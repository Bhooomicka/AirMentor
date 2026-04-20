#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

# Cooldown-aware rotation monitor: runs in background and auto-rotates to free accounts
# when current provider/slot is in cooldown, then rotates back when cooldown expires

status_file="${AUDIT_COOLDOWN_MONITOR_STATUS:-$(status_path_for "$(session_name_for overnight cooldown-aware-rotation-monitor)")}"
interval_seconds="${AUDIT_COOLDOWN_MONITOR_INTERVAL:-60}"
orchestrator_status="${AUDIT_OVERNIGHT_ORCHESTRATOR_STATUS:-$(status_path_for "$(session_name_for overnight night-run-orchestrator)")}"

monitor_active() {
  [ -f "$orchestrator_status" ] || return 1
  state="$(read_env_value "$orchestrator_status" state 2>/dev/null || true)"
  [ "$state" = "running" ] || return 1
  return 0
}

get_current_provider() {
  [ -f "$orchestrator_status" ] || return 1
  provider="$(read_env_value "$orchestrator_status" current_provider 2>/dev/null || true)"
  slot="$(read_env_value "$orchestrator_status" current_slot 2>/dev/null || true)"
  [ -n "$provider" ] && printf '%s\n' "$provider"
}

check_provider_cooldown() {
  local provider="$1"
  local slot="${2:-}"
  local native_health_file=""
  local slot_status_file=""
  local provider_health_file=""
  
  if [ "$provider" = "native-codex" ]; then
    native_health_file="$(provider_health_file_for native-codex)"
    cooldown_active_in_file "$native_health_file"
    return $?
  else
    if [ -n "$slot" ]; then
      slot_status_file="$(status_path_for_slot "$slot")"
      cooldown_active_in_file "$slot_status_file"
      return $?
    fi
    provider_health_file="$(provider_health_file_for "$provider")"
    cooldown_active_in_file "$provider_health_file"
    return $?
  fi
  return 1
}

try_rotation() {
  local current_provider="$1"
  local current_slot="${2:-}"
  local reason="Cooldown detected on $current_provider${current_slot:+/$current_slot}"
  
  if ! rotation_output="$(bash "$SCRIPT_DIR/rotate-provider-or-stop.sh" \
    --pass "truth-drift-reconciliation-pass" \
    --reason "$reason" \
    --from-provider "$current_provider" \
    $([ -n "$current_slot" ] && echo "--from-slot $current_slot" || true) 2>&1)"; then
    return 1
  fi
  
  eval "$rotation_output"
  
  if [ "${rotation_state:-}" = "route-ready" ]; then
    printf '[%s] cooldown-rotation: %s -> %s (slot=%s, model=%s)\n' \
      "$(timestamp_utc)" \
      "$current_provider" \
      "$selected_provider" \
      "${selected_slot:-native}" \
      "$selected_model"
    
    upsert_env "$orchestrator_status" current_provider "$selected_provider"
    upsert_env "$orchestrator_status" current_slot "${selected_slot:-}"
    upsert_env "$orchestrator_status" current_account "$selected_account"
    upsert_env "$orchestrator_status" last_cooldown_rotation "$(timestamp_utc)"
    upsert_env "$orchestrator_status" updated_at "$(timestamp_utc)"
    return 0
  fi
  return 1
}

ensure_audit_dirs

# Initialize status
status_mark "$status_file" running
upsert_env "$status_file" started_at "$(read_env_value "$status_file" started_at 2>/dev/null || timestamp_utc)"
upsert_env "$status_file" last_check "$(timestamp_utc)"
upsert_env "$status_file" rotation_attempts "0"

while true; do
  sleep "$interval_seconds"
  
  if ! monitor_active; then
    break
  fi
  
  current_provider="$(get_current_provider)" || continue
  current_slot="$(read_env_value "$orchestrator_status" current_slot 2>/dev/null || true)"
  
  upsert_env "$status_file" last_check "$(timestamp_utc)"
  upsert_env "$status_file" monitoring_provider "$current_provider"
  upsert_env "$status_file" monitoring_slot "$current_slot"
  
  if check_provider_cooldown "$current_provider" "$current_slot"; then
    if try_rotation "$current_provider" "$current_slot"; then
      rotation_count="$(read_env_value "$status_file" rotation_attempts 2>/dev/null || echo 0)"
      upsert_env "$status_file" rotation_attempts "$((rotation_count + 1))"
      upsert_env "$status_file" last_rotation "$(timestamp_utc)"
    fi
  fi
done

status_mark "$status_file" completed
