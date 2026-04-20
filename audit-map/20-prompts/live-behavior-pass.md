# Live Behavior Pass Prompt v2.0

Objective: compare scoped live behavior against local implementation, test claims, and audit assumptions with route-by-route and state-family evidence.

Required outputs:

- live-behavior entries using `templates/live-behavior-template.md`
- live artifacts for each tested route or endpoint family: screenshots, traces, HTML or JSON captures, network evidence where possible
- mismatch matrix entries between local expectation and live observation
- contradictions logged immediately

Rules:

- do not trust stale docs over fresh live evidence
- capture route, role, session, and state context for each live observation
- test more than happy paths when credentials and environment allow
- explicitly label observations as directly observed, inferred, or not yet verified
- record fallback-heavy behavior, stale deployment signals, auth/session/origin behavior, and route/refresh drift

Completion gate:

- live verification is not complete until each scoped route or endpoint family has either direct live evidence or an explicit credential or environment blocker
