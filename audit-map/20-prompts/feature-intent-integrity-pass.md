# Feature Intent Integrity Pass

Version: `v1.0`
Date: `2026-04-18`
Related orchestrator prompt: `P10`

## Objective

Verify that implemented behavior preserves feature intent, decision semantics, and user value.
Treat intent mismatch as release-blocking until proven resolved.

## Read First

1. `audit-map/20-prompts/adversarial-master-orchestrator-suite.md`
2. `airmentor-feature-registry.md`
3. `audit-map/15-final-maps/feature-registry.md`
4. `audit-map/14-reconciliation/contradiction-matrix.md`

## Mandatory Evidence Targets

- `airmentor-feature-registry.md`
- `src/portal-entry.tsx`
- `src/App.tsx`
- `src/system-admin-live-app.tsx`
- `src/system-admin-request-workspace.tsx`
- `src/system-admin-proof-dashboard-workspace.tsx`
- `src/pages/risk-explorer.tsx`
- `src/pages/student-shell.tsx`
- `src/pages/hod-pages.tsx`
- `air-mentor-api/src/modules/admin-requests.ts`
- `air-mentor-api/src/modules/academic.ts`
- `air-mentor-api/src/modules/academic-runtime-routes.ts`

## Mandatory Checks

- `P10-C01`: Feature intent maps to concrete implementation for high-impact features.
- `P10-C02`: User-value paths avoid dead-end or contradictory outcomes.
- `P10-C03`: Decision labels match resulting state transitions.
- `P10-C04`: Frontend/backend rule parity holds for intent-critical actions.
- `P10-C05`: Intent-critical transitions have explicit failure and recovery semantics.
- `P10-C06`: Role constraints do not accidentally break expected outcomes.
- `P10-C07`: Removed or deprecated behavior is explicit, not accidental omission.

## Race And Edge Scripts

- `P10-R01`: Concurrent approvals/rejections on same entity.
- `P10-R02`: Role switch while intent-critical action is in flight.
- `P10-R03`: Multi-tab stale write overwriting newer intent-consistent state.
- `P10-R04`: Browser back/forward replay causing decision branch inversion.

## Required Output Contract

Use the shared required finding schema and mandatory schema blocks from:
- `audit-map/20-prompts/adversarial-master-orchestrator-suite.md`

Also emit required test output for every high/critical finding.
Each high/critical finding must include:
1. One end-to-end intent-preservation test.
2. One backend contract assertion set.

## Required Durable Updates

- Add contradictions to `audit-map/14-reconciliation/contradiction-matrix.md` for intent mismatches.
- Update `audit-map/24-agent-memory/working-knowledge.md` with unresolved intent risk.
- Store evidence in `audit-map/17-artifacts/local/` and snapshots in `audit-map/18-snapshots/repo/`.

## Hard Pass/Fail Gates

- Fail if any high/critical intent mismatch remains open.
- Fail if logic fallacy checks are incomplete on critical journeys.
- Fail if high/critical findings lack required test output.
- Pass only when feature intent and implementation behavior are coherent.
