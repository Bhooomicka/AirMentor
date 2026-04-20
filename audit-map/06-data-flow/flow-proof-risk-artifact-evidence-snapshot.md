# Flow: Proof-Risk Artifacts and Evidence Snapshots

## Authoritative Sources

- `air-mentor-api/src/lib/msruas-proof-control-plane.ts`
- `air-mentor-api/src/lib/proof-control-plane-runtime-service.ts`
- `air-mentor-api/src/lib/proof-risk-model.ts`
- `air-mentor-api/src/lib/proof-control-plane-playback-service.ts`
- `src/pages/risk-explorer.tsx`
- `src/pages/student-shell.tsx`

## Entry Triggers And Producers

- Proof run finalization and runtime recompute paths trigger risk scoring and provenance writes.
- Artifact rebuild paths produce or refresh model artifact bundles (`riskModelArtifacts`).
- Assessment/risk retrieval paths emit role-projected risk payloads to frontend surfaces.

## Transformations And Derivations

- Stage evidence and policy context are transformed into risk assessments per learner/scope.
- Correlation and calibration logic derive display-safe risk heads and banded outputs.
- Evidence snapshots are derived and stored to preserve row-level provenance context.

## Caches, Shadows, Snapshots, Persistence Boundaries

- Artifact persistence boundary: `riskModelArtifacts` stores active model/artifact payloads.
- Evidence persistence boundary: `riskEvidenceSnapshots` stores provenance snapshots for runs.
- Assessment delivery boundary: risk payloads served to admin/academic/student consumers.
- Fallback branch boundary: simulated/downgraded provenance can still produce bounded outputs.

## Readers And Consumers

- Sysadmin proof dashboards and risk explorer views.
- Academic role pages that read active risk outputs.
- Student shell risk/timeline views where role-projected risk signals are visible.
- Backend playback and runtime services that consume artifact/evidence lineage.

## Failure And Fallback Branches

- Missing or stale artifact payloads route through deterministic fallback risk computation.
- Missing graph/history context can produce `fallback-simulated` style provenance references.
- Probability-head display can be suppressed by support/calibration gates while banding remains.

## Restore And Replay Paths

- Replay and runtime recompute can regenerate risk payload families after snapshot restore.
- Active run switching and republish paths refresh downstream risk read surfaces.

## Drift And Staleness Risks

- Artifact freshness can diverge from runtime evidence if rebuild cadence lags.
- Cross-surface explanation richness can drift between proof-tail and academic consumers.
- Fallback provenance interpretation risk remains if operators read simulated provenance as live truth.

## Evidence Anchors

- `air-mentor-api/src/lib/msruas-proof-control-plane.ts`
- `air-mentor-api/src/lib/proof-control-plane-runtime-service.ts`
- `air-mentor-api/src/lib/proof-risk-model.ts`
- `air-mentor-api/src/lib/proof-control-plane-playback-service.ts`
- `tests/risk-explorer.test.tsx`
- `tests/student-shell.test.tsx`
- `air-mentor-api/tests/proof-risk-model.test.ts`
- `air-mentor-api/tests/evaluate-proof-risk-model.test.ts`
