# Background Execution Policy

- Any task expected to outlive the terminal must run in detached `tmux`.
- Every background job must emit:
  - log file
  - status file
  - checkpoint file
  - command record
- If a job needs login, confirmation, or missing credentials, it must stop and write the exact action required.
