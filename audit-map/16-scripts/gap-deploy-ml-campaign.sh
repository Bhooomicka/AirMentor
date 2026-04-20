#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

worker_flag="${1:-}"

if [ "$worker_flag" != "--worker" ] && [ -z "${TMUX:-}" ]; then
  session_name="$(session_name_for overnight gap-deploy-ml-campaign)"
  status_file="$(status_path_for "$session_name")"
  if tmux_session_present "$session_name"; then
    printf 'session=%s\n' "$session_name"
    [ -f "$status_file" ] && printf 'status=%s\n' "$status_file"
    exit 0
  fi
  exec bash "$SCRIPT_DIR/tmux-start-job.sh" \
    --pass gap-deploy-ml-campaign \
    --context overnight \
    --task-class orchestration \
    --workdir "$AUDIT_REPO_ROOT" \
    --provider native-codex \
    --account native-codex-session \
    --command "bash $(printf '%q' "$SCRIPT_DIR/gap-deploy-ml-campaign.sh") --worker"
fi

ensure_audit_dirs

run_id="$(date -u +%Y%m%dT%H%M%SZ)"
report_file="$AUDIT_REPORT_ROOT/gap-deploy-ml-campaign-$run_id.md"

prompt_gap="$AUDIT_MAP_ROOT/20-prompts/gap-closure-deploy-audit-reconciliation-pass.md"
prompt_ml="$AUDIT_MAP_ROOT/20-prompts/ml-optimal-model-deep-tune-pass.md"

write_report() {
  printf '%s\n' "$1" >>"$report_file"
}

write_header() {
  {
    printf '# Gap Deploy ML Campaign Run\n\n'
    printf -- '- generated_at: %s\n' "$(timestamp_utc)"
    printf -- '- branch: promote-proof-dashboard-origin\n'
    printf -- '- objective: push stable gap closure first, then run deep ML tuning lane\n\n'
    printf '## Run Order\n'
    printf -- '- gap-closure-deploy-audit-reconciliation-pass\n'
    printf -- '- ml-optimal-model-deep-tune-pass (provider preference fallback chain)\n\n'
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
          printf 'Pass %s ended with state=%s\n' "$pass_name" "${state:-unknown}" >&2
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
  local launch_output=""

  write_report "- [$(timestamp_utc)] launch $pass_name ($context)"
  if ! launch_output="$(bash "$SCRIPT_DIR/run-audit-pass.sh" "$pass_name" --context "$context" "$@" 2>&1)"; then
    write_report "- [$(timestamp_utc)] launch failed for $pass_name"
    write_report "\`\`\`"
    write_report "$launch_output"
    write_report "\`\`\`"
    return 1
  fi

  write_report "\`\`\`"
  write_report "$launch_output"
  write_report "\`\`\`"

  if ! wait_for_pass_terminal_state "$pass_name" "$context"; then
    write_report "- [$(timestamp_utc)] terminal failure for $pass_name"
    return 1
  fi

  write_report "- [$(timestamp_utc)] completed $pass_name ($context)"
  return 0
}

write_header

run_pass_or_fail gap-closure-deploy-audit-reconciliation-pass bootstrap \
  --prompt-file "$prompt_gap" \
  --model gpt-5.4 \
  --reasoning-effort xhigh \
  --search 1 \
  --provider-mode auto \
  --wait-for-provider 1 \
  --wait-timeout-seconds 3600 \
  --wait-poll-seconds 60

ml_completed="0"

if run_pass_or_fail ml-optimal-model-deep-tune-pass bootstrap \
  --prompt-file "$prompt_ml" \
  --model claude-opus-4.6 \
  --reasoning-effort xhigh \
  --search 1 \
  --provider-mode auto \
  --require-provider antigravity \
  --wait-for-provider 1 \
  --wait-timeout-seconds 3600 \
  --wait-poll-seconds 60; then
  ml_completed="1"
  write_report "- [$(timestamp_utc)] ML lane used antigravity claude-opus-4.6"
fi

if [ "$ml_completed" != "1" ]; then
  write_report "- [$(timestamp_utc)] fallback to google gemini-3.1-pro-preview"
  if run_pass_or_fail ml-optimal-model-deep-tune-pass bootstrap \
    --prompt-file "$prompt_ml" \
    --model gemini-3.1-pro-preview \
    --reasoning-effort xhigh \
    --search 1 \
    --provider-mode auto \
    --require-provider google \
    --wait-for-provider 1 \
    --wait-timeout-seconds 3600 \
    --wait-poll-seconds 60; then
    ml_completed="1"
    write_report "- [$(timestamp_utc)] ML lane used google gemini-3.1-pro-preview"
  fi
fi

if [ "$ml_completed" != "1" ]; then
  write_report "- [$(timestamp_utc)] fallback to native codex gpt-5.4"
  run_pass_or_fail ml-optimal-model-deep-tune-pass bootstrap \
    --prompt-file "$prompt_ml" \
    --model gpt-5.4 \
    --reasoning-effort xhigh \
    --search 1 \
    --provider-mode auto \
    --require-provider native-codex \
    --wait-for-provider 1 \
    --wait-timeout-seconds 3600 \
    --wait-poll-seconds 60
  write_report "- [$(timestamp_utc)] ML lane used native-codex gpt-5.4"
fi

write_report "- [$(timestamp_utc)] campaign finished"
printf 'report=%s\n' "$report_file"
