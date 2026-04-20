# Dependency Pass Prompt v2.0

Objective: map direct, hidden, behavioral, persistence, runtime, and human-process dependencies for the scoped subsystem.

Required outputs:

- dependency entries using `templates/dependency-template.md`
- compile-time, runtime, auth/session, persistence, background-worker, deployment/config, and user-state dependencies
- downstream UI and semantic impacts for every important dependency edge
- tight-coupling, drift, and failure-mode notes

Rules:

- a dependency is not just an import; include URL params, localStorage/sessionStorage, cookies, active session role, active run, checkpoint context, feature flags, env vars, cron/worker inputs, and derived state contracts
- map dependency chains from UI control to route/state context to API call to service/module to DB/worker/model to rendered effect
- record hidden couplings that can make the same surface behave differently without obvious code-local changes

Completion gate:

- every important surface in scope must have its upstream dependencies and downstream impacts represented
- unresolved dependency ambiguity must be logged explicitly, not silently skipped
