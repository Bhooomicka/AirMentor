# Operator Next Steps

Date: 2026-04-15

## Update 2026-04-18

Use this as the current overnight execution handoff:

- `audit-map/32-reports/overnight-net-agent-handoff-2026-04-18.md`

This handoff includes:

- Prompt 0-14 expansion details and new deep-integrity passes
- truth-drift hard-gate requirements
- current account route health and autoswitch expectations
- exact overnight launch and recovery commands

## Current State

- the audit operating system is built and verified locally
- detached tmux execution, checkpointing, logging, queueing, and routing wrappers are ready
- native Codex is ready immediately
- Arctic is installed, project-scoped, slot-aware, and authenticated across the requested slots
- Caveman is installed globally but remains guarded and off by default
- OpenCode is documented as the fallback if Arctic proves too immature for your real workflow
- the earlier `inventory-pass` finished successfully and seeded the inventory, coverage, and memory files
- the detached overnight orchestrator now keeps queue entries until launch succeeds and reconciles tmux liveness before waiting
- all six Arctic `codex-*` slots are authenticated and model-visible with preferred model `gpt-5.4`
- both Arctic GitHub Copilot slots are authenticated and model-visible with preferred model `gpt-5.4`
- the Arctic Google slot is authenticated and model-visible with preferred model `gemini-3.1-pro-preview`
- current provider/model truth is in `25-accounts-routing/current-model-availability.md`
- current Arctic execution posture is promoted on pinned fallback models: all six Arctic Codex slots are execution-verified on `gpt-5.3-codex`, `google-main` is verified on `gemini-3.1-pro-preview`, and both Copilot slots are verified on the Gemini route
- account/provider cycling is enabled only for execution-verified alternate slots; today that means native Codex plus `google-main` plus the verified Copilot runtime path
- prompt suite `v2.0` is now active for the core forensic passes
- earlier v1 route, role, and feature outputs are explicitly treated as scaffold-level and are being rerun under the hardened prompt stack
- the prior overnight queue is no longer the source of truth; use `32-reports/current-run-status.md` for the repaired restart point

## When You Need To Revisit Arctic

You do not need Arctic login to start the main local forensic passes.

You do need Arctic login before any workflow that depends on:

- account or provider switching through Arctic
- Arctic session continuity as the primary resume path
- Arctic-backed model/provider comparison runs

Login is no longer the remaining task. The remaining Arctic work is:

- separate execution proof for higher visible tiers such as Arctic Codex `gpt-5.4` / `gpt-5.4-mini` and Copilot `gpt-5.4`
- optional wrapper hardening if you want additional provider-specific run modes beyond the current verified Google alternate
- verification of provider-specific reasoning/thinking controls if you want alternate routes to approximate native `xhigh` work more closely

Useful current checks:

```bash
cd /home/raed/projects/air-mentor-ui
bash audit-map/16-scripts/arctic-slot-status.sh
bash audit-map/16-scripts/arctic-reconcile-slot-metadata.sh
sed -n '1,260p' audit-map/25-accounts-routing/current-model-availability.md
```

Current detached run state is summarized in:

- `32-reports/current-run-status.md`

## Exact First Command If You Need To Relaunch The Deep Rerun

The inventory baseline already exists, and the prompt suite has been hardened. If you need to relaunch the deep rerun manually after the repaired controller changes, restart at the first failed deep pass:

```bash
cd /home/raed/projects/air-mentor-ui
nix develop --command bash audit-map/16-scripts/run-audit-pass.sh role-surface-pass --context bootstrap --model gpt-5.4-mini --reasoning-effort xhigh
```

This writes its prompt bundle, status file, checkpoint file, queue artifact, and tmux wrapper script automatically.

## Exact Reasoning Control

Codex on this machine supports reasoning control through config overrides, and the audit wrapper now exposes that as `--reasoning-effort`.

Verified local reasoning levels for `gpt-5.4` and `gpt-5.4-mini`:

- `low`
- `medium`
- `high`
- `xhigh`

Examples:

```bash
cd /home/raed/projects/air-mentor-ui
nix develop
bash audit-map/16-scripts/run-audit-pass.sh inventory-pass --context bootstrap --model gpt-5.4-mini --reasoning-effort medium
```

```bash
cd /home/raed/projects/air-mentor-ui
nix develop
bash audit-map/16-scripts/run-audit-pass.sh dependency-pass --context bootstrap --model gpt-5.4-mini --reasoning-effort high
```

```bash
cd /home/raed/projects/air-mentor-ui
nix develop
bash audit-map/16-scripts/run-audit-pass.sh live-behavior-pass --context live --model gpt-5.4 --reasoning-effort xhigh
```

If you run native Codex directly instead of the wrapper, the reasoning override form is:

```bash
codex exec -C /home/raed/projects/air-mentor-ui -m gpt-5.4 -c 'model_reasoning_effort="xhigh"' --full-auto - < audit-map/20-prompts/environment/main-analysis-agent-bootstrap.md
```

## Exact Prompt For The Main Analysis Agent

Use this file as the next-agent prompt source:

- `audit-map/20-prompts/environment/main-analysis-agent-bootstrap.md`

If you want to launch it manually through native Codex outside the wrapper, use:

```bash
cd /home/raed/projects/air-mentor-ui
nix develop
codex exec -C /home/raed/projects/air-mentor-ui -m gpt-5.4-mini --full-auto - < audit-map/20-prompts/environment/main-analysis-agent-bootstrap.md
```

Use the wrapper path for real work so tmux, status, checkpoints, and logs stay standardized.

## Recommended Overnight Workflow

Prepare the queue:

```bash
cd /home/raed/projects/air-mentor-ui
cp audit-map/31-queues/recommended-overnight.queue.sample audit-map/31-queues/pending.queue
```

Review or edit the queue if you want a different order, then launch:

```bash
cd /home/raed/projects/air-mentor-ui
nix develop
bash audit-map/16-scripts/night-run-orchestrator.sh
```

Recommended canonical overnight order:

1. `role-surface-pass`
2. `feature-atom-pass`
3. `dependency-pass`
4. `data-flow-pass`
5. `state-flow-pass`
6. `ml-audit-pass`
7. `test-gap-pass`
8. `ux-friction-pass`
9. `live-behavior-pass`
10. `account-routing-pass`
11. `cost-optimization-pass`
12. `prompt-self-improvement-pass`
13. `unattended-run-pass`
14. `audit-the-audit-pass`
15. `synthesis-pass`

Use the queue sample as a staged baseline, not as proof of completeness by itself.

The live queue already in progress is recorded in:

- `32-reports/current-run-status.md`

## Recovery Workflow If A Run Stops Halfway

1. inspect the last status file in `audit-map/29-status/`
2. inspect the paired checkpoint in `audit-map/30-checkpoints/`
3. inspect the log in `audit-map/22-logs/`
4. if the pass is resumable, run:

```bash
cd /home/raed/projects/air-mentor-ui
nix develop
bash audit-map/16-scripts/recover-from-failure.sh inventory-pass bootstrap resume
```

Replace `inventory-pass bootstrap` with the actual pass and context. If the stop reason was manual action required, complete that action first and then run the same command.

## How To Inspect Progress Later

Use these commands:

```bash
cd /home/raed/projects/air-mentor-ui
bash audit-map/16-scripts/tmux-list-jobs.sh
bash audit-map/16-scripts/tmux-job-status.sh inventory-pass bootstrap
bash audit-map/16-scripts/tmux-tail-job-log.sh inventory-pass bootstrap
```

Also inspect:

- `audit-map/23-coverage/coverage-ledger.md`
- `audit-map/24-agent-memory/working-knowledge.md`
- `audit-map/14-reconciliation/contradiction-matrix.md`
- `audit-map/32-reports/environment-verification-report.md`
- `audit-map/25-accounts-routing/current-model-availability.md`
- `audit-map/32-reports/current-run-status.md`

## Automatic Versus Guarded

Automatic now:

- tmux job launch, stop, restart, resume, status, and log capture
- prompt bundling and model-routing defaults
- queue-driven overnight orchestration
- checkpoint and status file creation
- live artifact storage conventions
- stale tmux-status reconciliation when a session disappears unexpectedly

Guarded or manual:

- Arctic Codex promotion above the pinned `gpt-5.3-codex` runtime until higher visible tiers are separately execution-verified
- Arctic GitHub Copilot unattended execution promotion until a visible model is proven runtime-supported
- live flows that require real credentials
- Caveman always-on repo-local hooks because repo-root `.codex` is currently a file, not a directory
- any provider switch path that has not yet been verified with a real authenticated session
- deterministic auto-application of the Caveman skill itself
