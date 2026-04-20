# Session Recovery Runbook

1. List jobs:
   - `bash audit-map/16-scripts/tmux-list-jobs.sh`
2. Inspect status:
   - `bash audit-map/16-scripts/tmux-job-status.sh <pass>`
3. Tail the log:
   - `bash audit-map/16-scripts/tmux-tail-job-log.sh <pass>`
4. Resume or restart:
   - `bash audit-map/16-scripts/tmux-resume-job.sh <pass>`
   - `bash audit-map/16-scripts/tmux-restart-job.sh <pass>`
