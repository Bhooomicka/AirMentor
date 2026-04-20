# AirMentor Screen Reader Preflight

Generated: 2026-04-16T11:16:57.362Z

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
- text: 16 Apr, 04:45 pm
- button "Switch to dark mode": 🌙
- button "Hide action queue": "1"
- button "Refresh admin data"
- button "Logout"
- button "Proof Control · open dialog": Proof Control
- text: Opens the shared proof control surface.
- complementary:
  - text: Operations Rail Governed Requests MNC proof branch · 3rd Year · Batch 2023 Proof
  - button "Collapse operations rail"
  - textbox "Admin search":
    - /placeholder: Search governed requests...
  - navigation:
    - button "Overview"
    - button "Proof"
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
  - tab "Academic 6"
  - tab "Mentor 1"
  - tab "Progression"
  - tab "History 0"
```

## System admin student edit dialog

- no blocking violations

## System admin student edit dialog tree

```text
- dialog "Edit Aarav Gupta":
  - text: Student Edit Edit Aarav Gupta Update the core student identity from a focused dialog instead of the stretched workspace card.
  - button "Close dialog": ×
  - text: Name
  - textbox "Student Name": Aarav Gupta
  - text: USN
  - textbox "Student USN": 1MS23MC101
  - text: Roll Number
  - textbox "Student Roll Number": MC-101
  - text: Admission Date
  - textbox "Student Admission Date": 2023-08-01
  - text: Email
  - textbox "Student Email": 1ms23mc101@student.msruas.ac.in
  - text: Phone
  - textbox "Student Phone": +91-8000000101
  - button "Cancel"
  - button "Delete Student"
  - button "Save Student"
```

## System admin proof dashboard tabs

```text
- tablist "Proof control-plane sections":
  - tab "Summary"
  - tab "Checkpoint" [selected]
  - tab "Diagnostics"
  - tab "Operations"
```

## System admin proof dashboard

- no blocking violations

## System admin proof dashboard tree

```text
- text: Proof Control Plane Proof Control Plane A compact proof shell for run control, checkpoint playback, and runtime evidence.
- button "Create Import"
- button "Run / Rerun"
- button "Recompute Risk"
- text: Active run MSRUAS proof rerun 61453 Semester 6 Pre TT1 · S1 1 imports
- status: Playback override active. The dashboard is pinned to Semester 1 · Pre TT1, while the operational semester remains Semester 6.
- text: Proof workflow rail Semester + checkpoint controls stay visible here. Use this rail to activate the live proof semester, step playback, and inspect the selected checkpoint without bouncing between tabs. Run MSRUAS proof rerun 61453 Semester 6 Pre TT1 · S1 0 queued Operational semester
- button "Sem 1"
- button "Sem 2"
- button "Sem 3"
- button "Sem 4"
- button "Sem 5"
- button "Sem 6" [disabled]
- text: Selected checkpoint Semester 1 · Pre TT1 · Opening stage before TT1 closes. Scheme setup, attendance updates, and class execution stay open here.
- button "Reset Playback To Semester 1" [disabled]
- button "Reset Branch From Scratch" [disabled]
- button "Previous" [disabled]
- button "Next"
- button "Play To End" [disabled]
- status: "Selected checkpoint: semester 1 · Pre TT1. This stage is synced into the academic playback overlay for teaching surfaces."
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
- group: Scope details
- tablist "Proof control-plane sections":
  - tab "Summary" [selected]
  - tab "Checkpoint"
  - tab "Diagnostics"
  - tab "Operations"
- tabpanel "Summary": "Current Proof State MSRUAS proof rerun 61453 Seed 61453 · completed running · 5% 0 saved snapshots · 720 watch scores Selected Checkpoint Semester 1 · Pre TT1 Risk 0/1/119 Queue 0/0/0 No-Action Comparator 0 · Average Risk Change 0 · Average Counterfactual Lift 0 Action Pressure 657 active reassessments · 720 alert decisions Queue Health: 0 queued · 0 running · 0 failed Checkpoint Readiness: 1/30 checkpoints ready Worker Lease: leased · running Risk Model Runtime diagnostics only · 0 active rows 0 run corpus · 0 checkpoint rows Runtime diagnostics are available for this run even though no stored evaluation artifact is active. · No stored production artifact is active; this dashboard is reporting checkpoint-governed runtime diagnostics."
```

## Academic portal login

- no blocking violations

## Teacher proof panel

- no blocking violations

## Teacher proof panel tree

```text
- text: "Proof Control Plane Proof Control Plane This panel only surfaces rerunnable proof data: active simulation runs, observed risk queue items, and elective-fit summaries. It does not expose latent-state internals."
- status: Authoritative proof panel for this faculty scope. Use this card and the linked proof routes for checkpoint-bound evidence; nearby summary and scope cards stay checkpoint-bound where possible, while permissions, appointments, and timetable-governance details remain operational context.
- status: Provenance · scope Proof unavailable · resolved from No active proof run is available for this scope. · Unavailable counts · operational semester unavailable · Proof mode.
- text: Active run contexts No active run is linked to this faculty context. Monitoring queue No governed queue items are currently linked to this profile. Proof-semester elective fit No elective recommendation is currently available for this profile.
```

## Portal home

- no blocking violations

## System admin login

- no blocking violations

## System admin faculty detail tabs

```text
- tablist "Faculty detail sections":
  - tab "Profile" [selected]
  - tab "Appointments 0" [disabled]
  - tab "Permissions 0" [disabled]
  - tab "Teaching 0" [disabled]
  - tab "Timetable Locked" [disabled]
  - tab "History 0" [disabled]
```

