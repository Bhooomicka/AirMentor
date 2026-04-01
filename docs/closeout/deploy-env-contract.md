# Deploy Environment Contract

## Status
- This document now records the actual deploy-time contract enforced by the repo and its verification wrappers.
- Stage `08C` still has to append the final live closeout evidence references and pass row after the final suite completes.

## Canonical Live Targets
- GitHub Pages app URL: `https://raed2180416.github.io/AirMentor/`
- Canonical frontend origin for backend checks: `https://raed2180416.github.io`
- Railway public API URL: `https://api-production-ab72.up.railway.app/`
- GitHub Actions variables currently expose:
  - `AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=sysadmin`
  - `RAILWAY_ALLOWED_FRONTEND_ORIGIN=https://raed2180416.github.io`
  - `RAILWAY_PUBLIC_API_URL=https://api-production-ab72.up.railway.app`
  - `VITE_AIRMENTOR_API_BASE_URL=https://api-production-ab72.up.railway.app`

## Owning Repo Truth Anchors
- `.github/workflows/deploy-pages.yml`
- `.github/workflows/deploy-railway-api.yml`
- `scripts/verify-final-closeout-live.sh`
- `scripts/check-railway-deploy-readiness.mjs`
- `scripts/live-admin-common.sh`
- `air-mentor-api/src/startup-diagnostics.ts`
- `src/startup-diagnostics.ts`
- `tests/verify-final-closeout-live.test.ts`
- `tests/railway-deploy-readiness.test.ts`

## Frontend Deploy Contract
- GitHub Pages deploys from `main` via `.github/workflows/deploy-pages.yml`.
- The frontend build must receive `VITE_AIRMENTOR_API_BASE_URL` as an absolute HTTPS API URL for production-like origins.
- `src/startup-diagnostics.ts` rejects a production-like Pages origin when:
  - the API base URL is missing
  - the API base URL is relative
  - the API base URL is localhost
  - the API base URL is non-HTTPS under an HTTPS page
- Client telemetry may use the backend relay derived from the API base URL when no explicit telemetry sink is configured.

## Backend Deploy Contract
- Railway deploys from `main` via `.github/workflows/deploy-railway-api.yml`.
- Railway preflight and live verification depend on:
  - `RAILWAY_TOKEN`
  - `RAILWAY_SERVICE`
  - optional `RAILWAY_ENVIRONMENT`
  - `RAILWAY_PUBLIC_API_URL`
  - `EXPECTED_FRONTEND_ORIGIN` / `RAILWAY_ALLOWED_FRONTEND_ORIGIN`
  - `AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER`
  - `AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD`
- `air-mentor-api/src/startup-diagnostics.ts` defines the required production-like posture:
  - at least one allowed origin
  - `SESSION_COOKIE_SAME_SITE=none` for GitHub Pages cross-origin sessions
  - `SESSION_COOKIE_SECURE=true`
  - explicit `CSRF_SECRET`
  - non-loopback host/database warnings when production-like

## Live Verification Entry Points
### Closeout wrapper
- `scripts/verify-final-closeout-live.sh` is the canonical live closeout wrapper.
- It always runs:
  - runtime-route compatibility inventory
  - optional Railway preflight when Railway auth/context is available
  - live session-contract verification
  - live proof closure
  - live acceptance
  - live request flow
  - live teaching parity
  - live accessibility regression
  - live keyboard regression
  - live session-security regression

### Railway readiness script
- `scripts/check-railway-deploy-readiness.mjs` is the canonical preflight/session-contract/health verifier.
- It is expected to prove:
  - Railway config shape
  - cookie and CSRF posture for the Pages origin
  - health endpoint reachability
  - live session login/restore contract
  - optional diagnostics capture on failure

### Local-vs-live credential handling
- `scripts/live-admin-common.sh` intentionally falls back to seeded `sysadmin` / `admin1234` only for non-live local runs.
- When `AIRMENTOR_LIVE_STACK=1`, live verification must fail fast unless both:
  - `AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER`
  - `AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD`
  are present.

## Redaction Rules
- Live credentials are required to execute verification, but they are not allowed in:
  - ledger `env` blocks
  - evidence-index command strings
  - closeout support docs
- Recorded live commands must use placeholders such as `<identifier>` and `<password>`.
- Reports may state that a password was present, but must not persist its raw value.

## Verification Anchors
- `tests/verify-final-closeout-live.test.ts` proves:
  - live credentials are mandatory in live mode
  - Railway preflight is skipped cleanly when auth/context is absent
  - Railway preflight runs before the browser chain when auth/context exists
  - preflight failure stops the live closeout immediately
- `tests/railway-deploy-readiness.test.ts` proves:
  - preflight passes only with the expected Pages plus Railway cookie posture
  - missing `CSRF_SECRET` fails preflight
  - live session-contract verification handles warming-up and failure cases deterministically
- `air-mentor-api/tests/startup-diagnostics.test.ts` and `tests/frontend-startup-diagnostics.test.ts` prove the backend/frontend startup gates that this contract relies on.

## 08C Seal Requirements
- The final `08C` closeout must append:
  - the exact deploy workflow run ids used for the verified live stack
  - the exact deployed commit SHA
  - the final live session-contract artifact
  - the final live closeout artifact bundle
- Until those are written into the backbone, this contract is materially current but not yet fully sealed.
