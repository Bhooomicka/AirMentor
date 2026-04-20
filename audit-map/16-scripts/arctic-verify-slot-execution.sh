#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

usage() {
  echo "Usage: $0 --slot <slot> [--model <slug>] [--message <text>] [--format <json|default>] [--probe-best]" >&2
  exit 64
}

normalize_probe_output() {
  local raw_output="${1:-}"
  printf '%s\n' "$raw_output" \
    | sed -E 's/\x1B\[[0-9;]*[[:alpha:]]//g' \
    | tr -d '\r'
}

summarize_probe_error() {
  local clean_output="${1:-}"
  local filtered=""
  local summary=""

  filtered="$(printf '%s\n' "$clean_output" | sed -E 's/[[:space:]]*Working\.\.\.[[:space:]]*//g')"
  summary="$(printf '%s\n' "$filtered" | grep -Eo '"message":"[^"]+"' | head -n 1 | sed -E 's/^"message":"//; s/"$//' || true)"
  if [ -z "$summary" ]; then
    summary="$(printf '%s\n' "$filtered" \
      | grep -Eim1 'Error:|Provider not found|Status:[[:space:]]*[0-9]+|Verify your account|unauthorized|forbidden|quota|limit|Request failed|invalid_request_error|not_found_error|model: |claude\.ai/settings/usage|extra usage' \
      || true)"
  fi
  if [ -z "$summary" ]; then
    summary="$(printf '%s\n' "$filtered" | awk 'NF > 0 { print; exit }')"
  fi
  summary="$(printf '%s\n' "$summary" | LC_ALL=C tr -cd '\11\12\15\40-\176')"
  summary="$(printf '%s\n' "$summary" | sed 's/\\"/"/g')"
  summary="$(printf '%s\n' "$summary" | tr '\n' ' ' | sed 's/  */ /g')"
  summary="${summary# }"
  printf '%s' "${summary:0:220}"
}

extract_provider_org_id() {
  local clean_output="${1:-}"
  local normalized=""
  normalized="$(printf '%s\n' "$clean_output" | sed 's/\\"/"/g')"
  printf '%s\n' "$normalized" \
    | grep -Eo 'anthropic-organization-id":"[a-zA-Z0-9-]+"|anthropic-organization-id:[a-zA-Z0-9-]+' \
    | head -n 1 \
    | sed -E 's/^anthropic-organization-id":"//; s/"$//; s/^anthropic-organization-id://' \
    || true
}

extract_provider_overage_reason() {
  local clean_output="${1:-}"
  local normalized=""
  normalized="$(printf '%s\n' "$clean_output" | sed 's/\\"/"/g')"
  printf '%s\n' "$normalized" \
    | grep -Eo 'anthropic-ratelimit-unified-overage-disabled-reason":"[a-zA-Z0-9_-]+"|anthropic-ratelimit-unified-overage-disabled-reason:[a-zA-Z0-9_-]+' \
    | head -n 1 \
    | sed -E 's/^anthropic-ratelimit-unified-overage-disabled-reason":"//; s/"$//; s/^anthropic-ratelimit-unified-overage-disabled-reason://' \
    || true
}

classify_probe_failure() {
  local exit_code="${1:-1}"
  local clean_output="${2:-}"
  if [ "$exit_code" -eq 0 ]; then
    if [ -z "$clean_output" ]; then
      printf 'exit-clean-no-output'
    else
      printf 'unexpected-output'
    fi
    return 0
  fi
  if printf '%s\n' "$clean_output" | grep -Eqi 'provider not found|unknown provider'; then
    printf 'provider-unavailable'
  elif printf '%s\n' "$clean_output" | grep -Eqi 'claude\.ai/settings/usage|extra usage|usage[^[:alnum:]]+limit|limit reached|try again at|rate limit|quota'; then
    printf 'quota-blocked'
  elif printf '%s\n' "$clean_output" | grep -Eqi 'usage limit|limit reached|try again at|rate limit|quota'; then
    printf 'quota-blocked'
  elif printf '%s\n' "$clean_output" | grep -Eqi 'verify your account to continue|permission denied on resource project|permission denied|not authorized|entitlement|subscription|not included with this plan|unauthorized|forbidden|401|403|auth'; then
    printf 'auth-or-entitlement'
  elif printf '%s\n' "$clean_output" | grep -Eqi 'statusCode":40[04]|"status":40[04]|invalid_request_error|not_found_error|model: '; then
    printf 'provider-rejected'
  elif [ "$exit_code" -eq 124 ]; then
    printf 'timed-out'
  else
    printf 'failed'
  fi
}

slot=""
model=""
message=""
format="json"
probe_best="0"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --slot) slot="${2:-}"; shift 2 ;;
    --model) model="${2:-}"; shift 2 ;;
    --message) message="${2:-}"; shift 2 ;;
    --format) format="${2:-json}"; shift 2 ;;
    --probe-best) probe_best="1"; shift ;;
    --help|-h) usage ;;
    *) usage ;;
  esac
done

[ -n "$slot" ] || usage
bash "$SCRIPT_DIR/arctic-login-check.sh" --slot "$slot" >/dev/null

status_file="$(status_path_for_slot "$slot")"
[ -f "$status_file" ] || { echo "Missing status file for slot '$slot'." >&2; exit 66; }

prior_execution_verification_state="$(read_env_value "$status_file" execution_verification_state 2>/dev/null || true)"
prior_execution_model="$(read_env_value "$status_file" execution_model 2>/dev/null || true)"
prior_execution_model_ref="$(read_env_value "$status_file" execution_model_ref 2>/dev/null || true)"
prior_execution_provider_org_id="$(read_env_value "$status_file" execution_provider_org_id 2>/dev/null || true)"
prior_execution_provider_overage_reason="$(read_env_value "$status_file" execution_provider_overage_reason 2>/dev/null || true)"
prior_execution_model_rank="0"
provider="$(read_env_value "$status_file" provider 2>/dev/null || provider_for_slot "$slot" 2>/dev/null || true)"
[ -n "$provider" ] || { echo "Unable to determine provider for slot '$slot'." >&2; exit 67; }

message_template="$message"
last_probe_model=""
last_probe_model_ref=""
last_probe_state="failed"
last_probe_failure_class=""
last_probe_error_summary=""
last_probe_snapshot=""
last_probe_exit_code="1"
last_expected_marker=""
execution_verification_state="failed"
stored_execution_model=""
stored_execution_model_ref=""
probe_model_rank="0"
provider_unavailable="0"
diagnostic_probe_model=""
diagnostic_probe_model_ref=""
diagnostic_probe_failure_class=""
diagnostic_probe_error_summary=""
diagnostic_probe_snapshot=""
diagnostic_probe_exit_code=""

if [ -n "$prior_execution_model" ]; then
  prior_execution_model_rank="$(provider_model_rank "$provider" "$prior_execution_model")"
fi

set +e
provider_models_output="$(run_arctic_for_slot "$slot" models "$provider" 2>&1)"
provider_models_rc="$?"
set -e
provider_models_clean="$(normalize_probe_output "$provider_models_output")"
if printf '%s\n' "$provider_models_clean" | grep -Eqi 'Provider not found|unknown provider'; then
  provider_unavailable="1"
  snapshot_dir="$(account_snapshot_dir_for_slot "$slot")"
  mkdir -p "$snapshot_dir"
  last_probe_snapshot="$snapshot_dir/provider-models-$(compact_timestamp).txt"
  printf '%s\n' "$provider_models_output" >"$last_probe_snapshot"
  last_probe_exit_code="$provider_models_rc"
  last_probe_state="provider-unavailable"
  last_probe_failure_class="provider-unavailable"
  last_probe_error_summary="$(summarize_probe_error "$provider_models_clean")"
  execution_verification_state="failed"
fi

if [ -z "$model" ]; then
  probe_best="1"
fi

if [ "$provider_unavailable" != "1" ]; then
  candidate_models=()
  if [ "$probe_best" = "1" ]; then
    preferred_model_ref="$(read_env_value "$status_file" preferred_model_ref 2>/dev/null || true)"
    preferred_model="$(read_env_value "$status_file" preferred_model 2>/dev/null || true)"
    for raw_model in "$model" "$preferred_model_ref" "$preferred_model"; do
      [ -n "$raw_model" ] || continue
      candidate_models+=("$(provider_model_slug "$provider" "$raw_model")")
    done
    while IFS= read -r candidate; do
      [ -n "$candidate" ] || continue
      candidate_models+=("$(provider_model_slug "$provider" "$candidate")")
    done < <(provider_execution_probe_candidates "$provider" 2>/dev/null || true)
  else
    [ -n "$model" ] || { echo "No model specified for slot '$slot'." >&2; exit 67; }
    candidate_models+=("$(provider_model_slug "$provider" "$model")")
  fi

  deduped_candidates=()
  seen_candidates=""
  for candidate_model in "${candidate_models[@]}"; do
    [ -n "$candidate_model" ] || continue
    case " $seen_candidates " in
      *" $candidate_model "*) continue ;;
    esac
    seen_candidates="$seen_candidates $candidate_model"
    deduped_candidates+=("$candidate_model")
  done
  [ "${#deduped_candidates[@]}" -gt 0 ] || { echo "No candidate probe models available for slot '$slot'." >&2; exit 67; }

  for candidate_model in "${deduped_candidates[@]}"; do
    candidate_model_ref="$(provider_model_ref "$provider" "$candidate_model")"
    last_expected_marker="execution-ok slot=$slot model=$candidate_model"
    candidate_message="${message_template:-Reply with exactly: $last_expected_marker}"
    snapshot_dir="$(account_snapshot_dir_for_slot "$slot")"
    mkdir -p "$snapshot_dir"
    last_probe_snapshot="$snapshot_dir/execution-smoke-$(compact_timestamp).txt"

    set +e
    output="$(run_arctic_for_slot "$slot" run --format "$format" --model "$candidate_model_ref" "$candidate_message" 2>&1)"
    last_probe_exit_code="$?"
    set -e

    printf '%s\n' "$output" >"$last_probe_snapshot"
    clean_output="$(normalize_probe_output "$output")"
    last_probe_model="$candidate_model"
    last_probe_model_ref="$candidate_model_ref"
    last_probe_error_summary=""

    if [ "$last_probe_exit_code" -eq 0 ] && printf '%s\n' "$clean_output" | grep -Fq "$last_expected_marker"; then
      last_probe_state="verified"
      last_probe_failure_class=""
      execution_verification_state="verified"
      stored_execution_model="$candidate_model"
      stored_execution_model_ref="$candidate_model_ref"
      probe_model_rank="$(provider_model_rank "$provider" "$candidate_model")"
      break
    fi

    last_probe_failure_class="$(classify_probe_failure "$last_probe_exit_code" "$clean_output")"
    last_probe_state="$last_probe_failure_class"
    last_probe_error_summary="$(summarize_probe_error "$clean_output")"

    if [ -z "$diagnostic_probe_failure_class" ]; then
      case "$last_probe_failure_class" in
        unexpected-output|exit-clean-no-output)
          ;;
        *)
          diagnostic_probe_model="$candidate_model"
          diagnostic_probe_model_ref="$candidate_model_ref"
          diagnostic_probe_failure_class="$last_probe_failure_class"
          diagnostic_probe_error_summary="$last_probe_error_summary"
          diagnostic_probe_snapshot="$last_probe_snapshot"
          diagnostic_probe_exit_code="$last_probe_exit_code"
          ;;
      esac
    fi
  done
fi

if [ "$execution_verification_state" != "verified" ] && [ -n "$diagnostic_probe_failure_class" ]; then
  use_diagnostic_failure="0"

  case "$last_probe_failure_class" in
    unexpected-output|exit-clean-no-output|'')
      use_diagnostic_failure="1"
      ;;
  esac

  if [ "$use_diagnostic_failure" = "0" ]; then
    case "$diagnostic_probe_failure_class" in
      provider-unavailable|quota-blocked|auth-or-entitlement)
        case "$last_probe_failure_class" in
          provider-rejected|failed|unexpected-output|exit-clean-no-output|'')
            use_diagnostic_failure="1"
            ;;
        esac
        ;;
    esac
  fi

  if [ "$use_diagnostic_failure" = "1" ]; then
    last_probe_model="$diagnostic_probe_model"
    last_probe_model_ref="$diagnostic_probe_model_ref"
    last_probe_failure_class="$diagnostic_probe_failure_class"
    last_probe_error_summary="$diagnostic_probe_error_summary"
    last_probe_snapshot="$diagnostic_probe_snapshot"
    last_probe_exit_code="$diagnostic_probe_exit_code"
    last_probe_state="$diagnostic_probe_failure_class"
  fi
fi

if [ "$execution_verification_state" = "verified" ] && [ "$prior_execution_verification_state" = "verified" ] && [ "$prior_execution_model_rank" -gt "$probe_model_rank" ]; then
  stored_execution_model="$prior_execution_model"
  stored_execution_model_ref="$prior_execution_model_ref"
fi

if [ "$execution_verification_state" != "verified" ] && [ "$prior_execution_verification_state" = "verified" ] && [ -n "$prior_execution_model" ]; then
  execution_verification_state="verified"
  stored_execution_model="$prior_execution_model"
  stored_execution_model_ref="$prior_execution_model_ref"
fi

last_probe_provider_org_id=""
last_probe_provider_overage_reason=""
last_probe_provider_identity=""
if [ -n "$last_probe_snapshot" ] && [ -f "$last_probe_snapshot" ]; then
  probe_snapshot_clean="$(normalize_probe_output "$(cat "$last_probe_snapshot" 2>/dev/null || true)")"
  last_probe_provider_org_id="$(extract_provider_org_id "$probe_snapshot_clean")"
  last_probe_provider_overage_reason="$(extract_provider_overage_reason "$probe_snapshot_clean")"
fi
[ -n "$last_probe_provider_org_id" ] || last_probe_provider_org_id="$prior_execution_provider_org_id"
[ -n "$last_probe_provider_overage_reason" ] || last_probe_provider_overage_reason="$prior_execution_provider_overage_reason"
if [ "$provider" = "anthropic" ] && [ -n "$last_probe_provider_org_id" ]; then
  last_probe_provider_identity="anthropic-org-$last_probe_provider_org_id"
fi

upsert_env "$status_file" execution_verification_state "$execution_verification_state"
upsert_env "$status_file" execution_snapshot_file "$last_probe_snapshot"
upsert_env "$status_file" execution_model "$stored_execution_model"
upsert_env "$status_file" execution_model_ref "$stored_execution_model_ref"
upsert_env "$status_file" execution_exit_code "$last_probe_exit_code"
upsert_env "$status_file" execution_last_error_summary "$last_probe_error_summary"
upsert_env "$status_file" execution_last_probe_model "$last_probe_model"
upsert_env "$status_file" execution_last_probe_model_ref "$last_probe_model_ref"
upsert_env "$status_file" execution_last_probe_state "$last_probe_state"
upsert_env "$status_file" execution_last_probe_failure_class "$last_probe_failure_class"
upsert_env "$status_file" execution_provider_org_id "$last_probe_provider_org_id"
upsert_env "$status_file" execution_provider_overage_reason "$last_probe_provider_overage_reason"
upsert_env "$status_file" execution_provider_identity "$last_probe_provider_identity"
upsert_env "$status_file" execution_last_checked_at "$(timestamp_utc)"
upsert_env "$status_file" updated_at "$(timestamp_utc)"
update_slot_execution_route_state "$status_file"

printf 'slot=%s\n' "$slot"
printf 'model=%s\n' "$stored_execution_model"
printf 'model_ref=%s\n' "$stored_execution_model_ref"
printf 'execution_verification_state=%s\n' "$execution_verification_state"
printf 'execution_snapshot_file=%s\n' "$last_probe_snapshot"
printf 'execution_exit_code=%s\n' "$last_probe_exit_code"
printf 'execution_last_error_summary=%s\n' "${last_probe_error_summary:-none}"
printf 'execution_last_probe_failure_class=%s\n' "${last_probe_failure_class:-none}"
printf 'execution_provider_org_id=%s\n' "${last_probe_provider_org_id:-unknown}"
printf 'execution_provider_overage_reason=%s\n' "${last_probe_provider_overage_reason:-unknown}"
printf 'execution_provider_identity=%s\n' "${last_probe_provider_identity:-unknown}"
printf 'expected_marker=%s\n' "$last_expected_marker"
