#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

pass_name="${1:-}"
context="${2:-local}"
[ -n "$pass_name" ] || { echo "Usage: $0 <pass-name> [context]" >&2; exit 64; }

session_name="$(session_name_for "$context" "$pass_name")"
status_file="$(status_path_for "$session_name")"
session_state="$(tmux_session_state "$session_name" 2>/dev/null || true)"

if [ "$session_state" = "inaccessible" ] || [ "$session_state" = "unavailable" ]; then
  echo "Cannot stop $session_name because tmux visibility is unavailable from this shell." >&2
  exit 69
fi

if [ "$session_state" = "present" ]; then
  tmux kill-session -t "$session_name"
fi

ensure_audit_dirs
touch "$status_file"
status_mark "$status_file" stopped
upsert_env "$status_file" finished_at "$(timestamp_utc)"
echo "stopped=$session_name"
