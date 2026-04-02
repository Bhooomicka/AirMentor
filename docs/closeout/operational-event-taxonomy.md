# Operational Event Taxonomy

## Status
- This taxonomy reflects the event families actually emitted by the current frontend, backend, and proof-worker owners.
- Finalized for Stage `08C`.

## Scope
- This document covers operational telemetry and diagnostics.
- It is intentionally separate from user-facing audit history and business-domain records.

## Repo Truth Anchors
- `air-mentor-api/src/lib/telemetry.ts`
- `src/telemetry.ts`
- `air-mentor-api/src/index.ts`
- `air-mentor-api/src/app.ts`
- `air-mentor-api/src/modules/session.ts`
- `air-mentor-api/src/modules/client-telemetry.ts`
- `air-mentor-api/src/lib/proof-run-queue.ts`
- `air-mentor-api/src/modules/academic-bootstrap-routes.ts`
- `air-mentor-api/src/modules/academic-runtime-routes.ts`
- `src/system-admin-live-app.tsx`
- `src/App.tsx`

## Event Families
| Family | Current Event Names | Owning Runtime | Required Context |
| --- | --- | --- | --- |
| Startup diagnostics | `startup.diagnostic`, `startup.ready` | backend and frontend | mode, origin/API posture, telemetry-sink posture, host/port or workspace |
| Session/auth | `auth.login.rate_limited`, `auth.login.failed`, `auth.login.succeeded`, `auth.session.restored`, `auth.logout.succeeded`, `auth.role_context.switched`, `auth.session.restore_failed` | backend plus client shells | role, user/faculty/session identifiers, failure reason, restore outcome |
| Security guardrails | `security.forbidden_origin`, `security.csrf.rejected` | backend request hook | method, route, origin, failure reason |
| Client telemetry relay | `client.telemetry.invalid`, `client.telemetry.received`, `telemetry.sink_failed`, `telemetry.persistence_failed` | backend relay plus shared telemetry utilities | source, event name, sink target, normalized error |
| Proof queue worker | `proof.run.queued`, `proof.run.requeued`, `proof.run.claimed`, `proof.run.executed`, `proof.run.failed` | backend proof worker | simulation run id, batch id, lease token, requested activation, failure payload |
| Proof playback/readiness | `proof.checkpoint.readiness`, `proof.checkpoint.detail_load_failed`, `proof.playback.restored`, `proof.playback.invalidated`, `proof.playback.inaccessible` | system-admin live shell and academic shell | simulation run id, checkpoint id, semester/stage label, blocked/accessibility posture |
| Academic/bootstrap | `academic.bootstrap.loaded`, `academic.bootstrap.load_failed`, `academic.runtime.shadow_drift` | backend bootstrap/runtime plus client shells | route/workspace context, normalized failure data, drift details |
| Curriculum linkage | `curriculum.linkage.regenerated`, `curriculum.linkage.regeneration_failed`, `curriculum.linkage.approved`, `curriculum.linkage.approval_failed`, `curriculum.proof_refresh.enqueue_failed` | backend admin structure plus system-admin live shell | linkage profile/version ids, approval or failure outcome |
| Request error surface | `request.error` | backend global error handler | method, route, status code, normalized error |
| Proof-surface load failures | `proof.faculty_profile.load_failed`, `proof.analytics.load_failed`, `proof.student_shell.load_failed`, `proof.student_timeline.load_failed`, `proof.risk_explorer.load_failed` | academic shell | surface name, active proof context, normalized error |

## Taxonomy Rules
### Operational events must include
- stable `name`
- `level`
- `timestamp`
- bounded `details`

### Correlation fields that should appear whenever available
- `simulationRunId`
- `simulationStageCheckpointId`
- `semesterNumber`
- `scopeType`
- `scopeId`
- `facultyId`
- `studentId`
- `sessionId`
- `requestId`

### Redaction rules
- Do not log:
  - raw passwords
  - session cookie values
  - CSRF token values
  - bearer tokens
  - provider secrets
  - raw prompt/model payloads
- Errors are normalized through `sanitizeValue(...)` in `air-mentor-api/src/lib/telemetry.ts` or `normalizeClientTelemetryError(...)` in `src/telemetry.ts`.
- Client telemetry relay must persist normalized event details, not arbitrary request bodies.

## Audit vs Telemetry Boundary
- Audit history is for user/business mutations such as approvals, overrides, provisioning, and bulk mentor assignment.
- Operational telemetry is for runtime posture, readiness, queue state, failures, and closeout verification flow.
- Some workflows may produce both:
  - audit evidence for the mutation
  - operational telemetry for queueing, proof refresh, or failure handling
- The telemetry side must remain redaction-safe even when the underlying workflow is security-sensitive.

## Verification Anchors
- Backend telemetry behavior: `air-mentor-api/tests/telemetry.test.ts`, `air-mentor-api/tests/telemetry-sink.test.ts`
- Client telemetry relay: `air-mentor-api/tests/client-telemetry.test.ts`, `tests/frontend-telemetry.test.ts`
- Startup diagnostics: `air-mentor-api/tests/startup-diagnostics.test.ts`, `tests/frontend-startup-diagnostics.test.ts`
- Live wrapper/readiness expectations: `tests/verify-final-closeout-live.test.ts`, `tests/railway-deploy-readiness.test.ts`

## 08C Seal Requirements
- Finalized for Stage `08C`.
- The final `08C` pass now points this taxonomy at the final live closeout artifact bundle, the live session-contract artifact, and the final ledger row.
