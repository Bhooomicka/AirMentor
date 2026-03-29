# Stage 02B - Proof Control Plane Completion

Hard stop: do not start unless `stage-02a-faculties-workspace-extraction-parity.md` is marked passed in the execution ledger, its artifacts are present in the evidence manifest/index, and no unresolved blocker tagged to `02A` remains open in the defect register.

Operational rule: run every non-trivial verify/build/deploy command through `bash scripts/run-detached.sh <job-name> <command...>`, deploy the current frontend/backend before live proof, and carry forward the lessons in `docs/closeout/operational-execution-rules.md` before continuing.


## Goal
- Complete the dedicated sysadmin proof control plane so it owns lifecycle, diagnostics, checkpoint playback, semester activation, import/crosswalk review, and operator readiness without leaning on unrelated hierarchy UI. The implementation is landed and repo-local plus deployed proof verifiers are green with no remaining predecessor blocker.

## Repo Truth Anchors
- `src/system-admin-proof-dashboard-workspace.tsx` exposes proof imports, run actions, queue diagnostics, worker diagnostics, checkpoint readiness, lifecycle audit, retained operational events, and semester activation controls.
- `air-mentor-api/src/modules/admin-proof-sandbox.ts` exposes proof run create/retry/activate/archive/recompute/restore routes plus `POST /api/admin/proof-runs/:simulationRunId/activate-semester`.
- `air-mentor-api/src/lib/proof-control-plane-dashboard-service.ts` computes proof queue/worker diagnostics for the dashboard.
- `air-mentor-api/src/lib/proof-control-plane-activation-service.ts` persists `activeOperationalSemester`, emits activation audit, and republishes proof-facing context.

## Inputs Required From Previous Stage
- `02A` ledger row
- extracted workspace parity evidence

## Allowed Change Surface
- `src/system-admin-proof-dashboard-workspace.tsx`
- extracted proof-control-plane services under `air-mentor-api/src/lib/`
- `air-mentor-api/src/modules/admin-proof-sandbox.ts`
- proof dashboard tests and proof smoke scripts

## Ordered Implementation Tasks
### backend
- Implemented `POST /api/admin/proof-runs/:simulationRunId/activate-semester`.
- Semester activation rebuilds offerings, ownership, checkpoint context, proof counts, and proof-facing UI context.
- Proof lifecycle logic stays in extracted services, not in the monolithic façade.

### frontend
- Proof control plane remains its own dedicated panel.
- Semester activation controls, explicit active-run context, and operator diagnostics are present.
- Checkpoint playback, queue diagnostics, import/crosswalk lifecycle, model diagnostics, and lifecycle audit remain visible without depending on the hierarchy pane.

### tests
- Service tests cover semester activation and operator diagnostics.
- Dashboard workspace tests cover the new control-plane affordances.

### evidence
- Proof-control-plane screenshots and diagnostics report references are recorded.
- The assertion matrix includes:
  - semester activation
  - queue/worker diagnostics
  - recent operational events

### non-goals
- Do not broaden proof logic into generic chat behavior.
- Do not hide degraded queue, checkpoint, or linkage conditions.

## Modularity Constraints
- All lifecycle or semester-rebuild behavior must live in extracted proof-control-plane services.
- Frontend proof controls belong in `src/system-admin-proof-dashboard-workspace.tsx` or helper components beside it, not in unrelated admin shells.

## Required Proof Before Exit
- Proof control plane is self-sufficient for imports, runs, checkpoints, diagnostics, and semester activation.
- Operator diagnostics are visible both locally and on the live stack.
- Existing proof smoke passes.

## Commands And Expected Artifacts
| Command | Expected Artifacts | Pass Signal |
| --- | --- | --- |
| `cd air-mentor-api && npx vitest run tests/proof-control-plane-dashboard-service.test.ts tests/admin-control-plane.test.ts tests/admin-proof-observability.test.ts` | backend test output; ledger reference | dashboard and observability tests pass |
| `npm test -- --run tests/system-admin-proof-dashboard-workspace.test.tsx tests/system-admin-accessibility-contracts.test.tsx` | frontend test output; ledger reference | proof dashboard workspace remains stable and accessible |
| `npm run verify:proof-closure:proof-rc` | local proof screenshots and reports; ledger reference | proof control plane passes locally |
| `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> npm run verify:proof-closure:live` | proof screenshots across admin/teacher/HoD/student | live proof control plane and dependent proof surfaces load correctly |

## Regression Watchlist
- Semester activation implemented directly in the monolithic façade
- Hidden or collapsed diagnostics that force operators back to logs or scripts
- Checkpoint playback regressions after activation changes

## Blockers That Stop The Next Stage
- Missing `activate-semester` contract
- Any failing proof smoke locally or live
- Any proof control action that still depends on unrelated hierarchy UI

## Current Execution Status
- `2026-03-30`: backend contract, persistence, API typing, frontend proof dashboard controls, and live-auth hardening landed in source.
- `2026-03-30`: repo-local proof passed, including targeted backend/frontend suites and `npm run verify:proof-closure:proof-rc`.
- `2026-03-30`: refreshed `LIVE-PROOF`, `LIVE-TEACHING`, and `LIVE-ACCEPTANCE` all passed on the deployed stack after Stage 02A re-cleared.
- `2026-03-30`: the predecessor blocker is gone, so Stage `02B` is formally passed.

## Exit Contract
- Stage `02B` is now `passed`; the proof-control-plane evidence is rerecorded without an open predecessor blocker.

## Handoff Update Required In Ledger
- `stageId: 02B`
- proof control-plane controls completed
- semester activation contract recorded
- local/live proof artifact references
