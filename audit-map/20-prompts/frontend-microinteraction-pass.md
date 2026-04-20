# Frontend Microinteraction Pass Prompt v2.0

Objective: map the frontend below feature-family level until important interactive components, hidden state paths, and downstream consequences are explicitly captured.

Primary scope:

- `src/` route trees
- shared component clusters
- tables, cards, filters, tabs, drawers, dialogs, banners, toasts
- hooks, stores, contexts, restore helpers, local/session storage usage
- replay, playback, comparison, pagination, sorting, selection, retry, empty, loading, and error states

Explicit closure targets (must cover if present):

- proof provenance / count-source explanation surfaces (where wording and counts are formed; prove cross-role reuse vs divergence)
- proof playback lifecycle UI triggers (reset/delete/rebuild flows, checkpoint navigation invalidation, restore behavior)
- telemetry + startup diagnostics UI pathways (where sent, what user sees, what is silent)

Required outputs:

- component-cluster interaction files or equivalent durable registry entries
- updates to `feature-registry.md`, `role-feature-matrix.md`, `dependency-graph.md`, `data-flow-map.md`, `state-flow-map.md`
- newly discovered blocker entries for any component clusters or interaction families that were not previously covered
- coverage updates proving which `src/` areas are now mapped versus still partial

Rules:

- do not stop at routed pages; go into shared and reused components
- capture trigger, visible effect, local state change, persisted state change, API consequence, downstream UI consequence, and role restriction
- record empty/loading/error/retry/restore behavior wherever applicable
- distinguish family-level understanding from actual component-level interaction mapping
- if a component appears across multiple roles or surfaces, record reuse and divergence explicitly
- where the same "count" or "status" is displayed across pages, trace the actual source field(s) and any transforms

Completion gate:

- this pass is not complete until important interactive component families are mapped below family-summary level and any still-thin clusters are explicitly logged as new blockers with evidence
