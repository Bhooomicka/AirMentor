# Stage 07C - Semester 4 To 6 Proof Walk

Hard stop: do not start unless `stage-07b-semester-1-to-3-proof-walk.md` is marked passed in the execution ledger, its artifacts are present in the evidence manifest/index, and no unresolved blocker tagged to `07B` remains open in the defect register.

Operational rule: run every non-trivial verify/build/deploy command through `bash scripts/run-detached.sh <job-name> <command...>`, deploy the current frontend/backend before live proof, and carry forward the lessons in `docs/closeout/operational-execution-rules.md` before continuing.

## Carry-Forward Failure Memory
- Before expensive live browser reruns, confirm deploy propagation with a cheap deterministic live probe against the exact dependency that changed, such as the proof bundle, checkpoint route, or build metadata.
- If live proof still shows stale, `null`, or inactive checkpoint context right after deploy, treat propagation lag or stale live stack as the first hypothesis and prove otherwise before changing product code.
- Reuse the shared proof-shell owner only where the target surface actually matches the tab contract. Do not force tabbed proof panels onto intentionally all-visible surfaces such as the faculty proof panel unless the stage explicitly changes that behavior and updates the tests.
- Do not mark the stage `passed` until `output/playwright/execution-ledger.jsonl`, `output/playwright/proof-evidence-manifest.json`, and `output/playwright/proof-evidence-index.md` all carry the same stage artifact ids.
- When updating `output/playwright/proof-evidence-manifest.json`, preserve the top-level `artifacts` array and the established artifact-record shape; do not invent alternate keys such as `items`.
- If the stage uncovers an invalid-checkpoint, denied-path, or stale-proof negative path, record it as a first-class artifact and link it in the assertion and coverage documents during the same stage.
- Do not force every proof-aware surface into the same navigation pattern. If a surface is already stable as an always-visible control plane, adopt the shared shell and launcher without hiding working sections behind new tabs.
- When a stage depends on a shared owner or extracted primitive, add explicit contract assertions for owner markers and linkage semantics. Content-only assertions are not enough to prove shared-contract adoption.
- When adding new jsdom contract tests, prefer `createElement` harnesses or explicitly import the React runtime before using JSX. Otherwise the test layer can fail on `React is not defined` and waste time on a non-product issue.
- Shared shell adoption does not mean every proof surface must gain tabs. Keep always-visible proof sections visible when the surface only needs the shared hero and launcher, and treat hiding previously visible evidence as a behavioral change that requires an explicit stage decision plus updated tests.

## Goal
- Prove the late trajectory, semesters 4 through 6, including queue pressure, checkpoint blocking, elective fit visibility, and final-stage proof behavior.

## Repo Truth Anchors
- `src/system-admin-proof-dashboard-workspace.tsx` already exposes checkpoint-readiness, blocked progression, and selected-checkpoint banners that are most stressed in late semesters.
- `src/pages/risk-explorer.tsx` and `src/pages/student-shell.tsx` already show blocked-stage messaging and no-action comparator notes tied to the selected checkpoint.
- `air-mentor-api/src/lib/proof-control-plane-stage-summary-service.ts` and related playback governance services already synthesize checkpoint summaries that late semesters depend on.
- `scripts/system-admin-live-keyboard-regression.mjs` already exercises checkpoint selection through the late proof stages.

## Inputs Required From Previous Stage
- `07B` ledger row
- explicit semester 1-3 artifact mapping
- late-semester defect-register notes for blocking queue, post-SEE, elective-fit, or final-stage behavior

## Allowed Change Surface
- extracted proof-control-plane stage-summary, playback, and tail services under `air-mentor-api/src/lib/`
- `air-mentor-api/src/modules/academic-proof-routes.ts`
- `src/system-admin-proof-dashboard-workspace.tsx`
- `src/pages/hod-pages.tsx`
- `src/pages/risk-explorer.tsx`
- `src/pages/student-shell.tsx`
- proof-playback/keyboard/proof-risk tests and scripts

## Ordered Implementation Tasks
### backend
- Verify or fix semester 4 through 6 stage summaries, queue projections, elective-fit visibility, and blocked-stage semantics.
- Ensure late-semester payloads expose checkpoint blocking state, no-action comparator data, and final-stage provenance consistently.
- Keep late-stage fixes in extracted proof services, not in monolithic proof-control-plane files.

### frontend
- Ensure the proof dashboard, faculty profile, HoD, Risk Explorer, and Student Shell all render late-semester blocked-state and final-stage context correctly.
- Ensure keyboard and playback navigation remain stable through late checkpoints and reset flows.
- Keep elective-fit, checkpoint blocking, and final-stage messaging explicit instead of deriving them from generic risk cards.

### tests
- Extend backend proof tests for late-semester blocking, no-action comparator exposure, and final-stage summaries.
- Extend frontend tests for blocked-state chips, elective-fit visibility, and late-stage playback banners.

### evidence
- Capture proof artifacts for semester 4, semester 5, and semester 6 and record the exact screenshot/report reference for each.
- Update the assertion matrix for:
  - semester 4 proof walk
  - semester 5 proof walk
  - semester 6 proof walk
  - blocked-stage and post-SEE/final-stage behavior

### non-goals
- Do not assume passing semester 6 proves semesters 4 and 5.
- Do not hide blocked-stage semantics in internal notes only.
- Do not fix late-stage behavior by weakening early-semester invariants from `07B`.

## Modularity Constraints
- Late-semester proof behavior belongs in extracted stage-summary/playback/tail services and proof pages.
- Keyboard/playback behavior remains owned by shared proof-shell helpers plus the proof dashboard workspace.
- Evidence mapping must distinguish semesters 4, 5, and 6 individually.

## Required Proof Before Exit
- Semesters 4, 5, and 6 are all proven individually.
- Blocked-stage, elective-fit, and final-stage semantics are visible and consistent across proof surfaces.
- Keyboard/playback navigation remains stable through the late trajectory locally and live.

## Commands And Expected Artifacts
| Command | Expected Artifacts | Pass Signal |
| --- | --- | --- |
| `cd air-mentor-api && npx vitest run tests/hod-proof-analytics.test.ts tests/risk-explorer.test.ts tests/student-agent-shell.test.ts tests/proof-control-plane-dashboard-service.test.ts` | backend test output; ledger reference | late-semester proof summaries and blocking semantics pass |
| `npm test -- --run tests/proof-playback.test.ts tests/system-admin-proof-dashboard-workspace.test.tsx tests/hod-pages.test.ts tests/risk-explorer.test.tsx tests/student-shell.test.tsx` | frontend test output; ledger reference | late-stage playback, banners, and proof pages pass |
| `npm run verify:proof-closure:proof-rc` | `output/playwright/system-admin-proof-control-plane.png`, `output/playwright/teacher-proof-panel.png`, `output/playwright/teacher-risk-explorer-proof.png`, `output/playwright/hod-proof-analytics.png`, `output/playwright/hod-risk-explorer-proof.png`, `output/playwright/student-shell-proof.png` | local semester 4-6 proof walk passes |
| `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> npm run verify:proof-closure:live` | `output/playwright/system-admin-proof-control-plane.png`, `output/playwright/teacher-proof-panel.png`, `output/playwright/teacher-risk-explorer-proof.png`, `output/playwright/hod-proof-analytics.png`, `output/playwright/hod-risk-explorer-proof.png`, `output/playwright/student-shell-proof.png` | live semester 4-6 proof walk passes |
| `npm run playwright:admin-live:keyboard-regression` | `output/playwright/system-admin-live-keyboard-regression-report.json`, `output/playwright/system-admin-live-keyboard-regression.png` | local late-stage keyboard playback passes |
| `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:keyboard-regression` | `output/playwright/system-admin-live-keyboard-regression-report.json`, `output/playwright/system-admin-live-keyboard-regression.png` | live late-stage keyboard playback passes |

## Regression Watchlist
- Late-stage blocked-state flags drifting between dashboard and teaching surfaces
- Elective-fit visible only on one proof route
- Final-stage keyboard flows breaking reset or restore behavior

## Blockers That Stop The Next Stage
- Any missing distinct artifact coverage for semester 4, 5, or 6
- Any late-stage blocking/elective/final-state mismatch across surfaces
- Any keyboard regression on late-stage playback locally or live

## Exit Contract
- Stage `07C` is `passed` only when semesters 4 through 6 are individually proven and late-stage behavior is stable across proof routes locally and live.

## Handoff Update Required In Ledger
- `stageId: 07C`
- semester 4/5/6 artifact mapping attached
- late-stage blocked/elective/final-state proof recorded
- local/live keyboard and proof references logged
