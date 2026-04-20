# Future Agent Operating Manual

## First Ten Minutes

1. Read `audit-map/index.md`.
2. Read `24-agent-memory/known-facts.md`.
3. Read `14-reconciliation/contradiction-matrix.md`.
4. Read `23-coverage/coverage-ledger.md`.
5. Inspect `29-status/` and `30-checkpoints/` for unfinished work.
6. Use `16-scripts/tmux-list-jobs.sh` before starting new long work.

## Working Rules

- Write durable notes into `24-agent-memory/working-knowledge.md` during each pass.
- Update `23-coverage/review-status-by-path.md` when a path changes audit state.
- Add contradictions immediately; do not defer them to the end.
- When using live evidence, store the artifact or snapshot path in the relevant note.

## Before Starting Unattended Work

- Route the task through `16-scripts/task-classify-route.sh`.
- Check model/budget posture with `16-scripts/check-model-budget.sh`.
- Start with `16-scripts/run-audit-pass.sh` or `16-scripts/tmux-start-job.sh`.

## Before Ending

- Ensure status and checkpoint files reflect the latest state.
- Add next-step instructions to `24-agent-memory/working-knowledge.md`.
- If blocked, write exact manual steps into `25-accounts-routing/manual-action-required.md`.
