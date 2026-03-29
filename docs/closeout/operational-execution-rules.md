# Operational Execution Rules

These rules are mandatory for every remaining closeout stage.

## Detached Execution
- Run every non-trivial verify, build, proof, and deploy command through `bash scripts/run-detached.sh <job-name> <command...>`.
- Detached jobs must write logs under `output/detached/` and survive terminal or IDE closure.
- When a detached job matters to stage proof, record the session/log path in commentary, the ledger notes, or both.

## Deploy-First Discipline
- Do not continue stage proof on a stale live stack.
- After frontend or backend changes that affect live-verified behavior, deploy the current surface first, then rerun the required live commands against the updated stack.
- Confirm the live stack is current before continuing:
  - Railway preflight/readiness checks pass.
  - GitHub Pages or the active frontend host serves the expected current bundle.
  - Live proof commands point at the deployed URLs that were just refreshed.

## Failure Memory
- Treat `AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER` and `AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD` as the canonical live system-admin credentials. Do not rely on implicit live defaults.
- Keep Railway readiness preflight in front of live verification and repair missing `CSRF_SECRET` or origin drift before deeper proof runs.
- When running `npm --workspace air-mentor-api run verify:live-session-contract` outside the wrapper, export both `RAILWAY_PUBLIC_API_URL` and `EXPECTED_FRONTEND_ORIGIN` explicitly.
- For live admin API lifecycle calls that depend on authenticated browser state, prefer browser-session cookies plus CSRF instead of cross-origin Node fetches that can diverge from live browser behavior.
- If the Railway live session contract returns `401 Invalid credentials`, treat that as credential drift first, correct `AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD`, and do not keep retrying until the live login rate limiter trips.
- If live auth was already rate-limited by a bad secret, use `scripts/railway-recovery-chain.sh` after the throttle window clears so the workflow rerun and live proof bar resume from a deterministic recovery path.
- In the live faculties acceptance flow, clear restored workspace state before the refresh-leg parity checks so local session restore does not masquerade as product drift.
- If the live `Bands` tab becomes selected but the page body still lacks `Academic Bands` and `Save Scope Governance`, treat that as deployed frontend bundle drift first, not as a flaky selector. The current known signature is a live asset that still contains `Academic Bands` but reports `Save Scope Governance=0` and `Reset To Inherited Policy=0`.
- Any failed proof or acceptance command must be written into `output/playwright/defect-register.json` before the next retry.

## Detached Usage
```bash
bash scripts/run-detached.sh proof-rc npm run verify:proof-closure:proof-rc
bash scripts/run-detached.sh live-acceptance env AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=... AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=... PLAYWRIGHT_APP_URL=... PLAYWRIGHT_API_URL=... AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:acceptance
```

## Expected Outcome
- Future stages should spend time on new behavior, not on re-debugging terminal closure, stale deploys, missing live credentials, Railway readiness drift, or the already-diagnosed live Pages bundle mismatch.
