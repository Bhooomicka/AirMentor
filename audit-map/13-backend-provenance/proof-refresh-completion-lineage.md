# Proof Refresh Completion Lineage

## Scope

- Pass: `proof-refresh-completion-pass`
- Goal: map post-enqueue completion ownership deterministically
- Evidence mode: local code and test artifacts (no live worker observation in this pass)

## Core Answer (Ownership)

- Owner of completion after queue insert is the backend in-process proof worker started by Fastify app bootstrap: `startProofRunWorker(...)` from `air-mentor-api/src/lib/proof-run-queue.ts`, wired in `air-mentor-api/src/app.ts`.
- The worker claims queued runs via DB lease, executes `startProofSimulationRun(...)`, and finalizes success/failure state on `simulation_runs`.
- For queued runs not yet materialized, a manual activation fallback can complete execution synchronously in request path through `activateProofSimulationRun(...)` -> `startProofSimulationRun(...)`.

## End-to-End Trace

### 1) UI/API refresh trigger

- Sysadmin frontend calls `apiClient.createProofRun(batchId, ...)` when forcing refresh/retry (`src/system-admin-live-app.tsx`, `src/api/client.ts`).
- API route receives this at `POST /api/admin/batches/:batchId/proof-runs` and enqueues using `enqueueProofSimulationRun(...)` (`air-mentor-api/src/modules/admin-proof-sandbox.ts`).
- Curriculum mutation flows also enqueue through `enqueueProofRefreshForBatches(...)` (`air-mentor-api/src/modules/admin-structure.ts`, `air-mentor-api/src/modules/academic-admin-offerings-routes.ts`).

### 2) Queue insert / enqueue path

- `enqueueProofSimulationRun(...)` inserts `simulation_runs` with:
  - `status='queued'`
  - `progress_json={ phase:'queued', percent:0, requestedActivate, mode }`
  - lease fields null (`worker_lease_token`, `worker_lease_expires_at`)
  - run metadata and policy snapshot
- Queue schema support is from migration `0014_async_proof_run_queue.sql` (progress + lease fields, queue/lease indexes).

### 3) Worker claim / lease / heartbeat

- Worker bootstrap: `air-mentor-api/src/app.ts` line path where app starts `startProofRunWorker({ db, pool, clock })`.
- Claim loop:
  - poll interval default 5s, lease duration 60s, heartbeat 15s (`proof-run-queue.ts`).
  - SQL claim picks oldest `queued` or lease-expired `running` row (`FOR UPDATE SKIP LOCKED`) and flips to:
    - `status='running'`
    - `worker_lease_token=<leaseToken>`
    - `worker_lease_expires_at=now+lease`
    - `started_at=COALESCE(started_at, now)`
- Heartbeat extends lease expiry while job runs.

### 4) Completion / failure / retry / abandonment semantics

- Success path:
  - worker calls `startProofSimulationRun(...)`.
  - then `finalizeProofRunLease(...)` clears lease token/expiry.
  - run terminal success is set by run services (`status='completed'`, `completedAt`, `progressJson.phase='completed'`) in:
    - `air-mentor-api/src/lib/proof-control-plane-seeded-run-service.ts`
    - `air-mentor-api/src/lib/proof-control-plane-live-run-service.ts`
- Failure path:
  - worker calls `failProofRun(...)`:
    - `status='failed'`
    - `failure_code='PROOF_RUN_EXECUTION_FAILED'`
    - `failure_message=<error>`
    - terminal progress payload
    - lease fields cleared
- Retry path:
  - `retryQueuedProofSimulationRun(...)` resets to queued and clears failure/lease fields.
- Abandonment / delayed worker path:
  - lease-expired `running` rows are reclaimable by next worker tick.
  - if no worker process runs, rows remain queued/running until worker returns.

### 5) Projection publish / downstream consumption

- `startProofSimulationRun(...)` delegates to seeded/live services, both rebuild stage playback (`rebuildSimulationStagePlayback(...)`) and recompute observed risk.
- Activation path (`activateProofSimulationRun(...)`) sets one run active and calls `publishOperationalProjection(...)`, which rewrites projection-facing tables (attendance/assessment/transcript/risk/alerts/electives for proof scope).
- Dashboard/read-side consumption:
  - backend dashboard aggregator reads run status/progress/worker lease diagnostics (`air-mentor-api/src/lib/proof-control-plane-batch-service.ts`, dashboard diagnostics helper)
  - frontend reads proof dashboard via `getProofDashboard(...)` in `src/api/client.ts`, surfaced in `src/system-admin-live-app.tsx`.

## Tables / records touched

- Primary control row: `simulation_runs` (`status`, `progress_json`, `started_at`, `completed_at`, `failure_code`, `failure_message`, `worker_lease_token`, `worker_lease_expires_at`, `active_flag`).
- Completion materialization families (non-exhaustive, key proof projection outputs):
  - `simulation_stage_checkpoints`
  - `simulation_stage_student_projections`
  - `simulation_stage_offering_projections`
  - `simulation_stage_queue_projections`
  - `risk_assessments`
  - `reassessment_events`
  - `alert_decisions`
  - `risk_evidence_snapshots`
  - operational projection targets: `student_attendance_snapshots`, `student_assessment_scores`, `transcript_term_results`, `transcript_subject_results`, `elective_recommendations`

## Terminal states and proofs

- Queue-control statuses in codepaths: `queued`, `running`, `failed`, `completed`, `active`, `archived`.
- Proof of worker ownership:
  - app bootstrap starts worker (`app.ts`)
  - worker claim/lease SQL in `proof-run-queue.ts`
  - worker emits `proof.run.claimed`, `proof.run.executed`, `proof.run.failed` telemetry events
- Proof of run terminalization:
  - seeded/live run services set `status='completed'`, `completedAt`, `progressJson.phase='completed'`.

## Drift risks if worker absent or delayed

- No out-of-process cron/queue consumer was found in this repository; completion depends on app process running worker loop.
- If worker is down:
  - refresh requests can accumulate in `queued` state.
  - UI may report "queued" without semantic completion.
- If worker dies mid-run:
  - row can be reclaimed only after lease expiry.
  - recovery latency is bounded by lease duration + poll cadence once worker returns.
- Manual mitigation exists but is operator-driven:
  - activating a queued run can force synchronous execution for non-materialized runs via activation endpoint logic.

## Evidence Paths

- `air-mentor-api/src/app.ts`
- `air-mentor-api/src/lib/proof-run-queue.ts`
- `air-mentor-api/src/lib/msruas-proof-control-plane.ts`
- `air-mentor-api/src/lib/proof-control-plane-seeded-run-service.ts`
- `air-mentor-api/src/lib/proof-control-plane-live-run-service.ts`
- `air-mentor-api/src/lib/proof-control-plane-runtime-service.ts`
- `air-mentor-api/src/lib/proof-control-plane-batch-service.ts`
- `air-mentor-api/src/modules/admin-proof-sandbox.ts`
- `air-mentor-api/src/modules/admin-structure.ts`
- `air-mentor-api/src/modules/academic-admin-offerings-routes.ts`
- `air-mentor-api/src/db/migrations/0014_async_proof_run_queue.sql`
- `air-mentor-api/src/db/schema.ts`
- `air-mentor-api/tests/proof-run-queue.test.ts`

## Completion Gate Verdict

- Gate question: "Who finishes refresh, how, and what proves it?"
- Verdict: **locally satisfied**.
  - Who: in-process backend proof worker (or activation-path synchronous fallback).
  - How: leased queue claim -> proof run execution -> run service completion -> optional activation projection publish.
  - Proof: explicit bootstrap wiring, lease SQL, terminal status writes, and dashboard consumption paths.
- Remaining closure risk: deployed worker liveness and end-to-end live completion still need credentialed runtime verification.
