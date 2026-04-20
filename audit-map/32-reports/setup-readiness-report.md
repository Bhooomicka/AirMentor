# Setup Readiness Report

Date: 2026-04-15

This is the durable completion report for the AirMentor audit operating system bootstrap.

Read `32-reports/phase-completion-matrix.md` for the blunt yes/no answer on what is truly complete versus only partially verified.

## Folder Tree Created

- exact generated tree: `32-reports/folder-tree.txt`
- root guide: `README.md`
- navigation index: `index.md`

## Exact Prompts Created

- manifest: `32-reports/prompts-created.txt`
- bootstrap prompt for the next main agent: `20-prompts/environment/main-analysis-agent-bootstrap.md`

## Exact Templates Created

- manifest: `32-reports/templates-created.txt`
- key forensic template: `20-prompts/templates/feature-template.md`

## Exact Scripts Created

- manifest: `32-reports/scripts-created.txt`
- tmux framework: `16-scripts/tmux-*.sh`
- account/provider wrappers: `16-scripts/arctic-*.sh`
- guarded compression wrappers: `16-scripts/caveman-*.sh`
- routing, budget, and escalation wrappers: `16-scripts/task-classify-route.sh`, `16-scripts/check-model-budget.sh`, `16-scripts/rotate-provider-or-stop.sh`
- unattended execution wrappers: `16-scripts/run-audit-pass.sh`, `16-scripts/night-run-orchestrator.sh`, `16-scripts/recover-from-failure.sh`

## Exact Runbooks Created

- manifest: `32-reports/runbooks-created.txt`
- local operation: `19-runbooks/local-analysis-runbook.md`
- live verification: `19-runbooks/live-verification-runbook.md`
- Arctic: `19-runbooks/arctic-integration-runbook.md`
- Caveman: `19-runbooks/caveman-integration-runbook.md`
- NixOS and VS Code: `19-runbooks/nixos-vscode-strategy.md`, `19-runbooks/nixos-dev-environment-strategy.md`

## Fully Ready For Local Analysis

- audit-map structure and governance
- durable memory and contradiction ledgers
- prompt system and templates
- Nix dev shell enhancements for `tmux`, `jq`, and `opencode`
- native Codex routing using locally verified models
- inventory, coverage, reconciliation, and final-map scaffolds

## Fully Ready For Live GitHub Pages And Railway Verification

- live-source documentation and runbooks exist
- baseline live artifacts were captured into `17-artifacts/live/`
- live-vs-local matrix and deployment drift log exist
- current known contradiction is already recorded: Railway `/health` returned `404` during bootstrap

## Fully Ready For Tmux-Detached Unattended Execution

- deterministic session naming
- detached launch wrappers
- status, checkpoint, and log files
- overnight queue orchestration
- restart, tail, status, and recovery scripts
- smoke-tested detached execution path

## Arctic Account, Provider, And Session Handling Status

Ready:

- Arctic CLI installed
- project-level `.arctic/arctic.json` added with the selected providers only
- slot-aware isolated account-store wrappers added
- Arctic docs, capability map, limits, and switching policies documented
- guarded wrapper scripts created
- manual-action stop path verified

Not yet complete:

- no Arctic slot has yet reached `execution_verification_state=verified`
- no real alternate-provider unattended failover has been verified yet
- the global Arctic store still shows `0 credentials`, which is acceptable because slot isolation is now the intended path

Current recommendation:

- keep Arctic in the stack for specialized account/provider continuity and future failover promotion
- use slot-aware Arctic login for repeated providers instead of the shared global store
- prefer native Codex for unattended execution until Arctic smoke verification returns stable output
- prefer OpenCode as the better documented fallback if Arctic proves too immature during real use

## Caveman Token-Saving Integration Status

Ready:

- Caveman skills installed globally
- safety policy, use-case limits, and guarded wrappers exist
- default-off posture is enforced by workflow
- per-job Caveman policy state is now recorded in job status/checkpoint files

Not yet complete:

- repo-local always-on hook integration is intentionally blocked until the existing repo-root `.codex` file is resolved
- deterministic auto-invocation of the Caveman skill inside every eligible `codex exec` run is not yet verified

## Cost-Aware Model Routing Status

Ready:

- exact local model availability is documented
- exact local reasoning-effort control is supported through Codex config overrides and the audit wrapper
- routing policy distinguishes `gpt-5.4` versus `gpt-5.4-mini`
- unavailable official tiers such as `GPT-5.4 nano` are explicitly marked unavailable locally
- budget warning, stop, and manual-switch scripts exist

## Manual Login Or Verification Still Required

- Arctic execution-smoke promotion if you want non-native unattended failover
- any live authentication flows that require user credentials
- optional decision on whether repo-local `.codex` may be replaced for Caveman auto-hooks

## What Cannot Yet Be Safely Automated

- first-time Arctic auth and any MFA or browser-mediated login
- provider entitlement discovery before using a newly authenticated slot for routing decisions
- any provider switch that has not been verified with a real session
- semantic validation of private live flows without credentials
- forced Caveman auto-hooking into repo-local Codex config while `.codex` remains a file
- exact spend-aware routing based on provider billing telemetry, because native Codex spend API is not wired into this audit OS

## Which Automations Are Automatic

- tmux job lifecycle management
- prompt bundling
- default model routing
- bounded provider-wait handling
- provider rotation cursor persistence for verified alternate slots
- checkpoint writing
- queue-driven overnight execution
- evidence directory conventions

## Which Automations Are Guarded Or Manual

- Arctic unattended execution promotion and first verified session continuation
- provider/account switching after usage exhaustion
- live credential entry
- delicate high-risk passes where Caveman must remain off

## Exact Next Prompt For The Main Codex Analysis Agent

- `20-prompts/environment/main-analysis-agent-bootstrap.md`

## Exact First Command Or Workflow To Run After Login Verification

```bash
cd /home/raed/projects/air-mentor-ui
nix develop
bash audit-map/16-scripts/run-audit-pass.sh route-map-pass --context bootstrap --model gpt-5.4-mini --reasoning-effort medium
```

## Exact Recommended Overnight Workflow

```bash
cd /home/raed/projects/air-mentor-ui
cp audit-map/31-queues/recommended-overnight.queue.sample audit-map/31-queues/pending.queue
nix develop
bash audit-map/16-scripts/night-run-orchestrator.sh
```

## Exact Recovery Workflow If A Run Stops Halfway

```bash
cd /home/raed/projects/air-mentor-ui
nix develop
bash audit-map/16-scripts/recover-from-failure.sh <pass-name> <context> resume
```

Inspect the paired files in `29-status/`, `30-checkpoints/`, and `22-logs/` before resuming.

## Exact Way To Inspect Progress Later

```bash
cd /home/raed/projects/air-mentor-ui
bash audit-map/16-scripts/tmux-list-jobs.sh
bash audit-map/16-scripts/tmux-job-status.sh <pass-name> <context>
bash audit-map/16-scripts/tmux-tail-job-log.sh <pass-name> <context>
```

High-signal report files:

- `32-reports/environment-verification-report.md`
- `32-reports/operator-next-steps.md`
- `23-coverage/coverage-ledger.md`
- `24-agent-memory/working-knowledge.md`
- `14-reconciliation/contradiction-matrix.md`
