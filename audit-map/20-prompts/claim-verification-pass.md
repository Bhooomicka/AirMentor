# Claim Verification Pass

Version: `v1.0`

This pass exists to verify the current audit corpus claim by claim.

## Mission

Build a durable matrix of the strongest existing audit claims and test whether their wording is justified by evidence.

For every major claim family, determine:

- the exact claim
- where the claim currently appears
- what evidence actually supports it
- whether the evidence is direct or inferred
- whether the current confidence is too strong, correct, or too weak
- whether the claim should be downgraded, split, or contradicted

## Required Outputs

Write or update:

- `audit-map/32-reports/claim-verification-matrix.md`
- `audit-map/24-agent-memory/working-knowledge.md`
- `audit-map/14-reconciliation/reconciliation-log.md`
- `audit-map/14-reconciliation/contradiction-matrix.md`
- `audit-map/23-coverage/coverage-ledger.md`

## Required Method

At minimum verify claim families covering:

- architecture
- role surfaces
- feature registry
- dependency graph
- data flow
- state flow
- ML/risk/proof semantics
- test posture
- UX findings
- live-vs-local findings

For each claim, label it with one of:

- `strongly-supported`
- `supported-with-gaps`
- `weakly-supported`
- `contradicted`
- `blocked-from-verification`

Do not collapse all claims into a summary paragraph.
Build a matrix.

## Completion Gate

This pass is not complete until:

- the strongest current claims have been sampled across all major audit families
- any overstated claim language has been downgraded in durable files
- contradictions are written down, not implied
