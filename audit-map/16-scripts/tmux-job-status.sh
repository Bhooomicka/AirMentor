#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

pass_name="${1:-}"
context="${2:-local}"
[ -n "$pass_name" ] || { echo "Usage: $0 <pass-name> [context]" >&2; exit 64; }

session_name="$(session_name_for "$context" "$pass_name")"
status_file="$(status_path_for "$session_name")"
checkpoint_file="$(checkpoint_path_for "$session_name")"
[ -f "$status_file" ] || { echo "No status file found for $session_name" >&2; exit 66; }

reconcile_status_with_tmux "$status_file" "$checkpoint_file"
cat "$status_file"
session_state="$(tmux_session_state "$session_name" 2>/dev/null || true)"
echo "tmux_state=${session_state:-unknown}"
case "$session_state" in
  present) echo "tmux_present=1" ;;
  missing) echo "tmux_present=0" ;;
  *) echo "tmux_present=unknown" ;;
esac
