#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

pass_name="${1:-}"
context="${2:-local}"
task_class="${3:-}"
prompt_file="${4:-}"
[ -n "$pass_name" ] || { echo "Usage: $0 <pass-name> [context] [task-class] [prompt-file]" >&2; exit 64; }

queue_file="$AUDIT_QUEUE_ROOT/pending.queue"
ensure_audit_dirs
touch "$queue_file"
printf '%s\t%s\t%s\t%s\n' "$pass_name" "$context" "$task_class" "$prompt_file" >>"$queue_file"
echo "$queue_file"
