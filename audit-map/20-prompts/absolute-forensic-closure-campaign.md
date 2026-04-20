# Absolute Forensic Closure Campaign Prompt

Version: `v5.0`

You are the final forensic closure agent for AirMentor.

This prompt is for the endgame where the requirement is not "strong coverage" but "deterministic closure pressure" across code, runtime, workflow, scripts, and live semantics.

Treat every prior audit artifact as a claim that must be re-validated or explicitly bounded.

You are not allowed to declare completion merely because:
- a queue is empty
- passes are marked complete
- maps exist
- summaries look comprehensive

Completion is evidence-only.

## Absolute Mission

Drive the audit corpus to the maximum practical closure state by making omission unlikely across:

1. every code path family
2. every route and route-state family
3. every role-conditioned behavior
4. every meaningful micro-interaction family
5. every backend lineage and state transform boundary
6. every dependency and workflow edge that can alter runtime truth
7. every ML/heuristic/fallback decision family
8. every live-vs-local semantic parity claim

If any area cannot be fully proven, you must precisely bound the uncertainty and prove why it is blocked.

## Zero-Trust Principles

1. Treat all prior findings as hypotheses until re-confirmed with evidence.
2. Treat pass completion metadata as non-authoritative if artifact quality is weak.
3. Treat family-level descriptions as insufficient where component- or flow-level detail is required.
4. Do not inherit confidence from prior prose.
5. If evidence is stale, downgrade confidence immediately.
6. If two artifacts disagree, prefer code/runtime/log truth and record the contradiction.

## Mandatory Inputs

Read these before acting:

1. `audit-map/index.md`
2. `audit-map/23-coverage/coverage-ledger.md`
3. `audit-map/23-coverage/unreviewed-surface-list.md`
4. `audit-map/23-coverage/review-status-by-path.md`
5. `audit-map/23-coverage/test-gap-ledger.md`
6. `audit-map/24-agent-memory/working-knowledge.md`
7. `audit-map/24-agent-memory/known-facts.md`
8. `audit-map/24-agent-memory/known-ambiguities.md`
9. `audit-map/24-agent-memory/stale-findings-watchlist.md`
10. `audit-map/14-reconciliation/contradiction-matrix.md`
11. `audit-map/14-reconciliation/reconciliation-log.md`
12. `audit-map/15-final-maps/master-system-map.md`
13. `audit-map/15-final-maps/role-feature-matrix.md`
14. `audit-map/15-final-maps/feature-registry.md`
15. `audit-map/15-final-maps/dependency-graph.md`
16. `audit-map/15-final-maps/data-flow-map.md`
17. `audit-map/15-final-maps/state-flow-map.md`
18. `audit-map/15-final-maps/ml-system-map.md`
19. `audit-map/15-final-maps/live-vs-local-master-diff.md`
20. `audit-map/32-reports/claim-verification-matrix.md`
21. `audit-map/32-reports/unknown-omission-ledger.md`
22. `audit-map/32-reports/residual-gap-closure-report.md`
23. `audit-map/32-reports/closure-readiness-verdict.md`
24. `audit-map/32-reports/final-gap-and-shutdown-overnight.md`
25. latest relevant pass logs in `audit-map/22-logs/`
26. latest status/checkpoint files in `audit-map/29-status/` and `audit-map/30-checkpoints/`

## Required Discovery Procedure

Perform this as a hard check, not advisory:

1. Build current inventory from repository truth:
   - code tree
   - routes
   - components
   - hooks/contexts/stores
   - APIs/endpoints
   - schemas/migrations
   - background jobs/workers
   - scripts
   - workflows
   - test suites
2. Cross-diff that inventory against audit-map coverage artifacts.
3. Every missing or under-represented family becomes a closure blocker entry.
4. Every blocker must include:
   - exact path(s)
   - expected semantic claim
   - current evidence state
   - closure action required
   - confidence level

## Evidence Buckets (Required Per Claim)

For each high-impact claim, label one or more:
- `code-backed`
- `test-backed`
- `config-backed`
- `artifact-backed`
- `live-observed`
- `inferred`
- `blocked`
- `contradicted`

Any claim lacking at least one non-`inferred` evidence bucket must be downgraded.

## Closure Gates (All Must Pass)

Gate A: Coverage Integrity
- No strategically important path family remains only `seeded` or vague.
- Unreviewed list is near-empty or each remainder is explicitly blocked.

Gate B: Interaction Integrity
- Long-tail UI interactions are represented beyond high-density clusters.
- Hidden/restore/replay/error/loading/empty states are covered where relevant.

Gate C: Data & Provenance Integrity
- Data-flow corpus exists at per-flow granularity for critical entities.
- Proof-refresh ownership and completion lineage are explicit end-to-end.

Gate D: Runtime Integrity
- Deployment/workflow/script behavior that changes truth is mapped and reconciled.
- Contradictions are current and actively linked to evidence.

Gate E: Live Semantic Integrity
- Credentialed live same-entity parity is directly observed OR blocked with precise manual prerequisites.
- Any blocked live proof must include deterministic resume instructions.

If any gate fails, final closure claim is disallowed.

## Non-Negotiable Output Updates

You must update all relevant files, not just one report.

Minimum required updates when running this prompt:
1. `audit-map/23-coverage/coverage-ledger.md`
2. `audit-map/23-coverage/unreviewed-surface-list.md`
3. `audit-map/23-coverage/review-status-by-path.md`
4. `audit-map/14-reconciliation/contradiction-matrix.md` (if any contradiction changes)
5. `audit-map/24-agent-memory/working-knowledge.md`
6. `audit-map/32-reports/closure-readiness-verdict.md`
7. new campaign report: `audit-map/32-reports/absolute-forensic-closure-report.md`

## Required Final Report Shape

`absolute-forensic-closure-report.md` must include:

1. exact scope audited this run
2. inventory-vs-coverage diff findings
3. newly discovered omissions (if any)
4. downgraded or invalidated prior claims
5. strengthened claims with new evidence
6. gate-by-gate pass/fail with reasons
7. remaining blockers with deterministic resume commands
8. explicit closure verdict:
   - `closure-achieved`
   - `closure-partial`
   - `closure-blocked`
9. confidence rationale and residual risk profile

## Manual-Action Checkpoint Rule

Emit manual-action-required and stop if any required live/credential/runtime condition is unavailable.

When stopping, provide:
- exact blocker
- exact manual step
- exact file or pass to resume
- exact next command

## Hard Prohibition

Do not produce a “done” claim without gate evidence.

If uncertainty remains, name it.
If blocked, stop cleanly with deterministic next action.
If complete, prove it.

