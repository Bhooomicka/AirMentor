# UX Consistency Cohesion Pass

Version: `v1.0`
Date: `2026-04-18`
Related orchestrator prompt: `P14`

## Objective

Validate cross-surface UX consistency, cognitive load safety, and accessibility cohesion.
Any high/critical inconsistency in decision-critical flows is release-blocking.

## Read First

1. `audit-map/20-prompts/adversarial-master-orchestrator-suite.md`
2. `audit-map/11-ux-audit/`
3. `audit-map/12-frontend-microinteractions/`
4. `audit-map/14-reconciliation/contradiction-matrix.md`

## Mandatory Evidence Targets

- `src/system-admin-ui.tsx`
- `src/ui-primitives.tsx`
- `src/theme.ts`
- `src/system-admin-live-app.tsx`
- `src/system-admin-request-workspace.tsx`
- `src/system-admin-faculties-workspace.tsx`
- `src/system-admin-proof-dashboard-workspace.tsx`
- `src/pages/risk-explorer.tsx`
- `src/pages/student-shell.tsx`
- `src/pages/hod-pages.tsx`
- `src/portal-entry.tsx`

## Mandatory Checks

- `P14-C01`: Terminology and status labels are consistent for equivalent actions.
- `P14-C02`: High-risk screens keep cognitive load bounded and decision clarity high.
- `P14-C03`: Empty, loading, and error states are coherent across surfaces.
- `P14-C04`: Keyboard focus order remains predictable across reusable primitives.
- `P14-C05`: Accessibility semantics remain consistent across reused components.
- `P14-C06`: Mobile and narrow viewports preserve access to critical controls.
- `P14-C07`: Progressive disclosure does not hide critical transitions.

## Race And Edge Scripts

- `P14-R01`: Rapid filter and scope changes under dense tables.
- `P14-R02`: Keyboard-only traversal across nested overlays.
- `P14-R03`: Live updates during active decision forms.
- `P14-R04`: Responsive layout shift during interaction.

## Required Output Contract

Use the shared required finding schema and mandatory schema blocks from:
- `audit-map/20-prompts/adversarial-master-orchestrator-suite.md`

Also emit required test output for every high/critical finding.
Each high/critical finding must include:
1. One keyboard/screen-reader path test.
2. One label and terminology consistency assertion set.

## Required Durable Updates

- Record UX contradictions in `audit-map/14-reconciliation/contradiction-matrix.md`.
- Update `audit-map/24-agent-memory/working-knowledge.md` with unresolved UX cohesion risk.
- Persist artifacts to `audit-map/17-artifacts/local/` and snapshots to `audit-map/18-snapshots/repo/`.

## Hard Pass/Fail Gates

- Fail if any high/critical UX consistency or cognitive-load trap remains open.
- Fail if critical accessibility semantics diverge across equivalent flows.
- Fail if high/critical findings lack required test output.
- Pass only when UX and accessibility behavior is coherent across roles and surfaces.
