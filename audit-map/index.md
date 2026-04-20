# Audit OS Index

## Start Here

1. `README.md`
2. `00-governance/mission.md`
3. `00-governance/future-agent-operating-manual.md`
4. `24-agent-memory/known-facts.md`
5. `14-reconciliation/contradiction-matrix.md`
6. `19-runbooks/local-analysis-runbook.md`
7. `19-runbooks/live-verification-runbook.md`
8. `20-prompts/environment/main-analysis-agent-bootstrap.md`
9. `32-reports/operator-next-steps.md`
10. `32-reports/phase-completion-matrix.md`
11. `32-reports/arctic-slot-login-playbook.md`

## Current Verified Environment Baseline

- Repo root: `/home/raed/projects/air-mentor-ui`
- Host OS: NixOS
- Frontend stack: Vite + React 19 + TypeScript
- Backend stack: Fastify + Drizzle + PostgreSQL + Vitest
- Nix dev shell present in `flake.nix`
- `tmux` verified installed: `tmux 3.6a`
- `codex` verified installed and logged in via ChatGPT
- Local Codex model cache verified on 2026-04-14:
  - `gpt-5.4`
  - `gpt-5.4-mini`
  - `gpt-5.3-codex`
  - `gpt-5.2`
- Arctic verified installed on 2026-04-14
- Arctic slot-isolation wrappers now exist for `codex`, `google`, and `github-copilot`
- Caveman skills verified installed globally under `~/.agents/skills/`
- OpenCode verified as an optional alternative workflow layer through Nix

## Current High-Signal Contradictions

- GitHub Pages is reachable at `https://raed2180416.github.io/AirMentor/`, but `https://api-production-ab72.up.railway.app/health` returned `404` during bootstrap validation.
- The user-required routing reference to `GPT-5.4 nano` is valid as an official name, but that model is not exposed in the local Codex cache used by this machine.
- Arctic docs describe one auth file location while the installed CLI reports another path; this is tracked in reconciliation.
- floating `nixpkgs#opencode` and the repo's pinned flake currently resolve to different OpenCode versions.

## Directory Guide

- `04-feature-atoms/`: atomic feature entries and bounded behavior clusters
- `05-dependencies/`: detailed dependency entries and hidden coupling chains
- `02-architecture/`: architecture placeholder folder; canonical outputs currently live in `15-final-maps/`
- `03-role-maps/`: role-map placeholder folder; canonical outputs currently live in `15-final-maps/`
- `06-data-flow/`: intended standalone data-flow corpus; currently incomplete
- `09-test-audit/`: test-audit placeholder folder; canonical outputs currently live in `23-coverage/`
- `00-governance/`: rules, policies, routing, escalation
- `01-inventory/`: path-by-path inventory scaffolds
- `10-live-behavior/`: deployed-system evidence and drift
- `16-scripts/`: deterministic automation wrappers
- `19-runbooks/`: human-readable operating procedures
- `20-prompts/`: reusable pass prompts and templates
- `21-automation/`: automation strategy and stop/resume policies
- `23-coverage/`: review coverage truth
- `24-agent-memory/`: durable memory, facts, ambiguities
- `29-status/`: current pass/job state
- `30-checkpoints/`: resumable pass checkpoints
- `32-reports/`: verification and synthesis outputs

## Structure Warning

- Empty directories inside `audit-map/` are not all equivalent.
- Some are deliberate artifact buckets with no captured images yet.
- Some are stale placeholder paths whose canonical evidence was consolidated elsewhere.
- `06-data-flow/` is the main exception: its emptiness reflects a real remaining audit gap.
- For the current directory-by-directory interpretation, read `32-reports/audit-map-structure-validation.md`.

## Current Operator Starting Point

- If Arctic authentication is not yet done, read `25-accounts-routing/manual-action-required.md`, then continue with native Codex until you are ready to authenticate Arctic.
- For the planned account map and slot names, read `25-accounts-routing/desired-provider-account-plan.md`.
- When you are ready to start the main forensic pass, use `20-prompts/environment/main-analysis-agent-bootstrap.md`.
- For the exact command sequence, overnight queue, and recovery flow, use `32-reports/operator-next-steps.md`.
