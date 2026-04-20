#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

pass_name="${1:-}"
context="${2:-local}"
[ -n "$pass_name" ] || { echo "Usage: $0 <pass-name> [context]" >&2; exit 64; }

session_name="$(session_name_for "$context" "$pass_name")"
status_file="$(status_path_for "$session_name")"
[ -f "$status_file" ] || { echo "No status file found for $session_name" >&2; exit 66; }

reconcile_status_with_tmux "$status_file"
log_file="$(read_env_value "$status_file" log_file 2>/dev/null || true)"
tail -n "${TAIL_LINES:-100}" -f "${log_file:-$(log_path_for "$session_name")}"
