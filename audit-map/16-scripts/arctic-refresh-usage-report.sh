#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

usage() {
  cat >&2 <<'EOF'
Usage: arctic-refresh-usage-report.sh [--slot <slot>] [--skip-refresh]

Refresh slot-local Arctic usage telemetry and regenerate
`audit-map/25-accounts-routing/usage-status.md`.
EOF
  exit 64
}

skip_refresh="0"
requested_slots=()

while [ "$#" -gt 0 ]; do
  case "$1" in
    --slot) requested_slots+=("$(arctic_slot_slug "${2:-}")"); shift 2 ;;
    --skip-refresh) skip_refresh="1"; shift ;;
    --help|-h) usage ;;
    *) usage ;;
  esac
done

ensure_audit_dirs

native_health_file="$(provider_health_file_for native-codex)"
report_file="$AUDIT_ACCOUNT_ROOT/usage-status.md"
auto_caveman_status_file="$(status_path_for caveman-auto-mode)"

infer_native_cooldown_from_logs() {
  local candidate_file=""
  local hint=""
  local hint_time=""
  local candidate_local=""
  local candidate_epoch=""
  local now_epoch=""
  local candidate_utc=""

  while IFS= read -r candidate_file; do
    hint="$(grep -Eo 'try again at [0-9]{1,2}:[0-9]{2} [AP]M' "$candidate_file" 2>/dev/null | tail -n 1 || true)"
    [ -n "$hint" ] && break
  done < <(find "$AUDIT_LOG_ROOT" -type f \( -name '*.log' -o -name '*.log.*' \) -printf '%T@ %p\n' | sort -nr | awk '{ $1=""; sub(/^ /, ""); print }')

  if [ -z "$hint" ]; then
    if cooldown_active_in_file "$native_health_file"; then
      :
    else
      clear_cooldown_in_file "$native_health_file"
    fi
    return 0
  fi

  hint_time="${hint#try again at }"
  candidate_local="$(date -d "$(date +%F) ${hint_time}" '+%Y-%m-%d %H:%M:%S %z' 2>/dev/null || true)"
  [ -n "$candidate_local" ] || return 0
  candidate_epoch="$(date -d "$candidate_local" +%s 2>/dev/null || true)"
  [ -n "$candidate_epoch" ] || return 0
  now_epoch="$(date +%s)"
  if [ "$candidate_epoch" -le "$now_epoch" ]; then
    clear_cooldown_in_file "$native_health_file"
    return 0
  fi
  [ -n "$candidate_epoch" ] || return 0
  candidate_utc="$(date -u -d "@$candidate_epoch" '+%Y-%m-%dT%H:%M:%SZ')"
  set_cooldown_in_file "$native_health_file" "cooling-down" "Observed native Codex usage-limit reset hint: $hint_time." "$candidate_utc" "native-log-hint"
}

collect_slots() {
  local status_file=""
  local slot=""

  if [ "${#requested_slots[@]}" -gt 0 ]; then
    printf '%s\n' "${requested_slots[@]}" | sort -u
    return 0
  fi

  if list_slots_from_map >/dev/null 2>&1; then
    list_slots_from_map | sort -u
    return 0
  fi

  for status_file in "$AUDIT_STATUS_ROOT"/arctic-slot-*.status; do
    [ -f "$status_file" ] || continue
    slot="$(basename "$status_file")"
    slot="${slot#arctic-slot-}"
    slot="${slot%.status}"
    printf '%s\n' "$slot"
  done | sort -u
}

render_report() {
  local status_file=""
  local slot=""
  local provider=""
  local account_label=""
  local preferred_model=""
  local execution_model=""
  local execution_verification_state=""
  local execution_route_state=""
  local execution_last_probe_failure_class=""
  local usage_total_tokens=""
  local usage_total_cost=""
  local usage_access_status=""
  local usage_limit_primary_percent=""
  local usage_limit_primary_reset_at=""
  local usage_limit_secondary_percent=""
  local usage_limit_secondary_reset_at=""
  local cooldown_state=""
  local cooldown_next_eligible_at=""
  local native_state=""
  local native_reason=""
  local native_reset_at=""
  local auto_state=""
  local auto_slot=""
  local auto_provider=""
  local auto_remaining=""
  local auto_used=""
  local auto_target_mode=""
  local auto_current_mode=""
  local auto_applied=""

  native_state="$(read_env_value "$native_health_file" cooldown_state 2>/dev/null || true)"
  native_reason="$(read_env_value "$native_health_file" cooldown_reason 2>/dev/null || true)"
  native_reset_at="$(read_env_value "$native_health_file" cooldown_next_eligible_at 2>/dev/null || true)"
  auto_state="$(read_env_value "$auto_caveman_status_file" state 2>/dev/null || true)"
  auto_slot="$(read_env_value "$auto_caveman_status_file" selected_slot 2>/dev/null || true)"
  auto_provider="$(read_env_value "$auto_caveman_status_file" selected_provider 2>/dev/null || true)"
  auto_remaining="$(read_env_value "$auto_caveman_status_file" selected_remaining_percent 2>/dev/null || true)"
  auto_used="$(read_env_value "$auto_caveman_status_file" selected_used_percent 2>/dev/null || true)"
  auto_target_mode="$(read_env_value "$auto_caveman_status_file" selected_mode 2>/dev/null || true)"
  auto_current_mode="$(read_env_value "$auto_caveman_status_file" current_mode 2>/dev/null || true)"
  auto_applied="$(read_env_value "$auto_caveman_status_file" applied 2>/dev/null || true)"

  {
    printf '# Usage Status\n\n'
    printf 'Generated: %s\n\n' "$(timestamp_utc)"
    printf '## Native Codex Route Health\n\n'
    printf -- '- cooldown state: `%s`\n' "${native_state:-unknown}"
    printf -- '- next eligible at: `%s`\n' "${native_reset_at:-unknown}"
    printf -- '- reason: %s\n\n' "${native_reason:-none}"
    printf '## Auto Caveman Mode\n\n'
    printf -- '- state: `%s`\n' "${auto_state:-unknown}"
    printf -- '- selected slot/provider: `%s` / `%s`\n' "${auto_slot:-none}" "${auto_provider:-none}"
    printf -- '- selected usage: used=`%s%%`, remaining=`%s%%`\n' "${auto_used:-unknown}" "${auto_remaining:-unknown}"
    printf -- '- target mode: `%s`\n' "${auto_target_mode:-unknown}"
    printf -- '- current mode: `%s` (applied=`%s`)\n\n' "${auto_current_mode:-unknown}" "${auto_applied:-0}"
    printf '## Arctic Slot Usage\n\n'
    printf '| Slot | Provider | Account | Preferred model | Execution model | Route state | Exec state | Last probe failure | Access | Primary remaining %% | Primary reset | Secondary remaining %% | Secondary reset | Tokens | Cost | Cooldown |\n'
    printf '| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |\n'

    while IFS= read -r slot; do
      status_file="$(status_path_for_slot "$slot")"
      [ -f "$status_file" ] || continue
      provider="$(read_env_value "$status_file" provider 2>/dev/null || true)"
      account_label="$(read_env_value "$status_file" account_label 2>/dev/null || true)"
      preferred_model="$(read_env_value "$status_file" preferred_model 2>/dev/null || true)"
      execution_model="$(read_env_value "$status_file" execution_model 2>/dev/null || true)"
      execution_verification_state="$(read_env_value "$status_file" execution_verification_state 2>/dev/null || true)"
      execution_route_state="$(read_env_value "$status_file" execution_route_state 2>/dev/null || true)"
      execution_last_probe_failure_class="$(read_env_value "$status_file" execution_last_probe_failure_class 2>/dev/null || true)"
      usage_total_tokens="$(read_env_value "$status_file" usage_total_tokens 2>/dev/null || true)"
      usage_total_cost="$(read_env_value "$status_file" usage_total_cost 2>/dev/null || true)"
      usage_access_status="$(read_env_value "$status_file" usage_access_status 2>/dev/null || true)"
      usage_limit_primary_percent="$(read_env_value "$status_file" usage_limit_primary_percent 2>/dev/null || true)"
      usage_limit_primary_reset_at="$(read_env_value "$status_file" usage_limit_primary_reset_at 2>/dev/null || true)"
      usage_limit_secondary_percent="$(read_env_value "$status_file" usage_limit_secondary_percent 2>/dev/null || true)"
      usage_limit_secondary_reset_at="$(read_env_value "$status_file" usage_limit_secondary_reset_at 2>/dev/null || true)"
      cooldown_state="$(read_env_value "$status_file" cooldown_state 2>/dev/null || true)"
      cooldown_next_eligible_at="$(read_env_value "$status_file" cooldown_next_eligible_at 2>/dev/null || true)"
      printf '| `%s` | `%s` | `%s` | `%s` | `%s` | `%s` | `%s` | `%s` | `%s` | `%s` | `%s` | `%s` | `%s` | `%s` | `%s` | `%s %s` |\n' \
        "$slot" \
        "${provider:-unknown}" \
        "${account_label:-unknown}" \
        "${preferred_model:-}" \
        "${execution_model:-}" \
        "${execution_route_state:-}" \
        "${execution_verification_state:-}" \
        "${execution_last_probe_failure_class:-}" \
        "${usage_access_status:-unknown}" \
        "${usage_limit_primary_percent:-}" \
        "${usage_limit_primary_reset_at:-}" \
        "${usage_limit_secondary_percent:-}" \
        "${usage_limit_secondary_reset_at:-}" \
        "${usage_total_tokens:-}" \
        "${usage_total_cost:-}" \
        "${cooldown_state:-unknown}" \
        "${cooldown_next_eligible_at:-}"
    done < <(collect_slots)
  } >"$report_file"
}

infer_native_cooldown_from_logs

if [ "$skip_refresh" != "1" ]; then
  while IFS= read -r slot; do
    [ -n "$slot" ] || continue
    bash "$SCRIPT_DIR/arctic-slot-usage.sh" --slot "$slot" </dev/null
  done < <(collect_slots)
fi

reverify_args=()
for slot in "${requested_slots[@]}"; do
  reverify_args+=(--slot "$slot")
done
bash "$SCRIPT_DIR/arctic-reverify-ready-slots.sh" "${reverify_args[@]}" >/dev/null 2>&1 || true

if [ "${AUDIT_AUTO_CAVEMAN_MODE:-1}" = "1" ]; then
  bash "$SCRIPT_DIR/caveman-auto-mode-by-usage.sh" >/dev/null 2>&1 || true
fi

render_report
python3 "$SCRIPT_DIR/operator-dashboard.py" --write-only >/dev/null 2>&1 || true
printf 'report=%s\n' "$report_file"
