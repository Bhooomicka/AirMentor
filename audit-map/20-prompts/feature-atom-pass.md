# Feature Atom Pass Prompt v2.0

Objective: decompose the scoped product surface into genuinely atomic interactions and stateful behaviors using `templates/feature-template.md`.

Required outputs:

- one filled feature entry per bounded feature atom or interaction family
- explicit preconditions, triggers, transitions, success paths, failure paths, retry paths, restore paths, and downstream effects
- control-level detail for buttons, dropdowns, filters, tabs, tables, row actions, modals, search, hover affordances, keyboard actions, background refresh, auto-selection, and replay/restore behavior
- expected, implemented, tested, and live behavior notes per atom whenever evidence exists

Atomicity rules:

- do not collapse multiple workflows into one entry
- split features by control/state variant when the behavior changes materially
- include empty, loading, stale, partial, disabled, locked, error, success, retry, saved, restored, and conflict states
- include hover-only, keyboard-only, and automatic/system-triggered behavior
- include same-control different-state variants separately when they imply different writes, visibility, or downstream effects

Evidence rules:

- tie every atom to concrete source files, handlers, backend calls, persistence paths, and tests when available
- if the same visible feature behaves differently by role, route, active run, or checkpoint context, record separate variants

Completion gate:

- the feature registry is not complete until every reachable control family in the scoped surface is represented or explicitly logged as missing evidence
