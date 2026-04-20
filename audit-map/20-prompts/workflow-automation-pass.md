# Workflow Automation Pass Prompt v1.0

Objective: map `.github/workflows/` and other automation surfaces as execution systems with real side effects, artifacts, failure modes, and semantic blind spots.

Primary scope:

- `.github/workflows/`
- deploy, verify, closeout, smoke, release, and artifact workflows
- Pages, Railway, CI, scheduled jobs, and any workflow-triggered scripts

Required outputs:

- workflow-by-workflow behavior map
- trigger/input/output/side-effect registry
- updates to `master-system-map.md`, `dependency-graph.md`, `live-vs-local-master-diff.md`, and coverage ledgers
- explicit workflow-only blind spots where repo truth, deployed truth, or verification truth can drift

Rules:

- do not stop at YAML inventory
- for each workflow, map trigger conditions, job graph, artifacts, environments touched, external services touched, scripts invoked, and what the workflow actually proves
- record where a workflow can make deployed truth diverge from repo or test truth
- link scripts and generated artifacts back to the product surfaces they affect

Completion gate:

- each important workflow must be represented as a behavior system, not just a file, and any unproven semantic guarantees must be logged explicitly
