# Data-Flow Corpus Rerun Pass

Version: `v1.0`

## Mission

Replace the current overlay-only data-flow state with a real standalone per-flow corpus.

## Required Outputs

Write or update:

- `audit-map/06-data-flow/flow-corpus-index.md`
- one or more standalone per-flow entries under `audit-map/06-data-flow/`
- `audit-map/15-final-maps/data-flow-map.md`
- `audit-map/23-coverage/unreviewed-surface-list.md`
- `audit-map/23-coverage/coverage-ledger.md`
- `audit-map/24-agent-memory/working-knowledge.md`

## Required Method

Trace concrete entity families and flows, including:

- authoritative source
- derived transformations
- caches and snapshots
- persistence boundaries
- UI projections
- role-specific reshaping
- failure/fallback branches

You must cover at least:

- proof run / checkpoint / projection flow
- proof-risk artifact and evidence snapshot flow
- academic route/session/bootstrap flow
- sysadmin request/proof/history search flow
- telemetry/startup-diagnostics flow

## Completion Gate

This pass is not complete until `audit-map/06-data-flow/` contains a real per-flow corpus and `data-flow-map.md` is no longer only overlay evidence.
