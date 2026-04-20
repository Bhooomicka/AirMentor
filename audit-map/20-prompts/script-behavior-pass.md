# Script Behavior Pass Prompt v2.0

Objective: map helper scripts and maintenance scripts as behavior-bearing systems that can alter semantic truth, audit confidence, artifact freshness, or deployment assumptions.

Primary scope:

- `scripts/`
- `air-mentor-api/scripts/`
- audit support scripts with product-facing or verification-facing consequences

Explicit closure targets (must cover if present):

- live auth and credential resolution helpers (`system-admin-live-auth`, teaching password resolution)
- closeout artifact snapshot + bundling (`snapshot-final-closeout-artifacts*`)
- Railway recovery chain helpers (`railway-recovery-chain*`, deploy readiness probes)
- detached stage promotion / completion automation (any `run-detached`, `closeout-stage-*`, `finalize-stage-*` scripts)
- parity seed generation and any fixtures that downstream tests depend on (`generate-academic-parity-seed*`)

Required outputs:

- script behavior registry
- invocation-path and side-effect notes
- updates to `dependency-graph.md`, `data-flow-map.md`, `test-gap-ledger.md`, and coverage ledgers
- explicit notes where green script output could still hide semantic problems
  - include whether a script is safe read-only vs mutating on live data
  - include whether a script can produce "success" while leaving semantic drift unresolved

Rules:

- do not inventory filenames only
- for each important script, capture purpose, inputs, assumptions, files touched, services touched, artifacts produced, semantic guarantee level, and failure modes
- identify script-only transformations that are not represented elsewhere in the audit maps
- if a script feeds live verification, ML artifacts, proof refresh, deploy, or closeout confidence, call that out directly
- if a script depends on external CLIs (Railway, Playwright, browser profiles, nix wrappers), record the exact dependency and failure signatures

Completion gate:

- all important script families must be mapped with invocation path and semantic consequence, or explicitly logged as still-unresolved blockers
