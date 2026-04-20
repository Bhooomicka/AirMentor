# Long-Tail Interaction Map

Pass: `frontend-long-tail-pass`
Date: 2026-04-16
Status: durable manual rerun after wrapper/artifact drift

This artifact extends `component-cluster-microinteraction-map.md` beyond the six already-mapped high-density clusters and focuses on the remaining sysadmin helper and shell interactions that were still only named as gaps.

## Drift Check

- At pass start, `audit-map/29-status/audit-air-mentor-ui-bootstrap-frontend-long-tail-pass.status` and the paired checkpoint still reported `state=running` / `last_event=running`, while the wider audit corpus had already downgraded the earlier wrapper completion as non-creditable.
- This rerun writes the missing durable interaction artifact, updates the coverage ledgers, writes the missing last-message file, and reconciles the pass control files so the audit OS no longer depends on wrapper labels alone for this surface.
- Evidence: `audit-map/29-status/audit-air-mentor-ui-bootstrap-frontend-long-tail-pass.status`, `audit-map/30-checkpoints/audit-air-mentor-ui-bootstrap-frontend-long-tail-pass.checkpoint`, `audit-map/32-reports/operator-dashboard.md`, `audit-map/14-reconciliation/contradiction-matrix.md`

## 1) Section Scope Selectors, Scope IDs, And Restore Hooks

- Where it appears: `src/system-admin-faculties-workspace.tsx`, `src/admin-section-scope.ts`, `src/system-admin-provisioning-helpers.ts`, `src/system-admin-live-app.tsx`
- Role restriction: `SYSTEM_ADMIN`
- Trigger: selecting Faculty, Department, Branch, Year, or Section in the faculties workspace; navigating back; resetting the faculties workspace restore banner
- Visible effect: the University workspace narrows from faculty to department to branch to year to section; captions, governance scope messages, registry-launch chips, and provisioning copy switch to the selected scope
- State mutation:
  - `selectedSectionCode`
  - `route`
  - `routeHistory`
  - `registryScope`
  - `studentRegistryFilter`
  - `facultyRegistryFilter`
- Persistence / restore behavior:
  - faculties workspace tab and section are stored in `sessionStorage` under `airmentor-admin-ui:${routeToHash(route)}`
  - `routeHistory` stores `{ route, universityTab, selectedSectionCode, scrollY }` in memory only, so breadcrumb-style back navigation survives in-session but not a full reload
  - `handleResetFacultiesWorkspaceRestore()` removes the current route-hash restore key and resets tab + section to default
- API consequence:
  - section scope feeds `getResolvedBatchPolicy(batchId, { sectionCode })`
  - section scope feeds `getResolvedStagePolicy(batchId, { sectionCode })`
  - scoped directory fetches use `listFaculty(scopedAdminDirectoryFilter)` and `listStudents(scopedAdminDirectoryFilter)`
  - workspace search scopes `searchAdminWorkspace(query, activeSearchScope)` by the active hierarchy selection
- Test backing: `tests/system-admin-overview-helpers.test.ts` proves section-aware `describeRegistryScope()`, `matchesStudentScope()`, `matchesFacultyScope()`, `matchesOfferingScope()`, and `computeOverviewScopedCounts()`
- Ambiguity / drift risk:
  - `src/system-admin-live-app.tsx` redefines `normalizeAdminSectionCode()`, `buildAdminSectionScopeId()`, `parseAdminSectionScopeId()`, and scope-chain construction instead of importing `src/admin-section-scope.ts`, so section-scope semantics currently have two local sources of truth
  - the visible Section selector in `SystemAdminFacultiesWorkspace` builds options from current student records in the batch, not canonical `selectedBatch.sectionLabels`; a configured section with zero active students is therefore not selectable even though other parts of the same workspace still treat the section as real. This is tracked as `C-011`

## 2) Scoped Registry Launchers And Breadcrumb Return

- Where it appears: `src/system-admin-scoped-registry-launches.tsx`, `src/system-admin-faculties-workspace.tsx`, `src/system-admin-live-app.tsx`, `src/system-admin-overview-helpers.ts`
- Role restriction: `SYSTEM_ADMIN`
- Trigger: clicking `Open #/admin/students`, `Open All Students`, `Open Scoped Faculty`, or `Open Full Faculty` from the faculties workspace
- Visible effect:
  - scoped launches move the operator into `#/admin/students` or `#/admin/faculty-members` with scope chips and captions preserved
  - full launches clear scope and open the global registry
  - breadcrumbs in student/faculty registries gain a clickable scope segment that returns to the faculties workspace
- State mutation:
  - scoped launch sets `registryScope`
  - scoped launch hydrates the corresponding registry filter from the active hierarchy scope
  - full launch clears `registryScope` and resets the corresponding registry filter to defaults
- Persistence / restore behavior:
  - `registryScope` is in-memory only; it survives route changes within the session but not a page reload
  - `handleReturnToScopedUniversity()` uses the stored scope snapshot to rebuild the faculties route and section selection, but that return path disappears after `handleOpenFullRegistry()` clears the snapshot
- API consequence:
  - scoped launches trigger server-side scoped directory fetches through `apiClient.listFaculty(scopedAdminDirectoryFilter)` and `apiClient.listStudents(scopedAdminDirectoryFilter)`
  - subsequent search requests also use the active scoped filter
- Test backing: presentational coverage only in `tests/system-admin-faculties-workspace.test.tsx`; no direct runtime test covers scoped launch state hydration or breadcrumb return
- Ambiguity / drift risk:
  - the return-to-scope breadcrumb depends on transient `registryScope`, not on sessionStorage restore
  - `Open Complete Page` intentionally discards the scoped snapshot, so operators can lose the easy return path after switching to the full registry

## 3) Bulk Mentor Assignment Preview / Apply

- Where it appears: `src/system-admin-provisioning-helpers.ts`, `src/system-admin-faculties-workspace.tsx`, `src/system-admin-live-app.tsx`
- Role restriction: `SYSTEM_ADMIN` with a selected batch; section-aware when `selectedSectionCode` is set
- Trigger:
  - selecting a mentor-eligible faculty member
  - switching between `missing-only` and `replace-all`
  - changing `effectiveFrom` or `source`
  - clicking `Preview Mentor Assignments`
  - clicking `Apply Previewed Mentor Changes`
- Visible effect:
  - the workspace shows scope-specific eligibility labels, preview summary text, counts chips, and per-student action cards
  - `Apply Previewed Mentor Changes` only becomes actionable when the preview includes real create/end-date changes
  - apply is gated by `window.confirm(...)`
- State mutation:
  - `bulkMentorAssignmentForm`
  - `bulkMentorAssignmentPreview`
  - flash messaging after preview/apply
- Persistence / restore behavior:
  - no local persistence
  - an effect auto-selects a fallback mentor-eligible faculty member and current semester start date when batch/section context changes
  - another effect clears `bulkMentorAssignmentPreview` whenever batch, section, faculty, effective date, source, or selection mode changes
- API consequence:
  - preview calls `apiClient.bulkApplyMentorAssignments(buildBulkMentorAssignmentPreviewPayload(...))`
  - apply calls the same endpoint with `previewOnly=false` plus `expectedStudentIds` from the preview to guard against stale selection drift
  - successful apply refreshes admin data and clears the preview
- Test backing: static coverage in `tests/system-admin-faculties-workspace.test.tsx` for the rendered bulk mentor assignment surface; no direct interaction test covers preview invalidation or apply confirmation
- Ambiguity / drift risk:
  - the feature is safer than a blind bulk mutation because apply uses preview-returned `studentIds`, but there is still no direct test proving end-to-end invalidation across batch/section changes
  - mentor eligibility depends on role-grant scope matching in `getScopedMentorEligibleFaculty()`, so drift between section-scope helper implementations would directly affect the visible eligible-faculty pool

## 4) Action Queue Dismiss / Restore And Reminder Semantics

- Where it appears: `src/system-admin-action-queue.ts`, `src/system-admin-live-app.tsx`, `src/system-admin-ui.tsx`
- Role restriction: `SYSTEM_ADMIN`
- Trigger:
  - clicking `Hide forever` on requests, reminders, or hidden-record restore cards
  - clicking `Hide all`
  - clicking `Restore all hidden`
  - clicking `Done` for a reminder
  - using the sticky `Quick Add Reminder` action
- Visible effect:
  - queue cards disappear without mutating the underlying request record
  - hidden-count messaging updates in `QueueBulkActions`
  - a fully hidden queue shows a restore banner instead of cards
  - reminders can move between pending/done states or disappear from the queue
- State mutation:
  - `dismissedQueueItemKeys`
  - `flashMessage`
  - `actionError`
  - `remindersSupported`
- Persistence / restore behavior:
  - dismiss keys are serialized to localStorage under `airmentor-admin-dismissed-queue-items`
  - `collectAdminQueueDismissKeys()` prefixes `request:`, `reminder:`, and `hidden:` to avoid collisions across entity types
  - `mergeAdminQueueDismissKeys()` de-duplicates bulk hides
  - `restoreAllHiddenQueueItems()` clears the entire stored list
- API consequence:
  - reminder create/update uses `/api/admin/reminders`
  - hidden-record restore actions call the relevant entity update/archive recovery API through `runAction(...)`
  - request hiding is purely client-side visibility state
- Test backing:
  - `tests/system-admin-action-queue.test.ts` covers prefixed key collection and de-duplicating merge behavior
  - `tests/system-admin-ui.test.tsx` covers queue bulk action chrome and hidden-count messaging
- Ambiguity / drift risk:
  - dismiss state is browser-global, not per authenticated system-admin session; `handleLogout()` clears session/data/registry scope but does not clear `dismissedQueueItemKeys`, so hidden requests/reminders can survive across different sysadmin logins on the same browser profile
  - reminder support is backend-capability sensitive; a `404` downgrades the queue into request-only mode with explanatory UI copy
  - no direct test covers localStorage persistence, logout behavior, or cross-user isolation of dismissed queue state

## 5) Session Boundary, Cookie Settlement, And Faculties Re-entry

- Where it appears: `src/system-admin-app.tsx`, `src/system-admin-session-shell.tsx`, `src/system-admin-live-app.tsx`, `src/system-admin-hierarchy-workspace-shell.tsx`
- Role restriction: `SYSTEM_ADMIN` gate enforced after session restore
- Trigger:
  - mounting the sysadmin app with or without `VITE_AIRMENTOR_API_BASE_URL`
  - boot-time session restore
  - login submit
  - role switch into `SYSTEM_ADMIN`
  - logout
  - re-entering the faculties workspace after a reload
- Visible effect:
  - missing API base URL stops startup and shows `System Admin Backend Required`
  - boot shows `Restoring system admin session…`
  - unauthenticated users see the full login panel
  - authenticated non-admin users see `System admin role required` plus a role-switch CTA
  - restored faculties tab/section state is surfaced through `RestoreBanner` with a `Reset workspace` action
- State mutation:
  - `booting`
  - `authBusy`
  - `authError`
  - `session`
  - `identifier`
  - `password`
  - `facultiesRestoreNotice`
  - `routeHistory`
- Persistence / restore behavior:
  - backend session truth is cookie-backed
  - `settleCookieBackedSession()` retries `restoreSession()` across `[0, 75, 200, 400, 750, 1200, 2000, 3000]` ms delays after login or role switch
  - faculties workspace re-entry restores only `universityTab` and `selectedSectionCode` from sessionStorage; registry scope, queue visibility, and route history are not restored
  - `showFacultyTimetableExpanded` is forced closed when the selected faculty or faculty-detail tab changes
- API consequence:
  - startup diagnostics emit `startup.diagnostic` and `startup.ready` telemetry events
  - auth flows call `/api/session/login`, `/api/session/restore`, `/api/session/role-context`, and `/api/session/logout`
- Test backing:
  - `tests/system-admin-ui.test.tsx` covers restore-banner rendering only
  - there is no direct test for cookie-settle retry, session restore, logout clearing, or faculties workspace sessionStorage replay
- Ambiguity / drift risk:
  - startup diagnostics and telemetry relay behavior are still a separate uncovered family, so startup event delivery is code-backed but not yet closure-mapped end-to-end
  - queue-hide persistence outlives logout even though other workspace state is reset

## 6) Active Faculty Calendar Surface

- Where it appears: `src/system-admin-live-app.tsx`, `src/system-admin-faculty-calendar-workspace.tsx`, `src/api/client.ts`, `src/pages/calendar-pages.tsx`
- Role restriction: `SYSTEM_ADMIN`
- Trigger:
  - selecting a faculty member and opening the `timetable` detail tab
  - clicking `Open Full Planner`
  - dragging/resizing recurring class blocks in the embedded shared planner
  - creating/editing/deleting markers
  - resetting or saving the planner
- Visible effect:
  - faculty detail starts with a summary card (counts, upcoming markers, class coverage)
  - `Open Full Planner` launches a full-screen modal around the planner
  - recurring edits visually disable when `classEditingLocked`
  - marker edits remain available even when recurring class edits are locked
  - save/reset actions act on local draft state before server persistence
- State mutation:
  - in live app: `facultyCalendar`, `facultyCalendarLoading`, `showFacultyTimetableExpanded`
  - in workspace: `draftTemplate`, `draftWorkspace`, `markerDraft`, `editingMarkerId`, `saving`, `saveError`
- Persistence / restore behavior:
  - selected faculty change fetches the latest calendar from `/api/admin/faculty-calendar/:facultyId`
  - the expanded modal closes automatically on faculty switch or tab switch
  - unsaved changes remain local only; `Reset` returns to `baseTemplate` / `baseWorkspace`
  - successful save persists both `template` and `workspace` through `saveAdminFacultyCalendar()` and then refreshes admin data
- API consequence:
  - read: `apiClient.getAdminFacultyCalendar(facultyId)`
  - write: `apiClient.saveAdminFacultyCalendar(facultyId, payload)`
- Test backing: no direct planner drag/resize/save tests; current test coverage is limited to static workspace rendering in `tests/system-admin-faculties-workspace.test.tsx`
- Ambiguity / drift risk:
  - the summary-first UX reduces initial density, but it also hides weekly-board semantics until the operator opens the modal
  - class-edit locking is enforced client-side in the planner wrapper; live parity still needs authenticated verification

## 7) `SystemAdminTimetableEditor` Alternate Planner (Repo-Present, Currently Unmounted)

- Where it appears: `src/system-admin-timetable-editor.tsx`
- Current route status: `rg` found no imports or tests outside the file itself, so this alternate planner is not part of the current active sysadmin route tree
- Role restriction: intended for sysadmin planner flows, but currently code-backed only
- Trigger / visible effect:
  - supports week navigation, hover targets, drag/resize interactions, marker sheets, extra-class sheets, inline class-info sheets, save/reset, and day-bound editing
  - presents a richer weekly-board-first planner than the currently mounted faculty calendar wrapper
- State mutation:
  - `draftTemplate`
  - `draftWorkspace`
  - `selectedDateISO`
  - `editorSheet`
  - `interaction`
  - `hoverTarget`
  - `saving`
  - `saveError`
- Persistence / restore behavior:
  - save flows through the supplied `onSave` prop only
  - there is no active route or mounted call site currently exercising that prop path
- API consequence: none in the active app because the component is unmounted
- Test backing: none beyond self-contained code inspection
- Ambiguity / drift risk:
  - this alternate planner can drift away from the mounted `SystemAdminFacultyCalendarWorkspace` behavior because it is not route-backed or test-backed
  - future agents should not assume the richer weekly planner is user-visible just because the file exists

## 8) `src/data.old.ts` Call-Site Inventory

- Where it appears: `src/data.old.ts`
- Current route status: zero active repo imports were reconfirmed with `rg -n "data.old" -S .`; hits now come only from audit artifacts and historical logs
- Visible effect: none in the current active route tree
- Persistence / restore behavior: none
- API consequence: none
- Ambiguity / drift risk:
  - the file is still a large mock-data/types corpus and remains easy to mistake for active source material
  - call-site inventory is now effectively closed, but formal archival/deletion intent is still undocumented

## Residual Frontend Gaps After This Pass

- telemetry and startup-diagnostics still need their own dedicated frontend/backend closure mapping (`src/system-admin-app.tsx` only gave the startup entrypoint context here)
- `src/data.old.ts` still needs a formal archival/removal decision even though active call sites now appear to be zero
- exhaustive every-component mapping across all remaining `src/` files is still broader than the six dense clusters plus this long-tail sysadmin helper addendum
- live authenticated confirmation for these long-tail frontend behaviors remains blocked by missing credentials and the current live-capture environment limits

## Evidence Anchors

- `src/admin-section-scope.ts`
- `src/system-admin-provisioning-helpers.ts`
- `src/system-admin-scoped-registry-launches.tsx`
- `src/system-admin-action-queue.ts`
- `src/system-admin-overview-helpers.ts`
- `src/system-admin-session-shell.tsx`
- `src/system-admin-hierarchy-workspace-shell.tsx`
- `src/system-admin-app.tsx`
- `src/system-admin-faculties-workspace.tsx`
- `src/system-admin-live-app.tsx`
- `src/system-admin-faculty-calendar-workspace.tsx`
- `src/system-admin-timetable-editor.tsx`
- `src/api/client.ts`
- `src/proof-playback.ts`
- `tests/system-admin-action-queue.test.ts`
- `tests/system-admin-overview-helpers.test.ts`
- `tests/system-admin-faculties-workspace.test.tsx`
- `tests/system-admin-ui.test.tsx`
