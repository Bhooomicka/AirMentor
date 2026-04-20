# Railway Verification Runbook

Use this runbook for backend-only deployment checks.

Primary checks:

- `GET /health`
- live session contract:
  - `npm --workspace air-mentor-api run verify:live-session-contract`
- deploy readiness diagnostics:
  - `node scripts/check-railway-deploy-readiness.mjs preflight`

Current warning:

- Bootstrap observed `404` on `/health`, so this runbook should be executed before trusting the deployed API.
