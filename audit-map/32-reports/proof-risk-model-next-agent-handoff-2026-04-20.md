# Proof Risk Model Next-Agent Handoff

Updated: `2026-04-20T05:31:17+05:30`

## Why This Exists

This document is for next AI agent taking over proof-risk-model investigation and monitoring.

Main needs:

1. preserve truth from current session
2. preserve user intent and product intent
3. preserve exact live process state
4. prevent duplicate work and stale-claim drift
5. make monitoring and next actions executable with minimal re-discovery

## User Intent

User intent, restated from current chat:

1. keep feature intent first, not leaderboard vanity
2. verify every important claim from code, tests, artifacts, and runnable evidence
3. improve model and metric framework in meaningful way
4. archive evidence so results are durable, not chat-only
5. use detached long runs so accidental editor close does not lose progress
6. keep researching strong 2024-2026 methods, but reject hype and weak transfer
7. continue monitoring active runs until completion

## Product Intent Anchor

System must provide trustworthy, actionable, explainable academic risk guidance for intervention decisions under:

1. drift
2. incomplete evidence
3. operational queue limits
4. governance / provenance constraints

Do not optimize one headline metric in isolation.

Primary optimization targets:

1. ranking quality where intervention triage needs it
2. probability quality where trust and explanation need it
3. intervention usefulness under queue constraints
4. robustness across stage and scenario-family shifts
5. reproducibility and provenance

## Big Facts Already Verified

### 1. `64` worlds still exist

This codebase still has `64` governed manifest worlds.

Important clarification:

1. `manifest-64` is still canonical governed corpus
2. `coverage-24` is only temporary wider evaluation profile
3. `coverage-24` does **not** replace `64`

Practical meaning:

1. `coverage-24` = broad sample for faster feedback
2. `manifest-64` = full governed corpus

## 2. Current `v6` model is real improvement over `v5-like`

Verified from smoke and wide runs:

1. current `v6` beats baseline `v5-like` on wide `coverage-24`
2. stage-aware feature conditioning was worthwhile, not cosmetic

Evidence:

- `air-mentor-api/src/lib/proof-risk-model.ts`
- `audit-map/17-artifacts/json/2026-04-19T232512Z--proof-risk-coverage-24--local--evaluation-report.json`

## 3. Offline challenger alone is not promotion-ready

Wide `coverage-24` result:

1. challenger improves some probability metrics
2. challenger loses too much ranking quality and recall
3. challenger remains too conservative to swap in directly

Evidence:

- `audit-map/17-artifacts/json/2026-04-19T232512Z--proof-risk-coverage-24--local--evaluation-report.json`

## 4. Hybrid router is most promising local next step so far

Offline evaluator-only `hybrid-router` was added.

Meaning:

1. validation-tuned stage/head router
2. route between current `v6` and challenger
3. current prod path untouched
4. no model promotion yet

Smoke result:

1. hybrid beat current on overall-course Brier, LogLoss, ROC-AUC, PR-AUC, and ECE at same time
2. strongest gains came from selective stage routing, not full challenger replacement

Evidence:

- `audit-map/17-artifacts/json/2026-04-19T231158Z--proof-risk-smoke-3-hybrid-router--local--evaluation-report.json`

## 5. Queue/evaluator integrity bug was real and fixed

Problem:

1. worker could steal evaluator-created `running` runs
2. this threatened reproducibility

Fix:

1. claim logic changed so worker only reclaims `running` rows with lease token

Evidence:

- `air-mentor-api/src/lib/proof-run-queue.ts`
- `air-mentor-api/tests/proof-run-queue.test.ts`

## 6. Detached-run safety now improved

New evaluator supports custom output paths.

Why:

1. long-running wide jobs should not have outputs overwritten by smoke reruns
2. concurrent experiments now safe

Evidence:

- `air-mentor-api/scripts/evaluate-proof-risk-model.ts`
- `air-mentor-api/tests/evaluate-proof-risk-model.test.ts`

## Current Live Run To Monitor

This is now the main live job:

- session: `airmentor-proof-risk-coverage-24-hybrid-20260419T233617Z`
- log: `output/detached/airmentor-proof-risk-coverage-24-hybrid-20260419T233617Z.log`
- isolated output dir: `air-mentor-api/output/proof-risk-model-runs/20260419T233617Z-coverage-24-hybrid`

Watcher:

- session: `airmentor-proof-risk-coverage-24-hybrid-archive-watcher-20260419T233617Z`
- log: `output/detached/airmentor-proof-risk-coverage-24-hybrid-archive-watcher-20260419T233617Z.log`

What watcher does:

1. waits for `wrote JSON report to` in main log
2. copies result to `audit-map/17-artifacts/json/...coverage-24-hybrid-router...`
3. copies markdown to `audit-map/17-artifacts/local/...coverage-24-hybrid-router...`

Do not kill these sessions unless user explicitly asks.

## Exact Monitoring Commands

Use these first.

### Check main log progress

```bash
tail -n 80 output/detached/airmentor-proof-risk-coverage-24-hybrid-20260419T233617Z.log
```

### Check if run finished

```bash
rg -n "wrote JSON report|wrote markdown report|exit=" \
  output/detached/airmentor-proof-risk-coverage-24-hybrid-20260419T233617Z.log \
  output/detached/airmentor-proof-risk-coverage-24-hybrid-archive-watcher-20260419T233617Z.log
```

### Check tmux sessions

```bash
tmux list-sessions | rg 'proof-risk'
```

### Check process still alive

```bash
ps -eo pid,ppid,stat,etime,%cpu,%mem,cmd | rg 'coverage-24-hybrid|tsx scripts/evaluate-proof-risk-model.ts'
```

### Find archived coverage-hybrid artifact after watcher finishes

```bash
find audit-map/17-artifacts -maxdepth 2 -type f \
  \( -name '*coverage-24-hybrid-router*' -o -name '*coverage-24*' \) | sort | tail -n 20
```

### Parse overall-course summary from archived artifact

```bash
node <<'NODE'
const fs = require('fs');
const p = 'audit-map/17-artifacts/json/REPLACE_ME.json';
const j = JSON.parse(fs.readFileSync(p,'utf8'));
console.log(JSON.stringify({
  generatedAt: j.generatedAt,
  seedProfile: j.seedProfile,
  overall: j.overallCourseVariantSummary,
  hybridPlan: j.hybridPlan ?? null,
}, null, 2));
NODE
```

## Important Archived Artifacts

### Current wide non-hybrid coverage baseline

- `audit-map/17-artifacts/json/2026-04-19T232512Z--proof-risk-coverage-24--local--evaluation-report.json`
- `audit-map/17-artifacts/local/2026-04-19T232512Z--proof-risk-coverage-24--local--evaluation-report.md`

Use this as wide baseline for comparison.

### Hybrid smoke result

- `audit-map/17-artifacts/json/2026-04-19T231158Z--proof-risk-smoke-3-hybrid-router--local--evaluation-report.json`
- `audit-map/17-artifacts/local/2026-04-19T231158Z--proof-risk-smoke-3-hybrid-router--local--evaluation-report.md`

Use this as proof-of-concept signal for hybrid router.

### Earlier smoke baseline/current/challenger comparison

- `audit-map/17-artifacts/json/2026-04-19T220545Z--proof-risk-smoke-3--local--evaluation-report.json`
- `audit-map/17-artifacts/local/2026-04-19T220545Z--proof-risk-smoke-3--local--evaluation-report.md`

## Code Changes Already In Workspace

Modified and not yet finalized/committed:

1. `air-mentor-api/scripts/evaluate-proof-risk-model.ts`
2. `air-mentor-api/tests/evaluate-proof-risk-model.test.ts`
3. `audit-map/32-reports/proof-risk-model-investigation-2026-04-20.md`

What changed in evaluator:

1. hybrid router added as evaluator-only variant
2. validation rows retained so routing can be learned without test leakage
3. custom output path support added
4. report shape extended for hybrid-ready runs

What changed in tests:

1. helper tests for hybrid routing logic
2. helper test for custom output-path isolation

Current targeted tests already passed after these changes:

```bash
cd air-mentor-api && npx vitest run \
  tests/evaluate-proof-risk-model.test.ts \
  tests/proof-risk-model.test.ts \
  tests/proof-run-queue.test.ts
```

## Best Findings So Far

### Wide `coverage-24` non-hybrid result

Overall-course:

1. current `v6`: `Brier 0.1361`, `LogLoss 0.4212`, `ROC-AUC 0.7886`, `PR-AUC 0.4860`, `ECE 0.0074`
2. baseline `v5-like`: `0.1369`, `0.4247`, `0.7846`, `0.4829`, `0.0063`
3. challenger: `0.1349`, `0.4312`, `0.7418`, `0.4879`, `0.0028`

Interpretation:

1. current `v6` > baseline
2. challenger gives better Brier/ECE
3. challenger gives much worse ROC-AUC
4. challenger does not justify direct replacement

### Smoke hybrid result

Overall-course:

1. current `v6`: `Brier 0.1214`, `LogLoss 0.3843`, `ROC-AUC 0.8056`, `PR-AUC 0.4631`, `ECE 0.0185`
2. hybrid-router: `0.1125`, `0.3612`, `0.8174`, `0.5633`, `0.0175`
3. challenger: `0.1142`, `0.3730`, `0.7712`, `0.5351`, `0.0154`

Interpretation:

1. hybrid-router dominated current on key overall-course metrics in smoke
2. hybrid-router preserved far more recall than pure challenger
3. hybrid-router is now strongest local candidate

## Smoke-Selected Routing Pattern

This is what smoke chose:

1. `attendanceRisk`: challenger at `pre-tt1`, `post-tt1`; current later
2. `ceRisk`: current all stages
3. `seeRisk`: mixed, but this head unstable and needs wider confirmation
4. `overallCourseRisk`: current early, challenger mid-late
5. `downstreamCarryoverRisk`: current all stages

Do **not** over-trust exact smoke routing until wide hybrid rerun confirms.

## Research Verdict From This Session

Best external next lane, after wide hybrid confirmation:

1. `CatBoost` or `XGBoost` per head
2. then stronger calibration: `Venn-Abers` or `Beta`
3. maybe later conformal gating for abstain / escalation / queue control

Do **not** jump first to:

1. deep tabular novelty
2. pure challenger replacement without routing
3. single-metric optimization

Useful sources already gathered:

1. `https://arxiv.org/abs/2506.16791`
2. `https://arxiv.org/abs/2407.04491`
3. `https://arxiv.org/abs/2407.02112`
4. `https://arxiv.org/abs/2601.19944`
5. `https://arxiv.org/abs/2502.05676`
6. `https://arxiv.org/abs/2407.10784`
7. `https://arxiv.org/abs/2404.15018`
8. `https://arxiv.org/abs/2401.11974`
9. `https://arxiv.org/abs/2409.14429`
10. `https://arxiv.org/abs/2501.18935`

Hard-nosed research conclusion:

1. first practical challenger should be strong GBDT, not flashy deep tabular
2. calibration must be stage-aware / temporal-aware
3. drift-sensitive eval design matters nearly as much as model family

## Risks / Things To Watch

### 1. Wide hybrid may fail to reproduce smoke gains

Possible reasons:

1. smoke overfit to tiny validation pattern
2. `seeRisk` routing unstable
3. some gains may collapse on wider scenario coverage

### 2. Pure probability improvements can hide recall damage

Always compare:

1. Brier / LogLoss / ECE
2. ROC-AUC / PR-AUC
3. threshold precision / recall
4. intervention queue burden / utility

### 3. Output confusion

There are now multiple output roots:

1. old default output: `air-mentor-api/output/proof-risk-model`
2. isolated experimental output roots under `air-mentor-api/output/proof-risk-model-runs/...`

Do not compare wrong artifact by accident.

## Next Steps For Next Agent

### If live hybrid wide rerun still running

1. monitor main log and watcher
2. wait for archive copy
3. do not launch another wide rerun in same slot

### Once live hybrid wide rerun finishes

1. locate archived `coverage-24-hybrid-router` JSON and MD
2. compare `current` vs `hybrid` vs `challenger` on:
   1. overall-course
   2. each head
   3. by-stage where useful
3. update `audit-map/32-reports/proof-risk-model-investigation-2026-04-20.md`
4. decide:
   1. if hybrid still wins broadly, keep advancing router lane
   2. if hybrid win is narrow or unstable, freeze router as research only and move to external GBDT challenger lane

### If hybrid wins on wide corpus

Recommended next implementation order:

1. add queue-budget / lead-capture evaluation metrics
2. rerun hybrid with those metrics
3. decide whether hybrid should remain evaluator-only or move toward promotable artifact form
4. only then start `CatBoost/XGBoost + Venn-Abers/Beta` lane

### If hybrid fails on wide corpus

Recommended next implementation order:

1. preserve failed result as evidence
2. write exact failure analysis by head and stage
3. start stronger external challenger lane
4. keep current `v6` as prod candidate meanwhile

## Short Executive Summary For Next Agent

Truth now:

1. current `v6` is real and better than `v5-like`
2. challenger alone is not good enough
3. hybrid-router is most promising local idea so far
4. smoke says hybrid-router materially better
5. wide non-hybrid run already finished and archived
6. wide hybrid rerun is now the critical blocking experiment

If time short:

1. monitor `coverage-24-hybrid`
2. parse archived result when done
3. compare `current` vs `hybrid`
4. update note
5. do not improvise new architecture before that

## Live Monitoring Snapshot (2026-04-20T05:31:17+05:30)

Status at snapshot time:

1. wide hybrid run still active
2. archive watcher still active
3. no `wrote JSON report to` or `wrote markdown report to` markers yet

## Final Wide Hybrid Outcome

This run later finished clean. Final archived artifacts:

1. `audit-map/17-artifacts/json/2026-04-20T001738Z--proof-risk-coverage-24-hybrid-router--local--evaluation-report.json`
2. `audit-map/17-artifacts/local/2026-04-20T001738Z--proof-risk-coverage-24-hybrid-router--local--evaluation-report.md`

Overall-course final comparison:

1. current `v6`: `Brier 0.1361`, `LogLoss 0.4211`, `ROC-AUC 0.7887`, `PR-AUC 0.4866`, `ECE 0.0065`, medium precision `0.4908`, medium recall `0.4291`
2. hybrid-router: `0.1336`, `0.4201`, `0.7846`, `0.5118`, `0.0100`, `0.5565`, `0.4204`
3. challenger: `0.1358`, `0.4333`, `0.7390`, `0.4844`, `0.0022`, `0.7014`, `0.1019`

Critical read:

1. hybrid helped probability quality and medium-threshold precision
2. hybrid hurt ROC-AUC and ECE on `overallCourseRisk`
3. hybrid clearly regressed `downstreamCarryoverRisk`
4. current `v6` remains safest promotable default
5. challenger alone still not strong enough

Per-head summary:

1. `attendanceRisk`: strong hybrid win, but calibration worse
2. `ceRisk`: strong rank/AP win, but calibration worse and intervention utility needs queue guards
3. `seeRisk`: modest win, calibration worse
4. `overallCourseRisk`: mixed; better Brier/log-loss/PR-AUC, worse ROC-AUC/ECE
5. `downstreamCarryoverRisk`: revert fully to current

Best next recommendation:

1. do **not** promote global hybrid
2. add evaluator queue-budget metrics first
3. narrow routing to allowlisted head+stage slices only
4. re-run `smoke-3` and `coverage-24`
5. then build offline `CatBoost` per-head challenger
6. then compare `Beta` vs `Venn-Abers` calibration on stage-aware temporal splits

Hard reject list:

1. global all-head hybrid promotion
2. challenger-only replacement
3. isotonic-by-default recalibration
4. row-level learned gating / MoE as next main bet
4. no archived `coverage-24-hybrid-router` artifact yet

Observed run progression:

1. main log advanced beyond earlier pause
2. latest confirmed stage lines:
  1. `[proof-eval] recompute finished after 1468.82s`
  2. `[proof-eval] loaded artifacts, checkpoints, and model diagnostics`

Liveness evidence:

1. tmux sessions present:
  1. `airmentor-proof-risk-coverage-24-hybrid-20260419T233617Z`
  2. `airmentor-proof-risk-coverage-24-hybrid-archive-watcher-20260419T233617Z`
2. evaluator process tree still alive; heavy child process active:
  1. PID `2383355` (`scripts/evaluate-proof-risk-model.ts`) in `Rl+`
  2. approx `%CPU 107`, elapsed `25m`, cpu-time `26m52s` at snapshot
3. watcher wrapper process alive and waiting for completion marker

File-clock evidence:

1. main log mtime: `2026-04-20 05:30:56.119303762 +0530`
2. watcher log mtime unchanged since start: `2026-04-20 05:06:37.798343325 +0530`

Immediate next action for next check:

1. rerun finish-marker probe first
2. when marker appears, verify archive copy landed in `audit-map/17-artifacts/json`
3. parse overall summary from archived JSON before any strategy conclusion
