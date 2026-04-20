# Overnight Runbook

1. Queue the passes you want.
2. Verify auth and budget posture.
3. Know the routing truth:
   - native Codex is execution-ready
   - Arctic alternates are bounded-wait only until a slot becomes `execution_verification_state=verified`
3. Start:
   - `bash audit-map/16-scripts/night-run-orchestrator.sh`
4. If a pass cannot launch, the queue entry is retained and the orchestrator stops cleanly instead of silently dropping work.
5. Next morning inspect:
   - `bash audit-map/16-scripts/tmux-list-jobs.sh`
   - `bash audit-map/16-scripts/tmux-job-status.sh night-run-orchestrator`
   - `tail -n 200 audit-map/22-logs/audit-air-mentor-ui-overnight-night-run-orchestrator.log`
