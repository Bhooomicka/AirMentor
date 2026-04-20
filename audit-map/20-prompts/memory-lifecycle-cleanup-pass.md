# Memory Lifecycle Cleanup Pass

Version: `v1.0`
Date: `2026-04-18`
Related orchestrator prompt: `P13`

## Objective

Find and close memory lifecycle defects: leaked listeners, leaked timers, stale subscriptions, and unbounded side effects.
Treat unresolved high/critical leaks as release blockers.

## Read First

1. `audit-map/20-prompts/adversarial-master-orchestrator-suite.md`
2. `audit-map/14-reconciliation/contradiction-matrix.md`
3. `audit-map/09-test-audit/`
4. `audit-map/24-agent-memory/working-knowledge.md`

## Mandatory Evidence Targets

- `src/system-admin-live-app.tsx`
- `src/system-admin-proof-dashboard-workspace.tsx`
- `src/system-admin-request-workspace.tsx`
- `src/system-admin-faculty-calendar-workspace.tsx`
- `src/pages/risk-explorer.tsx`
- `src/pages/student-shell.tsx`
- `src/pages/hod-pages.tsx`
- `src/telemetry.ts`
- `src/proof-playback.ts`
- `air-mentor-api/src/lib/proof-run-queue.ts`
- `air-mentor-api/src/lib/proof-queue-governance.ts`

## Mandatory Checks

- `P13-C01`: Listener registration has deterministic cleanup.
- `P13-C02`: Interval and timeout resources are cleaned on scope transition.
- `P13-C03`: Subscription and observer resources are released on route changes.
- `P13-C04`: Effect dependency changes do not create duplicate side effects.
- `P13-C05`: Queue worker loops release heartbeat resources on stop/retry paths.
- `P13-C06`: Memory growth remains bounded in remount stress loops.
- `P13-C07`: Leak regression guardrails compare baseline and post-run metrics.

## Race And Edge Scripts

- `P13-R01`: Repeated mount/unmount loops.
- `P13-R02`: Scope switching during active polling.
- `P13-R03`: Queue retry storms with worker restarts.
- `P13-R04`: Concurrent route transitions and telemetry emission.

## Required Output Contract

Use the shared required finding schema and mandatory schema blocks from:
- `audit-map/20-prompts/adversarial-master-orchestrator-suite.md`

Also emit required test output for every high/critical finding.
Each high/critical finding must include:
1. One remount stress test.
2. One baseline-restoration assertion set.

## Required Durable Updates

- Record leak contradictions in `audit-map/14-reconciliation/contradiction-matrix.md`.
- Update `audit-map/24-agent-memory/working-knowledge.md` with lifecycle regression status.
- Save artifacts in `audit-map/17-artifacts/local/` and snapshots in `audit-map/18-snapshots/repo/`.

## Hard Pass/Fail Gates

- Fail if any high/critical lifecycle leak defect remains open.
- Fail if baseline restoration evidence is missing for critical components.
- Fail if high/critical findings lack required test output.
- Pass only when lifecycle behavior is bounded and deterministic.
