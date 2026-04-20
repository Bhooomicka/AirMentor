# GitHub Pages Verification Runbook

Use this runbook for frontend-only deployment checks.

- URL: `https://raed2180416.github.io/AirMentor/`
- Primary checks:
  - HTML shell returns `200`
  - built asset paths start with `/AirMentor/`
  - frontend is wired to the expected API origin in runtime diagnostics

Capture HTML and headers into `17-artifacts/live/` and `18-snapshots/live/`.
