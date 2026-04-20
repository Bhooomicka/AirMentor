# Unknown Omission Pass

Version: `v1.0`

This pass exists to discover what the current audit still does not represent.

## Mission

Search for omissions that are not already called out in the current uncovered-surface list.

You must compare repo reality against audit representation and find:

- missing component clusters
- missing helper modules with semantic behavior
- missing scripts or workflows with side effects
- missing restore, replay, or persistence paths
- missing error, empty, loading, retry, and fallback states
- missing live or deployment edges
- missing proof or ML artifact flows
- missing same-entity parity checks

## Required Outputs

Write or update:

- `audit-map/32-reports/unknown-omission-ledger.md`
- `audit-map/23-coverage/unreviewed-surface-list.md`
- `audit-map/23-coverage/review-status-by-path.md`
- `audit-map/23-coverage/coverage-ledger.md`
- `audit-map/24-agent-memory/known-ambiguities.md`

## Required Method

Cross-check at least:

- `src/`
- `src/pages/`
- `src/api/`
- `air-mentor-api/src/`
- `air-mentor-api/src/db/`
- `scripts/`
- `air-mentor-api/scripts/`
- `tests/`
- `air-mentor-api/tests/`
- `.github/workflows/`

against:

- existing final maps
- existing pass outputs
- current uncovered-surface and review-status ledgers

For each omission found, record:

- path or subsystem
- why it is insufficiently represented
- what type of omission it is
- what pass or action is required to close it

## Completion Gate

This pass is not complete until it has found either:

- genuinely new omissions, or
- strong evidence that the current uncovered list already spans the remaining material gaps

If no new omissions are found, that claim itself must be defended with evidence.
