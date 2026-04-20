# Test Gap Ledger

Pass: `test-gap-pass`
Context: `bootstrap`
Date: `2026-04-15`

## Family Map

| Family | Representative paths | What it proves | What it does not prove |
| --- | --- | --- | --- |
| Unit | `tests/portal-routing.test.ts`, `tests/academic-role-sync.test.ts`, `tests/academic-workspace-route-helpers.test.ts`, `tests/proof-playback.test.ts`, `tests/proof-pilot.test.ts`, `tests/proof-risk-semester-walk.test.ts`, `tests/domain.test.ts`, `tests/selectors.test.ts`, `tests/ui-primitives-accessibility-contracts.test.tsx`, `air-mentor-api/tests/proof-control-plane-access.test.ts`, `air-mentor-api/tests/proof-control-plane-checkpoint-service.test.ts`, `air-mentor-api/tests/proof-queue-governance.test.ts`, `air-mentor-api/tests/policy-phenotypes.test.ts`, `air-mentor-api/tests/proof-risk-model.test.ts`, `air-mentor-api/tests/evaluate-proof-risk-model.test.ts`, `air-mentor-api/tests/msruas-curriculum-compiler.test.ts` | Deterministic helper logic, pure route parsing, queue math, model gating, and local UI contracts. | Auth, persistence, live credentials, browser navigation, cross-role live parity, and remote deployment truth. |
| Integration | `air-mentor-api/tests/academic-access.test.ts`, `air-mentor-api/tests/academic-bootstrap-routes.test.ts`, `air-mentor-api/tests/academic-parity.test.ts`, `air-mentor-api/tests/academic-proof-routes.test.ts`, `air-mentor-api/tests/academic-runtime-narrow-routes.test.ts`, `air-mentor-api/tests/admin-control-plane.test.ts`, `air-mentor-api/tests/admin-foundation.test.ts`, `air-mentor-api/tests/admin-proof-observability.test.ts`, `air-mentor-api/tests/student-agent-shell.test.ts`, `tests/api-client.test.ts`, `tests/repositories-http.test.ts`, `tests/repositories.test.ts`, `tests/system-admin-live-data.test.ts`, `tests/system-admin-live-detail.test.tsx`, `tests/system-admin-live-form-submit.test.tsx` | Local Fastify routes, persisted state, access control, repository wiring, and proof/dashboard data shaping. | Live Pages/Railway parity, real cookie/session round-trips, and same-student truth across roles in one run. |
| End-to-end / UI contract | `tests/academic-route-pages.test.tsx`, `tests/student-shell.test.tsx`, `tests/risk-explorer.test.tsx`, `tests/faculty-profile-proof.test.tsx`, `tests/hod-pages.test.ts`, `tests/system-admin-proof-dashboard-workspace.test.tsx`, `tests/system-admin-ui.test.tsx`, `tests/proof-surface-shell.test.tsx`, `tests/proof-surface-launcher.test.tsx`, `tests/academic-proof-summary-strip.test.tsx`, `tests/system-admin-accessibility-contracts.test.tsx`, `tests/ui-primitives-modal.test.tsx`, `tests/system-admin-faculties-workspace.test.tsx`, `tests/academic-workspace-route-surface.test.tsx`, `tests/academic-workspace-sidebar.test.tsx` | Component rendering, drilldown wiring, tab state, focus/ARIA contracts, and local proof-summary copy. | Backend truth, live credentials, production data volume, and proof-artifact freshness. |
| Smoke | `scripts/playwright-smoke.sh`, `scripts/playwright-admin-live-acceptance.sh`, `scripts/playwright-admin-live-request-flow.sh`, `scripts/playwright-admin-live-teaching-parity.sh`, `scripts/playwright-admin-live-accessibility-regression.sh`, `scripts/playwright-admin-live-keyboard-regression.sh`, `scripts/playwright-admin-live-session-security.sh`, `scripts/playwright-admin-live-proof-risk-smoke.sh`, `scripts/system-admin-live-acceptance.mjs`, `scripts/system-admin-live-request-flow.mjs`, `scripts/system-admin-live-teaching-parity.mjs`, `scripts/system-admin-live-accessibility-regression.mjs`, `scripts/system-admin-live-keyboard-regression.mjs`, `scripts/system-admin-live-session-security.mjs`, `scripts/system-admin-proof-risk-smoke.mjs` | Entry-point wiring, preview/server startup, and narrow happy-path acceptance when the live stack is actually run. | Exhaustive semantics, cross-role parity, and artifact credibility unless the smoke runs against live Pages/Railway with captured outputs. |
| Closeout | `scripts/verify-final-closeout-live.sh`, `tests/verify-final-closeout-live.test.ts`, `scripts/verify-final-closeout.sh` | Orchestration order, required preconditions, and fail-fast gating around the final closeout chain. | Live product correctness, fallback provenance, and auth/session parity unless the live chain succeeds end to end. |
| Deploy-verification | `tests/railway-deploy-readiness.test.ts`, `scripts/check-railway-deploy-readiness.mjs`, `tests/frontend-startup-diagnostics.test.ts` | Environment contracts, origin/header expectations, session-contract retry behavior, and startup diagnostics. | Actual browser workflows, same-student truth across surfaces, and the live user experience. |
| Script behavior / evidence promotion | `scripts/*`, `air-mentor-api/scripts/*` | Invocation path, wrapper mode, artifact generation, and promotion semantics for live auth, Railway recovery, seeded runtime, parity fixtures, detached jobs, and closeout bundles. | Live semantic truth, freshness, and whether green output is local-seeded or stale evidence. |
| Manual-only | `audit-map/25-accounts-routing/manual-action-required.md`, `audit-map/29-status/audit-air-mentor-ui-bootstrap-test-gap-pass.status`, `audit-map/30-checkpoints/audit-air-mentor-ui-bootstrap-test-gap-pass.checkpoint` | Required human gates, resumable runtime state, and account/provider decisions that cannot be proven in the local test harness. | Product semantics; manual steps are prerequisites, not proof of correctness. |

## Test Gap Entries

### T-001: Cross-role same-student truth
- Surface or workflow: mentor, course leader, HoD, and `SYSTEM_ADMIN` views of the same student, checkpoint, and proof summary.
- Existing tests: `air-mentor-api/tests/academic-parity.test.ts`, `air-mentor-api/tests/academic-bootstrap-routes.test.ts`, `air-mentor-api/tests/academic-proof-routes.test.ts`, `air-mentor-api/tests/student-agent-shell.test.ts`, `tests/student-shell.test.tsx`, `tests/risk-explorer.test.tsx`, `tests/faculty-profile-proof.test.tsx`, `tests/hod-pages.test.ts`, `tests/system-admin-proof-dashboard-workspace.test.tsx`, `tests/academic-route-pages.test.tsx`, `tests/academic-workspace-route-surface.test.tsx`, `tests/academic-workspace-route-helpers.test.ts`, `tests/academic-role-sync.test.ts`.
- Assertions currently proven: each surface can render or route a proof-scoped view; local fixtures can keep counts, labels, and drilldowns aligned within a single role-specific path.
- Missing semantic parity checks: one shared fixture that proves the same student truth across all four roles after role switches, checkpoint switches, and remounts.
- Missing role parity checks: explicit mentor vs course leader vs HoD vs `SYSTEM_ADMIN` comparison for the same student and the same checkpoint.
- Missing state-variant checks: active-run changes, stale checkpoint restoration, role refresh after page fallback, and remount after navigation.
- Missing live-vs-local checks: no live Pages/Railway run proves the same student truth on the deployed stack.
- Missing ML or proof credibility checks: the proof summary copy and band-only/warning semantics are locally asserted, but no test compares the same provenance labels when the active proof artifact changes.
- Live-only risk: the UI can appear consistent in isolated fixtures while deployed auth, session, or backing data diverges.
- Suggested test type: shared-fixture integration test plus a credentialed Playwright live parity flow.
- Evidence: `air-mentor-api/tests/academic-parity.test.ts`, `air-mentor-api/tests/student-agent-shell.test.ts`, `tests/student-shell.test.tsx`, `tests/risk-explorer.test.tsx`, `tests/faculty-profile-proof.test.tsx`, `tests/hod-pages.test.ts`, `tests/system-admin-proof-dashboard-workspace.test.tsx`.
- Confidence: high.

### T-002: Admin request transition parity
- Surface or workflow: system admin request queue, request detail, and mutation controls for `Needs Info`, `Rejected`, `Take Review`, `Approve`, `Mark Implemented`, and `Close`.
- Existing tests: `air-mentor-api/tests/admin-foundation.test.ts`, `air-mentor-api/tests/admin-control-plane.test.ts`, `tests/system-admin-live-data.test.ts`, `tests/system-admin-live-detail.test.tsx`, `tests/system-admin-live-form-submit.test.tsx`, `tests/system-admin-ui.test.tsx`, `tests/verify-final-closeout-live.test.ts`.
- Assertions currently proven: the backend supports the full request lifecycle and audit trail; the visible UI path is status-driven and can progress through the currently implemented controls.
- Missing semantic parity checks: UI assertions for the backend-supported `Needs Info` and `Rejected` transitions, plus confirmation that all request notes and transitions remain visible after each state change.
- Missing role parity checks: explicit comparison of what `SYSTEM_ADMIN` can do versus what HoD-backed request creation can see and mutate.
- Missing state-variant checks: stale version conflicts, rejected-to-reopened paths, information-request loops, and audit note ordering after multiple transitions.
- Missing live-vs-local checks: no live Playwright request-flow run proves the deployed controls match the backend transition set.
- Missing ML or proof credibility checks: none directly, but the request queue is a trust surface and should keep audit note order and status transitions deterministic.
- Live-only risk: the product can silently hide supported transitions in production even when the backend remains capable.
- Suggested test type: backend/UI parity test plus live request-flow Playwright coverage.
- Evidence: `src/system-admin-live-app.tsx`, `air-mentor-api/src/modules/admin-requests.ts`, `air-mentor-api/tests/admin-foundation.test.ts`, `air-mentor-api/tests/admin-control-plane.test.ts`, `tests/system-admin-live-data.test.ts`, `tests/system-admin-live-detail.test.tsx`, `tests/system-admin-live-form-submit.test.tsx`.
- Confidence: high.

### T-003: Proof playback and ML credibility freshness
- Surface or workflow: proof playback, proof-dashboard diagnostics, proof-risk training/evaluation, and checkpoint activation.
- Existing tests: `tests/proof-playback.test.ts`, `tests/proof-pilot.test.ts`, `tests/proof-risk-semester-walk.test.ts`, `tests/system-admin-proof-dashboard-workspace.test.tsx`, `air-mentor-api/tests/proof-control-plane-checkpoint-service.test.ts`, `air-mentor-api/tests/proof-control-plane-access.test.ts`, `air-mentor-api/tests/proof-queue-governance.test.ts`, `air-mentor-api/tests/proof-risk-model.test.ts`, `air-mentor-api/tests/evaluate-proof-risk-model.test.ts`, `air-mentor-api/tests/policy-phenotypes.test.ts`, `air-mentor-api/tests/admin-proof-observability.test.ts`, `air-mentor-api/tests/student-agent-shell.test.ts`, `tests/student-shell.test.tsx`, `tests/risk-explorer.test.tsx`, `tests/academic-parity.test.ts`.
- Assertions currently proven: deterministic training on governed manifest rows, support gating, local checkpoint activation/restore, queue summaries, and proof-dashboard tab/scroll behavior.
- Missing semantic parity checks: live artifact freshness, challenger-vs-production divergence, and fallback frequency in the deployed stack.
- Missing role parity checks: the same proof checkpoint is not verified across admin, faculty, mentor, and student surfaces in one live flow.
- Missing state-variant checks: production artifact present vs absent, checkpoint switch after remount, active run replacement, and runtime-governed fallback-heavy mode.
- Missing live-vs-local checks: no live proof-risk smoke currently proves the deployed artifacts match the local DB-backed artifact family.
- Missing ML or proof credibility checks: probability suppression, band-only output, calibration warnings, and provenance labels are locally tested but not revalidated against a fresh live artifact set.
- Live-only risk: a green local suite can still mask stale, fallback-heavy, or partially promoted live proof behavior.
- Suggested test type: deploy-verification with artifact checksum comparison plus live proof-risk smoke.
- Evidence: `air-mentor-api/src/lib/proof-risk-model.ts`, `air-mentor-api/tests/proof-risk-model.test.ts`, `air-mentor-api/tests/evaluate-proof-risk-model.test.ts`, `air-mentor-api/tests/policy-phenotypes.test.ts`, `tests/system-admin-proof-dashboard-workspace.test.tsx`, `tests/proof-playback.test.ts`, `tests/proof-pilot.test.ts`, `tests/proof-risk-semester-walk.test.ts`, `air-mentor-api/tests/admin-proof-observability.test.ts`.
- Confidence: high.

### T-004: Live Pages/Railway auth and session contract
- Surface or workflow: credentialed live login, session restore, live acceptance smoke, and final closeout orchestration.
- Existing tests: `tests/railway-deploy-readiness.test.ts`, `tests/verify-final-closeout-live.test.ts`, `tests/live-admin-common.test.ts`, `tests/frontend-startup-diagnostics.test.ts`, `tests/compat-route-inventory.test.ts`.
- Assertions currently proven: the wrappers fail fast on missing credentials, the preflight sequence is ordered, startup diagnostics flag bad API origins, and the route inventory is clean.
- Missing semantic parity checks: real live session round-trips against Pages + Railway, not just stubbed command sequencing.
- Missing role parity checks: live `SYSTEM_ADMIN`, HoD, teaching, and proof routes are still unverified as a set.
- Missing state-variant checks: browser-side cookie reuse, CSRF refresh, and live-origin handling across multiple tab loads.
- Missing live-vs-local checks: the current live baseline still records a `404` on `/health`, so local readiness cannot substitute for live proof.
- Missing ML or proof credibility checks: live proof-risk artifact freshness still depends on the later live-behavior pass.
- Live-only risk: local green wrappers can still hide a broken deployment or a stale session contract.
- Suggested test type: credentialed Playwright live acceptance plus manual-only credentialed verification when automation cannot complete the login flow.
- Evidence: `scripts/verify-final-closeout-live.sh`, `scripts/check-railway-deploy-readiness.mjs`, `scripts/playwright-admin-live-acceptance.sh`, `scripts/playwright-admin-live-request-flow.sh`, `scripts/playwright-admin-live-teaching-parity.sh`, `scripts/playwright-admin-live-accessibility-regression.sh`, `scripts/playwright-admin-live-keyboard-regression.sh`, `scripts/playwright-admin-live-session-security.sh`, `audit-map/10-live-behavior/deployment-drift-log.md`.
- Confidence: high.

### T-005: Accessibility and UX density under real data
- Surface or workflow: modal dialogs, proof launchers, proof summary strips, admin tabs, and the dense proof/workspace rail.
- Existing tests: `tests/system-admin-accessibility-contracts.test.tsx`, `tests/ui-primitives-accessibility-contracts.test.tsx`, `tests/ui-primitives-modal.test.tsx`, `tests/system-admin-ui.test.tsx`, `tests/proof-surface-shell.test.tsx`, `tests/proof-surface-launcher.test.tsx`, `tests/academic-proof-summary-strip.test.tsx`, `tests/faculty-profile-proof.test.tsx`, `tests/system-admin-proof-dashboard-workspace.test.tsx`.
- Assertions currently proven: tab linkage, focus trap, contrast threshold, launcher open/close behavior, keyboard focusability, and local proof-summary labels.
- Missing semantic parity checks: no test proves that the wording stays understandable when counts are stale, fallback-heavy, or contradictory across surfaces.
- Missing role parity checks: real mentor/HoD/course-leader/super-admin users under load are not compared for comprehension or navigation friction.
- Missing state-variant checks: large queue counts, mixed production/runtime diagnostics, and repeated tab remounts under real data volume.
- Missing live-vs-local checks: no live keyboard/accessibility regression has been run on the deployed app yet.
- Missing ML or proof credibility checks: support warnings and probability-suppression language are static contract assertions, not live-validated explanations.
- Live-only risk: a layout can satisfy ARIA and focus rules while still being too dense or misleading for production-scale use.
- Suggested test type: live or preview Playwright accessibility/keyboard regression plus a UX friction pass.
- Evidence: `tests/system-admin-accessibility-contracts.test.tsx`, `tests/ui-primitives-accessibility-contracts.test.tsx`, `tests/ui-primitives-modal.test.tsx`, `tests/system-admin-ui.test.tsx`, `tests/proof-surface-shell.test.tsx`, `tests/proof-surface-launcher.test.tsx`, `tests/academic-proof-summary-strip.test.tsx`, `tests/faculty-profile-proof.test.tsx`.
- Confidence: medium.

### T-006: System admin search and hidden-record visibility parity
- Surface or workflow: admin search, registry filtering, hierarchy visibility, and hidden-record drilldowns.
- Existing tests: `tests/system-admin-live-data.test.ts`, `tests/system-admin-live-detail.test.tsx`, `tests/system-admin-overview-helpers.test.ts`, `tests/system-admin-faculties-workspace.test.tsx`, `tests/system-admin-proof-dashboard-workspace.test.tsx`.
- Assertions currently proven: local search/filter helpers, scope labels, hierarchy upserts, and proof-dashboard summary derivations.
- Missing semantic parity checks: live search results for students, faculty, requests, hidden records, and proof hierarchy are not rechecked against deployed data.
- Missing role parity checks: the same search query under `SYSTEM_ADMIN` versus faculty-backed drilldowns is not compared in one live flow.
- Missing state-variant checks: archived rows, hidden rows, and scope drift after admin edits are not validated live.
- Missing live-vs-local checks: the current live admin surface is still pending, so local search behavior can drift from actual deployed data.
- Missing ML or proof credibility checks: proof-dashboard search and proof route labels can look stable while the backing proof artifact posture changes.
- Live-only risk: a green local search helper can still route into stale or inaccessible entities in production.
- Suggested test type: seeded integration plus live Playwright search workflow.
- Evidence: `src/system-admin-live-data.ts`, `tests/system-admin-live-data.test.ts`, `tests/system-admin-live-detail.test.tsx`, `tests/system-admin-overview-helpers.test.ts`, `tests/system-admin-faculties-workspace.test.tsx`, `tests/system-admin-proof-dashboard-workspace.test.tsx`.
- Confidence: medium.

### T-007: Script success versus semantic truth
- Surface or workflow: live auth helpers, Railway readiness/recovery, parity-seed generation, seeded runtime harness, proof-risk evaluation, detached closeout promotion, and wrapper-driven closeout scripts.
- Existing tests: `tests/railway-deploy-readiness.test.ts`, `tests/verify-final-closeout-live.test.ts`, `tests/live-admin-common.test.ts`, `tests/frontend-startup-diagnostics.test.ts`, `tests/proof-risk-semester-walk.test.ts`, `air-mentor-api/tests/proof-risk-model.test.ts`, `air-mentor-api/tests/evaluate-proof-risk-model.test.ts`.
- Assertions currently proven: wrappers enforce env gating and the scripts emit expected artifacts in seeded or local modes.
- Missing semantic parity checks: a script can succeed while promoting stale bundles, excluding proof-rc by default, or leaving deployed truth unresolved.
- Missing role parity checks: live admin/teacher/HoD/mentor/student proof remains unobserved when driven by script wrappers alone.
- Missing state-variant checks: sync-mode Railway var mutation, detached completion after tmux exit, and recovery-chain partial success.
- Missing live-vs-local checks: no live credentialed replay proves the script chain matches deployed truth end to end.
- Missing ML or proof credibility checks: proof-risk freshness and parity-seed consumer freshness remain outside script-success evidence.
- Live-only risk: green script output can still overstate closeout confidence or mask deployment drift.
- Suggested test type: artifact-diff validation plus credentialed live replay or explicit blocked-report capture.
