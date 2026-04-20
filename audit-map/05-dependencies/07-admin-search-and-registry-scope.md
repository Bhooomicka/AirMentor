# Dependency: Admin Search And Registry Scope

- Dependency name: Admin search and registry scope resolution
- Dependency type: runtime, persistence, route-state
- Source surface or action: admin search bar, registry filters, proof branch scope, breadcrumbs
- Upstream dependency: `route.section`, `registryScope`, `selectedSectionCode`, canonical proof route, visibility filters, server search scope
- Downstream impacted surfaces: search results, breadcrumb labels, faculty/student/request registries, proof-branch-only datasets
- Trigger: typing search, changing section, navigating to faculties, opening proof dashboard, returning to scoped university
- Data contract or key fields: `LiveAdminRoute`, `UniversityScopeState`, `RegistryFilterState`, `LiveAdminSearchScope`, route snapshot key
- Runtime conditions: proof-dashboard and canonical proof route normalize into the proof branch; route-scoped filters change what the same search term can return
- Persistence or config coupling: route snapshots and selected section codes are stored in sessionStorage; dismissed queue items remain in localStorage
- Hidden coupling sources: canonical proof scope can replace the current registry scope; the same left rail and search box can therefore reflect a different slice of the institution without a visible mode switch
- Failure mode: restoring a stale route snapshot or switching scope mid-session can hide otherwise valid records, making search results look inconsistent
- Drift risk: medium
- Evidence: `src/system-admin-live-app.tsx:1997-2154, 2270-2344, 2640-2697, 3010-3127, 5955-6090, 6333-6403, 6797-7189`, `src/system-admin-live-data.ts:41-143, 190-350`, `src/proof-pilot.ts:100-125`, `air-mentor-api/src/modules/admin-control-plane.ts:306-420, 884-1075`
- Notes: this is the main hidden coupling that makes the sysadmin hierarchy behave differently under the proof branch

