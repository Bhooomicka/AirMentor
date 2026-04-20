# Component Cluster Microinteraction Map

Pass: `frontend-microinteraction-pass`
Date: 2026-04-15

This artifact captures high-density frontend interaction clusters with explicit trigger-to-effect chains, restore/re-entry behavior, and hidden couplings.

## Cluster Index

1. Academic workspace shell and role-route sync
2. Calendar/timetable planner drag-resize and placement
3. System-admin live workspace shell and queue controls
4. System-admin request workspace lifecycle controls
5. System-admin proof dashboard launcher/checkpoint playback
6. System-admin hierarchy and route-scoped workspace restore

## 1) Academic workspace shell and role-route sync

- Where it appears: `src/App.tsx`, `src/academic-session-shell.tsx`, `src/academic-workspace-route-surface.tsx`, `src/academic-workspace-content-shell.tsx`, `src/academic-workspace-sidebar.tsx`, `src/academic-workspace-topbar.tsx`, `src/academic-route-pages.tsx`
- Roles: Course Leader, Mentor, HoD
- Trigger: hash route change, role change in UI, session restore, deep-link open
- Visible effect: side navigation and content shell switch to role-allowed pages; invalid route-role combos snap to safe home page
- Local state change: route parser output, selected role, active page state, route-history back-stack, in-flight loading/error slices
- Persisted state change: proof playback selection can be restored from localStorage through shared playback utilities
- API consequence: bootstrap/session refresh and role-scoped page reads are requested through academic routes
- Downstream UI consequence: page-specific surfaces (students, course, queue-history, risk-explorer, student-shell, HoD analytics) mount with scoped data
- Restore/re-entry behavior: route history and role sync restore guarded page state after refresh/login loops; illegal deep-links are normalized
- Empty/loading/error/retry states: loading shells and empty role/page states appear during session/bootstrap fetch; auth failures trigger gated surfaces and retry paths
- Hidden couplings: role-sync helper behavior and proof-run scope selection influence whether route state remains valid after restore

## 2) Calendar/timetable planner drag-resize and placement

- Where it appears: `src/pages/calendar-pages.tsx`, and role entry points in `src/academic-route-pages.tsx`
- Roles: Course Leader, Mentor, HoD (visibility/actions vary by role context)
- Trigger: drag start/move/end, resize handles, hover-add targets, tab/mode switches between calendar and timetable views
- Visible effect: classes move or resize on the grid; hover target previews and snap/reflow behavior update immediately
- Local state change: drag/resize state machines, hover slot state, selected event/detail-sheet state, timed vs untimed placement state
- Persisted state change: planner mutations route through runtime shadow-state/update paths that can survive page transitions
- API consequence: planner mutations call backend academic routes and can queue proof refresh follow-up behavior
- Downstream UI consequence: roster, availability, and risk-adjacent schedules reflect updates; stage-lock rules can disable parts of editing flow
- Restore/re-entry behavior: returning to planner views rehydrates selected mode and route context; compatible shadow state prevents hard loss on navigation
- Empty/loading/error/retry states: empty schedule boards, loading placeholders, and mutation failure/retry affordances are present across planner interactions
- Hidden couplings: planner writes couple into runtime shadow state and later proof refresh semantics; untimed/timed transitions alter valid placement constraints

## 3) System-admin live workspace shell and queue controls

- Where it appears: `src/system-admin-live-app.tsx`
- Roles: SYSTEM_ADMIN
- Trigger: top-tab changes, search actions, queue item dismiss/restore, route navigation, session restore, proof-route launches
- Visible effect: workspace section changes, breadcrumb/search context updates, queue visibility and action chips change inline
- Local state change: many state slices for session, routing, search scope, selected entities, queue state, proof-launch state, and refresh flags
- Persisted state change: dismissed queue items persist in localStorage; route and workspace context persist through hash and storage-backed mechanics
- API consequence: admin registry reads/writes, request reads, proof/dashboard data refreshes, and scoped lookup calls
- Downstream UI consequence: requests/proof/faculties/students/faculty-members/history surfaces update with filtered context; modal paths change available actions
- Restore/re-entry behavior: route-history replay, storage-backed restoration, and role/session retry logic rebuild prior context after reloads
- Empty/loading/error/retry states: request-not-found/no-selection, loading banners, and retry loops (including auth/session retry) are represented in shell logic
- Hidden couplings: search scope, canonical proof scope, and route serializer/parser behavior can silently redirect section context after restore

## 4) System-admin request workspace lifecycle controls

- Where it appears: `src/system-admin-request-workspace.tsx`, hosted by `src/system-admin-live-app.tsx`
- Roles: SYSTEM_ADMIN
- Trigger: request row selection and lifecycle action button clicks
- Visible effect: request detail panel updates status and notes trail based on action path
- Local state change: selected request, action-in-progress state, optimistic update/version handling, detail panel loading/error state
- Persisted state change: request lifecycle status is persisted on backend; frontend keeps continuity via selected request and route context
- API consequence: request transition mutations fire through admin request routes
- Downstream UI consequence: queue/list ordering and request detail metadata change; audit trail entries advance
- Restore/re-entry behavior: request deep-link and selection restore works through main admin route and workspace state restoration
- Empty/loading/error/retry states: no request selected, not found, loading detail, and mutation error/retry states are represented
- Hidden couplings: visible transition controls remain narrower than backend-supported transitions (`Needs Info` and `Rejected` absent in visible UI), sustaining contradiction `C-006`

## 5) System-admin proof dashboard launcher/checkpoint playback

- Where it appears: `src/system-admin-proof-dashboard-workspace.tsx`, `src/proof-surface-shell.tsx`, shared playback logic in `src/proof-playback.ts`
- Roles: SYSTEM_ADMIN
- Trigger: rail selection, tab change, launcher popup actions, checkpoint selection, playback progression controls
- Visible effect: proof summary/checkpoint/diagnostics/operations panes change; checkpoint detail and stage gating update
- Local state change: selected checkpoint/run context, active tab, launcher visibility, playback mode/progression state
- Persisted state change: active proof dashboard tab persists via sessionStorage key `airmentor-system-admin-proof-dashboard-tab`; checkpoint selection persists via localStorage key `airmentor-proof-playback-selection`
- API consequence: proof dashboard data reads, diagnostics/operations fetches, and proof refresh actions are triggered
- Downstream UI consequence: risk overlays, checkpoint rails, and operations views update across admin proof surfaces
- Restore/re-entry behavior: tab and checkpoint restore on reload or route return; invalid checkpoint context is invalidated/reset by playback guards
- Empty/loading/error/retry states: loading proof snapshots, blocked progression states, missing checkpoint detail, and action retries are represented
- Hidden couplings: canonical proof scope normalization and stored checkpoint selection can drift unless route/checkpoint context is revalidated

## 6) System-admin hierarchy and route-scoped workspace restore

- Where it appears: `src/system-admin-faculties-workspace.tsx`, integrated shell `src/system-admin-live-app.tsx`
- Roles: SYSTEM_ADMIN
- Trigger: hierarchy navigation, modal edits, section switches, route re-entry
- Visible effect: faculty/batch/section subviews and modals reopen with prior context
- Local state change: selected hierarchy node, opened modal/drawer state, section view, pending edit state
- Persisted state change: route-scoped restore snapshot persists via sessionStorage key family `airmentor-admin-ui:<hash>`
- API consequence: hierarchy control-plane reads/writes and related registry updates
- Downstream UI consequence: roster and structure projections in admin surfaces reflect hierarchy changes and restored context
- Restore/re-entry behavior: hash-scoped restoration repopulates workspace state after navigation/reload
- Empty/loading/error/retry states: loading hierarchy data, empty branch/section states, mutation error and retry behavior in modal workflows
- Hidden couplings: restore key depends on hash normalization; route form differences can create stale or partial workspace restores if scope changed

## Long-Tail Extension (2026-04-16)

- Durable follow-up artifact now exists at `audit-map/12-frontend-microinteractions/long-tail-interaction-map.md`.
- The long-tail addendum closes the previously thin sysadmin helper cluster by mapping:
  - section-scope selectors and scope-id helpers
  - scoped registry launch and breadcrumb return semantics
  - bulk mentor assignment preview/apply invalidation and confirmation flow
  - queue dismiss / hide-all / restore-all persistence
  - session boundary login, role-switch, logout, and faculties restore behavior
  - active faculty calendar modal planner behavior
- The active planner surface is `src/system-admin-faculty-calendar-workspace.tsx`; `src/system-admin-timetable-editor.tsx` is now explicitly mapped as a repo-present but currently unmounted alternate implementation.

## Thin/Uncovered Areas Not Closed In This Pass

- `src/data.old.ts` again showed zero active repo imports, but its formal archival/removal decision is still undocumented.
- Exhaustive component-by-component coverage of every remaining `src/` file is still broader than the six dense clusters plus the new long-tail sysadmin helper addendum.
- Live authenticated confirmation of these interaction chains remains blocked by current environment credential/network limitations.

## Evidence Anchors

- `src/App.tsx`
- `src/academic-session-shell.tsx`
- `src/academic-workspace-route-surface.tsx`
- `src/academic-workspace-content-shell.tsx`
- `src/academic-workspace-sidebar.tsx`
- `src/academic-workspace-topbar.tsx`
- `src/academic-route-pages.tsx`
- `src/pages/calendar-pages.tsx`
- `src/pages/course-pages.tsx`
- `src/pages/workflow-pages.tsx`
- `src/pages/hod-pages.tsx`
- `src/pages/student-shell.tsx`
- `src/pages/risk-explorer.tsx`
- `src/system-admin-live-app.tsx`
- `src/system-admin-request-workspace.tsx`
- `src/system-admin-proof-dashboard-workspace.tsx`
- `src/system-admin-faculties-workspace.tsx`
- `src/system-admin-history-workspace.tsx`
- `src/proof-surface-shell.tsx`
- `src/proof-playback.ts`
- `src/portal-entry.tsx`
- `src/repositories.ts`
