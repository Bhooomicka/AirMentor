# Route Index

## Route Map Pass Output

- Detailed route map: [`15-final-maps/route-map.md`](../15-final-maps/route-map.md)
- Frontend hash routes: portal chooser, academic workspace, and sysadmin shell
- Academic workspace: internal state-only pages keyed by `PageId`
- Sysadmin workspace: structured hash deep links plus canonical proof hierarchy
- Backend endpoints: Fastify modules under `air-mentor-api/src/modules/`

Frontend route and page surfaces:

- `src/portal-routing.ts`
- `src/academic-workspace-route-helpers.ts`
- `src/academic-workspace-route-surface.tsx`
- `src/academic-route-pages.tsx`
- `src/pages/calendar-pages.tsx`
- `src/pages/course-pages.tsx`
- `src/pages/hod-pages.tsx`
- `src/pages/risk-explorer.tsx`
- `src/pages/student-shell.tsx`
- `src/pages/workflow-pages.tsx`
- `src/App.tsx`
- `src/main.tsx`
- `src/portal-entry.tsx`
- `src/system-admin-app.tsx`
- `src/system-admin-live-app.tsx`

Route-like state families now recorded in the detailed map:

- Academic page-state routes: `dashboard`, `students`, `course`, `calendar`, `upload`, `entry-workspace`, `scheme-setup`, `queue-history`, `mentees`, `mentee-detail`, `department`, `unlock-review`, `faculty-profile`, `student-history`, `student-shell`, `risk-explorer`
- Academic subview families: course tabs, student-shell tabs, risk-explorer tabs, HOD tabs, and calendar mode
- Sysadmin hash families: overview, proof-dashboard, students, faculty-members, requests, history, and the hierarchical faculties proof route
- Sysadmin subview families: university tabs, proof-dashboard tabs, registry detail tabs, proof playback restore state, and route-scoped section-code persistence

Backend route modules:

- `air-mentor-api/src/app.ts`
- `air-mentor-api/src/modules/academic-access.ts`
- `air-mentor-api/src/modules/academic-admin-offerings-routes.ts`
- `air-mentor-api/src/modules/academic-authoritative-first.ts`
- `air-mentor-api/src/modules/academic-bootstrap-routes.ts`
- `air-mentor-api/src/modules/academic-proof-routes.ts`
- `air-mentor-api/src/modules/academic-runtime-routes.ts`
- `air-mentor-api/src/modules/academic.ts`
- `air-mentor-api/src/modules/admin-control-plane.ts`
- `air-mentor-api/src/modules/admin-proof-sandbox.ts`
- `air-mentor-api/src/modules/admin-requests.ts`
- `air-mentor-api/src/modules/admin-structure.ts`
- `air-mentor-api/src/modules/client-telemetry.ts`
- `air-mentor-api/src/modules/courses.ts`
- `air-mentor-api/src/modules/institution.ts`
- `air-mentor-api/src/modules/people.ts`
- `air-mentor-api/src/modules/session.ts`
- `air-mentor-api/src/modules/students.ts`
- `air-mentor-api/src/modules/support.ts`
