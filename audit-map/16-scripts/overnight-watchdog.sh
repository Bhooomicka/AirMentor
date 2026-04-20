#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

usage() {
  cat >&2 <<'EOF'
Usage: overnight-watchdog.sh [--worker] [--duration-seconds <n>] [--interval-seconds <n>] [--shutdown-on-complete 0|1]

Continuously monitors overnight orchestration and heals common stale/failure states:
- relaunches night-run-orchestrator when missing/stale
- relaunches usage-refresh-orchestrator when missing
- resets stale current pass state and relaunches orchestrator
EOF
  exit 64
}

worker_flag=""
duration_seconds="0"
interval_seconds="600"
shutdown_on_complete="1"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --worker) worker_flag="--worker"; shift ;;
    --duration-seconds) duration_seconds="${2:-0}"; shift 2 ;;
    --interval-seconds) interval_seconds="${2:-600}"; shift 2 ;;
    --shutdown-on-complete) shutdown_on_complete="${2:-1}"; shift 2 ;;
    --help|-h) usage ;;
    *) usage ;;
  esac
done

if [ "$worker_flag" != "--worker" ] && [ -z "${TMUX:-}" ]; then
  existing_session_name="$(session_name_for overnight overnight-watchdog)"
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
  exec bash "$SCRIPT_DIR/tmux-start-job.sh" \
    --pass overnight-watchdog \
    --context overnight \
    --task-class orchestration \
    --workdir "$AUDIT_REPO_ROOT" \
    --provider native-codex \
    --account native-codex-session \
    --command "bash $(printf '%q' "$SCRIPT_DIR/overnight-watchdog.sh") --worker --duration-seconds $(printf '%q' "$duration_seconds") --interval-seconds $(printf '%q' "$interval_seconds") --shutdown-on-complete $(printf '%q' "$shutdown_on_complete")"
fi

orch_session="$(session_name_for overnight night-run-orchestrator)"
orch_status="$(status_path_for "$orch_session")"
orch_checkpoint="$(checkpoint_path_for "$orch_session")"
usage_session="$(session_name_for overnight usage-refresh-orchestrator)"

log_dir="$AUDIT_LOG_ROOT"
mkdir -p "$log_dir"
run_log="$log_dir/${orch_session}.watchdog.$(compact_timestamp).log"

log() {
  printf '[%s] %s\n' "$(timestamp_utc)" "$*" | tee -a "$run_log"
}

launch_orchestrator() {
  local cmd=(env -u TMUX bash "$SCRIPT_DIR/night-run-orchestrator.sh")
  if [ "$shutdown_on_complete" = "1" ]; then
    cmd+=(--shutdown-on-complete)
  fi
  if launch_output="$(${cmd[@]} 2>&1)"; then
    log "orchestrator-launch=ok output=$(printf '%q' "$launch_output")"
  else
    log "orchestrator-launch=failed output=$(printf '%q' "$launch_output")"
  fi
}

ensure_usage_refresh() {
  if tmux_session_present "$usage_session"; then
    return 0
  fi
  if usage_output="$(env -u TMUX bash "$SCRIPT_DIR/usage-refresh-orchestrator.sh" 2>&1)"; then
    log "usage-refresh-launch=ok output=$(printf '%q' "$usage_output")"
  else
    log "usage-refresh-launch=failed output=$(printf '%q' "$usage_output")"
  fi
}

reset_current_pass_if_stale() {
  local current_pass="${1:-}"
  local current_context="${2:-bootstrap}"
  local pass_session=""
  local pass_status=""
  local pass_checkpoint=""
  local pass_state=""

  [ -n "$current_pass" ] || return 0

  pass_session="$(session_name_for "$current_context" "$current_pass")"
  pass_status="$(status_path_for "$pass_session")"
  pass_checkpoint="$(checkpoint_path_for "$pass_session")"

  if [ ! -f "$pass_status" ]; then
    return 0
  fi

  reconcile_status_with_tmux "$pass_status" "$pass_checkpoint"
  pass_state="$(read_env_value "$pass_status" state 2>/dev/null || true)"

  case "${pass_state:-unknown}" in
    failed|manual_action_required|stopped|stale)
      tmux kill-session -t "$pass_session" >/dev/null 2>&1 || true
      rm -f "$pass_status" "$pass_checkpoint"
      log "pass-reset=1 pass=$current_pass context=$current_context previous_state=$pass_state"
      ;;
    *)
      ;;
  esac
}

end_epoch="0"
if [ "${duration_seconds:-0}" -gt 0 ]; then
  end_epoch="$(( $(date +%s) + duration_seconds ))"
fi
iteration="0"

log "watchdog-start duration_seconds=$duration_seconds interval_seconds=$interval_seconds shutdown_on_complete=$shutdown_on_complete log=$run_log"

while :; do
  iteration="$((iteration + 1))"
  ensure_usage_refresh

  if [ -f "$orch_status" ]; then
    reconcile_status_with_tmux "$orch_status" "$orch_checkpoint"
  fi

  orch_state="$(read_env_value "$orch_status" state 2>/dev/null || true)"
  current_pass="$(read_env_value "$orch_status" current_queue_pass 2>/dev/null || true)"
  current_context="$(read_env_value "$orch_status" current_queue_context 2>/dev/null || true)"
  current_session="$(read_env_value "$orch_status" current_queue_session 2>/dev/null || true)"

  # If the queue head pass is stale/failed, reset immediately before relaunching orchestrator.
  reset_current_pass_if_stale "$current_pass" "${current_context:-bootstrap}"

  if ! tmux_session_present "$orch_session" || [ -z "$orch_state" ] || [ "$orch_state" = "stale" ] || [ "$orch_state" = "failed" ] || [ "$orch_state" = "manual_action_required" ] || [ "$orch_state" = "stopped" ]; then
    launch_orchestrator
    if [ -f "$orch_status" ]; then
      reconcile_status_with_tmux "$orch_status" "$orch_checkpoint"
      orch_state="$(read_env_value "$orch_status" state 2>/dev/null || true)"
      current_pass="$(read_env_value "$orch_status" current_queue_pass 2>/dev/null || true)"
      current_context="$(read_env_value "$orch_status" current_queue_context 2>/dev/null || true)"
      current_session="$(read_env_value "$orch_status" current_queue_session 2>/dev/null || true)"
    fi
  fi

  if [ -n "$current_pass" ]; then
    pass_session="$(session_name_for "${current_context:-bootstrap}" "$current_pass")"
    pass_status="$(status_path_for "$pass_session")"
    pass_checkpoint="$(checkpoint_path_for "$pass_session")"
    pass_state="missing"
    if [ -f "$pass_status" ]; then
      reconcile_status_with_tmux "$pass_status" "$pass_checkpoint"
      pass_state="$(read_env_value "$pass_status" state 2>/dev/null || true)"
    fi
    log "iteration=$iteration orchestrator_state=${orch_state:-unknown} queue_pass=$current_pass queue_session=${current_session:-unknown} pass_state=${pass_state:-unknown}"
  else
    log "iteration=$iteration orchestrator_state=${orch_state:-unknown} queue_pass=none"
  fi

  now_epoch="$(date +%s)"
  if [ "$end_epoch" -gt 0 ] && [ "$now_epoch" -ge "$end_epoch" ]; then
    break
  fi

  remaining="$interval_seconds"
  if [ "$end_epoch" -gt 0 ]; then
    remaining="$((end_epoch - now_epoch))"
  fi
  nap="$interval_seconds"
  if [ "$remaining" -lt "$nap" ]; then
    nap="$remaining"
  fi

  sleep "$nap"
done

log "watchdog-finished"
printf 'watchdog_log=%s\n' "$run_log"
