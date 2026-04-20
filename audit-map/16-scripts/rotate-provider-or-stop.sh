#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

usage() {
  echo "Usage: $0 [--pass <name>] [--reason <text>] [--from-provider <provider>] [--from-slot <slot>]" >&2
  exit 64
}

reason="Provider rotation requested"
pass_name="${ROTATION_PASS_NAME:-account-routing-pass}"
from_provider="${ROTATION_FROM_PROVIDER:-}"
from_slot="${ROTATION_FROM_SLOT:-}"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --pass) pass_name="${2:-}"; shift 2 ;;
    --reason) reason="${2:-}"; shift 2 ;;
    --from-provider) from_provider="${2:-}"; shift 2 ;;
    --from-slot) from_slot="${2:-}"; shift 2 ;;
    --help|-h) usage ;;
    *) usage ;;
  esac
done

route_args=(bash "$SCRIPT_DIR/select-execution-route.sh" "$pass_name")
[ -n "$from_slot" ] && route_args+=(--exclude-slot "$from_slot")
[ -z "$from_slot" ] && [ -n "$from_provider" ] && route_args+=(--exclude-provider "$from_provider")

eval "$("${route_args[@]}")"

from_context="${from_provider:-unknown}:${from_slot:-unknown}"
to_context="${selected_provider:-unknown}:${selected_slot:-${selected_account:-unknown}}"

case "$route_state" in
  ready)
    append_switch_history "$from_context" "$to_context" "$reason $route_reason" "Ready"
    if [ -n "${selected_slot:-}" ]; then
      write_rotation_cursor "$selected_provider" "$selected_slot"
      write_rotation_cursor "alternate-global" "$selected_slot"
      mark_slot_route_selected "$selected_slot" "$pass_name" "$selected_provider" "$selected_account" "$selected_model" || true
    fi
    printf 'rotation_state=%q\n' "route-ready"
    printf 'selected_provider=%q\n' "$selected_provider"
    printf 'selected_slot=%q\n' "$selected_slot"
    printf 'selected_account=%q\n' "$selected_account"
    printf 'selected_account_label=%q\n' "${selected_account_label:-}"
    printf 'selected_model=%q\n' "$selected_model"
    printf 'note=%q\n' "$route_reason"
    exit 0
    ;;
  wait)
    append_switch_history "$from_context" "wait" "$reason $route_reason" "Waiting"
    printf 'rotation_state=%q\n' "wait"
    printf 'note=%q\n' "$route_reason"
    exit 65
    ;;
  *)
    record_manual_action "Provider rotation required" "$reason $route_reason"
    append_switch_history "$from_context" "manual-action-required" "$reason $route_reason" "Manual action required"
    echo "rotation_state=manual_required"
    exit 65
    ;;
esac
