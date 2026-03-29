# Stage 02A - Faculties Workspace Extraction Parity

Hard stop: do not start unless `stage-01b-proof-count-parity-and-provenance.md` is marked passed in the execution ledger, its artifacts are present in the evidence manifest/index, and no unresolved blocker tagged to `01B` remains open in the defect register.

Operational rule: run every non-trivial verify/build/deploy command through `bash scripts/run-detached.sh <job-name> <command...>`, deploy the current frontend/backend before live proof, and carry forward the lessons in `docs/closeout/operational-execution-rules.md` before continuing.


## Goal
- Verify and preserve the extracted faculties workspace as the authoritative sysadmin editing surface for governance, curriculum, and semester controls. The source implementation, repo-local proof, and refreshed live acceptance/teaching parity are all green on the deployed stack.
- The extracted workspace is the authoritative sysadmin editing surface for academic terms, semester navigation, curriculum rows, course-leader assignment, provisioning launch points, policy editing, and stage-policy editing.

## Repo Truth Anchors
- `src/system-admin-faculties-workspace.tsx` renders the authoritative governance tabs, stage-policy editor, term and curriculum editors, course-leader assignment controls, and provisioning surface directly inside the extracted workspace.
- `src/system-admin-hierarchy-workspace-shell.tsx` already provides the extracted shell that later stages should preserve.
- `src/system-admin-live-app.tsx` remains the composition and state container that passes data and handlers into the extracted workspace.

## Inputs Required From Previous Stage
- `01B` ledger row
- proof count parity artifacts

## Allowed Change Surface
- `src/system-admin-faculties-workspace.tsx`
- `src/system-admin-hierarchy-workspace-shell.tsx`
- narrow extracted editor components/helpers created during this stage
- matching backend/editor tests

## Ordered Implementation Tasks
### backend
- Expose any missing editor endpoints already required by the extracted workspace.
- Keep backend changes narrow and service-backed; this stage is mainly about route/UI parity, not new product behavior.

### frontend
- Preserve extracted-workspace ownership for governance, stage-policy, curriculum, semester navigation, course-leader assignment, and provisioning.
- Ensure semester navigation, year selection, curriculum rows, and course-leader assignment all function from the extracted workspace without requiring a fallback to legacy shells.

### tests
- Add focused tests for extracted workspace parity and tab/panel linkage.
- Re-run system-admin accessibility contract tests after any extraction changes.

### evidence
- Capture before/after parity notes in the ledger.
- Update the coverage matrix to show the faculties workspace as the authoritative editor owner.

### non-goals
- Do not redesign proof diagnostics here.
- Do not defer parity work by leaving placeholder “to be wired” blocks.

## Modularity Constraints
- New extracted editors must live beside the workspace, not inside `src/system-admin-live-app.tsx`.
- If a shared editor is needed by both the extracted workspace and a detail view, extract it once and wire both callers to it.

## Required Proof Before Exit
- No governance or stage-policy placeholder blocks remain in the extracted workspace.
- The extracted workspace performs the required admin editing flows directly.
- Accessibility contracts for workspace tabs and panels remain intact.

## Commands And Expected Artifacts
| Command | Expected Artifacts | Pass Signal |
| --- | --- | --- |
| `npm test -- --run tests/system-admin-faculties-workspace.test.tsx tests/system-admin-accessibility-contracts.test.tsx tests/system-admin-live-data.test.ts tests/system-admin-proof-dashboard-workspace.test.tsx` | frontend test output; ledger reference | extracted workspace tests pass |
| `npm run verify:final-closeout` | existing local closeout artifacts; ledger reference | no regression in broader admin proof flows |
| `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:acceptance` | `system-admin-live-acceptance-report.json`, `system-admin-live-acceptance.png` | extracted workspace edits are reachable on live stack |
| `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:teaching-parity` | `system-admin-teaching-parity-smoke.png` | admin-to-teaching propagation survives extraction |

## Regression Watchlist
- Placeholder copy still present after wiring
- Editors only working in legacy live shell but not extracted workspace
- Tab focus or panel linkage regressions

## Blockers That Stop The Next Stage
- Any remaining extraction-placeholder block
- Any live acceptance failure in the faculties workspace
- Any parity gap that still requires using the legacy editor path

## Current Execution Status
- `2026-03-30`: repo-local extracted-workspace parity and accessibility proof passed through `tests/system-admin-faculties-workspace.test.tsx` and `tests/system-admin-accessibility-contracts.test.tsx` inside the targeted frontend verifier.
- `2026-03-30`: refreshed `LIVE-TEACHING` passed and rerecorded `output/playwright/system-admin-teaching-parity-smoke.png`.
- `2026-03-30`: refreshed `LIVE-ACCEPTANCE` passed across Overview, Bands, CE / SEE, CGPA Formula, Stage Gates, Courses, and Provision on the deployed stack.
- `2026-03-30`: `DEF-02A-LIVE-GITHUB-PAGES-BANDS-DRIFT` is closed.

## Exit Contract
- Stage `02A` is now `passed`; the deployed frontend bundle serves the extracted faculties workspace parity path and the refreshed `LIVE-ACCEPTANCE` artifacts are green.

## Handoff Update Required In Ledger
- `stageId: 02A`
- pass row appended after live acceptance and teaching parity re-cleared on the deployed stack
- extracted editor owners recorded
- local/live parity proof references
