# Proof Refresh Completion Pass

Version: `v1.0`

## Mission

Trace end-to-end ownership of proof-refresh completion after queueing.

This pass exists because queueing is known, but worker/consumer completion ownership is still not deterministically mapped.

## Required Outputs

Write or update:

- `audit-map/13-backend-provenance/proof-refresh-completion-lineage.md`
- `audit-map/15-final-maps/master-system-map.md`
- `audit-map/23-coverage/unreviewed-surface-list.md`
- `audit-map/23-coverage/review-status-by-path.md`
- `audit-map/24-agent-memory/working-knowledge.md`

## Required Method

Trace from:

- UI/API refresh trigger
- queue insert / enqueue path
- worker claim / lease / heartbeat
- completion / failure / retry / abandonment
- projection publish / cache invalidation / downstream UI consumption

Explicitly identify:

- owning code path
- tables / records touched
- background runner / cron / queue loop entrypoint
- terminal states
- drift risk if the worker is absent or delayed

## Completion Gate

This pass is complete only when the post-queue ownership path is explicit enough that a human can answer “who finishes the refresh, how, and what proves it?”
