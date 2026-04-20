# Gap Closure Deploy Audit Reconciliation Pass

## Scope

Execute Track A only from:

- `audit-map/20-prompts/gap-closure-deploy-ml-optimal-campaign-2026-04-20.md`

Do not expand into Track B in this pass.

## Source-Of-Truth Rules

1. Use current code, tests, scripts, status, and artifacts as primary truth.
2. Do not use handoff docs as primary truth.
3. If prompt text and code diverge, code/tests win and drift must be logged.

## Hard Goals

1. Verify and preserve closure of GAP-1, GAP-2, GAP-3, GAP-4, GAP-5, GAP-7.
2. Keep GAP-6 deferred.
3. Keep GAP-8 low priority.
4. Reconcile stale audit-map files to current implementation truth.
5. Commit and push stable non-deferred closure set before ML deep loops.

## Mandatory Actions

1. Validate each closed gap in code path and intent tests.
2. Validate `air-mentor-api/tests/gap-closure-intent.test.ts` surface and outcomes.
3. Reconcile required audit files:
   - `audit-map/15-final-maps/*` closure status where relevant
   - `audit-map/06-data-flow/*` anchorISO/currentDateISO flow
   - `audit-map/08-feature-atoms/*` new helper and clear-lock route
   - `audit-map/09-dependency/*` sessions/roleGrants import coupling
   - `audit-map/12-ml/*` hardcoded-threshold known-state note
   - `audit-map/32-reports/simulation-gap-closure-handoff-2026-04-20.md` section 4
   - `audit-map/32-reports/deterministic-gap-closure-plan.md`
   - `audit-map/23-coverage/coverage-ledger.md` new test surface
4. Run focused validation suites for changed surfaces.
5. Produce commit and push for stable non-deferred closure set.

## Deployment Contract

1. Do not wait for long ML experiments.
2. Push stable closure/reconciliation state first.
3. Record commit hash, branch, tests run, and deploy checks in output.
4. If merge-to-main is requested in this pass, require CI green + activation smoke criteria.

## Cleanup Guardrail

If collaborator-noise cleanup cannot be completed safely in this pass:

1. do not perform broad destructive deletion
2. produce deterministic prune plan with include/exclude rules and exact commands
3. mark cleanup as explicit follow-up after stable push

## Execution Settings

1. Use highest available reasoning (`xhigh` preferred).
2. Prefer native codex `gpt-5.4` for this high-stakes closure pass.
3. If provider/model fallback occurs, record exact route decision.

## Completion Gate

Pass is complete only when:

1. non-deferred gap closure behavior is still passing targeted tests
2. reconciliation files reflect current code truth
3. stable commit and push are completed and recorded
4. remaining deferred/low-priority gaps are explicitly labeled with rationale
