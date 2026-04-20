# Detached Execution Rules

- If a task may outlive the current terminal, start it through `tmux-start-job.sh`.
- If `tmux` is missing, stop and record the fallback; do not silently downgrade to fragile foreground mode for overnight work.
- Restarting a job must reuse the same deterministic session name and status/checkpoint paths.
