# State Flow: Runtime Shadow Conflict and Drift

- Flow name: Academic runtime shadow persistence, compatibility routes, conflict checks, and drift emission
- Context or scope: Backend runtime routes for tasks, task placements, and calendar audit shadow synchronization and conflict-aware persistence.
- Start and precondition states: authenticated academic runtime request; entity either absent (`create`) or present (`update`).
- Trigger: create/update/delete task or placement; calendar audit append; compatibility sync route usage.
- Guards: `expectedVersion` and `expectVersion` checks for tasks/meetings; `expectedUpdatedAt` checks for placements; ownership/scope access checks in runtime auth.
- Intermediate states: `validated`, `persisted-primary`, `shadow-sync-attempted`, `shadow-synced`, `compatibility-route-warning`.
- Async or background transitions: drift emission via operational event (`academic.runtime.shadow_drift`) when runtime shadow diverges; compatibility route header/link signaling for successor migration.
- Invalid or conflict states: stale version conflict; stale updatedAt conflict; duplicate audit event payload mismatch.
- Error states: `badRequest` for invalid expected-version usage, `conflict` for stale entity writes, `forbidden` and `notFound` for access/scope failures.
- Restore or re-entry states: compatibility routes (`/sync`) remain available for legacy callers and map to authoritative endpoints.
- Terminal states: persisted entity with incremented version; rejected mutation with explicit conflict payload.
- Recovery path: caller re-fetches current entity/version timestamps and retries mutation with updated conflict tokens.
- Observed drift: drift detection is implemented and evented locally; live drift frequency remains unverified without live telemetry pull.
- Evidence: `air-mentor-api/src/modules/academic-runtime-routes.ts:34`, `air-mentor-api/src/modules/academic-runtime-routes.ts:92`, `air-mentor-api/src/modules/academic-runtime-routes.ts:103`, `air-mentor-api/src/modules/academic-runtime-routes.ts:112`, `air-mentor-api/src/modules/academic-runtime-routes.ts:191`, `air-mentor-api/src/modules/academic-runtime-routes.ts:203`, `air-mentor-api/src/modules/academic-runtime-routes.ts:256`, `air-mentor-api/src/modules/academic-runtime-routes.ts:397`, `air-mentor-api/src/modules/academic-runtime-routes.ts:398`, `air-mentor-api/src/modules/academic-runtime-routes.ts:476`, `air-mentor-api/src/modules/academic-runtime-routes.ts:633`, `air-mentor-api/src/modules/academic-runtime-routes.ts:691`, `air-mentor-api/src/modules/academic-runtime-routes.ts:771`, `src/repositories.ts`, `air-mentor-api/tests/admin-foundation.test.ts`.
- Confidence: High for local backend guard/transition behavior; medium for live drift/worker-operational parity.
