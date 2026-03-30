# Stage 05A - Shared Proof Shell And Tab Contract

Hard stop: do not start unless `stage-04b-hod-risk-explorer-student-shell-parity.md` is marked passed in the execution ledger, its artifacts are present in the evidence manifest/index, and no unresolved blocker tagged to `04B` remains open in the defect register.

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
- When adding new jsdom contract tests for the shared shell, prefer `createElement` harnesses or explicitly import the React runtime before using JSX. Otherwise the proof can fail on `React is not defined` even when the product code is correct.
- Shared shell adoption does not mean every proof surface must gain tabs. Keep always-visible proof sections visible when the surface only needs the shared hero and launcher, and treat hiding previously visible evidence as a behavioral change that requires an explicit stage decision plus updated tests.

## Goal
- Build one shared proof shell and tab contract for sysadmin proof views, teacher proof panel, HoD analytics, risk explorer, and student shell.

## Repo Truth Anchors
- `src/system-admin-proof-dashboard-workspace.tsx`, `src/pages/hod-pages.tsx`, `src/pages/risk-explorer.tsx`, and `src/pages/student-shell.tsx` each currently render their own proof tab/panel structures.
- `tests/system-admin-accessibility-contracts.test.tsx`, `tests/faculty-profile-proof.test.tsx`, `tests/hod-pages.test.ts`, `tests/risk-explorer.test.tsx`, and `tests/student-shell.test.tsx` already assert `aria-controls` and `data-proof-section` semantics across multiple proof surfaces.
- `src/ui-primitives.tsx` already contains reusable tab/button primitives, but no single shared proof-shell contract exists yet.
- Live accessibility and keyboard scripts already exercise multiple proof-aware surfaces and will reveal shell inconsistency quickly.

## Inputs Required From Previous Stage
- `04B` ledger row
- HoD/risk/student parity artifacts
- updated defect register entries for any proof-surface parity defects

## Allowed Change Surface
- extracted shared proof-shell components created under `src/`
- `src/system-admin-proof-dashboard-workspace.tsx`
- `src/academic-workspace-content-shell.tsx`
- `src/academic-workspace-route-surface.tsx`
- `src/pages/hod-pages.tsx`
- `src/pages/risk-explorer.tsx`
- `src/pages/student-shell.tsx`
- `src/ui-primitives.tsx`

## Ordered Implementation Tasks
### backend
- Only add backend fields if a shared shell needs explicit state metadata that is missing today; otherwise keep this stage frontend-led.
- Do not widen backend contracts unnecessarily when the shell can compose existing proof fields.

### frontend
- Create one shared proof shell that owns stable min-height, internal scrolling, tab transitions, focus behavior, loading/empty/error states, and checkpoint-banner placement.
- Replace duplicated proof tab/panel scaffolding across sysadmin, teacher, HoD, risk explorer, and student shell with the shared contract.
- Add one floating proof launcher on every proof-aware surface using the same affordance, keyboard behavior, and fallback state.

### tests
- Add or extend contract tests so each proof-aware surface proves it is using the shared shell semantics rather than a one-off local structure.
- Keep accessibility and keyboard coverage focused on the shared contract instead of snapshotting styling details.
- Ensure the floating proof launcher is exercised across all proof-aware surfaces.

### evidence
- Capture before/after screenshots for each proof-aware surface showing stable checkpoint banner placement and tab behavior.
- Capture one local and one live proof-shell accessibility tree proving consistent roles and labels.
- Update the assertion matrix rows for shared proof shell, proof launcher, and panel linkage.

### non-goals
- Do not redesign queue behavior here; that belongs to the next UX stage.
- Do not hide unresolved proof data problems behind a nicer shell.

## Modularity Constraints
- The shared proof shell must be its own reusable owner, not copied into each page.
- `src/system-admin-proof-dashboard-workspace.tsx` and the academic pages consume the shared shell; they do not reimplement it.
- Do not add new cross-surface proof shell logic to `src/system-admin-live-app.tsx` or `src/App.tsx`.

## Required Proof Before Exit
- All proof-aware surfaces share one tab/panel contract, checkpoint banner placement, and floating launcher behavior.
- Focus order, internal scrolling, and loading/error states remain stable locally and live.
- No proof-aware surface retains a one-off incompatible shell.

## Commands And Expected Artifacts
| Command | Expected Artifacts | Pass Signal |
| --- | --- | --- |
| `npm test -- tests/system-admin-accessibility-contracts.test.tsx tests/faculty-profile-proof.test.tsx tests/hod-pages.test.ts tests/risk-explorer.test.tsx tests/student-shell.test.tsx` | frontend test output; ledger reference | shared shell semantics pass across all proof-aware surfaces |
| `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:accessibility-regression` | `output/playwright/system-admin-live-accessibility-report.json`; `output/playwright/system-admin-live-accessibility-regression.png` | live proof-shell accessibility contract passes |
| `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:keyboard-regression` | `output/playwright/system-admin-live-keyboard-regression-report.json`; `output/playwright/system-admin-live-keyboard-regression.png` | shared shell focus and launcher behavior pass |
| `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> npm run verify:proof-closure:live` | proof screenshots across admin/teacher/HoD/student | all proof surfaces render through the shared shell without parity regressions |

## Regression Watchlist
- One-off tab markup lingering on a single proof surface
- Floating proof launcher present on some proof surfaces but missing on others
- Checkpoint banner placement shifting between surfaces and causing layout jumps

## Blockers That Stop The Next Stage
- Any proof-aware surface is still using incompatible tab/panel semantics
- Shared shell causes accessibility or keyboard regressions
- Proof closure live suite shows shell-driven parity failures

## Exit Contract
- Stage `05A` is `passed` only when a single shared proof shell and launcher contract is in place across all proof-aware surfaces with local/live evidence.

## Handoff Update Required In Ledger
- `stageId: 05A`
- shared proof shell owner path
- launcher coverage by surface
- local/live artifact references
