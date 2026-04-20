# Artifact Naming Convention

Use:

`YYYY-MM-DDTHHMMSSZ--surface--environment--artifact-type--slug.ext`

Examples:

- `2026-04-15T001500Z--pages-root--live--html-shell--bootstrap.html`
- `2026-04-15T001520Z--railway-health--live--http-response--bootstrap.txt`
- `2026-04-15T003000Z--proof-dashboard--live--screenshot--sysadmin.png`

Rules:

- use UTC timestamps
- include environment: `local`, `live`, or `diff`
- include surface name, not just tool name
- never overwrite prior timestamped artifacts
