# Dependency: Admin Request Visibility And Transitions

- Dependency name: Admin request visibility and status transitions
- Dependency type: auth/session, runtime, data contract
- Source surface or action: requests list, request detail, take review, approve, request info, reject, mark implemented, close
- Upstream dependency: active faculty context, requester faculty id, owner faculty id, optimistic version, allowed status transition graph
- Downstream impacted surfaces: requests list visibility, request detail drawer, action labels, notes, audit history, status chips
- Trigger: opening the request queue, drilling into a request, or performing a status transition
- Data contract or key fields: `New`, `In Review`, `Needs Info`, `Approved`, `Rejected`, `Implemented`, `Closed`, `requestedByFacultyId`, `ownedByFacultyId`, `version`
- Runtime conditions: SYSTEM_ADMIN sees all requests; HODs see only requests requested by their faculty; `scope=open` removes closed requests
- Persistence or config coupling: transitions create audit rows and notes in the backend; version mismatches are rejected by the backend transition helper
- Hidden coupling sources: the frontend action rail is status-driven and does not expose the full backend transition graph; backend visibility also depends on faculty ownership, not just the current role
- Failure mode: an action can exist in the backend but not in the UI, or a stale version can cause the transition to fail and leave the request in its previous state
- Drift risk: high
- Evidence: `air-mentor-api/src/modules/admin-requests.ts:59-66, 126-383`, `air-mentor-api/src/modules/support.ts:231-256`, `src/system-admin-request-workspace.tsx:45-155`, `src/system-admin-live-app.tsx:3131-3140, 4539-4543, 7599-7601`, `src/api/client.ts:319-343, 1336-1460`
- Notes: the known `Needs Info` / `Rejected` UI mismatch is a dependency surface, not just a UI omission

