# Operational Execution Rules

These rules are mandatory for every remaining closeout stage.

## Detached Execution
- Run every non-trivial verify, build, proof, and deploy command through `bash scripts/run-detached.sh <job-name> <command...>`.
- Detached jobs must write logs under `output/detached/` and survive terminal or IDE closure.
- When a detached job matters to stage proof, record the session/log path in commentary, the ledger notes, or both.

## Deploy-First Discipline
- Do not continue stage proof on a stale live stack.
- After frontend or backend changes that affect live-verified behavior, deploy the current surface first, then rerun the required live commands against the updated stack.
- Before expensive live browser reruns, confirm propagation with a cheap deterministic live probe. Prefer the exact proof bundle, checkpoint route, or build-metadata endpoint that the changed UI depends on instead of trusting CI or deploy-start signals alone.
- If the probe still returns stale, `null`, or inactive proof context, treat the issue as propagation lag until proven otherwise. Wait or redeploy before rewriting product code.
- Confirm the live stack is current before continuing:
  - Railway preflight/readiness checks pass.
  - GitHub Pages or the active frontend host serves the expected current bundle.
  - Live proof commands point at the deployed URLs that were just refreshed.

## Evidence Synchronization
- A stage is not `passed` until the ledger row, evidence manifest, and evidence index all reference the same artifact ids for that stage.
- `output/playwright/proof-evidence-manifest.json` must continue to use the top-level `artifacts` array and the existing artifact-record field shape.
- If a stage produces a new negative-path proof artifact, add it to the manifest, the evidence index, and the relevant assertion/coverage matrices in the same stage rather than deferring that recording work.

## Failure Memory
- Treat `AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER` and `AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD` as the canonical live system-admin credentials. Do not rely on implicit live defaults.
- Keep Railway readiness preflight in front of live verification and repair missing `CSRF_SECRET` or origin drift before deeper proof runs.
- When running `npm --workspace air-mentor-api run verify:live-session-contract` outside the wrapper, export both `RAILWAY_PUBLIC_API_URL` and `EXPECTED_FRONTEND_ORIGIN` explicitly.
- For live admin API lifecycle calls that depend on authenticated browser state, prefer browser-session cookies plus CSRF instead of cross-origin Node fetches that can diverge from live browser behavior.
- If the Railway live session contract returns `401 Invalid credentials`, treat that as credential drift first, correct `AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD`, and do not keep retrying until the live login rate limiter trips.
- If live auth was already rate-limited by a bad secret, use `scripts/railway-recovery-chain.sh` after the throttle window clears so the workflow rerun and live proof bar resume from a deterministic recovery path.
- If `scripts/playwright-admin-live-proof-risk-smoke.sh` reports `Another proof smoke run is already active`, treat it as a local harness lock collision first. Wait for the reported pid to exit, confirm the lock owner is gone, and only then rerun the proof command against the same deployed stack.
- If a newly deployed proof surface still shows `No active proof run`, stale checkpoint data, or `null` active run context, verify the underlying live proof bundle before assuming the code path is broken.
- Reuse the shared proof-shell owner only where the surface semantics actually match. Do not force tabbed proof panels onto intentionally all-visible surfaces such as the faculty proof panel, or you will hide evidence by default and create false parity failures. Use the shared hero or launcher pieces there unless the stage explicitly changes that contract.
- When touching `output/playwright/proof-evidence-manifest.json`, remember that the canonical list key is `artifacts`, not `items`.
- In the live faculties acceptance flow, clear restored workspace state before the refresh-leg parity checks so local session restore does not masquerade as product drift.
- If the live `Bands` tab becomes selected but the page body still lacks `Academic Bands` and `Save Scope Governance`, treat that as deployed frontend bundle drift first, not as a flaky selector. The current known signature is a live asset that still contains `Academic Bands` but reports `Save Scope Governance=0` and `Reset To Inherited Policy=0`.
- Do not force every proof-aware surface into the same navigation pattern during shared-shell work. Stable always-visible proof control planes can adopt the shared shell and launcher without being reauthored into tabs.
- If a refactor claims shared-owner adoption, prove it with explicit owner-marker and linkage assertions. Content-only assertions can stay green while the shared contract silently regresses.
- For new jsdom contract tests, prefer `createElement` harnesses or explicitly import the React runtime before using JSX. Otherwise the test layer can fail on `React is not defined` and waste time on a non-product issue.
- Any failed proof or acceptance command must be written into `output/playwright/defect-register.json` before the next retry.
- When a stage calls for a shared shell or shared contract, do not assume every surface must adopt the most opinionated variant. Apply only the shared owner pieces the surface actually needs, and do not convert always-visible proof sections into hidden tabs unless the stage explicitly requires that behavior and the tests are updated with intent.

## Detached Usage
```bash
bash scripts/run-detached.sh proof-rc npm run verify:proof-closure:proof-rc
bash scripts/run-detached.sh live-acceptance env AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=... AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=... PLAYWRIGHT_APP_URL=... PLAYWRIGHT_API_URL=... AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:acceptance
```

## Expected Outcome
- Future stages should spend time on new behavior, not on re-debugging terminal closure, stale deploys, missing live credentials, Railway readiness drift, or the already-diagnosed live Pages bundle mismatch.
