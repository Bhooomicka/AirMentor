# Stage 07B - Semester 1 To 3 Proof Walk

Hard stop: do not start unless `stage-07a-semester-activation-contract-and-seeded-data.md` is marked passed in the execution ledger, its artifacts are present in the evidence manifest/index, and no unresolved blocker tagged to `07A` remains open in the defect register.

Operational rule: run every non-trivial verify/build/deploy command through `bash scripts/run-detached.sh <job-name> <command...>`, deploy the current frontend/backend before live proof, and carry forward the lessons in `docs/closeout/operational-execution-rules.md` before continuing.


## Goal
- Prove that the first half of the proof trajectory, semesters 1 through 3, is fully materialized, explorable, and consistent across sysadmin, faculty profile, HoD, Risk Explorer, and Student Shell.

## Repo Truth Anchors
- `air-mentor-api/src/lib/proof-control-plane-seeded-semester-service.ts` already materializes seeded historical semester rows for semesters 1 through 5.
- `tests/proof-playback.test.ts` already proves playback selection persistence, which is required for repeatable semester walks.
- `src/pages/hod-pages.tsx`, `src/pages/risk-explorer.tsx`, and `src/pages/student-shell.tsx` already expose checkpoint and semester chips on proof-bound surfaces.
- `npm run verify:proof-closure:proof-rc` already runs the local proof walkthrough stack that produces the canonical proof screenshots.

## Inputs Required From Previous Stage
- `07A` ledger row
- semester activation evidence
- a ledger annotation naming the exact semester 1, 2, and 3 checkpoints chosen for proof walk coverage

## Allowed Change Surface
- extracted proof-control-plane services under `air-mentor-api/src/lib/`
- `air-mentor-api/src/modules/academic-proof-routes.ts`
- `src/system-admin-proof-dashboard-workspace.tsx`
- `src/pages/hod-pages.tsx`
- `src/pages/risk-explorer.tsx`
- `src/pages/student-shell.tsx`
- proof-playback and proof-risk tests/scripts

## Ordered Implementation Tasks
### backend
- Verify or fix seeded historical evidence so semesters 1 through 3 produce stable proof bundles, queue state, and stage summaries.
- Ensure semester 1 through 3 payloads expose the same provenance, checkpoint, and bounded-card fields as later semesters.
- Fix any early-semester gaps in stage summaries or proof route payloads through extracted services only.

### frontend
- Ensure sysadmin playback can activate and inspect semester 1 through 3 checkpoints without UI assumptions that only work for late semesters.
- Ensure faculty, HoD, Risk Explorer, and Student Shell all render semester 1 through 3 context clearly, including empty-state and low-signal cases.
- Keep semester-specific rendering logic local to extracted proof pages and shared proof helpers.

### tests
- Extend proof-playback and proof-page tests if semester 1 through 3 reveal missing chips, banners, or bounded-card fields.
- Extend backend proof-route tests if early-semester payload shaping differs from late-semester payloads.

### evidence
- Capture proof artifacts for semester 1, semester 2, and semester 3 and record which screenshot/report line proves each one.
- Update the assertion matrix for:
  - semester 1 proof walk
  - semester 2 proof walk
  - semester 3 proof walk
  - early-semester empty/degraded-state handling

### non-goals
- Do not skip early semesters because the UI is more interesting later in the run.
- Do not rely on one screenshot to stand in for all of semesters 1 through 3.
- Do not patch early-semester issues directly in monolithic proof façades.

## Modularity Constraints
- Early-semester fixes belong in extracted seeded-semester, stage-summary, and proof-route helpers.
- Frontend semester-walk behavior belongs in proof dashboard and proof pages, not in root shells.
- Evidence mapping must point to exact semester-specific artifacts, not generic “proof passed” notes.

## Required Proof Before Exit
- Semesters 1, 2, and 3 are all reachable and proven across the proof-control plane and teaching proof surfaces.
- Early-semester proof payloads remain bounded and provenance-correct.
- The evidence ledger explicitly names the artifact proving each semester.

## Commands And Expected Artifacts
| Command | Expected Artifacts | Pass Signal |
| --- | --- | --- |
| `cd air-mentor-api && npx vitest run tests/hod-proof-analytics.test.ts tests/risk-explorer.test.ts tests/student-agent-shell.test.ts` | backend test output; ledger reference | early-semester proof payloads and guardrails pass |
| `npm test -- --run tests/proof-playback.test.ts tests/hod-pages.test.ts tests/risk-explorer.test.tsx tests/student-shell.test.tsx` | frontend test output; ledger reference | early-semester playback and proof pages pass |
| `npm run verify:proof-closure:proof-rc` | `output/playwright/system-admin-proof-control-plane.png`, `output/playwright/teacher-proof-panel.png`, `output/playwright/teacher-risk-explorer-proof.png`, `output/playwright/hod-proof-analytics.png`, `output/playwright/hod-risk-explorer-proof.png`, `output/playwright/student-shell-proof.png` | local semester 1-3 proof walk passes |
| `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> npm run verify:proof-closure:live` | `output/playwright/system-admin-proof-control-plane.png`, `output/playwright/teacher-proof-panel.png`, `output/playwright/teacher-risk-explorer-proof.png`, `output/playwright/hod-proof-analytics.png`, `output/playwright/hod-risk-explorer-proof.png`, `output/playwright/student-shell-proof.png` | live semester 1-3 proof walk passes |

## Regression Watchlist
- Early semesters missing provenance or checkpoint fields that later semesters have
- Proof pages rendering only late-semester assumptions
- Evidence ledger failing to distinguish semester 1/2/3 proof

## Blockers That Stop The Next Stage
- Any semester 1, 2, or 3 proof path lacking explicit artifact coverage
- Any mismatch between early-semester backend payloads and frontend proof cards
- Any local/live proof-walk failure for the chosen early-semester checkpoints

## Exit Contract
- Stage `07B` is `passed` only when semesters 1 through 3 are individually proven across sysadmin and teaching proof surfaces with explicit artifact mapping.

## Handoff Update Required In Ledger
- `stageId: 07B`
- semester 1/2/3 proof checkpoints named
- artifact-to-semester mapping attached
- local/live proof references recorded
