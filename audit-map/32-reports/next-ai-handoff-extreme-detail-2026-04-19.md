# AirMentor UI: Next AI Agent Handoff (Extreme Detail)

Date: 2026-04-19 (IST)  
Workspace root: `/home/raed/projects/air-mentor-ui`  
Primary objective: deterministic, explainable, stage-accurate academic operations + proof workflow, with clear UI/UX and zero ambiguity for operators.

---

## 0) Non-Negotiable Operating Intent (Read First)

The next agent must keep these constraints at the center of every change:

1. Product intent first:
- This product is a deterministic operations + proof platform, not a demo toy.
- Stage progression, proof playback, and role surfaces must behave predictably under refresh, role switch, and restart.

2. UI/UX clarity first:
- Every action label must map to one obvious user intent.
- Proof vs live semantics must be explicit, persistent, and never mixed silently.
- A non-technical user should infer “what this does” without reading docs.

3. Determinism first:
- Same input state => same output state across all surfaces.
- Same student + same checkpoint => same core metrics everywhere.
- Any asynchronous fallback must degrade predictably, not silently.

4. Local-first dev velocity first:
- If Railway state is unstable for dev, local stack must remain the authoritative testing path.
- Scripts must pass consistently against local seeded backend.

5. Never trade correctness for perceived speed:
- Fast but wrong state transitions are regressions.
- Optimistic UI is allowed only with reconciliation rules and explicit fallbacks.

---

## 1) Current Ground Truth Snapshot

### 1.1 What was fixed in this pass (high confidence)

1. Setup-readiness gate surfaced and enforced in sysadmin proof-related actions.
- Proof-mutating controls are blocked when required setup is incomplete.
- Blocker reasons are visible where users act.

2. Proof/dashboard wording aligned to plain English intent.
- Legacy/opaque labels were replaced or supported with clearer equivalents.
- Script assertions were updated to match current UX semantics.

3. Backend guard added against class-stage mutation via generic patch route.
- Stage transitions must go through dedicated `advance-stage` flow.
- Prevents hidden side-channel stage drift.

4. Faculty credential flow now supports username/email login and password setup link lifecycle.
- Invite/reset token lifecycle exists.
- Redeem invalidates prior sessions.

5. Local `/health` false-negative fixed for root-base proxy mode.
- In root-base local dev (`VITE_AIRMENTOR_API_BASE_URL='/'`), Vite now proxies both `/api` and `/health`.
- Prevents “API works but backend shown offline” UI confusion.

6. Sysadmin auth flow performance cleanup:
- Removed redundant second full admin dataset bootstrap after login/role-switch when settled session is equivalent.
- Sysadmin logout changed to immediate local clear + background best-effort server logout.
- Removed recent-audit overfetch triggered by `dataLoading` dependency oscillation.

7. Browser smoke suite drift repaired.
- Acceptance/request/proof-risk scripts now align with current wording and state invariants instead of stale text assumptions.

---

### 1.2 Verified passing checks (this cycle)

Targeted tests run and passed:
- `npx vitest run tests/session-response-helpers.test.ts tests/admin-request-selection.test.ts tests/vite-config.test.ts tests/api-connection.test.tsx tests/system-admin-request-workspace.test.tsx`
- `npx vitest run tests/system-admin-proof-dashboard-workspace.test.tsx tests/system-admin-faculties-workspace.test.tsx tests/academic-session-shell.test.tsx`
- `npx vitest run tests/academic-proof-summary-strip.test.tsx tests/faculty-profile-proof.test.tsx tests/hod-pages.test.ts tests/student-shell.test.tsx tests/risk-explorer.test.tsx`
- `npx vitest run` in API package for session/offering tests:
  - `air-mentor-api/tests/session.test.ts`
  - `air-mentor-api/tests/academic-admin-offerings.test.ts`

Browser scripts run and passed in local seeded stack:
- `bash scripts/playwright-admin-live-acceptance.sh`
- `bash scripts/playwright-admin-live-session-security.sh`
- `bash scripts/playwright-admin-live-teaching-parity.sh`
- `bash scripts/playwright-admin-live-request-flow.sh`
- `bash scripts/playwright-admin-live-proof-risk-smoke.sh`

Evidence artifacts are in `output/playwright/`.

### 1.3 Antigravity + Anthropic execution-readiness deep dive (2026-04-19)

Important distinction:
- `authenticated` means OAuth/token exists for slot.
- `execution-ready` means deterministic run probe succeeded and route state is `verified`.

Fresh probe sweep run (same day) across:
- `antigravity-main`, `antigravity-02`, `antigravity-03`, `antigravity-04`, `antigravity-05`, `antigravity-06`, `antigravity-07`, `antigravity-08`, `antigravity-09`, `anthropic-main`

Observed execution truth:
- Execution-ready (`verified`):
  - `antigravity-main`
  - `antigravity-02`
  - `antigravity-03`
  - `antigravity-04`
- Blocked (`failed`):
  - `antigravity-05`: `auth-or-entitlement` (`Error: Verify your account to continue.`)
  - `antigravity-06`: `auth-or-entitlement` (`Error: Verify your account to continue.`)
  - `antigravity-07`: `auth-or-entitlement` (`Error: Permission denied on resource project ...`)
  - `antigravity-08`: `auth-or-entitlement` (`Error: Verify your account to continue.`)
  - `antigravity-09`: `auth-or-entitlement` (`Error: Verify your account to continue.`)
  - `anthropic-main`: `quota-blocked` (`Third-party apps now draw from your extra usage ... claude.ai/settings/usage`)

Anthropic identity marker now captured in status (deep fix):
- `audit-map/16-scripts/arctic-verify-slot-execution.sh` now extracts and stores:
  - `execution_provider_org_id` (current: `c6cb4546-f02c-44be-8176-45ae188f31d1`)
  - `execution_provider_overage_reason` (current: `org_level_disabled`)
  - `execution_provider_identity` (current: `anthropic-org-c6cb4546-f02c-44be-8176-45ae188f31d1`)
- This gives a deterministic account target for browser re-auth even when provider does not return human-readable email/name via CLI token metadata.

Anthropic login labeling hardening:
- `audit-map/16-scripts/arctic-slot-login.sh` now requires explicit Anthropic account email/name entry during login (Zen browser account), instead of silently keeping a generic canonical label.
- `audit-map/16-scripts/arctic-login-check.sh` now auto-heals stale `state=starting-login` to `state=authenticated` when credentials are present.

Routing truth (no hardcoded single-slot lock):
- `select-execution-route.sh ... --require-provider antigravity` returns `route_state=ready` with `selected_candidate_count=4`.
- So pipeline already wired to multiple Antigravity accounts.
- Remaining slots are excluded only because they fail execution gate, not because mapping/routing code ignores them.

Unblock actions:
- For `antigravity-05/06/08/09`: complete provider account verification flow for each specific account until probe succeeds.
- For `antigravity-07`: grant account access to allowed Antigravity project/resource (permission issue), then re-probe.
- For `anthropic-main`: add extra usage credits at `claude.ai/settings/usage`, then re-probe.

Exact Anthropic browser account target for current slot:
- Authenticate the Anthropic browser account bound to provider identity `anthropic-org-c6cb4546-f02c-44be-8176-45ae188f31d1` (org id `c6cb4546-f02c-44be-8176-45ae188f31d1`).

Probe evidence snapshots (latest run):
- `audit-map/18-snapshots/accounts/antigravity-05/execution-smoke-20260419T182224Z.txt`
- `audit-map/18-snapshots/accounts/antigravity-06/execution-smoke-20260419T182247Z.txt`
- `audit-map/18-snapshots/accounts/antigravity-07/execution-smoke-20260419T182311Z.txt`
- `audit-map/18-snapshots/accounts/antigravity-08/execution-smoke-20260419T182335Z.txt`
- `audit-map/18-snapshots/accounts/antigravity-09/execution-smoke-20260419T182357Z.txt`
- `audit-map/18-snapshots/accounts/anthropic-main/execution-smoke-20260419T182401Z.txt`

---

## 2) Important Files Touched (High Signal)

Core product behavior:
- `/home/raed/projects/air-mentor-ui/src/system-admin-live-app.tsx`
- `/home/raed/projects/air-mentor-ui/src/system-admin-proof-dashboard-workspace.tsx`
- `/home/raed/projects/air-mentor-ui/src/system-admin-faculties-workspace.tsx`
- `/home/raed/projects/air-mentor-ui/src/academic-session-shell.tsx`
- `/home/raed/projects/air-mentor-ui/src/proof-provenance.ts`
- `/home/raed/projects/air-mentor-ui/src/pages/student-shell.tsx`
- `/home/raed/projects/air-mentor-ui/src/pages/hod-pages.tsx`
- `/home/raed/projects/air-mentor-ui/src/pages/risk-explorer.tsx`

New utility modules:
- `/home/raed/projects/air-mentor-ui/src/admin-request-selection.ts`
- `/home/raed/projects/air-mentor-ui/src/session-response-helpers.ts`
- `/home/raed/projects/air-mentor-ui/src/batch-setup-readiness.ts`

Frontend runtime/proxy:
- `/home/raed/projects/air-mentor-ui/vite.config.ts`
- `/home/raed/projects/air-mentor-ui/src/api-connection.ts`
- `/home/raed/projects/air-mentor-ui/src/backend-health-indicator.tsx`

Backend guard/auth:
- `/home/raed/projects/air-mentor-ui/air-mentor-api/src/modules/academic-admin-offerings-routes.ts`
- `/home/raed/projects/air-mentor-ui/air-mentor-api/src/modules/session.ts`
- `/home/raed/projects/air-mentor-ui/air-mentor-api/src/lib/password-setup.ts`
- `/home/raed/projects/air-mentor-ui/air-mentor-api/src/db/migrations/0019_password_setup_tokens.sql`

Browser smoke scripts:
- `/home/raed/projects/air-mentor-ui/scripts/system-admin-live-acceptance.mjs`
- `/home/raed/projects/air-mentor-ui/scripts/system-admin-live-request-flow.mjs`
- `/home/raed/projects/air-mentor-ui/scripts/system-admin-proof-risk-smoke.mjs`

---

## 3) What Is Still Not Done (Critical Backlog)

### 3.1 P0 (do next)

1. Academic login/role-switch still pays avoidable settle RTT.
- Current path still does one extra `GET /api/session` on happy path before bootstrap.
- Next change: trust login/switch response for immediate bootstrap; settle only on auth inconsistency or explicit 401 fallback.

2. API backend probing is still serial-blocking when multiple candidates exist.
- False `/health` negative is fixed, but serial probing can still delay first paint.
- Next change: parallel probe with fastest healthy winner; preserve deterministic telemetry.

3. Backend authoritative setup-readiness endpoint is missing.
- Frontend computes readiness now.
- Next change: move to backend endpoint returning canonical blocker list and completion contract.

### 3.2 P1 (very important)

4. Cross-surface same-student parity contract still incomplete.
- Need one canonical comparison contract shared across:
  - proof summary strip
  - faculty profile
  - HoD watchlist/analytics
  - student shell
  - risk explorer

5. Real email transport integration still pending.
- Token lifecycle exists.
- SMTP/transactional delivery + production hardening still missing.

6. Startup payload still heavy.
- Second sysadmin burst removed, but first boot remains expensive.
- Need critical-vs-background split in both academic and sysadmin bootstrap.

### 3.3 P2 (cleanup/hardening)

7. Controlled vocabulary table still not centralized.
- UI terms can drift again unless vocabulary becomes contract-driven.

8. Some Playwright checks still text-fragile.
- Prefer data attributes + structural invariant assertions over prose text.

---

## 4) Deterministic Next Execution Plan (for next agent)

Follow this exact order; do not skip verification gates.

### Step A: Lock startup/auth performance path without regressing correctness

Implement:
- Academic login/switch: remove mandatory happy-path settle round-trip.
- API probe strategy: parallel probe candidates with deterministic tie-breaking and telemetry.

Must keep:
- Session integrity
- CSRF continuity
- Role grant correctness
- Restore fallback correctness

Verification required:
- existing auth/session unit tests
- `playwright-admin-live-session-security.sh`
- `playwright-admin-live-teaching-parity.sh`
- add new targeted tests for “no extra settle RTT on happy path”

### Step B: Move setup-readiness to backend authority

Implement:
- Backend endpoint: authoritative readiness blockers per selected scope/batch
- Frontend consumes endpoint only (no divergent local rules)

Verification required:
- unit tests for endpoint conditions
- UI tests that proof controls lock/unlock exactly against backend readiness response

### Step C: Build cross-surface parity contract

Implement:
- Shared selector/contract for student+checkpoint proof values
- Assert identical values across all 5 surfaces

Verification required:
- one deterministic integration test fixture with same student/checkpoint
- browser proof-risk flow still green

### Step D: Email transport hardening

Implement:
- actual mail provider integration for invite/reset
- resend/expiry/abuse limits
- user-safe UX messaging

Verification required:
- API integration tests with mocked provider
- UI flow tests for request/inspect/redeem/reset loop

---

## 5) UI/UX Guardrails (must be enforced in every PR)

1. Every action CTA must answer:
- What does this change?
- Is it live or proof?
- Is it reversible?
- What prerequisite blocks it?

2. Live vs proof must always be visible.
- Badge/chip + sentence-level copy
- Never hidden in tooltips only

3. Stage semantics:
- “Current stage” and “selected checkpoint” must never be conflated
- If playback differs from live, show persistent, obvious banner

4. Failures must be instructional, not generic.
- show blocker list
- show exact next action to clear blocker

5. Keyboard + accessibility:
- tabs/buttons reachable and focus-visible
- avoid text-only assertions for functionality in smoke scripts

---

## 6) Deterministic Acceptance Criteria for “Done”

A change set is only “done” when all are true:

1. Unit/integration tests pass for changed modules.
2. Local browser smoke suite passes:
- acceptance
- session-security
- teaching-parity
- request-flow
- proof-risk
3. No new ambiguity introduced in proof/live language.
4. No duplicated data fetch burst introduced on auth transitions.
5. Stage progression paths cannot be bypassed by generic patch endpoints.
6. Same student + same checkpoint parity remains intact across surfaces.

---

## 7) Commands / Runbook

Local target commands (authoritative for dev):

```bash
npm run dev:live
```

Focused tests:

```bash
npx vitest run tests/session-response-helpers.test.ts tests/admin-request-selection.test.ts tests/vite-config.test.ts tests/api-connection.test.tsx
npx vitest run tests/system-admin-proof-dashboard-workspace.test.tsx tests/system-admin-faculties-workspace.test.tsx tests/academic-session-shell.test.tsx
cd air-mentor-api && npx vitest run tests/session.test.ts tests/academic-admin-offerings.test.ts
```

Browser smoke:

```bash
bash scripts/playwright-admin-live-acceptance.sh
bash scripts/playwright-admin-live-session-security.sh
bash scripts/playwright-admin-live-teaching-parity.sh
bash scripts/playwright-admin-live-request-flow.sh
bash scripts/playwright-admin-live-proof-risk-smoke.sh
```

Artifacts:
- `output/playwright/`

---

## 8) Risks / Footguns

1. Dirty worktree is large and mixed.
- Do not “clean up” broadly.
- Touch only files required for current scoped task.

2. Some scripts historically encoded stale UI text.
- Before trusting smoke failure, confirm whether failure is product bug or script drift.

3. Acceptance and request-flow scopes differ.
- Request closeout determinism should be validated in request-flow script.
- Acceptance should remain broad platform navigation/section readiness coverage.

4. Backend/local env mismatch can masquerade as frontend bug.
- Always confirm local seeded backend health and data before triage.

---

## 9) Suggested First Task for Next Agent (Concrete)

Implement “academic happy-path auth no-extra-settle RTT” end-to-end:

1. Change login/switch path to bootstrap immediately from returned `ApiSessionResponse`.
2. Keep settle fallback only when needed (401/inconsistency).
3. Add regression tests proving one fewer auth RTT in normal path.
4. Re-run full browser smoke suite.
5. Update this handoff + `system-deep-audit-and-repair-2026-04-18.md` with measured delta.

---

## 10) Final Instruction to Next Agent

Do not optimize blindly.  
For every change, prove all three:

1. Deterministic behavior improved.
2. User understanding improved (not just code elegance).
3. No cross-surface semantic drift introduced.

If any change makes UX wording more ambiguous, revert that part and redesign before merging.

