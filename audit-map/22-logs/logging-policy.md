# Logging Policy

- Logs live in `22-logs/`.
- Each detached job gets one primary log named after the deterministic session slug.
- Logs must capture the launched command, UTC start time, UTC end time, and exit status.
- Human summaries belong in Markdown; raw logs belong in `.log` or `.json`.
