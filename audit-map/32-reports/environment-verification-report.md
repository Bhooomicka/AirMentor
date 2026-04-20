# Environment Verification Report

Date: 2026-04-15

## Verified

- `audit-map/` structure exists
- governance, prompts, templates, runbooks, and inventory/final-map scaffolds exist
- operator handoff docs and generated manifests exist in `32-reports/`
- required tmux scripts exist and passed `bash -n`
- required Arctic and Caveman scripts exist and passed `bash -n`
- Arctic slot-isolation wrappers exist and passed `bash -n`
- detached tmux smoke run completed successfully
- stale running-status reconciliation has been added for detached jobs
- overnight queue items are no longer dropped before launch succeeds
- overnight queue waiting now reconciles tmux liveness and stops on missing or stale status instead of hanging forever
- Arctic guarded-stop path works and records manual action instead of bluffing
- live Pages and Railway baseline artifacts were captured
- Nix dev shell now includes `jq`, `tmux`, and `opencode`
- all requested Arctic slots are authenticated and model-visible
- native Codex remains the only execution-ready unattended path
- Arctic execution smoke is still guarded because the current wrapper captures blank output rather than a stable success marker

## Verified Artifacts

- `17-artifacts/live/2026-04-15T221302Z--pages-root--live--headers--bootstrap.txt`
- `17-artifacts/live/2026-04-15T221302Z--pages-root--live--html-shell--bootstrap.html`
- `17-artifacts/live/2026-04-15T221301Z--railway-health--live--headers--bootstrap.txt`
- `17-artifacts/live/2026-04-15T221301Z--railway-health--live--body--bootstrap.txt`
- `18-snapshots/env/2026-04-15-codex-models.txt`
- `18-snapshots/env/2026-04-15-tooling-baseline.txt`
- `18-snapshots/accounts/2026-04-15-arctic-auth-list.txt`
- `18-snapshots/accounts/2026-04-15-arctic-stats.json`
- `18-snapshots/env/2026-04-15-opencode-baseline.txt`
- `32-reports/setup-readiness-report.md`
- `32-reports/operator-next-steps.md`

## Manual Actions Still Required

- if you want Arctic promoted into unattended execution, continue execution-smoke verification until at least one slot reaches `execution_verification_state=verified`
- provide or verify live credentials before auth-required live flow runs
- decide whether repo-local `.codex` should remain a file or be replaced for Caveman auto-hooks

## Safe Fallbacks

- use native Codex without Arctic promotion until Arctic execution verification is complete
- use optional OpenCode through Nix if Arctic proves insufficient for multi-provider workflow
- keep Caveman off for high-risk tasks and use it only through guarded wrappers
