# Dependency Graph

This file reconciles the dependency layer captured in `audit-map/05-dependencies/`.

## Primary Chains

- Portal shell chain: `window.location.hash` -> `PortalRouterApp` -> `PortalEntryScreen` / `OperationalApp` / `SystemAdminApp` -> theme and faculty-id persistence in localStorage.
- Academic session chain: `VITE_AIRMENTOR_API_BASE_URL` -> `AirMentorApiClient` -> `/api/session` and `/api/session/login` -> session cookie + CSRF cookie -> role-specific workspace projection.
- Academic bootstrap gate chain: academic session role -> `simulationRuns.activeFlag` check in `registerAcademicBootstrapRoutes(...)` -> either `NO_ACTIVE_PROOF_RUN` gate response -> `academic-session-shell` gate page, or full bootstrap payload hydration.
- Academic route-state chain: session role + mock bootstrap params + route history -> role sync + in-app back stack -> page restore and deep-link behavior.
- Proof playback chain: localStorage proof selection -> bootstrap `simulationStageCheckpointId` -> active bootstrap or reset notice -> academic proof overlay and sysadmin proof dashboard restore.
- Student shell chain: run/checkpoint params + auth scope -> `resolveStudentShellRun()` / `resolveAcademicStageCheckpoint()` / `assertStudentShellScope()` -> student card, timeline, session messages, and risk explorer.
- Sysadmin proof chain: canonical proof batch scope + selected section + sessionStorage tab state + localStorage playback selection -> proof dashboard tabs, checkpoint rail, playback progression, and proof refresh actions.
- Admin request chain: faculty context + request state + optimistic version -> status transition helper -> request list/detail visibility, notes, audit trail, and status-driven UI.
- Admin search chain: route section + registry scope + canonical proof scope -> search scope filter -> registry lists, breadcrumbs, and proof-branch-only views.
- Runtime shadow-state chain: course/gradebook/planner mutations -> runtime state keys and compatibility routes -> DB-backed or local shadow state -> proof refresh queueing and parity banners.
- Assessment unlock chain: HoD unlock-review reset path -> `clearOfferingAssessmentLock(...)` API client -> `POST /api/academic/offerings/:offeringId/assessment-entries/:kind/clear-lock` -> clear `sectionOfferings.[kind]Locked` and runtime `lockByOffering` -> course leader can resubmit marks without stale DB lock rejection.
- Backend session config chain: cookie and CSRF env vars + origin config -> session issuance and request auth -> every authenticated mutation path.
- Frontend microinteraction cluster chain: route parser + role sync + drag/resize state + proof/checkpoint selectors + route-scoped storage restore -> cross-surface UI continuity and re-entry behavior (`audit-map/12-frontend-microinteractions/component-cluster-microinteraction-map.md`).
- Backend provenance chain: migrations (`runSqlMigrations`) + seed layering (`seedDatabase`, proof sandbox seed) -> async run queue lease protocol (`proof-run-queue.ts`) -> seeded/runtime control-plane services -> checkpoint/projection rebuilds -> active operational projection publication.
- Proof session invalidation chain: proof run archive/activate -> `batch.branchId` lookup -> `roleGrants.scopeId` match for branch-scoped faculty grants -> `facultyProfiles.userId` bridge -> delete `sessions` rows for affected faculty before new proof context becomes active.
- Replay dependency chain: `simulationResetSnapshots` payload -> `restoreProofSimulationSnapshot(...)` -> new run materialization -> activation and projection republish, with parent linkage preserving audit lineage.
- Risk artifact dependency chain: `riskEvidenceSnapshots` stage and active rows -> `rebuildProofRiskArtifacts(...)` artifact registry writes -> `loadActiveProofRiskArtifacts(...)` inference path -> `riskAssessments`/alerts/reassessments regeneration.
- Semester activation dependency chain: `simulation_runs.active_operational_semester` + `batches.current_semester` synchronization -> conditional republish for active runs -> cross-surface semester-consistent projections.
- Batch artifact lineage chain: complete governed proof runs + `PROOF_CORPUS_MANIFEST` -> batch-scoped production/challenger/correlation artifacts -> later checkpoint rebuild and active recompute for a single current run; inference provenance depends on corpus lineage, not only the active run.
- Hybrid proof-slice dependency chain: `activeOperationalSemester` + `batches.currentSemester` + playback-accessible checkpoint lookup -> default faculty/HoD/student proof slice -> payload that may be checkpoint-backed while remaining checkpoint-explicit in provenance fields.
- Authoritative-first runtime chain: authoritative task/placement/calendar families -> `pickAuthoritativeFirstList(...)` / `pickAuthoritativeFirstRecord(...)` -> runtime shadow fallback only when the authoritative family is empty -> possible suppression of runtime-only records once partial authoritative data exists.
- Workflow automation dependency chain: `.github/workflows/*` trigger filters + env/secret gates -> script entrypoints (`scripts/check-railway-deploy-readiness.mjs`, `scripts/verify-final-closeout-live.sh`, `scripts/playwright-admin-live-*.sh`) -> deployment/verification side effects and evidence artifacts (`output/playwright`, `air-mentor-api/output`, uploaded artifacts) -> operator confidence posture that can diverge if conditional skips or local-seeded live wrappers are misread as deployed-live proof.
- Script behavior execution chain: live auth env vars + candidate passwords -> `scripts/system-admin-live-auth.mjs` / `scripts/teaching-password-resolution.mjs` -> live wrappers and credentialed Playwright flows; source data + embedded Postgres + test flags -> `air-mentor-api/scripts/generate-academic-parity-seed.ts` / `air-mentor-api/scripts/start-seeded-server.ts` / `air-mentor-api/scripts/run-vitest-suite.mjs` / `air-mentor-api/scripts/evaluate-proof-risk-model.ts`; detached session state + stage artifacts -> `scripts/run-detached.sh` / `scripts/closeout-stage-*.mjs` / `scripts/finalize-stage-*-after-session.sh` / `scripts/snapshot-final-closeout-artifacts.mjs` -> promoted ledgers, manifests, indexes, and closeout bundles.
- Railway recovery chain: Railway CLI/auth + live URLs + optional sync flags -> `scripts/check-railway-deploy-readiness.mjs` / `scripts/railway-recovery-chain.sh` -> JSON diagnostics, workflow triggers, and closeout recovery side effects.

## Detailed Entries

- [Portal routing and theme](../05-dependencies/00-portal-routing-and-theme.md)
- [Academic session bootstrap and role context](../05-dependencies/01-academic-session-bootstrap-and-role-context.md)
- [Academic route snapshot and role sync](../05-dependencies/02-academic-route-snapshot-and-role-sync.md)
- [Proof playback and bootstrap selection](../05-dependencies/03-proof-playback-and-bootstrap-selection.md)
- [Student shell and risk explorer access](../05-dependencies/04-student-shell-risk-explorer-and-access.md)
- [System admin proof dashboard and canonical scope](../05-dependencies/05-system-admin-proof-dashboard-and-canonical-scope.md)
- [Admin request visibility and transitions](../05-dependencies/06-admin-request-visibility-and-transitions.md)
- [Admin search and registry scope](../05-dependencies/07-admin-search-and-registry-scope.md)
- [Runtime shadow state and proof refresh](../05-dependencies/08-runtime-shadow-state-and-proof-refresh.md)
- [Backend session cookie and CSRF config](../05-dependencies/09-backend-session-cookie-and-csrf-config.md)
