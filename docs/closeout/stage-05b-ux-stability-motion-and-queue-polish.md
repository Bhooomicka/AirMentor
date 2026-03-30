# Stage 05B - UX Stability, Motion, And Queue Polish

Hard stop: do not start unless `stage-05a-shared-proof-shell-and-tab-contract.md` is marked passed in the execution ledger, its artifacts are present in the evidence manifest/index, and no unresolved blocker tagged to `05A` remains open in the defect register.

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
- Stabilize shell sizing, motion, queue interactions, and visual language so proof-aware and sysadmin surfaces feel consistent and do not jump or regress during live operation.

## Repo Truth Anchors
- `src/system-admin-ui.tsx`, `src/system-admin-session-shell.tsx`, `src/academic-workspace-topbar.tsx`, and `src/academic-workspace-sidebar.tsx` already provide shared UI primitives and shell structure.
- `src/system-admin-live-app.tsx` still coordinates queue actions, dialogs, and some cross-surface panel transitions from the monolith.
- `scripts/system-admin-live-accessibility-regression.mjs`, `scripts/system-admin-live-keyboard-regression.mjs`, and `scripts/system-admin-live-acceptance.mjs` already reveal layout jumps and focus regressions on deployed flows.
- The authoritative plan requires `Hide all` and `Restore all hidden` queue actions and replacement of any remaining circular proof widgets with the metric-card language.

## Inputs Required From Previous Stage
- `05A` ledger row
- shared proof-shell screenshots and accessibility artifacts
- updated defect register entries for shell inconsistencies

## Allowed Change Surface
- `src/system-admin-ui.tsx`
- `src/system-admin-session-shell.tsx`
- `src/academic-workspace-topbar.tsx`
- `src/academic-workspace-sidebar.tsx`
- extracted queue and motion helpers created beside existing surface owners
- thin integration hooks in `src/system-admin-live-app.tsx` only if required
- queue governance helpers under `air-mentor-api/src/lib/` only if a backend affordance is required for bulk hide/restore

## Ordered Implementation Tasks
### backend
- Add extracted queue-governance support only if bulk hide/restore requires backend state changes; keep API work minimal and explicit.
- Preserve audit visibility for queue hide, restore, bulk hide, and bulk restore actions.

### frontend
- Standardize dropdown sizing, panel chrome, paddings, card styling, colors, tab heights, and segmented controls across sysadmin and proof-aware surfaces.
- Add smooth but restrained transitions for subpanel changes, proof drawer open/close, queue dismiss/hide/restore, modal transitions, and theme changes.
- Add `Hide all` and `Restore all hidden` to the action queue and remove any remaining circular proof widgets in favor of metric-card language.

### tests
- Extend component and interaction coverage for queue bulk actions, shell sizing stability, and motion-safe focus behavior.
- Reuse acceptance, accessibility, and keyboard suites as the release gate for jarring layout regressions.
- Add explicit assertions that layout height and checkpoint/banner placement remain stable during tab and drawer transitions.

### evidence
- Capture a before/after queue interaction bundle showing dismiss, hide, restore, hide all, and restore all.
- Capture one local and one live motion/shell stability screenshot set for proof drawer, tab switches, and modal transitions.
- Update the assertion matrix rows for queue polish, panel stability, and visual-language standardization.

### non-goals
- Do not introduce new proof data or semester logic here.
- Do not use animation to mask slow or incorrect data updates.

## Modularity Constraints
- Reusable motion and queue behavior belongs in extracted helpers or shared UI owners, not in repeated ad hoc blocks.
- `src/system-admin-live-app.tsx` may keep event wiring only; it must not become the permanent owner for queue UX behavior.
- Do not patch isolated pages one by one if the change should live in a shared primitive.

## Required Proof Before Exit
- Queue bulk actions exist, remain auditable, and behave consistently locally and live.
- Shared shells and proof surfaces keep stable height, focus, and chrome during transitions.
- No remaining circular proof widgets or inconsistent panel chrome remain on deployed proof-aware surfaces.

## Commands And Expected Artifacts
| Command | Expected Artifacts | Pass Signal |
| --- | --- | --- |
| `npm test -- tests/system-admin-ui.test.tsx tests/system-admin-accessibility-contracts.test.tsx` | frontend test output; ledger reference | queue controls and shared shell UI behavior pass |
| `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:acceptance` | `output/playwright/system-admin-live-acceptance-report.json`; `output/playwright/system-admin-live-acceptance.png` | live shell and queue flows remain stable |
| `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:accessibility-regression` | `output/playwright/system-admin-live-accessibility-report.json`; `output/playwright/system-admin-live-accessibility-regression.png` | motion and chrome changes preserve accessibility |
| `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:keyboard-regression` | `output/playwright/system-admin-live-keyboard-regression-report.json`; `output/playwright/system-admin-live-keyboard-regression.png` | queue and drawer transitions preserve focus order |

## Regression Watchlist
- Layout jumps when switching proof tabs or opening drawers
- Queue bulk actions hiding items without audit coverage or restore path
- Shared visual language diverging again between sysadmin and academic surfaces

## Blockers That Stop The Next Stage
- Bulk queue actions are missing or unaudited
- Keyboard/accessibility regression appears after motion or chrome changes
- Deployed surfaces still show inconsistent proof widgets or panel styling

## Exit Contract
- Stage `05B` is `passed` only when queue interactions, motion, and shell stability are consistent, auditable, and validated locally and live.

## Handoff Update Required In Ledger
- `stageId: 05B`
- queue bulk-action status
- motion/shell artifact references
- unresolved visual or interaction regressions

## Completion Notes
- `2026-03-30`: `src/system-admin-action-queue.ts`, `src/system-admin-ui.tsx`, `src/ui-primitives.tsx`, `src/system-admin-live-app.tsx`, and `src/academic-workspace-topbar.tsx` now own queue bulk hide/restore helpers, shared queue-control chrome, accessible queue count badges, and darker primary-action accents for the action rail.
- `2026-03-30`: detached local verification passed in `output/detached/airmentor-05b-local-ui-tests-r2-20260330T141357Z.log` and `output/detached/airmentor-05b-build-web-r2-20260330T141411Z.log` after the contrast and queue-chrome fix landed.
- `2026-03-30`: GitHub Pages deploy run `23749418896` propagated commit `b542b844ad91d623b50b0e3b950646918d089662` as `index-DL9CIFbe.js`; `LIVE-ACCEPTANCE`, `LIVE-A11Y`, and `LIVE-KEYBOARD` then passed on the deployed Pages + Railway stack, closing `DEF-05B-LIVE-A11Y-QUEUE-CONTRAST`.
