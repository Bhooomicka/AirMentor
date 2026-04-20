#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

pass_name="${1:-}"
context="${2:-local}"
mode="${3:-show}"
[ -n "$pass_name" ] || { echo "Usage: $0 <pass-name> [context] [show|resume]" >&2; exit 64; }

session_name="$(session_name_for "$context" "$pass_name")"
status_file="$(status_path_for "$session_name")"
checkpoint_file="$(checkpoint_path_for "$session_name")"
[ -f "$status_file" ] || { echo "No status file found for $session_name" >&2; exit 66; }

cat "$status_file"
echo
[ -f "$checkpoint_file" ] && cat "$checkpoint_file"

if [ "$mode" = "resume" ]; then
  exec bash "$SCRIPT_DIR/resume-audit-pass.sh" "$pass_name" "$context"
fi
