# Dependency: Academic Route Snapshot And Role Sync

- Dependency name: Academic route snapshot and role sync
- Dependency type: user-state, route-state, runtime
- Source surface or action: internal navigation in `OperationalApp`
- Upstream dependency: `routeHistory`, `historyBackPage`, `selectedMenteeId`, `studentShellStudentId`, `selectedUnlockTaskId`, `schemeOfferingId`, `courseInitialTab`, mock bootstrap query params
- Downstream impacted surfaces: academic page selection, in-app back navigation, role home resolution, drilldown restore behavior
- Trigger: navigation buttons, cross-link handlers, role changes, mock bootstrap in API-absent mode
- Data contract or key fields: `RouteSnapshot`, `Role`, `page`, `offerings`, `student ids`, `unlock task ids`
- Runtime conditions: `window.location.search` seeds mock state only when the academic API base URL is absent; remote mode uses session and bootstrap projection instead
- Persistence or config coupling: route history is held in component state, so refresh behavior depends on the live bootstrap path rather than a separate storage layer
- Hidden coupling sources: `resolveRoleSyncState()` silently snaps illegal role/page combinations back to the role home; `resolveAssignedMentees()` may come from faculty profile mentor scope or from the session teacher record
- Failure mode: stale history snapshots or role-page mismatches can reopen the wrong page or suppress an intended deep link
- Drift risk: medium
- Evidence: `src/App.tsx:1160-1822`, `src/academic-workspace-route-helpers.ts:7-93`, `audit-map/15-final-maps/route-map.md`, `audit-map/15-final-maps/role-feature-matrix.md`
- Notes: this is in-memory route state, but it still behaves like a hidden dependency graph for the academic workspace

