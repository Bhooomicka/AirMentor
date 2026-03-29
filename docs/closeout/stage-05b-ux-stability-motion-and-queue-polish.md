# Stage 05B - UX Stability, Motion, And Queue Polish

Hard stop: do not start unless `stage-05a-shared-proof-shell-and-tab-contract.md` is marked passed in the execution ledger, its artifacts are present in the evidence manifest/index, and no unresolved blocker tagged to `05A` remains open in the defect register.

Operational rule: run every non-trivial verify/build/deploy command through `bash scripts/run-detached.sh <job-name> <command...>`, deploy the current frontend/backend before live proof, and carry forward the lessons in `docs/closeout/operational-execution-rules.md` before continuing.


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
