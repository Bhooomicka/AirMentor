# Stage 08B - Role E2E HoD Student Session Security

Hard stop: do not start unless `stage-08a-role-e2e-sysadmin-course-leader-mentor.md` is marked passed in the execution ledger, its artifacts are present in the evidence manifest/index, and no unresolved blocker tagged to `08A` remains open in the defect register.

Operational rule: run every non-trivial verify/build/deploy command through `bash scripts/run-detached.sh <job-name> <command...>`, deploy the current frontend/backend before live proof, and carry forward the lessons in `docs/closeout/operational-execution-rules.md` before continuing.


## Goal
- Prove the HoD and student-facing closeout journey end to end, including session, CSRF, origin, and denied-path behavior on the live deployment.

## Repo Truth Anchors
- `scripts/system-admin-live-session-security.mjs` and `scripts/playwright-admin-live-session-security.sh` already drive local and live session-security verification.
- `scripts/verify-final-closeout-live.sh` already runs the cross-origin live session contract before the live playwright sweeps.
- `air-mentor-api/src/startup-diagnostics.ts` and `src/startup-diagnostics.ts` already encode production-like origin and cookie expectations.
- `tests/api-client.test.ts`, `tests/frontend-startup-diagnostics.test.ts`, `air-mentor-api/tests/session.test.ts`, and `air-mentor-api/tests/startup-diagnostics.test.ts` already cover important client/server session and startup contract behavior.
- HoD, risk explorer, and student shell proof surfaces are already exercised by the proof-closure scripts from earlier stages.

## Inputs Required From Previous Stage
- `08A` ledger row
- sysadmin/Course Leader/Mentor end-to-end artifacts
- updated matrices for those role paths

## Allowed Change Surface
- session, startup-diagnostics, academic-access, and proof-route modules
- client session handling and diagnostics modules
- session-security/accessibility scripts
- `docs/closeout/assertion-traceability-matrix.md`
- `docs/closeout/sysadmin-teaching-proof-coverage-matrix.md`

## Ordered Implementation Tasks
### backend
- Fix only HoD/student/session-security defects reproduced through the owned verification commands.
- Preserve secure cookie, CSRF, origin, and denied-path behavior across local and live modes.
- Keep session or access fixes in session/access/diagnostics modules, not scattered through feature routes.

### frontend
- Fix only HoD/student-shell/risk-explorer/session issues that surface in end-to-end or startup/session diagnostics.
- Keep client CSRF/session handling in the API client and diagnostics helpers.
- Preserve explicit denied-access messaging and safe recovery paths after session expiry.

### tests
- Re-run targeted HoD, student, API client, startup diagnostics, and session suites after every defect fix.
- Keep the live session contract command authoritative for deployed verification.

### evidence
- Produce a clean local artifact set for HoD/student proof and session security.
- Produce a clean live artifact set for cross-origin session contract, HoD/student proof, and denied paths.
- Update the matrices for session, CSRF, origin, HoD, student shell, and denied-path coverage.

### non-goals
- Do not skip directly to final closeout without logging every residual issue here.
- Do not weaken session or access checks to make scripts pass.

## Modularity Constraints
- Session and access fixes belong in `src/api/client.ts`, startup diagnostics helpers, session modules, and academic access modules.
- Do not patch around live-cookie or CSRF defects inside page components.

## Required Proof Before Exit
- HoD analytics, risk explorer, and student shell all work end to end locally and live.
- Cross-origin live session contract passes on GitHub Pages plus Railway.
- Denied paths and session expiry behavior remain explicit and safe.

## Commands And Expected Artifacts
| Command | Expected Artifacts | Pass Signal |
| --- | --- | --- |
| `cd air-mentor-api && npx vitest run tests/session.test.ts tests/startup-diagnostics.test.ts tests/academic-access.test.ts` | backend vitest output; ledger reference | session, diagnostics, and access rules stay correct |
| `npm test -- --run tests/api-client.test.ts tests/frontend-startup-diagnostics.test.ts tests/hod-pages.test.ts tests/student-shell.test.tsx tests/risk-explorer.test.tsx` | frontend vitest output; ledger reference | client session handling, denied paths, and HoD/student proof surfaces remain correct |
| `npm run playwright:admin-live:session-security` | `output/playwright/system-admin-live-session-security-report.json` | local session-security smoke passes |
| `npm run verify:proof-closure:proof-rc` | proof screenshots in `output/playwright/`; ledger reference | local HoD/student proof surfaces remain healthy |
| `RAILWAY_PUBLIC_API_URL=<railway-url> EXPECTED_FRONTEND_ORIGIN=<pages-origin> AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> npm --workspace air-mentor-api run verify:live-session-contract` | `air-mentor-api/output/railway-live-session-contract.json` or fresh session-contract output; ledger reference | live cross-origin cookie and CSRF contract passes |
| `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:session-security` | refreshed live session-security report; ledger reference | live session-security smoke passes |
| `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> npm run verify:proof-closure:live` | refreshed live proof screenshots; ledger reference | live HoD/student proof surfaces remain healthy |

## Regression Watchlist
- Session or CSRF fixes that work locally but fail on GitHub Pages cross-origin deployment
- Session expiry leaving ambiguous UI instead of explicit denied or re-auth flows
- HoD/student proof routes weakening access rules to make tests pass

## Blockers That Stop The Next Stage
- Any failing live session contract
- Any failing local/live HoD or student proof artifact
- Any denied-path regression or insecure session workaround

## Exit Contract
- Stage `08B` is `passed` only when HoD, student shell, risk explorer, session, CSRF, and origin behavior are proven locally and live with no weakened protections.

## Handoff Update Required In Ledger
- `stageId: 08B`
- session-security and live-session-contract artifact references
- HoD/student proof artifact references
- denied-path coverage note

