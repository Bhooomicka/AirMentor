# Proof Risk Model Investigation — 2026-04-20

## Purpose

Durable evidence log for local proof-risk-model investigation on 2026-04-20.

Goals:

1. Preserve current improved `v6` evaluation artifact before later reruns overwrite it.
2. Restore durable baseline-vs-improved evidence.
3. Expand governed evaluation coverage before stronger challenger comparison.
4. Compare stronger offline challenger against current production `v6` on ranking, calibration, and intervention utility signals.

## Archived Current Improved Artifact

Source artifact at archive time:

- `air-mentor-api/output/proof-risk-model/evaluation-report.json`
- `air-mentor-api/output/proof-risk-model/evaluation-report.md`

Archived copies:

- `audit-map/17-artifacts/json/2026-04-20T211458Z--proof-risk-v6-expanded-metrics--local--evaluation-report.json`
- `audit-map/17-artifacts/local/2026-04-20T211458Z--proof-risk-v6-expanded-metrics--local--evaluation-report.md`

Artifact provenance observed in archived JSON:

- generatedAt: `2026-04-19T21:14:58.954Z`
- production artifact version: `observable-risk-logit-v6`
- calibration version: `post-hoc-calibration-v2`
- requested seeds: `101, 4141, 5353`

## Known Local Fixes Already Verified Before Archive

1. Evaluator integrity hardening present in `air-mentor-api/scripts/evaluate-proof-risk-model.ts`.
2. Runtime dedupe present in `air-mentor-api/src/lib/proof-control-plane-runtime-service.ts`.
3. Playback reset checkpoint scoping present in `air-mentor-api/src/lib/proof-control-plane-playback-reset-service.ts`.
4. Queue worker race fixed locally in `air-mentor-api/src/lib/proof-run-queue.ts` so worker no longer steals direct evaluator-created runs.
5. Production model upgraded locally to stage-aware `v6` in `air-mentor-api/src/lib/proof-risk-model.ts`.

## Archived v6 Headline Metrics From Current Artifact

These values came from archived improved JSON at time of preservation.

| Head | Brier | Log Loss | ROC-AUC | PR-AUC | ECE |
| --- | ---: | ---: | ---: | ---: | ---: |
| attendanceRisk | 0.0367 | 0.1379 | 0.9427 | 0.6806 | 0.0410 |
| ceRisk | 0.0480 | 0.1783 | 0.8585 | 0.3407 | 0.0172 |
| seeRisk | 0.1778 | 0.5393 | 0.7250 | 0.4661 | 0.0523 |
| overallCourseRisk | 0.1677 | 0.5088 | 0.7635 | 0.5388 | 0.0408 |
| downstreamCarryoverRisk | 0.0894 | 0.2655 | 0.9512 | 0.8942 | 0.0608 |

## Durable Baseline Vs Current Vs Challenger Evidence

Reproducible baseline-vs-current evidence is now durable in the archived smoke artifact:

- `audit-map/17-artifacts/json/2026-04-19T220545Z--proof-risk-smoke-3--local--evaluation-report.json`
- `audit-map/17-artifacts/local/2026-04-19T220545Z--proof-risk-smoke-3--local--evaluation-report.md`

This artifact is important because it contains all four scorers in one frozen report:

1. current production-style local retrain: `observable-risk-logit-v6`
2. baseline ablation: `observable-risk-logit-v5-like`
3. stronger offline challenger: `observable-risk-depth2-tree-v6`
4. legacy heuristic comparator

Smoke artifact overall-course summary:

| Variant | Brier | Log Loss | ROC-AUC | PR-AUC | ECE | Medium Precision | Medium Recall |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| current v6 | 0.1215 | 0.3843 | 0.8049 | 0.4637 | 0.0183 | 0.5153 | 0.3040 |
| baseline v5-like | 0.1222 | 0.3880 | 0.8001 | 0.4599 | 0.0177 | 0.5153 | 0.3214 |
| offline challenger | 0.1141 | 0.3730 | 0.7678 | 0.5400 | 0.0154 | 0.9955 | 0.1651 |
| heuristic | 0.2157 | 0.6401 | 0.7613 | 0.4351 | 0.2734 | 0.2824 | 0.8578 |

Critical read of smoke artifact:

1. `v6` beats `v5-like` modestly on ranking and Brier. This supports stage-awareness as a real, not cosmetic, improvement.
2. offline challenger beats `v6` on Brier, log loss, PR-AUC, and ECE, but loses on ROC-AUC and recall at the medium threshold.
3. Because feature intent prioritizes actionable intervention support, challenger is not an automatic promotion winner. It looks more conservative and more precise, but it misses more risky cases.

## Coverage Profile Design

The evaluator profile `coverage-24` was chosen to widen corpus breadth without jumping straight to the full `manifest-64` cost.

Important: this does **not** replace the codebase manifest. The governed corpus definition is still `64` manifest worlds in `PROOF_CORPUS_MANIFEST`. `coverage-24` is only a temporary evaluation profile layered on top of that manifest.

Profile shape:

1. 8 train seeds
2. 8 validation seeds
3. 8 test seeds
4. all 8 scenario families represented in each split

Family coverage by split:

- train: `101 balanced`, `202 weak-foundation`, `303 low-attendance`, `404 high-forgetting`, `505 coursework-inflation`, `606 exam-fragility`, `707 carryover-heavy`, `808 intervention-resistant`
- validation: `4141 balanced`, `4242 weak-foundation`, `4343 low-attendance`, `4444 high-forgetting`, `4545 coursework-inflation`, `4646 exam-fragility`, `4747 carryover-heavy`, `4848 intervention-resistant`
- test: `5757 balanced`, `5858 weak-foundation`, `5959 low-attendance`, `6060 high-forgetting`, `6161 coursework-inflation`, `6262 exam-fragility`, `6363 carryover-heavy`, `6464 intervention-resistant`

This widened profile became necessary after direct code inspection found a stale evaluator-labeling bug: manifest scenario labels and generated scenario family could diverge for the same seed. Local code now rejects scenario-mismatch governed runs before evaluation.

## Next Evidence To Add

Pending in this same investigation:

1. Expanded governed evaluation coverage artifact from detached `coverage-24`.
2. Wider baseline vs current vs challenger comparison table from that artifact.
3. Final recommendation on whether challenger should remain offline only.

## Detached Run Ledger

Successful smoke rerun on current code:

- command profile: `smoke-3`
- detached log: `output/detached/airmentor-proof-risk-smoke-3-20260419T220003Z.log`
- archived artifacts:
  - `audit-map/17-artifacts/json/2026-04-19T220545Z--proof-risk-smoke-3--local--evaluation-report.json`
  - `audit-map/17-artifacts/local/2026-04-19T220545Z--proof-risk-smoke-3--local--evaluation-report.md`

Expanded coverage rerun in progress at note update time:

- command profile: `coverage-24`
- detached log: `output/detached/airmentor-proof-risk-coverage-24-20260419T220606Z.log`
- auto-archive watcher log: `output/detached/airmentor-proof-risk-coverage-24-archive-watcher-20260419T222910Z.log`

That original `coverage-24` rerun later finished clean and archived here:

- `audit-map/17-artifacts/json/2026-04-19T232512Z--proof-risk-coverage-24--local--evaluation-report.json`
- `audit-map/17-artifacts/local/2026-04-19T232512Z--proof-risk-coverage-24--local--evaluation-report.md`

Wide `coverage-24` conclusion from archived artifact:

1. current `v6` still beats `v5-like`
2. offline challenger still improves some probability metrics but remains too weak on ranking and recall to promote directly
3. this preserved the case for a stage/head router rather than a direct challenger replacement

## Current In-Flight Change Set

Evaluator now has new offline-only comparison lane under development:

1. validation-tuned `hybrid-router` between current `v6` and offline challenger
2. hard routing first, not soft blending first
3. routing learned on validation worlds only, then frozen on test worlds
4. current production artifact path remains untouched

Supporting evaluator infra also added:

1. custom output path support via `AIRMENTOR_EVAL_OUTPUT_DIR` and `AIRMENTOR_EVAL_OUTPUT_STEM`
2. this prevents future smoke reruns from overwriting long-running `coverage-24` outputs

Targeted tests currently passing after these changes:

- `air-mentor-api/tests/evaluate-proof-risk-model.test.ts`
- `air-mentor-api/tests/proof-risk-model.test.ts`
- `air-mentor-api/tests/proof-run-queue.test.ts`

Hybrid smoke rerun launched in detached mode:

- command profile: `smoke-3`
- detached session: `airmentor-proof-risk-smoke-3-hybrid-20260419T230224Z`
- detached log: `output/detached/airmentor-proof-risk-smoke-3-hybrid-20260419T230224Z.log`
- isolated output dir: `air-mentor-api/output/proof-risk-model-runs/20260419T230224Z-smoke-3-hybrid`

Critical reason for hybrid-router experiment:

1. saved smoke artifact shows no single scorer wins across all heads and stages
2. current `v6` remains stronger in several early-warning slices
3. offline challenger often wins later on probability quality
4. feature intent favors trustworthy stage-aware intervention guidance, so stage/head routing is lower-risk than immediate architecture replacement

## Hybrid Smoke Result

Hybrid smoke artifact archived:

- `audit-map/17-artifacts/json/2026-04-19T231158Z--proof-risk-smoke-3-hybrid-router--local--evaluation-report.json`
- `audit-map/17-artifacts/local/2026-04-19T231158Z--proof-risk-smoke-3-hybrid-router--local--evaluation-report.md`

Overall-course outcome on `smoke-3`:

| Variant | Brier | Log Loss | ROC-AUC | PR-AUC | ECE | Medium Precision | Medium Recall |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| current v6 | 0.1214 | 0.3843 | 0.8056 | 0.4631 | 0.0185 | 0.5180 | 0.3043 |
| hybrid router | 0.1125 | 0.3612 | 0.8174 | 0.5633 | 0.0175 | 0.6310 | 0.2930 |
| offline challenger | 0.1142 | 0.3730 | 0.7712 | 0.5351 | 0.0154 | 0.9955 | 0.1651 |

Critical smoke read:

1. Hybrid router beats current `v6` on overall-course Brier, log loss, ROC-AUC, PR-AUC, and ECE at the same time.
2. Hybrid router keeps much more recall than pure challenger while taking a large precision and PR-AUC step up over current `v6`.
3. Biggest gains come from routing `attendanceRisk` early checkpoints to challenger and routing `overallCourseRisk` late checkpoints to challenger while leaving weak heads mostly on current.

Per-head smoke deltas vs current `v6`:

| Head | Δ Brier | Δ Log Loss | Δ ROC-AUC | Δ PR-AUC | Δ ECE |
| --- | ---: | ---: | ---: | ---: | ---: |
| attendanceRisk | -0.0056 | -0.0214 | +0.0180 | +0.0856 | -0.0080 |
| ceRisk | 0.0000 | 0.0000 | +0.0020 | -0.0042 | 0.0000 |
| seeRisk | -0.0026 | -0.0106 | +0.0032 | +0.0304 | +0.0013 |
| overallCourseRisk | -0.0089 | -0.0231 | +0.0118 | +0.1002 | -0.0010 |
| downstreamCarryoverRisk | 0.0000 | 0.0000 | 0.0000 | -0.0007 | 0.0000 |

Smoke-selected routing summary:

1. `attendanceRisk`: challenger at `pre-tt1`, `post-tt1`; current later
2. `ceRisk`: current all stages
3. `seeRisk`: challenger at `post-tt1`, `pre-tt1`, `post-assignments`, `post-tt2`; current at `post-see`
4. `overallCourseRisk`: current at `pre-tt1`, `post-tt1`, `post-see`; challenger at `post-assignments`, `post-tt2`
5. `downstreamCarryoverRisk`: current all stages

## Hybrid Coverage Rerun Ledger

Fresh detached wide rerun launched on hybrid-capable evaluator:

- command profile: `coverage-24`
- detached session: `airmentor-proof-risk-coverage-24-hybrid-20260419T233617Z`
- detached log: `output/detached/airmentor-proof-risk-coverage-24-hybrid-20260419T233617Z.log`
- isolated output dir: `air-mentor-api/output/proof-risk-model-runs/20260419T233617Z-coverage-24-hybrid`

Fresh auto-archive watcher launched for hybrid wide rerun:

- detached session: `airmentor-proof-risk-coverage-24-hybrid-archive-watcher-20260419T233617Z`
- detached log: `output/detached/airmentor-proof-risk-coverage-24-hybrid-archive-watcher-20260419T233617Z.log`

Purpose of this rerun:

1. verify whether smoke-level hybrid gains hold on the wider `24`-world governed corpus
2. compare `current v6` vs `hybrid-router` under broader scenario coverage before any promotion decision

## Final Wide Hybrid Result

The detached `coverage-24` hybrid rerun later finished clean and auto-archived here:

- `audit-map/17-artifacts/json/2026-04-20T001738Z--proof-risk-coverage-24-hybrid-router--local--evaluation-report.json`
- `audit-map/17-artifacts/local/2026-04-20T001738Z--proof-risk-coverage-24-hybrid-router--local--evaluation-report.md`

Overall-course outcome on wide `coverage-24`:

| Variant | Brier | Log Loss | ROC-AUC | PR-AUC | ECE | Medium Precision | Medium Recall |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| current v6 | 0.1361 | 0.4211 | 0.7887 | 0.4866 | 0.0065 | 0.4908 | 0.4291 |
| hybrid router | 0.1336 | 0.4201 | 0.7846 | 0.5118 | 0.0100 | 0.5565 | 0.4204 |
| offline challenger | 0.1358 | 0.4333 | 0.7390 | 0.4844 | 0.0022 | 0.7014 | 0.1019 |

Critical wide read:

1. hybrid router does **not** dominate on the wider corpus
2. hybrid improves probability quality and intervention precision on some heads
3. hybrid worsens calibration and ranking in important slices
4. challenger alone remains too weak to promote directly
5. current `v6` stays best safe default

Per-head wide summary vs current `v6`:

1. `attendanceRisk`: real hybrid win on Brier, log loss, ROC-AUC, PR-AUC; ECE worse
2. `ceRisk`: real win on Brier, log loss, ROC-AUC, PR-AUC; ECE worse and actionability needs guardrails
3. `seeRisk`: modest win on Brier, log loss, ROC-AUC, PR-AUC; ECE worse
4. `overallCourseRisk`: mixed; better Brier, log loss, PR-AUC, and medium precision, but worse ROC-AUC and ECE
5. `downstreamCarryoverRisk`: clear regression; do not hybridize

Important stage-level failure modes:

1. `attendanceRisk/post-assignments`: router picked challenger but current was better on Brier, ROC-AUC, PR-AUC, and ECE
2. `ceRisk/post-tt1` and `ceRisk/post-see`: router could pick slices with zero medium-threshold flags on validation, which is bad for intervention utility
3. `overallCourseRisk/post-tt2` and `overallCourseRisk/post-assignments`: challenger improved Brier and PR-AUC but dropped ROC-AUC too much
4. `downstreamCarryoverRisk`: challenger routing hurt almost everywhere

## Final Research Read

Fresh 2024-2026 source review plus local evidence points to this order:

1. strengthen evaluator on decision utility first
2. use only coarse head+stage routing where wide validation says stable win
3. improve calibration after model selection, not before
4. bring in stronger external challenger only after evaluator guardrails are in place

Fresh sources that matter most:

1. `TabArena` (2025): `https://arxiv.org/abs/2506.16791`
2. `Better by Default` (2024): `https://arxiv.org/abs/2407.04491`
3. `Classifier Calibration at Scale` (2026): `https://arxiv.org/abs/2601.19944`
4. `Generalized Venn and Venn-Abers Calibration` (2025): `https://arxiv.org/abs/2502.05676`
5. `TabFSBench` (2025): `https://arxiv.org/abs/2501.18935`
6. `TableShift` (2023, still relevant baseline on shift protocol): `https://arxiv.org/abs/2312.07577`

Hard research conclusion:

1. do **not** jump next to global all-head routing or row-level MoE
2. first serious challenger should be `CatBoost` per head; `XGBoost` second if monotone constraints needed
3. best next calibrators are `Beta` and `Venn-Abers`, not blind isotonic-by-default
4. abstain / suppress / escalate logic should eventually use conformal-style risk control, because product intent cares about safe interventions under uncertainty

## Ranked Next Steps

1. Add evaluator-only queue-budget and intervention-utility metrics.
   1. `precision@budget`
   2. `recall@budget`
   3. `flaggedRate@budget`
   4. section overload / max-open-rate diagnostics
2. Replace global hybrid with allowlisted head+stage routing.
   1. safe default = current `v6`
   2. allow challenger only where wide evidence supports it
   3. initial keep-candidate set:
      1. `attendanceRisk`: `pre-tt1`, `post-tt1`, `post-tt2`
      2. maybe `seeRisk`: `post-tt2`, `post-assignments`
   4. force current for:
      1. all `downstreamCarryoverRisk`
      2. all `overallCourseRisk` for now
      3. most or all `ceRisk` until queue guards added
3. Add routing guardrails.
   1. support floor by world count
   2. no winner with zero actionable flags on intervention heads
   3. cap allowed ROC-AUC drop
   4. cap allowed ECE worsening
   5. fallback to current on unstable ties
4. Re-run `smoke-3` and `coverage-24` with those evaluator guardrails.
5. Then build offline `CatBoost` per-head challenger with same governed splits and provenance features.
6. Compare `uncalibrated` vs `Beta` vs `Venn-Abers` on stage-aware temporal calibration splits.
7. Only then consider wider stackers or `XGBoost`.

Current recommendation:

1. keep current `v6` as best promotable default
2. keep hybrid as evaluator-only research lane
3. do not promote global hybrid
4. do not replace with challenger-only model
