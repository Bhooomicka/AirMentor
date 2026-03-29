# Stage 07A - Semester Activation Contract And Seeded Data

Hard stop: do not start unless `stage-06b-provisioning-permissions-and-bulk-mentor-assignment.md` is marked passed in the execution ledger, its artifacts are present in the evidence manifest/index, and no unresolved blocker tagged to `06B` remains open in the defect register.

Operational rule: run every non-trivial verify/build/deploy command through `bash scripts/run-detached.sh <job-name> <command...>`, deploy the current frontend/backend before live proof, and carry forward the lessons in `docs/closeout/operational-execution-rules.md` before continuing.


## Goal
- Add the public semester-activation contract and align seeded proof data with it so sysadmin can switch the proof control plane to a specific operational semester using an explicit, auditable API.

## Repo Truth Anchors
- `air-mentor-api/src/lib/proof-control-plane-seeded-semester-service.ts` already builds seeded historical semesters and the semester-six proof rows internally.
- `air-mentor-api/src/lib/proof-control-plane-seeded-bootstrap-service.ts` already prepares seeded proof runs and auto-activates the run itself when requested.
- `air-mentor-api/src/modules/admin-proof-sandbox.ts` already supports run create/retry/activate/archive/recompute/restore, but `POST /api/admin/proof-runs/:simulationRunId/activate-semester` does not exist yet.
- `src/system-admin-proof-dashboard-workspace.tsx` already exposes run actions and checkpoint playback, which makes it the correct frontend owner for semester activation controls.

## Inputs Required From Previous Stage
- `06B` ledger row
- provisioning/permission/mentor-linkage evidence
- defect-register entries for semester activation, seeded data drift, or missing semester provenance

## Allowed Change Surface
- `air-mentor-api/src/modules/admin-proof-sandbox.ts`
- extracted proof-control-plane services under `air-mentor-api/src/lib/`
- `src/system-admin-proof-dashboard-workspace.tsx`
- `src/api/client.ts`
- `src/api/types.ts`
- proof dashboard, API-client, and openapi tests

## Ordered Implementation Tasks
### backend
- Add `POST /api/admin/proof-runs/:simulationRunId/activate-semester` with explicit request/response payloads and audit events.
- Extend proof-facing payloads with `activeOperationalSemester` wherever the active semester must be visible after activation.
- Rebuild or rehydrate semester-scoped proof context through extracted services, not through direct edits in `air-mentor-api/src/lib/msruas-proof-control-plane.ts`.

### frontend
- Add semester activation controls and active-semester state to `src/system-admin-proof-dashboard-workspace.tsx`.
- Ensure proof dashboard, playback banners, and downstream academic proof routes all reflect the newly active operational semester.
- Keep API wiring in `src/api/client.ts` and shared types, not inline inside page components.

### tests
- Extend backend route/service coverage for semester activation and any derived payload changes.
- Extend API-client and proof-dashboard tests for the new activation call and `activeOperationalSemester` rendering.

### evidence
- Capture local and live proof-risk artifacts after semester activation.
- Record the request/response JSON used for semester activation and link it in the evidence ledger.
- Update the assertion matrix for:
  - `activate-semester` public contract
  - `activeOperationalSemester` payload exposure
  - semester activation controls in the proof dashboard

### non-goals
- Do not treat internal seeded-semester services as sufficient proof of a public activation contract.
- Do not place semester activation logic directly into monolithic proof-control-plane files.
- Do not let the frontend infer the active semester from checkpoint labels alone.

## Modularity Constraints
- Semester activation belongs in extracted proof-control-plane route/service layers and the proof dashboard workspace.
- `src/system-admin-proof-dashboard-workspace.tsx` is the only frontend owner for activation controls.
- Shared types and API client contracts must carry the new activation semantics explicitly.

## Required Proof Before Exit
- The proof control plane exposes a public semester-activation contract.
- Active operational semester is explicit in backend and frontend proof context.
- Local and live proof walkthroughs confirm that semester activation changes visible proof state.

## Commands And Expected Artifacts
| Command | Expected Artifacts | Pass Signal |
| --- | --- | --- |
| `cd air-mentor-api && npx vitest run tests/proof-control-plane-dashboard-service.test.ts tests/admin-proof-observability.test.ts tests/openapi.test.ts` | backend test output; ledger reference | semester-activation contract and observability pass |
| `npm test -- --run tests/system-admin-proof-dashboard-workspace.test.tsx tests/api-client.test.ts tests/proof-playback.test.ts` | frontend test output; ledger reference | activation controls and playback contract pass |
| `npm run playwright:admin-live:proof-risk` | `output/playwright/system-admin-proof-control-plane.png`, `output/playwright/teacher-proof-panel.png`, `output/playwright/teacher-risk-explorer-proof.png`, `output/playwright/hod-proof-analytics.png`, `output/playwright/hod-risk-explorer-proof.png`, `output/playwright/student-shell-proof.png` | local semester activation and proof walkthrough pass |
| `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:proof-risk` | `output/playwright/system-admin-proof-control-plane.png`, `output/playwright/teacher-proof-panel.png`, `output/playwright/teacher-risk-explorer-proof.png`, `output/playwright/hod-proof-analytics.png`, `output/playwright/hod-risk-explorer-proof.png`, `output/playwright/student-shell-proof.png` | live semester activation and proof walkthrough pass |

## Regression Watchlist
- Active semester shown in the UI but not carried by the backend contract
- Semester activation mutating playback state in ways not recorded by audit/provenance
- New activation logic landing inside monolithic proof-control-plane code

## Blockers That Stop The Next Stage
- Missing `POST /api/admin/proof-runs/:simulationRunId/activate-semester`
- Missing `activeOperationalSemester` in proof-facing payloads
- Any local/live proof walkthrough failure after semester activation

## Exit Contract
- Stage `07A` is `passed` only when semester activation is public, auditable, explicit in payloads, and proven locally and live.

## Handoff Update Required In Ledger
- `stageId: 07A`
- semester-activation contract completed
- active operational semester evidence attached
- local/live proof artifact references
