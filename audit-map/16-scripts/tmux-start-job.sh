#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

usage() {
  echo "Usage: $0 --pass <name> [--context <context>] [--task-class <class>] [--workdir <dir>] [--model <slug>] [--provider <name>] [--account <name>] [--caveman-active 0|1] [--caveman-mode <mode>] [--allow-existing] --command <shell-command>" >&2
  exit 64
}

pass_name=""
context="local"
task_class="structured"
workdir="$AUDIT_REPO_ROOT"
model=""
provider="native-codex"
account="default"
caveman_active="0"
caveman_mode="off"
allow_existing="0"
command_string=""

while [ "$#" -gt 0 ]; do
  case "$1" in
    --pass) pass_name="${2:-}"; shift 2 ;;
    --context) context="${2:-}"; shift 2 ;;
    --task-class) task_class="${2:-}"; shift 2 ;;
    --workdir) workdir="${2:-}"; shift 2 ;;
    --model) model="${2:-}"; shift 2 ;;
    --provider) provider="${2:-}"; shift 2 ;;
    --account) account="${2:-}"; shift 2 ;;
    --caveman-active) caveman_active="${2:-}"; shift 2 ;;
    --caveman-mode) caveman_mode="${2:-}"; shift 2 ;;
    --allow-existing) allow_existing="1"; shift ;;
    --command) command_string="${2:-}"; shift 2 ;;
    --) shift; command_string="$(join_command "$@")"; break ;;
    *) usage ;;
  esac
done

[ -n "$pass_name" ] || usage
[ -n "$command_string" ] || usage

ensure_audit_dirs
require_tmux

session_name="$(session_name_for "$context" "$pass_name")"
status_file="$(status_path_for "$session_name")"
checkpoint_file="$(checkpoint_path_for "$session_name")"
log_file="$(log_path_for "$session_name")"
command_file="$(command_path_for "$session_name")"
wrapper_file="$AUDIT_TMUX_ROOT/${session_name}.wrapper.sh"
archived_log_file=""

if tmux has-session -t "$session_name" 2>/dev/null; then
  if [ "$allow_existing" != "1" ]; then
    echo "tmux session already exists: $session_name" >&2
    exit 73
  fi
  tmux kill-session -t "$session_name"
fi

{
  printf '#!/usr/bin/env bash\n'
  printf 'set -euo pipefail\n'
  printf 'cd %q\n' "$workdir"
  printf '%s\n' "$command_string"
} >"$command_file"
chmod +x "$command_file"

if [ -f "$log_file" ] && [ -s "$log_file" ]; then
  archived_log_file="${log_file}.$(compact_timestamp).prev"
  mv "$log_file" "$archived_log_file"
fi

write_env_file "$status_file" \
  session_name "$session_name" \
  pass_name "$pass_name" \
  context "$context" \
  task_class "$task_class" \
  workdir "$workdir" \
  state "queued" \
  model "$model" \
  provider "$provider" \
  account "$account" \
  caveman_active "$caveman_active" \
  caveman_mode "$caveman_mode" \
  original_command "$command_string" \
  command_file "$command_file" \
  log_file "$log_file" \
  archived_log_file "$archived_log_file" \
  checkpoint_file "$checkpoint_file" \
  created_at "$(timestamp_utc)" \
  updated_at "$(timestamp_utc)"

write_env_file "$checkpoint_file" \
  pass_name "$pass_name" \
  context "$context" \
  session_name "$session_name" \
  last_event "queued" \
  last_checkpoint_at "$(timestamp_utc)" \
  workdir "$workdir" \
  caveman_active "$caveman_active" \
  caveman_mode "$caveman_mode"

python3 "$SCRIPT_DIR/operator-dashboard.py" --write-only >/dev/null 2>&1 || true

{
  printf '#!/usr/bin/env bash\n'
  printf 'set -euo pipefail\n'
  printf 'source %q\n' "$SCRIPT_DIR/_audit-common.sh"
  printf 'status_file=%q\n' "$status_file"
  printf 'checkpoint_file=%q\n' "$checkpoint_file"
  printf 'log_file=%q\n' "$log_file"
  printf 'command_file=%q\n' "$command_file"
  printf 'status_mark "$status_file" running\n'
  printf 'upsert_env "$status_file" started_at "$(timestamp_utc)"\n'
  printf 'upsert_env "$status_file" pid "$$"\n'
  printf 'upsert_env "$checkpoint_file" last_event "running"\n'
  printf 'upsert_env "$checkpoint_file" last_checkpoint_at "$(timestamp_utc)"\n'
  printf 'python3 %q --write-only >/dev/null 2>&1 || true\n' "$SCRIPT_DIR/operator-dashboard.py"
  printf '{\n'
  printf '  printf "[%%s] session=%%s\\n" "$(timestamp_utc)" %q\n' "$session_name"
  printf '  printf "[%%s] command_file=%%s\\n" "$(timestamp_utc)" "$command_file"\n'
  printf '  set +e\n'
  printf '  bash "$command_file"\n'
  printf '  exit_code=$?\n'
  printf '  set -e\n'
  printf '  printf "[%%s] exit_code=%%s\\n" "$(timestamp_utc)" "$exit_code"\n'
  printf '} >>"$log_file" 2>&1\n'
  printf 'if [ "$exit_code" -eq 0 ]; then\n'
  printf '  status_mark "$status_file" completed\n'
  printf 'else\n'
  printf '  status_mark "$status_file" failed\n'
  printf 'fi\n'
  printf 'upsert_env "$status_file" exit_code "$exit_code"\n'
  printf 'upsert_env "$status_file" finished_at "$(timestamp_utc)"\n'
  printf 'upsert_env "$checkpoint_file" last_event "$(read_env_value "$status_file" state 2>/dev/null || true)"\n'
  printf 'upsert_env "$checkpoint_file" last_checkpoint_at "$(timestamp_utc)"\n'
  printf 'python3 %q --write-only >/dev/null 2>&1 || true\n' "$SCRIPT_DIR/operator-dashboard.py"
  if [ "$pass_name" != "usage-refresh-orchestrator" ]; then
    printf 'nohup bash %q >/dev/null 2>&1 &\n' "$SCRIPT_DIR/arctic-refresh-usage-report.sh"
  fi
  printf 'exit "$exit_code"\n'
} >"$wrapper_file"
chmod +x "$wrapper_file"

status_mark "$status_file" starting
set +e
tmux_launch_output="$(tmux new-session -d -s "$session_name" "bash $(printf '%q' "$wrapper_file")" 2>&1)"
tmux_launch_rc="$?"
set -e

if [ "$tmux_launch_rc" -ne 0 ]; then
  if printf '%s' "$tmux_launch_output" | grep -Eqi 'duplicate session'; then
    if tmux has-session -t "$session_name" 2>/dev/null; then
      status_mark "$status_file" running
      upsert_env "$status_file" started_at "$(timestamp_utc)"
      upsert_env "$checkpoint_file" last_event "running"
      upsert_env "$checkpoint_file" last_checkpoint_at "$(timestamp_utc)"
      printf 'session=%s\n' "$session_name"
      printf 'log=%s\n' "$log_file"
      printf 'status=%s\n' "$status_file"
      printf 'checkpoint=%s\n' "$checkpoint_file"
      exit 0
    fi
  fi
  status_mark "$status_file" failed
  upsert_env "$status_file" exit_code "$tmux_launch_rc"
  upsert_env "$status_file" finished_at "$(timestamp_utc)"
  upsert_env "$checkpoint_file" last_event "failed"
  upsert_env "$checkpoint_file" last_checkpoint_at "$(timestamp_utc)"
  echo "$tmux_launch_output" >&2
  exit "$tmux_launch_rc"
fi

printf 'session=%s\n' "$session_name"
printf 'log=%s\n' "$log_file"
printf 'status=%s\n' "$status_file"
printf 'checkpoint=%s\n' "$checkpoint_file"
