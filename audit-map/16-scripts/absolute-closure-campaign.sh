#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

worker_flag="${1:-}"

if [ "$worker_flag" != "--worker" ] && [ -z "${TMUX:-}" ]; then
  session_name="$(session_name_for overnight absolute-closure-campaign)"
  status_file="$(status_path_for "$session_name")"
  if tmux_session_present "$session_name"; then
    printf 'session=%s\n' "$session_name"
    [ -f "$status_file" ] && printf 'status=%s\n' "$status_file"
    exit 0
  fi
  exec bash "$SCRIPT_DIR/tmux-start-job.sh" \
    --pass absolute-closure-campaign \
    --context overnight \
    --task-class orchestration \
    --workdir "$AUDIT_REPO_ROOT" \
    --provider native-codex \
    --account native-codex-session \
    --command "bash $(printf '%q' "$SCRIPT_DIR/absolute-closure-campaign.sh") --worker"
fi

ensure_audit_dirs

report_file="$AUDIT_REPORT_ROOT/absolute-closure-campaign-overnight.md"
prompt_file_unknown="$AUDIT_MAP_ROOT/20-prompts/no-expenses-spared-final-closure-campaign.md"

timestamp_now() {
  timestamp_utc
}

append_report() {
  local text="$1"
  printf '%s\n' "$text" >>"$report_file"
}

write_report_header() {
  {
    printf '# Absolute Closure Campaign Overnight Run\n\n'
    printf -- '- generated_at: %s\n' "$(timestamp_now)"
    printf -- '- objective: force fresh reruns of the remaining closure passes instead of trusting prior completed labels\n\n'
    printf '## Passes\n'
    printf -- '- backend-provenance-pass\n'
    printf -- '- frontend-microinteraction-pass\n'
    printf -- '- same-student-cross-surface-parity-pass\n'
    printf -- '- live-credentialed-parity-pass\n'
    printf -- '- claim-verification-pass\n'
    printf -- '- unknown-omission-pass\n'
    printf -- '- residual-gap-closure-pass\n'
    printf -- '- closure-readiness-pass\n\n'
    printf '## Timeline\n'
  } >"$report_file"
}

wait_for_pass_terminal_state() {
  local pass_name="$1"
  local context="$2"
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
  local context="$2"
  shift 2

  append_report ""
  append_report "- [$(timestamp_now)] launching \`$pass_name\` (\`$context\`)"
  bash "$SCRIPT_DIR/run-audit-pass.sh" "$pass_name" --context "$context" "$@"
  wait_for_pass_terminal_state "$pass_name" "$context"
  append_report "- [$(timestamp_now)] completed \`$pass_name\` (\`$context\`)"
}

write_report_header

run_pass_or_fail backend-provenance-pass bootstrap \
  --provider-mode auto \
  --wait-for-provider 1 \
  --wait-timeout-seconds 3600 \
  --wait-poll-seconds 60

run_pass_or_fail frontend-microinteraction-pass bootstrap \
  --provider-mode auto \
  --wait-for-provider 1 \
  --wait-timeout-seconds 3600 \
  --wait-poll-seconds 60

run_pass_or_fail same-student-cross-surface-parity-pass live \
  --provider-mode auto \
  --wait-for-provider 1 \
  --wait-timeout-seconds 3600 \
  --wait-poll-seconds 60

run_pass_or_fail live-credentialed-parity-pass live \
  --provider-mode auto \
  --wait-for-provider 1 \
  --wait-timeout-seconds 3600 \
  --wait-poll-seconds 60

run_pass_or_fail claim-verification-pass bootstrap \
  --provider-mode auto \
  --wait-for-provider 1 \
  --wait-timeout-seconds 3600 \
  --wait-poll-seconds 60

run_pass_or_fail unknown-omission-pass bootstrap \
  --prompt-file "$prompt_file_unknown" \
  --provider-mode auto \
  --wait-for-provider 1 \
  --wait-timeout-seconds 3600 \
  --wait-poll-seconds 60

run_pass_or_fail residual-gap-closure-pass bootstrap \
  --provider-mode auto \
  --wait-for-provider 1 \
  --wait-timeout-seconds 3600 \
  --wait-poll-seconds 60

run_pass_or_fail closure-readiness-pass bootstrap \
  --provider-mode auto \
  --wait-for-provider 1 \
  --wait-timeout-seconds 3600 \
  --wait-poll-seconds 60

append_report ""
append_report "- [$(timestamp_now)] campaign finished"
