# State Flow: Academic Session, Role, and Page State

- Flow name: Academic portal bootstrap, session restore/login, role-sync, and internal page-state navigation
- Context or scope: `#/app` route handled by `OperationalApp`, including bootstrap mode selection, role grant projection, route snapshot restore, and back-navigation recovery.
- Start and precondition states: `portal-entry`; `boot-loading`; `mock-bootstrap` when API base is absent; `unauthenticated` when remote session restore returns 401; `session-ready` after successful restore/login and bootstrap data hydration.
- Trigger: Initial portal load, sign-in submit, role switch request, page navigation action, hash route transition into `#/app`.
- Guards: `canAccessPage` role/page guard; `resolveRoleSyncState` role-to-page alignment; active-role grant constraints from session projection; proof checkpoint availability when restoring proof-bound pages.
- Intermediate states: `loading`, `session-restoring`, `auth-error`, `role-sync-pending`, `page-guard-fallback`, `history-available`, `history-empty`, `proof-restore-notice`.
- Async or background transitions: parallel restore of public faculty + remote session; retry loops around backend cookie-readability and 401 restore boundaries; evented projection commits after restore/login.
- Invalid or conflict states: stale route snapshot that points to inaccessible page for current role; restored checkpoint ID no longer valid for current active run/scope.
- Error states: remote session restore failure; login failure; bootstrap fetch failure; inaccessible page attempts.
- Restore or re-entry states: route snapshot restore (`restoreRouteSnapshot`); back stack replay using `routeHistory`; restored proof playback message path when persisted checkpoint remains valid.
- Terminal states: `session-ready` with role-legal page; explicit sign-out transition back to unauthenticated gate.
- Recovery path: guard failure falls back to role home (`getHomePage`) or next valid history candidate; invalid proof checkpoint is cleared and control returns to active run/default view.
- Observed drift: no new local-vs-tested contradiction discovered in this pass; live behavior remains unverified in-browser.
- Evidence: `src/App.tsx:87`, `src/App.tsx:1190`, `src/App.tsx:1279`, `src/App.tsx:1583`, `src/App.tsx:1631`, `src/App.tsx:1788`, `src/App.tsx:1815`, `src/App.tsx:3559`, `src/App.tsx:3569`, `src/App.tsx:3652`, `src/App.tsx:3679`, `src/academic-workspace-route-helpers.ts`, `tests/academic-workspace-route-helpers.test.ts`, `tests/academic-route-pages.test.tsx`, `tests/portal-routing.test.ts`.
- Confidence: High for local and test-backed state transitions; medium for live deployment parity because no live replay was run in this pass.
