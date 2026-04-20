# Missing Artifact Repair Checklist (2026-04-18)

Purpose:
- Repair only artifacts that are proven missing right now.
- Use only pass ownership that is proven by existing prompt/log/report evidence.
- Use exact rerun commands that already exist in checked-in command files.

Execution scope in this document:
- No repair command was executed while writing this checklist.
- This document is only a deterministic runbook for follow-up execution.

## Proven Missing Items

### Item 1

- Missing artifact path:
  - `audit-map/17-artifacts/local/prompt-output-P12.json`
- Proven missing evidence:
  - Artifact folder listing currently contains `prompt-output-P11.json` but not `prompt-output-P12.json`.
- Proven references to this artifact:
  - `audit-map/14-reconciliation/contradiction-matrix.md` row `C-028` references `audit-map/17-artifacts/local/prompt-output-P12.json`.
  - `audit-map/20-prompts/adversarial-master-orchestrator-suite.md` lists `prompt-output-P12.json` as an expected prompt output.
- Proven owner pass mapping:
  - `audit-map/20-prompts/fault-tolerance-degradation-pass.md` declares `Related orchestrator prompt: P12`.
  - Owner pass: `fault-tolerance-degradation-pass`.
- Exact regeneration command (from existing command file):
  - `bash audit-map/31-queues/audit-air-mentor-ui-bootstrap-fault-tolerance-degradation-pass.command.sh`
- Done criteria (all must pass):
  1. `test -f audit-map/17-artifacts/local/prompt-output-P12.json`
  2. `jq -e '.findings | type == "array"' audit-map/17-artifacts/local/prompt-output-P12.json`
  3. `jq -e '([.findings[]?.prompt_id] | unique | index("P12")) != null' audit-map/17-artifacts/local/prompt-output-P12.json`
  4. `jq -e '.required_test_output | type == "object"' audit-map/17-artifacts/local/prompt-output-P12.json`

### Item 2

- Missing artifact path:
  - `audit-map/17-artifacts/local/2026-04-18T070237Z--cross-flow-recovery--local--test-evidence.md`
- Proven missing evidence:
  - The file is referenced inside `prompt-output-P11.json` but does not exist in the workspace.
- Proven references to this artifact:
  - `audit-map/17-artifacts/local/prompt-output-P11.json` includes this exact path in `.findings[].artifacts[]`.
- Proven owner pass mapping:
  - `audit-map/20-prompts/cross-flow-recovery-pass.md` declares `Related orchestrator prompt: P11`.
  - `audit-map/17-artifacts/local/prompt-output-P11.json` is the P11 output.
  - Owner pass: `cross-flow-recovery-pass`.
- Exact regeneration command (from existing command file):
  - `bash audit-map/31-queues/audit-air-mentor-ui-bootstrap-cross-flow-recovery-pass.command.sh`
- Done criteria (all must pass):
  1. `test -f audit-map/17-artifacts/local/prompt-output-P11.json`
  2. `jq -e '.findings | type == "array"' audit-map/17-artifacts/local/prompt-output-P11.json`
  3. `jq -e '([.findings[]?.prompt_id] | unique | index("P11")) != null' audit-map/17-artifacts/local/prompt-output-P11.json`
  4. `jq -r '.findings[]?.artifacts[]?' audit-map/17-artifacts/local/prompt-output-P11.json | while read -r p; do test -f "$p" || { echo "MISSING:$p"; exit 1; }; done`

## Post-Repair Validation Bundle

Run these after both item commands finish successfully:

1. `ls -l audit-map/17-artifacts/local | rg 'prompt-output-P11|prompt-output-P12'`
2. `rg -n 'prompt-output-P11.json|prompt-output-P12.json' audit-map/14-reconciliation/contradiction-matrix.md`
3. `jq -e '.findings | type == "array"' audit-map/17-artifacts/local/prompt-output-P11.json`
4. `jq -e '.findings | type == "array"' audit-map/17-artifacts/local/prompt-output-P12.json`

## Non-Hallucination Boundary

This checklist intentionally does not claim:
- which specific agent message wrote `C-028`,
- whether rerun output paths will keep the same timestamped filename,
- that either pass will preserve identical artifact names after rerun.

It only claims what is currently proven by on-disk files and pass prompts.
