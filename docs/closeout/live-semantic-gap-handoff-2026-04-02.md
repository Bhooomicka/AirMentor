# Live Semantic Gap Handoff

Status: open blocker handoff for the next implementation session (not yet ideal for target product intent)

Last reviewed: 2026-04-02

Owner intent: this document captures what the user actually meant, what is actually broken on the current repo and deployed stack, and what the next agent must fix before the product can be called semantically complete.

## Product-Intent Perspective
- Is the current live state ideal for the product being built: no.
- Why: the product still breaks core promise boundaries (single pilot truth, semester coherence, cross-surface parity, and meaningful proof/risk behavior).
- Current state is best described as: technically running, semantically incomplete.
- The ideal target is not just a green deploy or green wrappers; it is a professor-trustworthy, proof-consistent system where the same student and semester truth is preserved across sysadmin, teacher, mentor, HoD, risk explorer, and student views.
- Until that state is achieved on deployed GitHub Pages + Railway evidence, this remains a blocker handoff, not a closeout.

Relationship to other closeout docs:
- This document supplements [final-authoritative-plan.md](./final-authoritative-plan.md).
- If [stage-08c-live-closeout-proof-pack-completion.md](./stage-08c-live-closeout-proof-pack-completion.md) appears more optimistic than the current live product truth, this document wins for semantic-closeout decisions.
- A green deploy or a green wrapper command is not sufficient if the product still violates the user’s intended workflow.

## Executive Verdict
- The current system is deployed and operational, but it is not semantically closed out.
- Several requested UI changes are present, and several verification wrappers are green, but the product still violates the core intent:
  - the wrong batch can be selected by default in sysadmin
  - semester state is split across multiple sources and can contradict itself
  - admin and teaching totals are still leaking broader seeded/global data
  - the same student can show contradictory indicators across surfaces
  - the proof/risk panel is still largely fallback-driven and does not yet prove meaningful intervention logic
  - semester `2..6` curriculum exists for the proof batch, but the sysadmin course view can still present a sem-1-only experience because it keys off the selected batch instead of the proof-semester context
- Current closeout status should therefore be read as:
  - deploy and route plumbing: mostly working
  - security/session contract: mostly working
  - semantic parity for the intended M&C proof workflow: not done

## Non-Negotiable User Intent
The next agent must preserve these as the actual product target, not reinterpret them:

1. One proof cohort only for the main pass:
   - `Proof MNC 2023`
   - `120` students
   - sections `A` and `B`
   - `60` students each
   - semesters `1..6`

2. Sysadmin is the source of truth for setup:
   - teacher assignment
   - HoD assignment
   - permissions
   - CE/SEE split
   - SGPA/CGPA rules
   - prerequisites
   - curriculum features
   - local overrides beating broader defaults
   - bulk mentor assignment within the current hierarchy scope

3. Every sysadmin change must show up correctly everywhere else:
   - teaching profile
   - mentor view
   - HoD view
   - student full profile
   - student partial profile
   - risk explorer
   - student shell

4. No proof-scoped screen may display mock or fallback business data if live backend data exists.

5. Same-student indicators must be uniform everywhere:
   - counts
   - CGPA/SGPA
   - risk band
   - watch/priority state
   - mentor assignment
   - course list
   - semester context

6. Semester `1` should begin without spurious actionable risk noise.
   - The user specifically expects no priority alerts at the start of semester `1`.
   - If the system shows universal medium-watch fallback rows at `pre-tt1`, that is not an acceptable end state.

7. Semesters `1..6` must be visible and operable as a coherent walkthrough.
   - The user must be able to see all courses across all supported semesters.
   - The proof control plane must allow clear semester/class selection.
   - Operational semester, batch semester, and playback checkpoint semester must not silently disagree.

8. The proof/risk system must be meaningful for the codebase’s intent.
   - It must not merely show generic fallback labels.
   - It must show believable behavior under realistic evidence distributions.
   - Interventions must have explainable impact.
   - Queue behavior and risk movement must be defensible to a professor.

9. The UI must be professor-readable.
   - separate proof control plane
   - no unreadable scroll wall
   - stable panel sizing
   - smooth transitions
   - no ugly out-of-place radial widgets
   - consistent panel colors, dropdown chrome, and overflow behavior

10. Final truth must be proven on the deployed GitHub Pages + Railway stack, not only locally.

## Verified Current State

### What is genuinely working
- GitHub Pages is reachable:
  - `https://raed2180416.github.io/AirMentor/`
- Railway health is reachable:
  - `https://api-production-ab72.up.railway.app/health`
- The latest GitHub Pages deploy succeeded.
- Local build, lint, and the base test suite pass.
- The closeout wrapper suites produced real artifacts and screenshots.
- Several requested UI features now exist:
  - sysadmin welcome hero
  - separate proof control plane panel
  - `Hide all` and `Restore all hidden` action-queue actions
  - floating proof launcher wiring
  - HoD proof analytics surface
- The proof batch does have semester `1..6` curriculum data on the backend.

### What is still false or misleading
- A green deploy is being mistaken for semantic completion.
- A green local/live wrapper is being mistaken for uniform cross-surface truth.
- The product can still show the wrong batch, the wrong semester, and contradictory student indicators while the current wrapper suites remain green.

## High-Confidence Live Findings

### 1. The proof/risk system is still fallback-heavy
The live proof control plane currently states all of the following:
- `Heuristic fallback only`
- `No active local artifact has been trained for this batch yet.`
- `No evaluation payload is available.`
- CO evidence mode is `fallback-simulated`
- `Risk Snapshot 0 high · 720 medium · 0 low`
- `0 open · 720 watch · 0 resolved`
- `120 watched students`
- `Average Counterfactual Lift 0 scaled points`

This is not an acceptable semantic end state for the intended professor-facing proof workflow.

Primary evidence:
- `output/playwright/08c-live-system-admin-live-accessibility-report.json`

Owning code:
- `src/system-admin-proof-dashboard-workspace.tsx`

### 2. The current sysadmin route can still be looking at the wrong live batch
The user’s pasted live state showing `Batch 2022` and semester-1-only behavior is credible.

There are at least two relevant live M&C-style batches:
- proof batch:
  - `batch_branch_mnc_btech_2023`
  - label `2023 Proof`
  - current semester `6`
- another live batch:
  - `batch_6238cb50-7d0f-471c-97fb-3061b1f48a2c`
  - label `2022`
  - current semester `1`

The sysadmin curriculum and batch configuration views are still keyed off the route-selected batch, not the proof run.

Primary evidence:
- user-reported live screen
- direct live batch probe on 2026-04-02
- prior defect history in `output/playwright/defect-register.json`

Owning code:
- `src/system-admin-live-app.tsx`
- `src/system-admin-live-data.ts`

### 3. Semester state is split and can contradict itself
Right now the UI can legitimately show one semester in the proof control plane and another in the curriculum/course areas.

Cause:
- proof activation updates `simulationRuns.activeOperationalSemester`
- it does not update the batch record’s `currentSemester`
- sysadmin curriculum display still defaults from the selected batch

This creates contradictory states such as:
- proof panel says operational semester `4` or `6`
- batch config/courses still behave like semester `1`
- student/teacher pages still render with sem-1-style context

Primary evidence:
- `src/system-admin-live-app.tsx`
- `src/system-admin-live-data.ts`
- `air-mentor-api/src/lib/proof-control-plane-activation-service.ts`
- live proof snapshots in `output/playwright/08c-live-system-admin-live-accessibility-report.json`

### 4. Semesters `2..6` are present in backend data for the proof batch
The missing-semesters complaint is not caused by absent proof curriculum rows.

Verified live backend truth for the proof batch:
- `36` curriculum rows
- semesters `1,2,3,4,5,6`
- `6` courses per semester

This means the current problem is route/batch/semester selection and UI wiring, not missing proof-batch curriculum data.

Primary evidence:
- direct live curriculum probe on 2026-04-02

Owning code:
- `src/system-admin-live-app.tsx`
- `src/system-admin-live-data.ts`

### 5. Admin totals are still globally leaking broader seeded data
The admin student registry endpoint remains globally scoped.

Verified live behavior:
- direct call to `/api/admin/students` returned `795` student rows
- broader seeded CSE rows are present

This makes the user’s complaints about counts like `673 active`, `542 mentor gaps`, and unrelated CGPA leakage structurally credible even if the exact numbers can change over time.

Owning code:
- `air-mentor-api/src/modules/students.ts`
- `air-mentor-api/src/modules/people.ts`

### 6. Teaching totals are still operational aggregates, not proof truth
The teacher dashboard can still show `240` total students while the proof cohort truth is `120`.

Cause:
- teaching-side totals are built from offering-level student arrays and summed operationally
- those counts are not yet the canonical proof-scoped unique-student totals

Primary evidence:
- `output/playwright/08c-live-course-leader-dashboard-proof.png`

Owning code:
- `src/academic-route-pages.tsx`

### 7. Same-student indicators are still contradictory across surfaces
This is a confirmed core bug.

Current product behavior still allows the same student to be rendered from different truth sources:
- sysadmin full/partial student data
- teacher operational aggregates
- faculty proof panel
- HoD proof analytics
- risk explorer
- student shell

The code itself documents this split in places:
- faculty profile warns that proof cards are checkpoint-bound while surrounding cards remain operational context

This directly explains why the same student can show different indicators, CGPA values, semester context, or watch state depending on the route.

Owning code:
- `air-mentor-api/src/modules/students.ts`
- `src/system-admin-live-app.tsx`
- `src/academic-route-pages.tsx`
- `src/academic-faculty-profile-page.tsx`
- `src/academic-proof-summary-strip.tsx`
- `src/pages/student-shell.tsx`
- `src/pages/risk-explorer.tsx`

### 8. The proof control plane exists, but is still too dense to present well
The separate proof panel is real, but the current surface is still a large unreadable wall of status lines, diagnostics, fallback summaries, and duplicated counts.

The user’s complaint that it is too hard to read and too scroll-heavy is correct.

Primary evidence:
- `output/playwright/08c-live-system-admin-live-accessibility-report.json`
- the user’s pasted live screen

### 9. HoD proof context is improved, but not semantically complete
The HoD proof analytics surface is no longer universally blank.

However:
- this does not prove that HoD sees every teacher/mentor correctly for the intended department scope
- this does not prove department-overview completeness
- this does not prove consistent teacher lists under every proof checkpoint

Primary evidence:
- `output/playwright/08c-live-hod-proof-analytics.png`

### 10. Teacher clickthrough parity is not fully re-proven on the final live run
The final live closeout log contains this line:
- `Teacher proof panel has no row-backed monitoring or elective-fit entries at this checkpoint; skipping teacher-specific risk-explorer and student-shell subflow.`

That means the product was not fully re-proven on the final live pass for:
- every visible student opening partial profile
- teacher proof panel risk-explorer handoff
- teacher proof panel student-shell handoff

Primary evidence:
- `output/detached/airmentor-08c-live-closeout-20260401T215001Z.log`

## Issue-By-Issue Status Map

Status legend:
- `proven`: verified and acceptable on live
- `partial`: implemented or visible, but not yet semantically or live-fully proven
- `broken`: verified defect
- `unproven`: not yet re-proven with adequate live evidence

### Sysadmin data, scope, and batch control
- Dash panels must reflect actual values, no mock fallbacks.
  - Status: `broken`
  - Reason: admin endpoints still expose global seeded data, and proof panel still shows fallback-heavy semantics.
- Bulk assign all students in current hierarchy scope to one mentor.
  - Status: `partial`
  - Reason: backend and UI exist; not fully re-proven on the live pilot in this final audit.
- Local overrides must beat global defaults.
  - Status: `partial`
  - Reason: override framework exists, but section-level authority and full cross-surface proof are not yet closed out.
- Only one pilot faculty slice for now.
  - Status: `partial`
  - Reason: the system can still leak broader cohorts and broader faculty context.
- New-faculty creation after pilot.
  - Status: `unproven`
  - Reason: not part of the current semantic audit pass.

### Sysadmin semester and curriculum visibility
- Must show all courses across semesters `1..6`.
  - Status: `broken`
  - Reason: backend data exists, but the UI still keys off the selected batch and can present a sem-1-only experience.
- Must be able to modify those courses in sysadmin.
  - Status: `broken`
  - Reason: same route/batch/semester mismatch blocks a coherent semester-wide editing experience.
- Proof control plane should be separate and readable.
  - Status: `partial`
  - Reason: separate panel exists, but it is still too dense and professor-unfriendly.

### Sysadmin UI and interaction polish
- Welcome admin message similar to teaching portfolio.
  - Status: `proven`
- Hide all action queue items.
  - Status: `proven`
- Restore hidden queue items.
  - Status: `proven`
- Smooth animation between subpanels.
  - Status: `unproven`
- Smooth action-queue close animation.
  - Status: `unproven`
- Smooth light/dark transition.
  - Status: `unproven`
- Circular quick-insight widgets should be replaced.
  - Status: `partial`
  - Reason: current live surfaces appear more card-based, but professor-readability is still not satisfactory.
- Dropdowns, bars, panel sizing, color consistency, and overflow need cleanup.
  - Status: `partial`
  - Reason: some shared shell work landed, but the user’s live readability complaints remain valid.

### Counts, mock data, and cross-surface parity
- Student totals must be `120`, not broad seeded counts.
  - Status: `broken`
- Mentor-gap totals must align with the pilot cohort.
  - Status: `broken`
- Teacher total must not show `240` for the pilot cohort.
  - Status: `broken`
- Full student profile must match partial profile and teaching surfaces.
  - Status: `broken`
- Partial profile must not show mock data.
  - Status: `broken`
- Mentor-mentee data must not use mock data.
  - Status: `broken`
- Same student must show the same indicators everywhere.
  - Status: `broken`

### Teacher and HoD clickthrough behavior
- Clicking any visible student in teaching surfaces should open partial profile.
  - Status: `partial`
  - Reason: implemented and previously tested, but not fully re-proven on the final live pass for all proof checkpoints.
- Clicking total students should open the full student list.
  - Status: `partial`
  - Reason: likely wired, but the count itself is still wrong.
- Clicking high watch should open the expanded list.
  - Status: `unproven`
  - Reason: not sufficiently re-proven in the final live evidence set.
- HoD should not falsely show `No active proof run`.
  - Status: `partial`
  - Reason: HoD proof panel now exists, but scope completeness is not fully closed out.
- HoD should show department overview, all teachers, and mentors under teacher.
  - Status: `partial`
  - Reason: some surfaces exist, but semantic completeness remains unproven.

### Proof launcher and proof surface consistency
- Every sysadmin and teaching screen should have a bottom-right proof launcher.
  - Status: `partial`
  - Reason: shared proof launcher exists; still needs live route-by-route parity verification.
- Popup/expanded overlay should expose more readable proof detail.
  - Status: `partial`
  - Reason: launcher exists, but proof detail readability is still insufficient.

### Semester-1 and stage behavior
- Semester `1` should not start with priority alerts.
  - Status: `partial`
  - Reason: there are no obvious open queue items at `pre-tt1`, but the current fallback panel still marks all rows medium/watch, which is not defensible as meaningful semester-start behavior.
- Lock/unlock flow with HoD approval.
  - Status: `partial`
  - Reason: request flows and security flows are covered, but not yet semantically re-proven as part of the full semester walk.
- Recurring tasks, defer, hide, restore.
  - Status: `partial`
  - Reason: flow pieces exist; meaningful semester-wide parity is not yet fully proven.

### AI / risk / intervention meaningfulness
- Risk analysis should be meaningful, not generic fallback output.
  - Status: `broken`
- Interventions should have meaningful impact and visible lift.
  - Status: `broken`
  - Reason: live panel currently shows zero average counterfactual lift.
- The system should support realistic semester-by-semester simulation with believable distributions.
  - Status: `unproven`
- Predicted CGPA and total CGPA should be consistent with configured rules.
  - Status: `unproven`
- Rule changes should trigger deterministic recomputation, not stale proof state.
  - Status: `partial`
  - Reason: activation and recompute flows exist, but model-quality closure is not there.

### Deploy and CI
- GitHub Pages deployment is failing.
  - Status: `not true`
  - Reason: GitHub Pages is currently healthy.
- There are failing GitHub workflows.
  - Status: `proven`
  - Reason: current failures are verification jobs, especially backend parity/proof tests, not the frontend deploy itself.

## Root Cause Inventory

### Root cause 1: wrong default source of truth
The product still allows proof-facing screens to read from:
- global admin registry data
- operational offering aggregates
- checkpoint-bound proof payloads
- batch-local semester state

without first reconciling them into one authoritative proof-scoped contract.

### Root cause 2: semester state is not unified
At minimum these are still distinct:
- batch current semester
- proof active operational semester
- playback checkpoint semester
- route-selected semester/course context

They are not forced into a single authoritative state machine.

### Root cause 3: proof semantics are still fallback-driven
The proof UI itself admits the system is relying on fallback heuristics and missing active trained/evaluated artifacts.

### Root cause 4: closeout automation is stronger on route presence than semantic truth
Current wrappers prove a lot of route plumbing, session security, and artifact capture, but they do not yet fail loudly enough when:
- proof scope silently falls back to global
- teacher totals double-count
- same-student indicators diverge
- proof semester and batch semester disagree
- proof outputs are still fallback-only

## Owning Code Hotspots
- `src/system-admin-live-app.tsx`
  - route parsing
  - selected batch resolution
  - curriculum-by-semester selection
- `src/system-admin-live-data.ts`
  - curriculum filtering by batch
- `src/system-admin-proof-dashboard-workspace.tsx`
  - fallback-heavy proof control plane rendering
- `src/academic-route-pages.tsx`
  - operational teaching totals and high-watch derivation
- `src/academic-faculty-profile-page.tsx`
  - explicit proof-vs-operational split warning
- `src/academic-proof-summary-strip.tsx`
  - checkpoint-bound proof summary rendering
- `src/pages/student-shell.tsx`
  - proof-facing student surface
- `src/pages/risk-explorer.tsx`
  - proof-facing risk/student exploration
- `air-mentor-api/src/modules/students.ts`
  - global admin student routes and academic-profile-derived CGPA
- `air-mentor-api/src/modules/people.ts`
  - global faculty admin routes
- `air-mentor-api/src/lib/proof-control-plane-activation-service.ts`
  - active operational semester update without batch semester synchronization

## Evidence Pack To Carry Forward
- `output/playwright/08c-live-system-admin-live-accessibility-report.json`
- `output/playwright/08c-live-course-leader-dashboard-proof.png`
- `output/playwright/08c-live-mentor-view-proof.png`
- `output/playwright/08c-live-hod-proof-analytics.png`
- `output/playwright/08b-live-proof-risk-smoke-summary.json`
- `output/playwright/08c-live-closeout-artifact-bundle.json`
- `output/playwright/defect-register.json`
- `output/detached/airmentor-08c-live-closeout-20260401T215001Z.log`

## Mandatory Remediation Order
The next agent should not attack this randomly. The correct order is:

### Stage A: force canonical pilot-batch scoping
- make the proof batch the default pilot selection for proof-mode sysadmin and teaching surfaces
- remove silent fallback to the wrong live batch
- add visible scope provenance on every affected surface
- fail automation if the selected proof route is not the canonical proof batch

### Stage B: unify semester state
- create one authoritative semester contract spanning:
  - batch config
  - proof control plane
  - curriculum/course visibility
  - teacher surfaces
  - student surfaces
  - playback checkpoint
- disallow silent disagreement between batch semester, operational semester, and visible course semester

### Stage C: define one canonical student-indicator contract
- one source of truth for:
  - CGPA/SGPA
  - risk band
  - watch/priority flags
  - mentor assignment
  - current semester
  - course visibility
- make sysadmin, teacher, mentor, HoD, risk explorer, and student shell consume the same indicator contract in proof mode

### Stage D: remove global and mock leakage
- proof-scoped admin/faculty/student surfaces must stop reading broad global seeded data by default
- all mock/fallback business values should either:
  - disappear when live data exists
  - or be explicitly labeled unavailable

### Stage E: repair teacher and HoD aggregation semantics
- unique-student totals must match the pilot cohort
- high-watch counts must match the same proof-scoped student set
- every summary card must open the matching filtered list
- HoD department overview must include the full intended teacher/mentor picture for the active proof scope

### Stage F: make proof meaningful before polishing it
- do not spend another full pass polishing the proof panel while it still says fallback-only
- first fix:
  - artifact availability
  - model/evaluation diagnostics
  - non-fallback evidence paths
  - stage-wise meaningful lift and recommendation semantics

### Stage G: then finish the professor-facing UI cleanup
- simplify proof control plane hierarchy
- reduce wall-of-text density
- stabilize panel sizing
- resolve overflow and inconsistent dropdown/panel chrome
- improve motion and theme transitions

### Stage H: rerun the deployed semester walk
- semester `1..6`
- `pre-tt1`, `post-tt1`, `post-tt2`, `post-assignments`, `post-see`
- sysadmin, teacher, mentor, HoD, risk explorer, student shell
- one same-student parity proof pack at each major checkpoint

## Acceptance Criteria For The Next Agent
The next agent must not declare success until all of these are true:

1. The active proof route always resolves to the canonical pilot batch unless the user deliberately changes scope.
2. The product cannot silently disagree about semester.
3. Sysadmin can show and edit courses for semesters `1..6`.
4. Teacher totals, admin totals, and HoD totals all reconcile to the same pilot truth.
5. The same student shows the same indicator state on every surface.
6. No proof-scoped screen leaks mock or unrelated seeded data.
7. Semester `1` startup does not produce non-defensible risk noise.
8. The proof panel no longer reports fallback-only semantics for the main pilot workflow.
9. Intervention logic shows meaningful non-zero change where it should.
10. The proof control plane is presentable to a professor.
11. The full semester-walk proof pack passes on GitHub Pages + Railway.

## External Provider And Security Rules
- Do not use the Gemini API key pasted in chat.
- Do not commit, log, or screenshot secrets from chat, shell env, CI, or provider dashboards.
- If a later stage touches external-provider support, it must use environment-managed secrets only and follow the existing provider-governance contract in the closeout docs.
- The core proof-risk path remains deterministic/artifact-backed for this closeout unless a deliberate later design change says otherwise.

## Required External Research For The Next Agent
For time-sensitive implementation details, use current official docs before coding. At minimum:
- Framer Motion or the current Motion docs for transition and layout-stability patterns
- Playwright docs for reliable deployed-flow automation
- GitHub Actions docs for workflow hardening
- Railway docs for deploy and health verification details
- official docs for any external-provider integration touched later

Do not substitute tutorial-grade sources for official docs when current official docs exist.

## Final Direction
- Treat the product as functionally wired but semantically incomplete.
- Do not continue from “stage 08C passed” as though the user’s intent has already been met.
- Start from the actual blockers in this document and repair the source-of-truth contracts first.
