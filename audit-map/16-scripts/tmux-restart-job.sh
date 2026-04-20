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
task_class="$(read_env_value "$status_file" task_class 2>/dev/null || true)"
workdir="$(read_env_value "$status_file" workdir 2>/dev/null || true)"
model="$(read_env_value "$status_file" model 2>/dev/null || true)"
provider="$(read_env_value "$status_file" provider 2>/dev/null || true)"
account="$(read_env_value "$status_file" account 2>/dev/null || true)"
original_command="$(read_env_value "$status_file" original_command 2>/dev/null || true)"
command_file="$(read_env_value "$status_file" command_file 2>/dev/null || true)"

bash "$SCRIPT_DIR/tmux-start-job.sh" \
  --pass "$pass_name" \
  --context "$context" \
  --task-class "${task_class:-structured}" \
  --workdir "${workdir:-$AUDIT_REPO_ROOT}" \
  --model "${model:-}" \
  --provider "${provider:-native-codex}" \
  --account "${account:-default}" \
  --allow-existing \
  --command "${original_command:-bash $(printf '%q' "${command_file:-}")}"
