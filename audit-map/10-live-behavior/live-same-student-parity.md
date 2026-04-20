# Live Same-Student Parity

## Run Contract

- Date: `2026-04-16`
- Pass name: `live-credentialed-parity-pass`
- Context: `live`
- Model / provider / account: `gpt-5.4 / native-codex / native-codex-session`
- Caveman used: `no`
- Live stack mode: `probed directly against the documented Pages and Railway URLs`
- App URL: `https://raed2180416.github.io/AirMentor/`
- API URL: `https://api-production-ab72.up.railway.app/`
- Current rerun drift check: `2026-04-16T18:21:12Z`
- Local companion artifact: `audit-map/32-reports/same-student-cross-surface-parity-report.md` now carries the code-backed local parity matrix; this file remains the live-only blocker and resume document.

## Credential Matrix

| Surface or role | Identity used | Auth path | Verified in this run | Evidence |
| --- | --- | --- | --- | --- |
| `SYSTEM_ADMIN` | `sysadmin` | direct live system-admin login expected through `AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER` + `AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD` | `no` | `scripts/check-railway-deploy-readiness.mjs`, `scripts/verify-final-closeout-live.sh`, `audit-map/17-artifacts/live/2026-04-16T182112Z--live-env-contract--live--credential-blocker--parity-pass.md`, `audit-map/17-artifacts/live/2026-04-16T114020Z--railway-session-login--live--direct-probe.md` |
| `COURSE_LEADER` | `unresolved` | academic login plus in-session role switch | `no` | `scripts/system-admin-proof-risk-smoke.mjs` (`switch-role` -> `Course Leader`), `scripts/system-admin-teaching-parity-smoke.mjs`, `scripts/teaching-password-resolution.mjs` |
| `MENTOR` | `unresolved` | academic login plus in-session role switch | `no` | `scripts/system-admin-teaching-parity-smoke.mjs` (`switchRole('Mentor')`), `scripts/teaching-password-resolution.mjs` |
| `HOD` | `unresolved` | academic login plus in-session role switch | `no` | `scripts/system-admin-proof-risk-smoke.mjs` (`switch-role` -> `HoD`), `scripts/teaching-password-resolution.mjs` |
| `student shell` | `no separate live login path found` | indirect drilldown from teacher or HoD proof surfaces | `no` | `scripts/system-admin-proof-risk-smoke.mjs` (teacher and HoD student-shell actions), `src/academic-route-pages.tsx`, `src/pages/student-shell.tsx` |

## Shared Target Tuple

| Field | Value | Evidence |
| --- | --- | --- |
| Academic faculty / department / branch / batch | `unresolved` | live target discovery requires authenticated admin proof-route discovery; direct system-admin login probe now reaches the documented Railway URL but the backend returns `404 Application not found` |
| Route hash or live path | `unresolved` | `scripts/system-admin-proof-risk-smoke.mjs` discovers live route only after system-admin auth, and current direct login probe fails before any authenticated route is available |
| Simulation run id | `unresolved` | no authenticated proof dashboard response captured |
| Checkpoint id | `unresolved` | no authenticated proof dashboard response captured |
| Semester | `unresolved` | no authenticated proof dashboard response captured |
| Stage label / order | `unresolved` | no authenticated proof dashboard response captured |
| Student id | `unresolved` | no authenticated course leader / mentor / HoD / student-shell surface captured |
| Student name / USN | `unresolved` | no authenticated course leader / mentor / HoD / student-shell surface captured |
| Source of target selection | `blocked` | current shell has no exported live URLs/credentials, direct shell fetches still fail with `getaddrinfo EBUSY`, Playwright MCP still cancels, and the repo lacks a safe read-only live proof observer |

## Surface Evidence

### `SYSTEM_ADMIN`

- Live URL or route: `https://raed2180416.github.io/AirMentor/#/admin`
- Observation: the current shell still has no exported live env contract (`PLAYWRIGHT_APP_URL`, `PLAYWRIGHT_API_URL`, `AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER`, `AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD` are all unset), and direct shell fetches to both Pages and Railway still fail with `getaddrinfo EBUSY`. The latest network-backed probe from earlier the same day reached the documented Railway URL, but `POST /api/session/login` returned `404 Application not found`, so no authenticated system-admin surface could be rendered.
- Network / JSON evidence: direct live session/login request returned `404`, no `Set-Cookie`, and no `csrfToken`.
- Artifact paths:
  - `audit-map/17-artifacts/live/2026-04-16T182112Z--live-env-contract--live--credential-blocker--parity-pass.md`
  - `audit-map/17-artifacts/live/2026-04-16T182112Z--live-fetch-path--live--ebusy-blocker--parity-pass.md`
  - `audit-map/17-artifacts/live/2026-04-16T114020Z--railway-session-login--live--direct-probe.md`
  - `audit-map/17-artifacts/live/2026-04-16T110353Z--playwright-mcp--live--browser-cancelled--parity-pass.md`

### `COURSE_LEADER`

- Live URL or route: `unresolved`
- Observation: repo scripts expect a faculty login followed by a role switch to `Course Leader`, but no live teacher identifier/password was verified in this run and the existing proof/parity flows are not safe for blind live use.
- Network / JSON evidence: none captured in this run.
- Artifact paths:
  - `audit-map/17-artifacts/live/2026-04-16T110353Z--live-proof-parity-safety--code-audit--parity-pass.md`

### `MENTOR`

- Live URL or route: `unresolved`
- Observation: repo scripts expect the same teaching session to switch to `Mentor`, but the teaching-parity flow mutates faculty records and was not run.
- Network / JSON evidence: none captured in this run.
- Artifact paths:
  - `audit-map/17-artifacts/live/2026-04-16T110353Z--live-proof-parity-safety--code-audit--parity-pass.md`

### `HOD`

- Live URL or route: `unresolved`
- Observation: repo scripts expect the same teaching session to switch to `HoD`, but the available proof flow mutates proof lifecycle state before HoD evidence is captured and was not run.
- Network / JSON evidence: none captured in this run.
- Artifact paths:
  - `audit-map/17-artifacts/live/2026-04-16T110353Z--live-proof-parity-safety--code-audit--parity-pass.md`

### `student shell`

- Live URL or route: `indirect proof drilldown only`
- Observation: no separate live student credential path was found in the current scripts. Student shell evidence depends on upstream teacher or HoD proof navigation, which remains blocked by safety constraints and missing credentials.
- Network / JSON evidence: none captured in this run.
- Artifact paths:
  - `audit-map/17-artifacts/live/2026-04-16T110353Z--live-proof-parity-safety--code-audit--parity-pass.md`

## Invariant Comparison

| Invariant | `SYSTEM_ADMIN` | `COURSE_LEADER` | `MENTOR` | `HOD` | `student shell` | Verdict | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Student identity | `unresolved` | `unresolved` | `unresolved` | `unresolved` | `unresolved` | `blocked` | no shared live target tuple captured |
| Run id | `unresolved` | `unresolved` | `unresolved` | `unresolved` | `unresolved` | `blocked` | current shell cannot retry authenticated discovery because live env is absent and shell transport remains `EBUSY`; latest network-backed Railway probe earlier the same day still returned `404` |
| Checkpoint id | `unresolved` | `unresolved` | `unresolved` | `unresolved` | `unresolved` | `blocked` | current shell cannot retry authenticated discovery because live env is absent and shell transport remains `EBUSY`; latest network-backed Railway probe earlier the same day still returned `404` |
| Semester / stage | `unresolved` | `unresolved` | `unresolved` | `unresolved` | `unresolved` | `blocked` | current shell cannot retry authenticated discovery because live env is absent and shell transport remains `EBUSY`; latest network-backed Railway probe earlier the same day still returned `404` |
| Risk / playback provenance | `unresolved` | `unresolved` | `unresolved` | `unresolved` | `unresolved` | `blocked` | current repo lacks a safe read-only observer for live proof surfaces, and current shell/browser transport is still blocked |
| Scope-filtered differences | `unresolved` | `unresolved` | `unresolved` | `unresolved` | `unresolved` | `blocked` | legitimate role filtering cannot be compared until the same live target is captured |

## Allowed Differences

- `COURSE_LEADER`, `MENTOR`, and `HOD` are expected to be role-switched academic views when the live faculty identity has multiple grants.
- `student shell` is expected to be a drilldown surface, not a separate top-level live login path, unless later runtime evidence proves otherwise.
- `SYSTEM_ADMIN` may be valid as a credential pair in repo seed data, but that does not prove the documented Railway public API URL still points at the active deployed backend.

## Contradictions

- `C-001`: Railway `/health` remains contradicted against repo expectations and still undermines live backend confidence.
- `C-015`: the current live proof/parity helper chain is not safe for blind live parity work because the proof smoke can mutate proof lifecycle state and the teaching parity smoke can patch faculty records.
- `C-017`: the documented Railway public API URL does not currently satisfy the live session-login contract and returned `404 Application not found` on a direct probe.
- `C-016`: the live parity pass control plane regressed again to a stale `running` state with dead recorded PIDs before this rerun manually reconciled it.

## Blockers Or Manual Checkpoint

- Exact blocker: the current shell has no exported live URLs or credentials, direct shell fetches to both Pages and Railway still fail with `getaddrinfo EBUSY`, Playwright MCP still cancels before navigation, the latest network-backed Railway session probe earlier the same day still returned `404 Application not found`, and the repo does not currently expose a trustworthy read-only live proof/parity observer.
- Exact manual action:
  1. Export the live app/API URLs and live system-admin credentials in a network-capable shell.
  2. Verify the current live Railway public API URL or redeploy the backend to a live URL that actually serves `/api/session/login`.
  3. Re-run the Railway session-contract preflight against the corrected live API URL.
  4. Implement or approve a read-only live proof/parity observer before attempting course-leader, mentor, HoD, or student-shell parity capture on production data.
- Exact resume point: export live env first, then fix or confirm the live API URL, then `verify:live-session-contract`, then safe proof-target observation, then same-target parity capture.
- Exact next command:

```bash
cd /home/raed/projects/air-mentor-ui/air-mentor-api && \
RAILWAY_PUBLIC_API_URL=<correct-live-api-url> \
EXPECTED_FRONTEND_ORIGIN=https://raed2180416.github.io \
AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> \
AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> \
npm run verify:live-session-contract
```

## Verdict

- Coverage achieved: `direct live session probe plus live-script safety audit`
- Remaining uncertainty: `shared target tuple, role identity matrix, live same-student invariants, live proof playback/risk provenance, and all authenticated rendered surfaces`
- Live verification performed: `precondition-only; no authenticated live surface rendered`
- Safe for closure claim: `no`
- Final verdict: `live-parity-blocked`
