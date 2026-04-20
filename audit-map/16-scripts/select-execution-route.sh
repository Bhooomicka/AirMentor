#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

usage() {
  echo "Usage: $0 <pass-name> [--requested-model <slug>] [--require-provider <native-codex|anthropic|antigravity|codex|google|github-copilot>] [--exclude-provider <provider>] [--exclude-slot <slot>]" >&2
  exit 64
}

slot_is_execution_ready() {
  local status_file="$1"
  local slot=""
  local provider=""
  local state=""
  local preferred_model=""
  local canonical_account_label=""
  local execution_verification_state=""
  local execution_model=""
  local execution_route_state=""
  local execution_last_probe_failure_class=""
  local usage_access_status=""
  local account_label=""
  local identity_hint=""
  local label_policy_state=""
  local min_rank="0"
  # shellcheck disable=SC1090
  source "$status_file"
  [ "${execution_verification_state:-}" = "verified" ] || return 1
  [ -n "${canonical_account_label:-}" ] || return 1
  [ -n "${execution_model:-}" ] || return 1
  if printf '%s' "${usage_access_status:-}" | grep -Eqi 'blocked|limit reached'; then
    return 1
  fi
  case "${execution_route_state:-}" in
    provider-rejected|quota-blocked|auth-or-entitlement|unexpected-output|failed|silent-provider-failure|below-model-floor)
      return 1
      ;;
  esac
  case "${execution_last_probe_failure_class:-}" in
    provider-rejected|quota-blocked|auth-or-entitlement|unexpected-output|transient-provider-failure)
      return 1
      ;;
  esac
  min_rank="$(minimum_execution_rank_for_provider "${provider:-}")"
  [ "$(model_rank_for_provider "${provider:-}" "${execution_model:-}")" -ge "$min_rank" ] || return 1
  cooldown_active_in_file "$status_file" && return 1
  return 0
}

native_model_supported() {
  local model="${1:-}"
  [ -n "$model" ] || return 1
  case "$model" in
    gpt-*) ;;
    *) return 1 ;;
  esac
  if [ -f "$HOME/.codex/models_cache.json" ]; then
    grep -q "\"slug\": \"$model\"" "$HOME/.codex/models_cache.json"
    return $?
  fi
  return 0
}

model_supported_for_provider() {
  local provider="${1:-}"
  local model="${2:-}"
  [ -n "$provider" ] || return 1
  [ -n "$model" ] || return 1
  case "$provider" in
    native-codex)
      native_model_supported "$model"
      ;;
    anthropic|antigravity|codex|google|github-copilot)
      [ "$(model_rank_for_provider "$provider" "$model")" -gt 0 ]
      ;;
    *)
      return 1
      ;;
  esac
}

model_rank_for_provider() {
  local provider="${1:-}"
  local model="${2:-}"
  provider_model_rank "$provider" "$model"
}

emit_sorted_provider_candidates() {
  local required_provider="${1:-}"
  local status_file=""
  local slot=""
  local provider=""
  local state=""
  local preferred_model=""
  local execution_model=""
  local account_label=""
  local identity_hint=""
  local execution_verification_state=""
  local label_policy_state=""
  local updated_at=""
  local last_selected_at=""
  local score=""
  local freshness=""
  local primary_remaining=""
  local secondary_remaining=""
  local provider_priority=""

  for status_file in "$AUDIT_STATUS_ROOT"/arctic-slot-*.status; do
    [ -f "$status_file" ] || continue
    unset slot provider state preferred_model account_label identity_hint execution_verification_state label_policy_state updated_at
    # shellcheck disable=SC1090
    source "$status_file"
    [ "${provider:-}" = "$required_provider" ] || continue
    [ -n "${exclude_slot:-}" ] && [ "${slot:-}" = "$exclude_slot" ] && continue
    [ -n "${exclude_provider:-}" ] && [ "${provider:-}" = "$exclude_provider" ] && continue
    slot_is_execution_ready "$status_file" || continue
    score="$(model_rank_for_provider "$provider" "$execution_model")"
    [ "${score:-0}" -gt 0 ] || continue
    freshness="${execution_last_checked_at:-${updated_at:-1970-01-01T00:00:00Z}}"
    last_selected_at="${route_last_selected_at:-1970-01-01T00:00:00Z}"
    primary_remaining="${usage_limit_primary_percent:-0}"
    secondary_remaining="${usage_limit_secondary_percent:-0}"
    case "$provider" in
      github-copilot) provider_priority="5" ;;
      antigravity) provider_priority="4" ;;
      anthropic) provider_priority="3" ;;
      codex) provider_priority="2" ;;
      google) provider_priority="1" ;;
      *) provider_priority="0" ;;
    esac
    printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
      "$provider_priority" \
      "$score" \
      "$primary_remaining" \
      "$secondary_remaining" \
      "$last_selected_at" \
      "$freshness" \
      "$slot" \
      "$provider" \
      "$execution_model" \
      "${account_label:-unknown}" \
      "${identity_hint:--}"
  done
}

pick_best_alternate_slot() {
  local current_cursor=""
  local candidate_count="0"
  local pick_index="0"
  local found_cursor="0"
  local candidate_line=""
  local provider_priority=""
  local score=""
  local primary_remaining=""
  local secondary_remaining=""
  local last_selected_at=""
  local freshness=""
  local slot=""
  local provider=""
  local execution_model=""
  local account_label=""
  local identity_hint=""
  local candidate_lines=()

  mapfile -t candidate_lines < <(
    {
      emit_sorted_provider_candidates github-copilot
      emit_sorted_provider_candidates antigravity
      emit_sorted_provider_candidates anthropic
      emit_sorted_provider_candidates codex
      emit_sorted_provider_candidates google
    } | sort -t $'\t' -k1,1nr -k2,2nr -k3,3nr -k4,4nr -k7,7
  )
  candidate_count="${#candidate_lines[@]}"
  [ "$candidate_count" -gt 0 ] || return 1

  current_cursor="$(read_rotation_cursor alternate-global 2>/dev/null || true)"
  if [ -n "$current_cursor" ] && [ "$candidate_count" -gt 1 ]; then
    for pick_index in "${!candidate_lines[@]}"; do
      IFS=$'\t' read -r provider_priority score primary_remaining secondary_remaining last_selected_at freshness slot provider execution_model account_label identity_hint <<<"${candidate_lines[$pick_index]}"
      if [ "$slot" = "$current_cursor" ]; then
        found_cursor="1"
        pick_index="$(( (pick_index + 1) % candidate_count ))"
        break
      fi
    done
  fi

  [ "$found_cursor" = "1" ] || pick_index="0"
  candidate_line="${candidate_lines[$pick_index]}"
  IFS=$'\t' read -r provider_priority score primary_remaining secondary_remaining last_selected_at freshness slot provider execution_model account_label identity_hint <<<"$candidate_line"

  printf 'selected_slot=%q\n' "$slot"
  printf 'selected_provider=%q\n' "$provider"
  printf 'selected_model=%q\n' "$execution_model"
  printf 'selected_account=%q\n' "$slot"
  printf 'selected_account_label=%q\n' "$account_label"
  printf 'selected_identity_hint=%q\n' "$identity_hint"
  printf 'selected_candidate_count=%q\n' "$candidate_count"
}

pick_slot_for_provider() {
  local required_provider="${1:-}"
  local current_cursor=""
  local candidate_count="0"
  local pick_index="0"
  local found_cursor="0"
  local candidate_line=""
  local provider_priority=""
  local score=""
  local primary_remaining=""
  local secondary_remaining=""
  local last_selected_at=""
  local freshness=""
  local slot=""
  local provider=""
  local preferred_model=""
  local account_label=""
  local identity_hint=""
  local candidate_lines=()

  mapfile -t candidate_lines < <(emit_sorted_provider_candidates "$required_provider" | sort -t $'\t' -k1,1nr -k2,2nr -k3,3nr -k4,4nr -k7,7)
  candidate_count="${#candidate_lines[@]}"
  [ "$candidate_count" -gt 0 ] || return 1

  current_cursor="$(read_rotation_cursor "$required_provider" 2>/dev/null || true)"
  if [ -n "$current_cursor" ] && [ "$candidate_count" -gt 1 ]; then
    for pick_index in "${!candidate_lines[@]}"; do
      IFS=$'\t' read -r provider_priority score primary_remaining secondary_remaining last_selected_at freshness slot provider preferred_model account_label identity_hint <<<"${candidate_lines[$pick_index]}"
      if [ "$slot" = "$current_cursor" ]; then
        found_cursor="1"
        pick_index="$(( (pick_index + 1) % candidate_count ))"
        break
      fi
    done
  fi

  [ "$found_cursor" = "1" ] || pick_index="0"
  candidate_line="${candidate_lines[$pick_index]}"
  IFS=$'\t' read -r provider_priority score primary_remaining secondary_remaining last_selected_at freshness slot provider preferred_model account_label identity_hint <<<"$candidate_line"

  printf 'selected_slot=%q\n' "$slot"
  printf 'selected_provider=%q\n' "$provider"
  printf 'selected_model=%q\n' "$preferred_model"
  printf 'selected_account=%q\n' "$slot"
  printf 'selected_account_label=%q\n' "$account_label"
  printf 'selected_identity_hint=%q\n' "$identity_hint"
  printf 'selected_candidate_count=%q\n' "$candidate_count"
}

pass_name="${1:-}"
[ -n "$pass_name" ] || usage
shift || true

requested_model=""
require_provider=""
slot_selection=""
exclude_provider=""
exclude_slot=""

while [ "$#" -gt 0 ]; do
  case "$1" in
    --requested-model) requested_model="${2:-}"; shift 2 ;;
    --require-provider) require_provider="${2:-}"; shift 2 ;;
    --exclude-provider) exclude_provider="${2:-}"; shift 2 ;;
    --exclude-slot) exclude_slot="${2:-}"; shift 2 ;;
    --help|-h) usage ;;
    *) usage ;;
  esac
done

# Pass-specific defaults requested by campaign policy.
# Explicit CLI flags still win because this block only applies when fields are empty.
if [ "$pass_name" = "gap-closure-deploy-audit-reconciliation-pass" ] && [ -z "$require_provider" ]; then
  require_provider="native-codex"
fi

if [ "$pass_name" = "ml-optimal-model-deep-tune-pass" ]; then
  if [ -z "$require_provider" ]; then
    require_provider="google"
  fi
  if [ -z "$requested_model" ]; then
    requested_model="gemini-3.1-pro-preview"
  fi
fi

eval "$("$SCRIPT_DIR/task-classify-route.sh" "$pass_name")"
eval "$("$SCRIPT_DIR/check-model-budget.sh" "$pass_name" "${requested_model:-}")"

selected_slot=""
selected_provider=""
selected_model="${model:-${requested_model:-$recommended_model}}"
selected_account=""
selected_account_label=""
selected_identity_hint=""
route_state="manual_required"
route_reason="No compatible route found."
selected_candidate_count="0"

native_ready="0"
native_excluded="0"
native_health_file="$(provider_health_file_for native-codex)"
native_cooldown_until=""
if [ -f "$native_health_file" ]; then
  native_cooldown_until="$(read_env_value "$native_health_file" cooldown_next_eligible_at 2>/dev/null || true)"
fi
if [ "$exclude_provider" = "native-codex" ] || [ "$exclude_slot" = "native-codex-session" ]; then
  native_excluded="1"
fi

if [ "$budget_state" != "stop" ] && [ "$native_excluded" != "1" ] && ! cooldown_active_in_file "$native_health_file"; then
  native_ready="1"
fi

if [ -n "$require_provider" ]; then
  case "$require_provider" in
    native-codex)
      if [ "$native_excluded" = "1" ]; then
        route_state="wait"
        selected_provider="native-codex"
        route_reason="Native Codex was explicitly excluded from this route attempt."
      elif [ "$native_ready" = "1" ]; then
        route_state="ready"
        selected_provider="native-codex"
        selected_account="native-codex-session"
        route_reason="Native Codex satisfies the requested provider."
        selected_candidate_count="1"
      elif cooldown_active_in_file "$native_health_file"; then
        route_state="wait"
        selected_provider="native-codex"
        route_reason="Native Codex is cooling down until ${native_cooldown_until:-an observed reset window}."
      else
        route_state="wait"
        selected_provider="native-codex"
        route_reason="$note"
      fi
      ;;
    anthropic|antigravity|codex|google|github-copilot)
      if [ "$provider_admission_policy" = "native-only" ]; then
        route_state="manual_required"
        route_reason="Pass '$pass_name' is policy-locked to native Codex for high-stakes work."
      elif slot_selection="$(pick_slot_for_provider "$require_provider" 2>/dev/null)"; then
        eval "$slot_selection"
        route_state="ready"
        route_reason="Verified Arctic slot is ready for provider '$require_provider'."
      elif [ "$pass_name" = "ml-optimal-model-deep-tune-pass" ] && [ "$allow_alt_providers" = "1" ] && [ -n "$exclude_slot" ]; then
        if slot_selection="$(pick_best_alternate_slot 2>/dev/null)"; then
          eval "$slot_selection"
          route_state="ready"
          route_reason="No execution-verified slot is ready for provider '$require_provider' after excluding slot '$exclude_slot'; using the highest-ranked verified alternate route."
        else
          route_state="wait"
          selected_provider="$require_provider"
          route_reason="No execution-verified Arctic slot is ready for provider '$require_provider', and no verified alternate provider is currently ready."
        fi
      else
        route_state="wait"
        selected_provider="$require_provider"
        route_reason="No execution-verified Arctic slot is ready for provider '$require_provider'."
      fi
      ;;
    *)
      route_state="manual_required"
      route_reason="Unknown required provider '$require_provider'."
      ;;
  esac
else
  if [ "$native_ready" = "1" ]; then
    route_state="ready"
    selected_provider="native-codex"
    selected_account="native-codex-session"
    route_reason="Native Codex is the default verified execution path."
    selected_candidate_count="1"
  elif [ "$allow_alt_providers" = "1" ]; then
    if slot_selection="$(pick_best_alternate_slot 2>/dev/null)"; then
      eval "$slot_selection"
      route_state="ready"
      if cooldown_active_in_file "$native_health_file"; then
        route_reason="Native Codex is cooling down until ${native_cooldown_until:-an observed reset window}; using the highest-ranked verified alternate route."
      else
        route_reason="Native Codex is unavailable; using the highest-ranked verified alternate route."
      fi
    else
      route_state="wait"
      if cooldown_active_in_file "$native_health_file"; then
        route_reason="Native Codex is cooling down until ${native_cooldown_until:-an observed reset window}, and no verified alternate provider is currently ready."
      else
        route_reason="No verified alternate provider is currently ready."
      fi
    fi
  else
    route_state="manual_required"
    route_reason="$note"
  fi
fi

if [ "$route_state" = "ready" ]; then
  requested_candidate="${requested_model:-}"
  provider_candidate="${selected_model:-$recommended_model}"
  if [ "${selected_provider:-}" = "native-codex" ]; then
    if [ -n "$requested_candidate" ] && model_supported_for_provider "${selected_provider:-}" "$requested_candidate"; then
      selected_model="$(provider_model_slug "${selected_provider:-}" "$requested_candidate")"
    elif [ -n "$provider_candidate" ] && model_supported_for_provider "${selected_provider:-}" "$provider_candidate"; then
      selected_model="$(provider_model_slug "${selected_provider:-}" "$provider_candidate")"
      if [ -n "$requested_candidate" ] && [ "$(provider_model_slug "${selected_provider:-}" "$requested_candidate")" != "$selected_model" ]; then
        route_reason="$route_reason Requested model '$requested_candidate' is not available on provider '${selected_provider:-unknown}', so the provider-preferred compatible model '$selected_model' was selected."
      fi
    else
      candidate_model="${requested_candidate:-$provider_candidate}"
      route_state="manual_required"
      route_reason="Requested model '$candidate_model' is not compatible with provider '${selected_provider:-unknown}'."
      selected_model=""
    fi
  elif [ -n "$provider_candidate" ] && model_supported_for_provider "${selected_provider:-}" "$provider_candidate"; then
    selected_model="$(provider_model_slug "${selected_provider:-}" "$provider_candidate")"
    if [ -n "$requested_candidate" ] && [ "$(provider_model_slug "${selected_provider:-}" "$requested_candidate")" != "$selected_model" ]; then
      route_reason="$route_reason Requested model '$requested_candidate' is compatible with provider '${selected_provider:-unknown}' but is not separately execution-verified on slot '${selected_slot:-unknown}', so the slot's execution-verified model '$selected_model' was selected."
    fi
  else
    candidate_model="${requested_candidate:-$provider_candidate}"
    route_state="manual_required"
    route_reason="Requested model '$candidate_model' is not compatible with provider '${selected_provider:-unknown}'."
    selected_model=""
  fi
fi

printf 'route_state=%q\n' "$route_state"
printf 'selected_provider=%q\n' "${selected_provider:-unknown}"
printf 'selected_slot=%q\n' "${selected_slot:-}"
printf 'selected_account=%q\n' "${selected_account:-unknown}"
printf 'selected_account_label=%q\n' "${selected_account_label:-}"
printf 'selected_identity_hint=%q\n' "${selected_identity_hint:-}"
printf 'selected_model=%q\n' "${selected_model:-}"
printf 'selected_candidate_count=%q\n' "${selected_candidate_count:-0}"
printf 'task_class=%q\n' "$task_class"
printf 'risk_class=%q\n' "$risk_class"
printf 'reasoning_effort=%q\n' "$reasoning_effort"
printf 'provider_admission_policy=%q\n' "$provider_admission_policy"
printf 'route_reason=%q\n' "$route_reason"
