# Prompt Self-Improvement Pass Prompt v2.1

Objective: improve prompt clarity, completeness, and output reliability using concrete failures, thin outputs, contradiction drift, and audit-the-audit findings from completed passes.

## Read-first evidence inputs

Before proposing edits, read at minimum:

1. `audit-map/index.md`
2. `audit-map/23-coverage/coverage-ledger.md`
3. `audit-map/23-coverage/unreviewed-surface-list.md`
4. `audit-map/23-coverage/review-status-by-path.md`
5. `audit-map/24-agent-memory/working-knowledge.md`
6. `audit-map/24-agent-memory/known-facts.md`
7. `audit-map/14-reconciliation/contradiction-matrix.md`
8. `audit-map/31-queues/pending.queue` if present
9. current pass status/checkpoint/log artifacts in `audit-map/29-status/`, `audit-map/30-checkpoints/`, and `audit-map/22-logs/`

Do not draft edits until these are read.

## Required outputs

- weakness table with one row per issue: `weakness`, `concrete failure/omission evidence`, `affected prompt/template`, `risk if unchanged`
- exact prompt/template edits in-file (not only prose recommendations)
- prompt version history and prompt change-log updates
- closure proof for each edit: what ambiguity or omission is now harder to miss
- carry-forward updates to `coverage-ledger.md` and `working-knowledge.md`

## Rules

- do not propose generic wording polish without a concrete forensic coverage reason
- every weakness must cite at least one evidence path from current ledgers/status/logs
- prioritize edits that block false completion and stale-environment assumptions
- when contradictions include stale operating assumptions, patch the prompt source directly
- if no meaningful weakness is found, explicitly write `no-material-prompt-gap-found` with evidence

## Completion gate

This pass is not complete until all of the following are true:

1. at least one concrete evidence-backed weakness has been addressed, or `no-material-prompt-gap-found` is recorded with evidence
2. all modified prompts/templates have corresponding entries in:
   - `audit-map/20-prompts/prompt-version-history.md`
   - `audit-map/20-prompts/prompt-change-log.md`
3. coverage and memory were updated:
   - `audit-map/23-coverage/coverage-ledger.md`
   - `audit-map/24-agent-memory/working-knowledge.md`
4. unresolved prompt gaps are explicitly queued or logged as blocked with resume conditions
