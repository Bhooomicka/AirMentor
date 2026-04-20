# Data Flow Map

Status: `mapped`

This file is now backed by standalone per-flow corpus entries under `audit-map/06-data-flow/`.

Canonical corpus index:

- `audit-map/06-data-flow/flow-corpus-index.md`

Primary per-flow records:

- `audit-map/06-data-flow/flow-proof-run-checkpoint-projection.md`
- `audit-map/06-data-flow/flow-proof-risk-artifact-evidence-snapshot.md`
- `audit-map/06-data-flow/flow-academic-route-session-bootstrap.md`
- `audit-map/06-data-flow/flow-sysadmin-request-proof-history-search.md`
- `audit-map/06-data-flow/flow-telemetry-startup-diagnostics.md`

## Frontend Microinteraction Data-Flow Overlay

- Artifact: `audit-map/12-frontend-microinteractions/component-cluster-microinteraction-map.md`
- Academic shell flow: hash/role/session inputs -> route sync and page guard normalization -> role-scoped page data requests -> mounted drilldown surfaces.
- Academic proof-date flow: bootstrap `proofPlayback.currentDateISO` -> `proofVirtualDateISO` in `OperationalWorkspace` -> `toDueLabel(anchorISO)` / `applyPlacementToTask(..., anchorISO)` -> proof playback due labels that track simulation virtual date instead of wall clock.
- Calendar/timetable flow: drag/resize/placement interactions -> planner mutation payloads -> backend write + runtime shadow state coupling -> updated schedules and follow-on proof-refresh dependencies.
- Sysadmin shell flow: tab/search/queue triggers -> section-scoped reads and mutations -> local storage-backed queue/route continuity -> restored workspace and filtered detail panes.
- Proof dashboard flow: checkpoint/tab selections -> persisted restore keys -> proof diagnostics/operations data fetches -> playback progression and checkpoint rails.
- Request lifecycle flow: selection + transition actions -> admin request mutation routes -> list/detail/audit trail updates; current local frontend now exposes the full backend-supported transition set, so the residual risk is live deployment parity rather than local control-path omission.

## Backend Provenance Data-Flow Overlay

- Migration and bootstrap flow: SQL files in `air-mentor-api/src/db/migrations/` -> `runSqlMigrations(...)` filename-sorted apply -> `schema_migrations` tracking -> `seedDatabase()` -> destructive `seedIntoDatabase(...)` table reset -> platform seed replay -> `seedMsruasProofSandbox(...)`.
- Queue execution flow: run enqueue/retry on `simulation_runs` -> worker claim + lease heartbeat in `proof-run-queue.ts` -> `startProofSimulationRun(...)` execution -> lease finalize or `failed` terminal update.
- Academic bootstrap gate flow: session role -> `simulation_runs.activeFlag=1` check in `academic-bootstrap-routes.ts` -> either `403 NO_ACTIVE_PROOF_RUN` gate response or full bootstrap hydration path.
- Seeded materialization flow: seeded bootstrap/scaffolding/semester generators -> `finalizeSeededProofRun(...)` chunked inserts into runtime families -> checkpoint rebuild -> optional artifact rebuild + active risk recompute -> reset snapshot + run completion metrics.
- Playback rebuild flow: `resetPlaybackStageArtifacts(...)` -> rebuild context prep -> section-risk aggregation -> governance artifact generation -> stage-summary rebuild -> checkpoint, student/offering/queue, queue-case, and stage-evidence inserts.
- Artifact lineage flow: batch run inventory + checkpoint/evidence completeness gate + `PROOF_CORPUS_MANIFEST` selection -> `rebuildProofRiskArtifacts(...)` -> deactivate prior active artifacts -> insert new production/challenger/correlation rows with `sourceRunIdsJson`.
- Active recompute flow: delete active risk/alert/reassessment/evidence rows -> optionally refresh playback and artifacts -> rebuild active evidence from current observed rows, reusing checkpoint stage-close evidence when available and `fallback-simulated` source refs otherwise -> regenerate risk, alerts, and queue candidates.
- Activation publication flow: deactivate prior same-batch runs -> `invalidateProofBatchSessions(...)` resolves `batch.branchId -> roleGrants.scopeId -> facultyProfiles.userId -> sessions` and deletes branch-scoped faculty sessions -> activate target run (`active_flag=1`) -> `publishOperationalProjection(...)` rewrites semesters 1-5 transcripts, semester 6 attendance/assessment proof mirrors, seeds missing `offeringAssessmentSchemes` rows, refreshes risk/alert/elective timestamps, and updates `studentAcademicProfiles` for the active proof slice.
- Replay flow: `restoreProofSimulationSnapshot(...)` -> new run with `parentSimulationRunId` and restored seed/policy payload -> full run materialization and optional activation; live-runtime restore re-snapshots current operational tables rather than replaying a frozen data image.
- Semester pointer flow: `activateProofOperationalSemester(...)` updates `simulation_runs.active_operational_semester` and `batches.current_semester`; active runs trigger projection republish for user-visible state parity.
- Role-slice flow: `activeOperationalSemester` + `batches.currentSemester` + playback gate -> default faculty/HoD/student proof views that can recurse into the latest playback-accessible checkpoint for the active semester while keeping checkpoint-explicit provenance when fallback occurs.

## Script Behavior Data-Flow Overlay

- Credential flow: live admin env vars + candidate passwords -> `scripts/system-admin-live-auth.mjs` / `scripts/teaching-password-resolution.mjs` -> session-contract probe and live auth gating.
- Parity-seed flow: source data + parity assumptions -> `air-mentor-api/scripts/generate-academic-parity-seed.ts` -> `air-mentor-api/src/db/seeds/platform.seed.json` -> seeded parity fixtures and downstream parity tests.
- Seeded harness flow: `air-mentor-api/scripts/start-seeded-server.ts` -> embedded Postgres + migrations + seed -> readiness payload -> local replay, contract, and Vitest harnesses.
- Test-evidence flow: `air-mentor-api/scripts/run-vitest-suite.mjs` -> per-file test output; proof-rc remains excluded unless `AIRMENTOR_BACKEND_SUITE=proof-rc`.
- Proof-risk artifact flow: `air-mentor-api/scripts/evaluate-proof-risk-model.ts` -> JSON/Markdown proof-risk outputs under `air-mentor-api/output/proof-risk-model/`.
- Deploy-readiness and recovery flow: Railway config/auth + live URLs -> `scripts/check-railway-deploy-readiness.mjs` / `scripts/railway-recovery-chain.sh` -> JSON diagnostics, workflow triggers, and recovery side effects.
- Detached closeout flow: detached session state + stage artifacts -> `scripts/run-detached.sh` / `scripts/closeout-stage-*.mjs` / `scripts/finalize-stage-*-after-session.sh` / `scripts/snapshot-final-closeout-artifacts.mjs` -> promoted closeout bundles and rewritten ledgers/manifests/docs.
- These flows can emit success while still leaving semantic truth unresolved, so green script output is only artifact truth, not product truth.
