# Unattended Run Pass Prompt v2.0

Objective: prepare a pass for safe detached execution with checkpoints, bounded waits, deterministic stop conditions, and exact resume semantics.

Required outputs:

- queued command
- checkpoint seed
- stop conditions
- resume conditions
- current provider, account, slot, model, and reasoning posture
- manual-action behavior if credentials, provider readiness, or live access fail

Rules:

- do not treat launch success as completion
- require pass-specific status and checkpoint files before any blocker exit
- preserve queue state until the active pass reaches a terminal success state
