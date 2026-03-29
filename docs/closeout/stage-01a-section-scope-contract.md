# Stage 01A - Section Scope Contract

Hard stop: do not start unless `stage-00b-evidence-ledger-and-assertion-backbone.md` is marked passed in the execution ledger, its artifacts are present in the evidence manifest/index, and no unresolved blocker tagged to `00B` remains open in the defect register.

Operational rule: run every non-trivial verify/build/deploy command through `bash scripts/run-detached.sh <job-name> <command...>`, deploy the current frontend/backend before live proof, and carry forward the lessons in `docs/closeout/operational-execution-rules.md` before continuing.


## Goal
- Promote `section` from incidental data to an authoritative scope layer across backend contracts, frontend contracts, proof selectors, and sysadmin UI.
- Make the section scope encoding and precedence decision-complete for every later stage.

## Repo Truth Anchors
- `air-mentor-api/src/lib/stage-policy.ts` exposes `scopeTypeValues` as `institution -> academic-faculty -> department -> branch -> batch`.
- `air-mentor-api/src/modules/admin-structure.ts` `scopeTypeSchema`, `getBatchScopeContext`, `resolveBatchPolicy`, and `resolveBatchStagePolicy` also stop at `batch`.
- `src/api/types.ts` `ApiResolvedBatchPolicy` and `ApiResolvedBatchStagePolicy` do not include `section` in their scope chains.
- `src/system-admin-faculties-workspace.tsx` still renders batch-only governance messaging.
- The data model already carries `sectionCode` in offerings, enrollments, proof analytics, and student shell data, so this stage is about governance authority rather than creating section data from scratch.

## Inputs Required From Previous Stage
- `00B` ledger row
- seeded evidence backbone files
- pilot boundary note from `00A`

## Allowed Change Surface
- backend scope and policy contract owners
- frontend API types and governance selectors
- sysadmin faculties workspace scope UI
- targeted tests and evidence capture

## Ordered Implementation Tasks
### backend
- Add `section` to the authoritative scope enums and schemas.
- Define section IDs as `<batchId>::<sectionCode>`.
- Extend batch scope-context builders to append the active section node after `batch`.
- Update policy resolution and stage-policy resolution to honor section precedence.
- Update any proof-facing scope filters that currently stop at batch when the active context is section-specific.

### frontend
- Add `section` to `ApiScopeType` consumers and UI scope labels.
- Replace batch-only governance copy in the faculties workspace with section-aware copy.
- Ensure selector state can distinguish batch scope from section scope without route ambiguity.

### tests
- Add backend tests for:
  - section scope existence
  - section precedence over batch
  - rollback from section to batch
- Add frontend tests for:
  - section-aware governance messaging
  - section route/selector visibility

### evidence
- Update the coverage matrix and assertion matrix to mark section scope as an active contract, not a future note.
- Append proof artifacts and command results to the ledger/manifest/index.

### non-goals
- Do not solve count provenance in this stage.
- Do not add semester activation here.
- Do not implement mentor bulk apply here.

## Modularity Constraints
- Prefer editing extracted policy owners and API types first.
- Treat `src/system-admin-live-app.tsx` as a wiring surface only; do not bury new section-resolution logic there.
- Any new helper for section encoding or label rendering must live in a reusable owner, not inline inside a large component.

## Required Proof Before Exit
- `section` is visible in backend and frontend scope contracts.
- Section precedence over batch is covered by automated tests.
- Sysadmin governance surfaces no longer describe batch as the terminal scope.

## Commands And Expected Artifacts
| Command | Expected Artifacts | Pass Signal |
| --- | --- | --- |
| `cd air-mentor-api && npx vitest run tests/admin-hierarchy.test.ts tests/admin-control-plane.test.ts tests/academic-access.test.ts` | backend test output; ledger reference | section scope tests pass and no scope-regression failures remain |
| `npm test -- --run tests/system-admin-live-data.test.ts tests/system-admin-accessibility-contracts.test.tsx` | frontend test output; ledger reference | governance selectors and tab contracts stay green |
| `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:acceptance` | `system-admin-live-acceptance-report.json`, `system-admin-live-acceptance.png` | live admin navigation still works after section-scope changes |
| `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:teaching-parity` | `system-admin-teaching-parity-smoke.png` | teaching parity survives section-scope contract changes |

## Regression Watchlist
- Batch-only scope labels left behind in UI copy
- Section IDs that are inconsistent between backend and frontend
- Hidden route-state bugs where section selection corrupts batch selection

## Blockers That Stop The Next Stage
- Any failing precedence or rollback test
- Any remaining batch-terminal contract in public types or scope schemas
- Any live admin or teaching parity failure after section changes

## Exit Contract
- Stage `01A` is `passed` only when section is an authoritative scope layer in code, tests, and user-visible scope messaging.

## Handoff Update Required In Ledger
- `stageId: 01A`
- section ID encoding
- local precedence/rollback proof
- live admin + teaching verification references
