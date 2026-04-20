#!/usr/bin/env bash
set -euo pipefail
source /home/raed/projects/air-mentor-ui/audit-map/16-scripts/_audit-common.sh
status_file=/home/raed/projects/air-mentor-ui/audit-map/29-status/audit-air-mentor-ui-bootstrap-workflow-automation-pass.status
checkpoint_file=/home/raed/projects/air-mentor-ui/audit-map/30-checkpoints/audit-air-mentor-ui-bootstrap-workflow-automation-pass.checkpoint
log_file=/home/raed/projects/air-mentor-ui/audit-map/22-logs/audit-air-mentor-ui-bootstrap-workflow-automation-pass.log
command_file=/home/raed/projects/air-mentor-ui/audit-map/31-queues/audit-air-mentor-ui-bootstrap-workflow-automation-pass.command.sh
status_mark "$status_file" running
upsert_env "$status_file" started_at "$(timestamp_utc)"
upsert_env "$status_file" pid "$$"
upsert_env "$checkpoint_file" last_event "running"
upsert_env "$checkpoint_file" last_checkpoint_at "$(timestamp_utc)"
python3 /home/raed/projects/air-mentor-ui/audit-map/16-scripts/operator-dashboard.py --write-only >/dev/null 2>&1 || true
{
  printf "[%s] session=%s\n" "$(timestamp_utc)" audit-air-mentor-ui-bootstrap-workflow-automation-pass
  printf "[%s] command_file=%s\n" "$(timestamp_utc)" "$command_file"
  set +e
  bash "$command_file"
  exit_code=$?
  set -e
  printf "[%s] exit_code=%s\n" "$(timestamp_utc)" "$exit_code"
} >>"$log_file" 2>&1
if [ "$exit_code" -eq 0 ]; then
  status_mark "$status_file" completed
else
  status_mark "$status_file" failed
fi
upsert_env "$status_file" exit_code "$exit_code"
upsert_env "$status_file" finished_at "$(timestamp_utc)"
upsert_env "$checkpoint_file" last_event "$(read_env_value "$status_file" state 2>/dev/null || true)"
upsert_env "$checkpoint_file" last_checkpoint_at "$(timestamp_utc)"
python3 /home/raed/projects/air-mentor-ui/audit-map/16-scripts/operator-dashboard.py --write-only >/dev/null 2>&1 || true
nohup bash /home/raed/projects/air-mentor-ui/audit-map/16-scripts/arctic-refresh-usage-report.sh >/dev/null 2>&1 &
exit "$exit_code"
