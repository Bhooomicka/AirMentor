# Stage 08A - Role E2E Sysadmin Course Leader Mentor

Hard stop: do not start unless `stage-07c-semester-4-to-6-proof-walk.md` is marked passed in the execution ledger, its artifacts are present in the evidence manifest/index, and no unresolved blocker tagged to `07C` remains open in the defect register.

Operational rule: run every non-trivial verify/build/deploy command through `bash scripts/run-detached.sh <job-name> <command...>`, deploy the current frontend/backend before live proof, and carry forward the lessons in `docs/closeout/operational-execution-rules.md` before continuing.


## Goal
- Run a strict end-to-end proof pass for the Sysadmin, Course Leader, and Mentor journey now that hierarchy, proof control, semester walkthroughs, and provisioning contracts are complete.

## Repo Truth Anchors
- `scripts/verify-final-closeout.sh` already chains lint, runtime-route inventory, proof closure, local acceptance, request flow, teaching parity, accessibility regression, keyboard regression, and session security.
- `scripts/system-admin-live-acceptance.mjs` already exercises the sysadmin create/edit/request flow.
- `scripts/system-admin-teaching-parity-smoke.mjs` already validates the sysadmin-to-faculty-profile parity handoff.
- `scripts/system-admin-proof-risk-smoke.mjs` already captures system admin, teacher, risk-explorer, HoD, and student proof screenshots.

## Inputs Required From Previous Stage
- `07C` ledger row
- full semester-walk proof artifacts
- updated matrices for semesters `1` through `6`

## Allowed Change Surface
- role-specific proof scripts under `scripts/`
- narrowly scoped backend or frontend fixes discovered during end-to-end verification
- `docs/closeout/assertion-traceability-matrix.md`
- `docs/closeout/sysadmin-teaching-proof-coverage-matrix.md`

## Ordered Implementation Tasks
### backend
- Fix only end-to-end defects that block Sysadmin, Course Leader, or Mentor flows after reproducing them with owned proof commands.
- Keep fixes in the owning request, proof, access, or provisioning modules.
- Preserve public contracts introduced earlier; do not collapse them into ad hoc test-only behavior.

### frontend
- Fix only end-to-end defects that block sysadmin launch, request handling, faculty-profile parity, mentor-visible proof, or risk-explorer/student-shell returns.
- Keep UI fixes in extracted owners rather than backsliding into large integration files.

### tests
- Re-run the targeted role-flow suites after every defect fix.
- Keep the end-to-end stage evidence tied to existing scripts and reports.

### evidence
- Produce one clean local artifact set covering sysadmin, Course Leader, and Mentor.
- Produce the matching live artifact set on GitHub Pages plus Railway.
- Update the matrices with any newly discovered role-path edge cases or corrected commands.

### non-goals
- Do not broaden this stage into HoD/session-security closeout; that belongs to `08B`.
- Do not edit `final-authoritative-plan.md`.

## Modularity Constraints
- Any fixes discovered here must land in the owning module or workspace extracted in earlier stages.
- `src/App.tsx`, `src/system-admin-live-app.tsx`, `air-mentor-api/src/modules/academic.ts`, and `air-mentor-api/src/lib/msruas-proof-control-plane.ts` remain thin integration files only.

## Required Proof Before Exit
- Sysadmin can launch, navigate, operate requests, and reach the proof system.
- Course Leader and Mentor can reach faculty profile parity and downstream proof views from both direct teaching mode and sysadmin handoff.
- Local and live artifacts agree on the successful role journey.

## Commands And Expected Artifacts
| Command | Expected Artifacts | Pass Signal |
| --- | --- | --- |
| `npm run verify:proof-closure:proof-rc` | proof screenshots in `output/playwright/`; ledger reference | local proof stack for teacher-facing surfaces passes |
| `npm run playwright:admin-live:acceptance` | `output/playwright/system-admin-live-acceptance-report.json`, `output/playwright/system-admin-live-acceptance.png` | local sysadmin end-to-end flow passes |
| `npm run playwright:admin-live:request-flow` | `output/playwright/system-admin-live-request-flow-report.json`, `output/playwright/system-admin-live-request-flow.png` | local governed request journey passes |
| `npm run playwright:admin-live:teaching-parity` | `output/playwright/system-admin-teaching-parity-smoke.png` | local sysadmin-to-teaching parity passes |
| `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> npm run verify:proof-closure:live` | refreshed live proof screenshots; ledger reference | live teacher-facing proof stack passes |
| `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:acceptance` | refreshed live acceptance artifacts; ledger reference | live sysadmin end-to-end flow passes |
| `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:request-flow` | refreshed live request-flow artifacts; ledger reference | live governed request journey passes |
| `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:teaching-parity` | refreshed live teaching-parity artifact; ledger reference | live sysadmin-to-teaching parity passes |

## Regression Watchlist
- Local role flows passing while live parity fails because of origin, cookie, or deployed data assumptions
- Mentor-visible proof surfaces regressing after semester-walk changes
- End-to-end defects patched in root files instead of owning modules

## Blockers That Stop The Next Stage
- Any failing sysadmin, Course Leader, or Mentor end-to-end artifact locally or live
- Any mismatch between sysadmin handoff and direct teaching-mode proof context
- Any unresolved role-path blocker left unlogged in the defect register

## Exit Contract
- Stage `08A` is `passed` only when Sysadmin, Course Leader, and Mentor flows are proven end to end with matching local and live evidence.

## Handoff Update Required In Ledger
- `stageId: 08A`
- role-path artifacts used for proof
- defects found and fixed during role e2e
- matrix updates completed

