# Session Naming Policy

Format:

`audit-<project-slug>-<context-slug>-<pass-slug>`

Example:

`audit-air-mentor-ui-local-inventory-pass`

Rules:

- lowercase ASCII only
- deterministic from project, context, and pass
- no timestamps in the session name itself
- timestamps belong in artifact names and status history
