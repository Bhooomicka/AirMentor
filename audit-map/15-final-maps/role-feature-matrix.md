# Role Feature Matrix

Pass: `role-surface-pass`
Date: 2026-04-15

This pass maps each role to the visible surfaces it can reach, the backend authority that actually applies, the hidden or indirect paths that can still expose the same truth, and the states that show the surface is blocked, locked, or out of scope.

## Role Matrix

| Role | Home / anchor surface | Visible UI | Backend authorization | Hidden or indirect paths | Notes |
| --- | --- | --- | --- | --- | --- |
| Public / unauthenticated | Portal chooser / login shell | Portal chooser, academic login, sysadmin login, auth errors, and public faculty lookup support | `GET /api/academic/public/faculty` is public; session, bootstrap, and admin APIs require auth | Protected workspaces can mount briefly before session resolution blocks them | No protected workspace state is usable without auth. |
| Course Leader | Dashboard | Dashboard, students registry, course pages, calendar/timetable, data entry hub, entry workspace, queue history, faculty profile, student-history, student-shell, and risk-explorer | Session role grant plus offering ownership, active-run, enrollment, and assignment checks | Scheme setup, upload, entry workspace, and drilldowns are reached from student cards, course actions, and queue rows | Visible UI is broader than write authority. |
| Mentor | My Mentees | Mentees list, mentee detail, queue history, calendar/timetable, faculty profile, student-history, student-shell, and risk-explorer | Session role grant plus active assignment, proof-run, and same-faculty scope checks | `mentee-detail` and bounded student drilldowns are reached from cards and history links, not from the top nav | Mentor UI is intentionally narrow, but indirect student drilldowns remain first-class. |
| HoD | Department | Department proof analytics, courses, faculty, reassessments, queue history, unlock-review, and faculty profile | Session role grant plus faculty context, proof-run selection rules, department / branch overlap checks, and requester-scoped admin request visibility | Unlock review opens from queue/history or direct hash; admin request list/create are requester-scoped | HoD is the only academic role with dedicated proof bundle / faculty / student / reassessment reads. |
| SYSTEM_ADMIN | Overview | Overview, proof dashboard, faculties, students, faculty members, requests, history, hierarchy modals, registry search, detail tabs, and inline action queue | All `/api/admin/*`, proof sandbox routes, and broader academic inspection paths | Hidden-records, canonical proof route, search routing, inline queue, modals, and restore surfaces are reachable without the visible top tabs | `SystemAdminSessionBoundary` blocks the workspace unless the active session role is `SYSTEM_ADMIN`. |

## Cross-Role Truth Coupling

- Student truth is split across course leader, mentor, HoD, and sysadmin views.
- Course truth is operational in course leader, proof-scoped in HoD, and structural in sysadmin.
- Proof-run truth is shared by academic roles, but sysadmin can inspect inactive runs and checkpoints.
- Faculty truth is shared across faculty-profile, HoD overlap checks, and sysadmin registries.
- Request truth is requester-scoped for HoD list/create but operational for sysadmin review.

## Same-Student Parity Overlay (2026-04-16)

- Durable local parity matrix: `audit-map/32-reports/same-student-cross-surface-parity-report.md`.
- Canonical explicit checkpoint render anchor: `mnc_student_001 / 1MS23MC001 / run_001 / checkpoint_001 / semester 6 / Post TT1` across faculty-profile, HoD, risk explorer, and student shell.
- Runtime parity contract for course leader / mentor / HoD drilldowns:
  - explicit playback should preserve `simulationRunId`, `simulationStageCheckpointId`, student identity, and semester/stage across queue rows, risk explorer, and student shell
  - default slices may legitimately follow the activated semester instead of an explicit checkpoint
- Allowed surface-specific differences:
  - `SYSTEM_ADMIN` exposes per-course checkpoint projections, diagnostics, worker/readiness state, and inactive-run inspection
  - `COURSE_LEADER` is filtered by owned offerings
  - `MENTOR` is filtered by active mentee assignments
  - `HOD` is filtered by department / branch overlap and exposes aggregate watch/faculty/reassessment rollups
  - `student shell` adds bounded deterministic explanation/chat
  - `risk explorer` adds trained heads, feature provenance/completeness, and derived scenario heads
- Open contradiction `C-021`: default faculty / HoD / student proof slices can become checkpoint-backed while still presenting `proof-run` provenance after the service layer clears checkpoint metadata.

## Public / unauthenticated

- Role: Public / unauthenticated
- Surface name: Portal chooser and login shell
- Parent workflow: Authentication entry and portal selection
- Entry points: `#/`, `#/app`, `#/admin`
- Routes and deep links: `#/` chooser, `#/app` academic portal, `#/admin` sysadmin portal
- Preconditions: no authenticated session
- Visible UI: portal chooser, academic login, sysadmin login, auth failure states, and public faculty lookup support
- Hidden or conditional UI: protected workspaces can mount briefly but immediately block on session state
- Allowed actions: choose a portal, submit login, refresh auth
- Restricted or blocked actions: all protected academic and sysadmin surfaces
- Backend enforcement: session, bootstrap, and admin APIs require auth; only `GET /api/academic/public/faculty` is public
- Data exposure and scope filters: no protected workspace data without auth
- Loading, empty, disabled, locked, and error states: auth loading, login error, blocked shell, empty session state
- Indirect access paths: none beyond login redirects
- Cross-role truth dependencies: no role-grant truth is available until login
- Known mismatches: protected shells can render briefly before the auth gate resolves
- Evidence: `src/portal-routing.ts`, `src/api/client.ts`, `air-mentor-api/src/modules/academic-bootstrap-routes.ts`
- Confidence level: high

## Course Leader

- Role: Course Leader
- Surface name: Course Leader workspace
- Parent workflow: Teaching operations, course management, and live entry
- Entry points: `#/app`, role switcher, dashboard home, course rows, calendar rows, student cards, and upload actions
- Routes and deep links: `dashboard`, `students`, `course`, `calendar`, `upload`, `entry-workspace`, `queue-history`, `scheme-setup`, `student-history`, `student-shell`, `risk-explorer`, and `faculty-profile`
- Preconditions: active Course Leader grant, current proof-scoped bootstrap, and an offering or student in scope
- Visible UI: dashboard proof strip, high-watch and pending-action cards, year/offering cards, students table with profile/history/data-entry actions, course tabs for overview/risk/attendance/tt1/tt2/quizzes/assignments/co/gradebook, calendar and timetable views, data entry hub, entry workspace, queue history, and the faculty-profile button
- Hidden or conditional UI: `scheme-setup` and `entry-workspace` can be launched from course and upload actions, `tt2` and `risk` lock before stage 2, `resolveRoleSyncState()` snaps illegal page/role combinations back to the home page, and indirect drilldowns from student cards and queue rows expose extra surfaces
- Allowed actions: open students, open course drilldowns, edit schema and timetable data, save drafts, submit and lock, request unlock from HoD, schedule and move classes, and open student shell / risk explorer for in-scope students
- Restricted or blocked actions: admin-only proof sandbox, sysadmin registries, HOD-only proof bundle reads, and any student or offering outside scope
- Backend enforcement: session role-context, `requireRole`, `assertViewerCanReadOffering`, `assertViewerCanSuperviseStudent`, course-leader offering ownership checks, `resolveProofReassessmentAccess`, `evaluateStudentShellSessionMessageAccess`, and the offering ownership / enrollment checks in `air-mentor-api/src/modules/academic.ts`
- Data exposure and scope filters: assigned offerings, enrolled students, proof-scoped bootstrap role availability, calendar offerings, year and section filters, and course-specific risk and gradebook data
- Loading, empty, disabled, locked, and error states: dashboard proof summary loading, empty student registries, no-roster states, scheme-not-ready warnings, read-only mentor notes on upload, `CSV import is disabled in v1`, lock warnings, stage-locked tabs, and read-only fallback surfaces
- Indirect access paths: row clicks, student cards, course card actions, queue rows, history links, calendar actions, and role-sync recovery after invalid deep links
- Cross-role truth dependencies: the same student appears in course leader registry, history, shell, and risk views; the same course truth feeds upload, gradebook, and timetable; the same proof-run selection drives dashboard and drilldowns
- Known mismatches: the client can surface route names that the backend still rejects by scope, and the role switcher may snap back from illegal pages even if the route existed in history
- Evidence: `src/academic-workspace-route-helpers.ts`, `src/academic-workspace-sidebar.tsx`, `src/academic-workspace-route-surface.tsx`, `src/academic-route-pages.tsx`, `src/pages/workflow-pages.tsx`, `src/pages/course-pages.tsx`, `src/pages/calendar-pages.tsx`, `air-mentor-api/src/modules/academic.ts`, `air-mentor-api/src/modules/academic-proof-routes.ts`, `tests/academic-route-pages.test.tsx`, `air-mentor-api/tests/student-agent-shell.test.ts`
- Confidence level: high

## Mentor

- Role: Mentor
- Surface name: Mentor workspace
- Parent workflow: Mentee management, intervention review, and bounded student drilldown
- Entry points: `#/app`, role switcher, mentee cards, search results, queue rows, history links, and calendar actions
- Routes and deep links: `mentees`, `mentee-detail`, `queue-history`, `calendar`, `faculty-profile`, `student-history`, `student-shell`, and `risk-explorer`
- Preconditions: active Mentor grant, assigned mentees, and the current faculty context
- Visible UI: mentee list with proof summary strip, search field, risk filters, clear search, action queue, per-mentee cards, phone and email contact actions, mentee detail with metrics and intervention timeline, queue history, calendar/timetable, and the faculty-profile button
- Hidden or conditional UI: `mentee-detail` is not a top-level nav item, `student-history` / `student-shell` / `risk-explorer` appear through drilldowns and history follow-through, and empty-state messaging appears when no mentees match the filter
- Allowed actions: search mentees, filter by risk, open student history, open student shell, open risk explorer, inspect intervention timeline, copy contact details, review queue history, and navigate through the calendar
- Restricted or blocked actions: course-leader editing paths, scheme setup, entry workspace, unlock review, sysadmin registries, and any out-of-scope student
- Backend enforcement: active assignment checks, active proof-run selection, same-faculty context, `assertViewerCanSuperviseStudent`, `resolveProofReassessmentAccess`, and `evaluateStudentShellSessionMessageAccess`
- Data exposure and scope filters: mentor scope prefers `facultyProfile.mentorScope.studentIds` over bootstrap mentee hints, and the proof summary strip is derived from the current proof-scoped snapshot
- Loading, empty, disabled, locked, and error states: no-mentees results, no-history paths, disabled drilldown buttons when no selected mentee exists, and general page loading during proof-scoped refresh
- Indirect access paths: mentee card clicks, row history links, queue history, student-shell and risk-explorer buttons, calendar row actions, and the faculty-profile button
- Cross-role truth dependencies: the same student appears in mentor cards, course leader registries, HoD proof analytics, and sysadmin registries, but mentor truth is collapsed to assignment and intervention context
- Known mismatches: the mentor home page is narrow, but indirect drilldowns still expose student-shell and risk-explorer; the bootstrap-derived role list can hide a grant that still exists in the underlying session
- Evidence: `src/academic-workspace-route-helpers.ts`, `src/academic-workspace-sidebar.tsx`, `src/academic-workspace-route-surface.tsx`, `src/academic-route-pages.tsx`, `air-mentor-api/src/modules/academic.ts`, `air-mentor-api/tests/academic-access.test.ts`, `tests/academic-route-pages.test.tsx`
- Confidence level: high

## HoD

- Role: HoD
- Surface name: Department proof analytics and unlock review
- Parent workflow: Department oversight, proof review, and unlock decisions
- Entry points: `#/app`, role switcher, department home, queue rows, unlock-review hashes, and faculty-profile drilldowns
- Routes and deep links: `department`, `course`, `calendar`, `queue-history`, `unlock-review`, `faculty-profile`, `student-history`, `student-shell`, and `risk-explorer`
- Preconditions: active HoD grant, faculty context, and a proof run that the department can inspect
- Visible UI: department proof analytics, proof summary strip, overview/courses/faculty/reassessments tabs, course rollups, faculty rollups, student watch rows, reassessment rows, queue history entry, unlock-review page, and faculty profile
- Hidden or conditional UI: unlock-review is not a top-level nav item, it is opened from queue/history or a direct hash, admin request list/create are requester-scoped, and faculty-profile access still depends on department and branch overlap checks
- Allowed actions: inspect proof analytics, filter the watchlist, open queue history, open unlock review, approve or reject unlock requests, complete reset and unlock after approval, and open faculty / student drilldowns that remain in scope
- Restricted or blocked actions: sysadmin request mutations, arbitrary faculty reads outside overlap checks, inactive proof-run selection, and any student-shell or risk-explorer path that fails scope checks
- Backend enforcement: faculty context checks, proof-run selection checks, `assertViewerCanReadOffering`, `assertViewerCanSuperviseStudent`, `resolveProofReassessmentAccess`, `canAccessAdminRequest`, and the separate academic unlock-request workflow in `air-mentor-api/src/modules/academic.ts`
- Data exposure and scope filters: department and branch scopes, active proof run, checkpoint overlays, requester-scoped admin requests, and course / faculty / student rollups pulled from the same live proof snapshot
- Loading, empty, disabled, locked, and error states: `Loading live HoD proof analytics...`, the no-active-proof-run empty state, error banners, the read-only checkpoint overlay, and the queue filter that can collapse the watchlist to action-needed rows only
- Indirect access paths: queue history button, unlock-review from task rows, direct hash navigation, proof-launcher controls, student rows, course rows, faculty rows, and reassessment rows
- Cross-role truth dependencies: HoD sees the same student and faculty truth as the other academic roles, but filtered through department scope and the active proof run instead of an operational class roster
- Known mismatches: admin-request visibility is requester-scoped rather than global across all HoDs, so the request queue is narrower than the role name suggests
- Evidence: `src/academic-workspace-route-helpers.ts`, `src/academic-workspace-route-surface.tsx`, `src/academic-route-pages.tsx`, `src/pages/hod-pages.tsx`, `air-mentor-api/src/modules/academic.ts`, `air-mentor-api/src/modules/academic-proof-routes.ts`, `air-mentor-api/src/modules/admin-requests.ts`, `air-mentor-api/tests/hod-proof-analytics.test.ts`
- Confidence level: high

## SYSTEM_ADMIN

- Role: SYSTEM_ADMIN
- Surface name: Sysadmin portal and proof control plane
- Parent workflow: Registry administration, proof operations, and live audit
- Entry points: `#/admin`, search results, hidden history hashes, proof-dashboard hashes, registry cards, and canonical proof hierarchy routes
- Routes and deep links: `overview`, `proof-dashboard`, `faculties`, `students`, `faculty-members`, `requests`, `history`, `#/admin/faculties/.../batches/...`, and the student / faculty detail subroutes
- Preconditions: `SYSTEM_ADMIN` active session role and the admin boundary
- Visible UI: top bar search, breadcrumbs, mode chip, top tabs, inline action queue, proof dashboard tabs for summary/checkpoint/diagnostics/operations, hierarchy tabs for overview/bands/ce-see/cgpa/stage/courses/provision, student registry filters and detail tabs, faculty-member registry filters and detail tabs, request list and detail panes, restore / archive / recycle-bin history panes, and many edit modals
- Hidden or conditional UI: the canonical proof route is not a top tab, `#/admin/history` is the hidden-records surface, search can route into students / faculty / requests without using the tabs, inline action queue is conditional on viewport, and the hierarchy and timetable edits open in modals or drawers rather than full pages
- Allowed actions: search across admin entities, inspect proof playback, create or edit faculties and students, edit hierarchy and timetable state, review requests, restore archived records, and inspect inactive proof or checkpoint states
- Restricted or blocked actions: none of the academic role gates apply here, but the academic portal role switcher does not expose `SYSTEM_ADMIN`
- Backend enforcement: all `/api/admin/*` families, proof sandbox routes, and session role-context / auth gates on the admin control plane
- Data exposure and scope filters: hidden / archived / deleted filtering, section-scoped registry filters, proof-playback diagnostics, and search routing into the students / faculty-members / requests / faculties subtrees
- Loading, empty, disabled, locked, and error states: proof-dashboard loading and blocked-stage states, request detail loading, no-request-selected and request-not-found empty states, live-data refreshing banners, restore banners, empty registries, locked recurring edits in the timetable modal, and history restore windows
- Indirect access paths: search, breadcrumbs, inline queue actions, student and faculty row clicks, history entries, modal follow-through, proof launcher popup actions, and the canonical proof route
- Cross-role truth dependencies: the sysadmin view is the most canonical registry for students, faculty, requests, and proof operations, but its request action surface is narrower than the backend transition set
- Known mismatches: the request workspace only exposes the status-driven `Take Review` / `Approve` / `Mark Implemented` / `Close` path even though the backend supports `Needs Info` and `Rejected` transitions; the sysadmin role is absent from the academic role switcher by design
- Evidence: `src/system-admin-live-app.tsx`, `src/system-admin-request-workspace.tsx`, `src/system-admin-faculties-workspace.tsx`, `src/system-admin-proof-dashboard-workspace.tsx`, `src/system-admin-history-workspace.tsx`, `tests/system-admin-live-data.test.ts`, `tests/system-admin-accessibility-contracts.test.tsx`, `tests/system-admin-faculties-workspace.test.tsx`, `tests/system-admin-proof-dashboard-workspace.test.tsx`, `air-mentor-api/src/modules/admin-control-plane.ts`, `air-mentor-api/src/modules/admin-requests.ts`, `air-mentor-api/src/modules/admin-proof-sandbox.ts`
- Confidence level: high

## Role-Specific Loading and Blocked States

- Course Leader surfaces block on invalid role/page combinations, missing offerings, locked tabs, missing roster data, and unlock requests that have not been granted yet.
- Mentor surfaces block on empty mentee sets, missing selected mentee history, and drilldowns that fail assignment or proof-scope checks.
- HoD surfaces block on no active proof run, checkpoint overlays, and any faculty or student outside the department and branch overlap rules.
- SYSTEM_ADMIN surfaces block on hidden or deleted records, request state transitions that do not match the visible button path, and locked timetable recurrence edits.
- Public surfaces block on any protected session state before login resolves.

## Evidence Anchor Summary

- Academic role routing: `src/academic-workspace-route-helpers.ts`, `src/academic-workspace-route-surface.tsx`, `src/academic-workspace-sidebar.tsx`
- Academic role pages: `src/academic-route-pages.tsx`, `src/pages/workflow-pages.tsx`, `src/pages/course-pages.tsx`, `src/pages/calendar-pages.tsx`, `src/pages/hod-pages.tsx`, `src/pages/student-shell.tsx`, `src/pages/risk-explorer.tsx`
- Academic backend guards: `air-mentor-api/src/modules/academic.ts`, `air-mentor-api/src/modules/academic-proof-routes.ts`, `air-mentor-api/src/modules/academic-bootstrap-routes.ts`, `air-mentor-api/src/modules/admin-requests.ts`, `air-mentor-api/src/modules/support.ts`
- Admin surfaces: `src/system-admin-live-app.tsx`, `src/system-admin-request-workspace.tsx`, `src/system-admin-faculties-workspace.tsx`, `src/system-admin-proof-dashboard-workspace.tsx`, `src/system-admin-history-workspace.tsx`
- Test anchors: `tests/academic-route-pages.test.tsx`, `tests/academic-workspace-route-helpers.test.ts`, `tests/academic-workspace-route-surface.test.tsx`, `tests/system-admin-live-data.test.ts`, `tests/system-admin-accessibility-contracts.test.tsx`, `air-mentor-api/tests/admin-foundation.test.ts`, `air-mentor-api/tests/academic-access.test.ts`, `air-mentor-api/tests/student-agent-shell.test.ts`

## Confidence Summary

- Public / unauthenticated: high
- Course Leader: high
- Mentor: high
- HoD: high
- SYSTEM_ADMIN: high
- Live verification: pending for later pass

## Frontend Microinteraction Overlay (cross-role)

- Component-cluster microinteraction evidence is now centralized in `audit-map/12-frontend-microinteractions/component-cluster-microinteraction-map.md`.
- Course Leader / Mentor / HoD share the academic shell and calendar/timetable interaction stack, but role-specific scope checks still gate which drag/edit and drilldown actions commit.
- SYSTEM_ADMIN carries the highest interaction density through `src/system-admin-live-app.tsx`, where search, queue controls, route restore, proof dashboard playback, and hierarchy restore interact through shared route/storage context.
- Persisted restore keys create cross-role continuity risks when context changes (`airmentor-proof-playback-selection`, `airmentor-system-admin-proof-dashboard-tab`, `airmentor-admin-ui:<hash>`), so re-entry guards remain a primary coupling control.
- Local admin request transition parity is now restored: current UI controls match the backend-supported transition set, so the remaining risk is deployed/live parity rather than local role-surface mismatch.
