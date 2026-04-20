# Live vs Local Master Diff

Aggregate all confirmed live-vs-local mismatches here.

## Confirmed Alignment

- GitHub Pages root and `#/admin` still resolve to the `air-mentor-ui` HTML shell, and the bootstrap shell remains byte-identical to a clean committed `HEAD` Pages-style build.
  - Evidence: `audit-map/17-artifacts/live/2026-04-15T221302Z--pages-root--live--html-shell--bootstrap.html`, `audit-map/17-artifacts/live/2026-04-15T164511Z--pages-shell--live--web-observation--live-pass.md`, `audit-map/17-artifacts/live/2026-04-15T174110Z--pages-shell--live--web-observation--live-pass.md`, `audit-map/17-artifacts/diffs/2026-04-15T164515Z--pages-root--diff--head-parity--live-pass.md`

## Confirmed Contradiction

- Railway still has an unresolved readiness mismatch. Local code and Railway config still expect `/health`, but the latest direct artifact shows `404` with `x-railway-fallback: true`.
  - Expected by code: `air-mentor-api/src/app.ts`, `air-mentor-api/railway.json`
  - Live evidence: `audit-map/17-artifacts/live/2026-04-15T221301Z--railway-health--live--headers--bootstrap.txt`, `audit-map/17-artifacts/live/2026-04-15T221301Z--railway-health--live--body--bootstrap.txt`
  - Current blocker: `audit-map/17-artifacts/live/2026-04-15T174110Z--live-capture-path--live--environment-blocker--live-pass.md`

## Current Live Verification Blockers

- The current shell still does not have the live URLs or live credentials exported, so this pass cannot lawfully advance past preconditions without manual env injection.
  - Evidence: `audit-map/17-artifacts/live/2026-04-16T182112Z--live-env-contract--live--credential-blocker--parity-pass.md`
- Authenticated live semantic verification is still blocked because the canonical live closeout wrapper requires explicit live system-admin credentials and this shell does not have them.
  - Evidence: `audit-map/17-artifacts/live/2026-04-15T164512Z--live-closeout--live--credential-blocker--live-pass.txt`, `audit-map/17-artifacts/live/2026-04-15T174110Z--live-closeout--live--credential-blocker--live-pass.txt`, `audit-map/17-artifacts/live/2026-04-16T182112Z--live-env-contract--live--credential-blocker--parity-pass.md`
- Fresh terminal-side live capture is still blocked in the native Codex shell because direct Node fetches fail with `getaddrinfo EBUSY` for both Pages and Railway hostnames, and Playwright MCP calls are cancelled before navigation.
  - Evidence: `audit-map/17-artifacts/live/2026-04-15T174110Z--live-capture-path--live--environment-blocker--live-pass.md`, `audit-map/17-artifacts/live/2026-04-16T110353Z--playwright-mcp--live--browser-cancelled--parity-pass.md`, `audit-map/17-artifacts/live/2026-04-16T182112Z--live-fetch-path--live--ebusy-blocker--parity-pass.md`
- Safe same-target proof parity capture is still blocked because the current repo's proof/parity helper chain mutates live proof lifecycle or faculty records before parity is proven.
  - Evidence: `audit-map/17-artifacts/live/2026-04-16T110353Z--live-proof-parity-safety--code-audit--parity-pass.md`, `audit-map/10-live-behavior/live-same-student-parity.md`
- The live parity control plane still needs manual reconciliation because the pass status/checkpoint can regress into dead `running` states after the worker is gone.
  - Evidence: `audit-map/17-artifacts/live/2026-04-16T182112Z--live-parity-status--live--stale-running-control-plane--parity-pass.md`, `audit-map/29-status/audit-air-mentor-ui-live-live-credentialed-parity-pass.status`, `audit-map/30-checkpoints/audit-air-mentor-ui-live-live-credentialed-parity-pass.checkpoint`

## Same-Student Parity Position (2026-04-16)

- Local same-student parity is now durably mapped in `audit-map/32-reports/same-student-cross-surface-parity-report.md`.
- Local directly observed parity exists for the explicit checkpoint fixture `mnc_student_001 / 1MS23MC001 / run_001 / checkpoint_001 / semester 6 / Post TT1` across faculty-profile, HoD, risk explorer, and student shell render contracts.
- Fresh backend DB-backed parity rerun is blocked in this shell by sandbox `listen EPERM: operation not permitted 127.0.0.1`, so route-level parity relies on committed backend tests plus code inspection rather than a fresh listener-backed run.
- Live same-target parity remains blocked by `C-015`, `C-017`, and `C-019`: no safe read-only observer, the documented Railway public URL still fails the session contract, and Railway redeploy/recovery is billing-blocked.
- Local contradiction `C-021` is now resolved: current faculty / HoD / risk-explorer / student-shell fallback slices remain checkpoint-explicit when semester pointers diverge. Remaining risk is live same-target capture, not local provenance relabeling.

## Workflow-Level Drift Risks (Local vs Live Truth)

- `proof-browser-cadence.yml` executes scripts named `playwright-admin-live-*`, but without explicit `AIRMENTOR_LIVE_STACK=1` and live URL injection those wrappers default to local seeded startup, so cadence success can be interpreted as live semantic proof when it is not.
- `deploy-pages.yml` publishes artifacts but does not run post-deploy semantic checks, so deployment success can drift from user-visible route/role/action correctness.
- `deploy-railway-api.yml` may skip deploy/verify branches when vars/secrets are absent (`RAILWAY_TOKEN`, `RAILWAY_SERVICE`, `RAILWAY_PUBLIC_API_URL`, live credentials), producing non-failing runs that do not prove deployed API truth.

## Uncovered Semantic Live Scope

- System-admin login, overview, faculties workspace, governed request flow, proof semester walk, teaching parity, HoD proof/risk, student-shell proof parity, accessibility regression, keyboard regression, session security, and fresh Railway `/`, `/health`, `/openapi.json`, plus session-contract capture.
