# Data-Flow Corpus Index

Status: complete for the required high-risk flow families in this rerun pass.
Canonical path: `audit-map/06-data-flow/`.

## Scope Covered In This Corpus

- proof run, checkpoint, and operational projection publication
- proof-risk artifact and evidence snapshot lifecycle
- academic route/session/bootstrap lifecycle
- sysadmin request/proof/history/search workspace lifecycle
- telemetry and startup-diagnostics lifecycle

## Corpus Entries

1. `audit-map/06-data-flow/flow-proof-run-checkpoint-projection.md`
2. `audit-map/06-data-flow/flow-proof-risk-artifact-evidence-snapshot.md`
3. `audit-map/06-data-flow/flow-academic-route-session-bootstrap.md`
4. `audit-map/06-data-flow/flow-sysadmin-request-proof-history-search.md`
5. `audit-map/06-data-flow/flow-telemetry-startup-diagnostics.md`

## Evidence Priority Used

- code paths and runtime services in `src/` and `air-mentor-api/src/`
- test anchors from `tests/` and `air-mentor-api/tests/` where already referenced in mapped coverage
- prior status and reconciliation artifacts where relevant to continuity

## Remaining Boundaries

- This corpus closes the missing standalone backing for the final data-flow map (C-009 target).
- It does not claim full component-by-component long-tail `src/` interaction closure.
- Live environment validation remains separately governed by C-001 and live-pass blockers.
