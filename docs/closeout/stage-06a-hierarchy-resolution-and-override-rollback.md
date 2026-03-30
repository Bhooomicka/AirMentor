# Stage 06A - Hierarchy Resolution And Override Rollback

Hard stop: do not start unless `stage-05b-ux-stability-motion-and-queue-polish.md` is marked passed in the execution ledger, its artifacts are present in the evidence manifest/index, and no unresolved blocker tagged to `05B` remains open in the defect register.

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
- Make hierarchy-derived policy and stage-policy resolution fully explainable, section-aware, and rollback-safe so operators can prove where an override came from and reverse it without stale scope state.

## Repo Truth Anchors
- `air-mentor-api/src/modules/admin-structure.ts` already owns `resolveBatchPolicy` and `resolveBatchStagePolicy`.
- `air-mentor-api/tests/admin-hierarchy.test.ts` already exercises policy override inheritance and resolved-policy reads.
- `src/system-admin-faculties-workspace.tsx` is the extracted owner for hierarchy lineage display and must render the authoritative resolved payloads instead of generic scope hints.
- `src/api/types.ts` and the resolved policy/stage-policy endpoints already expose `scopeDescriptor`, `resolvedFrom`, `scopeMode`, `countSource`, and `activeOperationalSemester`; the remaining 06A gap is authoritative display and rollback copy, not missing payload fields.

## Inputs Required From Previous Stage
- `05B` ledger row
- accessibility and keyboard proof artifacts
- updated matrix rows for shared shell, metadata, and UX stability

## Allowed Change Surface
- `air-mentor-api/src/modules/admin-structure.ts`
- extracted hierarchy/policy helpers created under `air-mentor-api/src/lib/`
- `src/system-admin-faculties-workspace.tsx`
- `src/system-admin-live-data.ts`
- hierarchy/policy tests and targeted admin scripts

## Ordered Implementation Tasks
### backend
- Finish authoritative hierarchy resolution across institution, academic faculty, department, branch, batch, and section where section-level scope applies.
- Keep resolved policy and resolved stage-policy payloads authoritative, including `scopeDescriptor`, `resolvedFrom`, and `scopeMode`, while tightening any rollback or label gaps that still affect direct operator display.
- Add explicit rollback-safe behavior for override removal, override replacement, and any scope reassignment that should invalidate older derived state.

### frontend
- Replace generic "resolved from scope" hints with explicit lineage, resolved scope labels, and rollback-ready operator messaging.
- Keep override lineage display inside the extracted faculties workspace and its helpers.
- Ensure section-aware lineage appears anywhere a section selection changes the effective source of truth.

### tests
- Tighten resolved-policy and rollback-path coverage on the backend.
- Add UI assertions for lineage labels and rollback-safe messages if the extracted governance UI changes.
- Keep section-aware selector coverage aligned with the new lineage contract.

### evidence
- Capture local and live proof that the active override lineage is visible and that a rollback or removal path leaves no stale resolved state.
- Record the scope chain exercised, including any section-level resolution.
- Update both matrices for lineage fields and rollback proof.

### non-goals
- Do not add bulk mentor-assignment features here.
- Do not move proof-run lifecycle logic into hierarchy modules.

## Modularity Constraints
- New resolution and rollback behavior belongs in structure-specific modules or extracted helpers under `air-mentor-api/src/lib/`.
- Do not add new hierarchy resolution branches to `air-mentor-api/src/modules/academic.ts` or `air-mentor-api/src/lib/msruas-proof-control-plane.ts`.
- `src/system-admin-live-app.tsx` may only receive thin display wiring.

## Required Proof Before Exit
- Resolved policy and stage-policy payloads explain their source with authoritative lineage fields.
- Override rollback or removal does not leave stale UI or derived payload state.
- Section-aware lineage works locally and on the live stack.

## Commands And Expected Artifacts
| Command | Expected Artifacts | Pass Signal |
| --- | --- | --- |
| `cd air-mentor-api && npx vitest run tests/admin-hierarchy.test.ts tests/admin-control-plane.test.ts tests/policy-phenotypes.test.ts` | backend vitest output; ledger reference | resolved lineage and rollback behavior stay correct |
| `npm test -- --run tests/system-admin-live-data.test.ts tests/system-admin-accessibility-contracts.test.tsx` | frontend vitest output; ledger reference | lineage display and section-aware selectors remain stable |
| `npm run playwright:admin-live:acceptance` | `output/playwright/system-admin-live-acceptance-report.json`, `output/playwright/system-admin-live-acceptance.png` | local hierarchy/override workflow remains usable |
| `npm run playwright:admin-live:keyboard-regression` | `output/playwright/system-admin-live-keyboard-regression-report.json`, `output/playwright/system-admin-live-keyboard-regression.png` | local keyboard traversal through override surfaces passes |
| `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:acceptance` | refreshed live acceptance artifacts; ledger reference | live hierarchy/override workflow passes |
| `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:keyboard-regression` | refreshed live keyboard artifacts; ledger reference | live hierarchy/override keyboard path passes |

## Regression Watchlist
- Override rollback clearing the database row but leaving stale resolved labels or cached counts
- Section selection changing scope labels without changing resolved lineage
- Rollback logic implemented ad hoc in UI handlers instead of authoritative backend helpers

## Blockers That Stop The Next Stage
- Missing lineage fields on resolved payloads
- Any rollback path that leaves stale resolved state
- Any local/live failure on hierarchy or keyboard proof

## Exit Contract
- Stage `06A` is `passed` only when hierarchy resolution and override rollback are authoritative, explainable, section-aware, and proven locally and live.

## Handoff Update Required In Ledger
- `stageId: 06A`
- lineage fields added
- rollback scenario used for proof
- local/live artifact references
