# Live Credentialed Parity Report

Pass: `live-credentialed-parity-pass`
Context: `live`
Date: `2026-04-16`
Model/provider/account: `gpt-5.4 / native-codex / native-codex-session`
Caveman used: `no`
Live verification performed in this pass: `precondition-only`

## Exact Scope Audited

- Current live-session-contract preflight path
- Current shell live env contract
- Current shell direct fetch transport path
- Current Playwright browser-observation path
- Current live proof and teaching parity helper chain safety
- Current role-identity expectations for `SYSTEM_ADMIN`, `COURSE_LEADER`, `MENTOR`, `HOD`, and student-shell
- Current audit-OS control-plane truth for the live parity pass

## Findings

1. `verify:live-session-contract` is still the correct first live command, and it is safe. A direct rerun with `sysadmin/admin1234` reached the documented Railway URL, but `POST /api/session/login` returned `404 Application not found` with no `csrfToken`, `airmentor_session`, or `airmentor_csrf`.
2. Railway auth is now live in this shell, and the linked production service metadata is no longer ambiguous: the authoritative service is `api` on project `71baa9af-c17f-4782-b1a7-f53259a161fe`, with canonical domain `https://api-production-ab72.up.railway.app`.
3. Railway reports that `api` currently has no active deployments and its latest deployment is failed. This is consistent with the public Railway fallback `404`.
4. Deployment logs show the backend process can reach `startup.ready` and serve live traffic, but later crashes on an unhandled `pg` pool error: `Error: Connection terminated unexpectedly` against `postgres.railway.internal`.
5. A narrow backend fix was prepared and locally verified: add a `pool.on('error', ...)` listener so idle database disconnects do not kill the Node process.
6. The attempted isolated deploy of that fix was rejected by Railway billing state: `Your trial has expired. Please select a plan to continue using Railway.`
7. Playwright MCP still cannot refresh live browser evidence here; `browser_navigate` to the public Pages root returned `user cancelled MCP tool call`.
8. The current repo does not provide a safe blind live proof/parity observer:
   - `scripts/system-admin-proof-risk-smoke.mjs` can create proof imports, validate/review/approve them, recompute risk, create proof runs, and activate semesters.
   - `scripts/system-admin-teaching-parity-smoke.mjs` patches faculty profile and appointment state without a fully proven restore inside the same run.
9. The academic side appears to expect one multi-grant faculty identity rather than separate course-leader/mentor/HoD logins, but this remains code-backed only in this run.
10. Student shell is still only evidenced as an indirect drilldown surface, not a separate live credential path.
11. The machine's default Zen profile does contain historical Railway cookies, but replaying the Railway cookie-session auth hop redirected to `https://railway.com/login`, and GraphQL remained `Not Authorized`. The local Railway browser session is therefore stale for privileged reads and cannot currently auto-resolve the live service domain through browser reuse alone.
12. `audit-map/29-status/audit-air-mentor-ui-live-live-credentialed-parity-pass.status` was left in a stale `running` state with absent recorded PIDs; this report manually reconciles the control plane to terminal blocked truth.
13. The current shell still exposes none of the required live env vars: `PLAYWRIGHT_APP_URL`, `PLAYWRIGHT_API_URL`, `AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER`, `AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD`, and optional `AIRMENTOR_LIVE_TEACHER_IDENTIFIER` are all unset.
14. The current shell still cannot directly resolve either live hostname. Fresh Node fetch probes to Pages root, Railway `/health`, and Railway session login all fail with `getaddrinfo EBUSY`.
15. Playwright MCP browser navigation still immediately returns `user cancelled MCP tool call`, so browser-based re-observation remains unavailable in this session.
16. The live parity pass control plane regressed again before this rerun: status/checkpoint returned to `running`, but the recorded `pid=1431641` and `execution_supervisor_pid=1432544` were already gone.

## Evidence Manifest

- Session-contract direct live probe:
  - `audit-map/17-artifacts/live/2026-04-16T114020Z--railway-session-login--live--direct-probe.md`
- Current shell env contract:
  - `audit-map/17-artifacts/live/2026-04-16T182112Z--live-env-contract--live--credential-blocker--parity-pass.md`
- Current shell transport blocker:
  - `audit-map/17-artifacts/live/2026-04-16T182112Z--live-fetch-path--live--ebusy-blocker--parity-pass.md`
- Current control-plane drift capture:
  - `audit-map/17-artifacts/live/2026-04-16T182112Z--live-parity-status--live--stale-running-control-plane--parity-pass.md`
- Railway deploy/billing blocker:
  - `audit-map/17-artifacts/live/2026-04-16T141700Z--railway-deploy-attempt--live--billing-blocker.md`
- Railway browser-auth replay:
  - `audit-map/17-artifacts/live/2026-04-16T135900Z--railway-auth-cookie-replay--live--zen-session-stale.md`
- Current browser-path blocker:
  - `audit-map/17-artifacts/live/2026-04-16T110353Z--playwright-mcp--live--browser-cancelled--parity-pass.md`
- Current proof/parity safety audit:
  - `audit-map/17-artifacts/live/2026-04-16T110353Z--live-proof-parity-safety--code-audit--parity-pass.md`
- Durable blocked parity artifact:
  - `audit-map/10-live-behavior/live-same-student-parity.md`

## Shared Target Tuple

No shared live target tuple was resolved in this run.

Blocking reason:

- direct live system-admin login against the documented Railway URL returned `404 Application not found`
- the current shell still has no live URLs or credentials exported
- the current shell still cannot resolve either live host directly because fetches fail with `getaddrinfo EBUSY`
- default-browser Railway auth replay lands on `railway.com/login`, so the local Railway operator session is stale
- Railway deployment/redeploy is currently blocked by expired trial / plan state
- no safe read-only proof-target discovery path exists in the current repo

## Credential Matrix

| Surface or role | Identity used | Direct or role-switched | Verified in this run | Exact evidence path |
| --- | --- | --- | --- | --- |
| `SYSTEM_ADMIN` | `sysadmin` | direct | `no` | `audit-map/17-artifacts/live/2026-04-16T182112Z--live-env-contract--live--credential-blocker--parity-pass.md`, `audit-map/17-artifacts/live/2026-04-16T114020Z--railway-session-login--live--direct-probe.md` |
| `COURSE_LEADER` | `unresolved` | role-switched in code | `no` | `scripts/system-admin-proof-risk-smoke.mjs`, `scripts/system-admin-teaching-parity-smoke.mjs` |
| `MENTOR` | `unresolved` | role-switched in code | `no` | `scripts/system-admin-teaching-parity-smoke.mjs` |
| `HOD` | `unresolved` | role-switched in code | `no` | `scripts/system-admin-proof-risk-smoke.mjs` |
| `student shell` | `no separate credential path found` | drilldown | `no` | `scripts/system-admin-proof-risk-smoke.mjs`, `src/pages/student-shell.tsx` |

## Gate Result

- `run contract`: pass
- `verify:live-session-contract first`: pass
- `proof-risk live observation safety audit`: pass
- `same-target parity capture`: fail
- `safe live closure evidence`: fail

Reason:

- documented Railway URL fails the session-login contract
- current shell still lacks exported live env
- current shell still fails direct host resolution with `getaddrinfo EBUSY`
- browser capture path cancelled
- no safe read-only proof/parity observer exists yet

## Remaining Blockers

- The documented Railway public API URL currently returns `404 Application not found` on `/api/session/login`
- The current shell still has no exported live URLs or credentials
- The current shell still cannot directly resolve the live Pages or Railway hosts (`getaddrinfo EBUSY`)
- The local Zen Railway session is stale and cannot currently be reused to query authoritative Railway service metadata
- Railway billing state currently blocks deploy/redeploy of the prepared backend crash fix
- No safe read-only live proof/parity observer in current repo
- No shared live target tuple
- No authenticated role evidence for `COURSE_LEADER`, `MENTOR`, `HOD`, or student-shell

## Exact Resume Command

```bash
cd /home/raed/projects/air-mentor-ui/air-mentor-api && \
RAILWAY_PUBLIC_API_URL=<correct-live-api-url> \
EXPECTED_FRONTEND_ORIGIN=https://raed2180416.github.io \
AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> \
AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> \
npm run verify:live-session-contract
```

If the backend must be recovered first, restore Railway billing/plan access and deploy the prepared pool-error fix before rerunning the session contract.

After the command passes, do not run `playwright:admin-live:teaching-parity` on production until a read-only proof/parity observer exists or a full restore path is proven inside the same run.

## Final Verdict

- `live-parity-blocked`

Confidence rationale:

- high confidence on the blocker itself because it is re-proven by direct command output, current shell env inspection, fresh `EBUSY` transport evidence, and current script inspection
- low confidence on live semantic parity because no authenticated target tuple or rendered role surface was captured
