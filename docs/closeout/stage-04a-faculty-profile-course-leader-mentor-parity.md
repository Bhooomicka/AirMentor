# Stage 04A - Faculty Profile, Course Leader, And Mentor Parity

Hard stop: do not start unless `stage-03b-sysadmin-hierarchy-students-faculty.md` is marked passed in the execution ledger, its artifacts are present in the evidence manifest/index, and no unresolved blocker tagged to `03B` remains open in the defect register.

Operational rule: run every non-trivial verify/build/deploy command through `bash scripts/run-detached.sh <job-name> <command...>`, deploy the current frontend/backend before live proof, and carry forward the lessons in `docs/closeout/operational-execution-rules.md` before continuing.


## Goal
- Align faculty profile, course-leader, and mentor surfaces to the same authoritative proof context, counts, scope labels, and partial-profile drilldowns used by sysadmin.

## Repo Truth Anchors
- `src/academic-workspace-route-surface.tsx` is the extracted route owner for faculty-profile, course-leader, mentor, queue-history, risk explorer, and student shell entry points.
- `FacultyProfilePage` is still imported from `src/App.tsx`, which remains a monolith and should only keep a thin integration role.
- `tests/faculty-profile-proof.test.tsx` already asserts proof sections such as `proof-mode-authority`, `active-run-contexts`, `checkpoint-overlay`, `monitoring-queue`, and `elective-fit`.
- `scripts/system-admin-teaching-parity-smoke.mjs` already validates sysadmin to teaching-profile parity on the live stack.
- `air-mentor-api/src/modules/academic-proof-routes.ts` is the backend owner for proof-facing academic runtime routes.

## Inputs Required From Previous Stage
- `03B` ledger row
- hierarchy/student/faculty parity artifacts
- updated traceability rows for scoped faculty payloads

## Allowed Change Surface
- `src/academic-workspace-route-surface.tsx`
- extracted faculty-profile, course-leader, or mentor helpers created beside the academic workspace surface
- thin integration hooks in `src/App.tsx` only if extraction requires it
- `air-mentor-api/src/modules/academic-proof-routes.ts`
- extracted proof-facing services used by academic runtime routes

## Ordered Implementation Tasks
### backend
- Ensure faculty profile, course-leader, mentor, queue-history, and related academic runtime payloads all expose `scopeDescriptor`, `resolvedFrom`, `scopeMode`, `countSource`, and `activeOperationalSemester`.
- Keep proof-scoped counts authoritative for faculty load, mentor gaps, requests, monitored students, and queue state whenever a proof run or proof semester is active.
- Preserve the separation between faculty permissions and teaching ownership across all academic runtime endpoints.

### frontend
- Move any remaining large faculty-profile-specific behavior out of `src/App.tsx` into extracted academic workspace owners while keeping `src/App.tsx` as a thin integration hook.
- Ensure every student mention from faculty profile, mentor views, queue history, and course-leader flows opens the mapped partial profile, not a dead-end label.
- Remove any remaining mixed-count display such as institution-sized totals on proof-scoped teaching views.

### tests
- Extend backend academic parity tests for faculty profile, mentor scope, queue counts, and proof provenance fields.
- Extend frontend faculty-profile coverage and route-surface coverage for proof sections, partial-profile launches, and scoped counts.
- Keep the live teaching-parity suite as the source of truth for deployed parity.

### evidence
- Capture one faculty profile proof panel, one mentor view, one queue-history proof, and one course-leader proof panel for the same scope.
- Capture the same faculty profile path on GitHub Pages + Railway.
- Update both the assertion matrix and coverage matrix for faculty profile, teacher proof panel, mentor list, and queue history.

### non-goals
- Do not redesign HoD analytics here.
- Do not introduce new proof shell chrome before the shared proof-shell stage.

## Modularity Constraints
- `src/academic-workspace-route-surface.tsx` is the route owner; keep feature-specific rendering in extracted academic surface helpers instead of reinflating `src/App.tsx`.
- Backend proof composition must stay in `air-mentor-api/src/modules/academic-proof-routes.ts` and extracted services, not in `air-mentor-api/src/modules/academic.ts` unless it is a thin delegating hook.

## Required Proof Before Exit
- Faculty profile, course-leader, mentor, and queue-history surfaces show the same scoped proof context and counts for the same faculty scope.
- Every student launch from these surfaces opens the intended partial profile path.
- Local and live parity evidence shows no mixed proof vs institutional totals.

## Commands And Expected Artifacts
| Command | Expected Artifacts | Pass Signal |
| --- | --- | --- |
| `cd air-mentor-api && npx vitest run tests/academic-parity.test.ts tests/academic-access.test.ts tests/academic-runtime-narrow-routes.test.ts` | backend test output; ledger reference | faculty/course-leader/mentor proof payload parity passes |
| `npm test -- tests/faculty-profile-proof.test.tsx tests/system-admin-live-data.test.ts tests/portal-routing.test.ts` | frontend test output; ledger reference | faculty profile proof sections, route launches, and scoped counts pass |
| `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:teaching-parity` | `output/playwright/system-admin-teaching-parity-smoke.png` | live sysadmin-to-teaching parity passes |
| `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> npm run verify:proof-closure:live` | `output/playwright/teacher-proof-panel.png`; `output/playwright/system-admin-proof-control-plane.png` | live teaching proof surfaces stay aligned with proof control plane |

## Regression Watchlist
- Faculty profile still depending on `src/App.tsx` for nontrivial proof logic
- Mentor or queue-history counts diverging from the faculty profile proof panel
- Student drilldowns launching stale or out-of-scope routes

## Blockers That Stop The Next Stage
- Any proof provenance field is missing from faculty-facing payloads
- Mixed totals remain on faculty, course-leader, or mentor surfaces
- Live teaching-parity or proof-closure evidence fails

## Exit Contract
- Stage `04A` is `passed` only when faculty profile, course-leader, mentor, and queue-history surfaces are proof-aligned, maintainable, and fully evidenced locally and live.

## Handoff Update Required In Ledger
- `stageId: 04A`
- faculty profile extraction/parity status
- local/live teaching artifact references
- unresolved drilldown or count defects
