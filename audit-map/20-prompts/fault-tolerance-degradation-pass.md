# Fault Tolerance Degradation Pass

Version: `v1.0`
Date: `2026-04-18`
Related orchestrator prompt: `P12`

## Objective

Audit fault containment and graceful degradation behavior across frontend and backend paths.
Prevent silent failure, phantom success, and unsafe user states.

## Read First

1. `audit-map/20-prompts/adversarial-master-orchestrator-suite.md`
2. `audit-map/14-reconciliation/contradiction-matrix.md`
3. `audit-map/09-test-audit/`
4. `audit-map/10-live-behavior/`

## Mandatory Evidence Targets

- `src/main.tsx`
- `src/App.tsx`
- `src/system-admin-app.tsx`
- `src/system-admin-live-app.tsx`
- `src/academic-session-shell.tsx`
- `src/system-admin-session-shell.tsx`
- `src/repositories.ts`
- `air-mentor-api/src/app.ts`
- `air-mentor-api/src/lib/http-errors.ts`
- `air-mentor-api/src/modules/session.ts`
- `air-mentor-api/src/modules/client-telemetry.ts`

## Mandatory Checks

- `P12-C01`: Frontend local faults are contained and do not collapse global shell.
- `P12-C02`: Backend error typing and status mapping is deterministic.
- `P12-C03`: Degraded paths preserve actionable user feedback.
- `P12-C04`: Retry and backoff paths avoid duplicate side effects.
- `P12-C05`: Silent drop and stale-success UI behavior is eliminated.
- `P12-C06`: Error telemetry includes useful context without leaking sensitive data.
- `P12-C07`: Non-recoverable paths provide explicit user-safe guidance.

## Race And Edge Scripts

- `P12-R01`: Burst failures under degraded dependency.
- `P12-R02`: Repeated retries from multiple surfaces.
- `P12-R03`: Error then immediate route change with stale success render risk.
- `P12-R04`: Session expiry during active mutation and replay.

## Required Output Contract

Use the shared required finding schema and mandatory schema blocks from:
- `audit-map/20-prompts/adversarial-master-orchestrator-suite.md`

Also emit required test output for every high/critical finding.
Each high/critical finding must include:
1. One negative-path failure test.
2. One explicit recovery-path test.

## Required Durable Updates

- Add contradictions for degradation gaps in `audit-map/14-reconciliation/contradiction-matrix.md`.
- Update `audit-map/24-agent-memory/working-knowledge.md` with unresolved fault-containment risk.
- Store artifacts under `audit-map/17-artifacts/local/` and snapshots under `audit-map/18-snapshots/repo/`.

## Hard Pass/Fail Gates

- Fail if any high/critical containment or degradation defect remains open.
- Fail if critical failure paths lack deterministic user-safe recovery.
- Fail if high/critical findings lack required test output.
- Pass only when fault containment and graceful degradation are proven.
