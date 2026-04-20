# Dependency: Portal Routing And Theme

- Dependency name: Portal route canonicalization and theme persistence
- Dependency type: user-state, route-state, persistence
- Source surface or action: `PortalRouterApp`, `PortalEntryScreen`, theme toggle, portal exit
- Upstream dependency: `window.location.hash`, `airmentor-theme`, `airmentor-current-faculty-id`, `airmentor-current-admin-faculty-id`, `airmentor-current-teacher-id`
- Downstream impacted surfaces: `#/`, `#/app`, `#/admin`, `src/App.tsx`, `src/portal-entry.tsx`, `src/system-admin-app.tsx`, `src/academic-session-shell.tsx`
- Trigger: hash change, chooser navigation, theme switch, leaving admin or academic shells
- Data contract or key fields: canonical portal hashes, theme mode enum, faculty snapshot ids
- Runtime conditions: `#/app/*` and `#/admin/*` are collapsed to the shell root; unknown hashes fall back to home
- Persistence or config coupling: localStorage theme snapshot is shared across shells; admin exit clears faculty hint keys before returning home
- Hidden coupling sources: portal shell restore behavior depends on stale faculty ids and theme persistence, not only the visible hash
- Failure mode: malformed hashes or stale faculty hints can land the user in the wrong shell or force an unexpected home reset
- Drift risk: low
- Evidence: `src/App.tsx:3889-3925`, `src/portal-entry.tsx:48-60`, `src/repositories.ts:46-66, 213-220`
- Notes: portal routing is hash-based shell routing, not React Router

