# Flow: Academic Route, Session, and Bootstrap

## Authoritative Sources

- `src/App.tsx`
- `src/academic-session-shell.tsx`
- `src/api/client.ts`
- `src/repositories.ts`
- `air-mentor-api/src/modules/session.ts`
- `air-mentor-api/src/modules/academic-bootstrap-routes.ts`

## Entry Triggers And Producers

- Portal route/hash entry and page-level guard checks start session/bootstrap negotiation.
- Frontend API client emits bootstrap/session requests with cookie/csrf expectations.
- Backend session module resolves session principal and role-scoped access.
- Academic bootstrap routes produce role-scoped startup payloads for initial render state.

## Transformations And Derivations

- Route and query inputs are normalized into canonical academic page state.
- Session identity and role claims are transformed into permitted workspace surfaces.
- Bootstrap first checks active proof-run existence and can short-circuit into `NO_ACTIVE_PROOF_RUN`.
- Bootstrap payloads are transformed into frontend repository/view-model projections.
- `proofPlayback.currentDateISO` is transformed into frontend `proofVirtualDateISO`, then consumed by `toDueLabel(anchorISO)` and `applyPlacementToTask(..., anchorISO)` so due labels track proof virtual date.

## Caches, Shadows, Snapshots, Persistence Boundaries

- Session boundary: backend cookie/session state and CSRF expectations.
- Frontend shadow state: mounted academic shell state and route-history context.
- Restore boundary: local route/session restore behavior in shell and route helper pathways, plus proof-playback checkpoint restore and its virtual-date anchor.

## Readers And Consumers

- Academic role pages and shared workspace route surfaces.
- Course leader, mentor, and HoD page families consuming bootstrap data slices.
- Route helpers consuming role/session state to constrain navigation.

## Failure And Fallback Branches

- Session 401 or expired cookie paths trigger restore/retry and login gating behavior.
- Missing active proof run returns `403 NO_ACTIVE_PROOF_RUN`, which the academic session shell converts into an explicit gate page.
- Missing bootstrap fields force guarded rendering and fallback route normalization.
- Role mismatch routes are rejected or redirected to allowed surfaces.

## Restore And Replay Paths

- Route replay from hash/history state after reload.
- Session restore path on app startup and shell re-entry.
- Re-bootstrap on role/page transition or failed request retry.

## Drift And Staleness Risks

- Route-history restore can drift from current backend session role after long idle periods.
- Frontend cached selection/context can outlive backend scope changes.
- Session and bootstrap shape drift can break page guard assumptions.

## Evidence Anchors

- `src/App.tsx`
- `src/academic-session-shell.tsx`
- `src/api/client.ts`
- `src/repositories.ts`
- `air-mentor-api/src/modules/session.ts`
- `air-mentor-api/src/modules/academic-bootstrap-routes.ts`
- `air-mentor-api/src/modules/academic.ts`
- `tests/portal-routing.test.ts`
- `tests/academic-route-pages.test.tsx`
- `tests/academic-session-shell.test.tsx`
- `tests/domain.test.ts`
- `tests/calendar-utils.test.ts`
- `air-mentor-api/tests/gap-closure-intent.test.ts`
