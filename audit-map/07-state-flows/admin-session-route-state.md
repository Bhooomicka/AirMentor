# State Flow: System-Admin Session and Route State

- Flow name: Sysadmin hash-route parse/serialize, session restore/login, role-context switching, and workspace restore
- Context or scope: `#/admin` route family in `system-admin-live-app`, including hash parsing, route history behavior, session gate, and sessionStorage-backed sub-workspace restore.
- Start and precondition states: `admin-entry`; `route-parsed`; `session-restoring`; `unauthenticated`; `authenticated-admin`.
- Trigger: Hash changes, app boot in admin surface, login submit, role-context switch, explicit route navigation into `history`, `requests`, `students`, `faculty-members`, or proof hierarchy.
- Guards: `parseAdminRoute`/`routeToHash` canonicalization; role-context permissions from backend session grant set; scope validity checks for proof hierarchy and selected entities.
- Intermediate states: `hash-sync-pending`, `workspace-restored`, `workspace-restore-invalid`, `flash-notice`, `active-route-ready`, `history-visible`, `request-queue-visible`.
- Async or background transitions: restore-session attempts with 401 handling; cookie settlement retry loop after login; storage-backed workspace tab + section rehydration.
- Invalid or conflict states: corrupted sessionStorage workspace payload; stale selected scope/entity no longer present; stale version conflicts on mutating admin records (409 conflict path).
- Error states: restore failure (non-401), login failure, route-scoped data fetch failures, conflict mutation failure.
- Restore or re-entry states: faculties workspace restore notice path; explicit reset workspace fallback; hidden-record restore operations; route hash replay via parse/serialize cycle.
- Terminal states: authenticated route-ready state or unauthenticated gate after logout/session expiry.
- Recovery path: invalid restore payload triggers reset prompt and defaults to university overview; 401 restore loops terminate at sign-in gate; conflict paths require refetch-and-retry.
- Observed drift: no new contradiction added; C-006 remains separate and concerns request transition controls, not route/session parsing.
- Evidence: `src/system-admin-live-app.tsx:518`, `src/system-admin-live-app.tsx:546`, `src/system-admin-live-app.tsx:1999`, `src/system-admin-live-app.tsx:2207`, `src/system-admin-live-app.tsx:2209`, `src/system-admin-live-app.tsx:2270`, `src/system-admin-live-app.tsx:2312`, `src/system-admin-live-app.tsx:2317`, `src/system-admin-live-app.tsx:2324`, `src/system-admin-live-app.tsx:2350`, `src/system-admin-live-app.tsx:2359`, `tests/system-admin-live-data.test.ts`, `tests/portal-routing.test.ts`.
- Confidence: High for local implementation and tests around routing behavior; medium for live parity pending browser verification.
