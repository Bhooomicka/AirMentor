# Final Authoritative AirMentor Closeout Plan

Status: authoritative handoff for the next implementation sessions

Last reviewed: 2026-03-29

## Purpose
- This document is the single source of truth for the next agentic implementation sessions.
- It is intended to be executed stage by stage without product-level ambiguity.
- It is grounded in the current repo, the current deployed stack, the audit pack, and the prior planning chat.

## Coverage Confirmation
This plan explicitly covers:
- all sysadmin concerns raised in the chat
- teaching profile parity with sysadmin
- mentor and mentee parity
- HoD overview, faculty visibility, and proof context
- student partial profile and full profile parity
- proof control plane separation and usability
- semester-by-semester proof verification for semesters `1..6`
- stage-by-stage simulation and evidence entry
- UI consistency, overflow, sizing, motion, and theme transitions
- no-mock-data requirements on proof-scoped surfaces
- security, auth, CSRF, role boundaries, and deployed session verification
- logging, audit, telemetry, queue diagnostics, and evidence capture
- curriculum-linkage and external-model governance
- deployed GitHub Pages plus Railway verification with screenshot artifacts

## Explicit Boundaries
- Pilot cohort: `Proof MNC 2023`
- Pilot size: `120` students total
- Sections: `A`, `B`
- Proof-semester coverage: `1..6` only
- Semesters `7..8`: explicitly out of scope for this closeout
- First pass: one faculty and HoD operating slice
- Second pass after pilot green: newly created faculty onboarding and verification
- Core proof-risk engine remains deterministic and artifact-backed in this pass
- Gemini or other external LLMs are not part of the core proof-risk path in this pass

## Repo And Deployment Facts The Next Agent Must Not Re-Decide
- The proof sandbox currently supports semesters `1..6` only.
- Semesters `1..5` are mostly historical proof state; semester `6` is the only fully materialized live operational semester today.
- The extracted sysadmin faculties workspace now owns the governance, stage-policy, curriculum, semester, and provisioning editor UI; the live sysadmin shell still supplies state, data, and action handlers.
- The current count mismatches are likely caused by proof views mixing the `120`-student proof cohort with larger seeded institutional totals.
- Policy override precedence currently stops at `batch`; `section` is not yet authoritative and must be added.
- The current deployed stack is live:
  - `https://raed2180416.github.io/AirMentor/`
  - `https://api-production-ab72.up.railway.app/health`
- The repo already has real deployed verification entrypoints:
  - `npm run verify:final-closeout`
  - `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> npm run verify:final-closeout:live`

## Implementation Discipline
- Future implementation work should prefer current official documentation and primary sources for any framework or platform behavior that is not repo-local.
- For implementation details that may drift over time, consult current official docs before coding:
  - Framer Motion
  - Playwright
  - GitHub Actions
  - GitHub Pages
  - Railway
  - any external model/provider documentation if that subsystem is touched later
- Use official docs and official changelogs first. Avoid tutorial-grade sources when official docs are available.
- When implementation depends on current browser/platform behavior, verify it on the deployed GitHub Pages plus Railway stack, not only locally.

## Authoritative Deliverables
- `docs/closeout/final-authoritative-plan.md`
- `docs/closeout/final-authoritative-plan-security-observability-annex.md`
- `docs/closeout/deploy-env-contract.md`
- `docs/closeout/operational-event-taxonomy.md`
- `output/playwright/assertion-catalog.json`
- `output/playwright/execution-ledger.jsonl`
- `output/playwright/proof-evidence-manifest.json`
- `output/playwright/proof-evidence-index.md`
- `output/playwright/defect-register.json`

## Public APIs, Types, And Runtime Contracts
- Add `section` to `ScopeTypeValue` and `ApiScopeType`.
- Encode `section` scope ids as `<batchId>::<sectionCode>`.
- Authoritative precedence becomes:
  - `institution -> academic-faculty -> department -> branch -> batch -> section`
- Extend resolved policy and proof payloads with:
  - `scopeDescriptor`
  - `resolvedFrom`
  - `scopeMode`
  - `countSource`
  - `activeOperationalSemester`
- Add bulk mentor assignment:
  - `POST /api/admin/mentor-assignments/bulk-apply`
  - preview count
  - explicit confirmation
  - audit trail
  - end-date prior active assignments
- Add proof-semester activation:
  - `POST /api/admin/proof-runs/:simulationRunId/activate-semester`
  - `semesterNumber: 1..6`
  - rebuild offerings, ownership, checkpoint context, proof-scoped counts, and proof-facing UI context
- Add build metadata exposure on frontend and backend so deployed verification can assert commit identity before evidence capture starts.
- Add explicit curriculum-linkage provider contract:
  - `AIRMENTOR_LINKAGE_PROVIDER=deterministic|python-nlp|ollama|gemini`
  - default `deterministic`

## Complete Surface Inventory
### Sysadmin
- overview dashboard
- search
- recent audit/history
- reminders
- faculties and hierarchy workspace
- students registry and drilldown
- faculty-members registry and drilldown
- requests workflow
- action queue
- proof control plane
- curriculum governance
- curriculum linkage review
- provisioning
- faculty calendar oversight
- scoped registry launches
- theme switching
- hidden and archived restore flows

### Teaching and Academic
- teaching portfolio
- faculty profile
- teacher proof panel
- course detail
- scheme setup
- question paper and CO mapping
- entry workspace
- attendance entry
- TT1 entry
- TT2 entry
- assignment entry
- SEE entry
- calendar and timetable
- mentor mentee list
- mentee detail
- queue history
- unlock review and request flow
- HoD overview
- HoD course hotspots
- HoD faculty operations
- HoD reassessment audit
- risk explorer
- student shell
- full student profile
- partial student profile

## Phase 0: Freeze The Pilot And Build The Handoff Backbone
1. Freeze the pilot to `Proof MNC 2023`, `120` students, sections `A/B`, semesters `1..6`, one faculty/HoD operating slice.
2. Record a deviation note that this pass is not yet the later CSE `M/C` expansion.
3. Create one assertion catalog with unique ids for every claim that must be proved.
4. Create the handoff artifacts, evidence manifest, execution ledger, and defect register before implementation starts.
5. Record exact deployed URLs, commit SHA, Playwright browser target, and deploy env contract in the ledger.
6. Gate Phase 0 on a complete surface inventory across sysadmin, teaching, mentor, HoD, student, proof, queue, request, and registry routes.

## Phase 1: Source Of Truth, Scope, And Count Parity
1. Add `section` as a real authoritative scope layer in backend types, API types, resolvers, labels, and UI.
2. Make proof-scoped values the default whenever an active proof run or proof semester exists.
3. Keep global institutional totals behind an explicit global mode only.
4. Reconcile all visible totals and lists against authoritative data:
   - total students
   - mentor gaps
   - faculty load
   - HoD totals
   - proof queue
   - high watch
   - medium watch
   - priority alerts
   - transcript counts
   - CGPA and SGPA
5. Remove mock and fallback displays where live data exists.
6. Where live data does not exist, render explicit unavailable states instead of fabricated values.
7. Gate Phase 1 on backend and client tests proving section precedence, proof-scoped totals, and proof-vs-global count provenance.

## Phase 2: Sysadmin Extraction Parity And Complete Control Plane
1. Build on the extracted-workspace parity already established for governance, stage-policy, curriculum, semester navigation, course-leader assignment, and provisioning.
2. Restore full parity for:
   - academic terms
   - semester navigation
   - semester-wise curriculum tables
   - course-leader assignment
   - provisioning
   - policy editing
   - stage-policy editing
   - proof-linked curriculum governance
3. Keep proof control plane as its own dedicated sysadmin panel, not buried inside batch overview.
4. That panel must include:
   - active run context
   - semester activation
   - section and class selection
   - checkpoint playback
   - import and crosswalk lifecycle
   - model diagnostics
   - lifecycle audit
   - operational events
   - queue and worker diagnostics
5. Restore complete semester and course visibility. “Semester 1 only” is treated as a regression.
6. Gate Phase 2 on acceptance tests proving extracted workspace parity with the legacy live shell.

## Phase 3: Sysadmin Data And Workflow Parity By Area
### Overview
- Show only real scoped values.
- Remove mixed institutional totals when proof context is active.
- Ensure overview support cards are actionable and drill down correctly.

### Hierarchy and governance
- Institution, academic faculty, department, branch, batch, and section must all show correct resolved policy and provenance.
- Every override family must be editable, visible, resettable, and reversible.

### Students
- Canonical pilot total must resolve to `120`.
- Active semester, section, transcript, mentor assignment, promotion state, and audit history must align.

### Faculty-members
- Appointments, role grants, HoD status, ownership, mentor load, teaching load, and calendar data must align with teaching and proof views.

### Requests and history
- Preserve notes, transitions, approvals, closure, hide/restore, and audit history.

### Proof dashboard
- Show queue state, worker state, checkpoint readiness, stale diagnostics, recent events, and lifecycle history without relying on unrelated hierarchy UI.

## Phase 4: Teaching Portfolio, Mentor, HoD, Student, And Proof Parity
1. Make all required metrics clickable:
   - total students
   - high watch
   - medium watch
   - priority alerts
   - proof queue
   - elective fits
   - HoD students covered
   - faculty in scope
   - overload flags
   - requests
   - mentor gaps
2. Every student mention in faculty, mentor, HoD, risk explorer, and queue surfaces must open the partial profile.
3. Aggregate student counts must open the exact filtered full list they summarize.
4. Teacher totals must stop showing mixed values like `240` when the scoped proof cohort is `120`.
5. Mentor and mentee views must use live assignment data only.
6. HoD overview must always show department and faculty coverage for the active proof context and never fall into a false “No active proof run” state.
7. Risk explorer and student shell must consume the same evidence and checkpoint context as teacher and HoD views.
8. Gate Phase 4 on cross-surface parity tests for the same student, same semester, same checkpoint, same scope.

## Phase 5: UX Consistency, Motion, And Shell Stability
1. Build one shared proof tab shell for:
   - sysadmin proof views
   - teacher proof panel
   - HoD analytics
   - risk explorer
   - student shell
2. The shell must own:
   - stable min-height
   - internal scrolling
   - tab transitions
   - focus behavior
   - empty/loading/error states
   - checkpoint banner placement
3. Add one floating proof launcher on every proof-aware surface.
4. Standardize:
   - dropdown sizing
   - panel chrome
   - paddings
   - card styling
   - colors
   - tab heights
   - segmented controls
5. Add smooth transitions for:
   - subpanel changes
   - proof drawer open and close
   - action queue dismiss, hide, and restore
   - modal transitions
   - light and dark theme changes
6. Replace any remaining out-of-place circular proof widgets on the deployed site with the metric-card language.
7. Add `Hide all` and `Restore all hidden` for the action queue.
8. Gate Phase 5 on visual regression and interaction tests proving stable panel sizing and no jarring layout jumps.

## Phase 6: Hierarchy, Overrides, Permissions, And Provisioning
1. Verify every hierarchy layer independently:
   - institution
   - academic faculty
   - department
   - branch
   - batch
   - section
2. Verify every policy family at every layer:
   - academic bands
   - CE/SEE
   - attendance and condonation
   - eligibility and pass rules
   - SGPA/CGPA/progression
   - stage policy
   - curriculum feature binding
   - provisioning defaults
3. Verify explicit rollback behavior:
   - add override
   - observe resolution everywhere
   - remove override
   - confirm reversion to next broader scope
4. Provision the pilot through sysadmin end to end:
   - terms
   - sections
   - course rows
   - faculty ownership
   - HoD assignment
   - course leaders
   - mentors
   - class distribution defaults
5. Gate Phase 6 on parity tests comparing resolved values across sysadmin, teaching, HoD, and proof surfaces.

## Phase 7: Semester `1..6` Activation And Realistic Proof Walk
1. Add semester activation so semesters `1..6` can each become the active operational semester.
2. Historical semesters stay transcript and history below the active semester.
3. Future semesters stay unavailable above the active semester.
4. Use fixed pseudo-random seeds for realistic but reproducible evidence generation.
5. Semester 1 acceptance:
   - `120` students
   - `60/60` sections
   - no fake transcript history
   - no priority alerts at `pre-tt1`
   - no actionable queue at semester start
   - all semester-1 courses visible and editable
6. Semester 2 acceptance:
   - SGPA to CGPA carry-forward
   - first backlog emergence
   - repeat-risk behavior
   - section override rendered correctly
7. Semester 3 acceptance:
   - prerequisite carryover
   - early intervention history
   - believable medium and high watch emergence
8. Semester 4 acceptance:
   - repeated-course latest-attempt logic
   - condonation
   - progression pressure
9. Semester 5 acceptance:
   - long-history consistency
   - backlog accumulation and clearance
   - progression readiness
10. Semester 6 acceptance:
   - offerings
   - ownership
   - question papers
   - CO mapping
   - attendance
   - TT1 and TT2
   - assignments
   - SEE
   - electives
   - queue generation
   - interventions
   - HoD analytics
11. For every semester, verify:
   - `pre-tt1`
   - `post-tt1`
   - `post-tt2`
   - `post-assignments`
   - `post-see`
12. Gate Phase 7 on a full semester-walk suite.

## Phase 8: Role-By-Role End-To-End Flow Verification
### Sysadmin
- hierarchy setup
- permissions
- HoD assignment
- ownership
- section overrides
- CE/SEE
- SGPA/CGPA rules
- curriculum
- provisioning
- mentor bulk assignment
- proof control plane
- semester activation

### Course leader
- question papers
- CO mapping
- evidence entry
- lock
- unlock request
- post-approval edit
- re-lock

### Mentor
- assigned mentees
- recurring tasks
- defer
- hide
- restore
- intervention tracking

### HoD
- department overview
- supervised faculty list
- reassessment audit
- unlock approval
- proof analytics

### Student and risk
- full profile
- partial profile
- risk explorer
- student shell
- timeline
- checkpoint alignment

### Session and restore
- login
- session restore
- role-context switch
- proof-playback restore
- invalid-checkpoint fallback
- logout

## Security Contract
- Preserve the existing cookie-auth contract:
  - session cookie
  - CSRF cookie/token contract
  - allowed-origin enforcement
  - secure-cookie posture for Pages plus Railway
  - production-like `CSRF_SECRET` startup gate
- Explicitly verify:
  - login
  - session restore
  - logout
  - role-context switch
  - bad-origin rejection
  - missing-CSRF rejection
  - secure-cookie flags
  - startup diagnostics for production-like deployment
- No feature is considered complete if it regresses deployed auth or session behavior.
- Deployed verification must include:
  - live session-contract verification
  - live session-security suite

## Role Boundary And Proof Access Matrix
- Define explicit allowed and denied cases for:
  - `SYSTEM_ADMIN`
  - `HOD`
  - `COURSE_LEADER`
  - `MENTOR`
- Matrix must include:
  - active proof run access
  - inactive proof run inspection
  - archived proof inspection
  - course-leader offering scope
  - mentor student scope
  - HoD department and branch scope
  - teacher proof drilldowns
  - student-shell session ownership
  - out-of-scope student or faculty attempts
  - invalid semester or checkpoint selection
- Require negative-path tests and evidence for denied cases, not only happy-path parity.

## Audit Vs Telemetry Taxonomy
### Audit events must cover
- policy override create, update, reset
- stage policy create, update, reset
- section override create, update, reset
- bulk mentor assignment
- HoD assignment
- ownership changes
- provisioning
- unlock approval and rejection
- queue bulk hide and restore
- curriculum-linkage approve and reject
- proof-semester activation

### Operational telemetry must cover
- proof lifecycle
- checkpoint restore and reset
- queue diagnostics
- worker diagnostics
- stale proof warnings
- count mismatch detection
- degraded linkage provider
- screenshot capture jobs
- assertion pass and fail
- deploy and live verification steps

### Rules
- Every event family must define:
  - event name
  - required payload keys
  - correlation ids
  - redaction rules
  - retention target
  - whether it is audit evidence, operator diagnostics, or both
- Secrets, cookies, CSRF tokens, prompts, provider keys, and raw credentials must never appear in audit or telemetry payloads.

## Operator Diagnostics And Readiness
- `/health` alone is not enough.
- Required readiness and operator surfaces:
  - backend startup diagnostics
  - frontend startup diagnostics
  - live session-contract verification
  - proof queue diagnostics
  - worker lease state
  - checkpoint readiness
  - recent retained operational events
  - telemetry sink configured or not configured state
  - proof dashboard diagnostics visible in sysadmin
- Deployed readiness must assert:
  - GitHub Pages reachable
  - Railway reachable
  - backend session contract valid for the frontend origin
  - build metadata matches target commit
  - proof operator surfaces render correctly on live deploy

## Queue/Worker SLO And Failure Matrix
- Define worker states:
  - queued
  - claimed
  - executing
  - completed
  - failed
  - stale lease
  - heartbeat lost
  - retry exhausted
- Define thresholds for:
  - stale lease age
  - heartbeat timeout
  - retry budget
  - acceptable queue age
  - acceptable checkpoint materialization latency
- Require screenshot and JSON evidence for:
  - healthy queue
  - queued work
  - running work
  - failed work
  - stale lease
  - recovered or retried work
- Proof dashboard must surface these states clearly in sysadmin.

## External Model / Linkage Provider Contract
- Core proof-risk, queue generation, student shell, risk explorer, and HoD analytics remain deterministic.
- External-provider use is restricted to curriculum linkage only.
- Authoritative provider precedence:
  - `deterministic`
  - `python-nlp`
  - `ollama`
  - `gemini`
- Default deployed posture:
  - `deterministic`
  - provider assist disabled unless explicitly enabled
- Rules:
  - provider output is advisory only
  - manual approval required before mutation
  - deterministic fallback always available
  - provider provenance returned in API payloads
  - timeout, failure, and degraded warnings visible in sysadmin
  - Python helper must receive a minimized env allowlist, not the full process env
  - prompts, raw model payloads, and secrets must not land in audit or telemetry logs

## Gemini Future Gate
- Gemini is out of current runtime scope.
- If ever added later, it must be:
  - backend-only
  - env-secret-only
  - opt-in
  - provider-allowlisted
  - rate-limited
  - kill-switchable
  - provenance-tagged
  - redacted from logs
  - human-reviewed before any curriculum or proof mutation
- No future agent may interpret this plan as permission to wire Gemini directly into proof-risk or student-data flows.

## Logging, Evidence, And Handoff Architecture
1. Reuse existing audit and operational telemetry infrastructure as the base.
2. Extend both systems with correlation identifiers:
   - `buildSha`
   - `requestId`
   - `sessionId`
   - `simulationRunId`
   - `simulationStageCheckpointId`
   - `semesterNumber`
   - `scopeType`
   - `scopeId`
   - `facultyId`
   - `studentId`
3. Keep generated evidence untracked in repo and uploaded as artifacts.
4. Execution ledger must be append-only and record:
   - phase
   - step
   - assertion ids
   - commands
   - env
   - artifacts
   - pass or fail
   - blocker
   - next action
5. Every screenshot and report must map to exact assertion ids in the evidence manifest.
6. The next agent session must be able to resume from the ledger without rediscovery.
7. Long-running verify/build/deploy commands must be launched detached with durable logs, and stage proof must run only against the freshly deployed live stack that matches the current repo state.
8. Repeat failures should be collapsed into shared execution rules so later stages inherit the fix instead of rediscovering it.

## Screenshot And Evidence Pack
- Minimum checkpoint pack:
  - `6 semesters x 5 stages x 5 core surfaces = 150` labeled screenshots
- Core surfaces:
  - sysadmin proof panel
  - teacher proof panel
  - HoD overview
  - risk explorer
  - student shell
- Additional parity and config pack must include:
  - sysadmin overview
  - hierarchy at every scope layer
  - semester list
  - curriculum tables
  - section override resolution
  - mentor bulk assignment
  - full student list
  - partial student profile
  - high-watch list
  - unlock requested
  - unlock approved
  - queue hide-all
  - queue restore-all
  - theme and panel-shell visual evidence
- Student-risk pack:
  - at least one low-risk student
  - at least one medium-risk student
  - at least one high-risk student
  - for each semester where those bands are valid
- Filenames:
  - `proof-semXX-stage-<stageKey>-<surface>-raw.png`
  - `proof-semXX-stage-<stageKey>-<surface>-labeled.png`
  - `config-<area>-<scope>.png`
  - `workflow-semXX-<flow>-<step>.png`
- Every manifest row must include:
  - `artifactId`
  - `semesterNumber`
  - `stageKey`
  - `simulationRunId`
  - `simulationStageCheckpointId`
  - `surface`
  - `actorRole`
  - `scopeType`
  - `scopeId`
  - `routeHash`
  - `studentId`
  - `courseId`
  - `assertionIds[]`
  - `rawPath`
  - `labeledPath`
  - `scriptName`
  - `appUrl`
  - `apiUrl`
  - `createdAt`

## Automated Tests And Release Gates
### Backend
- section precedence
- proof-scoped totals
- mentor bulk assignment
- proof-semester activation
- semester-1 quiet start
- provisioning defaults
- ownership and HoD coverage
- unlock governance
- proof access denial matrix
- linkage provider fallback behavior

### Frontend
- extracted workspace parity
- shared proof tab shell
- clickable metric drilldowns
- stable-height panels
- overflow behavior
- floating proof launcher
- theme transitions
- no-fallback live copy
- proof-vs-operational separation where needed

### Browser
- keep current suites:
  - proof risk
  - admin acceptance
  - request flow
  - teaching parity
  - accessibility regression
  - keyboard regression
  - session security
- add new Firefox Playwright semester-walk suite for semesters `1..6` and all five checkpoints

### Deployed release gate
- wait for GitHub Pages and Railway
- assert build metadata
- run health plus live session contract
- run current live browser bar
- run semester-walk suite
- upload `output/playwright/**`
- release is blocked if:
  - mock values remain on proof-scoped surfaces
  - counts mismatch
  - semesters are missing
  - drilldowns fail
  - unauthorized access leaks
  - HoD falsely shows no active proof run
  - panel jumpiness persists
  - evidence pack is incomplete

## Assumptions And Defaults
- Pilot remains the current repo-supported `Proof MNC 2023` cohort.
- Semesters `1..6` only are in scope.
- Proof-facing totals default to proof scope first.
- Policy precedence includes `section`.
- Faculty permissions and teaching ownership are separate from policy override resolution.
- Proof-risk remains deterministic in this pass.
- External provider assist is optional, admin-only, curriculum-linkage-only, and disabled by default on deployed verification.
