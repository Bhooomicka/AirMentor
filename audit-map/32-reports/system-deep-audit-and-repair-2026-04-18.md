# System Deep Audit And Repair

Date: 2026-04-18

## What Was Verified

- Railway API health was checked directly at `https://api-production-ab72.up.railway.app/health` on 2026-04-18 and returned `{ "ok": true }`.
- Local deterministic dev mode was verified through `npm run dev:live`, which starts:
  - frontend at `http://127.0.0.1:5173/`
  - seeded local backend behind the Vite proxy
- Targeted regression coverage for the repaired proof/admin/session flows now passes:
  - `tests/proof-pilot.test.ts`
  - `tests/academic-proof-summary-strip.test.tsx`
  - `tests/student-shell.test.tsx`
  - `tests/student-shell-loading.test.tsx`
  - `tests/risk-explorer.test.tsx`
  - `tests/hod-pages.test.ts`
  - `tests/faculty-profile-proof.test.tsx`
  - `tests/academic-route-pages.test.tsx`
  - `tests/system-admin-proof-dashboard-workspace.test.tsx`
  - `tests/api-connection.test.tsx`

## Deterministic Fixes Applied

### 1. Removed hidden sysadmin proof-batch coercion

The admin workspace was silently forcing operators into the canonical MNC proof batch through three paths:

- global `operatorData` filtering
- auto-populating `registryScope` with the canonical proof scope
- auto-redirecting `#/admin/faculties` into the canonical proof route

That behavior is now removed. Result:

- system admin can stay on the real selected route instead of being snapped into the proof pilot
- registry searches and admin-wide results no longer inherit a hidden proof scope
- the canonical proof batch remains available explicitly, instead of hijacking the workspace

### 2. Simplified proof language across the actual UI

The proof surfaces were using audit-facing language that is technically precise but operator-hostile. The following surfaces now use plain-language explanations:

- academic proof summary strip
- proof provenance helper text
- system admin proof dashboard
- student shell
- HoD proof view
- faculty proof panel
- risk explorer popup guidance

The new rule is:

- say what the page is showing
- say whether it is live data or a saved preview checkpoint
- say whether the numbers stay fixed or follow live semester state
- avoid terms like `checkpoint-bound counts`, `model usefulness`, `no-action comparator`, and `simulated intervention / realized path` in first-line guidance

### 3. Fixed startup backend selection drift

When multiple backend candidates were configured, the client previously booted against the first one immediately and only proved health afterward. That caused exactly the kind of slow login / wrong data / drift symptoms seen when Railway and localhost were both in play.

The selector now:

- keeps a single configured backend available immediately
- waits for the first health probe before choosing among multiple candidates
- prefers a verified healthy fallback instead of briefly booting against the wrong backend

This directly improves local-first development when Railway is slow, stale, or partially unavailable.

## Surfaces Explicitly Reconciled

These surfaces now share clearer proof semantics and no longer rely on the old hidden admin proof lock:

- `#/admin/overview`
- `#/admin/faculties`
- `#/admin/proof-dashboard`
- `#/admin/students`
- `#/admin/faculty-members`
- course leader dashboard proof strip
- mentor proof strip
- queue history proof strip
- faculty profile proof summary and proof popup
- HoD proof analytics
- student shell
- risk explorer

## Remaining Gaps That Still Matter

These were not fully solved in this patch and still need a deliberate follow-up.

### 1. No true “start empty campus” setup workflow yet

The system still does not provide one coherent first-run flow that blocks progression until all required setup is complete. Missing product-level behavior still includes:

- required-config checklist before stage progression
- explicit setup completeness gates for institution, faculty, department, branch, batch, term, curriculum, offerings, teachers, students, mentor assignments, timetable ownership, and grading policy
- stage-block reasons tied to missing configuration, not just proof queue state

### 2. No teacher invite / password reset email loop yet

Current code still uses direct credential storage for faculty creation. There is no full email-driven flow for:

- invite token
- first-time password setup
- forgot-password reset
- expiry / replay protection
- mail delivery integration

### 3. Mixed live-vs-preview cards still exist

The copy is better now, but some pages still mix preview-backed teaching metrics with live admin metadata in the same overall screen. That is valid only if the UI keeps the distinction visible everywhere. The long-term fix is stronger structural separation:

- “Preview data” cards
- “Live admin record” cards
- per-card scope badges

### 4. Stage progression is not yet globally governed by one contract

The proof dashboard already knows when a checkpoint is blocked by queue items. The wider product still needs one shared contract for:

- teacher-side grading prerequisites
- policy/scheme prerequisites
- request approval prerequisites
- unlock/late-entry prerequisites
- date-based release prerequisites

Right now some of that logic is still distributed or implicit.

### 5. Academic bootstrap is still heavy

The backend target selection is fixed, but the academic and sysadmin boot flows still fetch a lot of data eagerly. The next performance pass should split:

- critical first-paint/session restore data
- background secondary data
- role-switch refresh data
- on-demand detail data

Likely wins:

- do not block initial shell on every secondary fetch
- avoid full bootstrap reload on every role switch when only role-bound slices changed
- cache stable dictionaries across role changes

### 6. Same-student parity still needs a hard contract

Audit-map already flagged cross-surface parity drift. The next pass should create one deterministic parity contract for:

- proof summary strip
- faculty profile
- HoD watchlist
- student shell
- risk explorer

For the same student and same selected checkpoint, these surfaces should agree on:

- semester
- stage
- risk band
- queue counts
- no-action view
- intervention history count

### 7. Global wording still needs one shared vocabulary table

This patch fixed the most painful proof wording, but the whole product still needs a controlled vocabulary so the same concept is never shown under three different names. The main ones:

- live semester
- preview checkpoint
- current status
- no-action view
- intervention history
- stage blocked
- reset preview

## Recommended Next Build Sequence

1. Add a first-run sysadmin setup contract with required-step gating.
2. Build teacher invite / reset token workflows in the backend and login UI.
3. Create a shared `stage-readiness` model consumed by sysadmin, teacher entry, and proof progression.
4. Split academic/sysadmin boot into critical-load and background-load phases.
5. Add same-student cross-surface parity tests for one student at one checkpoint.
6. Add end-to-end local-first smoke coverage using `dev:live` as the default test target.

## 2026-04-19 Addendum

### Additional deterministic fixes applied

- Batch setup readiness is now computed explicitly and reused across sysadmin batch setup and proof surfaces.
- Proof-changing actions now lock when the selected batch is not fully configured:
  - `Capture Snapshot`
  - `Generate Preview`
  - `Refresh Risk`
- The proof dashboard and the faculties workspace now expose the same blocker list instead of leaving readiness implicit.
- Generic section-offering patching can no longer mutate class stage state. Stage motion must go through the dedicated `advance-stage` flow.
- Teacher authentication now supports username or email login.
- Password setup links now exist end to end in the backend and academic login shell:
  - request link
  - inspect link
  - redeem link
  - invite-vs-reset semantics
  - existing session invalidation on redeem
- Local-first Vite proxy now forwards both `/api` and `/health` when `VITE_AIRMENTOR_API_BASE_URL='/'`, so the frontend no longer reports a false offline backend while API traffic is working.
- Sysadmin login and role-switch no longer force a second full admin bootstrap when the settled cookie-backed session matches the optimistic session payload.
- Sysadmin logout now clears local workspace state immediately and sends backend logout as a best-effort background call instead of blocking the user on network latency.
- Recent sysadmin audit fetches no longer refire just because admin data loading flips during auth transitions.
- Browser smoke scripts for acceptance, request flow, and proof-risk were realigned to the current plain-English proof vocabulary and current request workflow behavior, eliminating false failures from stale legacy wording.

### Additional targeted verification

- Frontend targeted regression:
  - `tests/system-admin-proof-dashboard-workspace.test.tsx`
  - `tests/system-admin-faculties-workspace.test.tsx`
  - `tests/academic-session-shell.test.tsx`
  - `tests/admin-request-selection.test.ts`
  - `tests/session-response-helpers.test.ts`
  - `tests/vite-config.test.ts`
  - `tests/api-connection.test.tsx`
- Backend targeted regression:
  - `air-mentor-api/tests/session.test.ts`
  - `air-mentor-api/tests/academic-admin-offerings.test.ts`
- Browser smoke:
  - `scripts/playwright-admin-live-acceptance.sh`
  - `scripts/playwright-admin-live-session-security.sh`
  - `scripts/playwright-admin-live-teaching-parity.sh`
  - `scripts/playwright-admin-live-request-flow.sh`
  - `scripts/playwright-admin-live-proof-risk-smoke.sh`

### Remaining high-value gaps after this pass

- A backend-delivered batch-readiness endpoint still does not exist; the current readiness checklist is frontend-derived.
- The proof dashboard vocabulary is materially clearer, but same-checkpoint metric parity should still be hardened across faculty profile, HoD views, student shell, and risk explorer with one shared contract.
- Mail delivery itself is still preview/local-only; the token lifecycle exists, but real outbound email transport is still pending.
- Academic login / role-switch still spends an avoidable `GET /api/session` settle round-trip before bootstrap on the happy path.
- Sysadmin restore still cold-loads a large admin dataset burst; the second burst was removed, but the first paint path still needs critical-vs-background splitting.
- Multi-candidate API health probing still blocks first paint until probes finish; the `/health` false-negative is fixed, but the probe strategy itself should be parallelized next.
