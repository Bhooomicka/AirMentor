# AirMentor Audit OS

This directory is the audit operating system for a near-lossless forensic analysis of the AirMentor codebase and deployed stack.

It is designed to make long-running analysis deterministic, resumable, evidence-backed, and cost-aware. The later analysis agent should treat this directory as the authoritative control plane for audit workflow, not as optional notes.

## Purpose

- Force durable externalized memory instead of chat-only reasoning.
- Separate local-code evidence from live-deployment evidence.
- Route tasks to the strongest safe model available on this machine.
- Keep long-running work alive in detached `tmux` sessions.
- Preserve contradictions, assumptions, checkpoints, and manual stop conditions.

## Authoritative Files

Read these first, in order:

1. `index.md`
2. `00-governance/mission.md`
3. `00-governance/future-agent-operating-manual.md`
4. `00-governance/analysis-rules.md`
5. `00-governance/model-routing-policy.md`
6. `24-agent-memory/known-facts.md`
7. `14-reconciliation/contradiction-matrix.md`
8. `23-coverage/coverage-ledger.md`
9. `19-runbooks/local-analysis-runbook.md`
10. `19-runbooks/live-verification-runbook.md`
11. `20-prompts/environment/main-analysis-agent-bootstrap.md`
12. `32-reports/operator-next-steps.md`
13. `32-reports/phase-completion-matrix.md`

The pre-existing `/audit` directory remains valuable evidence, but `/audit-map` is the operating layer that future agents must update while they work.

## Update Rules

- Every meaningful finding goes into a file in this tree before the agent ends a pass.
- Every major assumption belongs in `24-agent-memory/known-ambiguities.md` or `00-governance/decision-log.md`.
- Every contradiction belongs in `14-reconciliation/contradiction-matrix.md`.
- Every pass must update `23-coverage/coverage-ledger.md` and `24-agent-memory/working-knowledge.md`.
- Every unattended run must write a status file, checkpoint file, and log file.
- Never overwrite evidence artifacts in place when versioned snapshots matter; add a dated artifact or snapshot instead.

## Resumability Model

- Long-running passes run in detached `tmux` only.
- Session status lives in `29-status/`.
- Checkpoints live in `30-checkpoints/`.
- Durable memory lives in `24-agent-memory/`.
- Queue state lives in `31-queues/`.
- Generated evidence lives in `17-artifacts/` and `18-snapshots/`.

If the terminal closes, the next agent should recover state from those folders, not from chat history.

## Live vs Local Evidence Model

- Local implementation evidence belongs in `17-artifacts/local/`, `18-snapshots/repo/`, and inventory/architecture maps.
- Live deployment evidence belongs in `17-artifacts/live/`, `18-snapshots/live/`, and `10-live-behavior/`.
- Mismatches belong in `10-live-behavior/deployment-drift-log.md` and `14-reconciliation/`.
- Passing local tests never overrides contradictory live evidence.

## Cost and Routing Model

- `GPT-5.4` is the default high-stakes synthesis model on this machine.
- `GPT-5.4 mini` is the default structured pass model on this machine.
- `GPT-5.4 nano` is an official product name but is not currently exposed in the local Codex model cache; routing falls back to `gpt-5.4-mini` plus shell automation.
- Arctic and Caveman are optional accelerators under policy, never truth sources.
- Arctic multi-account handling on this machine uses isolated slots, not the shared global auth store.

See `00-governance/model-routing-policy.md` and `21-automation/model-provider-routing-controller.md`.

## What Complete Enough Means

Per pass, "complete enough" means all of the following are true:

- The inspected surface is named and bounded.
- Source files and runtime entry points are listed.
- Expected behavior, implemented behavior, tested behavior, and live behavior are each recorded separately.
- Known unknowns and contradictions are explicit.
- Coverage status is updated.
- A future agent can continue without rereading the same raw code just to recover context.
