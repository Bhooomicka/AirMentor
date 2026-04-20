# Live Credentialed Parity Pass

Version: `v2.0`

## Mission

This pass exists to close the highest-value remaining live gap:

- direct, credentialed, same-target parity across `SYSTEM_ADMIN`, `COURSE_LEADER`, `MENTOR`, `HOD`, and the student-facing shell surface

Do not run this pass as a generic live smoke.
Do not let it collapse into "auth blocked" prose unless the blocker is exact and reproducible.
Do not claim completion from local seeded flows.

The goal is either:

1. direct live parity evidence on one shared target tuple, or
2. an exact manual-action-required checkpoint that proves why that parity cannot yet be observed

## Mandatory Inputs

Read these before acting:

1. `audit-map/32-reports/closure-readiness-verdict.md`
2. `audit-map/32-reports/residual-gap-closure-report.md`
3. `audit-map/32-reports/claim-verification-matrix.md`
4. `audit-map/23-coverage/coverage-ledger.md`
5. `audit-map/24-agent-memory/working-knowledge.md`
6. `audit-map/24-agent-memory/known-facts.md`
7. `audit-map/24-agent-memory/known-ambiguities.md`
8. `audit-map/14-reconciliation/contradiction-matrix.md`
9. `audit-map/10-live-behavior/live-evidence-checklist.md`
10. `audit-map/10-live-behavior/live-vs-local-matrix.md`
11. `audit-map/15-final-maps/live-vs-local-master-diff.md`
12. `scripts/verify-final-closeout-live.sh`
13. `scripts/live-admin-common.sh`
14. `scripts/system-admin-live-auth.mjs`
15. `scripts/teaching-password-resolution.mjs`
16. `scripts/proof-risk-semester-walk.mjs`
17. `scripts/proof-risk-semester-walk-probe.mjs`
18. `scripts/system-admin-proof-risk-smoke.mjs`
19. `audit-map/20-prompts/templates/live-credentialed-parity-template.md`

## Required Outputs

Write or update all relevant files:

- `audit-map/10-live-behavior/live-same-student-parity.md`
- `audit-map/10-live-behavior/live-evidence-checklist.md`
- `audit-map/10-live-behavior/live-vs-local-matrix.md`
- `audit-map/15-final-maps/live-vs-local-master-diff.md`
- `audit-map/14-reconciliation/contradiction-matrix.md`
- `audit-map/23-coverage/coverage-ledger.md`
- `audit-map/24-agent-memory/working-knowledge.md`
- `audit-map/24-agent-memory/known-facts.md`
- `audit-map/24-agent-memory/known-ambiguities.md`
- `audit-map/32-reports/live-credentialed-parity-report.md`

## Required Preconditions

This pass is live-only. Treat local seeded mode as non-creditable for closure.

The pass must verify and record the state of:

- `AIRMENTOR_LIVE_STACK=1`
- `PLAYWRIGHT_APP_URL`
- `PLAYWRIGHT_API_URL`
- `AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER`
- `AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD`
- optional `AIRMENTOR_LIVE_TEACHER_IDENTIFIER`

You must also establish whether the live role surface actually requires:

- one multi-grant faculty identity that can switch among `COURSE_LEADER`, `MENTOR`, and `HOD`
- or separate faculty identities for those surfaces

Do not invent a separate live student login if the repo/runtime does not expose one.
If the student surface is only available through `student-shell` or a delegated drilldown surface, state that explicitly and prove the surface through direct observation.

## Mandatory Credential Matrix

The report must include an explicit credential matrix for:

- `SYSTEM_ADMIN`
- `COURSE_LEADER`
- `MENTOR`
- `HOD`
- `student shell`

For each, record:

- identity used
- whether the identity is direct or role-switched
- whether the credential was directly verified in this run
- the exact evidence path

## Mandatory Shared Target Tuple

You must resolve and persist one shared live target tuple before making parity claims:

- academic faculty
- department
- branch
- batch
- route hash or live route
- `simulationRunId`
- `simulationStageCheckpointId`
- semester number / label
- stage label / order
- `studentId`
- student name / USN if visible

This target must be the same underlying truth across all observed surfaces.

If the pass cannot prove that the target is the same entity across all surfaces, parity is not proven.

## Execution Discipline

Follow this order:

1. verify live URL reachability and session-contract preconditions
2. verify system-admin authentication works on the live stack
3. resolve the shared target tuple from direct live evidence
4. capture `SYSTEM_ADMIN` evidence for that target
5. capture `COURSE_LEADER` evidence for the same target
6. capture `MENTOR` evidence for the same target
7. capture `HOD` evidence for the same target
8. capture the student-facing shell evidence for the same target
9. compare invariants, allowed differences, and contradictions
10. update live-vs-local and closure artifacts

## Evidence Manifest

This pass is not creditable unless it records a durable evidence manifest with timestamps and artifact paths.

Capture where possible:

- screenshots per surface
- HTML or text snapshots for the observed route
- JSON or network evidence for bootstrap / proof / student-shell / risk endpoints
- trace or request-response artifacts for the chosen target
- final role-by-role comparison table

If a surface cannot be captured, write the exact reason and the next direct-observation step.

## Required Invariants

For the chosen shared target, explicitly compare at minimum:

- student identity
- `simulationRunId`
- `simulationStageCheckpointId`
- semester identity
- stage identity
- proof playback selection / restore behavior
- risk or provenance labels shown to the user
- queue or action state when visible
- scope-filtered differences versus actual contradictions

Do not treat legitimate role filtering as a contradiction.
Do treat mismatched student, run, checkpoint, semester, or provenance truth as a contradiction.

## Live Safety Rule

Prefer read-only or clearly reversible live actions.

Do not run a mutating verification step on the deployed stack unless one of these is true:

1. the mutation is already proven reversible inside the same run and the restore path is captured, or
2. the prompt explicitly records why the mutation is necessary and low-risk

If an existing script performs live writes without a proven restore path, do not blindly trust it as safe.
Record that as a workflow risk and choose a safer observation path where possible.

## Required Reporting Shape

`live-same-student-parity.md` and `live-credentialed-parity-report.md` must include:

1. run contract
2. credential matrix
3. shared target tuple
4. per-surface observations
5. invariant comparison table
6. allowed differences
7. contradictions
8. blocker or checkpoint section
9. exact resume command if blocked
10. final verdict:
   - `live-parity-proved`
   - `live-parity-partial`
   - `live-parity-blocked`

Use `audit-map/20-prompts/templates/live-credentialed-parity-template.md` as the minimum structure.

## Manual-Action Rule

If any prerequisite is missing, emit a deterministic manual checkpoint and stop.

The blocker output must include:

- exact reason
- exact missing credential / URL / environment condition
- exact resume point
- exact next command
- exact target evidence still expected

## Completion Gate

This pass is complete only when it does one of the following:

1. directly proves same-target live parity with artifact-backed evidence across the required role surfaces, or
2. writes a durable, exact blocker report that makes the next manual step unambiguous

Anything weaker is non-creditable.
