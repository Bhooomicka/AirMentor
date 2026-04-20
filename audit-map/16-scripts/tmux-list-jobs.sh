#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

ensure_audit_dirs
printf 'session\tstate\ttmux\tlog\n'
for file in "$AUDIT_STATUS_ROOT"/*.status; do
  [ -e "$file" ] || exit 0
  if [[ "$(basename "$file")" != audit-* ]]; then
    continue
  fi
  checkpoint_file="$(checkpoint_path_for "$(basename "$file" .status)")"
  reconcile_status_with_tmux "$file" "$checkpoint_file"
  session_name="$(read_env_value "$file" session_name 2>/dev/null || true)"
  state="$(read_env_value "$file" state 2>/dev/null || true)"
  log_file="$(read_env_value "$file" log_file 2>/dev/null || true)"
  tmux_state="$(tmux_session_state "$session_name" 2>/dev/null || true)"
  case "$tmux_state" in
    present) tmux_state="running" ;;
    missing) tmux_state="missing" ;;
    *) tmux_state="inaccessible" ;;
  esac
  printf '%s\t%s\t%s\t%s\n' "${session_name:-unknown}" "${state:-unknown}" "$tmux_state" "${log_file:-}"
done
