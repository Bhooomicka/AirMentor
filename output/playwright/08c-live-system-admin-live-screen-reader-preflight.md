# AirMentor Screen Reader Preflight

Generated: 2026-04-01T21:55:09.387Z

This transcript is generated from the live accessibility regression accessibility-tree and aria-snapshot checks.
It is meant to make the remaining human screen-reader review deterministic, not to replace a real NVDA/JAWS/VoiceOver pass.

## Portal home

- no blocking violations

## System admin login

- no blocking violations

## System admin requests detail

- no blocking violations

## System admin requests detail tree

```text
- button "Go to dashboard": AM
- text: M. S. Ramaiah University of Applied Sciences Welcome System Admin · Governed Requests
- button "Go back": Back
- text: 02 Apr, 03:24 am
- button "Switch to dark mode": 🌙
- button "Hide action queue": "72"
- button "Refresh admin data"
- button "Logout"
- complementary:
  - text: Operations Rail Governed Requests
  - button "Collapse operations rail"
  - textbox "Admin search":
    - /placeholder: Search governed requests...
  - navigation:
    - button "Overview"
    - button "Faculties"
    - button "Students"
    - button "Faculty Members"
    - button "Requests"
  - text: Path
  - button "Requests"
  - text: Grant additional mentor mapping coverage
- text: Workflow Requests HoD-issued permanent changes move through admin review, approval, implementation, and closure.
- button "Grant additional mentor mapping coverage faculty role or mapping update · department:dept_cse · due 18 Mar 2026, 10:30 pm Closed"
- text: "Grant additional mentor mapping coverage Need temporary mentor reassignment capacity for section A. Closed Request Type: faculty role or mapping update Priority: P2 Requester: t1 Current Owner: fac_sysadmin Due: 18 Mar 2026, 10:30 pm Updated: 17 Mar 2026, 12:21 am Linked Targets faculty_profile:t6 Status History Start -> New SYSTEM_ADMIN · fac_sysadmin · 16 Mar 2026, 05:40 am New -> In Review SYSTEM_ADMIN · fac_sysadmin · 17 Mar 2026, 12:21 am In Review -> Approved SYSTEM_ADMIN · fac_sysadmin · 17 Mar 2026, 12:21 am Approved -> Implemented SYSTEM_ADMIN · fac_sysadmin · 17 Mar 2026, 12:21 am Implemented -> Closed SYSTEM_ADMIN · fac_sysadmin · 17 Mar 2026, 12:21 am Notes Claimed for review. SYSTEM_ADMIN · fac_sysadmin · 17 Mar 2026, 12:21 am Approved for implementation. SYSTEM_ADMIN · fac_sysadmin · 17 Mar 2026, 12:21 am Implemented from the sysadmin workspace. SYSTEM_ADMIN · fac_sysadmin · 17 Mar 2026, 12:21 am Closed after execution. SYSTEM_ADMIN · fac_sysadmin · 17 Mar 2026, 12:21 am Action Queue 72 visible Requests go first. Personal reminders stay private to the signed-in system admin. Queue Controls Nothing hidden right now."
- button "Hide all"
- button "Restore all hidden" [disabled]
- text: Requests
- status: No open HoD or governance requests right now.
- text: Personal Tasks
- status: No private admin reminders. Use the quick add button below.
- text: Hidden Records Quality Assurance Faculty QA7679 Updated Academic faculty · deleted 29 Mar 2026, 07:19 pm · restore window 60 days Academic faculty
- button "Restore"
- button "Hide forever"
- text: Quality Systems QA7679 Updated Department · deleted 29 Mar 2026, 07:19 pm · restore window 60 days Department
- button "Restore"
- button "Hide forever"
- text: Quality Analytics QA7679 Updated Branch · deleted 29 Mar 2026, 07:19 pm · restore window 60 days Branch
- button "Restore"
- button "Hide forever"
- text: 2028-A Year · deleted 29 Mar 2026, 07:19 pm · restore window 60 days Year
- button "Restore"
- button "Hide forever"
- button "Quick Add Reminder"
```

## System admin student detail tabs

```text
- tablist "Student detail sections":
  - tab "Profile" [selected]
  - tab "Academic 1"
  - tab "Mentor 1"
  - tab "Progression"
  - tab "History 1"
```

## System admin student edit dialog

- no blocking violations

## System admin student edit dialog tree

```text
- dialog "Edit Aarav Sharma":
  - text: Student Edit Edit Aarav Sharma Update the core student identity from a focused dialog instead of the stretched workspace card.
  - button "Close dialog": ×
  - text: Name
  - textbox "Student Name": Aarav Sharma
  - text: USN
  - textbox "Student USN": 1MS23CS001
  - text: Roll Number
  - textbox "Student Roll Number": "001"
  - text: Admission Date
  - textbox "Student Admission Date": 2024-08-01
  - text: Email
  - textbox "Student Email": 1ms23cs001@student.airmentor.local
  - text: Phone
  - textbox "Student Phone": +91 9700000000
  - button "Cancel"
  - button "Delete Student"
  - button "Save Student"
```

## System admin hierarchy workspace tabs

```text
- tablist "Hierarchy workspace sections":
  - tab "Overview" [selected]
  - tab "Bands"
  - tab "CE / SEE"
  - tab "CGPA Formula"
  - tab "Stage Gates"
  - tab "Courses"
  - tab "Provision"
```

## System admin proof dashboard

- no blocking violations

## System admin proof dashboard tree

```text
- text: Proof Control Plane Proof Control Plane Curriculum import, crosswalk review, active run control, monitoring state, and snapshot restore all run from the backend proof shell now.
- button "Create Import"
- button "Validate Import"
- button "Review Mappings" [disabled]
- button "Approve Import"
- button "Run / Rerun"
- button "Recompute Risk"
- status: Scope System admin proof route · Pre TT1 · resolved from Pre TT1 · Live batch proof run 80973 · Checkpoint-bound proof counts · operational semester 1 · Proof mode.
- status: Checkpoint-bound proof counts are authoritative for System admin proof route · Pre TT1.
- button "Jump to proof controls"
- text: Active Run Live batch proof run 80973 Seed 80973 · completed completed · 100% Monitoring 720 watch scores · 0 open reassessments Alerts 720 decisions · 0 acknowledgements Snapshots 1 saved Operational Semester Semester 1
- button "Sem 1" [disabled]
- text: "Queue Health 0 queued · 0 running · 0 failed Oldest queue age n/a · retryable failures 0 Worker Lease released · phase completed Queue age n/a · progress 100% Checkpoint Readiness 1/5 ready 4 blocked · 3 playback gated · 16 blocking queue items First blocked checkpoint stage_checkpoint_a42a1716cfe51f06a5debd2b Stage 2 Coverage 0/120 profiles · 0 question results Topic 0 · CO 0 · response 0 Risk Model Heuristic fallback only No active local artifact has been trained for this batch yet. Corpus + Split Manifest unknown Splits: Unavailable Worlds: Unavailable Scenario families: Unavailable Calibration + Policy Calibration unknown No evaluation payload is available. Governed policy: acceptanceGates structuredStudyPlanWithinLimit/targetedTutoringBeatsStructuredStudyPlanAcademicSlice/noRecommendedActionUnderperformsNoAction · byAction attendance-recovery-follow-up/pre-see-rescue · byPhenotype late-semester-acute/persistent-nonresponse/prerequisite-dominant · counterfactualPolicyDiagnostics metricNote/efficacySupportThreshold/targetedTutoringVsStructuredStudyPlanAcademicSlice · realizedPathDiagnostics metricNote/byAction/byPhenotype · recommendedActionCount 3600 · simulatedActionCount 64 · structuredStudyPlanShare 0 Governed CO evidence: acceptanceGates theoryCoursesDefaultToBlueprintEvidence/fallbackOnlyInExplicitCases · byCourseFamily lab-like/communication-practice/theory-heavy · byMode fallback-simulated · bySemester sem1 · fallbackCount 3600 · labFallbackCount 1200 · theoryFallbackCount 2400 · totalRows 3600 Policy gates: noRecommendedActionUnderperformsNoAction true · structuredStudyPlanWithinLimit true · targetedTutoringBeatsStructuredStudyPlanAcademicSlice false Active-run parity: activeRunId simulation_run_19da4b62-d4e2-4c83-b4ea-ff8bca2e74ed · coEvidenceDiagnostics totalRows/fallbackCount/theoryFallbackCount · policyDiagnostics recommendedActionCount/simulatedActionCount/structuredStudyPlanShare Checkpoint Playback Read-only playback overlay for the active proof run. The run itself does not mutate while stepping through stage checkpoints."
- button "Reset To Start" [disabled]
- button "Previous" [disabled]
- button "Next"
- button "Play To End" [disabled]
- status: "Selected checkpoint: semester 1 · Pre TT1 · Opening stage before TT1 closes. Scheme setup, attendance updates, and class execution stay open here.. This stage is synced into the academic playback overlay for teaching surfaces."
- button "S1 · Pre TT1"
- button "S1 · Post TT1"
- button "S1 · Post TT2 · blocked"
- button "S1 · Post Assignments · blocked"
- button "S1 · Post SEE · blocked"
- text: "Risk Snapshot 0 high · 720 medium · 0 low Queue State 0 open · 720 watch · 0 resolved 0 blocking students · 120 watched students No-Action Comparator 0 high-risk rows without simulated support Average Risk Change 0 scaled points Average Counterfactual Lift 0 scaled points Stage queue preview CS101 · Course Leader · Medium · Watching Follow-up · action Schedule a monitored reassessment and review the current intervention plan. · risk 36% vs no-action 36%. CO evidence mode: fallback-simulated. Δ 0 Lift 0 HSS106 · Course Leader · Medium · Watching Follow-up · action Schedule a monitored reassessment and review the current intervention plan. · risk 36% vs no-action 36%. CO evidence mode: fallback-simulated. Δ 0 Lift 0 MA101 · Course Leader · Medium · Watching Follow-up · action Schedule a monitored reassessment and review the current intervention plan. · risk 36% vs no-action 36%. CO evidence mode: fallback-simulated. Δ 0 Lift 0 MNC103 · Course Leader · Medium · Watching Follow-up · action Schedule a monitored reassessment and review the current intervention plan. · risk 36% vs no-action 36%. CO evidence mode: fallback-simulated. Δ 0 Lift 0 MNC104 · Course Leader · Medium · Watching Follow-up · action Schedule a monitored reassessment and review the current intervention plan. · risk 36% vs no-action 36%. CO evidence mode: fallback-simulated. Δ 0 Lift 0 MNC105L · Course Leader · Medium · Watching Follow-up · action Schedule a monitored reassessment and review the current intervention plan. · risk 36% vs no-action 36%. CO evidence mode: fallback-simulated. Δ 0 Lift 0 CS101 · Course Leader · Medium · Watching Follow-up · action Schedule a monitored reassessment and review the current intervention plan. · risk 36% vs no-action 36%. CO evidence mode: fallback-simulated. Δ 0 Lift 0 HSS106 · Course Leader · Medium · Watching Follow-up · action Schedule a monitored reassessment and review the current intervention plan. · risk 36% vs no-action 36%. CO evidence mode: fallback-simulated. Δ 0 Lift 0 Offering action summary CS101 · Section A No pending action · avg risk 36% · open queue 0. CS101 · Section B No pending action · avg risk 36% · open queue 0. HSS106 · Section A No pending action · avg risk 36% · open queue 0. HSS106 · Section B No pending action · avg risk 36% · open queue 0. MA101 · Section A No pending action · avg risk 36% · open queue 0. MA101 · Section B No pending action · avg risk 36% · open queue 0. MNC103 · Section A No pending action · avg risk 36% · open queue 0. MNC103 · Section B No pending action · avg risk 36% · open queue 0. Imports system-admin-live approved · admin-managed · 0 unresolved mappings Crosswalk Review No pending crosswalk reviews. Runs Live batch proof run 80973 Active Seed 80973 · 26/3/2026, 10:33:00 pm completed · 100% Queue age n/a · lease released"
- button "Archive"
- button "Restore Snapshot"
- text: "Teacher Load Prof. Ananya Iyer Sem 1 · 14 contact hrs · 5 credits Dr. Kavitha Rao QA Sem 1 · 13 contact hrs · 4 credits Dr. Kavitha Rao QA Sem 1 · 11 contact hrs · 3 credits Queue Preview Aarav Nair · CS101 Course Leader · Open · due 7/5/2026, 10:33:00 pm Playback fallback · Post TT1 CO evidence mode: fallback-simulated. Δ +24 Lift 0 Aarav Nair · HSS106 Course Leader · Open · due 7/5/2026, 10:33:00 pm Playback fallback · Post TT1 CO evidence mode: fallback-simulated. Δ +24 Lift 0 Aarav Nair · MA101 Course Leader · Open · due 7/5/2026, 10:33:00 pm Playback fallback · Post TT1 CO evidence mode: fallback-simulated. Δ +24 Lift 0 Aarav Nair · MNC103 Course Leader · Open · due 7/5/2026, 10:33:00 pm Playback fallback · Post TT1 CO evidence mode: fallback-simulated. Δ +24 Lift 0 Aarav Nair · MNC104 Course Leader · Open · due 7/5/2026, 10:33:00 pm Playback fallback · Post TT1 CO evidence mode: fallback-simulated. Δ +24 Lift 0 Aarav Nair · MNC105L Course Leader · Open · due 7/5/2026, 10:33:00 pm Playback fallback · Post TT1 CO evidence mode: fallback-simulated. Δ +24 Lift 0 Kavya Iyer · CS101 Course Leader · Open · due 7/5/2026, 10:33:00 pm Playback fallback · Post TT1 CO evidence mode: fallback-simulated. Δ +24 Lift 0 Kavya Iyer · HSS106 Course Leader · Open · due 7/5/2026, 10:33:00 pm Playback fallback · Post TT1 CO evidence mode: fallback-simulated. Δ +24 Lift 0 Kavya Iyer · MA101 Course Leader · Open · due 7/5/2026, 10:33:00 pm Playback fallback · Post TT1 CO evidence mode: fallback-simulated. Δ +24 Lift 0 Kavya Iyer · MNC103 Course Leader · Open · due 7/5/2026, 10:33:00 pm Playback fallback · Post TT1 CO evidence mode: fallback-simulated. Δ +24 Lift 0 Kavya Iyer · MNC104 Course Leader · Open · due 7/5/2026, 10:33:00 pm Playback fallback · Post TT1 CO evidence mode: fallback-simulated. Δ +24 Lift 0 Kavya Iyer · MNC105L Course Leader · Open · due 7/5/2026, 10:33:00 pm Playback fallback · Post TT1 CO evidence mode: fallback-simulated. Δ +24 Lift 0 Lifecycle Audit recomputed-observed-risk System · 26/3/2026, 10:33:02 pm run-created System · 26/3/2026, 10:33:02 pm Recent Operational Events auth.session.restored sessionId: session_a620a941-6715-4fb1-ae64-6e0963595c90 · userId: user_sysadmin · facultyId: fac_sysadmin info backend 2/4/2026, 3:24:28 am auth.login.succeeded sessionId: session_a620a941-6715-4fb1-ae64-6e0963595c90 · userId: user_sysadmin · facultyId: fac_sysadmin info backend 2/4/2026, 3:24:28 am client.telemetry.received name: startup.diagnostic · level: info · timestamp: 2026-04-01T21:54:27.273Z info backend 2/4/2026, 3:24:27 am client.telemetry.received name: startup.ready · level: info · timestamp: 2026-04-01T21:54:27.274Z info backend 2/4/2026, 3:24:27 am request.error method: GET · route: /api/session · statusCode: 401 warn backend 2/4/2026, 3:24:27 am startup.ready workspace: system-admin · apiBaseUrl: https://api-production-ab72.up.railway.app · telemetrySinkConfigured: false info client 2/4/2026, 3:24:27 am startup.diagnostic workspace: system-admin · level: info · code: FRONTEND_STARTUP_MODE info client 2/4/2026, 3:24:27 am academic.bootstrap.loaded facultyId: t1 · roleCode: MENTOR · simulationStageCheckpointId: null info backend 2/4/2026, 3:24:22 am"
```

## Academic portal login

- no blocking violations

## Teacher proof panel

- no blocking violations

## Teacher proof panel tree

```text
- text: "Proof Control Plane Proof Control Plane This panel only surfaces rerunnable proof data: active simulation runs, observed risk queue items, and elective-fit summaries. It does not expose latent-state internals."
- status: Authoritative proof panel for this faculty scope. Use this card and the linked proof routes for checkpoint-bound evidence; surrounding faculty-profile cards remain operational context.
- status: Scope 2023 Proof · resolved from MSRUAS first-6-semester proof batch · Proof-run counts · operational semester 4 · Proof mode.
- text: "Active run contexts 2023 Proof · MSRUAS first-6-semester proof batch · active · Seed 101 · Created 31 Mar 2026 Monitoring queue No governed queue items are currently linked to this profile. Semester-6 elective fit No elective recommendation is currently available for this profile. Active proof context: 2023 Proof · MSRUAS first-6-semester proof batch · active · B.Tech Mathematics and Computing."
```

## Portal home

- no blocking violations

## System admin login

- no blocking violations

## System admin faculty detail tabs

```text
- tablist "Faculty detail sections":
  - tab "Profile" [selected]
  - tab "Appointments 2"
  - tab "Permissions 6"
  - tab "Teaching 4"
  - tab "Timetable"
  - tab "History 0"
```

