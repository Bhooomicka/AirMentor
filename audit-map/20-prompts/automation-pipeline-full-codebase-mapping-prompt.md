# AirMentor UI — Full Codebase Mapping Prompt
# For Automation Pipeline Handoff — 2026-04-19
# Zero drift. Intent first. Every file. Every route. Every type.

---

## MISSION STATEMENT

You are mapping the AirMentor UI monorepo — a university academic risk management system deployed for MSRUAS (M.S. Ramaiah University of Applied Sciences). The system lets a System Admin seed a realistic 6-semester simulation of student academic trajectories, faculty members supervise their students through a structured proof pipeline, and HODs get analytics on at-risk cohorts. Everything is built with intent: every file exists because a specific user-facing capability needed it. Your job is to produce a living map where every file's reason-for-existence is stated explicitly, every API endpoint is linked to the UI surface that calls it, and every divergence between the audit-map and the current code is flagged as a drift item requiring resolution.

**Repo root:** `/home/raed/projects/air-mentor-ui`

---

## REPO STRUCTURE

```
air-mentor-ui/                  ← monorepo root
  src/                          ← React frontend (Vite, TypeScript)
  air-mentor-api/               ← Fastify backend (TypeScript, Drizzle ORM, PostgreSQL)
    src/
      db/
        migrations/             ← 20 SQL migration files (0000–0019)
        seeds/                  ← 3 seed JSON files
      lib/                      ← ~40 pure service/library files
      modules/                  ← ~16 Fastify route-registration modules
    tests/                      ← ~35 vitest test files + helpers/
    scripts/                    ← 5 TypeScript/MJS scripts
  audit-map/                    ← 2461 files across 33 directories (governance, inventory, reports)
  scripts/                      ← ~50 bash/mjs scripts (live acceptance, playwright, tunnel, etc.)
  .github/                      ← GitHub Actions workflows
```

---

## MAPPING INSTRUCTIONS

For each file listed below, produce a record with:
1. **Path** — exact relative path from repo root
2. **Intent** — WHY this file exists (the user-facing capability it enables, not what the code does)
3. **Key exports / routes / tables** — the most important named things inside it
4. **Depends on** — which other files it imports from (within the repo)
5. **Called by** — which files import this one (within the repo)
6. **Drift flag** — if anything in the file contradicts the audit-map inventory or a previously documented intent, note it here

---

## SECTION 1: BACKEND ENTRYPOINT & CONFIGURATION

### `air-mentor-api/src/index.ts`
**Intent:** Production process entrypoint. Reads environment, creates email transport (SMTP if SMTP_HOST set, else noop), instantiates DB pool, runs migrations, builds Fastify app, starts listening. Also sets up SIGTERM/SIGINT graceful shutdown.
**Key exports:** none (side effects only)
**Depends on:** `config.ts`, `db/client.ts`, `db/migrate.ts`, `app.ts`, `lib/email-transport.ts`

### `air-mentor-api/src/app.ts`
**Intent:** Compose all Fastify plugins and route modules into a single testable app factory. Registers CORS, cookie, CSRF, session plugin, static file serving, and all route modules. Accepts `BuildAppOptions` including injected `emailTransport` and `clock` for test determinism.
**Key exports:** `buildApp(options: BuildAppOptions): Promise<FastifyInstance>`, `BuildAppOptions`, `RouteContext`
**Depends on:** all modules in `src/modules/`, `src/lib/csrf.ts`, `src/lib/telemetry.ts`

### `air-mentor-api/src/config.ts`
**Intent:** Single source of truth for all environment variable parsing. Returns typed `AppConfig` from raw `process.env`. All consumers import from here — never read `process.env` directly in route modules.
**Key exports:** `AppConfig`, `loadConfig(env)`
**Key fields:** `port`, `host`, `databaseUrl`, `sessionSecret`, `csrfSecret`, `corsAllowedOrigins[]`, `smtpHost|Port|Secure|User|Pass`, `emailFromAddress|Name`, `passwordSetupEmailRateLimitWindowMs|Max`, `loginRateLimitMaxAttempts`, `passwordSetupEmailRateLimit*`, `defaultThemeMode`, `passwordSetupPreviewEnabled`

### `air-mentor-api/src/startup-diagnostics.ts`
**Intent:** On startup, runs a suite of DB connectivity and schema sanity checks. Emits structured JSON to stdout. Surfaces catastrophic misconfigurations before the first real request arrives.
**Key exports:** `runStartupDiagnostics(db, config)`

---

## SECTION 2: DATABASE LAYER

### `air-mentor-api/src/db/client.ts`
**Intent:** Wraps `postgres` (node-postgres) and Drizzle ORM into typed helpers. Exports `createPool`, `createDb`, and the `AppDb` type used throughout route modules.
**Key exports:** `createPool`, `createDb`, `AppDb`

### `air-mentor-api/src/db/migrate.ts`
**Intent:** Applies SQL migration files in numerical order using Drizzle's migrator. Called at startup (index.ts) and in test helpers before each test suite.
**Key exports:** `runSqlMigrations(pool, migrationsDir)`

### `air-mentor-api/src/db/schema.ts`
**Intent:** Drizzle schema definition — the single source of truth for all table structures. Every column, constraint, and relation is defined here. Migration files are generated from diffs against this schema.
**Key tables (intent):**
- `users` — person identity + role + password hash
- `faculties` — organizational unit (dept/school)
- `departments`, `schools` — hierarchy
- `courses` — course catalogue
- `offerings` — section-specific instance of a course in a semester (course × section × faculty × semester)
- `students` — student identity + section assignment
- `enrollments` — student enrolled in an offering
- `proofRuns` — one ML inference run for a student×offering×checkpoint
- `proofCheckpoints` — staged academic checkpoints (TT1, TT2, SEE)
- `proofActiveRun` — currently in-progress proof run per offering
- `proofRunQueue` — async queue for batch proof runs
- `proofCases` — governance case per student (tracks escalation state)
- `proofCaseHistory` — append-only event log per case
- `riskModelArtifacts` — persisted trained ML model weights + calibration
- `operationalSemester` — which semester is currently "active" for proof
- `passwordSetupTokens` — time-limited tokens for invite/reset email flows
- `loginRateLimitWindows` — per-IP login attempt tracking
- `operationalTelemetryEvents` — append-only client event log

### `air-mentor-api/src/db/seed.ts`
**Intent:** Populates a fresh DB (in test or seeded-server mode) with realistic MSRUAS data: faculty members, courses, students across sections A and B, 6 semesters of historical trajectories, and a live semester-6 proof run. Uses `stableUnit`/`stableBetween` deterministic RNG so the same `runSeed` always produces identical data.
**Key exports:** `seedIntoDatabase(db, pool, baseNow)`

### `air-mentor-api/src/db/seeds/admin-foundation.seed.json`
**Intent:** Bootstraps the System Admin account and initial platform config on first deploy.

### `air-mentor-api/src/db/seeds/platform.seed.json`
**Intent:** Default platform-level settings (theme, feature flags).

### `air-mentor-api/src/db/seeds/msruas-mnc-curriculum.json`
**Intent:** MSRUAS MNC (Master of Network and Communications?) curriculum structure — course codes, titles, credit units, prerequisite chains. Source of truth for what courses exist.

### Migration files (0000–0019)
Every migration is append-only and exists because a feature needed a new table or column. Map each to its feature:
- `0000_admin_foundation.sql` → users, faculties, initial admin account
- `0001_academic_runtime.sql` → courses, offerings, students, enrollments
- `0002_admin_hierarchy.sql` → departments, schools, hierarchy
- `0002_cleanup_seeded_kavitha_scope.sql` → one-off data cleanup (kavitha.rao scope fix)
- `0003_admin_control_plane.sql` → admin management tables
- `0004_academic_assessment_and_history.sql` → assessment scores, attendance
- `0005_teaching_authority_phase2.sql` → faculty teaching assignments
- `0006_msruas_proof_runtime.sql` → proofRuns, proofCheckpoints
- `0007_msruas_proof_control_plane.sql` → proof case governance
- `0008_msruas_world_engine_stage2.sql` → simulation world engine tables
- `0009_student_agent_shell.sql` → student-facing view tables
- `0010_simulation_stage_playback.sql` → playback/snapshot tables for time-travel
- `0011_risk_model_artifacts.sql` → persisted ML model weights
- `0012_faculty_calendar_admin_workspaces.sql` → faculty calendar/timetable
- `0012_proof_queue_case_governance.sql` → proof queue case tables (parallel migration)
- `0012_proof_queue_governance_runtime.sql` → proof queue governance runtime (parallel migration)
- `0013_scope_governance_profiles_and_provisioning.sql` → provisioning profiles
- `0014_async_proof_run_queue.sql` → async proofRunQueue table
- `0015_curriculum_linkage_candidates.sql` → curriculum linkage ML candidates
- `0016_login_rate_limit_windows.sql` → login rate limiting table
- `0017_operational_telemetry_events.sql` → telemetry events table
- `0018_proof_active_operational_semester.sql` → operationalSemester table
- `0019_password_setup_tokens.sql` → passwordSetupTokens table

**DRIFT FLAG:** Three `0012_*.sql` files exist. The standard migration runner applies files alphabetically within the same prefix. Verify the runner handles this correctly and that no table is defined twice.

---

## SECTION 3: BACKEND LIBRARY MODULES (`air-mentor-api/src/lib/`)

### `proof-risk-model.ts`
**Intent:** Core ML system. Trains a logistic regression model on student observable features to produce a calibrated at-risk probability. Also provides tree-based split decision for interpretability. All inference is deterministic given the same weights.
**Key exports:**
- `OBSERVABLE_FEATURE_KEYS` — 27 scaled feature names (the exact list):
  `attendancePctScaled`, `attendanceTrendScaled`, `attendanceHistoryRiskScaled`, `currentCgpaScaled`, `backlogPressureScaled`, `tt1RiskScaled`, `tt2RiskScaled`, `seeRiskScaled`, `quizRiskScaled`, `assignmentRiskScaled`, `weakCoPressureScaled`, `weakQuestionPressureScaled`, `courseworkTtMismatchScaled`, `ttMomentumRiskScaled`, `interventionResidualRiskScaled`, `prerequisitePressureScaled`, `prerequisiteAverageRiskScaled`, `prerequisiteFailurePressureScaled`, `prerequisiteChainDepthScaled`, `prerequisiteWeakCourseRateScaled`, `prerequisiteCarryoverLoadScaled`, `prerequisiteRecencyWeightedFailureScaled`, `downstreamDependencyLoadScaled`, `weakPrerequisiteChainCountScaled`, `repeatedWeakPrerequisiteFamilyCountScaled`, `semesterProgressScaled`, `sectionPressureScaled`
- `PRODUCTION_RISK_THRESHOLDS` — `{ medium: 0.4, high: 0.85 }`
- `RISK_CALIBRATION_VERSION` — `'post-hoc-calibration-v1'`
- `PROOF_SCENARIO_FAMILIES` — 8 scenario families for seeding diverse risk profiles
- `trainProofRiskModel(trainingData)` — trains logistic regression + calibration
- `scoreWithLogistic(head, vector)` — inference on trained model
- Learning rates: **0.08** (calibration sigmoid fit) / **0.22** (main logistic regression)
- Calibration methods: `identity` | `sigmoid` | `isotonic`
- Risk threshold clamp: `clamp(0.75, 0.35, 0.8)` → always yields `0.75` as trained threshold

### `proof-control-plane-seeded-semester-service.ts`
**Intent:** Generates synthetic semester-level data (per-section teaching environment parameters) used during simulation seeding. Produces deterministic `teacherStrictnessIndex`, `assessmentDifficultyIndex`, and `interventionCapacity` per section per semester.
**Key per-section environment params:**
- `teacherStrictnessIndex`: `stableBetween(seed, 0.32, 0.78)` — how strictly attendance/deadlines are enforced
- `assessmentDifficultyIndex`: `stableBetween(seed, 0.38, 0.84)` — how hard the assessments are
- `interventionCapacity`: `stableBetween(seed, 0.34, 0.82)` — faculty bandwidth for interventions
- Section B gets faculty index offset by 1: `(courseIndex + 1) % courseLeaderFaculty.length`

### `proof-control-plane-seeded-scaffolding-service.ts`
**Intent:** Generates per-student academic trajectories across all 6 semesters. Each student has a latent profile that determines their behavioral response to the environment.
**Key student profile params:**
- `profile.behavior.attendancePropensity` — intrinsic attendance tendency
- `profile.behavior.practiceCompliance` — probability of completing assigned practice
- `profile.intervention.interventionReceptivity` — probability of accepting a mentor intervention
- `profile.intervention.expectedRecoveryThreshold` — how much improvement an intervention creates
- `profile.intervention.temporaryUpliftCredit` — temporary score boost from intervention
- `profile.readiness` — academic readiness (CGPA-correlated)
- `profile.dynamics` — how student performance changes over time
- `latentBase.academicPotential` — underlying ability (not observable by teacher)

### `proof-control-plane-seeded-bootstrap-service.ts`
**Intent:** Orchestrates the full simulation bootstrap: creates faculty accounts, students, offerings, runs all 6 semester trajectories, and inserts everything into the DB in a single transaction.

### `proof-control-plane-seeded-run-service.ts`
**Intent:** Executes one semester of the simulation — generates assessment scores, attendance, interventions, and proof run data for a given set of students and offerings.

### `proof-control-plane-runtime-service.ts`
**Intent:** Runtime proof pipeline operations — runs the ML model on current student data, updates proofRun records, triggers queue items. Called when faculty/HOD request a proof computation.

### `proof-control-plane-playback-service.ts`
**Intent:** Time-travel / stage-advance. Replays simulation data for the next checkpoint stage, advancing the "current date" and populating new student data as if that checkpoint period had passed.

### `proof-control-plane-playback-reset-service.ts`
**Intent:** Resets the live semester-6 proof run back to the beginning of the simulation, clearing all runtime proof data so a fresh demo can be run from checkpoint 0.

### `proof-control-plane-playback-governance-service.ts`
**Intent:** Enforces rules about which stages can be played back and in what order. Prevents out-of-sequence advances.

### `proof-control-plane-activation-service.ts`
**Intent:** Activates a proof run for a given offering — transitions it from "draft" to "active" state, gating further faculty interaction.

### `proof-control-plane-batch-service.ts`
**Intent:** Coordinates batch proof runs across multiple offerings simultaneously. Used for HOD-level "run all" operations.

### `proof-control-plane-checkpoint-service.ts`
**Intent:** Manages checkpoint-level operations — recording scores, locking a checkpoint once complete, computing risk bands at checkpoint boundaries.

### `proof-control-plane-dashboard-service.ts`
**Intent:** Computes the aggregated dashboard data shown to faculty and HOD — section risk summary, top-at-risk students, checkpoint completion rates.

### `proof-control-plane-hod-service.ts`
**Intent:** HOD-specific analytics: section-wide risk distributions, student watch list, inter-section comparison, trend analysis across checkpoints.

### `proof-control-plane-elective-service.ts`
**Intent:** Handles elective course offerings — different proof rules apply to electives vs core courses.

### `proof-control-plane-live-run-service.ts`
**Intent:** Manages the "live" (non-seeded) proof run — used when real faculty enter real scores, not during simulation.

### `proof-control-plane-section-risk-service.ts`
**Intent:** Computes section-aggregate risk metrics: mean risk probability, proportion of high/medium/low students, risk band transitions across checkpoints.

### `proof-control-plane-policy-service.ts`
**Intent:** Encodes proof governance policy: which roles can do what, stage advance rules, lock conditions.

### `proof-control-plane-rebuild-context-service.ts`
**Intent:** Rebuilds the proof run context from DB state — used after a reset or when context is stale.

### `proof-control-plane-stage-summary-service.ts`
**Intent:** Generates the stage-level summary shown on the faculty workbench — how many students passed/failed each stage, checkpoint completion status.

### `proof-control-plane-tail-service.ts`
**Intent:** Tail-end proof operations — final stage wrap-up, writing summary records, closing out the proof run.

### `proof-control-plane-access.ts`
**Intent:** Access control layer for proof operations — checks session role and faculty assignment before allowing any proof mutation.

### `proof-active-run.ts`
**Intent:** Helpers for querying and updating `proofActiveRun` — the single "currently in progress" proof run per offering.

### `proof-observed-state.ts`
**Intent:** Builds the observable feature vector from raw student assessment data. Feeds into the ML model. This is where raw scores become the 27 scaled features.

### `proof-provenance.ts`
**Intent:** Tracks provenance metadata for proof runs — which model version was used, which data version, when it was run.

### `proof-queue-governance.ts`
**Intent:** Governance rules for the async proof run queue — max concurrency, retry policy, stale job detection.

### `proof-run-queue.ts`
**Intent:** Async queue implementation for proof runs — enqueues jobs, polls for available workers, marks jobs complete/failed.

### `stage-policy.ts`
**Intent:** Stage progression policy — what conditions must be met before a faculty member can advance to the next checkpoint. Gate requirements (see Simulation Flow section below).

### `monitoring-engine.ts`
**Intent:** Builds the faculty mentoring workbench data — which students need attention, what actions are available, intervention history.

### `inference-engine.ts`
**Intent:** Higher-level inference orchestration — calls `proof-risk-model.ts` scoreWithLogistic, handles missing data, applies business rules on top of raw ML score.

### `msruas-proof-control-plane.ts`
**Intent:** MSRUAS-specific proof control plane orchestration — coordinates all the smaller services into the full proof lifecycle.

### `msruas-proof-sandbox.ts`
**Intent:** Sandbox environment for testing proof runs without affecting live data. Used in admin testing routes.

### `msruas-rules.ts`
**Intent:** MSRUAS-specific business rules — attendance thresholds (75% required), backlog limits, CGPA cutoffs that trigger automatic escalation.

### `msruas-curriculum-compiler.ts`
**Intent:** Compiles the raw curriculum JSON into an internal graph structure with prerequisite chains, credit units, and co-requisite sets.

### `graph-summary.ts`
**Intent:** Summarizes the curriculum prerequisite graph — chain depth, downstream dependency count, weak prerequisite family detection.

### `curriculum-linkage.ts` / `curriculum-linkage-python.ts`
**Intent:** Links observed weak performance in a course to downstream dependency risk. Python variant calls the NLP script for semantic similarity.

### `academic-provisioning.ts`
**Intent:** Creates faculty, student, and offering records from provisioning requests. Called by admin routes.

### `email-transport.ts`
**Intent:** Abstraction over email delivery. Noop mode (dev, no SMTP configured) vs SMTP mode (prod/tunnel, uses nodemailer). Injectable in tests via `createTestApp({ emailTransport })`. Sends `invite` and `reset` password setup emails.
**Key exports:** `EmailTransport`, `SendPasswordSetupEmailOptions`, `createNoopEmailTransport()`, `createSmtpEmailTransport(config)`

### `email-rate-limiter.ts`
**Intent:** In-memory per-recipient sliding window rate limiter for email sends. Prevents spamming invites to the same address. Window and max are configurable per limiter instance.
**Key exports:** `EmailRateLimiter`, `EmailRateLimitResult`

### `password-setup.ts`
**Intent:** Creates, validates, and consumes password setup tokens. Tokens are time-limited (24h default), single-use, stored in `passwordSetupTokens` table.

### `passwords.ts`
**Intent:** Argon2id hashing and verification. Never stores plaintext passwords.

### `csrf.ts`
**Intent:** CSRF double-submit cookie protection. Generates and validates CSRF tokens for all state-mutating requests from the browser.

### `ids.ts`
**Intent:** Generates all internal IDs using `nanoid`. Ensures consistent ID format across all tables.

### `http-errors.ts`
**Intent:** Typed HTTP error constructors — 400, 401, 403, 404, 409, 422, 429, 500. All route modules throw these; the Fastify error handler maps them to JSON responses.

### `json.ts`
**Intent:** Safe JSON parse helpers — returns `null` instead of throwing on malformed input.

### `time.ts`
**Intent:** Time utilities — injectable `clock` function, ISO string helpers, duration arithmetic. The `clock` param in `BuildAppOptions` allows tests to freeze time.

### `telemetry.ts`
**Intent:** Server-side telemetry helpers — writes operational events to `operationalTelemetryEvents` table.

### `operational-event-store.ts`
**Intent:** Append-only event store for audit trail. Every proof operation writes an event here.

### `proof-control-plane-seeded-semester-service.ts`
*(covered above)*

---

## SECTION 4: BACKEND ROUTE MODULES (`air-mentor-api/src/modules/`)

Each module registers Fastify routes. Map each route with: method, path pattern, auth requirement, what it does, and which frontend component calls it.

### `session.ts`
**Routes:**
- `POST /api/session/login` — password auth → session cookie
- `POST /api/session/logout` — destroys session
- `GET /api/session` — returns current session user (role, name, theme, etc.)
- `POST /api/session/password-setup/request` — self-service password reset request → sends email via transport
- `POST /api/session/password-setup/complete` — consumes token, sets new password
- `GET /api/session/password-setup/preview/:token` — dev-only token preview link
**Rate limiting:** `selfServicePasswordSetupRateLimiter` (3 per 10min per email)

### `people.ts`
**Routes:**
- `GET /api/admin/faculty` → list all faculty (system admin)
- `POST /api/admin/faculty` → create faculty member
- `PUT /api/admin/faculty/:facultyId` → update faculty
- `POST /api/admin/faculty/:facultyId/password-setup` → admin-initiated invite/reset email
**Rate limiting:** `adminPasswordSetupRateLimiter` (5 per 10min per faculty email)
**Returns:** `emailDelivered`, `rateLimited`, `expiresAt`, `issuedToEmail`

### `academic.ts`
**Routes:** Faculty academic workspace — session bootstrap, proof surface data
- `GET /api/academic/session` → faculty session with assigned offerings
- `GET /api/academic/offerings/:offeringId/students` → student list for offering

### `academic-proof-routes.ts`
**Routes:** Faculty proof pipeline operations
- `GET /api/academic/proof/:offeringId` → current proof state
- `POST /api/academic/proof/:offeringId/activate` → activate proof run
- `POST /api/academic/proof/:offeringId/checkpoint/:checkpointId/lock` → lock checkpoint
- `POST /api/academic/proof/:offeringId/advance` → advance to next stage
- `GET /api/academic/proof/:offeringId/students/:studentId` → student detail card

### `academic-bootstrap-routes.ts`
**Routes:** Bootstrap data for faculty session
- `GET /api/academic/bootstrap` → full session bootstrap (offerings, proof states, semester)

### `academic-runtime-routes.ts`
**Routes:** Runtime academic data (attendance, scores)
- `PUT /api/academic/offerings/:offeringId/students/:studentId/attendance` → update attendance
- `PUT /api/academic/offerings/:offeringId/students/:studentId/scores` → update assessment scores

### `academic-admin-offerings-routes.ts`
**Routes:** Admin management of offerings
- `GET /api/admin/offerings` → list all offerings
- `POST /api/admin/offerings` → create offering

### `academic-access.ts`
**Intent:** Auth middleware for academic routes — verifies faculty session and offering assignment.

### `academic-authoritative-first.ts`
**Intent:** Ensures academic data reads always hit the primary DB replica, not a read replica. Prevents stale reads after writes.

### `admin-structure.ts`
**Routes:** Institution structure management
- `GET /api/admin/structure` → departments, schools, faculties
- `POST /api/admin/structure/department` → create dept
- `POST /api/admin/structure/school` → create school

### `admin-control-plane.ts`
**Routes:** Simulation control plane (system admin only)
- `POST /api/admin/proof/seed` → seed full simulation into DB
- `POST /api/admin/proof/reset` → reset live semester back to start
- `POST /api/admin/proof/advance` → advance simulation to next date/stage
- `GET /api/admin/proof/status` → current simulation state

### `admin-proof-sandbox.ts`
**Routes:** Sandbox proof run testing
- `POST /api/admin/sandbox/proof-run` → run proof in sandbox, returns result without persisting

### `admin-requests.ts`
**Routes:** Request/unlock workflow
- `GET /api/admin/requests` → list pending unlock requests
- `POST /api/admin/requests/:requestId/approve` → HOD approves unlock
- `POST /api/admin/requests/:requestId/reject` → HOD rejects unlock

### `courses.ts`
**Routes:**
- `GET /api/courses` → course catalogue
- `GET /api/courses/:courseId` → course detail

### `institution.ts`
**Routes:**
- `GET /api/institution` → institution profile

### `students.ts`
**Routes:**
- `GET /api/students/:studentId` → student profile (HOD/admin access)
- `GET /api/students` → student list

### `support.ts`
**Routes:**
- `GET /api/health` → health check (used by start-tunnel-stack.sh readiness probe)
- `GET /api/version` → build version

### `client-telemetry.ts`
**Routes:**
- `POST /api/telemetry` → client sends interaction events; appended to `operationalTelemetryEvents`

---

## SECTION 5: FRONTEND (`src/`)

### `main.tsx`
**Intent:** React entry point. Mounts either the faculty/student app or the system-admin app based on URL routing. Configures React Query client.

### `App.tsx`
**Intent:** Root router. Splits into public portal (login, password setup) vs authenticated shells (academic workspace, system admin).

### `api/client.ts`
**Intent:** Typed fetch wrapper. All API calls go through here. Handles CSRF token injection, session cookie, and error response parsing.

### `api/types.ts`
**Intent:** TypeScript types for all API response shapes. These must stay in sync with backend responses. DRIFT FLAG: any mismatch between these types and actual API responses will cause silent data loss or runtime errors.
**Key types:**
- `ApiSessionResponse` — current user session
- `ApiAcademicBootstrapResponse` — full faculty session bootstrap
- `ApiStudentAgentCard` — student detail card (faculty view)
- `ApiStudentRiskExplorer` — risk explorer student data
- `ApiAcademicHodProofStudentWatch` — HOD student watch list entry
- `ApiFacultyProofOperations` — faculty proof operations surface data

### `student-checkpoint-parity.ts`
**Intent:** Cross-surface parity contract. All 5 proof surfaces show the same student checkpoint data but receive it in 4 different API shapes. This file defines the canonical `StudentCheckpointCoreMetrics` type and 4 selector functions that normalize each shape to the canonical form. Prevents UI surfaces from diverging on which field name to display.
**Key exports:**
- `StudentCheckpointCoreMetrics` — 11-field canonical type
- `coreMetricsFromStudentCard(card)` → canonical
- `coreMetricsFromRiskExplorer(explorer)` → canonical
- `coreMetricsFromHodStudentWatch(student)` → canonical
- `coreMetricsFromFacultyQueueItem(item)` → canonical

### `academic-session-shell.tsx`
**Intent:** Faculty session wrapper — fetches bootstrap, handles loading/error states, provides session context to all child routes.

### `academic-faculty-profile-page.tsx`
**Intent:** Faculty read-only profile page — shows assigned offerings, proof status per offering.

### `academic-proof-summary-strip.tsx`
**Intent:** Compact proof status strip shown on the faculty workbench — current checkpoint, risk band distribution, locked/unlocked state.

### `academic-workspace-*.tsx` (5 files)
**Intent:** Faculty academic workspace shell, sidebar, topbar, route surface, and content shell. Compose the faculty-facing layout.

### `pages/hod-pages.tsx`
**Intent:** HOD (Head of Department) analytics pages — section risk overview, student watch list, inter-section comparison, action-needed filter.

### `pages/risk-explorer.tsx`
**Intent:** Detailed risk explorer — lets HOD/faculty drill into individual student risk factors, prerequisite pressure, intervention history.

### `pages/student-shell.tsx`
**Intent:** Student-facing view — shows their own proof timeline, chat with mentor (if enabled), and risk indicators.

### `pages/course-pages.tsx`
**Intent:** Course detail pages — risk tab, stage locks, assessment entry hubs.

### `pages/calendar-pages.tsx`
**Intent:** Faculty calendar — timetable view, planner interactions.

### `pages/workflow-pages.tsx`
**Intent:** Request/unlock workflow pages — faculty submits unlock request, HOD reviews.

### `proof-surface-shell.tsx`
**Intent:** Wrapper for all 5 proof surfaces. Handles surface-level routing, proof state loading, and gating (locked stages show read-only view).

### `proof-pilot.ts`
**Intent:** Client-side proof pipeline orchestration — determines current stage, available actions, and calls the appropriate API endpoints.

### `proof-provenance.ts`
**Intent:** Client-side provenance display — shows which model version produced the current risk score.

### `proof-playback.ts`
**Intent:** Client-side time-travel controls — calls `/api/admin/proof/advance` to move to next checkpoint date.

### `system-admin-app.tsx`
**Intent:** System admin root — different app shell from faculty. Shows control plane UI.

### `system-admin-live-app.tsx`
**Intent:** System admin live mode — when connected to Railway/tunnel, shows live data controls.

### `system-admin-proof-dashboard-workspace.tsx`
**Intent:** System admin proof dashboard — simulation status, seed/reset/advance controls, per-section risk charts.

### `system-admin-faculties-workspace.tsx`
**Intent:** Faculty management UI — list, create, edit faculty; trigger password setup emails.

### `system-admin-hierarchy-workspace-shell.tsx`
**Intent:** Institution hierarchy management — departments, schools, faculties.

### `system-admin-faculty-calendar-workspace.tsx` / `system-admin-timetable-editor.tsx`
**Intent:** Faculty calendar and timetable assignment.

### `system-admin-history-workspace.tsx`
**Intent:** Audit history and archive — browse past proof runs, restore deleted items.

### `system-admin-request-workspace.tsx`
**Intent:** HOD unlock request queue — approve/reject pending requests.

### `system-admin-action-queue.ts` / `system-admin-ui.tsx`
**Intent:** Action queue helpers and UI primitives for system admin.

### `system-admin-live-data.ts`
**Intent:** Live data fetching for system admin — Railway DB health, simulation state.

### `system-admin-overview-helpers.ts` / `system-admin-provisioning-helpers.ts` / `system-admin-scoped-registry-launches.tsx` / `system-admin-session-shell.tsx`
**Intent:** Admin overview, provisioning, scoped registry, and session management helpers.

### `admin-request-selection.ts` / `admin-section-scope.ts`
**Intent:** Admin request selection and section scope filtering helpers.

### `repositories.ts`
**Intent:** Client-side data repositories — React Query hooks wrapping `api/client.ts` calls. All components fetch data through here, never directly.

### `selectors.ts`
**Intent:** Pure selector functions over API response data — used in components and in `student-checkpoint-parity.ts`.

### `domain.ts`
**Intent:** Domain type definitions shared across frontend — role enums, checkpoint stage definitions, proof state machine types.

### `data.ts` / `data.old.ts`
**Intent:** `data.ts` — current static reference data (section codes, semester labels). `data.old.ts` — archived old data structure, kept for reference during migration. DRIFT FLAG: `data.old.ts` should be deleted once confirmed no code references it.

### `startup-diagnostics.ts` (frontend)
**Intent:** Client-side startup checks — verifies API URL is set, backend is reachable, session is valid.

### `portal-entry.tsx` / `portal-routing.ts`
**Intent:** Public portal entry point and routing — login page, password setup flow.

### `api-connection.ts`
**Intent:** Manages API base URL (from `VITE_AIRMENTOR_API_BASE_URL` env var) and connection state indicator.

### `backend-health-indicator.tsx`
**Intent:** Small UI component showing backend connectivity status.

### `error-boundary.tsx`
**Intent:** React error boundary — catches render errors, shows fallback UI.

### `ui-primitives.tsx`
**Intent:** Design system primitives — buttons, cards, badges, form inputs. All styled with Frosted Focus theme.

### `theme.ts`
**Intent:** Theme tokens for Frosted Focus light/dark modes. Injected as CSS variables.

### `telemetry.ts` (frontend)
**Intent:** Client-side telemetry — sends interaction events to `/api/telemetry`.

### `batch-setup-readiness.ts`
**Intent:** Checks readiness of batch password setup operations — validates all faculty have valid email addresses before triggering bulk invite.

### `calendar-utils.ts`
**Intent:** Calendar date utilities — semester week calculation, checkpoint date mapping.

### `session-response-helpers.ts`
**Intent:** Helpers for parsing and normalizing session API responses.

### `page-utils.ts`
**Intent:** Page-level utility functions — scroll restoration, page title management.

---

## SECTION 6: FRONTEND TESTS (`src/` — none currently)

**DRIFT FLAG:** There are zero frontend unit/component tests. All testing is via backend vitest and live Playwright scripts. This is an intentional choice (cost/benefit) but should be documented as a known gap.

---

## SECTION 7: BACKEND TESTS (`air-mentor-api/tests/`)

Every test file maps to the feature it guards. Map each to: what it tests, what seed data it uses, what the critical invariants are.

### `helpers/test-app.ts`
**Intent:** Test helper — creates an in-memory Fastify app with embedded PostgreSQL, runs migrations, seeds data, returns app and close function. Accepts `emailTransport` injection.

### `admin-foundation.test.ts` — user creation, role assignment, login/logout
### `admin-hierarchy.test.ts` — dept/school/faculty hierarchy CRUD
### `admin-batch-setup-readiness.test.ts` — batch invite readiness checks
### `admin-control-plane.test.ts` — simulation seed/reset/advance
### `admin-curriculum-feature-config.test.ts` — curriculum feature flags
### `admin-proof-observability.test.ts` — proof run observability data
### `academic-access.test.ts` — faculty access control enforcement
### `academic-bootstrap-routes.test.ts` — faculty session bootstrap response shape
### `academic-admin-offerings.test.ts` — offering CRUD
### `academic-parity.test.ts` — parity between faculty and HOD views of same student
### `academic-proof-routes.test.ts` — faculty proof pipeline operations
### `academic-runtime-narrow-routes.test.ts` — narrow runtime route edge cases
### `email-transport.test.ts` — email rate limiter, noop transport, SMTP mock injection
### `evaluate-proof-risk-model.test.ts` — ML model training/inference regression
### `hod-proof-analytics.test.ts` — HOD analytics endpoints
### `http-smoke.test.ts` — basic 200/401 smoke checks on all routes
### `msruas-curriculum-compiler.test.ts` — curriculum graph compilation
### `msruas-proof-engines.test.ts` — proof engine orchestration
### `msruas-proof-sandbox.test.ts` — sandbox proof run
### `openapi.test.ts` — OpenAPI schema generation
### `policy-phenotypes.test.ts` — proof governance policy variants
### `proof-control-plane-access.test.ts` — proof access control
### `proof-control-plane-activation-service.test.ts` — proof activation
### `proof-control-plane-checkpoint-service.test.ts` — checkpoint locking
### `proof-control-plane-dashboard-service.test.ts` — dashboard aggregation
### `proof-queue-governance.test.ts` — queue governance rules
### `proof-run-queue.test.ts` — async queue operations
### `risk-explorer.test.ts` — risk explorer endpoint
### `session.test.ts` — login, logout, password setup flows
### `startup-diagnostics.test.ts` — DB diagnostic checks
### `config.test.ts` — config env var parsing
### `db-client.test.ts` — DB client helpers
### `client-telemetry.test.ts` — telemetry event recording

### `tests/student-checkpoint-parity.test.ts` (frontend, not backend)
**Intent:** 6 tests (P-PAR-01 through P-PAR-06) verifying that all 4 selector functions in `student-checkpoint-parity.ts` produce identical canonical output from different API shapes.

---

## SECTION 8: SCRIPTS

### `air-mentor-api/scripts/start-seeded-server.ts`
**Intent:** Starts a local backend with embedded PostgreSQL and fully seeded simulation data. Used for live browser testing without Railway. Writes a JSON ready-payload to stdout when listening.

### `air-mentor-api/scripts/evaluate-proof-risk-model.ts`
**Intent:** Standalone ML model evaluation script — trains model on seeded data, computes calibration error, AUC, precision/recall. Writes to `output/proof-risk-model/`.

### `air-mentor-api/scripts/generate-academic-parity-seed.ts`
**Intent:** Generates parity seed data for the academic parity test — ensures both sections get same course list.

### `air-mentor-api/scripts/run-vitest-suite.mjs`
**Intent:** Orchestrates running all vitest tests with correct environment and timeout settings.

### `air-mentor-api/scripts/curriculum_linkage_nlp.py`
**Intent:** Python NLP script for semantic curriculum linkage — uses sentence transformers to find which downstream courses are most affected by weakness in an upstream course.

### `scripts/start-tunnel-stack.sh`
**Intent:** Starts mailpit (local email) + AirMentor backend + ngrok tunnel in a single process group. Trap cleanup on Ctrl+C. Validates ngrok auth and domain before starting.
**Required env:** `air-mentor-api/.env.tunnel` with `NGROK_DOMAIN`, `DATABASE_URL`, SMTP settings, `SESSION_COOKIE_SECURE=true`, `SESSION_COOKIE_SAME_SITE=none`, `CORS_ALLOWED_ORIGINS=https://raed2180416.github.io`

### Playwright/live acceptance scripts (`scripts/system-admin-live-*.mjs`, `scripts/playwright-*.sh`)
**Intent:** End-to-end live acceptance tests against running backend. Cover: auth flows, proof pipeline, risk explorer, HOD analytics, accessibility, keyboard regression.

### `scripts/proof-risk-semester-walk.mjs`
**Intent:** Walks through all 6 semesters of simulation data, prints risk band transitions per student, used for manual verification of ML model behavior.

---

## SECTION 9: AUDIT MAP (`audit-map/`)

The audit-map is a parallel documentation layer maintained by AI agents. It has 33 directories and ~2461 files. The key directories:

- `00-governance/` — operating policies (caveman mode, stop conditions, model routing, account switching)
- `01-inventory/` — file-by-file inventory lists (these must be kept in sync with actual code)
- `02-architecture/` — system architecture diagrams and decisions
- `03-role-maps/` — which roles can do what
- `04-feature-atoms/` — per-feature detailed breakdowns
- `08-ml-audit/` — ML model documentation
- `09-test-audit/` — test coverage analysis
- `14-reconciliation/` — drift reconciliation reports
- `20-prompts/` — this file and other pipeline prompts
- `32-reports/` — handoff reports between AI sessions

**DRIFT DETECTION RULE:** After mapping every source file above, cross-reference with `audit-map/01-inventory/*.md`. Any file that appears in the inventory but not in the source, or vice versa, is a **drift item**. List all drift items at the end of your output.

---

## SECTION 10: GITHUB ACTIONS (`.github/workflows/`)

Map each workflow to: what triggers it, what it does, what it deploys.
- `deploy-pages.yml` — triggered by push to main or manual dispatch; builds frontend with `VITE_AIRMENTOR_API_BASE_URL` from GitHub variable; deploys to GitHub Pages at `https://raed2180416.github.io`
- Any other workflows: document similarly.

---

## SECTION 11: CONFIGURATION FILES

### Root `package.json`
**Intent:** Monorepo root — workspace definitions, shared dev dependencies (TypeScript, Vite, Playwright).

### `air-mentor-api/package.json`
**Intent:** Backend dependencies. Key runtime deps: `fastify`, `@fastify/cookie`, `@fastify/session`, `drizzle-orm`, `postgres`, `nodemailer`, `nanoid`, `argon2`. Key dev deps: `vitest`, `embedded-postgres`, `typescript`.

### `air-mentor-api/railway.json`
**Intent:** Railway deployment config — build command, start command, health check path.

### `air-mentor-api/nixpacks.toml`
**Intent:** Nixpacks build config for Railway — Node version, build steps.

### `air-mentor-api/.env.example`
**Intent:** Documents all required environment variables for backend deployment. Safe to commit.

### `air-mentor-api/.env.tunnel`
**Intent:** Local tunnel mode config (gitignored). Railway DB + ngrok + mailpit. NOT for production.

### `air-mentor-api/drizzle.config.ts`
**Intent:** Drizzle Kit config — points to schema.ts, migration output directory.

---

## SECTION 12: DRIFT DETECTION OUTPUT FORMAT

After completing the full map, output a **Drift Report** in this format:

```
## DRIFT REPORT — {date}

### Files in source but NOT in audit-map inventory
- path/to/file.ts — added in which session, needs inventory entry

### Files in audit-map inventory but NOT in source
- path/to/file.ts — was this deleted? Was it renamed? Or is the inventory wrong?

### Type mismatches between api/types.ts and actual API responses
- ApiXxx.fieldName — backend returns Y, type declares Z

### Route mismatches
- METHOD /api/path — exists in module but not in route-index.md
- METHOD /api/path — in route-index.md but handler was removed

### Schema mismatches
- table.column — schema.ts declares X, latest migration has Y

### Open items requiring human decision
- item — why it can't be auto-resolved
```

---

## EXECUTION ORDER FOR AUTOMATION PIPELINE

1. Parse this prompt to extract all file paths listed in Sections 1–11
2. For each file: read it, extract key exports/routes/types, record actual state
3. Load all audit-map inventory files from `audit-map/01-inventory/`
4. Diff source reality vs inventory — produce Drift Report (Section 12)
5. For any new files not yet in inventory, add them
6. For any stale inventory entries, flag for deletion or update
7. Write updated inventory files back to `audit-map/01-inventory/`
8. Write Drift Report to `audit-map/32-reports/drift-report-{date}.md`
9. Update `audit-map/14-reconciliation/` with reconciliation notes

**DO NOT** modify any source code files. This pipeline is read-only on source, write-only on audit-map.

---

## INTENT PRESERVATION RULE

Every file in this codebase exists because a user-facing capability needed it. When mapping, always ask: "If this file were deleted, which user action would break?" State the answer. That is the file's intent. No file should be mapped as "utility" or "helpers" without naming the specific feature those utilities serve.

The two features that are the north star of this entire codebase:
1. **A faculty member can open their laptop, log in, enter student scores, and see an ML-computed risk band for each student — without any manual model training step.**
2. **A System Admin can seed a 6-semester simulation, click "advance date", and watch the system generate realistic student trajectories that demonstrate the risk model catching at-risk students before they fail.**

Every file serves one or both of these features. Map accordingly.
