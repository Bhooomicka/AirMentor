# Route Map

Pass: `route-map-pass`
Scope: bootstrap
Date: 2026-04-15

## Summary

- Frontend routing is hash-based at the portal level.
- The academic workspace uses internal page state and tab/mode families, not React Router.
- The sysadmin workspace uses structured hash deep links, canonical proof-route helpers, and session-backed restore state.
- Backend routing is Fastify-based and split across module-owned endpoint families.

## Hash Routes

| Route | Entry component or handler | Role access hints | Notes |
| --- | --- | --- | --- |
| `#/` | `PortalRouterApp` -> `PortalEntryScreen` in [`src/App.tsx`](../../src/App.tsx) and [`src/portal-entry.tsx`](../../src/portal-entry.tsx) | Public chooser | Top-level portal landing page. |
| `#/app` | `PortalRouterApp` -> `OperationalApp` in [`src/App.tsx`](../../src/App.tsx) | Authenticated academic portal | Any `#/app/*` hash also resolves here. |
| `#/admin` | `PortalRouterApp` -> `SystemAdminApp` -> `SystemAdminLiveApp` in [`src/App.tsx`](../../src/App.tsx) and [`src/system-admin-app.tsx`](../../src/system-admin-app.tsx) | Authenticated `SYSTEM_ADMIN` portal | Any `#/admin/*` hash also resolves here. |

Portal route restore behavior:

- `resolvePortalRoute()` and `hashBelongsToPortalRoute()` canonicalize `#/app/*` to the academic shell and `#/admin/*` to the sysadmin shell.
- `navigateToPortal()` mutates `window.location.hash` directly; the shell listens for `hashchange` and re-resolves on every navigation.
- Unknown hashes fall back to `#/` rather than a dead page.
- Exiting the admin portal clears `airmentor-current-admin-faculty-id`, `airmentor-current-faculty-id`, and `airmentor-current-teacher-id` before returning home.

## Academic Workspace Pages

These are route states inside `OperationalApp`, not URL path segments. Entry navigation comes from the role-specific sidebar, the top bar, and cross-link handlers in [`src/App.tsx`](../../src/App.tsx).

| Page id | Entry component or handler | Role hints | Navigation sources |
| --- | --- | --- | --- |
| `dashboard` | `CLDashboard` | `Course Leader` | `CL_NAV`, dashboard cards, `handleGoHome`, `handleOpenCourse`, `handleOpenCalendar`, `handleOpenUpload`. |
| `students` | `AllStudentsPage` | `Course Leader` | `CL_NAV`, dashboard, student drawer, history links, `handleOpenStudent`, `handleOpenHistoryFromStudent`. |
| `course` | `CourseDetail` | `Course Leader`, `HoD` | `handleOpenCourse`, calendar cross-link, student cross-links, `handleOpenCourseFromCalendar`. |
| `calendar` | `CalendarTimetablePage` | `Course Leader`, `Mentor`, `HoD` | `CL_NAV`, `MENTOR_NAV`, `HOD_NAV`, calendar cards, `handleOpenCalendar`. |
| `upload` | `UploadPage` | `Course Leader` | `CL_NAV`, `handleOpenUpload`, `handleSaveScheme` (returns here). |
| `entry-workspace` | `EntryWorkspacePage` | `Course Leader` | `handleOpenWorkspace`, `handleOpenEntryHub`. |
| `scheme-setup` | `SchemeSetupPage` | `Course Leader` | `handleOpenSchemeSetup`, `CourseDetail` action, `UploadPage` action. |
| `queue-history` | `QueueHistoryPage` | `Course Leader`, `Mentor`, `HoD` | `CL_NAV`, `MENTOR_NAV`, `HOD_NAV`, queue action rail, `handleOpenQueueHistory`. |
| `mentees` | `MentorView` | `Mentor` | `MENTOR_NAV`, `handleGoHome` for mentors. |
| `mentee-detail` | `MenteeDetailPage` | `Mentor` | `handleOpenMentee`, mentee history links, task links. |
| `department` | `HodView` | `HoD` | `HOD_NAV`, `handleGoHome` for HoD. |
| `unlock-review` | `UnlockReviewPage` | `HoD` | Queue history, lock/unlock workflow, `handleOpenUnlockReview`. |
| `faculty-profile` | `FacultyProfilePage` | Cross-cutting route | Sidebar faculty-profile button; `handleOpenStudentProfile` may route here for mentor/self profile views. |
| `student-history` | `StudentHistoryPage` | Cross-cutting route | Student cards, mentee cards, queue items, history cross-links. |
| `student-shell` | `StudentShellPage` | Cross-cutting route | Student history cross-link, student drawer, proof controls. |
| `risk-explorer` | `RiskExplorerPage` | Cross-cutting route | Student history cross-link, student drawer, proof controls. |

Role gating is enforced by [`src/academic-workspace-route-helpers.ts`](../../src/academic-workspace-route-helpers.ts):

- `Course Leader`: `dashboard`, `students`, `course`, `calendar`, `upload`, `entry-workspace`.
- `Mentor`: `mentees`, `calendar`.
- `HoD`: `department`, `course`, `calendar`, `unlock-review`.
- Cross-cutting: `faculty-profile`, `student-history`, `student-shell`, `risk-explorer`, `queue-history`.

## Academic Route-State Families

These are the route-like internal page states that change visible behavior inside `OperationalApp`.

| Family | Canonical state | Entry source | Guard / restore behavior | Notes |
| --- | --- | --- | --- | --- |
| Course tabs | `overview`, `risk`, `attendance`, `tt1`, `tt2`, `quizzes`, `assignments`, `co`, `gradebook` | `CourseDetail` initial tab, `mockTab`, row actions from course and workspace views | `tt2` and `risk` are stage-locked when the offering is not far enough along | Local tab state only; no URL segment. |
| Student shell tabs | `overview`, `topic-co`, `assessment`, `interventions`, `timeline`, `chat` | `StudentShellPage` initial tab, proof/drilldown entry points | Timeline hydrates lazily; tab state is restored from the initial prop only | Hidden proof control popup is tied to this surface. |
| Risk explorer tabs | `overview`, `details`, `advanced` | `RiskExplorerPage` initial tab and drilldown links | Starts on `overview` unless an explicit initial tab is provided | Used for student history and shell drilldowns. |
| HOD tabs | `overview`, `courses`, `faculty`, `reassessments` | `HodView` local navigation | Visible only on the HoD page family | No URL segment; state lives inside the component tree. |
| Calendar mode | `calendar`, `timetable` | `CalendarTimetablePage` segmented control | Both modes are gated by the active role and shared timetable data | Mode switch changes the entire render path. |

Academic bootstrap and history state:

- `window.location.search` is parsed only in bootstrap/mock mode when the academic API base URL is absent.
- Query keys: `mockTeacher`, `mockRole`, `mockOfferingId`, `mockStudentUsn`, `mockMenteeId`, `mockPage`, `mockTab`, `mockKind`, `mockShowQueue`, `mockUnlockTaskId`.
- `mockTeacher` can switch the current teacher and inherited role context.
- `mockRole` resets the workspace to that role's home page.
- `mockOfferingId`, `mockStudentUsn`, `mockMenteeId`, and `mockPage` seed drilldown page state.
- `mockTab` seeds `courseInitialTab`; `mockKind` seeds both upload and entry kinds.
- `mockShowQueue` toggles the action queue; `mockUnlockTaskId` opens the HoD unlock review state.
- `routeHistory`, `historyBackPage`, `selectedUnlockTaskId`, `studentShellStudentId`, `selectedMenteeId`, and `schemeOfferingId` are the main restoreable route-snapshot fields.
- `restoreRouteSnapshot()` and `handleNavigateBack()` drive in-app back navigation without changing the URL.

## Sysadmin Hash Routes

Hash parsing and serialization live in [`src/system-admin-live-app.tsx`](../../src/system-admin-live-app.tsx).

| Route | Entry component or handler | Role hints | Notes |
| --- | --- | --- | --- |
| `#/admin/overview` | `SystemAdminLiveApp` overview workspace | `SYSTEM_ADMIN` | Default admin landing route. |
| `#/admin/proof-dashboard` | Proof dashboard workspace | `SYSTEM_ADMIN` | Proof-scoped admin surface. |
| `#/admin/students` | Student registry workspace | `SYSTEM_ADMIN` | Registry list route. |
| `#/admin/students/:studentId` | Student detail workspace | `SYSTEM_ADMIN` | Direct entity drilldown. |
| `#/admin/faculty-members` | Faculty registry workspace | `SYSTEM_ADMIN` | Registry list route. |
| `#/admin/faculty-members/:facultyMemberId` | Faculty detail workspace | `SYSTEM_ADMIN` | Direct entity drilldown. |
| `#/admin/requests` | Governed requests workspace | `SYSTEM_ADMIN` and some `HOD`-backed flows | List route. |
| `#/admin/requests/:requestId` | Request detail workspace | `SYSTEM_ADMIN` and some `HOD`-backed flows | Direct entity drilldown. |
| `#/admin/history` | Hidden-records / recycle-bin workspace | `SYSTEM_ADMIN` | Restore and archive history. |
| `#/admin/faculties` | University hierarchy workspace | `SYSTEM_ADMIN` | Sectioned registry workspace. |
| `#/admin/faculties/:academicFacultyId` | Faculty-level hierarchy workspace | `SYSTEM_ADMIN` | Base faculty scope. |
| `#/admin/faculties/:academicFacultyId/departments/:departmentId` | Department-level hierarchy workspace | `SYSTEM_ADMIN` | Department drilldown. |
| `#/admin/faculties/:academicFacultyId/departments/:departmentId/branches/:branchId` | Branch-level hierarchy workspace | `SYSTEM_ADMIN` | Branch drilldown. |
| `#/admin/faculties/:academicFacultyId/departments/:departmentId/branches/:branchId/batches/:batchId` | Batch-level hierarchy workspace | `SYSTEM_ADMIN` | Batch drilldown; canonical proof route extends here. |

The canonical proof route helper in [`src/proof-pilot.ts`](../../src/proof-pilot.ts) maps to:

- `#/admin/faculties/academic_faculty_engineering_and_technology/departments/dept_cse/branches/branch_mnc_btech/batches/batch_branch_mnc_btech_2023`

## Sysadmin Route-State Families

These are the hash routes and route-conditioned subviews inside `SystemAdminLiveApp`.

| Family | Canonical state | Entry source | Guard / restore behavior | Notes |
| --- | --- | --- | --- | --- |
| Overview shell | `#/admin/overview` | Default admin landing, top tabs, and route reset | Any non-admin hash is forced back to `#/admin/overview` on mount | Root admin workspace. |
| Proof dashboard | `#/admin/proof-dashboard` | Admin top tab and proof sandbox links | Loads session-backed dashboard state; checkpoint selection can auto-open the checkpoint tab | Uses proof playback selection and checkpoint restore notices. |
| Students registry | `#/admin/students` and `#/admin/students/:studentId` | Search results, audit links, scoped registry launches | Drilldown hash is preserved in history snapshots | Deep link family for student records. |
| Faculty members registry | `#/admin/faculty-members` and `#/admin/faculty-members/:facultyMemberId` | Search results, audit links, scoped registry launches | Drilldown hash is preserved in history snapshots | Deep link family for faculty records. |
| Requests | `#/admin/requests` and `#/admin/requests/:requestId` | Search results, audit links, HOD-backed request flows | Drilldown hash is preserved in history snapshots | Request list/detail family. |
| History | `#/admin/history` | Hidden history launchers and restore actions | Exposes archived and deleted records rather than live registry views | Recovery and audit-bin workspace. |
| Faculties hierarchy | `#/admin/faculties/...` | University navigation, canonical proof route, registry launches | Route-scoped restore uses `sessionStorage` key `airmentor-admin-ui:${routeToHash(route)}` | Canonical proof hierarchy resolves here. |

Admin route-conditioned subviews and persistence:

- `universityTab` is a route-level subview family with values `overview`, `bands`, `ce-see`, `cgpa`, `stage`, `courses`, and `provision`.
- `selectedSectionCode` filters the university scope and changes resolved-policy, resolved-stage-policy, and registry queries.
- `selectedSectionCode` is persisted with the route snapshot and restored from `sessionStorage` when the faculties route is revisited.
- `studentDetailTab` and `facultyDetailTab` are nested detail panes inside registry drilldowns, not standalone URL routes.
- `ProofDashboardTabId` is `summary`, `checkpoint`, `diagnostics`, and `operations`.
- The proof dashboard stores its tab in `sessionStorage` and auto-recovers to `checkpoint` when a checkpoint is selected, or back to `summary` if the checkpoint disappears.
- `selectedProofCheckpointSource` distinguishes `auto`, `restored`, and `manual` checkpoint selection for restore semantics.
- `proof-playback` localStorage stores `{ simulationRunId, simulationStageCheckpointId, updatedAt }` and drives the proof-dashboard restore notice and default checkpoint selection.
- `ADMIN_DISMISSED_QUEUE_STORAGE_KEY` keeps hidden queue dismissals stable across refreshes.

## Helper-Generated Routes And Deep Links

### Frontend bootstrap query params

These are parsed only in `OperationalApp` local/mock mode when the academic API base URL is absent or during bootstrap emulation.

- `mockTeacher`
- `mockRole`
- `mockOfferingId`
- `mockStudentUsn`
- `mockMenteeId`
- `mockPage`
- `mockTab`
- `mockKind`
- `mockShowQueue`
- `mockUnlockTaskId`

Route-affecting state sources in the academic workspace:

- `window.location.hash` controls the portal shell and sysadmin route families.
- `window.location.search` seeds mock bootstrap state only when the academic API is absent.
- `routeHistory` stores in-app back navigation snapshots for both academic and admin workspaces.
- `window.localStorage` clears portal workspace hints on portal exit and stores proof playback selection plus hidden queue dismissals.
- `window.sessionStorage` stores the admin proof-dashboard tab and the admin faculties route snapshot.
- Auth/session state gates role-specific page access and determines whether the academic workspace restores from remote session data or falls back to bootstrap mock mode.

### Admin helper-generated routes

- `routeToHash()` and `parseAdminRoute()` in [`src/system-admin-live-app.tsx`](../../src/system-admin-live-app.tsx) are the canonical serializer/parser pair.
- `getAuditEventRoute()` in [`src/system-admin-live-app.tsx`](../../src/system-admin-live-app.tsx) generates deep links from audit rows to `students`, `faculty-members`, or `requests`.
- `searchAdminWorkspace()` returns route targets that feed the admin search box and the left-rail result list.
- `CANONICAL_PROOF_ROUTE` in [`src/proof-pilot.ts`](../../src/proof-pilot.ts) is the proof-scoped faculties route base.
- `shouldResolveCanonicalProofRoute()` and `resolveAuthoritativeOperationalSemester()` in [`src/proof-pilot.ts`](../../src/proof-pilot.ts) decide when proof-scoped routes are auto-normalized or semantically treated as `proof-run`, `batch`, or `unavailable`.
- `restoreRouteSnapshot()` in [`src/App.tsx`](../../src/App.tsx) and the admin workspace history stack make the academic and admin shells behave like nested route stacks even without React Router.

## Local Versus Live Notes

- Local route parsing is verified by `tests/portal-routing.test.ts` and `tests/proof-pilot.test.ts`.
- Page-state and restore behavior are exercised by `tests/system-admin-proof-dashboard-workspace.test.tsx`, `tests/proof-playback.test.ts`, `tests/student-shell.test.tsx`, `tests/risk-explorer.test.tsx`, `tests/hod-pages.test.ts`, and `tests/academic-route-pages.test.tsx`.
- No live route capture was run in this pass.
- The only preexisting live route drift on record remains the Railway `/health` `404` in `audit-map/10-live-behavior/deployment-drift-log.md`.
- No new route contradiction was discovered in code or tests during this pass.

## Server Endpoints

### Core server routes

- `GET /` -> API status document in [`air-mentor-api/src/app.ts`](../../air-mentor-api/src/app.ts)
- `GET /health` -> health check in [`air-mentor-api/src/app.ts`](../../air-mentor-api/src/app.ts)
- `GET /openapi.json` -> Swagger/OpenAPI in [`air-mentor-api/src/app.ts`](../../air-mentor-api/src/app.ts)

### Session and prefs

Defined in [`air-mentor-api/src/modules/session.ts`](../../air-mentor-api/src/modules/session.ts).

- `GET /api/session`
- `POST /api/session/login`
- `DELETE /api/session`
- `POST /api/session/role-context`
- `GET /api/preferences/ui`
- `PATCH /api/preferences/ui`

Role hints:

- `GET /api/session` and `DELETE /api/session` are authenticated.
- `POST /api/session/login` is public login.
- `POST /api/session/role-context` is authenticated.
- Preference routes are authenticated.

### Client telemetry

Defined in [`air-mentor-api/src/modules/client-telemetry.ts`](../../air-mentor-api/src/modules/client-telemetry.ts).

- `POST /api/client-telemetry`

Role hints:

- Frontend-origin write path with origin/CSRF safeguards; not role-gated.

### Institution and structure admin

Defined in [`air-mentor-api/src/modules/institution.ts`](../../air-mentor-api/src/modules/institution.ts) and [`air-mentor-api/src/modules/admin-structure.ts`](../../air-mentor-api/src/modules/admin-structure.ts).

- `GET /api/admin/institution`
- `PATCH /api/admin/institution`
- `GET /api/admin/departments`
- `POST /api/admin/departments`
- `PATCH /api/admin/departments/:departmentId`
- `GET /api/admin/branches`
- `POST /api/admin/branches`
- `PATCH /api/admin/branches/:branchId`
- `GET /api/admin/terms`
- `POST /api/admin/terms`
- `PATCH /api/admin/terms/:termId`
- `GET /api/admin/academic-faculties`
- `POST /api/admin/academic-faculties`
- `PATCH /api/admin/academic-faculties/:academicFacultyId`
- `GET /api/admin/batches`
- `POST /api/admin/batches`
- `PATCH /api/admin/batches/:batchId`
- `GET /api/admin/curriculum-courses`
- `POST /api/admin/curriculum-courses`
- `PATCH /api/admin/curriculum-courses/:curriculumCourseId`
- `GET /api/admin/batches/:batchId/curriculum-feature-config`
- `POST /api/admin/batches/:batchId/curriculum/bootstrap`
- `GET /api/admin/batches/:batchId/curriculum/linkage-candidates`
- `POST /api/admin/batches/:batchId/curriculum/linkage-candidates/regenerate`
- `POST /api/admin/batches/:batchId/curriculum/linkage-candidates/:curriculumLinkageCandidateId/approve`
- `POST /api/admin/batches/:batchId/curriculum/linkage-candidates/:curriculumLinkageCandidateId/reject`
- `PUT /api/admin/batches/:batchId/curriculum-feature-config/:curriculumCourseId`
- `GET /api/admin/curriculum-feature-profiles`
- `POST /api/admin/curriculum-feature-profiles`
- `PATCH /api/admin/curriculum-feature-profiles/:curriculumFeatureProfileId`
- `PUT /api/admin/batches/:batchId/curriculum-feature-binding`
- `GET /api/admin/stage-policy-overrides`
- `POST /api/admin/stage-policy-overrides`
- `PATCH /api/admin/stage-policy-overrides/:stagePolicyOverrideId`
- `GET /api/admin/policy-overrides`
- `POST /api/admin/policy-overrides`
- `PATCH /api/admin/policy-overrides/:policyOverrideId`
- `GET /api/admin/batches/:batchId/resolved-policy`
- `GET /api/admin/batches/:batchId/resolved-stage-policy`
- `POST /api/admin/batches/:batchId/resolved-policy`

Role hints:

- `SYSTEM_ADMIN` for the admin structure routes.

### People, students, courses

Defined in [`air-mentor-api/src/modules/people.ts`](../../air-mentor-api/src/modules/people.ts), [`air-mentor-api/src/modules/students.ts`](../../air-mentor-api/src/modules/students.ts), and [`air-mentor-api/src/modules/courses.ts`](../../air-mentor-api/src/modules/courses.ts).

- `GET /api/admin/faculty`
- `POST /api/admin/faculty`
- `PATCH /api/admin/faculty/:facultyId`
- `POST /api/admin/faculty/:facultyId/appointments`
- `PATCH /api/admin/appointments/:appointmentId`
- `POST /api/admin/faculty/:facultyId/role-grants`
- `PATCH /api/admin/role-grants/:grantId`
- `GET /api/admin/students`
- `POST /api/admin/students`
- `PATCH /api/admin/students/:studentId`
- `POST /api/admin/students/:studentId/enrollments`
- `PATCH /api/admin/enrollments/:enrollmentId`
- `POST /api/admin/mentor-assignments/bulk-apply`
- `POST /api/admin/mentor-assignments`
- `PATCH /api/admin/mentor-assignments/:assignmentId`
- `GET /api/admin/courses`
- `POST /api/admin/courses`
- `PATCH /api/admin/courses/:courseId`

Role hints:

- `SYSTEM_ADMIN` for all routes in these modules.

### Admin requests

Defined in [`air-mentor-api/src/modules/admin-requests.ts`](../../air-mentor-api/src/modules/admin-requests.ts).

- `GET /api/admin/requests`
- `POST /api/admin/requests`
- `GET /api/admin/requests/:requestId`
- `POST /api/admin/requests/:requestId/assign`
- `POST /api/admin/requests/:requestId/request-info`
- `POST /api/admin/requests/:requestId/approve`
- `POST /api/admin/requests/:requestId/reject`
- `POST /api/admin/requests/:requestId/mark-implemented`
- `POST /api/admin/requests/:requestId/close`
- `POST /api/admin/requests/:requestId/notes`
- `GET /api/admin/requests/:requestId/audit`

Role hints:

- `GET /api/admin/requests` and `POST /api/admin/requests` accept `SYSTEM_ADMIN` and `HOD`.
- The mutation routes are `SYSTEM_ADMIN`-gated.
- `GET /api/admin/requests/:requestId/audit` is authenticated and request-scoped.

### Admin proof sandbox

Defined in [`air-mentor-api/src/modules/admin-proof-sandbox.ts`](../../air-mentor-api/src/modules/admin-proof-sandbox.ts).

- `GET /api/admin/batches/:batchId/proof-dashboard`
- `GET /api/admin/proof-models/active`
- `GET /api/admin/proof-models/evaluation`
- `GET /api/admin/proof-models/correlations`
- `GET /api/admin/proof-runs/:simulationRunId/checkpoints`
- `GET /api/admin/proof-runs/:simulationRunId/checkpoints/:checkpointId`
- `GET /api/admin/proof-runs/:simulationRunId/checkpoints/:checkpointId/students/:studentId`
- `POST /api/admin/batches/:batchId/proof-imports`
- `POST /api/admin/proof-imports/:curriculumImportVersionId/validate`
- `POST /api/admin/proof-imports/:curriculumImportVersionId/review-crosswalks`
- `POST /api/admin/proof-imports/:curriculumImportVersionId/approve`
- `POST /api/admin/batches/:batchId/proof-runs`
- `POST /api/admin/proof-runs/:simulationRunId/retry`
- `POST /api/admin/proof-runs/:simulationRunId/activate`
- `POST /api/admin/proof-runs/:simulationRunId/activate-semester`
- `POST /api/admin/proof-runs/:simulationRunId/archive`
- `POST /api/admin/proof-runs/:simulationRunId/recompute-risk`
- `POST /api/admin/proof-runs/:simulationRunId/restore-snapshot`
- `GET /api/admin/proof-runs/:simulationRunId/students/:studentId/evidence-timeline`

Role hints:

- `SYSTEM_ADMIN` for all proof sandbox routes.

### Academic bootstrap

Defined in [`air-mentor-api/src/modules/academic-bootstrap-routes.ts`](../../air-mentor-api/src/modules/academic-bootstrap-routes.ts).

- `GET /api/academic/public/faculty`
- `GET /api/academic/bootstrap`

Role hints:

- `GET /api/academic/public/faculty` is public.
- `GET /api/academic/bootstrap` is gated to `COURSE_LEADER`, `MENTOR`, and `HOD`.

### Academic proof routes

Defined in [`air-mentor-api/src/modules/academic-proof-routes.ts`](../../air-mentor-api/src/modules/academic-proof-routes.ts) and backed by [`src/system-admin-live-data.ts`](../../src/system-admin-live-data.ts) route state.

- `GET /api/academic/hod/proof-summary`
- `GET /api/academic/hod/proof-bundle`
- `GET /api/academic/hod/proof-courses`
- `GET /api/academic/hod/proof-faculty`
- `GET /api/academic/hod/proof-students`
- `GET /api/academic/hod/proof-reassessments`
- `POST /api/academic/proof-reassessments/:reassessmentEventId/acknowledge`
- `POST /api/academic/proof-reassessments/:reassessmentEventId/resolve`
- `GET /api/academic/student-shell/students/:studentId/card`
- `GET /api/academic/students/:studentId/risk-explorer`
- `GET /api/academic/student-shell/students/:studentId/timeline`
- `POST /api/academic/student-shell/students/:studentId/sessions`
- `POST /api/academic/student-shell/sessions/:sessionId/messages`

Role hints:

- HoD-only for the `hod/*` endpoints.
- `POST`/mutation proof routes accept `SYSTEM_ADMIN` plus academic roles where access helpers allow it.
- Student-shell and risk-explorer routes are proof-scoped and may be further limited by student context.

### Academic runtime and teaching workflows

Defined in [`air-mentor-api/src/modules/academic-runtime-routes.ts`](../../air-mentor-api/src/modules/academic-runtime-routes.ts).

- `PUT /api/academic/runtime/:stateKey` (deprecated compatibility route)
- `PUT /api/academic/runtime/drafts`
- `PUT /api/academic/runtime/cell-values`
- `PUT /api/academic/runtime/lock-by-offering`
- `PUT /api/academic/runtime/lock-audit-by-target`
- `PUT /api/academic/tasks/sync`
- `GET /api/academic/tasks`
- `PUT /api/academic/tasks/:taskId`
- `PUT /api/academic/task-placements/sync`
- `GET /api/academic/task-placements`
- `PUT /api/academic/task-placements/:taskId`
- `DELETE /api/academic/task-placements/:taskId`
- `PUT /api/academic/calendar-audit/sync`
- `GET /api/academic/calendar-audit`
- `POST /api/academic/calendar-audit`
- `PUT /api/academic/faculty-calendar-workspace/:facultyId`
- `POST /api/academic/meetings`
- `PATCH /api/academic/meetings/:meetingId`
- `PUT /api/academic/offerings/:offeringId/attendance`
- `PUT /api/academic/offerings/:offeringId/assessment-entries/:kind`
- `PUT /api/academic/offerings/:offeringId/scheme`
- `PUT /api/academic/offerings/:offeringId/question-papers/:kind`

Role hints:

- Runtime slice routes and tasks/placements/calendar audit routes accept `COURSE_LEADER`, `MENTOR`, or `HOD` as the academic role set.
- `PUT /api/academic/faculty-calendar-workspace/:facultyId`, `PUT /api/academic/offerings/:offeringId/attendance`, `PUT /api/academic/offerings/:offeringId/assessment-entries/:kind`, `PUT /api/academic/offerings/:offeringId/scheme`, and `PUT /api/academic/offerings/:offeringId/question-papers/:kind` are `COURSE_LEADER`-only.

### Academic admin offerings

Defined in [`air-mentor-api/src/modules/academic-admin-offerings-routes.ts`](../../air-mentor-api/src/modules/academic-admin-offerings-routes.ts).

- `GET /api/admin/course-outcomes`
- `POST /api/admin/course-outcomes`
- `PATCH /api/admin/course-outcomes/:courseOutcomeOverrideId`
- `GET /api/admin/offerings/:offeringId/resolved-course-outcomes`
- `GET /api/admin/offerings/:offeringId/stage-eligibility`
- `POST /api/admin/offerings/:offeringId/advance-stage`
- `POST /api/admin/batches/:batchId/provision`
- `GET /api/admin/offerings`
- `POST /api/admin/attendance-snapshots`
- `POST /api/admin/assessment-scores`
- `POST /api/admin/student-interventions`
- `POST /api/admin/transcript-term-results`
- `POST /api/admin/transcript-subject-results`
- `POST /api/admin/offerings`
- `PATCH /api/admin/offerings/:offeringId`
- `GET /api/admin/offering-ownership`
- `POST /api/admin/offering-ownership`
- `PATCH /api/admin/offering-ownership/:ownershipId`

Role hints:

- `SYSTEM_ADMIN` for admin mutation and setup routes.
- `GET /api/admin/offerings/:offeringId/resolved-course-outcomes` is authenticated and additionally scope-checked for offering visibility.

### Admin control plane

Defined in [`air-mentor-api/src/modules/admin-control-plane.ts`](../../air-mentor-api/src/modules/admin-control-plane.ts).

- `GET /api/admin/search`
- `GET /api/admin/audit-events`
- `GET /api/admin/audit-events/recent`
- `GET /api/admin/reminders`
- `POST /api/admin/reminders`
- `PATCH /api/admin/reminders/:reminderId`
- `GET /api/admin/faculty-calendar/:facultyId`
- `PUT /api/admin/faculty-calendar/:facultyId`
- `GET /api/academic/faculty-profile/:facultyId`

Role hints:

- Search, audit, and admin timetable routes are `SYSTEM_ADMIN`.
- Reminders are `SYSTEM_ADMIN` and faculty-scoped to the current admin user.
- `GET /api/academic/faculty-profile/:facultyId` is authenticated and allows self, `HOD`, or `SYSTEM_ADMIN`.

## Local And Live Verification Notes

- Local test run: `npm test -- tests/portal-routing.test.ts tests/proof-pilot.test.ts`
- Result: 2 files passed, 15 tests passed.
- Source inspection confirms there is no React Router; portal routing is handled by `parsePortalRoute()` / `navigateToPortal()` and the admin deep-link parser `parseAdminRoute()`.
- Existing live smoke coverage in the repo already targets `#/app`, `#/admin`, and the canonical proof faculty hierarchy route.
- No new contradictions surfaced in this pass.
