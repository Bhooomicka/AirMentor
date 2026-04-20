#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

usage() {
  echo "Usage: $0 --slot <slot> [provider] [--refresh] [--verbose]" >&2
  exit 64
}

preferred_model_for_output() {
  local provider="${1:-}"
  local output="${2:-}"
  local available_models
  local candidate
  available_models="$(printf '%s\n' "$output" \
    | sed -E 's/\x1B\[[0-9;]*[[:alpha:]]//g' \
    | awk -F/ '/^[a-z0-9-]+\// { print $2 }')"
  case "$provider" in
    anthropic)
      for candidate in claude-opus-4.6 claude-opus-4.5 claude-opus-4-5-thinking claude-sonnet-4.6 claude-sonnet-4.5 claude-sonnet-4-5-thinking claude-3.7-sonnet; do
        if printf '%s\n' "$available_models" | grep -Fxq "$candidate"; then
          printf '%s' "$candidate"
          return 0
        fi
      done
      ;;
    antigravity)
      for candidate in gemini-3-flash gemini-3.1-pro-preview gemini-3.1-pro-preview-customtools gemini-3-pro-preview gpt-5.4 gpt-5.4-mini gpt-5.3-codex claude-opus-4-5-thinking claude-sonnet-4-5 claude-sonnet-4-5-thinking gemini-3-pro-high gemini-3-pro-low; do
        if printf '%s\n' "$available_models" | grep -Fxq "$candidate"; then
          printf '%s' "$candidate"
          return 0
        fi
      done
      ;;
    codex)
      for candidate in gpt-5.4 gpt-5.4-mini gpt-5.3-codex gpt-5.2; do
        if printf '%s\n' "$available_models" | grep -Fxq "$candidate"; then
          printf '%s' "$candidate"
          return 0
        fi
      done
      ;;
    google)
      for candidate in gemini-3.1-pro-preview gemini-3.1-pro-preview-customtools gemini-3-pro-preview gemini-2.5-pro gemini-2.5-pro-preview-06-05 gemini-2.5-pro-preview-05-06; do
        if printf '%s\n' "$available_models" | grep -Fxq "$candidate"; then
          printf '%s' "$candidate"
          return 0
        fi
      done
      ;;
    github-copilot)
      for candidate in gpt-5.4 claude-opus-4.6 claude-opus-4.5 gpt-5.4-mini gpt-5.3-codex gemini-3.1-pro-preview gemini-3-pro-preview gemini-2.5-pro claude-sonnet-4.6 claude-sonnet-4.5; do
        if printf '%s\n' "$available_models" | grep -Fxq "$candidate"; then
          printf '%s' "$candidate"
          return 0
        fi
      done
      ;;
  esac
  return 1
}

slot=""
refresh="0"
verbose="0"
provider=""

while [ "$#" -gt 0 ]; do
  case "$1" in
    --slot) slot="${2:-}"; shift 2 ;;
    --refresh) refresh="1"; shift ;;
    --verbose) verbose="1"; shift ;;
    --help|-h) usage ;;
    *)
      if [ -z "$provider" ]; then
        provider="$1"
        shift
      else
        usage
      fi
      ;;
  esac
done

[ -n "$slot" ] || usage
bash "$SCRIPT_DIR/arctic-login-check.sh" --slot "$slot" >/dev/null
[ -n "$provider" ] || provider="$(provider_for_slot "$slot" 2>/dev/null || true)"

args=(models)
[ -n "$provider" ] && args+=("$provider")
[ "$refresh" = "1" ] && args+=(--refresh)
[ "$verbose" = "1" ] && args+=(--verbose)

models_output="$(run_arctic_for_slot "$slot" "${args[@]}" 2>&1)"
snapshot_dir="$(account_snapshot_dir_for_slot "$slot")"
mkdir -p "$snapshot_dir"
snapshot_file="$snapshot_dir/models-${provider:-all}-$(compact_timestamp).txt"
printf '%s\n' "$models_output" >"$snapshot_file"

status_file="$(status_path_for_slot "$slot")"
preferred_model="$(preferred_model_for_output "$provider" "$models_output" || true)"
policy_state="manual-review"
[ -n "$preferred_model" ] && policy_state="preferred-model-visible"
clean_models_output="$(printf '%s\n' "$models_output" | sed -E 's/\x1B\[[0-9;]*[[:alpha:]]//g' | tr -d '\r')"
if printf '%s\n' "$clean_models_output" | grep -Eqi 'Provider not found|unknown provider'; then
  policy_state="provider-unavailable"
fi

if [ -f "$status_file" ]; then
  upsert_env "$status_file" preferred_model "${preferred_model:-}"
  upsert_env "$status_file" preferred_model_ref "$(provider_model_ref "$provider" "${preferred_model:-}")"
  upsert_env "$status_file" models_snapshot_file "$snapshot_file"
  upsert_env "$status_file" model_policy_state "$policy_state"
  if [ "$policy_state" = "provider-unavailable" ]; then
    upsert_env "$status_file" execution_verification_state "failed"
    upsert_env "$status_file" execution_last_probe_failure_class "provider-unavailable"
    upsert_env "$status_file" execution_last_error_summary "Provider not found in current Arctic build"
    update_slot_execution_route_state "$status_file"
  fi
  upsert_env "$status_file" updated_at "$(timestamp_utc)"
  if [ -n "$preferred_model" ]; then
    upsert_env "$status_file" state "models-verified"
  fi
fi

printf 'slot=%s\n' "$slot"
printf 'provider=%s\n' "${provider:-all}"
printf 'models_snapshot=%s\n' "$snapshot_file"
printf 'preferred_model=%s\n' "${preferred_model:-none-found}"
printf 'model_policy_state=%s\n\n' "$policy_state"
printf '%s\n' "$models_output"
