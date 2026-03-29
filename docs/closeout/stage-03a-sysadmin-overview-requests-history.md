# Stage 03A - Sysadmin Overview, Requests, And History

Hard stop: do not start unless `stage-02b-proof-control-plane-completion.md` is marked passed in the execution ledger, its artifacts are present in the evidence manifest/index, and no unresolved blocker tagged to `02B` remains open in the defect register.

Operational rule: run every non-trivial verify/build/deploy command through `bash scripts/run-detached.sh <job-name> <command...>`, deploy the current frontend/backend before live proof, and carry forward the lessons in `docs/closeout/operational-execution-rules.md` before continuing.


## Goal
- Bring the sysadmin overview dashboard, requests workflow, and history/restore workspace to parity with authoritative proof-first counts, scoped drilldowns, and preserved audit transitions.

## Repo Truth Anchors
- `src/system-admin-request-workspace.tsx` already owns the extracted request list/detail surface, including transitions and notes rendering.
- `src/system-admin-history-workspace.tsx` already owns the extracted archive/recycle-bin/audit surface.
- `src/system-admin-live-app.tsx` still computes overview support cards, route history, scoped metrics, and navigation glue in the monolith.
- `air-mentor-api/src/modules/admin-requests.ts` is the request workflow backend owner.
- `scripts/system-admin-live-request-flow.mjs` and `scripts/system-admin-live-acceptance.mjs` already exercise live overview/request navigation.

## Inputs Required From Previous Stage
- `02B` ledger row
- proof control-plane screenshots and diagnostics
- updated assertion traceability entries for proof-scoped counts and semester activation

## Allowed Change Surface
- `src/system-admin-request-workspace.tsx`
- `src/system-admin-history-workspace.tsx`
- `src/system-admin-live-data.ts`
- extracted overview helpers created beside existing sysadmin workspaces
- `air-mentor-api/src/modules/admin-requests.ts`
- request/history proof or Playwright coverage added under `tests/` and `scripts/`

## Ordered Implementation Tasks
### backend
- Remove any remaining mixed institutional totals from request- and overview-facing payloads when an active proof run or proof semester is present.
- Ensure request summaries, request details, transitions, notes, and linked targets remain lossless across create, approval, implementation, closure, hide, and restore actions.
- Expose request/history payload fields needed for deterministic deep-linking back into sysadmin surfaces without forcing extra monolithic client reconstruction.

### frontend
- Extract any remaining overview-card or request/history mapping logic out of `src/system-admin-live-app.tsx` into maintainable helpers beside the existing request/history workspaces.
- Make every overview support card drill into the correct route, preserve scoped context, and avoid switching back to institution-wide counts when proof context is active.
- Keep request detail, transition history, notes, and linked-target visibility stable when the operator deep-links, navigates back, or reopens the workspace from history.

### tests
- Extend backend request workflow coverage for scoped counts, detail hydration, transitions, notes, and restore behavior.
- Extend frontend coverage for overview-card routing, scoped count rendering, request-detail persistence, and history deep-link behavior.
- Reuse the live request-flow and acceptance suites; do not create a second competing request harness.

### evidence
- Capture one local proof bundle showing overview scoped cards, one request detail with transitions/notes, and one history/restore state.
- Capture the same surfaces on GitHub Pages + Railway.
- Update the assertion matrix rows for overview cards, requests workflow, and history/restore.

### non-goals
- Do not redesign unrelated proof-control-plane panels here.
- Do not add new request types unless required to preserve an existing authoritative workflow.

## Modularity Constraints
- `src/system-admin-request-workspace.tsx` and `src/system-admin-history-workspace.tsx` remain the UI owners for their surfaces.
- `src/system-admin-live-app.tsx` may only keep thin route wiring, selected-item state, and shell integration hooks.
- Do not move request/history behavior into `src/App.tsx` or other unrelated roots.

## Required Proof Before Exit
- Overview cards show proof-scoped counts when proof context is active and drill into the intended surface without losing scope.
- Request detail preserves notes, transitions, targets, and actionable status changes locally and live.
- History/restore remains navigable, restore-capable, and traceable through audit entries locally and live.

## Commands And Expected Artifacts
| Command | Expected Artifacts | Pass Signal |
| --- | --- | --- |
| `cd air-mentor-api && npx vitest run tests/admin-foundation.test.ts tests/admin-hierarchy.test.ts` | backend test output; ledger reference | request/history payload and scoped summary behavior pass |
| `npm test -- tests/system-admin-live-data.test.ts tests/system-admin-ui.test.tsx tests/portal-routing.test.ts` | frontend test output; ledger reference | overview routing, scoped counts, and request/history deep links pass |
| `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:acceptance` | `output/playwright/system-admin-live-acceptance-report.json`; `output/playwright/system-admin-live-acceptance.png` | overview surface loads with correct scoped drilldowns |
| `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:request-flow` | `output/playwright/system-admin-live-request-flow-report.json`; `output/playwright/system-admin-live-request-flow.png` | live request transitions, notes, and deep-link flow pass |

## Regression Watchlist
- Overview cards silently reverting to institution-wide totals during proof playback
- Request transitions or notes disappearing after status changes
- History/restore opening the wrong route or losing scoped selection on navigation back

## Blockers That Stop The Next Stage
- Any mixed proof vs institutional count remains visible on overview or request surfaces
- Request-flow Playwright fails locally or live
- History restore cannot reopen the correct entity route with preserved context

## Exit Contract
- Stage `03A` is `passed` only when overview, requests, and history all use authoritative scoped data, deep links stay stable, and local/live evidence is logged.

## Handoff Update Required In Ledger
- `stageId: 03A`
- overview scoped-count parity status
- request/history artifact references
- unresolved defects, if any, with exact surface names
