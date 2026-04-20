# Cross Flow Recovery Pass

Version: `v1.0`
Date: `2026-04-18`
Related orchestrator prompt: `P11`

## Objective

Validate end-to-end workflow integrity across role boundaries, interruptions, and recoveries.
Any critical flow that cannot recover deterministically is a closure blocker.

## Read First

1. `audit-map/20-prompts/adversarial-master-orchestrator-suite.md`
2. `audit-map/15-final-maps/feature-registry.md`
3. `audit-map/07-state-flows/`
4. `audit-map/14-reconciliation/contradiction-matrix.md`

## Mandatory Evidence Targets

- `src/portal-entry.tsx`
- `src/academic-session-shell.tsx`
- `src/system-admin-session-shell.tsx`
- `src/system-admin-live-app.tsx`
- `src/system-admin-request-workspace.tsx`
- `src/system-admin-faculties-workspace.tsx`
- `src/system-admin-proof-dashboard-workspace.tsx`
- `src/repositories.ts`
- `air-mentor-api/src/modules/session.ts`
- `air-mentor-api/src/modules/admin-requests.ts`
- `air-mentor-api/src/modules/academic-authoritative-first.ts`

## Mandatory Checks

- `P11-C01`: Full journey integrity for login, context selection, action, confirmation, and recovery.
- `P11-C02`: Cross-workspace handoff state consistency.
- `P11-C03`: Reload and resume resilience at each major flow stage.
- `P11-C04`: Partial failure recovery without phantom success.
- `P11-C05`: Retry idempotence for mutating actions.
- `P11-C06`: Back/forward navigation preserves invariants.
- `P11-C07`: Same-entity coherence across role boundaries.

## Race And Edge Scripts

- `P11-R01`: Refresh during in-flight mutation and retry.
- `P11-R02`: Competing updates by different roles.
- `P11-R03`: Resume from stale deep link after server-side mutation.
- `P11-R04`: Network instability during optimistic transition.

## Required Output Contract

Use the shared required finding schema and mandatory schema blocks from:
- `audit-map/20-prompts/adversarial-master-orchestrator-suite.md`

Also emit required test output for every high/critical finding.
Each high/critical finding must include:
1. One deterministic multi-step e2e scenario.
2. One interruption-and-recovery assertion set.

## Required Durable Updates

- Record cross-flow contradictions in `audit-map/14-reconciliation/contradiction-matrix.md`.
- Update `audit-map/24-agent-memory/working-knowledge.md` with unresolved recovery gaps.
- Persist artifacts to `audit-map/17-artifacts/local/` and snapshots to `audit-map/18-snapshots/repo/`.

## Hard Pass/Fail Gates

- Fail if any critical recovery path is unverified.
- Fail if any high/critical flow-integrity defect remains open.
- Fail if high/critical findings lack required test output.
- Pass only with full workflow and interruption recovery evidence.
