# Stage 03B - Sysadmin Hierarchy, Students, And Faculty

Hard stop: do not start unless `stage-03a-sysadmin-overview-requests-history.md` is marked passed in the execution ledger, its artifacts are present in the evidence manifest/index, and no unresolved blocker tagged to `03A` remains open in the defect register.

Operational rule: run every non-trivial verify/build/deploy command through `bash scripts/run-detached.sh <job-name> <command...>`, deploy the current frontend/backend before live proof, and carry forward the lessons in `docs/closeout/operational-execution-rules.md` before continuing.


## Goal
- Complete sysadmin hierarchy, students, and faculty registry parity so section-aware resolution, enrollment state, mentor assignment, appointments, permissions, and teaching ownership all align with teaching and proof surfaces.

## Repo Truth Anchors
- `src/system-admin-faculties-workspace.tsx` already owns the extracted hierarchy navigator and large parts of registry/governance editing.
- `src/system-admin-hierarchy-workspace-shell.tsx` is the extracted shell for hierarchy workspace composition.
- `src/system-admin-live-app.tsx` still contains student/faculty scope matching, registry state, and several cross-surface selectors in the monolith.
- `air-mentor-api/src/modules/admin-structure.ts`, `air-mentor-api/src/modules/students.ts`, and `air-mentor-api/src/modules/people.ts` are the backend owners for hierarchy, student, and faculty data.
- `tests/system-admin-live-data.test.ts`, `tests/system-admin-accessibility-contracts.test.tsx`, and `air-mentor-api/tests/admin-hierarchy.test.ts` already cover parts of this area.

## Inputs Required From Previous Stage
- `03A` ledger row
- overview/request/history proof artifacts
- updated defect register entries for any scoped-count or deep-link regressions

## Allowed Change Surface
- `src/system-admin-faculties-workspace.tsx`
- `src/system-admin-hierarchy-workspace-shell.tsx`
- `src/system-admin-live-data.ts`
- extracted hierarchy/student/faculty helpers created beside existing sysadmin workspaces
- `air-mentor-api/src/modules/admin-structure.ts`
- `air-mentor-api/src/modules/students.ts`
- `air-mentor-api/src/modules/people.ts`

## Ordered Implementation Tasks
### backend
- Make section-aware resolution authoritative for hierarchy, students, and faculty payloads, including active semester, section, transcript visibility, mentor assignment, promotion state, appointments, role grants, HoD status, ownership, and calendar-linked data.
- Ensure student and faculty detail payloads return the same resolved policy/provenance fields used elsewhere in the pack, especially `scopeDescriptor`, `resolvedFrom`, `scopeMode`, `countSource`, and `activeOperationalSemester`.
- Preserve audit/restore semantics for student and faculty mutations so rollbacks remain traceable.

### frontend
- Continue pulling registry and hierarchy-specific derivation logic out of `src/system-admin-live-app.tsx` into extracted helpers or workspace-owned utilities.
- Make section selection first-class in hierarchy drilldown, student detail, and faculty detail flows.
- Ensure student history, mentor assignment, appointments, role grants, ownership, and audit tabs stay internally consistent when opened from hierarchy search, proof drilldown, or request/history routes.

### tests
- Extend backend coverage for section-aware hierarchy resolution, student/faculty detail parity, and audit visibility.
- Extend frontend coverage for hierarchy tab linkage, scoped registry search, student/faculty detail parity, and accessibility of extracted hierarchy tabs.
- Reuse live admin acceptance and accessibility sweeps; do not treat the monolith as the source of truth for new regression tests.

### evidence
- Capture one scoped hierarchy walkthrough at institution, faculty, department, branch, batch, and section layers.
- Capture one student detail proof, one faculty detail proof, and one accessibility snapshot of hierarchy tab semantics.
- Update the coverage matrix rows for hierarchy, students, and faculty-members.

### non-goals
- Do not implement semester activation here.
- Do not add new proof-only widgets to the registries before the shared proof shell stage.

## Modularity Constraints
- `src/system-admin-faculties-workspace.tsx` remains the primary UI owner.
- New selectors or registry transforms belong in extracted helpers or `src/system-admin-live-data.ts`, not in `src/system-admin-live-app.tsx`.
- Backend hierarchy logic stays in `air-mentor-api/src/modules/admin-structure.ts` and related extracted services, not in `air-mentor-api/src/modules/academic.ts`.

## Required Proof Before Exit
- Every hierarchy layer from institution through section resolves correctly and consistently across student/faculty drilldowns.
- Student and faculty details match teaching/proof-facing ownership, permissions, and semester context.
- Accessibility linkage for hierarchy tabs and panels remains correct locally and live.

## Commands And Expected Artifacts
| Command | Expected Artifacts | Pass Signal |
| --- | --- | --- |
| `cd air-mentor-api && npx vitest run tests/admin-hierarchy.test.ts tests/academic-access.test.ts tests/academic-parity.test.ts` | backend test output; ledger reference | hierarchy/student/faculty resolution and access pass |
| `npm test -- tests/system-admin-live-data.test.ts tests/system-admin-accessibility-contracts.test.tsx tests/system-admin-ui.test.tsx` | frontend test output; ledger reference | scoped registry behavior and tab accessibility pass |
| `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:acceptance` | `output/playwright/system-admin-live-acceptance-report.json`; `output/playwright/system-admin-live-acceptance.png` | live hierarchy/student/faculty navigation stays aligned |
| `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:accessibility-regression` | `output/playwright/system-admin-live-accessibility-report.json`; `output/playwright/system-admin-live-accessibility-regression.png`; `output/playwright/system-admin-live-screen-reader-preflight.md` | hierarchy accessibility contract passes live |

## Regression Watchlist
- Section scope present in one registry surface but missing in another
- Student detail and faculty detail disagreeing on active semester, ownership, or role grants
- Registry search returning out-of-scope results after section-aware filtering

## Blockers That Stop The Next Stage
- Any hierarchy layer fails to resolve or display section-aware provenance
- Student/faculty detail parity breaks against teaching or proof surfaces
- Accessibility regression appears in hierarchy tab or panel linkage

## Exit Contract
- Stage `03B` is `passed` only when hierarchy, students, and faculty-members behave as one coherent section-aware control surface with local/live proof recorded.

## Handoff Update Required In Ledger
- `stageId: 03B`
- hierarchy layers verified
- student/faculty parity artifact references
- remaining defects tagged by layer and entity type
