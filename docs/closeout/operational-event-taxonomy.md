# Operational Event Taxonomy

## Status
- Stage `00B` stub created.
- Content is intentionally limited to the current telemetry anchors and completion ownership for later stages.

## Purpose
- Hold the authoritative event-family taxonomy for operational telemetry and its separation from audit records.
- Give later stages a single document target for event naming, payload boundaries, and closeout verification references.

## Consumers
- Engineers touching frontend or backend telemetry
- Operators reviewing readiness and degraded-state diagnostics
- Reviewers reconciling telemetry artifacts with the closeout proof pack

## Repo Truth Anchors
- `docs/closeout/final-authoritative-plan.md`
- `docs/closeout/assertion-traceability-matrix.md`
- `air-mentor-api/src/lib/telemetry.ts`
- `air-mentor-api/src/modules/client-telemetry.ts`
- `src/telemetry.ts`

## Required Inputs
- Stage `00A` and `00B` ledger rows in `output/playwright/execution-ledger.jsonl`
- Current telemetry-focused test results and live closeout artifacts
- Current observability and audit findings already documented under `audit/`

## Planned Completion Stage(s)
- Stage `00B`: create and anchor the taxonomy stub in the backbone
- Stage `08C`: finalize the taxonomy against the completed closeout evidence pack
