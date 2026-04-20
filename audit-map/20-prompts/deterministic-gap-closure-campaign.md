# Deterministic Gap Closure Campaign

Version: `v1.1`

This campaign exists to close the final high-risk gaps that still block a claim of near-lossless system understanding.

## Campaign Goal

Do not re-summarize the codebase.

Do not repeat already completed broad passes.

Do not treat prior final maps as closure by default.

Instead, drive the remaining work needed for a stronger deterministic claim:

1. standalone per-flow data-flow corpus
2. proof-refresh completion ownership
3. full long-tail frontend interaction coverage
4. credentialed live same-student / proof / role parity verification

## Required Inputs

Read these before starting any pass in this campaign:

1. `audit-map/32-reports/closure-readiness-verdict.md`
2. `audit-map/32-reports/residual-gap-closure-report.md`
3. `audit-map/32-reports/unknown-omission-ledger.md`
4. `audit-map/32-reports/claim-verification-matrix.md`
5. `audit-map/23-coverage/unreviewed-surface-list.md`
6. `audit-map/23-coverage/review-status-by-path.md`
7. `audit-map/23-coverage/coverage-ledger.md`
8. `audit-map/24-agent-memory/working-knowledge.md`
9. `audit-map/24-agent-memory/known-ambiguities.md`
10. `audit-map/14-reconciliation/reconciliation-log.md`
11. `audit-map/14-reconciliation/contradiction-matrix.md`
12. `audit-map/15-final-maps/*`
13. `audit-map/10-live-behavior/*`
14. `audit-map/12-frontend-microinteractions/*`
15. `audit-map/13-backend-provenance/*`

## Hard Rules

- Every pass in this campaign must materially reduce one of the four named closure blockers.
- If a pass only restates an already known blocker, it does not count as progress.
- If a pass is blocked, it must write:
  - the exact blocker
  - the exact missing capability or credential
  - the exact resume point
- `live-credentialed-parity-pass` specifically must produce a role credential matrix, a shared target tuple (`studentId`, `simulationRunId`, `simulationStageCheckpointId`, semester, stage, route), and a durable evidence manifest or it is non-creditable.
- Treat the current audit corpus as strong but incomplete.
- Prefer code, tests, configs, and direct live evidence over previous prose.
- If a previous final-map claim conflicts with deeper code truth, update the deeper truth and record the contradiction.

## Completion Standard

This campaign is only complete when:

- the data-flow family has a real per-flow corpus
- proof-refresh completion ownership is traced end-to-end
- long-tail frontend interaction coverage is materially extended beyond the six dense clusters
- live credentialed parity is either directly observed or deterministically blocked with exact manual preconditions
- a final closure-readiness rerun confirms the new state explicitly

## Queue Shape

Recommended order:

1. `data-flow-corpus-rerun-pass`
2. `proof-refresh-completion-pass`
3. `frontend-long-tail-pass`
4. `live-credentialed-parity-pass`
5. `closure-readiness-pass`

## Output Discipline

At the end of each pass, record:

1. what was actually closed
2. what remained open
3. which durable files were updated
4. whether any previously open risk was removed, reduced, or unchanged
5. whether a manual checkpoint is required before the next pass
