# Dependency: Student Shell And Risk Explorer Access

- Dependency name: Student shell, risk explorer, and session-message access
- Dependency type: auth/session, runtime, semantic access
- Source surface or action: student shell cards, timeline, chat/session messages, risk explorer drilldowns
- Upstream dependency: active role, active run, simulation checkpoint id, faculty context, student supervision scope
- Downstream impacted surfaces: student card, timeline, risk explorer tabs, session message creation, HOD and mentor drilldowns
- Trigger: opening a student shell, requesting a timeline or card, creating or reading a session message
- Data contract or key fields: `simulationRunId`, `simulationStageCheckpointId`, `studentId`, active mentor assignment, enrollment scope
- Runtime conditions: non-admin roles are constrained to the active run and the current supervision scope; `resolveStudentShellRun()` and `resolveAcademicStageCheckpoint()` gate the same path
- Persistence or config coupling: student shell sessions and messages are backend resources tied to the active proof run and the selected checkpoint
- Hidden coupling sources: the same visible student surface may resolve to the active run, a requested run, or a checkpoint-derived run depending on auth and parameters; mentor, course leader, and HOD access checks differ underneath the same UI
- Failure mode: stale checkpoint ids, non-active runs, or supervision mismatch can return empty state or forbidden access instead of student data
- Drift risk: high
- Evidence: `air-mentor-api/src/modules/academic-proof-routes.ts:324-430`, `air-mentor-api/src/modules/academic.ts:926-1045, 1902-2065`, `air-mentor-api/src/modules/academic-access.ts:76-181`, `src/api/client.ts:114-119, 420-430, 1063-1071`
- Notes: the exact live boundary behavior of `resolveStudentShellRun()` and `assertStudentShellScope()` remains a known verification gap

