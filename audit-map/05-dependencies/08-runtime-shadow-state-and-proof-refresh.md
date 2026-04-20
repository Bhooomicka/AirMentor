# Dependency: Runtime Shadow State And Proof Refresh

- Dependency name: Academic runtime shadow state and proof refresh queueing
- Dependency type: runtime, persistence, background-worker
- Source surface or action: course, gradebook, planner, lock, and curriculum mutation flows plus proof refresh actions
- Upstream dependency: runtime state keys in the API, compatibility sync routes, resolved batch and stage policies, backend proof refresh queueing
- Downstream impacted surfaces: tasks, resolved tasks, drafts, cell values, lock state, timetable templates, task placements, calendar audit, proof parity banners
- Trigger: saving academic runtime data, toggling locks, updating curriculum or policy overrides, recomputing proof risk, re-queuing proof runs
- Data contract or key fields: `tasks`, `resolvedTasks`, `drafts`, `cellValues`, `lockByOffering`, `lockAuditByTarget`, `timetableByFacultyId`, `adminCalendarByFacultyId`
- Runtime conditions: shadow-drift detection can emit operational events; compatibility routes like `/sync` still exist; tasks outside the active teaching scope may be ignored; unlock reset now has to clear authoritative DB lock state before local/runtime state mutation is safe
- Persistence or config coupling: in repo mode the same repositories fall back to local storage; in live mode the same actions flow through API-backed runtime routes and queued proof refresh work
- Hidden coupling sources: the same edit can be local-only or backend-persisted depending on repository mode; proof refresh queueing is contingent on a background consumer that is not directly visible in the UI; proof run archive/activate now also depends on `batch.branchId -> roleGrants.scopeId -> facultyProfiles.userId -> sessions` session invalidation coupling
- Failure mode: shadow drift can leave local and backend state out of sync; proof refresh can be queued but not yet executed; live parity can lag after curriculum or policy edits; a failed remote clear-lock call must block local unlock completion or the UI would drift from DB truth
- Drift risk: high
- Evidence: `src/repositories.ts:353-500, 552-587, 697-823, 868-879`, `air-mentor-api/src/modules/academic-runtime-routes.ts:104-863, 1055-1056`, `src/system-admin-live-app.tsx:3906-4410, 4658-4665, 4072-4116, 4135-4246`, `air-mentor-api/src/modules/admin-proof-sandbox.ts:1-240`
- Notes: local proof-refresh ownership is now traced through Fastify worker bootstrap and queue lease semantics; remaining ambiguity is deployed worker liveness, not missing local ownership mapping
