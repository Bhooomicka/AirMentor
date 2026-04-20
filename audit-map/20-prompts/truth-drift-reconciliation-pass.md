# Truth Drift Reconciliation Pass

Version: `v1.0`
Date: `2026-04-18`
Related orchestrator prompt: `P9`

## Objective

Detect and close truth drift across contradiction, coverage, status/checkpoint, and report artifacts.
Treat every claim as false until verified by current evidence.

## Read First

1. `audit-map/20-prompts/adversarial-master-orchestrator-suite.md`
2. `audit-map/14-reconciliation/contradiction-matrix.md`
3. `audit-map/23-coverage/coverage-ledger.md`
4. `audit-map/24-agent-memory/known-facts.md`
5. `audit-map/24-agent-memory/working-knowledge.md`
6. `audit-map/29-status/`
7. `audit-map/30-checkpoints/`
8. `audit-map/32-reports/`

## Mandatory Evidence Targets

- `audit-map/14-reconciliation/contradiction-matrix.md`
- `audit-map/23-coverage/coverage-ledger.md`
- `audit-map/24-agent-memory/known-facts.md`
- `audit-map/24-agent-memory/working-knowledge.md`
- `audit-map/20-prompts/prompt-index.md`
- `audit-map/20-prompts/prompt-version-history.md`
- `audit-map/20-prompts/prompt-change-log.md`
- `audit-map/16-scripts/tmux-list-jobs.sh`
- `audit-map/16-scripts/tmux-job-status.sh`
- `audit-map/16-scripts/tmux-tail-job-log.sh`

## Mandatory Checks

- `P9-C01`: Every open contradiction has expected, implemented, tested/live evidence references.
- `P9-C02`: Contradiction status labels match newest artifacts.
- `P9-C03`: Status/checkpoint/log precedence resolves conflicts deterministically.
- `P9-C04`: Completion claims map to required artifact sets.
- `P9-C05`: Coverage ledger entries map to real files and current scope.
- `P9-C06`: Known-facts append-only integrity is preserved.
- `P9-C07`: Prompt index/version/changelog coherence is maintained.
- `P9-C08`: Drift type classification is assigned for each high/critical mismatch.
- `P9-C09`: Unresolved drift has deterministic resume instructions.

## Race And Edge Scripts

- `P9-R01`: Status restamp during tmux session transition.
- `P9-R02`: Queue mutation during orchestrator queue read.
- `P9-R03`: Concurrent contradiction and coverage updates.
- `P9-R04`: Stale report claim after newer artifact generation.

## Required Output Contract

Use the shared required finding schema and mandatory schema blocks from:
- `audit-map/20-prompts/adversarial-master-orchestrator-suite.md`

Also emit required test output for every high/critical finding.
Each high/critical finding must include:
1. One artifact-coherence contract test.
2. One status/checkpoint/log precedence test.

## Required Durable Updates

- Update `audit-map/14-reconciliation/contradiction-matrix.md` for drift findings.
- Update `audit-map/23-coverage/coverage-ledger.md` if coverage claims change.
- Update `audit-map/24-agent-memory/working-knowledge.md` with current drift outcomes.
- Write artifacts under `audit-map/17-artifacts/local/` and `audit-map/18-snapshots/repo/`.

## Hard Pass/Fail Gates

- Fail if any high/critical truth drift remains open.
- Fail if any closed drift finding has unresolved drift state.
- Fail if any high/critical finding lacks required test output.
- Pass only when contradiction, coverage, and status/checkpoint/log truth is coherent.
