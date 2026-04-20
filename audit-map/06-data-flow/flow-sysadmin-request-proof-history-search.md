# Flow: Sysadmin Request, Proof, History, and Search

## Authoritative Sources

- `src/system-admin-live-app.tsx`
- `src/system-admin-request-workspace.tsx`
- `src/system-admin-live-data.ts`
- `air-mentor-api/src/modules/admin-requests.ts`
- `src/system-admin-history-workspace.tsx`
- `src/system-admin-proof-dashboard-workspace.tsx`

## Entry Triggers And Producers

- Sysadmin route/tab/search triggers produce scoped backend queries and workspace state updates.
- Request transition actions produce admin request mutation calls.
- Proof dashboard controls (checkpoint/tab/scope) produce diagnostics and playback reads.
- History/recycle interactions produce archive/restore mutation and list refresh cycles.

## Transformations And Derivations

- Search input and section filters are transformed into scoped list/detail query payloads.
- Request status and action state are transformed into visible action affordances.
- Proof dashboard context is transformed into role-specific diagnostics/projection summaries.

## Caches, Shadows, Snapshots, Persistence Boundaries

- Frontend persistence: local storage-backed queue dismissals and tab/route restore state.
- Backend persistence: request state transitions and history/recycle data stores.
- Proof scope persistence: checkpoint/tab/selection restore keys across sessions.

## Readers And Consumers

- Sysadmin live app shell, request workspace, proof workspace, and history workspace.
- Backend admin-requests routes and related list/detail mutation handlers.

## Failure And Fallback Branches

- Failed request transitions revert UI optimism and retain prior row status.
- Search and scoped query failures degrade to prior cached rows or empty-state messaging.
- Known mismatch branch remains: backend supports more transitions than current UI exposes (C-006).

## Restore And Replay Paths

- Local storage restores tab and proof dashboard context on reload.
- History page restores selection/filter context for iterative operator workflows.
- Request list/detail re-fetch after mutations to replay latest backend truth.

## Drift And Staleness Risks

- UI action set can drift from backend transition contract (active C-006 risk).
- Persisted local queue/tab state can become stale after backend-side bulk changes.
- Search scope assumptions can drift as role/scope governance evolves.

## Evidence Anchors

- `src/system-admin-live-app.tsx`
- `src/system-admin-request-workspace.tsx`
- `src/system-admin-live-data.ts`
- `src/system-admin-history-workspace.tsx`
- `src/system-admin-proof-dashboard-workspace.tsx`
- `air-mentor-api/src/modules/admin-requests.ts`
- `tests/system-admin-live-data.test.ts`
- `tests/system-admin-proof-dashboard-workspace.test.tsx`
- `air-mentor-api/tests/admin-foundation.test.ts`
