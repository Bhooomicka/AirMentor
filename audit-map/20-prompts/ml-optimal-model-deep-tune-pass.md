# ML Optimal Model Deep Tune Pass

## Scope

Execute Track B from:

- `audit-map/20-prompts/gap-closure-deploy-ml-optimal-campaign-2026-04-20.md`

## Hard Goals

1. Push toward strongest trustworthy model under product constraints.
2. Keep current v6 as safety baseline unless stronger constrained evidence appears.
3. Run deeper experiments with strict artifact durability.
4. Produce decision based on ranking + calibration + intervention utility, not one metric.

## Mandatory Inputs

Read first:

1. `audit-map/32-reports/proof-risk-model-investigation-2026-04-20.md`
2. `audit-map/32-reports/proof-risk-model-next-agent-handoff-2026-04-20.md`
3. latest archived `coverage-24` and hybrid artifacts in `audit-map/17-artifacts/json/`

## Required Experiment Order

1. Add and use decision-utility evaluator metrics (budget/overload-aware).
2. Constrain hybrid router with head+stage allowlist and hard guardrails.
3. Rerun smoke-3 and coverage-24 under constrained router.
4. Run external challenger lane (CatBoost first, optional XGBoost next).
5. Run calibration bake-off (uncalibrated, Beta, Venn-Abers).
6. Reassess promotion decision.

## Provider Preference Contract

When route selection is available, prefer:

1. antigravity `claude-opus-4.6`
2. antigravity or google `gemini-3.1-pro-preview`
3. native codex `gpt-5.4`
4. copilot `gpt-5.3-codex`

Document actual route used in every major run.

## Side Reasoning Task (No Code Change)

Provide deep analysis on real-class robustness vs simulation world assumptions and deferred slider configurability.

## Completion Gate

Pass complete only when:

1. new artifacts are archived with stable names
2. recommendation states promote/hold with explicit constraints
3. no-code robustness analysis is complete and explicit
