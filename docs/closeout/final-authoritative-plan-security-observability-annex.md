# Final Authoritative Plan Security And Observability Annex

## Status
- Stage `00B` backbone support doc is now populated from current repo truth instead of a stub.
- Stage `08C` still has to attach the final local/live closeout artifact references and pass row before this annex is fully sealed.

## Scope
- This annex is the closeout-wide contract for auth, session, CSRF, role-boundary enforcement, startup/readiness diagnostics, operational telemetry, and evidence redaction.
- It is not the source of product behavior by itself. The owning code and tests remain authoritative; this document records the contract they currently implement.

## Repo Truth Anchors
- `docs/closeout/final-authoritative-plan.md`
- `docs/closeout/stage-gate-protocol.md`
- `docs/closeout/assertion-traceability-matrix.md`
- `air-mentor-api/src/app.ts`
- `air-mentor-api/src/modules/session.ts`
- `air-mentor-api/src/startup-diagnostics.ts`
- `src/startup-diagnostics.ts`
- `air-mentor-api/src/lib/telemetry.ts`
- `src/telemetry.ts`
- `air-mentor-api/src/modules/client-telemetry.ts`
- `air-mentor-api/src/lib/proof-run-queue.ts`

## Security Contract
### Session and cookie posture
- The backend owns session and CSRF cookies through `air-mentor-api/src/modules/session.ts`.
- Live cross-origin operation is guarded by `air-mentor-api/src/startup-diagnostics.ts`:
  - `GITHUB_PAGES_REQUIRES_SAMESITE_NONE`
  - `PRODUCTION_LIKE_REQUIRES_SECURE_COOKIE`
  - `CSRF_SECRET_REQUIRED`
- The frontend startup gate in `src/startup-diagnostics.ts` rejects production-like Pages origins unless the API base URL is absolute, remote, and HTTPS.
- `scripts/verify-final-closeout-live.sh` and `scripts/check-railway-deploy-readiness.mjs` are the canonical live verification entrypoints for this contract.

### Origin and CSRF enforcement
- `air-mentor-api/src/app.ts` rejects mutating requests from missing or non-allowlisted origins with `security.forbidden_origin`.
- The same hook rejects authenticated writes without a valid CSRF header/cookie pair with `security.csrf.rejected`.
- `/api/client-telemetry` is intentionally exempted from the CSRF gate in `air-mentor-api/src/app.ts` because it is a fire-and-forget telemetry relay, not an authenticated mutation surface.

### Auth lifecycle events
- `air-mentor-api/src/modules/session.ts` emits explicit operational events for:
  - `auth.login.rate_limited`
  - `auth.login.failed`
  - `auth.login.succeeded`
  - `auth.session.restored`
  - `auth.logout.succeeded`
  - `auth.role_context.switched`
- These events are part of operator diagnostics, not user-facing audit history.

### Role-boundary expectations
- `SYSTEM_ADMIN`, `HOD`, `COURSE_LEADER`, and `MENTOR` all rely on the same session contract, but proof and academic access rules remain role-scoped in the owning route/services.
- Negative-path proof remains mandatory for:
  - out-of-scope student or faculty access
  - invalid checkpoint selection
  - forbidden origin
  - missing or mismatched CSRF
  - non-admin access to sysadmin routes
- The stage backbone records these as first-class artifacts instead of leaving them implied by happy-path runs.

## Observability Contract
### Startup diagnostics
- Backend startup diagnostics are produced by `air-mentor-api/src/startup-diagnostics.ts` and emitted from `air-mentor-api/src/index.ts` as:
  - `startup.diagnostic`
  - `startup.ready`
- Frontend startup diagnostics are produced by `src/startup-diagnostics.ts` and emitted from the live shells as:
  - `startup.diagnostic`
  - `startup.ready`
- The readiness contract is broader than `/health`; it includes cookie posture, frontend origin/API alignment, and telemetry-sink posture.

### Operational telemetry
- Backend operational events are normalized and sanitized through `air-mentor-api/src/lib/telemetry.ts`.
- Client operational events are normalized through `src/telemetry.ts` and may be relayed through `/api/client-telemetry`.
- Proof queue worker state is surfaced through `air-mentor-api/src/lib/proof-run-queue.ts`:
  - `proof.run.queued`
  - `proof.run.requeued`
  - `proof.run.claimed`
  - `proof.run.executed`
  - `proof.run.failed`
- Proof playback and proof-surface readiness events are surfaced client-side from `src/system-admin-live-app.tsx` and `src/App.tsx`, including:
  - `proof.checkpoint.readiness`
  - `proof.checkpoint.detail_load_failed`
  - `proof.playback.restored`
  - `proof.playback.invalidated`
  - `proof.playback.inaccessible`

### Client telemetry relay
- `/api/client-telemetry` accepts only `airmentor-client-event` payloads validated by Zod in `air-mentor-api/src/modules/client-telemetry.ts`.
- Invalid client telemetry raises `client.telemetry.invalid`.
- Accepted client telemetry is persisted via `persistOperationalEvent(...)` and acknowledged with `client.telemetry.received`.
- Relay to an external sink is optional and must not block the request path.

## Redaction And Data Handling Rules
- `air-mentor-api/src/lib/telemetry.ts` sanitizes unknown payloads to bounded serializable shapes and strips non-serializable runtime objects.
- `src/telemetry.ts` and `air-mentor-api/src/lib/telemetry.ts` both treat sink failures as secondary warning events rather than dumping raw request objects.
- Raw passwords, session cookies, CSRF tokens, bearer tokens, provider secrets, and prompt payloads must not be written into:
  - telemetry payloads
  - execution-ledger `env`
  - evidence index command strings
  - closeout support docs
- Closeout helpers and docs should use placeholders such as `<identifier>`, `<password>`, and `<redacted>` when recording live commands.

## Verification Anchors
- Backend startup diagnostics: `air-mentor-api/tests/startup-diagnostics.test.ts`
- Frontend startup diagnostics: `tests/frontend-startup-diagnostics.test.ts`
- Backend telemetry normalization/persistence/relay: `air-mentor-api/tests/telemetry.test.ts`, `air-mentor-api/tests/telemetry-sink.test.ts`, `air-mentor-api/tests/client-telemetry.test.ts`
- Session/auth/CSRF/origin behavior: `air-mentor-api/tests/session.test.ts`
- Live deploy/readiness wrapper contract: `tests/railway-deploy-readiness.test.ts`, `tests/verify-final-closeout-live.test.ts`

## 08C Seal Requirements
- The final `08C` pass must reference:
  - the final local closeout bundle
  - the final live closeout bundle
  - the live session-contract output
  - the completed assertion and coverage matrices
  - the append-only ledger row
- Until those references are written into the proof backbone, this annex is complete in substance but not yet fully sealed.
