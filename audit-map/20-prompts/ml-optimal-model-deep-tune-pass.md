# ML Optimal Model Deep Tune Pass

## Scope

Execute Track B only from:

- `audit-map/20-prompts/gap-closure-deploy-ml-optimal-campaign-2026-04-20.md`

Do not re-open Track A closure edits unless needed to unblock Track B experiments.

## Source-Of-Truth Rules

1. Use current code, evaluator scripts, and generated artifacts as primary truth.
2. Do not use handoff docs as primary truth.
3. If handoff content conflicts with current artifacts/code, artifacts/code win and drift must be logged.

## Hard Goals

1. Find strongest trustworthy and intervention-useful model policy under product constraints.
2. Keep current v6 as production baseline unless constrained evidence proves stronger replacement.
3. Run deeper experiments with durable artifact isolation.
4. Decide using ranking + calibration + decision utility + queue impact together.

## Mandatory Inputs

Read first from live repo state:

1. `air-mentor-api/scripts/evaluate-proof-risk-model.ts`
2. `air-mentor-api/src/lib/proof-risk-model.ts`
3. latest archived `smoke-3`, `coverage-24`, and hybrid artifacts under `audit-map/17-artifacts/`
4. current `audit-map/29-status/` and `audit-map/30-checkpoints/` entries for ML pass continuity

## Required Experiment Order

1. Add/use decision-utility and queue-budget metrics (`precision@budget`, `recall@budget`, `flaggedRate@budget`, overload).
2. Constrain hybrid router with head+stage allowlist and hard guardrails.
3. Force current path for `downstreamCarryoverRisk`; keep overall-course on current until safe.
4. Rerun `smoke-3` and `coverage-24` under constrained router and expanded evaluator.
5. Run external challenger lane (CatBoost first, optional XGBoost second) using same governed splits.
6. Run calibration bake-off (uncalibrated, Beta, Venn-Abers) per head/stage.
7. Reassess promotion decision with explicit operational constraints.

## Provider/Model Preference Contract

Use highest exposed reasoning effort.
Preferred order when available:

1. antigravity: `claude-opus-4.6`, then `gemini-3.1-pro-preview`
2. google: `gemini-3.1-pro-preview`
3. native codex: `gpt-5.4`
4. copilot: `gpt-5.3-codex`
5. claude lane: `sonnet-4.6` max reasoning

If unavailable, use best verified fallback and log exact route decision.

## Side Reasoning Task (No Code Change)

Provide deep reasoning on:

1. expected real-class robustness across varied learning rates/environments
2. effect of deferred slider-configurable world parameters on external validity claims
3. what evidence is still needed before claiming real-world robustness

No code changes allowed for this side task.

## Completion Gate

Pass is complete only when:

1. new artifacts are archived with stable, non-stomping names
2. recommendation states promote/hold/reject with explicit constraints and tradeoffs
3. decision utility and queue-budget behavior are included in model decision
4. no-code robustness analysis is explicit and actionable
