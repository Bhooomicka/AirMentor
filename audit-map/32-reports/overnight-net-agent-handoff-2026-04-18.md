# Overnight Net Agent Handoff

Date: `2026-04-18`
Owner: `AirMentor audit operator`

## Executive Decision

Use the existing Arctic + tmux automation pipeline.
Do not bypass it for overnight operation.

Reason:
- it preserves status/checkpoint/log artifacts required by audit-map governance
- it supports provider fallback when native route is unavailable
- it now includes hardened stale-session recovery and stricter alternate-slot eligibility

Manual one-pass execution is only recommended for emergency debugging.

## What Was Added In This Update

1. Prompt suite expanded to `Prompt 0-14` in:
   - `audit-map/20-prompts/adversarial-master-orchestrator-suite.md`
2. New mandatory schema blocks added:
   - truth drift
   - intent integrity
   - logic integrity
   - UX integrity
   - recovery integrity
3. Truth drift is now a hard gate in Prompt 0 global closure logic.
4. Six new standalone pass prompts were added:
   - `audit-map/20-prompts/truth-drift-reconciliation-pass.md`
   - `audit-map/20-prompts/feature-intent-integrity-pass.md`
   - `audit-map/20-prompts/cross-flow-recovery-pass.md`
   - `audit-map/20-prompts/fault-tolerance-degradation-pass.md`
   - `audit-map/20-prompts/memory-lifecycle-cleanup-pass.md`
   - `audit-map/20-prompts/ux-consistency-cohesion-pass.md`
5. Queue sample updated to include the six new passes and closure validations:
   - `audit-map/31-queues/recommended-overnight.queue.sample`
6. Routing and orchestration hardening:
   - `audit-map/16-scripts/select-execution-route.sh`
   - `audit-map/16-scripts/night-run-orchestrator.sh`
   - `audit-map/16-scripts/usage-refresh-orchestrator.sh`
   - `audit-map/16-scripts/tmux-start-job.sh`
   - `audit-map/16-scripts/_audit-common.sh`

## Current Route Health Snapshot

Reference:
- `audit-map/25-accounts-routing/usage-status.md`

### Ready Routes

- native: `native-codex-session` (`gpt-5.4`)
- github-copilot: `copilot-accneww432` (`gpt-5.3-codex` execution-verified)
- codex: `codex-05`, `codex-01`, `codex-02`, `codex-06` (`gpt-5.3-codex` execution-verified)
- google: `google-main` (`gemini-3.1-pro-preview` execution-verified)

### Degraded Or Excluded Routes

- `codex-03`: quota-blocked/cooling-down
- `codex-04`: cooling-down
- `copilot-raed2180416`: last execution probe `provider-rejected` (now excluded by route-selection logic)
- `antigravity-main`: execution failed (`unexpected-output`)

## Verified Auto-Switch Behavior

Validated in shell after patching:
- default route: native-codex
- when native is unavailable/excluded: switches to `copilot-accneww432`
- when that slot is excluded: switches to a verified codex slot (observed `codex-05`)
- provider-rejected/blocked slots are no longer treated as ready candidates

## Overnight Run Procedure (Exact)

Run from repository root.

```bash
cd /home/raed/projects/air-mentor-ui
nix develop
```

1. Refresh account usage + dashboard status:

```bash
bash audit-map/16-scripts/arctic-refresh-usage-report.sh
bash audit-map/16-scripts/arctic-slot-status.sh
```

2. Sanity-check route selection:

```bash
bash audit-map/16-scripts/select-execution-route.sh closure-readiness-pass
bash audit-map/16-scripts/select-execution-route.sh closure-readiness-pass --exclude-provider native-codex
```

3. Load overnight queue:

```bash
cp audit-map/31-queues/recommended-overnight.queue.sample audit-map/31-queues/pending.queue
```

4. Start telemetry refresher (detached):

```bash
bash audit-map/16-scripts/usage-refresh-orchestrator.sh
```

5. Start overnight queue orchestrator (detached):

```bash
bash audit-map/16-scripts/night-run-orchestrator.sh
```

6. Monitor while unattended (optional pre-sleep quick check):

```bash
bash audit-map/16-scripts/tmux-list-jobs.sh
bash audit-map/16-scripts/tmux-job-status.sh night-run-orchestrator overnight
bash audit-map/16-scripts/tmux-job-status.sh usage-refresh-orchestrator overnight
```

## Expected New Pass Order In Queue

1. `route-map-pass`
2. `role-surface-pass`
3. `feature-atom-pass`
4. `dependency-pass`
5. `data-flow-pass`
6. `state-flow-pass`
7. `ml-audit-pass`
8. `test-gap-pass`
9. `ux-friction-pass`
10. `truth-drift-reconciliation-pass`
11. `feature-intent-integrity-pass`
12. `cross-flow-recovery-pass`
13. `fault-tolerance-degradation-pass`
14. `memory-lifecycle-cleanup-pass`
15. `ux-consistency-cohesion-pass`
16. `live-behavior-pass`
17. `account-routing-pass`
18. `claim-verification-pass`
19. `unknown-omission-pass`
20. `residual-gap-closure-pass`
21. `closure-readiness-pass`
22. `cost-optimization-pass`
23. `prompt-self-improvement-pass`
24. `unattended-run-pass`
25. `audit-the-audit-pass`
26. `synthesis-pass`

## Recovery If A Pass Stops

```bash
cd /home/raed/projects/air-mentor-ui
nix develop
bash audit-map/16-scripts/tmux-list-jobs.sh
bash audit-map/16-scripts/tmux-job-status.sh <pass-name> <context>
bash audit-map/16-scripts/tmux-tail-job-log.sh <pass-name> <context>
bash audit-map/16-scripts/recover-from-failure.sh <pass-name> <context> resume
```

If status says `manual_action_required`, resolve that blocker first, then resume.

## Required Morning Verification

1. Confirm queue emptied:
   - `audit-map/31-queues/pending.queue`
2. Confirm Prompt 0 outputs exist and are current:
   - `artifacts/unified-closure-matrix.json`
   - `artifacts/global-gate-verdict.json`
   - `artifacts/truth-drift-ledger.json`
3. Confirm contradiction matrix and coverage ledger were updated:
   - `audit-map/14-reconciliation/contradiction-matrix.md`
   - `audit-map/23-coverage/coverage-ledger.md`
4. Confirm working memory updated:
   - `audit-map/24-agent-memory/working-knowledge.md`

## If You Must Run Without Arctic Automation

Fallback option (not preferred for overnight):
- run passes sequentially with `run-audit-pass.sh` under native route only
- no parallel auto-refresh or provider fallback
- higher risk of unattended stall

Use this only if Arctic route health is degraded and cannot be restored quickly.
