# Stage 04B - HoD, Risk Explorer, And Student Shell Parity

Hard stop: do not start unless `stage-04a-faculty-profile-course-leader-mentor-parity.md` is marked passed in the execution ledger, its artifacts are present in the evidence manifest/index, and no unresolved blocker tagged to `04A` remains open in the defect register.

Operational rule: run every non-trivial verify/build/deploy command through `bash scripts/run-detached.sh <job-name> <command...>`, deploy the current frontend/backend before live proof, and carry forward the lessons in `docs/closeout/operational-execution-rules.md` before continuing.


## Goal
- Make HoD analytics, risk explorer, and student shell consume the same proof evidence, checkpoint state, and scoped totals as teacher and sysadmin surfaces.

## Repo Truth Anchors
- `src/pages/hod-pages.tsx` already renders live HoD analytics, read-only checkpoint overlay, faculty operations, reassessment audit, and student launch actions.
- `src/pages/student-shell.tsx` and `src/pages/risk-explorer.tsx` already expose proof-section markup and scoped evidence panels.
- `tests/hod-pages.test.ts`, `tests/risk-explorer.test.tsx`, and `tests/student-shell.test.tsx` already assert proof-section contracts and denial states.
- `air-mentor-api/tests/hod-proof-analytics.test.ts`, `air-mentor-api/tests/risk-explorer.test.ts`, and `air-mentor-api/tests/student-agent-shell.test.ts` cover backend proof surfaces.
- `scripts/system-admin-live-accessibility-regression.mjs` and `scripts/system-admin-live-keyboard-regression.mjs` already walk HoD, risk explorer, and student shell on the live stack.

## Inputs Required From Previous Stage
- `04A` ledger row
- teaching parity artifacts
- updated traceability rows for faculty proof parity

## Allowed Change Surface
- `src/pages/hod-pages.tsx`
- `src/pages/risk-explorer.tsx`
- `src/pages/student-shell.tsx`
- `src/academic-workspace-route-surface.tsx`
- `air-mentor-api/src/modules/academic-proof-routes.ts`
- extracted proof-facing services for HoD analytics, student shell, and risk explorer

## Ordered Implementation Tasks
### backend
- Ensure HoD analytics, risk explorer, and student shell derive from the same persisted proof evidence, checkpoint selection, and active operational semester as teacher and sysadmin proof panels.
- Make denied-path behavior explicit for out-of-scope student or faculty attempts, invalid semester selection, and stale checkpoint restoration.
- Keep HoD analytics read-only with lifecycle control remaining exclusively on the sysadmin proof control plane.

### frontend
- Remove false “No active proof run” behavior when valid proof context exists.
- Make risk explorer and student shell show the same checkpoint banner, scope descriptor, and provenance language as the corresponding teacher/HoD surfaces.
- Preserve reliable back-navigation to the calling proof surface without losing selected checkpoint or proof context.

### tests
- Extend backend proof analytics coverage for HoD watchlists, risk-explorer evidence, student-shell session ownership, and invalid access behavior.
- Extend frontend coverage for tab linkage, proof-section parity, error/denied states, and checkpoint-aligned navigation back to the caller.
- Reuse the live accessibility and keyboard suites to verify these surfaces in deployment.

### evidence
- Capture one HoD analytics screenshot, one HoD-to-student drilldown, one risk explorer screenshot, and one student shell screenshot for the same proof context.
- Capture denied-path evidence for at least one out-of-scope or invalid-access attempt.
- Update the coverage matrix rows for HoD overview, course hotspots, faculty operations, reassessment audit, risk explorer, and student shell.

### non-goals
- Do not move proof lifecycle actions into HoD or student-facing surfaces.
- Do not replace the shared proof shell contract here; that belongs to the next stage.

## Modularity Constraints
- Keep surface logic in `src/pages/hod-pages.tsx`, `src/pages/risk-explorer.tsx`, `src/pages/student-shell.tsx`, or extracted helpers beside them.
- `src/academic-workspace-route-surface.tsx` remains a routing and composition layer only.
- Backend proof composition stays in `air-mentor-api/src/modules/academic-proof-routes.ts` and extracted services, not in `air-mentor-api/src/modules/academic.ts`.

## Required Proof Before Exit
- HoD analytics, risk explorer, and student shell all display the same checkpoint-aligned proof context for the same student/scope.
- Read-only HoD analytics never impersonate proof lifecycle control.
- Negative-path evidence exists for denied/out-of-scope proof access locally and live.

## Commands And Expected Artifacts
| Command | Expected Artifacts | Pass Signal |
| --- | --- | --- |
| `cd air-mentor-api && npx vitest run tests/hod-proof-analytics.test.ts tests/risk-explorer.test.ts tests/student-agent-shell.test.ts tests/academic-access.test.ts` | backend test output; ledger reference | HoD/risk/student proof parity and denial behavior pass |
| `npm test -- tests/hod-pages.test.ts tests/risk-explorer.test.tsx tests/student-shell.test.tsx` | frontend test output; ledger reference | HoD, risk explorer, and student shell proof contracts pass |
| `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> npm run verify:proof-closure:live` | `output/playwright/hod-proof-analytics.png`; `output/playwright/hod-risk-explorer-proof.png`; `output/playwright/student-shell-proof.png` | live proof surfaces render and align |
| `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:keyboard-regression` | `output/playwright/system-admin-live-keyboard-regression-report.json`; `output/playwright/system-admin-live-keyboard-regression.png` | checkpoint-aligned navigation and return paths pass |
| `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:accessibility-regression` | `output/playwright/system-admin-live-accessibility-report.json`; `output/playwright/system-admin-live-accessibility-regression.png` | live accessibility tree and scoped proof surfaces pass |

## Regression Watchlist
- HoD falling into a false empty or inactive-proof state while teacher/sysadmin show active proof data
- Risk explorer and student shell reading different checkpoint or semester context
- Back-navigation dropping proof playback selection or opening the wrong caller surface

## Blockers That Stop The Next Stage
- Any proof-facing HoD/risk/student surface diverges on checkpoint, scope, or totals
- Denied-path evidence is missing
- Live keyboard or accessibility proof fails for these surfaces

## Exit Contract
- Stage `04B` is `passed` only when HoD analytics, risk explorer, and student shell are checkpoint-aligned with teacher/sysadmin proof surfaces and negative-path evidence is captured.

## Handoff Update Required In Ledger
- `stageId: 04B`
- HoD/risk/student parity status
- denied-path evidence references
- unresolved checkpoint or access defects
