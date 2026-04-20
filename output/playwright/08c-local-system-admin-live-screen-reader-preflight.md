# AirMentor Screen Reader Preflight

Generated: 2026-04-01T21:19:19.562Z

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
- text: AirMentor Academic Demo University Welcome System Admin · Governed Requests
- button "Go back": Back
- text: 02 Apr, 02:48 am
- button "Switch to dark mode": 🌙
- button "Hide action queue": "1"
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
- button "Grant additional mentor mapping coverage faculty role or mapping update · department:dept_cse · due 18 Mar 2026, 10:30 pm New"
- text: Grant additional mentor mapping coverage Need temporary mentor reassignment capacity for section A. New
- button "Take Review"
- text: "Request Type: faculty role or mapping update Priority: P2 Requester: t1 Current Owner: fac_sysadmin Due: 18 Mar 2026, 10:30 pm Updated: 16 Mar 2026, 05:30 am Linked Targets faculty_profile:t6 Status History Start -> New SYSTEM_ADMIN · fac_sysadmin · 16 Mar 2026, 05:30 am Action Queue 1 visible Requests go first. Personal reminders stay private to the signed-in system admin. Queue Controls Nothing hidden right now."
- button "Hide all"
- button "Restore all hidden" [disabled]
- text: Requests
- button "Grant additional mentor mapping coverage faculty role or mapping update · Dr. Kavitha Rao · due 18 Mar 2026, 10:30 pm New P2"
- text: New
- button "Hide forever"
- text: Personal Tasks
- status: No private admin reminders. Use the quick add button below.
- text: Hidden Records Nothing hidden right now.
- button "Quick Add Reminder"
```

## System admin student detail tabs

```text
- tablist "Student detail sections":
  - tab "Profile" [selected]
  - tab "Academic 1"
  - tab "Mentor 0"
  - tab "Progression"
  - tab "History 0"
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
- status: Scope System admin proof route · Pre TT1 · resolved from Pre TT1 · MSRUAS proof rerun 9260 · Checkpoint-bound proof counts · operational semester 6 · Proof mode.
- status: Checkpoint-bound proof counts are authoritative for System admin proof route · Pre TT1.
- status: Playback override active. The dashboard is pinned to Semester 1 · Pre TT1, while the operational semester remains Semester 6.
- button "Jump to proof controls"
- text: Active Run MSRUAS proof rerun 9260 Seed 9260 · completed running · 5% Monitoring 720 watch scores · 659 open reassessments Alerts 720 decisions · 0 acknowledgements Snapshots 0 saved Operational Semester Semester 6
- button "Sem 1"
- button "Sem 2"
- button "Sem 3"
- button "Sem 4"
- button "Sem 5"
- button "Sem 6" [disabled]
- text: "Queue Health 0 queued · 0 running · 0 failed Oldest queue age n/a · retryable failures 0 Worker Lease leased · phase running Queue age n/a · progress 5% Lease expires 2/4/2026, 2:50:03 am Checkpoint Readiness 1/30 ready 29 blocked · 28 playback gated · 863 blocking queue items First blocked checkpoint stage_checkpoint_396102a5cfeeab0b2d58d581 Stage 2 Coverage 120/120 profiles · 69120 question results Topic 25440 · CO 12960 · response 1194 Risk Model Heuristic fallback only No active local artifact has been trained for this batch yet. Corpus + Split Manifest unknown Splits: Unavailable Worlds: Unavailable Scenario families: Unavailable Calibration + Policy Calibration unknown No evaluation payload is available. Governed policy: acceptanceGates structuredStudyPlanWithinLimit/targetedTutoringBeatsStructuredStudyPlanAcademicSlice/noRecommendedActionUnderperformsNoAction · byAction attendance-recovery-follow-up/pre-see-rescue/targeted-tutoring · byPhenotype late-semester-acute/persistent-nonresponse/prerequisite-dominant · counterfactualPolicyDiagnostics metricNote/efficacySupportThreshold/targetedTutoringVsStructuredStudyPlanAcademicSlice · realizedPathDiagnostics metricNote/byAction/byPhenotype · recommendedActionCount 140 · simulatedActionCount 43 · structuredStudyPlanShare 0 Governed CO evidence: acceptanceGates theoryCoursesDefaultToBlueprintEvidence/fallbackOnlyInExplicitCases · byCourseFamily object · byMode object · bySemester object · fallbackCount 0 · labFallbackCount 0 · theoryFallbackCount 0 · totalRows 0 Policy gates: noRecommendedActionUnderperformsNoAction true · structuredStudyPlanWithinLimit true · targetedTutoringBeatsStructuredStudyPlanAcademicSlice true Active-run parity: activeRunId simulation_run_f5892bb0-f6f4-47bb-ace9-8b5576665408 · coEvidenceDiagnostics totalRows/fallbackCount/theoryFallbackCount · policyDiagnostics recommendedActionCount/simulatedActionCount/structuredStudyPlanShare Checkpoint Playback Read-only playback overlay for the active proof run. The run itself does not mutate while stepping through stage checkpoints."
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
- button "S2 · Pre TT1 · blocked"
- button "S2 · Post TT1 · blocked"
- button "S2 · Post TT2 · blocked"
- button "S2 · Post Assignments · blocked"
- button "S2 · Post SEE · blocked"
- button "S3 · Pre TT1 · blocked"
- button "S3 · Post TT1 · blocked"
- button "S3 · Post TT2 · blocked"
- button "S3 · Post Assignments · blocked"
- button "S3 · Post SEE · blocked"
- button "S4 · Pre TT1 · blocked"
- button "S4 · Post TT1 · blocked"
- button "S4 · Post TT2 · blocked"
- button "S4 · Post Assignments · blocked"
- button "S4 · Post SEE · blocked"
- button "S5 · Pre TT1 · blocked"
- button "S5 · Post TT1 · blocked"
- button "S5 · Post TT2 · blocked"
- button "S5 · Post Assignments · blocked"
- button "S5 · Post SEE · blocked"
- button "S6 · Pre TT1 · blocked"
- button "S6 · Post TT1 · blocked"
- button "S6 · Post TT2 · blocked"
- button "S6 · Post Assignments · blocked"
- button "S6 · Post SEE · blocked"
- text: Risk Snapshot 0 high · 5 medium · 715 low Queue State 0 open · 720 watch · 0 resolved 0 blocking students · 120 watched students No-Action Comparator 0 high-risk rows without simulated support Average Risk Change 0 scaled points Average Counterfactual Lift 0 scaled points Stage queue preview No stage queue items exist at this checkpoint. Offering action summary No offering rollups are available for this checkpoint. Imports msruas-mnc-curriculum.json approved · review-required · 26 unresolved mappings Crosswalk Review No pending crosswalk reviews. Runs MSRUAS proof rerun 9260 completed Seed 9260 · 2/4/2026, 2:48:29 am running · 5% Queue age n/a · lease leased
- button "Set Active"
- button "Archive"
- text: MSRUAS first-6-semester proof batch completed Seed 101 · 16/3/2026, 5:30:00 am Queue age n/a · lease released
- button "Set Active"
- button "Archive"
- text: "Teacher Load Dr. Devika Shetty Sem 1 · 4 contact hrs · 1 credits Dr. Devika Shetty Sem 2 · 3 contact hrs · 1 credits Dr. Devika Shetty Sem 3 · 4 contact hrs · 1 credits Dr. Devika Shetty Sem 4 · 4 contact hrs · 1 credits Dr. Devika Shetty Sem 5 · 4 contact hrs · 1 credits Dr. Devika Shetty Sem 6 · 4 contact hrs · 1 credits Queue Preview Aarav Sharma · MCC301A Mentor · Open · due 5/4/2026, 2:48:32 am Aarav Sharma · MCC310A Mentor · Open · due 5/4/2026, 2:48:32 am Ishita Sharma · AMC-S6-32 Mentor · Open · due 5/4/2026, 2:48:32 am Ishita Sharma · AMC-S6-33 Mentor · Open · due 5/4/2026, 2:48:32 am Ishita Sharma · AMC-S6-34 Mentor · Open · due 5/4/2026, 2:48:32 am Ishita Sharma · MCC301A Mentor · Open · due 5/4/2026, 2:48:32 am Vihaan Sharma · AID201A Mentor · Open · due 5/4/2026, 2:48:32 am Vihaan Sharma · AMC-S6-32 Mentor · Open · due 5/4/2026, 2:48:32 am Vihaan Sharma · AMC-S6-33 Mentor · Open · due 5/4/2026, 2:48:32 am Vihaan Sharma · MCC301A Mentor · Open · due 5/4/2026, 2:48:32 am Ananya Sharma · AID201A Mentor · Open · due 5/4/2026, 2:48:32 am Ananya Sharma · AMC-S6-32 Mentor · Open · due 5/4/2026, 2:48:32 am Lifecycle Audit No proof lifecycle audit entries yet. Recent Operational Events proof.run.claimed simulationRunId: simulation_run_f5892bb0-f6f4-47bb-ace9-8b5576665408 · batchId: batch_branch_mnc_btech_2023 · leaseToken: proof_worker_lease_21fda5d1-1c23-4112-9709-e943a0722e92 info backend 2/4/2026, 2:48:32 am proof.run.queued simulationRunId: simulation_run_f5892bb0-f6f4-47bb-ace9-8b5576665408 · batchId: batch_branch_mnc_btech_2023 · curriculumImportVersionId: curriculum_import_mnc_2023_first6_v1 info backend 2/4/2026, 2:48:29 am auth.session.restored sessionId: session_268fdfa8-3296-4b0d-82a7-2723c6948a81 · userId: user_sysadmin · facultyId: fac_sysadmin info backend 2/4/2026, 2:48:18 am auth.login.succeeded sessionId: session_268fdfa8-3296-4b0d-82a7-2723c6948a81 · userId: user_sysadmin · facultyId: fac_sysadmin info backend 2/4/2026, 2:48:18 am request.error method: GET · route: /api/session · statusCode: 401 warn backend 2/4/2026, 2:48:18 am"
```

## Academic portal login

- no blocking violations

## Teacher proof panel

- no blocking violations

## Teacher proof panel tree

```text
- text: "Proof Control Plane Proof Control Plane This panel only surfaces rerunnable proof data: active simulation runs, observed risk queue items, and elective-fit summaries. It does not expose latent-state internals."
- status: Authoritative proof panel for this faculty scope. Use this card and the linked proof routes for checkpoint-bound evidence; surrounding faculty-profile cards remain operational context.
- status: Scope Proof unavailable · resolved from No active proof run is available for this scope. · Unavailable counts · operational semester unavailable · Proof mode.
- text: Active run contexts No active run is linked to this faculty context. Monitoring queue No governed queue items are currently linked to this profile. Semester-6 elective fit No elective recommendation is currently available for this profile.
```

## Portal home

- no blocking violations

## System admin login

- no blocking violations

## System admin faculty detail tabs

```text
- tablist "Faculty detail sections":
  - tab "Profile" [selected]
  - tab "Appointments 1"
  - tab "Permissions 3"
  - tab "Teaching 0"
  - tab "Timetable"
  - tab "History 0"
```

