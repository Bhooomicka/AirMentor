# State Flow: Admin Request Lifecycle

- Flow name: Admin request status machine across backend transitions and sysadmin workspace controls
- Context or scope: Request lifecycle from creation through review, approval, implementation, and closure; includes backend-supported but UI-hidden transition branches.
- Start and precondition states: `New` request visible in queue; role/scope authorization satisfied.
- Trigger: take review action, approve action, mark implemented action, close action, backend transition endpoints (`needs info`, `rejected`) where called.
- Guards: transition must match current status and expected version; authorized admin actor; request visibility/filter scope checks.
- Intermediate states: `In Review`, `Approved`, `Implemented`, `Closed`, and backend-recognized branch states `Needs Info` and `Rejected`.
- Async or background transitions: queue refresh and list reload after mutation; status-driven action button text mapping in workspace.
- Invalid or conflict states: stale version conflict on request mutation; action requested for unsupported status.
- Error states: failed transition API call, conflict errors, missing request scope.
- Restore or re-entry states: archived/hidden queue item restore semantics are separate from request-status transitions and reinsert items into active queue visibility.
- Terminal states: `Closed` as visible terminal workflow state; `Rejected` as backend terminal branch when used.
- Recovery path: conflict path requires reload and replay with fresh version; unexposed transitions require explicit backend call path or future UI parity decision.
- Observed drift: contradiction C-006 persists: backend supports `Needs Info` and `Rejected` transitions while current sysadmin workspace exposes only `Take Review`, `Approve`, `Mark Implemented`, and `Close`.
- Evidence: `src/system-admin-request-workspace.tsx`, `src/system-admin-live-app.tsx:4538`, `src/system-admin-live-app.tsx:4539`, `src/system-admin-live-app.tsx:4540`, `src/system-admin-live-app.tsx:4541`, `air-mentor-api/src/modules/admin-requests.ts`, `air-mentor-api/tests/admin-foundation.test.ts`, `audit-map/14-reconciliation/contradiction-matrix.md`.
- Confidence: High for implemented local transition graph and mismatch evidence; medium for live operator usage without browser replay.
