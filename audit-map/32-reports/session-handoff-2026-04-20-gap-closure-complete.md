# AirMentor — Session Handoff
# Gap Closure Complete + Deployment + Audit Reconciliation
**Date:** 2026-04-20
**Branch:** `promote-proof-dashboard-origin`
**Repo:** `https://github.com/Raed2180416/AirMentor.git`
**Working dir:** `/home/raed/projects/air-mentor-ui`

---

## Approach — Non-Negotiable Philosophy

Every decision in this session was driven by **feature intent first, code mechanics second.**

Before touching any file:
1. Read the full feature intent from audit maps, prior handoffs, and product context.
2. Trace the exact data/control flow path that breaks the intent.
3. Fix only what breaks the intent — nothing extra, no cleanup, no preemptive abstraction.
4. Write tests that prove the intent is upheld, not just that code runs without throwing.

This is not a coverage exercise. Every test in `gap-closure-intent.test.ts` has a comment explaining *why* the assertion matters to the product, not just what it checks. When a test was too heavy or too fragile to express real intent, it was skipped rather than written badly.

---

## What Was Done This Session

### GAP-7 — Virtual date drives task due labels ✅

**Intent:** In proof playback mode, when the simulation is at a virtual date (e.g. "Week 8, March 16 2026"), task due labels (`Today`, `This week`, `<dateISO>`) must read relative to that virtual date — not the wall clock. Otherwise a teacher in demo mode sees nonsense due labels.

**Files changed:**

- [`src/domain.ts:346`](../../src/domain.ts#L346) — `toDueLabel(dueDateISO, fallback, anchorISO?)` — added optional third param. When `anchorISO` provided, anchor date replaces `new Date()` for the relative-date comparison.
- [`src/calendar-utils.ts`](../../src/calendar-utils.ts) — `applyPlacementToTask(task, placement, anchorISO?)` — passes `anchorISO` through to `toDueLabel`.
- [`air-mentor-api/src/modules/academic.ts`](../../air-mentor-api/src/modules/academic.ts) — `buildAcademicBootstrap` now includes `proofPlayback.currentDateISO` in the response. Derived from `stageCheckpointRow.createdAt.slice(0, 10)` (the checkpoint's creation date is the virtual date proxy).
- [`src/App.tsx`](../../src/App.tsx) — `OperationalWorkspace`:
  - Derives `proofVirtualDateISO` from `academicBootstrap.proofPlayback?.currentDateISO`.
  - Passes it to both `applyPlacementToTask` calls.
  - Passes it to all `toDueLabel` calls for recurring task scheduling, schedule edits, and task creation in `handleCreateTask`.

**Key non-obvious detail:** `TaskComposerModal` is a separate component — `proofVirtualDateISO` is not in scope inside it. The `due` field is computed in `handleCreateTask` (the `onSubmit` handler in `OperationalWorkspace`) where the anchor is available, not inside the modal.

---

### GAP-1 — Proof offerings get assessment schemes on activation ✅

**Intent:** When a proof simulation run is activated, every offering must have a `Configured` assessment scheme row in the DB. Without it, the stage-eligibility check (`academic.ts:1740`) blocks all stage advancement with "Assessment scheme is not configured." Teachers would be stuck at stage 1 forever.

**Root cause:** `publishOperationalProjection` wrote attendance and scores but never inserted `offeringAssessmentSchemes` rows. `buildDefaultSchemeFromPolicy` in `academic.ts` was a runtime fallback only — it never persisted.

**Fix:** `publishOperationalProjection` now inserts `offeringAssessmentSchemes` rows for every proof offering using the MSRUAS default scheme JSON, with `status: 'Configured'`, on conflict do nothing (idempotent).

**Circular import avoided:** `buildDefaultSchemeFromPolicy` lives in `academic.ts` which already imports from `msruas-proof-control-plane.ts`. Rather than creating a cycle, the default scheme JSON is hardcoded as a constant in the control plane.

---

### GAP-2 — Stage gate prevents locking future-stage evidence ✅

**Intent:** A teacher in stage 1 (pre-TT1) must not be able to lock TT2 scores. The proof simulation seeds all scores at once during activation, so the DB has TT2 scores from day one — but the stage gate must prevent premature commitment of future-stage evidence.

**Fix:** `academic-runtime-routes.ts` — the `PUT .../assessment-entries/:kind` endpoint now checks `offering.stage` against a required stage order map before accepting a lock. TT2 requires stage ≥ 2, quiz requires stage ≥ 2, assignment requires stage ≥ 3, finals requires stage ≥ 4. TT1 is valid at stage 1.

---

### GAP-3 — HOD clear-lock actually clears the DB column ✅

**Intent:** When HOD approves an unlock request, the teacher must be able to re-submit marks. The bug: HOD approval only updated the `academicRuntimeState` JSON blob, not the `sectionOfferings.tt1Locked` DB column. The re-submission endpoint reads the DB column directly — so it would still reject with "This assessment dataset is locked."

**Fix — backend:** New route `POST /api/academic/offerings/:offeringId/assessment-entries/:kind/clear-lock` in `academic-runtime-routes.ts`. Requires HOD role. Clears the `[kind]Locked` column in `sectionOfferings` and returns `{ ok: true, offeringId, kind, cleared: boolean }`. Returns `cleared: false` with `reason: 'already-unlocked'` if idempotent call.

**Fix — API client:** `src/api/client.ts` — `clearOfferingAssessmentLock(offeringId, kind)`.

**Fix — repositories:** `src/repositories.ts` — `clearRemoteLock(offeringId, kind)` in HTTP mode locksAudit.

**Fix — frontend:** `src/App.tsx` `handleResetComplete` — awaits `repositories.locksAudit.clearRemoteLock(offeringId, unlockKind)` before calling `setLockByOffering` to update local state.

---

### GAP-5 — Bootstrap gate blocks entry without active proof run ✅

**Intent:** When no simulation run is active, a sandbox faculty member navigating to the academic portal must see an explicit gate — not a blank/broken workspace with undefined errors.

**Fix — backend:** `academic-bootstrap-routes.ts` now queries for an active simulation run before calling `buildAcademicBootstrap`. If none found, returns `403 { code: 'NO_ACTIVE_PROOF_RUN', message: '...' }`. `buildAcademicBootstrap` is never called — no point building empty data.

**Fix — frontend:** `src/academic-session-shell.tsx` intercepts `code === 'NO_ACTIVE_PROOF_RUN'` and renders a gate page instead of the workspace.

---

### GAP-4 — Session invalidation on proof run archive/activate ✅

**Intent:** When a proof run is archived or a new one is activated, all sandbox faculty sessions must be force-invalidated. Otherwise faculty can continue operating in a stale proof context — seeing data from a run that no longer exists, or operating against the wrong operational semester.

**Files changed:**

- [`air-mentor-api/src/lib/msruas-proof-control-plane.ts`](../../air-mentor-api/src/lib/msruas-proof-control-plane.ts):
  - Added `sessions`, `roleGrants` to schema imports.
  - New private helper `invalidateProofBatchSessions(db, batchId)`:
    - `batchId → batches.branchId`
    - `branchId → roleGrants where scopeId = branchId` (all faculty with any role scoped to this branch)
    - `facultyIds → facultyProfiles.userId` (bridge — `userAccounts` has no `facultyId` column)
    - `userIds → delete sessions where userId IN (...)`
  - `archiveProofSimulationRun` — calls `invalidateProofBatchSessions` after the audit emit.
  - `activateProofSimulationRun` — calls `invalidateProofBatchSessions` after deactivating old runs and before activating the new one. This ensures no faculty can race a request through the activation window using a stale session.

**Join chain (critical):** `roleGrants.scopeId` matches `branches.branchId`. `userAccounts` does NOT have a `facultyId` column — the bridge is `facultyProfiles` which has both `facultyId` (PK) and `userId` (FK to `userAccounts`).

---

### Intent-Driven Tests — `gap-closure-intent.test.ts` ✅

**File:** [`air-mentor-api/tests/gap-closure-intent.test.ts`](../../air-mentor-api/tests/gap-closure-intent.test.ts)

New test file. 10 tests. Every test includes a comment explaining the product intent behind the assertion — not just what it checks.

| Test | Intent |
|------|--------|
| GAP-5: 403 NO_ACTIVE_PROOF_RUN when no active run | Gate must be explicit — not blank/broken |
| GAP-5: 200 + bootstrap called when active run exists | Gate must not block legitimate sessions |
| GAP-1: stage-eligibility blocked without scheme | Stage advance must require a configured scheme |
| GAP-1: stage-eligibility not blocked with Configured scheme | A Configured scheme must not itself block advancement |
| GAP-2: tt2 rejected at stage 1 | Future-stage evidence must not be committable early |
| GAP-2: tt1 allowed at stage 1 | Stage gate must not over-block valid current-stage evidence |
| GAP-3: clear-lock sets DB column to 0, returns cleared:true | The physical column must be cleared — runtime blob alone is not enough |
| GAP-3: clear-lock idempotent, returns cleared:false | Double-clear is not an error |
| GAP-3: Course Leader rejected with 403 | Role separation is the whole point of the HOD approve pattern |
| GAP-4: Faculty session deleted after archive | Stale sessions must not survive a run transition |

**Key test helpers:**
- `getProofOfferingId(db)` — finds active run → highest-semesterNumber term → first offering. Joins via `academicTerms` (not directly via `sectionOfferings.batchId` which doesn't exist).
- `loginAsHOD(app)` — logs in as `devika.shetty` (has HOD grant `grant_mnc_t1_hod`) → POST `/api/session/role-context` to switch active role → returns updated cookie.

---

## Open Gaps

### GAP-6 — Section env params not slider-configurable (DEFERRED) 🟡

**What:** `teacherStrictnessIndex`, `assessmentDifficultyIndex`, `interventionCapacity` are deterministically seeded from `stableBetween(seed, min, max)`. ML params (learning rate, risk thresholds) are hardcoded. No UI or DB mechanism to configure these per proof run.

**Why deferred:** Requires a new DB migration (`configJson` column on `simulationRuns`), a new frontend form (sliders per section), and wiring into `activateProofSimulationRun`. The parameter ranges and defaults need a design spec. The simulation still runs correctly without this — it just can't be tuned per-demo.

**When to pick up:** When a demo scenario requires specific risk distributions or teacher behaviors that differ from the current hardcoded seeds. Until then, the seeds produce consistent, reasonable output.

**What to build:**
1. Migration: add `configJson text` to `simulation_runs`.
2. UI: sysadmin sees a config form before activating a run (strictness/difficulty/capacity sliders per section, scenario mix dropdown, risk threshold overrides).
3. Backend: `activateProofSimulationRun` reads `configJson` and passes bounds into seeding functions.

---

### GAP-8 — totalClasses mismatch (LOW PRIORITY) 🟢

**What:** Proof simulation seeds `totalClasses=32` (4 checkpoints × 8 classes). Admin scaffold route uses `totalClasses=50`. Not a demo blocker — admin scaffold path is not used in proof demo flow.

---

## Audit Map Reconciliation — 2026-04-20 Status

The older handoff snapshot said the gap-closure work was not yet reflected in canonical audit-map files. That is no longer true after the reconciliation pass.

### Canonical reconciliation targets and current status:

| Audit Map Area | What's missing |
|----------------|----------------|
| `audit-map/15-final-maps/` | Reconciled to current local truth: GAP-1/2/3/4/5/7 preserved; stale `C-006` / `C-021` carry-forward prose removed where relevant |
| `audit-map/06-data-flow/` | Reconciled: `toDueLabel(anchorISO)` and `proofPlayback.currentDateISO` now explicitly mapped in canonical flow docs |
| `audit-map/04-feature-atoms/` | Reconciled canonical feature-atom files now capture `invalidateProofBatchSessions` coupling and HOD `clear-lock` capability |
| `audit-map/05-dependencies/` | Reconciled canonical dependency files now capture `sessions` + `roleGrants` coupling and remote clear-lock dependency |
| `audit-map/08-ml-audit/` | Reconciled known-state note: proof thresholds/env knobs remain hardcoded under deferred GAP-6 |
| `audit-map/32-reports/simulation-gap-closure-handoff-2026-04-20.md` | Updated with clarified scope and canonical-path truth |
| `audit-map/32-reports/deterministic-gap-closure-plan.md` | Updated with current validation/reconciliation reality |
| `audit-map/23-coverage/coverage-ledger.md` | Updated with the gap-closure intent surface plus focused validation results and sandbox blocker note |

### Validation note

- Frontend/local focused suites now pass:
  - `tests/domain.test.ts`
  - `tests/calendar-utils.test.ts`
  - `tests/academic-session-shell.test.tsx`
- Backend focused local suites now pass where listener-free:
  - `air-mentor-api/tests/academic-bootstrap-routes.test.ts`
  - GAP-5 subset of `air-mentor-api/tests/gap-closure-intent.test.ts`
- Full embedded-Postgres portion of `air-mentor-api/tests/gap-closure-intent.test.ts` remains blocked in this sandbox by `listen EPERM: operation not permitted 127.0.0.1`.

### Deep Pass — Look for Things Not in Audit Maps

The audit maps are thorough but not exhaustive. The `unknown-omission-ledger.md` (2026-04-16) already flagged these areas as underrepresented. A next AI session should perform a **targeted deep pass** on:

1. **Telemetry / startup diagnostics family** (UO-001) — `src/telemetry.ts`, `src/startup-diagnostics.ts`, `air-mentor-api/src/lib/telemetry.ts`, `air-mentor-api/src/lib/operational-event-store.ts` and their tests. The audit maps don't trace the full emission → relay → persistence → sink path.

2. **Proof playback lifecycle helper family** (UO-008) — `proof-control-plane-access.ts`, `proof-control-plane-playback-governance-service.ts`, `proof-control-plane-playback-reset-service.ts`, `proof-control-plane-stage-summary-service.ts`, `proof-observed-state.ts`. The reset/restore/checkpoint-rebuild semantics are underrepresented.

3. **Proof provenance / count-source explanation** (UO-007) — `src/proof-provenance.ts` is consumed across sysadmin, HoD, risk-explorer, student-shell surfaces. No test locks the cross-surface parity of what counts are shown and why. This is a same-truth risk.

4. **Sysadmin helper cluster** (UO-002) — `src/system-admin-provisioning-helpers.ts`, `src/system-admin-scoped-registry-launches.tsx`, `src/system-admin-faculty-calendar-workspace.tsx` — not decomposed in microinteraction maps.

5. **`invalidateProofBatchSessions` security coverage** — the new helper deletes sessions by `roleGrants.scopeId = branchId`. This needs a dedicated test that verifies: (a) sysadmin sessions are NOT deleted (sysadmin role grants have `scopeType = 'global'`, not `branch`), (b) faculty from a different branch are NOT deleted, (c) faculty with no active session are handled gracefully (no error). The current GAP-4 test only checks the happy path.

---

## Complete File Change List (This Session)

### Backend — `air-mentor-api/`

| File | Change |
|------|--------|
| `src/lib/msruas-proof-control-plane.ts` | Added `sessions`, `roleGrants` imports; new `invalidateProofBatchSessions` helper; wired into `archiveProofSimulationRun` and `activateProofSimulationRun`; inserted `offeringAssessmentSchemes` rows in `publishOperationalProjection` (GAP-1) |
| `src/modules/academic-runtime-routes.ts` | New `POST .../assessment-entries/:kind/clear-lock` route (GAP-3); stage-gate check on lock endpoint (GAP-2) |
| `src/modules/academic.ts` | `proofPlayback.currentDateISO` added to bootstrap response (GAP-7); NO_ACTIVE_PROOF_RUN gate (GAP-5) |
| `src/modules/academic-bootstrap-routes.ts` | Active run check before bootstrap (GAP-5) |
| `tests/gap-closure-intent.test.ts` | NEW — 10 intent-driven tests covering all closed gaps |

### Frontend — `src/`

| File | Change |
|------|--------|
| `domain.ts` | `toDueLabel(dueDateISO, fallback, anchorISO?)` — optional virtual date anchor (GAP-7) |
| `calendar-utils.ts` | `applyPlacementToTask(task, placement, anchorISO?)` — passes anchor to `toDueLabel` (GAP-7) |
| `App.tsx` | `proofVirtualDateISO` derived from bootstrap; passed to all due-label computations; `handleResetComplete` awaits `clearRemoteLock` before state update (GAP-3, GAP-7) |
| `api/client.ts` | `clearOfferingAssessmentLock(offeringId, kind)` (GAP-3) |
| `repositories.ts` | `clearRemoteLock(offeringId, kind)` in HTTP mode locksAudit (GAP-3) |
| `academic-session-shell.tsx` | Renders NO_ACTIVE_PROOF_RUN gate page on 403 with that code (GAP-5) |

---

## Deployment Instructions

### Current state

All work remains on branch `promote-proof-dashboard-origin`. Current focused validation truth is:

- frontend/local listener-free suites pass
- backend listener-free bootstrap/gate suites pass
- full embedded-Postgres gap-intent integration remains blocked in this shell by `listen EPERM: operation not permitted 127.0.0.1`
- push/CI/deploy observation must be captured separately after commit

### Step 1 — Commit the current complete state

```bash
cd /home/raed/projects/air-mentor-ui

# Stage backend changes
git add air-mentor-api/src/lib/msruas-proof-control-plane.ts
git add air-mentor-api/src/modules/academic-runtime-routes.ts
git add air-mentor-api/src/modules/academic.ts
git add air-mentor-api/src/modules/academic-bootstrap-routes.ts
git add air-mentor-api/tests/gap-closure-intent.test.ts

# Stage frontend changes
git add src/domain.ts
git add src/calendar-utils.ts
git add src/App.tsx
git add src/api/client.ts
git add src/repositories.ts
git add src/academic-session-shell.tsx

# Stage everything else that has accumulated
git add -u

# Review before committing
git diff --cached --stat
```

Then commit:
```bash
git commit -m "$(cat <<'EOF'
Close GAP-1/2/3/4/5/7: proof simulation lifecycle integrity

- GAP-1: publishOperationalProjection now inserts offeringAssessmentSchemes
  rows (status=Configured) so stage advancement is never blocked by missing scheme
- GAP-2: assessment-entries lock endpoint validates offering.stage against
  required stage order before accepting a lock request
- GAP-3: new POST clear-lock route clears sectionOfferings.[kind]Locked DB
  column; frontend handleResetComplete awaits it before updating local state
- GAP-4: invalidateProofBatchSessions helper deletes all branch-scoped faculty
  sessions on proof run archive or activate
- GAP-5: academic bootstrap returns 403 NO_ACTIVE_PROOF_RUN when no active
  simulation run exists; faculty shell renders explicit gate page
- GAP-7: toDueLabel and applyPlacementToTask accept optional anchorISO;
  proofPlayback.currentDateISO drives all due-label computations in proof mode
- Tests: gap-closure-intent.test.ts — 10 intent-driven integration tests

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>
EOF
)"
```

### Step 2 — Push to GitHub

```bash
git push origin promote-proof-dashboard-origin
```

GitHub Pages will pick up the push if CI is configured to build and deploy the frontend. Check `.github/workflows/` for the Pages deploy action.

### Step 3 — Local machine as server (whenever up)

The local backend is already wired. To run the full proof stack locally:

```bash
npm run dev:live
```

This starts a seeded API on port 4000 and the Vite dev server on port 5173. The seed includes the full MSRUAS proof sandbox (10 faculty `mnc_t1`–`mnc_t10`, semester 6 offerings, active simulation run).

For frontend-only against Railway production API:
```bash
# Railway API already has wiring, use it as backend:
VITE_AIRMENTOR_API_BASE_URL=https://api-production-ab72.up.railway.app npm run dev
```

Or with local fallback when Railway is slow:
```bash
npm run dev:live-with-fallback
```

### Step 4 — Railway (production mode, when ready)

Railway is already wired:
- **Config:** `air-mentor-api/railway.json`
- **Build:** Nixpacks (auto-detects Node)
- **Pre-deploy:** `node dist/db/migrate.js` (runs migrations before start)
- **Start:** `npm run start`
- **Health check:** `/health`
- **Restart policy:** ON_FAILURE, max 10 retries

To deploy to Railway production:
1. Merge `promote-proof-dashboard-origin` into `main` (or whichever branch Railway watches).
2. Railway will pick up the push and deploy automatically.
3. Verify `/health` responds 200 before declaring success.
4. Check `GET /api/admin/proof-runs/active` to confirm the seeded proof run is active.

**Do not merge to main until:** the intent tests pass in CI, and a manual smoke of the proof activation flow confirms `offeringAssessmentSchemes` rows are created.

---

## Credentials for Testing

Sandbox faculty (proof playback mode):
- `devika.shetty` / `faculty1234` — has HOD, Course Leader, Mentor grants
- `mnc_t1` through `mnc_t10` — individual faculty accounts

Sysadmin:
- `sysadmin` / `admin1234`

HOD role switch (after login as `devika.shetty`):
```
POST /api/session/role-context
{ "roleGrantId": "grant_mnc_t1_hod" }
```

---

## What to Do Next (Priority Order)

1. **Run the full test suite** and confirm all existing tests still pass:
   ```bash
   cd air-mentor-api && npx vitest run
   npx vitest run
   ```

2. **Audit map reconciliation** — update `simulation-gap-closure-handoff-2026-04-20.md` section 4 with the implemented fixes listed above. Update `deterministic-gap-closure-plan.md` status table.

3. **Deep repo pass** — perform a fresh targeted audit of the 5 underrepresented areas listed in the "Deep Pass" section above. Focus especially on:
   - Security boundary of `invalidateProofBatchSessions` (sysadmin sessions, cross-branch isolation)
   - Proof provenance cross-surface parity (`src/proof-provenance.ts`)
   - Playback lifecycle reset semantics

4. **GAP-6 design spec** — define what parameters the slider config UI should expose, their ranges, defaults, and how they feed into `stableBetween`. Write the migration. Then implement.

5. **Deploy** when suite is green.

---

## Session Philosophy Summary

Deep codebase analysis. Every feature understood at the level of its data flow, not just its API surface. Intent of each feature kept at the forefront of every decision. Tests written for *why the feature matters*, not *that the code runs*. No speculative abstractions. No cleanup beyond the task. No comments that explain what the code does — only what the code *cannot explain about itself*.
