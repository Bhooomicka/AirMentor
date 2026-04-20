# Workflow Behavior Map

Pass: `workflow-automation-pass`
Context: `bootstrap`
Date: `2026-04-15`

## Scope

- `.github/workflows/ci-verification.yml`
- `.github/workflows/deploy-pages.yml`
- `.github/workflows/deploy-railway-api.yml`
- `.github/workflows/proof-browser-cadence.yml`
- `.github/workflows/verify-live-closeout.yml`
- Workflow-invoked script surfaces under `scripts/` and `air-mentor-api/package.json` command bindings

## Environment Drift Check (Prompt Assumptions vs Status Truth)

- Prompt queue context targets `provider=codex`, `account=codex-04`, `model=gpt-5.3-codex`, `reasoning=xhigh`; status file currently records this exact route as active (`audit-map/29-status/audit-air-mentor-ui-bootstrap-workflow-automation-pass.status`).
- Live verification assumptions remain drifted from environment capabilities: prior blockers (`getaddrinfo EBUSY`, cancelled browser MCP calls, missing live creds in shell) remain active in memory/status artifacts and are not resolved by workflow definitions alone.
- No provider/account switch occurred inside this pass.

## Workflow Registry (Execution-System View)

| Workflow | Trigger and scope | Job graph | Primary side effects | Artifacts | External surfaces touched | What it actually proves | What it does not prove |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `ci-verification.yml` | `pull_request`, `push main`, manual dispatch | `repo-hygiene` + `lint-guardrails` + `lint` + `frontend` + `backend-fast` (parallel, shared checkout/install pattern) | Fails build on banned-file regressions, lint/test/build failures; validates key startup/telemetry lint slices | None uploaded | GitHub Actions runners only | Repo hygiene gates, frontend tests/build, backend fast suite execution in CI | No live deployment semantics, no authenticated live parity, no Railway/Pages runtime truth |
| `deploy-pages.yml` | `push main`, manual dispatch | `build` -> `deploy` | Builds frontend with `VITE_AIRMENTOR_API_BASE_URL`, publishes `dist` to Pages environment | Pages artifact via `actions/upload-pages-artifact` | GitHub Pages environment | Deployment pipeline can publish built shell/assets to Pages | No post-deploy semantic smoke, no live login/session proof, no API contract validation |
| `deploy-railway-api.yml` | `push main` on `air-mentor-api/**` and readiness-script/workflow path changes; manual dispatch | single `deploy` job with conditional steps keyed by `steps.railway-config.outputs.ready` | Optional Railway variable preflight/sync, API build, Railway CLI deploy, optional health and session-contract checks, optional diagnostics upload on failure | `air-mentor-api/output` uploaded as `railway-api-diagnostics` on failure | Railway CLI/API + optionally live Railway public URL | If fully configured, can prove deploy command execution plus preflight policy checks and session contract | If env vars/secrets missing, workflow can skip deployment and checks without failing; no proof-risk semantic parity proof |
| `proof-browser-cadence.yml` | `push main` on `src/**`, `air-mentor-api/**`, `scripts/**`, workflow file; weekly cron Monday 03:00 UTC; manual dispatch | `proof-rc` -> matrix `browser-suites` (6 scripts) | Runs backend proof-rc suite; executes browser scripts named "admin-live-*" | None uploaded | Local CI runner runtime (seeded stack by default script behavior) | Repeated local browser contract coverage and proof-rc backend suite cadence | Does not inherently prove live Pages/Railway behavior because `AIRMENTOR_LIVE_STACK=1`, `PLAYWRIGHT_APP_URL`, and `PLAYWRIGHT_API_URL` are not set |
| `verify-live-closeout.yml` | manual dispatch only | `live-semester-walk` -> `live-closeout` | Runs explicit live semester walk then full closeout chain with live env wiring | `live-semester-walk-artifacts`, `live-closeout-artifacts` | GitHub Pages URL + Railway URL via env, Playwright browser | Strongest workflow-level live semantic proof path when credentials and vars are present | Manual-only trigger and credential dependency; if live env drifts or creds absent, workflow cannot prove parity |

## Trigger/Input/Output/Side-Effect Details

### 1) `ci-verification.yml`

- Trigger conditions:
  - Pull requests and pushes to `main` always run full verification fan-out.
- Inputs and assumptions:
  - Node 20, npm cache, workspace install succeeds with `npm ci`.
- Job behaviors:
  - `repo-hygiene` enforces banned-path invariants and rejects committed temp artifacts (`tmp_*.cjs`, `air-mentor-api/output`).
  - `lint-guardrails` pins lint for startup diagnostics and telemetry slices across frontend/backend critical files.
  - `frontend` and `backend-fast` split contract breadth: frontend test/build and backend fast test suite.
- Semantic blind spots:
  - Green CI can coexist with live semantic drift (`/health` mismatch, auth flow drift, fallback-heavy live inference posture).

### 2) `deploy-pages.yml`

- Trigger conditions:
  - Push to `main` and manual dispatch.
- Inputs and assumptions:
  - `vars.VITE_AIRMENTOR_API_BASE_URL` controls runtime API base embedding.
- Side effects:
  - Uploads `dist` to Pages artifact and deploys to `github-pages` environment.
- Blind spots:
  - No workflow-native post-deploy browser/API checks; deploy success proves publish mechanics, not route/surface semantics.

### 3) `deploy-railway-api.yml`

- Trigger conditions:
  - Pushes touching backend subtree/readiness script/workflow file; manual dispatch.
- Inputs and assumptions:
  - Requires `RAILWAY_TOKEN` and `RAILWAY_SERVICE` for deploy readiness.
  - Optional validation gates depend on `vars.RAILWAY_PUBLIC_API_URL` and live admin credentials.
- Side effects:
  - Can mutate Railway service variables (`SYNC_RAILWAY_SERVICE_VARS=true`) through preflight script.
  - Deploys via `railway up --ci` and captures stdout/stderr logs to `air-mentor-api/output`.
  - On failure, gathers diagnostics (`deployment list`, logs, build logs, health poll output).
- What readiness script enforces:
  - Cookie/CORS/session env posture (`CSRF_SECRET`, `CORS_ALLOWED_ORIGINS`, `SESSION_COOKIE_SECURE=true`, `SESSION_COOKIE_SAME_SITE=none`).
  - DATABASE safety check against local default URL.
  - Optional boot smoke and deploy-path smoke via embedded Postgres local harness.
  - Live health/session-contract verification against public Railway URL.
- Blind spots and false-confidence risk:
  - If core Railway secrets/vars are absent, workflow reports "skipping" and exits cleanly; branch can look green without deployment truth.
  - Even with health/session checks, no direct proof of cross-role same-student parity or proof-risk artifact freshness in live UI.

### 4) `proof-browser-cadence.yml`

- Trigger conditions:
  - Weekly scheduled cadence + pushes in broad frontend/backend/scripts areas.
- Inputs and assumptions:
  - Installs Playwright Firefox and runs six browser scripts via matrix.
  - No explicit live-stack env injection in workflow.
- Side effects:
  - Repeated browser smoke execution pressure on local-seeded path (unless script env overridden externally).
- Blind spots:
  - Script names include `admin-live`, but workflow defaults still run local seeded stack behavior in these wrappers when `AIRMENTOR_LIVE_STACK` is unset.
  - This can create perceived live confidence from non-live execution.

### 5) `verify-live-closeout.yml`

- Trigger conditions:
  - Manual dispatch only.
- Inputs and assumptions:
  - Hardwired `PLAYWRIGHT_APP_URL` to Pages URL.
  - `PLAYWRIGHT_API_URL` from `vars.RAILWAY_PUBLIC_API_URL`.
  - Requires live admin identifier/password vars/secrets.
- Side effects:
  - Semester walk across target semesters (`1..6`) and artifact prefixing for reproducible live evidence.
  - Full closeout orchestration (`verify-final-closeout-live.sh`) with optional proof-smoke dedup via `SKIP_PROOF_CLOSURE_LIVE=1`.
- What it proves (when fully configured):
  - End-to-end authenticated live chain including acceptance/request-flow/teaching-parity/accessibility/keyboard/session-security.
- Blind spots:
  - Manual-only entry and secret provisioning remain a human gate; automation does not guarantee cadence execution.

## Script Coupling Graph (Workflow -> Script -> Product Surface)

- `proof-browser-cadence.yml` matrix scripts ->
  - `scripts/playwright-admin-live-proof-risk-smoke.sh` -> `scripts/system-admin-proof-risk-smoke.mjs` -> sysadmin proof control plane + teacher/HoD/student-shell/risk-explorer parity surfaces and checkpoint playback persistence.
  - `scripts/playwright-admin-live-request-flow.sh` -> `scripts/system-admin-live-request-flow.mjs` -> sysadmin requests list/detail/deep-link and transition flow.
  - `scripts/playwright-admin-live-teaching-parity.sh` -> `scripts/system-admin-teaching-parity-smoke.mjs` -> sysadmin-to-teaching data parity and proof summary consistency across roles.
  - `scripts/playwright-admin-live-accessibility-regression.sh` -> `scripts/system-admin-live-accessibility-regression.mjs` -> page/fragment accessibility scans and accessibility-tree assertions.
  - `scripts/playwright-admin-live-keyboard-regression.sh` -> `scripts/system-admin-live-keyboard-regression.mjs` -> keyboard-only navigation contracts on requests/modals/proof playback/role switching.
  - `scripts/playwright-admin-live-acceptance.sh` -> `scripts/system-admin-live-acceptance.mjs` -> broad sysadmin hierarchy/request acceptance path.
- `verify-live-closeout.yml` -> `scripts/verify-final-closeout-live.sh` -> chained verification runner:
  - route inventory clean assertion
  - optional Railway preflight
  - live session-contract verification
  - live Playwright suites for acceptance/request/teaching/accessibility/keyboard/session security.
- `deploy-railway-api.yml` -> `scripts/check-railway-deploy-readiness.mjs` -> deployment env policy enforcement + boot smoke + health/session diagnostics.

## Workflow-Only Drift and Blind-Spot Ledger

1. `proof-browser-cadence.yml` can run "live"-named scripts in local-seeded mode by default, which weakens live-confidence semantics.
2. `deploy-pages.yml` has no post-deploy semantic verification stage; successful deployment does not prove route/action correctness.
3. `deploy-railway-api.yml` allows clean skip when required vars/secrets are absent, so green workflow state can hide non-deployment.
4. `deploy-railway-api.yml` health/session checks are conditional on `RAILWAY_PUBLIC_API_URL`; absent var suppresses production contract checks.
5. `verify-live-closeout.yml` is manual-dispatch only; no scheduled safety net guarantees regular live-semantic revalidation.

## Pass Output Contract

- Covered:
  - Full workflow-by-workflow behavior system mapping with trigger/job/side-effect/blind-spot decomposition.
  - Downstream script coupling to product surfaces and evidence artifact outputs.
- Updated files:
  - `audit-map/09-workflow-automation/workflow-behavior-map.md` (new)
- Contradictions found:
  - No new contradiction added in this pass; existing C-001 and C-006 remain active.
- Risks discovered:
  - Workflow-level false confidence from conditional skips and local-vs-live ambiguity in cadence runs.
- Routing/provider/account changes:
  - None.
- Caveman:
  - Not used.
- Live verification performed:
  - No direct live execution in this pass; this is workflow/system mapping only.
- Next pass recommendation:
  - `script-behavior-pass` to decompose the long-tail non-workflow helper scripts and guarantee-level semantics.
- Manual checkpoint required:
  - No new manual checkpoint required for this mapping pass itself.

## Evidence Anchors

- Workflows:
  - `.github/workflows/ci-verification.yml`
  - `.github/workflows/deploy-pages.yml`
  - `.github/workflows/deploy-railway-api.yml`
  - `.github/workflows/proof-browser-cadence.yml`
  - `.github/workflows/verify-live-closeout.yml`
- Script layer:
  - `scripts/check-railway-deploy-readiness.mjs`
  - `scripts/verify-final-closeout-live.sh`
  - `scripts/playwright-admin-live-proof-risk-smoke.sh`
  - `scripts/playwright-admin-live-acceptance.sh`
  - `scripts/playwright-admin-live-request-flow.sh`
  - `scripts/playwright-admin-live-teaching-parity.sh`
  - `scripts/playwright-admin-live-accessibility-regression.sh`
  - `scripts/playwright-admin-live-keyboard-regression.sh`
  - `scripts/playwright-admin-live-session-security.sh`
  - `scripts/live-admin-common.sh`
  - `scripts/playwright-browser-common.sh`
- Node command bindings:
  - `package.json`
  - `air-mentor-api/package.json`
