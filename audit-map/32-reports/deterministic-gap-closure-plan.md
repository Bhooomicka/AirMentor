# Deterministic Gap Closure Plan

Date: `2026-04-16`

## 2026-04-20 Reconciliation Update

Current closure truth now differs from the original draft scope.

### Gap Status Snapshot

| Gap | Status | Notes |
| --- | --- | --- |
| GAP-1 | closed | `offeringAssessmentSchemes` persisted as `Configured` during proof activation path |
| GAP-2 | closed | stage gate blocks future-stage lock attempts |
| GAP-3 | closed | HOD clear-lock now clears DB lock column, idempotent path covered |
| GAP-4 | closed | branch-scoped faculty sessions invalidated on archive/activate |
| GAP-5 | closed | bootstrap now gates proof faculty access when active run missing |
| GAP-7 | closed | proof virtual date now anchors due-label calculations |
| GAP-6 | deferred | slider/config migration + UI + activation wiring still pending by design |
| GAP-8 | low-priority known | `totalClasses` mismatch still non-blocking for demo path |

### Immediate Plan Adjustment

1. Keep deterministic closure effort focused on post-closure verification and reconciliation quality.
2. Treat GAP-6 as design-track work, not blocker-track work.
3. Keep GAP-8 as known low-priority mismatch unless product intent changes.
4. Prioritize deep pass coverage for telemetry/startup diagnostics, playback lifecycle helper family, provenance parity, sysadmin helper cluster, and session-invalidation boundary tests.

### Deployment And Audit Reconciliation Constraint

Stable push should not wait for long ML experimentation.
Commit/push non-deferred closure set first, then continue ML optimization in background lane with durable artifacts.

### 2026-04-20 Validation And Reconciliation Reality

1. Frontend proof-date surfaces now have direct test backing: `tests/domain.test.ts`, `tests/calendar-utils.test.ts`, and `tests/academic-session-shell.test.tsx` pass after adding explicit virtual-date anchor assertions.
2. Backend bootstrap gate coverage is locally runnable and currently passes through `air-mentor-api/tests/academic-bootstrap-routes.test.ts` plus the GAP-5 subset of `air-mentor-api/tests/gap-closure-intent.test.ts`.
3. The full backend integration portion of `air-mentor-api/tests/gap-closure-intent.test.ts` remains sandbox-blocked by `listen EPERM: operation not permitted 127.0.0.1` from embedded Postgres. Treat those assertions as code-backed plus sandbox-blocked test-backed until they are rerun in a listener-permitted environment.
4. Audit reconciliation must target canonical current paths:
   - feature atoms: `audit-map/04-feature-atoms/`
   - dependencies: `audit-map/05-dependencies/`
   - ML audit: `audit-map/08-ml-audit/`
   The older `08-feature-atoms` / `09-dependency` / `12-ml` path wording is stale prompt prose, not current audit-OS truth.

## Current Critical Status

Gap-closure Track A is now locally stable, but not globally complete.

Closed and locally preserved now:

1. GAP-1
2. GAP-2
3. GAP-3
4. GAP-4
5. GAP-5
6. GAP-7

Still intentionally not closed:

1. GAP-6 (deferred design/config track)
2. GAP-8 (known low-priority mismatch)

The remaining high-risk blockers for this track are verification and deployment residuals, not missing local code-path fixes:

1. full backend integration rerun of `gap-closure-intent.test.ts` outside the current `listen EPERM` sandbox
2. security-boundary expansion for `invalidateProofBatchSessions`
3. stable push + CI/deploy observation
4. credentialed live same-student / proof / role parity verification

## Critical Analysis

### What is already good enough

- broad architecture, route, role, feature, dependency, state, ML, workflow, and backend provenance coverage
- contradiction and ambiguity ledgers
- strong local code/test-backed system maps
- standalone data-flow corpus backing
- local proof-refresh completion ownership
- local gap-closure code paths and focused listener-free tests

### What is still too weak for a deterministic claim

- backend listener-dependent gap-closure integration reruns are blocked in this shell
- `invalidateProofBatchSessions` still lacks full boundary-guard coverage
- frontend long tail is still clustered, not exhaustive for the broader closure campaign
- live credentialed parity is still blocked

### What this means

The codebase is no longer “unknown,” but it is still not closure-complete.

The remaining uncertainty is concentrated, not diffuse.
That is progress, but it is not the same as deterministic closure.

## Planned Final-Gap Campaign

Canonical prompt stack:

1. `audit-map/20-prompts/environment/main-analysis-agent-bootstrap.md`
2. `audit-map/20-prompts/exhaustive-closure-campaign.md`
3. `audit-map/20-prompts/adversarial-validation-campaign.md`
4. `audit-map/20-prompts/deterministic-gap-closure-campaign.md`
5. the specific pass prompt

Planned queue:

1. `data-flow-corpus-rerun-pass`
2. `proof-refresh-completion-pass`
3. `frontend-long-tail-pass`
4. `live-credentialed-parity-pass`
5. `closure-readiness-pass`

Queue sample:

- `audit-map/31-queues/final-gap-closure.queue.sample`

## Runner Policy

- `data-flow-corpus-rerun-pass`: native-only
- `proof-refresh-completion-pass`: native-only
- `frontend-long-tail-pass`: native-only
- `live-credentialed-parity-pass`: native-only and credential-gated
- final `closure-readiness-pass`: native-only

Reason:

The deepest closure passes are not trustworthy on the current alternate Copilot route.

## Manual Checkpoint

The first three passes are local/deep-code passes.

The fourth pass is a hard manual checkpoint because it requires:

- valid live credentials
- a working live browser environment
- a chosen same-student target for parity verification

## Success Standard

This campaign should only be considered complete when:

- `audit-map/06-data-flow/` has a real per-flow corpus
- proof-refresh completion lineage exists as a durable artifact
- long-tail frontend interaction coverage is materially expanded
- live same-student parity is either proven or explicitly blocked with exact resume conditions
- `closure-readiness-verdict.md` is rerun and updated from those new facts
