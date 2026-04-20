# Local Analysis Runbook

## First Pass

1. Read `audit-map/index.md`.
2. Check detached jobs:
   - `bash audit-map/16-scripts/tmux-list-jobs.sh`
3. Refresh or inspect inventory scaffolds in `01-inventory/`.
4. Launch a pass through:
   - `bash audit-map/16-scripts/run-audit-pass.sh inventory-pass`

## Good Default Local Commands

- frontend tests: `npm test`
- backend tests: `npm --workspace air-mentor-api test`
- proof-risk eval: `npm run evaluate:proof-risk-model`
- local live-like stack: `npm run dev:live`

## Do Not Skip

- update `23-coverage/`
- update `24-agent-memory/`
- write evidence into `17-artifacts/` or `18-snapshots/`
