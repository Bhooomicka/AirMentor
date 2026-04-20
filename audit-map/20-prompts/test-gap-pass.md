# Test Gap Pass Prompt v2.0

Objective: compare implemented behavior to existing tests and identify semantic, cross-role, live-only, and UX verification blind spots.

Required outputs:

- test-gap entries using `templates/test-gap-template.md`
- path-to-test mappings for unit, integration, end-to-end, smoke, closeout, deploy-verification, and manual-only flows
- explicit statements of what each test family proves and what it does not prove

Rules:

- separate operability checks from semantic truth checks
- require cross-role parity analysis, negative-path coverage, state-variant coverage, and live-vs-local blind spots
- record missing assertions for downstream effects, permission drift, proof semantics, and ML credibility
- if a green test can still hide a real product-level mismatch, say so explicitly

Completion gate:

- every important scoped workflow must have either test evidence or a logged verification gap with suggested test type
