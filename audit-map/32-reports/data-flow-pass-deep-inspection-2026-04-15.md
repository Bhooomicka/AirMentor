# Data-Flow Pass Deep Inspection

Date: 2026-04-15
Pass: `data-flow-pass`
Context: `bootstrap`
Session: `audit-air-mentor-ui-bootstrap-data-flow-pass`

## Verdict

The pass appears stalled.

It is not fully dead at the process level, but it is no longer making meaningful audit progress and the overnight queue is effectively blocked behind it.

## Evidence

1. Detached job status still reports `state=running`, `provider=google`, `model=gemini-3.1-pro-preview`, and `tmux_present=1`.
2. The visible pass log stopped after the initial fallback and a few file reads:
   - `audit-map/index.md`
   - `audit-map/24-agent-memory/known-facts.md`
   - `audit-map/14-reconciliation/contradiction-matrix.md`
   - `audit-map/23-coverage/coverage-ledger.md`
3. The pass log file and attempt-2 log have not materially advanced since the original fallback launch window.
4. The wrapper shell, command shell, and failover shell are all sleeping in `do_wait`, which means they are waiting on a deeper child process rather than doing useful work themselves.
5. The real active child is an `arctic run` process for:
   - slot: `google-main`
   - model: `google/gemini-3.1-pro-preview`
6. That `arctic` process is still alive and has open sockets, but its activity is minimal and consistent with idle polling rather than meaningful forward progress.
7. The live internal Arctic log behind the running process shows a provider-side Google capacity failure:

   - HTTP `429`
   - `No capacity available for model gemini-3.1-pro-preview on the server`
   - `MODEL_CAPACITY_EXHAUSTED`

8. After that failure, the process stayed alive instead of terminating cleanly, and the orchestrator remained blocked behind the still-running pass.

## Operational Meaning

- The pass did start.
- Native Codex hit a usage limit first.
- Automatic failover to Google worked.
- The Google fallback then hit a provider-side capacity exhaustion condition.
- The process did not cleanly exit after that error.
- Because the tmux job still exists, the orchestrator still considers the pass active.

## Practical Status

- `data-flow-pass`: stalled
- `night-run-orchestrator`: still present, but blocked behind the stalled pass
- `usage-refresh-orchestrator`: separate and still useful for routing telemetry

## Safe Next Step

Do not trust the current `data-flow-pass` as actively progressing.

The correct next operator action is:

1. mark the current pass as stuck
2. stop or recover only that pass
3. relaunch it through the patched controller so bounded failover or manual-stop behavior happens correctly

## Commands Used For Inspection

```bash
bash audit-map/16-scripts/tmux-job-status.sh data-flow-pass bootstrap
tmux capture-pane -pt audit-air-mentor-ui-bootstrap-data-flow-pass -S -200
tail -n 120 audit-map/22-logs/audit-air-mentor-ui-bootstrap-data-flow-pass.log
ps -p 2910595,2910666,2910667,2914103,2914104,2915091 -o pid,ppid,etime,stat,%cpu,%mem,cmd
cat /proc/2915091/status
cat /proc/2915091/wchan
cat /proc/2915091/task/2915091/children
ls -l /proc/2915091/fd
tail -n 200 /proc/2915091/fd/17
ss -tpn | rg 'pid=2915091'
```
