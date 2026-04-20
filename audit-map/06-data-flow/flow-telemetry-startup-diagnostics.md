# Flow: Telemetry and Startup Diagnostics

## Authoritative Sources

- `src/startup-diagnostics.ts`
- `src/telemetry.ts`
- `air-mentor-api/src/modules/client-telemetry.ts`
- `air-mentor-api/src/lib/telemetry.ts`
- `air-mentor-api/src/lib/operational-event-store.ts`
- `air-mentor-api/src/app.ts`

## Entry Triggers And Producers

- Frontend startup path emits diagnostics and telemetry events during app boot and route lifecycle.
- Frontend telemetry helpers produce structured client event payloads.
- Backend telemetry module receives client telemetry ingestion requests.
- Backend telemetry/event-store libraries persist or forward operational telemetry records.

## Transformations And Derivations

- Raw frontend diagnostic context is transformed into normalized event envelopes.
- Backend module validates and maps client telemetry into operational-event persistence shape.
- Operational store derives queryable event records used by diagnostics and observability consumers.

## Caches, Shadows, Snapshots, Persistence Boundaries

- Frontend transient buffer/state during startup and send attempts.
- API boundary between client telemetry emitter and backend ingestion route.
- Backend persistence boundary in operational event storage.

## Readers And Consumers

- Startup diagnostic surfaces and internal debug/observability consumers.
- Backend telemetry readers and any operational reporting that consumes stored events.

## Failure And Fallback Branches

- Frontend telemetry send failures degrade to best-effort/no-block behavior for user flows.
- Backend ingestion failures avoid blocking primary app behavior and rely on operational logging paths.
- Partial event payloads are normalized or dropped per backend validation contract.

## Restore And Replay Paths

- Startup diagnostics rerun on each application startup lifecycle.
- Operational event persistence allows later replay/inspection of captured telemetry sequences.

## Drift And Staleness Risks

- Schema drift between frontend event payloads and backend route expectations.
- Event-store backlog or retention changes can affect diagnostic time-window completeness.
- Startup diagnostics can underreport if initialization order changes without telemetry updates.

## Evidence Anchors

- `src/startup-diagnostics.ts`
- `src/telemetry.ts`
- `air-mentor-api/src/modules/client-telemetry.ts`
- `air-mentor-api/src/lib/telemetry.ts`
- `air-mentor-api/src/lib/operational-event-store.ts`
- `air-mentor-api/src/app.ts`
- `tests/frontend-startup-diagnostics.test.ts`
- `tests/frontend-telemetry.test.ts`
