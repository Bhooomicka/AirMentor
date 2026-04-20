#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

queue_file="$AUDIT_QUEUE_ROOT/pending.queue"
status_appearance_timeout_seconds="${AUDIT_STATUS_APPEAR_TIMEOUT_SECONDS:-180}"
status_appearance_poll_seconds="${AUDIT_STATUS_APPEAR_POLL_SECONDS:-10}"
pass_poll_seconds="${AUDIT_PASS_POLL_SECONDS:-30}"
route_wait_timeout_seconds="${AUDIT_ROUTE_WAIT_TIMEOUT_SECONDS:-0}"
route_wait_poll_seconds="${AUDIT_ROUTE_WAIT_POLL_SECONDS:-60}"
worker_flag=""
shutdown_on_complete="${AUDIT_OVERNIGHT_SHUTDOWN_ON_COMPLETE:-0}"

usage() {
  echo "Usage: $0 [--worker] [--shutdown-on-complete]" >&2
  exit 64
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --worker)
      worker_flag="--worker"
      shift
      ;;
    --shutdown-on-complete)
      shutdown_on_complete="1"
      shift
      ;;
    --help|-h)
      usage
      ;;
    *)
      usage
      ;;
  esac
done

if [ "$worker_flag" != "--worker" ] && [ -z "${TMUX:-}" ]; then
  existing_session_name="$(session_name_for overnight night-run-orchestrator)"
  existing_status_file="$(status_path_for "$existing_session_name")"
  existing_checkpoint_file="$(checkpoint_path_for "$existing_session_name")"
  if tmux_session_present "$existing_session_name"; then
    if tmux_session_idle_shell "$existing_session_name"; then
      tmux kill-session -t "$existing_session_name" >/dev/null 2>&1 || true
      if [ -f "$existing_status_file" ]; then
        status_mark "$existing_status_file" stale
        upsert_env "$existing_status_file" tmux_reclaimed_at "$(timestamp_utc)"
        upsert_env "$existing_status_file" tmux_reclaimed_reason "idle-shell-session"
      fi
      if [ -f "$existing_checkpoint_file" ]; then
        upsert_env "$existing_checkpoint_file" last_event "stale"
        upsert_env "$existing_checkpoint_file" last_checkpoint_at "$(timestamp_utc)"
      fi
    else
      printf 'session=%s\n' "$existing_session_name"
      [ -f "$existing_status_file" ] && printf 'status=%s\n' "$existing_status_file"
      exit 0
    fi
  fi
  worker_command="bash $(printf '%q' "$SCRIPT_DIR/night-run-orchestrator.sh") --worker"
  if [ "$shutdown_on_complete" = "1" ]; then
    worker_command="$worker_command --shutdown-on-complete"
  fi
  exec bash "$SCRIPT_DIR/tmux-start-job.sh" \
    --pass night-run-orchestrator \
    --context overnight \
    --task-class orchestration \
    --workdir "$AUDIT_REPO_ROOT" \
    --provider native-codex \
    --account native-codex-session \
    --command "$worker_command"
fi

ensure_audit_dirs
touch "$queue_file"

bash "$SCRIPT_DIR/arctic-seed-slots-from-global-auth.sh" --all >/dev/null 2>&1 || true

orchestrator_session_name="$(session_name_for overnight night-run-orchestrator)"
orchestrator_status_file="$(status_path_for "$orchestrator_session_name")"
orchestrator_checkpoint_file="$(checkpoint_path_for "$orchestrator_session_name")"

status_mark "$orchestrator_status_file" running
upsert_env "$orchestrator_status_file" current_phase "queue-processing"
upsert_env "$orchestrator_status_file" started_at "$(read_env_value "$orchestrator_status_file" started_at 2>/dev/null || timestamp_utc)"
upsert_env "$orchestrator_status_file" shutdown_on_complete "$shutdown_on_complete"
upsert_env "$orchestrator_checkpoint_file" last_event "running"
upsert_env "$orchestrator_checkpoint_file" last_checkpoint_at "$(timestamp_utc)"

nohup bash "$SCRIPT_DIR/cooldown-aware-rotation-monitor.sh" >/dev/null 2>&1 &
monitor_pid="$!"
printf '[%s] cooldown-aware-rotation-monitor started with pid=%s\n' "$(timestamp_utc)" "$monitor_pid"

drop_first_queue_line() {
  tail -n +2 "$queue_file" >"${queue_file}.tmp" || true
  mv "${queue_file}.tmp" "$queue_file"
}

while [ -s "$queue_file" ]; do
  IFS=$'\t' read -r pass_name context task_class prompt_file <"$queue_file"

  case "${pass_name:-}" in
    "")
      drop_first_queue_line
      continue
      ;;
    \#*)
      drop_first_queue_line
      continue
      ;;
  esac

  args=("$pass_name")
  [ -n "${context:-}" ] && args+=(--context "$context")
  [ -n "${task_class:-}" ] && args+=(--task-class "$task_class")
  [ -n "${prompt_file:-}" ] && args+=(--prompt-file "$prompt_file")
  args+=(--provider-mode auto --wait-for-provider 1 --wait-timeout-seconds "$route_wait_timeout_seconds" --wait-poll-seconds "$route_wait_poll_seconds")
  session_name="$(session_name_for "${context:-local}" "$pass_name")"
  status_file="$(status_path_for "$session_name")"
  checkpoint_file="$(checkpoint_path_for "$session_name")"
  upsert_env "$orchestrator_status_file" current_queue_pass "$pass_name"
  upsert_env "$orchestrator_status_file" current_queue_context "${context:-}"
  upsert_env "$orchestrator_status_file" current_queue_task_class "${task_class:-}"
  upsert_env "$orchestrator_status_file" current_queue_prompt_file "${prompt_file:-}"
  upsert_env "$orchestrator_checkpoint_file" current_queue_pass "$pass_name"
  upsert_env "$orchestrator_checkpoint_file" current_queue_context "${context:-}"
  upsert_env "$orchestrator_checkpoint_file" last_event "running"
  upsert_env "$orchestrator_checkpoint_file" last_checkpoint_at "$(timestamp_utc)"
  
  # Pre-pass cooldown check: wait a bit for cooldown monitor to rotate if needed
  sleep 3
  python3 "$SCRIPT_DIR/operator-dashboard.py" --write-only >/dev/null 2>&1 || true
  if [ -f "$status_file" ]; then
    reconcile_status_with_tmux "$status_file" "$checkpoint_file"
    state="$(read_env_value "$status_file" state 2>/dev/null || true)"
    if [ "${state:-}" = "completed" ]; then
      drop_first_queue_line
      nohup bash "$SCRIPT_DIR/arctic-refresh-usage-report.sh" >/dev/null 2>&1 &
      upsert_env "$orchestrator_status_file" last_completed_pass "$pass_name"
      upsert_env "$orchestrator_status_file" last_completed_session "$session_name"
      upsert_env "$orchestrator_checkpoint_file" last_completed_pass "$pass_name"
      upsert_env "$orchestrator_checkpoint_file" last_completed_session "$session_name"
      upsert_env "$orchestrator_checkpoint_file" last_checkpoint_at "$(timestamp_utc)"
      python3 "$SCRIPT_DIR/operator-dashboard.py" --write-only >/dev/null 2>&1 || true
      continue
    fi
  fi
  if [ "${state:-}" = "running" ] && tmux_session_present "$session_name"; then
    launch_output="$(printf 'session=%s\nlog=%s\nstatus=%s\ncheckpoint=%s\n' "$session_name" "$(log_path_for "$session_name")" "$status_file" "$checkpoint_file")"
  else
    if ! launch_output="$(bash "$SCRIPT_DIR/run-audit-pass.sh" "${args[@]}" 2>&1)"; then
      printf '%s\n' "$launch_output" >&2
      record_manual_action "Overnight launch failure" "Pass '$pass_name' could not launch from the overnight queue. Queue entry was retained. Review the launch output in the current terminal and rerun night-run-orchestrator after fixing the blocker."
      echo "Overnight run stopped before $pass_name could launch. Queue entry retained." >&2
      exit 65
    fi
  fi
  printf '%s\n' "$launch_output"
  upsert_env "$orchestrator_status_file" current_queue_session "$session_name"
  upsert_env "$orchestrator_checkpoint_file" current_queue_session "$session_name"
  upsert_env "$orchestrator_checkpoint_file" last_checkpoint_at "$(timestamp_utc)"
  python3 "$SCRIPT_DIR/operator-dashboard.py" --write-only >/dev/null 2>&1 || true
  deadline="$(( $(date +%s) + status_appearance_timeout_seconds ))"

  while [ ! -f "$status_file" ]; do
    if ! tmux_session_present "$session_name"; then
      record_manual_action "Overnight status missing" "Session '$session_name' never produced a status file and the tmux session disappeared. Queue entry was retained for retry."
      echo "Overnight run stopped because $session_name never produced a status file and the tmux session is gone. Queue entry retained." >&2
      exit 65
    fi
    if [ "$(date +%s)" -ge "$deadline" ]; then
      record_manual_action "Overnight status timeout" "Session '$session_name' did not produce a status file within ${status_appearance_timeout_seconds}s. Queue entry was retained for retry."
      echo "Overnight run timed out waiting for $session_name to produce a status file. Queue entry retained." >&2
      exit 65
    fi
    sleep "$status_appearance_poll_seconds"
  done

  pass_poll_extended_seconds="$((pass_poll_seconds * 10))"
  status_loss_grace_period_seconds="300"
  status_loss_first_at="0"
  
  while true; do
    sleep "$pass_poll_extended_seconds"
    upsert_env "$orchestrator_status_file" current_queue_session "$session_name"
    upsert_env "$orchestrator_status_file" current_queue_pass "$pass_name"
    upsert_env "$orchestrator_checkpoint_file" current_queue_session "$session_name"
    upsert_env "$orchestrator_checkpoint_file" current_queue_pass "$pass_name"
    upsert_env "$orchestrator_checkpoint_file" last_event "running"
    upsert_env "$orchestrator_checkpoint_file" last_checkpoint_at "$(timestamp_utc)"
    python3 "$SCRIPT_DIR/operator-dashboard.py" --write-only >/dev/null 2>&1 || true
    
    if [ ! -f "$status_file" ]; then
      if [ "$status_loss_first_at" = "0" ]; then
        status_loss_first_at="$(date +%s)"
      fi
      time_since_loss=$(( $(date +%s) - status_loss_first_at ))
      if [ "$time_since_loss" -lt "$status_loss_grace_period_seconds" ]; then
        continue
      fi
      record_manual_action "Overnight status lost" "Session '$session_name' lost its status file after launch and did not recover within ${status_loss_grace_period_seconds}s. Manual inspection is required before resuming the queue."
      echo "Overnight run lost the status file for $session_name after launch." >&2
      exit 65
    fi
    
    status_loss_first_at="0"
    reconcile_status_with_tmux "$status_file" "$checkpoint_file"
    state="$(read_env_value "$status_file" state 2>/dev/null || true)"
    supervisor_state="$(read_env_value "$status_file" execution_supervisor_state 2>/dev/null || true)"
    route_attempt="$(read_env_value "$status_file" route_attempt 2>/dev/null || true)"
    
    case "${state:-unknown}" in
      completed)
        drop_first_queue_line
        nohup bash "$SCRIPT_DIR/arctic-refresh-usage-report.sh" >/dev/null 2>&1 &
        upsert_env "$orchestrator_status_file" last_completed_pass "$pass_name"
        upsert_env "$orchestrator_status_file" last_completed_session "$session_name"
        upsert_env "$orchestrator_checkpoint_file" last_completed_pass "$pass_name"
        upsert_env "$orchestrator_checkpoint_file" last_completed_session "$session_name"
        upsert_env "$orchestrator_checkpoint_file" last_checkpoint_at "$(timestamp_utc)"
        python3 "$SCRIPT_DIR/operator-dashboard.py" --write-only >/dev/null 2>&1 || true
        break
        ;;
      failed|manual_action_required|stopped|stale)
        record_manual_action "Overnight pass stopped" "Session '$session_name' ended the overnight queue with state='${state:-unknown}' after route_attempt=$route_attempt (supervisor_state=$supervisor_state). Inspect its status/checkpoint/log trio before resuming."
        echo "Overnight run stopped on $session_name with state=${state:-unknown} (attempt=$route_attempt, supervisor=$supervisor_state)" >&2
        exit 65
        ;;
    esac
  done
done

if [ "$shutdown_on_complete" = "1" ]; then
  upsert_env "$orchestrator_status_file" current_phase "final-gap-and-shutdown"
  upsert_env "$orchestrator_checkpoint_file" last_event "final-gap-and-shutdown"
  upsert_env "$orchestrator_checkpoint_file" last_checkpoint_at "$(timestamp_utc)"
  python3 "$SCRIPT_DIR/operator-dashboard.py" --write-only >/dev/null 2>&1 || true
  if ! bash "$SCRIPT_DIR/final-gap-and-shutdown.sh"; then
    record_manual_action "Overnight shutdown tail failed" "The overnight queue completed, but final-gap-and-shutdown.sh failed before requesting shutdown. Resolve the blocker and rerun final-gap-and-shutdown.sh manually."
    echo "Overnight queue complete, but final-gap-and-shutdown failed before shutdown request." >&2
    exit 65
  fi
fi

upsert_env "$orchestrator_checkpoint_file" last_event "completed"
upsert_env "$orchestrator_checkpoint_file" last_checkpoint_at "$(timestamp_utc)"
echo "Overnight queue complete."
