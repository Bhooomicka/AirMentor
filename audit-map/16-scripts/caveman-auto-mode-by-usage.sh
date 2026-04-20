#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

usage() {
  cat >&2 <<'EOF'
Usage: caveman-auto-mode-by-usage.sh [--slot <slot>] [--dry-run]

Automatic Caveman mode ladder from quota usage percent:
  used <= 30.0   -> lite
  used <= 90.0   -> full
  used <= 93.3   -> wenyan-lite
  used <= 96.3   -> wenyan-full
  used >  96.3   -> wenyan-ultra

Selection policy:
  1) If --slot is set, use that slot.
  2) Else if overnight orchestrator has current_slot, use that.
  3) Else use highest usage (worst remaining) among all slots.
EOF
  exit 64
}

selected_slot=""
dry_run="0"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --slot)
      selected_slot="$(arctic_slot_slug "${2:-}")"
      shift 2
      ;;
    --dry-run)
      dry_run="1"
      shift
      ;;
    --help|-h)
      usage
      ;;
    *)
      usage
      ;;
  esac
done

ensure_audit_dirs

status_out_file="$(status_path_for caveman-auto-mode)"
orchestrator_status="$(status_path_for "$(session_name_for overnight night-run-orchestrator)")"

is_number() {
  local value="${1:-}"
  printf '%s' "$value" | rg -q '^[0-9]+(\.[0-9]+)?$'
}

used_from_remaining() {
  local remaining="${1:-}"
  awk "BEGIN { printf \"%.4f\", 100.0 - ($remaining + 0.0) }"
}

mode_for_used() {
  local used="${1:-0}"
  awk -v u="$used" 'BEGIN {
    if (u <= 30.0) { print "lite"; exit }
    if (u <= 90.0) { print "full"; exit }
    if (u <= 93.3) { print "wenyan-lite"; exit }
    if (u <= 96.3) { print "wenyan-full"; exit }
    print "wenyan-ultra"
  }'
}

current_caveman_mode() {
  read_env_value "$(caveman_state_file)" mode 2>/dev/null || true
}

pick_status_file() {
  local slot="${1:-}"
  local candidate=""
  if [ -n "$slot" ]; then
    candidate="$(status_path_for_slot "$slot")"
    [ -f "$candidate" ] && printf '%s\n' "$candidate" && return 0
    return 1
  fi

  if [ -f "$orchestrator_status" ]; then
    local orch_slot=""
    orch_slot="$(read_env_value "$orchestrator_status" current_slot 2>/dev/null || true)"
    if [ -n "$orch_slot" ]; then
      candidate="$(status_path_for_slot "$orch_slot")"
      if [ -f "$candidate" ]; then
        printf '%s\n' "$candidate"
        return 0
      fi
    fi
  fi

  local best_file=""
  local best_used="-1"
  local status_file=""
  local remaining=""
  local used=""

  for status_file in "$AUDIT_STATUS_ROOT"/arctic-slot-*.status; do
    [ -f "$status_file" ] || continue
    remaining="$(read_env_value "$status_file" usage_limit_primary_percent 2>/dev/null || true)"
    is_number "$remaining" || continue
    used="$(used_from_remaining "$remaining")"
    if awk "BEGIN { exit !($used > $best_used) }"; then
      best_used="$used"
      best_file="$status_file"
    fi
  done

  [ -n "$best_file" ] || return 1
  printf '%s\n' "$best_file"
}

selected_status_file="$(pick_status_file "$selected_slot" 2>/dev/null || true)"

if [ -z "$selected_status_file" ] || [ ! -f "$selected_status_file" ]; then
  write_env_file "$status_out_file" \
    state "no-usage-data" \
    selected_slot "" \
    selected_provider "" \
    selected_remaining_percent "" \
    selected_used_percent "" \
    selected_mode "" \
    current_mode "$(current_caveman_mode)" \
    dry_run "$dry_run" \
    updated_at "$(timestamp_utc)"
  echo "state=no-usage-data"
  exit 0
fi

slot_name="$(basename "$selected_status_file")"
slot_name="${slot_name#arctic-slot-}"
slot_name="${slot_name%.status}"
provider_name="$(read_env_value "$selected_status_file" provider 2>/dev/null || true)"
remaining_percent="$(read_env_value "$selected_status_file" usage_limit_primary_percent 2>/dev/null || true)"

if ! is_number "$remaining_percent"; then
  write_env_file "$status_out_file" \
    state "invalid-usage-data" \
    selected_slot "$slot_name" \
    selected_provider "$provider_name" \
    selected_remaining_percent "$remaining_percent" \
    selected_used_percent "" \
    selected_mode "" \
    current_mode "$(current_caveman_mode)" \
    dry_run "$dry_run" \
    updated_at "$(timestamp_utc)"
  echo "state=invalid-usage-data slot=$slot_name remaining=$remaining_percent"
  exit 0
fi

used_percent="$(used_from_remaining "$remaining_percent")"
target_mode="$(mode_for_used "$used_percent")"
current_mode="$(current_caveman_mode)"

applied="0"
if [ "$dry_run" != "1" ]; then
  if [ "$current_mode" != "$target_mode" ]; then
    bash "$SCRIPT_DIR/caveman-enable-everywhere.sh" "$target_mode" --no-strict >/dev/null
    applied="1"
    current_mode="$target_mode"
  fi
fi

write_env_file "$status_out_file" \
  state "ok" \
  selected_slot "$slot_name" \
  selected_provider "$provider_name" \
  selected_remaining_percent "$remaining_percent" \
  selected_used_percent "$used_percent" \
  selected_mode "$target_mode" \
  current_mode "$current_mode" \
  applied "$applied" \
  dry_run "$dry_run" \
  updated_at "$(timestamp_utc)"

printf 'state=ok\n'
printf 'selected_slot=%s\n' "$slot_name"
printf 'selected_provider=%s\n' "$provider_name"
printf 'remaining_percent=%s\n' "$remaining_percent"
printf 'used_percent=%s\n' "$used_percent"
printf 'target_mode=%s\n' "$target_mode"
printf 'current_mode=%s\n' "$current_mode"
printf 'applied=%s\n' "$applied"
