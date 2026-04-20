# Backend Provenance Map

## Scope

- Pass: `backend-provenance-pass`
- Date: `2026-04-16`
- Evidence mode: local code, migrations, and tests only; no live runtime confirmation in this pass
- Primary closure target: authoritative data origins, migrations, seeds, artifact lineage, worker completion paths, restore/replay semantics, and same-entity truth drift risks across backend proof services

## Drift Check

- Status artifacts remain authoritative over stale prompt prose. The native Codex route cooldown timestamps found in older status files are expired and are not an active blocker for this pass.
- Coverage memory before this pass still treated three backend families as partial: proof provenance/count-source helpers, proof playback lifecycle helpers, and the active-run/live-run/dashboard/section-risk/provisioning cluster.
- This pass closes those three families locally in code; the remaining backend provenance blockers are now live runtime proof, not missing local ownership or helper-lineage mapping.

## Primary Evidence

- Migration runner and seed orchestration: `air-mentor-api/src/db/migrate.ts`, `air-mentor-api/src/db/seed.ts`
- Schema and migrations: `air-mentor-api/src/db/schema.ts`, `air-mentor-api/src/db/migrations/0006_msruas_proof_runtime.sql` through `0018_proof_active_operational_semester.sql`
- Queue and worker chain: `air-mentor-api/src/lib/proof-run-queue.ts`, `air-mentor-api/src/app.ts`
- Main proof control plane: `air-mentor-api/src/lib/msruas-proof-control-plane.ts`
- Run finalization and recompute services: `air-mentor-api/src/lib/proof-control-plane-seeded-run-service.ts`, `air-mentor-api/src/lib/proof-control-plane-live-run-service.ts`, `air-mentor-api/src/lib/proof-control-plane-runtime-service.ts`
- Playback and role services: `air-mentor-api/src/lib/proof-provenance.ts`, `air-mentor-api/src/lib/proof-control-plane-access.ts`, `air-mentor-api/src/lib/proof-control-plane-playback-governance-service.ts`, `air-mentor-api/src/lib/proof-control-plane-playback-reset-service.ts`, `air-mentor-api/src/lib/proof-control-plane-stage-summary-service.ts`, `air-mentor-api/src/lib/proof-observed-state.ts`, `air-mentor-api/src/lib/proof-control-plane-tail-service.ts`, `air-mentor-api/src/lib/proof-control-plane-hod-service.ts`
- Active-run and helper cluster: `air-mentor-api/src/lib/proof-active-run.ts`, `air-mentor-api/src/lib/proof-control-plane-dashboard-service.ts`, `air-mentor-api/src/lib/proof-control-plane-section-risk-service.ts`, `air-mentor-api/src/modules/academic-authoritative-first.ts`, `air-mentor-api/src/lib/academic-provisioning.ts`
- Verification references: `air-mentor-api/tests/proof-run-queue.test.ts`, `air-mentor-api/tests/proof-control-plane-activation-service.test.ts`, `air-mentor-api/tests/proof-control-plane-dashboard-service.test.ts`, `air-mentor-api/tests/hod-proof-analytics.test.ts`, `air-mentor-api/tests/student-agent-shell.test.ts`, `air-mentor-api/tests/admin-control-plane.test.ts`, `air-mentor-api/tests/academic-parity.test.ts`

## Inventory-vs-Coverage Delta Closed

- `air-mentor-api/src/db/`: migration and seed lineage are now mapped as destructive bootstrap plus proof-sandbox layering, rather than a generic “DB writes happen here” note.
- Proof provenance/count-source helper family: `proof-provenance.ts`, `proof-control-plane-tail-service.ts`, and `proof-control-plane-hod-service.ts` are now explicitly mapped.
- Proof playback lifecycle family: access gating, reset deletion semantics, governance artifact generation, stage-summary rebuild, and observed-state parsing are now explicitly mapped.
- Active-run/helper family: active-run selection, live-runtime snapshotting, dashboard diagnostics, section-risk aggregation, authoritative-first fallback, and mentor provisioning eligibility are now explicitly mapped.

## Migration and Seed Lineage

- `runSqlMigrations(...)` applies raw SQL files in lexical filename order and records filenames in `schema_migrations`; reused numeric prefixes such as `0002_*` and `0012_*` are execution-safe but human-hostile for temporal reconstruction.
- `0006_msruas_proof_runtime.sql` creates the first proof-runtime lineage: curriculum imports/nodes/edges, bridge/topic/elective tables, `simulation_runs`, teacher allocations/load, observed and latent student state, reset snapshots, and base risk/reassessment/alert tables.
- `0007_msruas_proof_control_plane.sql` upgrades runs into a control plane with `parent_simulation_run_id`, `active_flag`, `source_type`, policy and engine snapshots, lifecycle audits, curriculum validation/crosswalk review, and proof-specific risk metadata.
- `0008_msruas_world_engine_stage2.sql` adds per-student behavior/topic/CO/question/intervention/world-context families that seeded proof runs materialize before playback and active risk recompute.
- `0009_student_agent_shell.sql` adds persistent card/session/message storage keyed by proof run and viewer context.
- `0010_simulation_stage_playback.sql` creates checkpointed playback families and adds checkpoint IDs to agent cards and sessions.
- `0011_risk_model_artifacts.sql` formalizes checkpoint/active evidence snapshots and the batch-scoped artifact registry.
- `0012_*` adds queue-case governance, assigned faculty, resolution payload enrichment, and queue-runtime indexes.
- `0013_scope_governance_profiles_and_provisioning.sql` adds curriculum feature profiles/bindings/overrides, finals lock, and stage-advancement audits.
- `0014_async_proof_run_queue.sql` adds async queue progress and lease columns to `simulation_runs`.
- `0017_operational_telemetry_events.sql` adds the telemetry sink used by queue/worker observability.
- `0018_proof_active_operational_semester.sql` adds and backfills `simulation_runs.active_operational_semester`.
- `seedDatabase()` runs migrations first, then `seedIntoDatabase(...)`.
- `seedIntoDatabase(...)` is destructive, not additive: it deletes broad proof, academic, auth, and institutional tables before replaying `platform.seed.json`, then calls `seedMsruasProofSandbox(...)` to rebuild the synthetic proof corpus.
- Consequence: there are two seed roots in local bootstrap provenance.
  - Platform baseline: `air-mentor-api/src/db/seeds/platform.seed.json`
  - Proof sandbox synthetic corpus: `seedMsruasProofSandbox(...)` plus later seeded proof run materialization

## Major Record Families

### Curriculum import and graph lineage

- Origin: `createProofCurriculumImport(...)` compiles a workbook, validates it, writes `curriculum_import_versions`, `curriculum_validation_results`, crosswalks, nodes, edges, bridge modules, topic partitions, baskets, and options.
- Authoritative boundary: the approved import version and its graph tables are the proof-side curriculum source of truth; `curriculum_courses` becomes a downstream operational mirror only after `approveProofCurriculumImport(...)` calls `syncCurriculumSnapshot(...)`.
- Replay path: `validateProofCurriculumImport(...)` re-runs compile/validation against the stored `source_path`; approval does not regenerate nodes, it approves and mirrors them.
- Main consumers: seeded bootstrap, live-runtime proof runs, playback rebuild context, provisioning helpers, and dashboard import diagnostics.
- Drift risk: live proof can continue against an already-approved import while a newer import exists but is still pending review.

### Simulation run control lineage

- Origin: `enqueueProofSimulationRun(...)`, `retryQueuedProofSimulationRun(...)`, `startProofSimulationRun(...)`, or `startLiveBatchProofSimulationRun(...)`.
- Authoritative boundary: `simulation_runs` is the control row for queue state, active state, policy snapshot, engine versions, progress, lease ownership, and `activeOperationalSemester`.
- Transform path:
  - queue insert or retry writes `queued`
  - worker claim flips to `running` and sets lease token/expiry
  - seeded/live services terminalize `completed`
  - failure path writes `failed`
  - activation normalizes same-batch peers to `completed` and the target run to `active`
- Restore path: `restoreProofSimulationSnapshot(...)` launches a new run with `parentSimulationRunId` pointing at the source run.
- Main consumers: admin proof dashboard, checkpoint detail APIs, HoD analytics, faculty proof view, student shell, risk explorer, and operational projection publication.
- Drift risk: no separate cron or queue consumer was found; completion depends on the in-process worker or an operator-driven activation fallback.

### Observed-state lineage

- Origin:
  - seeded runs: synthetic semester generators emit `student_observed_semester_states`
  - live-runtime runs: `startLiveBatchProofSimulationRun(...)` re-reads current operational terms, enrollments, attendance, assessments, profiles, and transcripts and writes new observed rows
- Authoritative boundary: `student_observed_semester_states.observed_state_json` is the proof-run local fact store; `parseObservedStateRow(...)` is only a thin JSON parser, not a transformer.
- Transform path: observed rows feed stage playback rebuild, active-only risk recompute, and operational projection publication.
- Restore path:
  - seeded snapshot restore is near-deterministic because it reuses seed + curriculum pointers
  - live-runtime snapshot restore is not immutable replay; it stores metadata such as term/semester/seed, then re-queries current operational tables when the restored run is rebuilt
- Main consumers: checkpoint projections, active risk recompute, faculty/HoD/student proof services, and `publishOperationalProjection(...)`.
- Drift risk: a restored live-runtime run can legitimately diverge from the original run if operational tables changed after the snapshot was captured.

### Stage playback lineage

- Origin: `rebuildSimulationStagePlayback(...)` resets prior stage artifacts, rebuilds playback context, computes section risk, builds governance artifacts, builds stage summaries, then inserts checkpoints, student projections, offering projections, queue cases, queue projections, and checkpoint-bound evidence rows.
- Authoritative boundary:
  - `simulation_stage_checkpoints` and `simulation_stage_queue_cases` are the authoritative playback-control records
  - student/offering/queue projection rows are derived playback views over source evidence and governance decisions
- Reset path: `resetPlaybackStageArtifacts(...)` deletes only checkpoint-scoped artifacts for the run: checkpoint-bound agent cards/sessions/messages, checkpoint-bound `risk_evidence_snapshots`, queue projections/cases, offering projections, student projections, and checkpoints.
- Main consumers: checkpoint list/detail APIs, admin dashboard checkpoint readiness, faculty proof views, HoD checkpoint slices, student shell, and risk explorer.
- Drift risk: playback reset is a delete-then-rebuild pattern. If interrupted outside a larger transaction, checkpoints and stage projections can be temporarily sparse even though the underlying run still exists.

### Active risk lineage

- Origin: `recomputeObservedOnlyRisk(...)`.
- Transform path:
  - deletes active-run alerts, outcomes, reassessments, resolutions, overrides, active `risk_assessments`, and active `risk_evidence_snapshots` for the run
  - optionally rebuilds playback and artifacts first
  - re-derives active evidence rows from current observed state
  - re-derives `risk_assessments`, `alert_decisions`, `alert_outcomes`, and runtime queue candidates from that active evidence
- Authoritative boundary: active proof risk is carried by `risk_assessments` plus active `risk_evidence_snapshots` with `simulation_stage_checkpoint_id = null`.
- Fallback behavior: when no checkpoint-bound stage evidence exists for a current semester row, recompute synthesizes `sourceRefs` with `coEvidenceMode='fallback-simulated'` and missing graph/history completeness.
- Main consumers: active faculty proof view, active HoD view, active student shell, active risk explorer, and downstream operational mirrors.
- Drift risk: active-mode truth is intentionally weaker than checkpoint playback truth when it falls back to `fallback-simulated`.

### Risk artifact lineage

- Origin: `rebuildProofRiskArtifacts(...)`.
- Transform path:
  - scans all batch runs
  - keeps only runs with full checkpoint/evidence coverage
  - selects governed corpus runs from `PROOF_CORPUS_MANIFEST`
  - trains production, challenger, and correlation artifacts
  - deactivates prior active artifacts for the batch
  - inserts new active artifacts with `sourceRunIdsJson` listing every governed source run
- Authoritative boundary: the active production/correlation pair for a batch is the inference source loaded by `loadActiveProofRiskArtifacts(...)`; it is batch-wide and corpus-backed, not per-run.
- Main consumers: playback governance rebuild, active-only recompute, student risk explorer, student shell, and dashboard model diagnostics.
- Drift risk: a current run can be scored by artifacts trained from multiple earlier complete runs; current-run UI diagnostics and source run IDs are the only durable explanation of that lineage.

### Operational projection mirrors

- Origin: `publishOperationalProjection(...)` runs only for the active proof run or when semester activation republishes an already-active run.
- Transform path:
  - semesters 1-5 observed rows become transcript term and subject results
  - semester 6 observed rows become proof-sourced attendance and assessment rows
  - active `risk_assessments`, alerts, and elective recommendations get refreshed timestamps for the active run
  - `student_academic_profiles.prev_cgpa_scaled` is updated from the latest proof historical CGPA
- Authoritative boundary: these are operational mirrors for academic/admin surfaces, not the proof playback source itself.
- Replacement behavior: when re-activating a proof run for the proof batch, the publisher deletes prior proof-sourced attendance and term-specific assessment rows for the affected proof students/offering IDs before re-inserting them.
- Main consumers: operational-semester academic routes, student directory/detail surfaces, faculty profile views, and admin hierarchy/students APIs.
- Drift risk: inactive runs can keep stale `activeOperationalSemester` or checkpoint data without republishing; only the active run rewrites operational mirrors.

### Reset snapshot and lifecycle audit lineage

- Origin:
  - seeded runs insert a `Baseline snapshot`
  - live-runtime runs insert a `Live baseline snapshot`
  - activation/archive/run creation/semester activation emit `simulation_lifecycle_audits`
- Authoritative boundary: reset snapshots preserve rerun pointers, not a full frozen DB image.
- Replay path: `restoreProofSimulationSnapshot(...)` uses the stored snapshot payload plus current code/data paths to launch a new run.
- Drift risk: snapshot restore proves lineage and seed selection, but it is not a byte-for-byte restore of every derived table family.

### Provisioning and authoritative-first helper lineage

- `getFacultyMentorProvisioningEligibility(...)` requires both an active appointment in scope and an active mentor grant in the same scope family; appointment-only or grant-only coverage is insufficient.
- `buildFacultyTimetableTemplates(...)` is deterministic synthetic scheduling from load rows, not a replay of existing timetable facts.
- `pickAuthoritativeFirstList(...)` and `pickAuthoritativeFirstRecord(...)` choose authoritative families wholesale once any authoritative rows exist; runtime shadow values are only used when the authoritative family is empty.
- Main consumers: academic task/task-placement/calendar surfaces rather than the proof control plane directly.
- Drift risk: partially authoritative datasets can suppress runtime-only records instead of merging them, so runtime shadow truth may disappear once even a partial authoritative family exists.

## Worker and Completion Path

1. `enqueueProofSimulationRun(...)` writes a queue-ready `simulation_runs` row with policy snapshot, engine versions, progress JSON, and no lease owner.
2. `startProofRunWorker(...)` polls, claims the next queued or lease-expired running row, sets `status='running'`, and starts heartbeats.
3. `executeClaimedProofRun(...)` delegates to `startProofSimulationRun(...)`.
4. Seeded runs materialize synthetic runtime families, rebuild playback, optionally rebuild artifacts, recompute active risk, insert baseline snapshot, and mark the run `completed`.
5. Live-runtime runs snapshot current operational tables into proof runtime rows, rebuild playback, recompute active risk, insert live baseline snapshot, and mark the run `completed`.
6. `activateProofSimulationRun(...)` can synchronously materialize a queued, non-materialized run, then normalizes same-batch runs and republishes operational projections.
7. Failure path writes `failed` plus failure metadata; a lease-expired `running` row is reclaimable by the next worker tick.

## Same-Entity Truth Divergence Boundaries

- Operational academic/admin surfaces and proof surfaces do not serve the same layer of truth.
  - Operational surfaces use resolved batch policy and operational mirrors, exposing `countSource='operational-semester'`.
  - Proof surfaces use `buildProofCountProvenance(...)`, exposing `proof-run`, `proof-checkpoint`, or `unavailable`.
- Default faculty, HoD, and student proof views can become stage-backed while still presenting run-level provenance.
  - When `simulation_runs.active_operational_semester` diverges from `batches.current_semester`, or when active-risk rows are empty, the default active slice recurses into the latest playback-accessible checkpoint for that semester.
  - The returned payload is then relabeled with run-level provenance so the visible semester matches the activated operational semester even though the underlying slice came from checkpoint data.
  - This behavior is explicit in code and tests; it is a documented same-truth drift risk, not an accidental bug in this pass.
- `pickMostRecentActiveRun(...)` resolves duplicate active flags by `updatedAt`, then `createdAt`, then `activeOperationalSemester`, then `runLabel`; dashboard/admin tests expect this deterministic winner selection.
- `simulation_runs.active_operational_semester` and `batches.current_semester` are duplicated semester pointers. `activateProofOperationalSemester(...)` keeps them in sync, but inactive runs can retain older values without republishing operational mirrors.
- Batch-scoped active artifacts are another same-truth divergence boundary: current-run inference may be driven by artifacts trained from multiple governed source runs, while checkpoint playback still comes only from the selected run/checkpoint rows.

## Residual Risks

- Live worker liveness and continuity remain unproven on the deployed stack.
- Delete-and-rebuild playback and publication flows are not yet proven end-to-end inside a single transactional envelope.
- Live proof artifact freshness, fallback frequency, and same-student cross-surface parity remain blocked outside local code/tests.
- Live-runtime snapshot restore is semantically “re-snapshot current operational tables,” not immutable replay.

## Remaining Uncovered / Blocked Scope

- Credentialed proof worker and operational publication verification on deployed Railway.
- Safe read-only live same-target parity capture across sysadmin, HoD, mentor, course leader, and student surfaces.
- Fresh proof-risk artifact regeneration in a less restricted environment.
- Seed-data-to-live parity and deployment dependency posture for optional Python/NLP curriculum-linkage helpers.

## Pass Reporting Snapshot

- Scope covered: migrations, destructive seed boundary, proof run control lineage, playback reset/rebuild semantics, active recompute, artifact rebuild, operational publication, role-specific proof services, active-run helper cluster, and provisioning/authoritative-first helpers.
- Files updated in this pass: this provenance map plus final maps, coverage, and working-memory files listed in the pass closeout.
- Remains uncovered: deployed worker liveness, live same-student parity, live proof artifact freshness, and proof-safe live observation.
- Contradictions found: none newly added in this pass; existing live/runtime contradictions remain unchanged.
- Risks discovered or sharpened: destructive seed reset boundary, batch-wide artifact lineage, live-runtime restore non-immutability, stage-backed-but-run-labeled default proof slices, and wholesale authoritative-first fallback behavior.
- Routing/provider/account changes: none.
- Caveman usage: none.
- Live verification performed: no.
- Recommended next pass: `same-student-cross-surface-parity-pass`, followed by credentialed `live-behavior-pass`.
- Manual checkpoint required: no new manual checkpoint from local code analysis alone; live closure work still requires the existing credential/runtime blockers to clear.
