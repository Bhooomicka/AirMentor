#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

pass_name="${1:-}"
context="${2:-local}"
[ -n "$pass_name" ] || { echo "Usage: $0 <pass-name> [context]" >&2; exit 64; }

session_name="$(session_name_for "$context" "$pass_name")"
session_state="$(tmux_session_state "$session_name" 2>/dev/null || true)"
if [ "$session_state" = "present" ]; then
  echo "Session already running: $session_name"
  exit 0
fi

if [ "$session_state" = "inaccessible" ] || [ "$session_state" = "unavailable" ]; then
  echo "Cannot determine whether $session_name is running because tmux visibility is unavailable from this shell." >&2
  exit 69
fi

bash "$SCRIPT_DIR/tmux-restart-job.sh" "$pass_name" "$context"
