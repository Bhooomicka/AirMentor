# Stage 06B - Provisioning Permissions And Bulk Mentor Assignment

Hard stop: do not start unless `stage-06a-hierarchy-resolution-and-override-rollback.md` is marked passed in the execution ledger, its artifacts are present in the evidence manifest/index, and no unresolved blocker tagged to `06A` remains open in the defect register.

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
- Finish faculty provisioning, appointments, permissions, and mentor-mapping operations with explicit auditability and a maintainable bulk mentor-assignment flow.

## Repo Truth Anchors
- `air-mentor-api/src/modules/people.ts` already owns faculty profile, appointment, and role-grant create/update behavior.
- `air-mentor-api/src/modules/students.ts` currently exposes only single-record `POST /api/admin/mentor-assignments` and `PATCH /api/admin/mentor-assignments/:assignmentId`.
- `src/api/client.ts` currently exposes only single mentor-assignment create/update client methods.
- `air-mentor-api/src/lib/academic-provisioning.ts` already owns deterministic faculty timetable template generation and is the right home for provisioning-side calculations.
- `air-mentor-api/tests/admin-control-plane.test.ts` already proves appointment, role-grant, cascade-delete, and mentor-link effects on the live teaching surface.

## Inputs Required From Previous Stage
- `06A` ledger row
- hierarchy lineage and rollback artifacts
- updated matrix rows for override proof

## Allowed Change Surface
- `air-mentor-api/src/modules/people.ts`
- `air-mentor-api/src/modules/students.ts`
- extracted provisioning helpers under `air-mentor-api/src/lib/`
- `src/api/client.ts`
- extracted sysadmin faculty/student provisioning helpers beside current workspaces
- `src/system-admin-faculties-workspace.tsx`
- provisioning/permissions/openapi tests and live scripts

## Ordered Implementation Tasks
### backend
- Add `POST /api/admin/mentor-assignments/bulk-apply`.
- Keep bulk mentor assignment auditable, version-safe, and compatible with existing single-record create/patch flows.
- Tighten provisioning and permission behavior so appointments, grants, and mentor mappings stay consistent with hierarchy scope and faculty deletion cascades.

### frontend
- Add maintainable bulk mentor-assignment controls in extracted sysadmin provisioning helpers rather than growing monolith detail panels.
- Expose enough permission and provisioning state for operators to understand which faculty holds which role and why a mentor mapping succeeded or failed.
- Keep single-record edit flows intact while adding bulk-apply behavior.

### tests
- Extend backend tests for bulk mentor assignment, openapi coverage, and cascade consistency.
- Add client or UI tests only where new bulk actions or permission summaries require it.
- Keep teaching-parity coverage green because mentor and permission changes propagate into faculty profile and student-facing proof surfaces.

### evidence
- Capture local and live proof that bulk mentor assignment changes the intended students only and remains visible through faculty and teaching-proof surfaces.
- Record the faculty, scope, and student set used for the bulk-apply proof.
- Update both matrices for provisioning, permissions, and mentor bulk apply.

### non-goals
- Do not broaden this stage into semester activation or proof-walk scripting.
- Do not replace the single-record mentor-assignment endpoints; bulk apply must complement them.

## Modularity Constraints
- Bulk mentor-assignment orchestration belongs in focused student/provisioning helpers, not in `air-mentor-api/src/modules/academic.ts`.
- Frontend bulk operations belong in extracted sysadmin helpers beside the owning workspaces.
- `src/system-admin-live-app.tsx` may only receive thin wiring for new controls and callbacks.

## Required Proof Before Exit
- Bulk mentor assignment exists as a first-class public contract.
- Appointments, role grants, and mentor mappings remain auditable and consistent after bulk changes.
- Faculty-profile and student-facing proof surfaces still reflect the updated provisioning state locally and live.

## Commands And Expected Artifacts
| Command | Expected Artifacts | Pass Signal |
| --- | --- | --- |
| `cd air-mentor-api && npx vitest run tests/admin-control-plane.test.ts tests/admin-foundation.test.ts tests/openapi.test.ts` | backend vitest output; ledger reference | provisioning, permissions, and public contract snapshots stay correct |
| `npm test -- --run tests/system-admin-live-data.test.ts tests/system-admin-accessibility-contracts.test.tsx` | frontend vitest output; ledger reference | sysadmin selectors and accessibility remain stable after bulk controls |
| `npm run verify:proof-closure:proof-rc` | proof screenshots in `output/playwright/`; ledger reference | local proof surfaces still reflect mentor/provisioning state correctly |
| `npm run playwright:admin-live:acceptance` | `output/playwright/system-admin-live-acceptance-report.json`, `output/playwright/system-admin-live-acceptance.png` | local sysadmin provisioning flow remains stable |
| `npm run playwright:admin-live:teaching-parity` | `output/playwright/system-admin-teaching-parity-smoke.png` | local teaching parity remains intact after provisioning changes |
| `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> npm run verify:proof-closure:live` | refreshed live proof artifacts; ledger reference | live proof surfaces stay correct |
| `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:acceptance` | refreshed live acceptance artifacts; ledger reference | live provisioning flow passes |
| `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:teaching-parity` | refreshed live teaching-parity artifact; ledger reference | live teaching parity remains intact |

## Regression Watchlist
- Bulk apply bypassing audit/version rules that single-record assignment already honors
- Provisioning or permission changes updating sysadmin state but not teaching-proof surfaces
- Bulk mentor actions implemented directly inside large root components

## Blockers That Stop The Next Stage
- Missing `POST /api/admin/mentor-assignments/bulk-apply`
- Any mismatch between bulk-apply results and teaching-proof surfaces
- Any local/live parity or proof-closure failure after provisioning changes

## Exit Contract
- Stage `06B` is `passed` only when provisioning, permissions, and bulk mentor assignment are complete, maintainable, auditable, and proven locally and live.

## Handoff Update Required In Ledger
- `stageId: 06B`
- bulk mentor-apply scope and student set used for proof
- local/live artifact references
- openapi/public contract change summary
