# Gap Closure + Deploy + ML Optimal Campaign Prompt (2026-04-20)

## Zero-Loss Contract

Preserve every requirement in this prompt.
Do not collapse details into vague summaries.
Do not skip constraints unless blocked by runtime limits.
If blocked, record blocker, exact cause, exact resume command, and exact remaining scope.

## Session Metadata

- Date: `2026-04-20`
- Branch: `promote-proof-dashboard-origin`
- Repo: `https://github.com/Raed2180416/AirMentor.git`
- Working dir: `/home/raed/projects/air-mentor-ui`

## Mission (Two Tracks, One Runbook)

1. Gap Closure Complete + Deployment + Audit Reconciliation.
2. Continue ML model work with deeper testing, reruns, tuning, and fresh research when needed.

## Source-of-Truth Rule

Do not use existing handoff docs as primary truth when creating plan or execution flow.
You may use handoff docs only as weak hints.
Primary truth must come from current code, tests, scripts, configs, status/checkpoint files, and generated artifacts in this repo.

## Approach (Non-Negotiable Philosophy)

Every decision must follow: feature intent first, code mechanics second.

Before changing files:

1. Read full feature intent from audit maps and product context.
2. Trace exact data/control path that breaks intent.
3. Fix only what breaks intent. No unrelated cleanup. No speculative abstraction.
4. Write tests that prove intent, not only no-throw behavior.

This is not a coverage exercise.
Tests in `gap-closure-intent.test.ts` should explain why each assertion matters to product behavior.
If a test is too fragile/heavy to express intent well, skip explicitly instead of writing a low-value test.

## Track A: Gap Closure + Deploy + Audit Reconciliation

### A1. Closed Gap Outcomes To Verify/Preserve

Closed now: `GAP-1`, `GAP-2`, `GAP-3`, `GAP-4`, `GAP-5`, `GAP-7`.
Deferred: `GAP-6`.
Low priority known mismatch: `GAP-8`.

### A2. Detailed Implemented Facts (Must Be Preserved)

#### GAP-7: Virtual date drives due labels

Intent:
Proof playback mode must compute due labels (`Today`, `This week`, `<dateISO>`) relative to simulation virtual date, not wall clock.

Implemented details:

1. `src/domain.ts` adds `toDueLabel(dueDateISO, fallback, anchorISO?)` with optional anchor date.
2. `src/calendar-utils.ts` updates `applyPlacementToTask(task, placement, anchorISO?)` to pass anchor to `toDueLabel`.
3. `air-mentor-api/src/modules/academic.ts` bootstrap now returns `proofPlayback.currentDateISO`, derived from `stageCheckpointRow.createdAt.slice(0, 10)`.
4. `src/App.tsx` derives `proofVirtualDateISO` from `academicBootstrap.proofPlayback?.currentDateISO` and passes it through all due-label call paths, including recurring scheduling, edits, and `handleCreateTask`.

Non-obvious detail:
`TaskComposerModal` cannot read `proofVirtualDateISO` directly.
Due label is computed in `OperationalWorkspace` `handleCreateTask` submit path where anchor is in scope.

#### GAP-1: Proof offerings get configured schemes on activation

Intent:
When proof run activates, every offering must have a persisted `Configured` assessment scheme row.
Without it, stage eligibility blocks advancement.

Root cause:
`publishOperationalProjection` wrote attendance/scores but not `offeringAssessmentSchemes` rows.
Runtime fallback in `academic.ts` was not persisted.

Fix:
`publishOperationalProjection` inserts `offeringAssessmentSchemes` for proof offerings using MSRUAS default scheme JSON, `status='Configured'`, with conflict-safe idempotency.

Cycle avoidance:
Default scheme JSON is kept in control plane constant to avoid circular import to `buildDefaultSchemeFromPolicy` in `academic.ts`.

#### GAP-2: Stage gate blocks future-stage evidence lock

Intent:
Stage 1 teacher must not lock TT2/quiz/assignment/finals early, even if seeded records exist.

Fix:
`academic-runtime-routes.ts` `PUT .../assessment-entries/:kind` enforces stage order:

1. TT1 requires stage >= 1.
2. TT2/quiz require stage >= 2.
3. assignment requires stage >= 3.
4. finals requires stage >= 4.

#### GAP-3: HOD clear-lock must clear DB column

Intent:
HOD approval must allow teacher re-submit.
Clearing only runtime JSON is not enough because submit path checks DB lock column.

Fix set:

1. Backend route in `academic-runtime-routes.ts`:
   `POST /api/academic/offerings/:offeringId/assessment-entries/:kind/clear-lock`
   - role: HOD required
   - action: clear `[kind]Locked` in `sectionOfferings`
   - response: `{ ok: true, offeringId, kind, cleared: boolean }`
   - idempotent: `cleared:false` with `reason:'already-unlocked'`
2. API client `src/api/client.ts` adds `clearOfferingAssessmentLock(offeringId, kind)`.
3. `src/repositories.ts` adds HTTP-mode `clearRemoteLock(offeringId, kind)` in `locksAudit`.
4. Frontend `src/App.tsx` `handleResetComplete` awaits `repositories.locksAudit.clearRemoteLock(...)` before local state mutation.

#### GAP-5: Bootstrap gate on no active proof run

Intent:
If no active simulation run, sandbox faculty must see explicit gate, not broken workspace.

Fix set:

1. `academic-bootstrap-routes.ts` checks active simulation run before calling bootstrap builder.
2. If absent, returns `403` with code `NO_ACTIVE_PROOF_RUN`.
3. `buildAcademicBootstrap` is not called in this case.
4. `src/academic-session-shell.tsx` intercepts this code and renders gate page.

#### GAP-4: Session invalidation on archive/activate

Intent:
On archive/new activation, branch-scoped faculty sessions must be invalidated to prevent stale context operations.

Fix set in `air-mentor-api/src/lib/msruas-proof-control-plane.ts`:

1. Adds schema imports: `sessions`, `roleGrants`.
2. Adds helper `invalidateProofBatchSessions(db, batchId)`:
   - `batchId -> batches.branchId`
   - `branchId -> roleGrants.scopeId`
   - `facultyIds -> facultyProfiles.userId`
   - `userIds -> delete sessions where userId in (...)`
3. `archiveProofSimulationRun` calls helper after audit emit.
4. `activateProofSimulationRun` calls helper after deactivating old runs and before activating new run.

Critical join fact:
`userAccounts` has no `facultyId`.
Bridge must go through `facultyProfiles`.

### A3. Intent-Driven Test Surface

File: `air-mentor-api/tests/gap-closure-intent.test.ts`

Expected tests (10):

1. GAP-5: 403 `NO_ACTIVE_PROOF_RUN` when no active run.
2. GAP-5: 200 + bootstrap path when active run exists.
3. GAP-1: stage eligibility blocked without scheme.
4. GAP-1: stage eligibility not blocked with configured scheme.
5. GAP-2: TT2 rejected at stage 1.
6. GAP-2: TT1 allowed at stage 1.
7. GAP-3: clear-lock clears DB column and returns `cleared:true`.
8. GAP-3: idempotent clear-lock returns `cleared:false`.
9. GAP-3: Course Leader rejected (`403`) on clear-lock.
10. GAP-4: faculty session deleted after archive.

Key helper expectations:

1. `getProofOfferingId(db)` resolves via active run -> highest semester term -> first offering.
2. `loginAsHOD(app)` uses `devika.shetty` then role-context switch to `grant_mnc_t1_hod`.

### A4. Open Gaps State

#### GAP-6 (Deferred, keep deferred)

What:
Section environment params and ML thresholds are seeded/hardcoded; not slider-configurable per run.

Why deferred:
Needs migration + UI + activation wiring + design-spec ranges/defaults.
Not required for current stable proof demo correctness.

Future build shape:

1. Migration: add `configJson` on `simulation_runs`.
2. UI: pre-activation form with sliders/overrides.
3. Backend: activation reads config and feeds seeding bounds.

#### GAP-8 (Low priority)

`totalClasses` mismatch (`32` vs scaffold `50`) is non-blocking for current proof demo path.

### A5. Required Audit Reconciliation Work

Update these areas with current truth:

1. `audit-map/15-final-maps/` reflect GAP-1..7 closure status.
2. `audit-map/06-data-flow/` add `toDueLabel(anchorISO)` + `proofPlayback.currentDateISO` flow.
3. `audit-map/08-feature-atoms/` capture `invalidateProofBatchSessions` helper.
4. `audit-map/08-feature-atoms/` capture new `clearOfferingAssessmentLock` route capability.
5. `audit-map/09-dependency/` reflect `sessions` + `roleGrants` imports in proof control plane.
6. `audit-map/12-ml/` record hardcoded threshold note as known.
7. `audit-map/32-reports/simulation-gap-closure-handoff-2026-04-20.md` fill section 4 implemented fixes.
8. `audit-map/32-reports/deterministic-gap-closure-plan.md` update statuses (all closed except 6 and 8).
9. `audit-map/23-coverage/coverage-ledger.md` add `gap-closure-intent.test.ts` surface.

### A6. Deep Pass Targets Not Fully Represented

Run targeted deep pass on:

1. Telemetry/startup diagnostics path (`src/telemetry.ts`, `src/startup-diagnostics.ts`, backend telemetry/event-store and tests).
2. Proof playback lifecycle helper family (`proof-control-plane-access`, playback governance/reset/stage summary, observed state).
3. Cross-surface proof provenance/count-source parity (`src/proof-provenance.ts` across sysadmin/HoD/risk-explorer/student-shell).
4. Sysadmin helper cluster (`system-admin-provisioning-helpers`, scoped registry launches, faculty calendar workspace).
5. `invalidateProofBatchSessions` security tests:
   - sysadmin sessions not deleted
   - different-branch faculty sessions not deleted
   - no-session faculty path remains graceful

### A7. Deployment Contract

Current state constraints:

1. Work is on `promote-proof-dashboard-origin`.
2. TypeScript compile should remain clean.
3. Full suite may be expensive; do targeted first, then broader suite when feasible.

Deployment sequence:

1. Stage intended backend/frontend/reconciliation changes.
2. Commit stable non-deferred gap closure set.
3. Push branch.
4. Verify CI/deploy workflow status.
5. For Railway deployment path: confirm `/health`, then verify active proof run endpoint.

Do not merge to `main` until:

1. intent-driven tests pass in CI
2. manual smoke confirms configured schemes are created on activation

### A8. Credential Context For Testing

Sandbox/HOD:

1. `devika.shetty` / `faculty1234`
2. role switch payload: `{ "roleGrantId": "grant_mnc_t1_hod" }`

Sysadmin:

1. `sysadmin` / `admin1234`

## Track B: ML Deep Tune Program

### B1. Primary Objective

Optimize for trustworthy, explainable, intervention-useful risk guidance under drift/partial evidence/operational constraints.
Do not optimize only for leaderboard metrics.

### B2. Current Findings To Preserve

1. Evaluator completeness/integrity guardrails retained.
2. Queue/evaluator reclaim race fixed in `proof-run-queue.ts` and tested in queue tests.
3. Stage-aware scoring path added and regression-tested.
4. Evaluator diagnostics expanded (log loss, PR-AUC, calibration slope/intercept, threshold precision/recall, per-stage summaries).
5. Offline comparison lanes support baseline/current/challenger/hybrid.
6. Isolated output-dir support prevents artifact stomping.
7. Canonical governed corpus remains 64 worlds.
8. `coverage-24` is intermediate profile, not corpus replacement.

### B3. Current Metric Narrative

Wide non-hybrid (`coverage-24`):

1. current v6 improves overall mix vs baseline.
2. challenger has partial improvements but weaker ranking/recall posture.
3. challenger not promotable alone.

Hybrid smoke (`smoke-3`):

1. strong optimistic gains.

Hybrid wide (`coverage-24`):

1. improves some probability/precision signals.
2. degrades some ranking/calibration signals.
3. not dominant enough for global promotion.

Per-head asymmetry:

1. attendanceRisk: strong gains with ECE tradeoff.
2. ceRisk: rank/AP gains with calibration caveat.
3. seeRisk: modest gains with calibration caveat.
4. overallCourseRisk: mixed tradeoff.
5. downstreamCarryoverRisk: regression under hybrid, keep current.

### B4. Why Global Hybrid Underperformed

1. Router hard-selection can favor loss/AP while hurting ranking/calibration utility.
2. Missing safety constraints in objective causes unstable operational behavior.
3. One global policy is too coarse for head+stage asymmetry.

### B5. Research Direction (2024-2026)

Use latest evidence-guided direction:

1. robust tabular baselines + careful ensembling/stacking.
2. temporal/stage-aware evaluation over IID comfort.
3. calibration as first-class post-model step (Beta, Venn-Abers).
4. decision-risk and conformal-style controls for intervention systems.

Reference set:

1. https://arxiv.org/abs/2506.16791
2. https://arxiv.org/abs/2407.04491
3. https://arxiv.org/abs/2410.24210
4. https://arxiv.org/abs/2601.19944
5. https://arxiv.org/abs/2502.05676
6. https://arxiv.org/abs/2406.19380
7. https://arxiv.org/abs/2407.02112
8. https://arxiv.org/abs/2401.11974
9. https://arxiv.org/abs/2404.15018

### B6. Metric Meaning In Product Terms

1. ROC-AUC: ranking/triage quality.
2. PR-AUC: positive retrieval under imbalance.
3. Brier + LogLoss: probability honesty.
4. ECE/slope/intercept: calibration trust.
5. Threshold precision/recall: intervention tradeoff.
6. Queue-volume diagnostics: staff capacity compatibility.

Success requires joint quality:
ranking + calibration + useful precision/recall under queue constraints.

### B7. Required Experiment Program (Ranked)

1. Add decision-utility/queue-budget metrics (`precision@budget`, `recall@budget`, `flaggedRate@budget`, overload diagnostics).
2. Constrain router with head+stage allowlist; default current v6.
3. Force current for `downstreamCarryoverRisk`.
4. Keep `overallCourseRisk` on current until guardrails prove safe.
5. Add router guardrails: support/stability floors, AUC drop cap, ECE degradation cap, non-actionable flag suppression.
6. Rerun smoke-3 + coverage-24 with expanded evaluator and guardrails.
7. Add external challenger lane (CatBoost first, optional XGBoost).
8. Run calibration bake-off (uncalibrated vs Beta vs Venn-Abers) per head/stage.
9. Optional uncertainty-control lane (conformal-style abstain/escalate).

### B8. Promotion Guidance At Start

1. Promote now: current v6 only.
2. Keep hybrid/challenger in research lane.
3. Do not promote global hybrid or challenger-only replacement yet.

## Side Reasoning Task (No Code Changes)

Analyze deeply:
Will model generalize to real classes with varied learning rates/environments, and how deferred configurables affect robustness claims?

Rules:

1. no code changes for this side task
2. reason heavily from world-generation design and constrained realism assumptions
3. describe which ranges are covered, which are not, and what evidence required for robust real-world claim
4. explain how future slider-configurable worlds can improve external validity if ranges/defaults are grounded in realistic priors

## Automation Execution Constraints

1. Build complete detailed flow, then send through Arctic automation pipeline.
2. Do not execute unrelated activities.
3. Evaluate current repo state before launching.
4. Commit/push stable non-deferred gap closure set first.
5. Do not block push on long ML loops.
6. Continue ML deep tuning in background automation after stable push.
7. Push follow-up once strongest constrained model path is proven.

## Model/Account Preference Order

Use highest available reasoning effort everywhere (`xhigh` when exposed).

Preferred order:

1. antigravity: `gemini-3.1-pro` and `claude-opus-4.6` for heavy reasoning when available
2. google: `gemini-3.1-pro` (or nearest equivalent)
3. native codex: `gpt-5.4` with high/xhigh
4. copilot: `gpt-5.3-codex` with xhigh
5. claude account lane: `sonnet-4.6` with max reasoning

If unavailable, use best verified fallback and log exact route decision.

## Output Style Contract

1. If writing documentation files: caveman lite style.
2. For other outputs: caveman ultra wenyan style.
3. Keep technical terms, code blocks, and errors exact.

## Primary Product Hygiene Goal

Target collaborator-friendly branch state:

1. include core codebase + detailed audit maps needed for engineering truth
2. exclude complete automation internals, handoff-only docs, stale logs/outputs, personal/Nix-only artifacts, and irrelevant scripts/docs when safe
3. if cleanup cannot be completed safely in same run, produce deterministic prune plan with exact include/exclude + commands

## Required Final Deliverables

1. exact code/doc updates
2. exact tests run and outcomes
3. exact commits and pushes
4. exact artifact paths for ML runs
5. explicit model promotion/hold decision and rationale
6. deep no-code robustness analysis for real class variability + deferred configurable worlds
7. explicit blockers/resume commands if anything remains incomplete
