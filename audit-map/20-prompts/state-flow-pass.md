# State Flow Pass Prompt v2.0

Objective: map state transitions, guards, triggers, async/background transitions, restore states, invalid states, and terminal states for the scoped surface.

Required outputs:

- state-flow entries using `templates/state-flow-template.md`
- transition tables or equivalent state family mappings
- guard conditions, restore/re-entry behavior, and mismatch notes between intended, implemented, and live state behavior

Rules:

- include normal, empty, loading, stale, disabled, blocked, error, retry, suspended, resumed, restored, archived, and terminal states where relevant
- include async/background transitions such as polling, auto-refresh, worker completion, checkpoint restore, and role-sync redirects
- include invalid or conflict states even if they appear rare
- record where local, tested, and live state machines may diverge

Completion gate:

- every important workflow in scope must have a start state, trigger family, guard story, transition family, and recovery path
