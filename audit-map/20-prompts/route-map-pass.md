# Route Map Pass Prompt v2.0

Objective: exhaustively map every route-like entry point in the scoped surface, including URL routes, hash routes, helper-generated routes, internal page-state routes, deep links, redirects, guards, restore-on-refresh behavior, query/hash state, modal-triggered routes, and route-conditioned subviews.

Required inputs:

- current route index and inventory
- `23-coverage/coverage-ledger.md`
- `24-agent-memory/known-facts.md`
- `14-reconciliation/contradiction-matrix.md`

Required outputs:

- route entries using `templates/route-entry-template.md` or equivalent route tables
- explicit canonical routes, redirect routes, dynamic routes, guarded routes, and hidden entry points
- route-affecting state sources: query params, hash fragments, localStorage/sessionStorage restore, cookies, feature flags, auth/session state, bootstrap payloads
- local versus live route notes and contradictions

Exhaustiveness rules:

- discover routes from code, tests, helper functions, generated links, navigation handlers, and live observations
- map nested routes and route-conditioned panels/tabs/modals separately when they change visible behavior
- record params, query fields, and deep-link tokens explicitly
- include landing redirects, unauthorized fallbacks, missing-data fallbacks, and route restoration behavior
- if the app uses internal page IDs instead of URL segments, treat each stable page state as a route family
- do not stop after top-level nav; follow drilldowns, search result links, notifications, audit links, row-click handlers, and helper-generated destinations

Completion gate:

- coverage is not complete until every discovered route family has an owner, entry path, guard story, state source, and evidence path
- if any route-like surface is only partially mapped, log it in coverage and ambiguities before ending
