#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

worker_flag="${1:-}"

if [ "$worker_flag" != "--worker" ] && [ -z "${TMUX:-}" ]; then
  session_name="$(session_name_for overnight final-gap-and-shutdown)"
  status_file="$(status_path_for "$session_name")"
  if tmux_session_present "$session_name"; then
    printf 'session=%s\n' "$session_name"
    [ -f "$status_file" ] && printf 'status=%s\n' "$status_file"
    exit 0
  fi
  exec bash "$SCRIPT_DIR/tmux-start-job.sh" \
    --pass final-gap-and-shutdown \
    --context overnight \
    --task-class orchestration \
    --workdir "$AUDIT_REPO_ROOT" \
    --provider native-codex \
    --account native-codex-session \
    --command "bash $(printf '%q' "$SCRIPT_DIR/final-gap-and-shutdown.sh") --worker"
fi

ensure_audit_dirs

report_file="$AUDIT_REPORT_ROOT/final-gap-and-shutdown-overnight.md"

timestamp_now() {
  timestamp_utc
}

write_report() {
  local outcome="$1"
  local details="$2"
  {
    printf '# Final Gap Overnight Run\n\n'
    printf -- '- generated_at: %s\n' "$(timestamp_now)"
    printf -- '- outcome: %s\n' "$outcome"
    printf -- '- details: %s\n\n' "$details"
    printf '## Passes\n'
    printf -- '- proof-refresh-completion-pass\n'
    printf -- '- frontend-long-tail-pass\n'
    printf -- '- closure-readiness-pass\n'
  } >"$report_file"
}

wait_for_pass_terminal_state() {
  local pass_name="$1"
  local context="${2:-bootstrap}"
  local session_name status_file checkpoint_file state

  session_name="$(session_name_for "$context" "$pass_name")"
  status_file="$(status_path_for "$session_name")"
  checkpoint_file="$(checkpoint_path_for "$session_name")"

  while true; do
    if [ -f "$status_file" ]; then
      reconcile_status_with_tmux "$status_file" "$checkpoint_file"
      state="$(read_env_value "$status_file" state 2>/dev/null || true)"
      case "${state:-unknown}" in
        completed)
          return 0
          ;;
        failed|manual_action_required|stopped|stale)
          printf 'Pass %s ended in state=%s\n' "$pass_name" "${state:-unknown}" >&2
          return 65
          ;;
      esac
    fi
    sleep 60
  done
}

run_pass_or_fail() {
  local pass_name="$1"
  shift
  local context="bootstrap"
  local session_name status_file checkpoint_file state

  session_name="$(session_name_for "$context" "$pass_name")"
  status_file="$(status_path_for "$session_name")"
  checkpoint_file="$(checkpoint_path_for "$session_name")"

  if [ -f "$status_file" ]; then
    reconcile_status_with_tmux "$status_file" "$checkpoint_file"
    state="$(read_env_value "$status_file" state 2>/dev/null || true)"
    if [ "${state:-}" = "completed" ]; then
      printf '[%s] skipping %s (already completed)\n' "$(timestamp_now)" "$pass_name"
      return 0
    fi
  fi

  printf '[%s] launching %s\n' "$(timestamp_now)" "$pass_name"
  bash "$SCRIPT_DIR/run-audit-pass.sh" "$pass_name" --context bootstrap "$@"
  wait_for_pass_terminal_state "$pass_name" bootstrap
}

request_shutdown() {
  sync || true
  sleep 3
  systemctl poweroff || loginctl poweroff || shutdown -h now || poweroff
}

if ! run_pass_or_fail proof-refresh-completion-pass \
  --require-provider codex \
  --provider-mode auto \
  --wait-for-provider 1 \
  --wait-timeout-seconds 3600 \
  --wait-poll-seconds 60; then
  write_report "failed" "proof-refresh-completion-pass did not complete successfully; automatic shutdown was skipped."
  exit 65
fi

if ! run_pass_or_fail frontend-long-tail-pass \
  --require-provider codex \
  --provider-mode auto \
  --wait-for-provider 1 \
  --wait-timeout-seconds 3600 \
  --wait-poll-seconds 60; then
  write_report "failed" "frontend-long-tail-pass did not complete successfully; automatic shutdown was skipped."
  exit 65
fi

if ! run_pass_or_fail closure-readiness-pass \
  --require-provider codex \
  --provider-mode auto \
  --wait-for-provider 1 \
  --wait-timeout-seconds 3600 \
  --wait-poll-seconds 60; then
  write_report "failed" "closure-readiness-pass did not complete successfully; automatic shutdown was skipped."
  exit 65
fi

write_report "success" "All remaining automatable final-gap passes completed successfully. Shutdown requested after report persistence."
request_shutdown
