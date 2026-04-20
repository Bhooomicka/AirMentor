# Gap Closure + Deploy + ML Optimal Campaign Prompt (2026-04-20)

## No-Loss Contract

Do not drop any requirement from this prompt bundle.
Do not flatten details into vague summary.
Do not skip any explicit constraint unless blocked by tool/runtime limits.
If blocked, record blocker, exact reason, and exact resume command.

## Canonical Source Package (Read Fully, Preserve Exactly)

1. `audit-map/32-reports/session-handoff-2026-04-20-gap-closure-complete.md`
2. `audit-map/32-reports/simulation-gap-closure-handoff-2026-04-20.md`
3. `audit-map/32-reports/deterministic-gap-closure-plan.md`
4. `audit-map/23-coverage/coverage-ledger.md`
5. `audit-map/32-reports/proof-risk-model-investigation-2026-04-20.md`
6. `audit-map/32-reports/proof-risk-model-next-agent-handoff-2026-04-20.md`
7. `audit-map/14-reconciliation/contradiction-matrix.md`
8. `audit-map/24-agent-memory/known-facts.md`

Treat those files as mandatory facts, not optional context.

## Mission

Two-track mission, same runbook, no intent drift:

1. Gap Closure Complete + Deployment + Audit Reconciliation
2. Continue ML model optimization with deep testing, reruns, tuning, and latest research-backed reasoning

Date: `2026-04-20`
Branch: `promote-proof-dashboard-origin`
Repo: `https://github.com/Raed2180416/AirMentor.git`
Working dir: `/home/raed/projects/air-mentor-ui`

## Non-Negotiable Philosophy

Feature intent first, code mechanics second.

Before touching any file:

1. Read full feature intent from audit maps, handoffs, and product context.
2. Trace exact data/control path that breaks intent.
3. Fix only what breaks intent. No unrelated cleanup. No preemptive abstraction.
4. Write tests proving intent, not just no-throw execution.

Intent-test standard:

- Every assertion should map to product why.
- If test is too fragile or too heavy for truthful intent proof, skip it explicitly rather than add a weak test.

## Track A Facts To Preserve

Closed gaps this session: `GAP-1`, `GAP-2`, `GAP-3`, `GAP-4`, `GAP-5`, `GAP-7`.
Deferred: `GAP-6`.
Low-priority known mismatch: `GAP-8`.

Track A key outcomes already implemented in code (must verify and protect):

1. Virtual date anchor for due labels via `toDueLabel(..., anchorISO?)` and `proofPlayback.currentDateISO` flow.
2. Proof activation now persists `offeringAssessmentSchemes` rows as `Configured`.
3. Stage gate on assessment lock endpoint blocks future-stage evidence locking.
4. HOD clear-lock route clears physical DB lock column and supports idempotent response.
5. Bootstrap gate returns `403 NO_ACTIVE_PROOF_RUN` when proof run absent.
6. Proof archive/activate invalidates branch-scoped faculty sessions via `invalidateProofBatchSessions`.
7. Intent-driven test suite exists in `air-mentor-api/tests/gap-closure-intent.test.ts` with 10 tests.

## Track A Mandatory Reconciliation Outputs

Must reconcile docs that were stale after implementation:

1. Fill section 4 in `audit-map/32-reports/simulation-gap-closure-handoff-2026-04-20.md`.
2. Update `audit-map/32-reports/deterministic-gap-closure-plan.md` to reflect closure state (closed except 6 and 8).
3. Add `gap-closure-intent.test.ts` surface in `audit-map/23-coverage/coverage-ledger.md`.
4. Ensure prompt/index tracking includes this campaign prompt set.

## Track A Deployment + Collaboration Constraints

Primary product goal:

- stable product
- all non-deferred gaps committed and pushed
- collaborator-facing branch stays clean and usable

Keep in mainline scope:

- core app/backend code
- detailed audit maps needed for engineering truth

Keep out from mainline scope where possible:

- full automation pipeline internals
- handoff-only docs
- stale logs and generated outputs no longer needed
- local/Nix-only personal environment artifacts
- random helper scripts with no team value

If full cleanup cannot be safely completed in this run, produce a deterministic prune plan with explicit include/exclude path rules and commands.

## Track B Facts To Preserve

Primary ML objective:

- trustworthy, explainable, intervention-useful risk guidance under drift, partial evidence, and operational constraints
- not leaderboard-only optimization

Current proven facts to respect:

1. Evaluator integrity hardening retained.
2. Queue/evaluator race fixed (`proof-run-queue.ts` around line 268) and covered (`proof-run-queue.test.ts` around line 107).
3. Stage-aware scoring added in `proof-risk-model.ts` and tested (`proof-risk-model.test.ts` stage-sensitive case).
4. Evaluator upgraded with stronger reliability and decision diagnostics.
5. Isolated output-dir support prevents report stomping.
6. Canonical governed corpus remains 64 worlds; `coverage-24` is an intermediate profile, not replacement.

Current metric truth to preserve from artifacts:

- Wide non-hybrid (`coverage-24`): current v6 beats baseline; challenger not promotable alone.
- Hybrid smoke (`smoke-3`): optimistic gains.
- Hybrid wide (`coverage-24`): mixed; gains in probability/precision slices, regressions in ranking/calibration slices.
- Head asymmetry real; one global router is too coarse.

Promotion guidance now:

1. Promote now: current v6 only.
2. Keep as research lane: hybrid router and challenger variants.
3. Do not promote now: global hybrid or challenger-only replacement.

## Track B Next Experiment Program (Required)

Ranked order:

1. Add decision-utility/queue-budget evaluator metrics:
   - precision@budget
   - recall@budget
   - flaggedRate@budget
   - overload diagnostics
2. Constrain routing by head+stage allowlist with current v6 as default.
3. Add routing guardrails:
   - minimum support/stability
   - cap tolerated AUC drop
   - cap tolerated ECE degradation
   - disallow non-actionable flag behavior on intervention heads
4. Rerun smoke-3 and coverage-24 with constrained router + expanded metrics.
5. Add external challenger lane (offline first): CatBoost per head, then optional XGBoost.
6. Run calibration bake-off per head/stage: uncalibrated vs Beta vs Venn-Abers.
7. Optional uncertainty control lane: conformal-style abstain/escalate gating.

## Side Analysis Requirement (No Code Changes)

Analyze this question deeply in final report:

Will model remain robust in real classes with different learning rates and environments, and how does deferred slider configurability affect external validity?

Rules for this side analysis:

1. No code edits for this item.
2. Use heavy reasoning grounded in current world-generation design, feature schema, calibration behavior, and decision utility limits.
3. Include explicit argument for what simulation ranges represent, what they miss, and what evidence is needed before claiming robustness in real-world variation.

## Required Provider/Model Preferences For Automation

When route control is available, use this preference order:

1. Native Codex: `gpt-5.4` with `xhigh` or `high`.
2. Antigravity primary reasoning lanes: `claude-opus-4.6` and `gemini-3.1-pro-preview`.
3. Google lanes: `gemini-3.1-pro-preview` (or nearest equivalent).
4. Copilot lanes: `gpt-5.3-codex` with `xhigh`.
5. Claude lanes: `claude-sonnet-4.6` with max reasoning.

If preferred provider is unavailable, document exact fallback path used.

## Execution Sequence Contract

Order is mandatory:

1. Stabilize and push non-deferred gap closure + reconciliation changes first.
2. Do not block push on long ML exploration.
3. After push, launch ML deep-tune lane in background automation.
4. Continue ML iterations; when strongest constrained model path is proven, push follow-up changes.

## Final Deliverables Contract

Deliverables must include:

1. exact code/doc changes made
2. exact tests run and outcomes
3. exact commits pushed and branch names
4. exact ML artifacts generated and where stored
5. explicit promotion decision with rationale tied to product intent and queue/intervention constraints
6. deep no-code robustness analysis for real classroom variability and deferred configurables

No vague endings. No unresolved ambiguity without explicit blocker record.
