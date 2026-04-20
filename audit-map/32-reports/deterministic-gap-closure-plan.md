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

## Current Critical Status

The audit corpus is strong, but it is not yet deterministic enough to support a claim that every meaningful line, interaction, and cross-surface truth is fully mapped.

The remaining high-risk closure blockers are:

1. standalone per-flow data-flow corpus
2. proof-refresh completion ownership
3. full long-tail frontend interaction coverage
4. credentialed live same-student / proof / role parity verification

## Critical Analysis

### What is already good enough

- broad architecture, route, role, feature, dependency, state, ML, workflow, and backend provenance coverage
- contradiction and ambiguity ledgers
- strong local code/test-backed system maps

### What is still too weak for a deterministic claim

- data flow is still overlay-only
- worker completion ownership is still not explicit enough
- frontend long tail is still clustered, not exhaustive
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
