# Troubleshooting Runbook

## Common Failures

- Missing `tmux`: install or use documented fallback, then rerun the wrapper.
- `codex` not authenticated: run `codex login` or `codex login status`.
- Arctic shows zero credentials in the shared store: if you intended to use slots, that is not fatal. Run `bash audit-map/16-scripts/arctic-slot-status.sh` and authenticate the intended slot with `bash audit-map/16-scripts/arctic-slot-login.sh <provider>:<slot>`.
- Live API drift: capture current outputs before changing assumptions.
- Backend startup failures: verify `.env`, DB reachability, and migrations.

## Recovery Order

1. Inspect `29-status/` and `30-checkpoints/`.
2. Tail the relevant log in `22-logs/`.
3. Reproduce manually only after the job status and command record are understood.
