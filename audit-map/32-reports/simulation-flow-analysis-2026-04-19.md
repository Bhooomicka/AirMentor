# Simulation Flow Analysis — 2026-04-19
# Critical analysis of: ML configurables, teacher gates, credential lifecycle, unlock flow, time-travel

---

## 1. WHAT EXISTS NOW vs WHAT THE VISION REQUIRES

### Current state (what is seeded, fixed, non-interactive)

The simulation seeds everything deterministically from a `runSeed` string. Once seeded, the data is fixed — no user-facing sliders change any ML parameters at runtime. The "simulation" is pre-computed: all 6 semesters of student data are generated at seed time, then the time-travel (advance) feature reveals them stage by stage.

The parameters below exist in the code but are **NOT yet exposed as UI sliders**. They are hardcoded via `stableBetween(seed, min, max)` calls.

---

## 2. ML MODEL CONFIGURABLES — CURRENT STATE AND SLIDER POTENTIAL

### The 27 features (all read-only from current data, none are sliders)

The ML model (`proof-risk-model.ts`) computes a risk probability from 27 scaled features:

| Feature | What it measures | Slider target? |
|---|---|---|
| `attendancePctScaled` | raw attendance % / 100 | YES — baseline attendance |
| `attendanceTrendScaled` | trend (improving/declining) | derived, not slideable directly |
| `attendanceHistoryRiskScaled` | count of weeks below 75% | derived |
| `currentCgpaScaled` | CGPA / 10 | YES — starting CGPA |
| `backlogPressureScaled` | backlog count / max | YES — backlog count |
| `tt1RiskScaled` | TT1 score risk | YES — assessment difficulty |
| `tt2RiskScaled` | TT2 score risk | YES — assessment difficulty |
| `seeRiskScaled` | SEE score risk | YES — assessment difficulty |
| `quizRiskScaled` | quiz score risk | derives from assessmentDifficultyIndex |
| `assignmentRiskScaled` | assignment score risk | derives from assessmentDifficultyIndex |
| `weakCoPressureScaled` | count of weak co-enrollments / 4 | section environment |
| `weakQuestionPressureScaled` | weak quiz question count / max | section environment |
| `courseworkTtMismatchScaled` | coursework vs TT score mismatch | student behavior |
| `ttMomentumRiskScaled` | TT1→TT2 momentum | student trajectory |
| `interventionResidualRiskScaled` | residual risk after interventions | depends on receptivity |
| `prerequisite*` (8 features) | historical prerequisite chain health | seed-time curriculum config |
| `semesterProgressScaled` | how far into semester | time-based |
| `sectionPressureScaled` | section aggregate risk | emergent from all students |

### Per-section environment parameters (the real sliders — currently seeded, not exposed)

These are the parameters that differ between Section A and Section B. Each is drawn from `stableBetween(seed, min, max)` per semester per section:

| Parameter | Current range | Proposed Section A range | Proposed Section B range | Effect |
|---|---|---|---|---|
| `teacherStrictnessIndex` | `[0.32, 0.78]` | `[0.55, 0.78]` (strict) | `[0.32, 0.50]` (lenient) | Higher strictness → more attendance failures flagged → higher section risk |
| `assessmentDifficultyIndex` | `[0.38, 0.84]` | `[0.38, 0.55]` (easier) | `[0.65, 0.84]` (harder) | Higher difficulty → lower raw scores → more students cross risk threshold |
| `interventionCapacity` | `[0.34, 0.82]` | `[0.60, 0.82]` (high capacity) | `[0.34, 0.55]` (low capacity) | Lower capacity → fewer interventions executed → residual risk accumulates |

### Per-student behavioral parameters (seeded from `PROOF_SCENARIO_FAMILIES`, not exposed as sliders)

Each student is assigned a scenario family that determines their profile:

| Family | `interventionReceptivity` range | `practiceCompliance` range | `attendancePropensity` range | Typical outcome |
|---|---|---|---|---|
| `balanced` | 0.65–0.85 | 0.65–0.80 | 0.75–0.95 | Low risk, recovers well |
| `weak-foundation` | 0.50–0.70 | 0.45–0.65 | 0.70–0.85 | Medium risk, prerequisite chain weak |
| `low-attendance` | 0.40–0.60 | 0.60–0.75 | 0.30–0.55 | High risk from attendance features |
| `high-forgetting` | 0.55–0.70 | 0.50–0.65 | 0.70–0.85 | Risk increases at TT2 and SEE |
| `coursework-inflation` | 0.70–0.85 | 0.80–0.95 | 0.75–0.90 | Low coursework risk but high TT mismatch |
| `exam-fragility` | 0.55–0.70 | 0.65–0.80 | 0.70–0.85 | Passes coursework, fails at SEE |
| `carryover-heavy` | 0.40–0.55 | 0.40–0.55 | 0.60–0.75 | High backlog pressure, escalation likely |
| `intervention-resistant` | 0.10–0.25 | 0.20–0.40 | 0.50–0.70 | Interventions fail, risk persists |

### Risk band thresholds (hardcoded, not slideable)

```
PRODUCTION_RISK_THRESHOLDS = { medium: 0.40, high: 0.85 }
```
- `< 0.40` → **Low** (green)
- `0.40–0.84` → **Medium** (amber)
- `≥ 0.85` → **High** (red)

### Proposed slider UI for admin simulation config

To expose two distinct classroom environments (Section A = stronger cohort, Section B = at-risk cohort):

```
Section A: "High-performing cohort"
  teacherStrictnessIndex: slider [0.50 → 0.80], default 0.65
  assessmentDifficultyIndex: slider [0.30 → 0.60], default 0.45
  interventionCapacity: slider [0.55 → 0.85], default 0.70

Section B: "At-risk cohort"
  teacherStrictnessIndex: slider [0.25 → 0.55], default 0.38
  assessmentDifficultyIndex: slider [0.60 → 0.90], default 0.75
  interventionCapacity: slider [0.25 → 0.55], default 0.38

Global:
  Scenario mix: radio [ balanced only | mixed | at-risk heavy ]
  runSeed: text input (changes all deterministic values)
```

**What needs to be built:** Accept these slider values in `POST /api/admin/proof/seed` body instead of computing them from seed alone. Store them in the simulation config table. Pass them into `seedIntoDatabase` as override parameters. The seed-based computation becomes the fallback when no overrides are given.

---

## 3. TEACHER-SIDE GATE REQUIREMENTS AT EACH STAGE

The proof pipeline has 5 stages. Advancing from one stage to the next requires ALL of the following gates to be clear:

### Stage 1: `pre-tt1` → `post-tt1` (day 0 → day 35)

Gates before advance is allowed:
1. **Evidence gate:** `requiredEvidence: ['attendance']` — attendance must be entered and locked for the offering
2. **Queue clearance:** `requireQueueClearance: true` — no pending at-risk escalation cases in queue for this offering
3. **Task clearance:** `requireTaskClearance: true` — all assigned mentoring tasks must be marked complete
4. **TT1 scores entered:** TT1 scores must be present for all enrolled students (this is the evidence that triggers the ML run)
5. **advancementMode: `admin-confirmed`** — System Admin must explicitly click "advance" (not automatic)

### Stage 2: `post-tt1` → `post-tt2` (day 35 → day 77)

Gates:
1. **Evidence gate:** `requiredEvidence: ['tt1']` — TT1 evidence must be locked
2. **Queue clearance** — all TT1-generated cases must be resolved (approved or closed)
3. **Task clearance** — interventions assigned at TT1 must be marked done
4. **TT2 scores entered** — TT2 scores must be present
5. **Admin confirmed**

### Stage 3: `post-tt2` → `post-assignments` (day 77 → day 98)

Gates:
1. **Evidence gate:** `requiredEvidence: ['tt2']` — TT2 evidence locked
2. **Queue clearance** — TT2 cases resolved
3. **Task clearance**
4. **Assignment scores entered**
5. **Admin confirmed**

### Stage 4: `post-assignments` → `post-see` (day 98 → day 119)

Gates:
1. **Evidence gate:** `requiredEvidence: ['assignment']` — assignment evidence locked
2. **Queue clearance** — assignment-stage cases resolved
3. **Task clearance**
4. **SEE scores entered**
5. **Admin confirmed**

### Stage 5: `post-see` → CLOSED (day 119+)

Gates:
1. **Evidence gate:** `requiredEvidence: ['finals']` — SEE/finals evidence locked
2. **Queue clearance** — all final-stage cases resolved
3. **Task clearance**
4. **Admin confirmed** — closes the semester proof run

### What "queue clearance" actually means

Each at-risk student generates a `proofCase`. A case is "in queue" when:
- Student's risk band is **High** (prob ≥ 0.85)
- OR faculty has flagged them for escalation
- OR automatic rule triggered (backlog count ≥ threshold, attendance < 65%)

The case must reach one of these terminal states before the stage can advance:
- `resolved` — faculty reviewed and closed (student improved or accepted risk)
- `escalated_to_hod` AND `hod_approved` — HOD reviewed and approved advancement despite risk
- `escalated_to_hod` AND `hod_rejected` → **blocks advance** — HOD says not ready

### What "task clearance" means

Each intervention assigned to a mentor generates a task. All tasks for an offering must reach `complete` or `skipped` state before stage advance.

---

## 4. AUTO-GENERATED STUDENT AND TEACHER CREDENTIALS

### Current credential lifecycle

When `POST /api/admin/proof/seed` is called:

1. **Faculty accounts created:**
   - Pulled from `platform.seed.json` — fixed set of faculty personas (e.g., `kavitha.rao`, `rajesh.kumar`)
   - Passwords are set via argon2id hash of a deterministic seed-derived password
   - `passwordSetupTokens` are NOT generated automatically — invites must be triggered separately via `POST /api/admin/faculty/:id/password-setup`

2. **Student accounts created:**
   - Each student gets a `studentId` (nanoid), section assignment (A or B), and a deterministic profile
   - Students do NOT have login credentials by default — they are observed entities, not users
   - If the student-facing shell is to be shown, student login must be provisioned separately

3. **Credentials for Section A:**
   - Faculty: rotated from the course leader list with `courseIndex % courseLeaderFaculty.length`
   - Section A gets index 0, 1, 2, ... (no offset)

4. **Credentials for Section B:**
   - Same faculty list but offset by 1: `(courseIndex + 1) % courseLeaderFaculty.length`
   - This means Section A and B share some faculty on different courses, simulating reality

### What happens on reset (`POST /api/admin/proof/reset`)

- All runtime proof run data for semester 6 is cleared
- Seeded historical data (semesters 1–5) is preserved
- Faculty accounts and student accounts are preserved
- Proof cases and queue items are cleared
- The simulation returns to `pre-tt1` state
- Faculty can log in again with the same credentials

### What DOES NOT exist yet (required for the vision)

- Auto-generated, ephemeral student login credentials that expire on reset
- Per-simulation credential roster (a printable list of all usernames/passwords for demo participants)
- Credential lifecycle hooks (create on seed, disable on reset, delete on new seed)

---

## 5. REQUEST-TO-UNLOCK FLOW (Faculty → HOD)

### When is an unlock request triggered?

A faculty member cannot advance a student's case from `escalated` state without HOD approval. The unlock flow is:

```
Faculty sees High-risk student in queue
  → Faculty clicks "Escalate to HOD" (or automatic escalation at threshold)
  → Creates ProofCase with status: 'escalated_to_hod'
  → HOD sees this in their request queue (GET /api/admin/requests)

HOD reviews:
  → HOD can view student's full proof history, risk scores, evidence
  → HOD clicks "Approve advancement" → POST /api/admin/requests/:id/approve
      → Case status: 'hod_approved'
      → Faculty can now close the case and advance the stage
  → HOD clicks "Reject" → POST /api/admin/requests/:id/reject
      → Case status: 'hod_rejected'
      → Stage advance for this offering is BLOCKED until case is re-reviewed
```

### What the HOD sees in the request workspace

- Student name, section, offering (course × section)
- Current risk band and probability
- All 27 feature values (the observable evidence)
- Intervention history (was intervention offered? accepted? completed?)
- Attendance history across checkpoints
- Prerequisite chain health (did they carry backlogs?)
- Which faculty member escalated and why

### What is NOT yet built

- Push notification to HOD when a new escalation arrives
- Email notification for escalation (the email transport is now wired, just needs the template)
- HOD dashboard showing "X requests pending, Y blocking advance"
- SLA tracking (how long has a request been pending?)

---

## 6. TIME-TRAVEL (ADVANCE SYSTEM DATE) — HOW IT WORKS

### Current mechanism

`POST /api/admin/proof/advance` calls `proof-control-plane-playback-service.ts`:

1. Reads the current stage from `proofActiveRun`
2. Looks up the next stage in `DEFAULT_STAGE_POLICY.stages`
3. Populates the next stage's student data (scores, attendance, interventions) from the pre-seeded simulation data
4. Updates `proofActiveRun.currentStageKey` to the next stage
5. Sets `proofActiveRun.currentDate` to `baseNow + semesterDayOffset` for the new stage
6. Triggers proof run queue to re-compute ML scores for all students with new data

**The date is not the system clock** — it is a virtual date stored in `proofActiveRun.currentDate`. The frontend reads this virtual date and displays it as "current checkpoint date". This is why time-travel is instant and reversible.

### What "advance" actually reveals

Each advance call reveals the data that was pre-computed at seed time for that checkpoint. The ML model re-runs on the revealed data. Risk bands update.

**Stage-by-stage data revealed:**

| Stage | Day offset | Data revealed |
|---|---|---|
| `pre-tt1` | 0 | Attendance week 1–4 only |
| `post-tt1` | 35 | TT1 scores + attendance weeks 1–5 |
| `post-tt2` | 77 | TT2 scores + attendance weeks 1–11 |
| `post-assignments` | 98 | Assignment scores + quiz scores |
| `post-see` | 119 | SEE/finals scores — final risk bands |

### What advancing requires (before the button is clickable)

- All gate conditions for the current stage must be met (Section 3 above)
- System Admin role required — faculty cannot trigger advance
- The current stage must not be `post-see` (already at end)

### What is NOT yet built for time-travel

- **Per-stage date picker** — instead of fixed offsets, let admin pick a specific date within the allowed range
- **Partial advance** — reveal data for some students but not others (split class scenario)
- **Rewind** — currently, once advanced past a stage, only a full reset can go back (no per-stage rewind)
- **Manual date override** — currently the virtual date is always `baseNow + semesterDayOffset`, but there's no UI to say "pretend today is March 15" without actually seeding at that date

---

## 7. TWO-SECTION DIFFERENTIATED ENVIRONMENT — IMPLEMENTATION PLAN

To make the demo clearly show Section A (strong) vs Section B (at-risk):

### Seed-time config changes needed

```typescript
// POST /api/admin/proof/seed body
{
  runSeed: "msruas-2026",
  sectionOverrides: {
    A: {
      teacherStrictnessIndex: 0.72,  // high — strict attendance
      assessmentDifficultyIndex: 0.42,  // low — accessible exams
      interventionCapacity: 0.75,  // high — teacher engages actively
      scenarioMix: { balanced: 0.6, weakFoundation: 0.2, examFragility: 0.2 }
    },
    B: {
      teacherStrictnessIndex: 0.35,  // low — lenient, misses warning signs
      assessmentDifficultyIndex: 0.78,  // high — hard assessments
      interventionCapacity: 0.38,  // low — teacher overwhelmed
      scenarioMix: { balanced: 0.1, lowAttendance: 0.3, carryoverHeavy: 0.3, interventionResistant: 0.3 }
    }
  }
}
```

### Expected simulation outcome with these settings

**Section A after post-tt1:**
- ~70–80% students Low risk
- ~15–25% students Medium risk
- ~0–5% students High risk
- ML features dominant: high attendance, passing TT1, low backlog

**Section B after post-tt1:**
- ~20–30% students Low risk
- ~30–40% students Medium risk
- ~30–40% students High risk
- ML features dominant: low attendance, failing TT1, prerequisite pressure
- Multiple cases in HOD escalation queue
- Several cases blocking stage advance → demo of unlock request flow

---

## 8. SUMMARY: WHAT EXISTS, WHAT NEEDS BUILDING

| Feature | Status |
|---|---|
| Seeded student/faculty data | EXISTS |
| Deterministic RNG from runSeed | EXISTS |
| Per-section environment parameters | EXISTS (seeded only, no UI override) |
| 27-feature ML model | EXISTS |
| Stage gate policy (5 stages) | EXISTS |
| Queue clearance requirement | EXISTS |
| Task clearance requirement | EXISTS |
| HOD unlock request flow | EXISTS (routes exist, UI partially built) |
| Time-travel / stage advance | EXISTS |
| Email transport (noop + SMTP) | EXISTS (added this session) |
| Two-section differentiated config via sliders | MISSING |
| Student login credentials lifecycle | MISSING |
| Per-simulation credential roster | MISSING |
| Email notification on escalation | MISSING (transport exists, template missing) |
| Partial advance / per-student date | MISSING |
| Stage rewind (without full reset) | MISSING |
| HOD push notification for requests | MISSING |
