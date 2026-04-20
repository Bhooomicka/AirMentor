#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

usage() {
  cat >&2 <<'EOF'
Usage: usage-refresh-orchestrator.sh [--worker] [--interval-seconds <n>]

Refresh Arctic usage/cooldown state on a timer in detached tmux.
The worker adapts its sleep time based on upcoming primary/secondary reset windows.
EOF
  exit 64
}

worker_flag=""
interval_seconds="${AUDIT_USAGE_REFRESH_INTERVAL_SECONDS:-900}"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --worker) worker_flag="--worker"; shift ;;
    --interval-seconds) interval_seconds="${2:-900}"; shift 2 ;;
    --help|-h) usage ;;
    *) usage ;;
  esac
done

if [ "$worker_flag" != "--worker" ] && [ -z "${TMUX:-}" ]; then
  session_name="$(session_name_for overnight usage-refresh-orchestrator)"
  status_file_existing="$(status_path_for "$session_name")"
  checkpoint_file_existing="$(checkpoint_path_for "$session_name")"
  if tmux_session_present "$session_name"; then
    if tmux_session_idle_shell "$session_name"; then
      tmux kill-session -t "$session_name" >/dev/null 2>&1 || true
      if [ -f "$status_file_existing" ]; then
        status_mark "$status_file_existing" stale
        upsert_env "$status_file_existing" tmux_reclaimed_at "$(timestamp_utc)"
        upsert_env "$status_file_existing" tmux_reclaimed_reason "idle-shell-session"
      fi
      if [ -f "$checkpoint_file_existing" ]; then
        upsert_env "$checkpoint_file_existing" last_event "stale"
        upsert_env "$checkpoint_file_existing" last_checkpoint_at "$(timestamp_utc)"
      fi
    else
      printf 'session=%s\n' "$session_name"
      [ -f "$status_file_existing" ] && printf 'status=%s\n' "$status_file_existing"
      exit 0
    fi
  fi
  exec bash "$SCRIPT_DIR/tmux-start-job.sh" \
    --pass usage-refresh-orchestrator \
    --context overnight \
    --task-class orchestration \
    --workdir "$AUDIT_REPO_ROOT" \
    --provider native-codex \
    --account native-codex-session \
    --command "bash $(printf '%q' "$SCRIPT_DIR/usage-refresh-orchestrator.sh") --worker --interval-seconds $(printf '%q' "$interval_seconds")"
fi

status_file="$(status_path_for "$(session_name_for overnight usage-refresh-orchestrator)")"
checkpoint_file="$(checkpoint_path_for "$(session_name_for overnight usage-refresh-orchestrator)")"

status_mark "$status_file" running
upsert_env "$status_file" started_at "$(read_env_value "$status_file" started_at 2>/dev/null || timestamp_utc)"
upsert_env "$checkpoint_file" last_event "running"
upsert_env "$checkpoint_file" last_checkpoint_at "$(timestamp_utc)"

next_sleep_seconds() {
  local default_sleep="${1:-900}"
  local soonest_epoch=""
  local next_epoch=""
  local now_epoch=""
  local sleep_seconds=""
  local status_path=""
  local primary_reset=""
  local secondary_reset=""

  now_epoch="$(date +%s)"

  while IFS= read -r status_path; do
    [ -f "$status_path" ] || continue
    primary_reset="$(read_env_value "$status_path" usage_limit_primary_reset_at 2>/dev/null || true)"
    secondary_reset="$(read_env_value "$status_path" usage_limit_secondary_reset_at 2>/dev/null || true)"
    for reset_at in "$primary_reset" "$secondary_reset"; do
      [ -n "$reset_at" ] || continue
      next_epoch="$(iso_to_epoch "$reset_at" 2>/dev/null || true)"
      [ -n "$next_epoch" ] || continue
      if [ "$next_epoch" -le "$now_epoch" ]; then
        continue
      fi
      if [ -z "$soonest_epoch" ] || [ "$next_epoch" -lt "$soonest_epoch" ]; then
        soonest_epoch="$next_epoch"
      fi
    done
  done < <(find "$AUDIT_STATUS_ROOT" -maxdepth 1 -name 'arctic-slot-*.status' | sort)

  if [ -z "$soonest_epoch" ]; then
    printf '%s' "$default_sleep"
    return 0
  fi

  sleep_seconds="$((soonest_epoch - now_epoch))"
  if [ "$sleep_seconds" -le 600 ]; then
    printf '60'
  elif [ "$sleep_seconds" -le 3600 ]; then
    printf '300'
  elif [ "$sleep_seconds" -le "$default_sleep" ]; then
    printf '%s' "$sleep_seconds"
  else
    printf '%s' "$default_sleep"
  fi
}

while :; do
  upsert_env "$status_file" current_phase "refreshing-usage"
  upsert_env "$checkpoint_file" last_event "running"
  upsert_env "$checkpoint_file" last_checkpoint_at "$(timestamp_utc)"
  bash "$SCRIPT_DIR/arctic-seed-slots-from-global-auth.sh" --all >/dev/null 2>&1 || true
  if bash "$SCRIPT_DIR/arctic-refresh-usage-report.sh"; then
    upsert_env "$status_file" last_refresh_state "completed"
    upsert_env "$status_file" last_refresh_at "$(timestamp_utc)"
  else
    upsert_env "$status_file" last_refresh_state "failed"
    upsert_env "$status_file" last_refresh_at "$(timestamp_utc)"
  fi
  sleep_seconds="$(next_sleep_seconds "$interval_seconds")"
  upsert_env "$status_file" current_phase "sleeping"
  upsert_env "$status_file" next_refresh_in_seconds "$sleep_seconds"
  upsert_env "$checkpoint_file" next_refresh_in_seconds "$sleep_seconds"
  upsert_env "$checkpoint_file" last_checkpoint_at "$(timestamp_utc)"
  sleep "$sleep_seconds"
done
