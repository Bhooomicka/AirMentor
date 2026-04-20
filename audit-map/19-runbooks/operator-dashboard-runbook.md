# Operator Dashboard Runbook

## Purpose

Provide one operator view for:

- active pass
- queue head
- next-route decision
- slot reset windows
- detached session health
- suspected stale or blocked work

## Files

- Dashboard script: `audit-map/16-scripts/operator-dashboard.sh`
- Dashboard generator: `audit-map/16-scripts/operator-dashboard.py`
- Durable report: `audit-map/32-reports/operator-dashboard.md`

## Common Commands

One-shot terminal view:

```bash
bash audit-map/16-scripts/operator-dashboard.sh
```

One-shot plain view:

```bash
bash audit-map/16-scripts/operator-dashboard.sh --no-ansi
```

Write the durable report only:

```bash
bash audit-map/16-scripts/operator-dashboard.sh --write-only
```

Watch mode:

```bash
bash audit-map/16-scripts/operator-dashboard.sh --watch 15
```

Refresh usage first, then render:

```bash
bash audit-map/16-scripts/operator-dashboard.sh --refresh-usage
```

## Anti-Stall Behavior

`execute-pass-with-failover.sh` now supervises the live provider attempt.

If no progress signal is observed for the configured idle window, the attempt is treated as stuck:

- progress sources:
  - pass attempt log
  - last-message file
  - status file
  - checkpoint file
- default idle timeout:
  - `AUDIT_ATTEMPT_IDLE_TIMEOUT_SECONDS=1200`
- default poll interval:
  - `AUDIT_ATTEMPT_MONITOR_POLL_SECONDS=30`

On idle-timeout:

1. the attempt is marked with supervisor metadata
2. the provider process tree is terminated
3. the failure is classified as recoverable
4. failover/wait logic continues instead of hanging indefinitely

## Restart Safety

The orchestrator wrappers now avoid duplicate-session failures when the worker is already present.

The overnight orchestrator also reattaches to an already-running queue-head pass instead of trying to relaunch it.

## What To Watch

Healthy:

- `state=running`
- `tmux=present`
- low idle age
- supervisor state `watching`

Needs attention:

- `state=stale`
- `state=failed`
- `tmux=missing`
- idle age keeps growing on a running pass

## Current External Tooling Path

Keep the current dashboard dependency-light for now.

Future upgrades worth considering:

- Textual for a richer interactive TUI
- Gum for shell-native presentation improvements
- Watchexec for auto-refresh on file changes
