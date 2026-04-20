# Same-Student Cross-Surface Parity Report

Pass: `same-student-cross-surface-parity-pass`
Date: `2026-04-16`
Context: `live` with local forensic reconciliation
Model / provider / account: `gpt-5.4 / native-codex / native-codex-session`
Caveman used: `no`
Live verification performed in this run: `no new authenticated live surface`

## Environment Drift Check

- `audit-map/29-status/audit-air-mentor-ui-live-same-student-cross-surface-parity-pass.status` and the paired checkpoint still claimed `running`, but `ps` found no `pid=958497` or `execution_supervisor_pid=959058`.
- `audit-map/22-logs/audit-air-mentor-ui-live-same-student-cross-surface-parity-pass.log` contained wrapper/bootstrap text rather than a durable parity artifact.
- This run therefore treated status-file truth as stale, wrote the missing parity artifact, and manually reconciled the pass control files to terminal state.

## Scope Covered

- parity seed generator lineage
- tuple resolution for explicit checkpoint playback and default activated-semester slices
- same-student proof truth across `SYSTEM_ADMIN`, `COURSE_LEADER`, `MENTOR`, `HOD`, `student shell`, and `risk explorer`
- provenance / count-source explanation invariants
- allowed role-filtered differences versus true semantic contradictions
- live blocker carry-forward

## Evidence Buckets Used

- `directly observed`: render-test fixtures and explicit UI contract assertions
- `inferred`: code-backed plus committed backend-test-backed route/service behavior that could not be freshly rerun in this sandbox
- `blocked`: live or DB-backed rerun evidence unavailable in this shell

## Local Tuple Anchors

| Anchor | Tuple | Surfaces anchored | Evidence label | Evidence |
| --- | --- | --- | --- | --- |
| Explicit checkpoint render anchor | `studentId=mnc_student_001`, `usn=1MS23MC001`, `simulationRunId=run_001`, `simulationStageCheckpointId=checkpoint_001`, `semester=6`, `stage=Post TT1` | faculty-profile proof panel, HoD proof page, risk explorer, student shell | `directly observed` | `tests/faculty-profile-proof.test.tsx`, `tests/hod-pages.test.ts`, `tests/risk-explorer.test.tsx`, `tests/student-shell.test.tsx` |
| Runtime-selected parity anchor | `studentId=accessibleStudentId`, `simulationRunId=activeRun.simulationRunId`, explicit checkpoint from `selectedCheckpoint` / `playbackCheckpoint` or activated semester from sysadmin control plane | course leader, mentor, HoD, student shell, risk explorer, sysadmin dashboard checkpoint family | `inferred` | `air-mentor-api/tests/academic-parity.test.ts`, `air-mentor-api/tests/hod-proof-analytics.test.ts`, `air-mentor-api/tests/student-agent-shell.test.ts`, `air-mentor-api/src/modules/academic.ts`, `air-mentor-api/src/modules/academic-proof-routes.ts`, `air-mentor-api/src/lib/proof-control-plane-tail-service.ts`, `air-mentor-api/src/lib/proof-control-plane-hod-service.ts`, `air-mentor-api/src/lib/proof-control-plane-batch-service.ts` |
| Live authenticated target | unresolved | sysadmin, course leader, mentor, HoD, student shell on deployed Pages + Railway | `blocked` | `audit-map/10-live-behavior/live-same-student-parity.md`, `audit-map/32-reports/live-credentialed-parity-report.md` |

## Seed Generator Lineage

- `air-mentor-api/scripts/generate-academic-parity-seed.ts` is an intentional parity fixture source, not a generic demo seed.
- It strips seeded faculty scope for `t1` (`FACULTY_WITH_PERMISSIONS_ONLY='t1'`) so teaching parity relies on admin-owned proof records instead of stale prefilled faculty-local arrays.
- It deterministically seeds mentor follow-up, HoD unlock, and proof-adjacent academic task state on a fixed clock (`BASE_NOW_ISO='2026-03-16T00:00:00.000Z'`).
- Verdict: local parity fixtures are designed to stabilize invariants around proof-owned truth and role-scoped filtering.

Evidence:

- `air-mentor-api/scripts/generate-academic-parity-seed.ts:21-24`
- `air-mentor-api/scripts/generate-academic-parity-seed.ts:46-55`
- `air-mentor-api/scripts/generate-academic-parity-seed.ts:77-237`

## Parity Matrix

| Surface | How the same-student tuple is resolved | Truth that should stay invariant | Legitimate surface differences | Evidence label | Evidence |
| --- | --- | --- | --- | --- | --- |
| `SYSTEM_ADMIN` | sysadmin proof dashboard chooses active run and optional checkpoint; per-student checkpoint detail is shaped by `getProofRunCheckpointStudentDetail(...)` | explicit checkpoint id, semester/stage, student identity, per-course risk band/probability, no-action comparator, queue/reassessment state | sysadmin uniquely sees per-course checkpoint projections, run diagnostics, worker/readiness state, and inactive-run inspection | `inferred` | `air-mentor-api/src/lib/proof-control-plane-batch-service.ts:172-225`, `src/system-admin-proof-dashboard-workspace.tsx:353-375`, `src/api/types.ts:1238-1275`, `tests/system-admin-proof-dashboard-workspace.test.tsx:21-50`, `tests/system-admin-proof-dashboard-workspace.test.tsx:522-543`, `air-mentor-api/tests/student-agent-shell.test.ts:655-690` |
| `COURSE_LEADER` | faculty-profile `proofOperations.monitoringQueue` yields in-scope students; drilldowns resolve through active run or explicit checkpoint plus owned-offering scope checks | queue student must remain the same student in bootstrap, risk explorer, and student shell; explicit checkpoint slice must carry the same run/checkpoint/semester tuple | course leader only sees owned-offering students and checkpoint-owned offerings for the current proof semester | `inferred` | `air-mentor-api/tests/academic-parity.test.ts:783-919`, `air-mentor-api/src/modules/academic.ts:926-1048`, `air-mentor-api/src/lib/proof-control-plane-access.ts:3-20` |
| `MENTOR` | faculty-profile `proofOperations.monitoringQueue` and elective-fit rows are filtered by active mentor assignments; drilldowns reuse the same student-shell/risk-explorer route chain | same student id must survive mentor queue -> risk explorer -> student shell; explicit checkpoint tuple stays stable when requested | mentor only sees assigned students, not all owned-offering students or department totals | `inferred` | `air-mentor-api/tests/academic-parity.test.ts:921-971`, `air-mentor-api/src/modules/academic.ts:1016-1026`, `air-mentor-api/src/lib/proof-control-plane-access.ts:8-20` |
| `HOD` | HoD proof bundle filters department / branch scope and can further narrow by `studentId`; student shell scope is validated against HoD proof analytics for the same run/checkpoint | active run id should align with sysadmin dashboard; queue load should align with faculty profile; explicit checkpoint summary should preserve the same checkpoint tuple; student current semester should follow the activated semester | HoD sees department aggregates, faculty rollups, watchlist rows, and reassessment tables instead of faculty-owned queue/elective-only slices | `inferred` | `air-mentor-api/tests/hod-proof-analytics.test.ts:27-155`, `air-mentor-api/tests/hod-proof-analytics.test.ts:560-668`, `air-mentor-api/src/modules/academic.ts:983-1014`, `air-mentor-api/src/lib/proof-control-plane-hod-service.ts:825-861`, `src/pages/hod-pages.tsx:193-223`, `tests/hod-pages.test.ts:7-267` |
| `student shell` | `resolveStudentShellRun(...)` + `resolveAcademicStageCheckpoint(...)` + `assertStudentShellScope(...)` fix the run/checkpoint/student tuple before card/session/timeline reads | explicit checkpoint view must preserve student identity, checkpoint id, semester/stage, and bounded proof provenance; default slice must track activated semester | student shell alone adds deterministic chat/session state and explanatory framing; it cannot mutate academic records | `directly observed` + `inferred` | `air-mentor-api/src/modules/academic.ts:926-1048`, `air-mentor-api/tests/academic-proof-routes.test.ts:65-176`, `air-mentor-api/tests/student-agent-shell.test.ts:426-465`, `air-mentor-api/tests/student-agent-shell.test.ts:468-690`, `tests/student-shell.test.tsx:231-294` |
| `risk explorer` | reuses `buildStudentAgentCard(...)` first, then layers checkpoint-policy comparison, trained heads, feature completeness/provenance, and derived scenario heads | core student, checkpoint, current evidence, current status, weak CO, question patterns, elective fit, and counterfactual truth should align with student shell for the same tuple | risk explorer legitimately adds trained heads, feature provenance/completeness, derived scenario heads, and advanced policy diagnostics | `directly observed` + `inferred` | `air-mentor-api/src/lib/proof-control-plane-tail-service.ts:2107-2174`, `tests/risk-explorer.test.tsx:23-239`, `air-mentor-api/tests/academic-parity.test.ts:895-919` |

## Invariant Checks

| Invariant | Expected result | Current local result | Evidence label | Notes |
| --- | --- | --- | --- | --- |
| Explicit checkpoint tuple (`simulationRunId`, `simulationStageCheckpointId`, semester, stage) stays stable across checkpoint-bound surfaces | should match | `pass` for faculty-profile, HoD, risk explorer, and student shell render fixtures; route chain also preserves checkpoint id through scope checks | `directly observed` + `inferred` | `tests/faculty-profile-proof.test.tsx`, `tests/hod-pages.test.ts`, `tests/risk-explorer.test.tsx`, `tests/student-shell.test.tsx`, `air-mentor-api/tests/academic-proof-routes.test.ts` |
| Student identity stays stable across queue/drilldown surfaces | should match | `pass` locally for faculty-profile queue -> bootstrap -> risk explorer / student shell, and for mentor/course-leader scoped drilldowns | `inferred` | `air-mentor-api/tests/academic-parity.test.ts:885-919`, `air-mentor-api/tests/admin-control-plane.test.ts:1946-1985` |
| Activated-semester default slice differs from explicit checkpoint playback only by scope source, not by hidden tuple drift | should differ only in permitted ways | `partial pass` | `inferred` | committed backend tests prove default slice follows activated semester while explicit playback keeps checkpoint tuple separate |
| Count-source/provenance wording is consistent for explicit checkpoint playback | should say `proof-checkpoint` with checkpoint semester | `pass` locally | `directly observed` | `tests/faculty-profile-proof.test.tsx`, `tests/hod-pages.test.ts`, `tests/risk-explorer.test.tsx`, `tests/student-shell.test.tsx`, `src/proof-provenance.ts` |
| Default slice provenance honestly reflects underlying data source | should not hide checkpoint-backed fallback | `fail / contradiction` | `inferred` | `C-021`: default faculty / HoD / student slices can recurse into checkpoint data and then relabel the payload as `proof-run` with cleared checkpoint context |
| Scope-filtered differences stay role-legitimate rather than semantic contradictions | should hold | `pass` locally | `inferred` | course leader uses owned offerings, mentor uses assignments, HoD uses department/branch overlap, sysadmin can inspect inactive runs/checkpoints |

## Contradictions Found

- `C-021`: default faculty, HoD, and student proof slices can become checkpoint-backed while returning `countSource=proof-run` and clearing checkpoint metadata. This is the main local parity contradiction still open after this run.

## Fresh Verification Results From This Run

- Frontend parity render suite passed in this shell:

```bash
npx vitest run tests/faculty-profile-proof.test.tsx tests/academic-proof-summary-strip.test.tsx tests/hod-pages.test.ts tests/risk-explorer.test.tsx tests/student-shell.test.tsx tests/system-admin-proof-dashboard-workspace.test.tsx --reporter=dot
```

- Result: `6` files passed, `35` tests passed.

- Backend DB-backed parity rerun is blocked in this shell:

```bash
cd air-mentor-api && npx vitest run tests/academic-parity.test.ts tests/academic-proof-routes.test.ts tests/hod-proof-analytics.test.ts tests/student-agent-shell.test.ts --reporter=dot
```

- Result: suite aborted under sandbox `listen EPERM: operation not permitted 127.0.0.1` before the Fastify / DB-backed app could stand up. Current backend parity conclusions therefore rely on committed test corpus plus code inspection, not a fresh rerun.

## Live Status

- `blocked`
- Reason:
  - documented Railway public API URL still fails session-contract expectations
  - no safe read-only live proof/parity observer exists
  - current proof/parity helpers are write-capable and unsafe for blind production use

## Remaining Uncovered Scope

- direct live same-target tuple capture across sysadmin, course leader, mentor, HoD, and student shell
- live observation of whether `C-021` is visible in deployed surfaces or only local/runtime data shaping
- fresh backend DB-backed parity rerun in an environment that allows local listener setup
- explicit same-student sysadmin checkpoint-student-detail comparison against the academic tuple in one runnable local integration test

## Next Pass

- credentialed `live-behavior-pass` or a dedicated read-only live parity observer pass, after the live session contract and safe observer prerequisites are satisfied
