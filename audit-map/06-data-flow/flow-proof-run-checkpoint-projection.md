# Flow: Proof Run, Checkpoint, and Projection

## Authoritative Sources

- `air-mentor-api/src/lib/proof-run-queue.ts`
- `air-mentor-api/src/lib/msruas-proof-control-plane.ts`
- `air-mentor-api/src/lib/proof-control-plane-runtime-service.ts`
- `air-mentor-api/src/lib/proof-control-plane-activation-service.ts`
- `src/proof-playback.ts`
- `src/proof-pilot.ts`

## Entry Triggers And Producers

- Admin or runtime flow enqueues simulation work onto `simulation_runs` queue state.
- Queue worker claims a lease and drives run execution and heartbeat updates.
- Seeded or runtime paths produce stage artifacts, checkpoint material, and projection candidates.
- Frontend proof pages trigger reads for playback/checkpoints and activate restore selections.

## Transformations And Derivations

- Queue metadata is transformed into executable run context (seed policy, parent linkage, scope).
- Run execution materializes runtime families and rebuilds stage/checkpoint snapshots.
- Activation flow derives an authoritative operational projection from active run outputs.
- Frontend playback derives user-visible timeline/progress state from checkpoint payloads.

## Caches, Shadows, Snapshots, Persistence Boundaries

- Durable queue and run state: backend DB tables (`simulation_runs` and related runtime families).
- Durable checkpoint/snapshot state: backend runtime checkpoint and stage playback surfaces.
- Frontend restore cache: proof playback selection persisted in local storage (`airmentor-proof-playback-selection`).
- Operational publication boundary: projection publish writes become cross-surface read truth.

## Readers And Consumers

- Sysadmin proof dashboard and proof playback consumers in `src/proof-playback.ts` and admin workspaces.
- Academic role surfaces consume active operational projection outputs after publication.
- Backend diagnostic services consume run/checkpoint lineage for observability and replay.

## Failure And Fallback Branches

- Queue lease failure or worker interruption yields retry/failure transitions at queue state.
- Runtime recompute can proceed without all optional artifact rebuild branches.
- Incomplete context can force downgraded or deferred projection publication until valid activation state.

## Restore And Replay Paths

- Snapshot restore relaunches runs with `parentSimulationRunId` lineage.
- Playback UI restores prior checkpoint selection from storage and resumes progression rails.
- Re-activation can republish operational projection for parity after run state transitions.

## Drift And Staleness Risks

- Queue-to-consumer ownership can drift if producer paths exist without clear worker liveness proof.
- Frontend restore state can become stale when checkpoint context changes between sessions.
- Projection rewrite timing can transiently expose mixed old/new user-visible state.

## Evidence Anchors

- `air-mentor-api/src/lib/proof-run-queue.ts`
- `air-mentor-api/src/lib/msruas-proof-control-plane.ts`
- `air-mentor-api/src/lib/proof-control-plane-runtime-service.ts`
- `air-mentor-api/src/lib/proof-control-plane-activation-service.ts`
- `src/proof-playback.ts`
- `src/proof-pilot.ts`
- `tests/proof-playback.test.ts`
- `tests/proof-pilot.test.ts`
- `tests/system-admin-proof-dashboard-workspace.test.tsx`
