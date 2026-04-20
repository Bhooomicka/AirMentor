# Live UI Flows

## Entry 1

- Surface or workflow: Pages shell bootstrap and hash-shell parity
- Live URL or endpoint: `https://raed2180416.github.io/AirMentor/` and `https://raed2180416.github.io/AirMentor/#/admin`
- Route or state variant tested: root shell and admin hash shell
- Credentials and session context: unauthenticated
- Local expectation: hash routes should land on the same static shell before client boot, and the deployed Pages shell should match a clean committed Pages-style build
- Live observation: root and `#/admin` both resolved to the `air-mentor-ui` HTML shell in both live-pass attempts; the bootstrap live HTML shell is byte-identical to a clean committed `HEAD` build, but direct Node refresh in the native shell is still blocked by `getaddrinfo EBUSY`
- Network evidence: repeated `web.open` success for Pages; clean `HEAD` build parity via `diff -u`; direct Node refresh blocked before any HTTP response
- Artifact paths: `audit-map/17-artifacts/live/2026-04-15T164511Z--pages-shell--live--web-observation--live-pass.md`, `audit-map/17-artifacts/live/2026-04-15T174110Z--pages-shell--live--web-observation--live-pass.md`, `audit-map/17-artifacts/live/2026-04-15T221302Z--pages-root--live--html-shell--bootstrap.html`, `audit-map/17-artifacts/local/2026-04-15T164514Z--pages-root--local--html-shell--head-build.html`, `audit-map/17-artifacts/diffs/2026-04-15T164515Z--pages-root--diff--head-parity--live-pass.md`
- Mismatch: none at HTML-shell level; a dirty-worktree local build differed, but that variance came from undeployed local edits and is not authoritative for live drift
- Confidence: high for shell-level parity; low for runtime-rendered React behavior because no browser-rendered capture completed
- Follow-up: re-run with a working browser path to inspect rendered login/error/loading state and post-bootstrap network activity

## Entry 2

- Surface or workflow: system-admin login plus overview and faculties workspace
- Live URL or endpoint: `https://raed2180416.github.io/AirMentor/#/admin`
- Route or state variant tested: authenticated system-admin shell expected by `scripts/system-admin-live-acceptance.mjs`
- Credentials and session context: live system-admin credentials absent in this shell
- Local expectation: `scripts/verify-final-closeout-live.sh` should authenticate a live system-admin user, reach the overview shell, and navigate the faculties workspace
- Live observation: the canonical live wrapper failed before any browser step in both live-pass attempts because `AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER` and `AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD` were unset
- Network evidence: repeated wrapper fail-fast output, plus repeated environment blockers on direct browser/network recapture
- Artifact paths: `audit-map/17-artifacts/live/2026-04-15T164512Z--live-closeout--live--credential-blocker--live-pass.txt`, `audit-map/17-artifacts/live/2026-04-15T164513Z--live-capture-path--live--environment-blocker--live-pass.md`, `audit-map/17-artifacts/live/2026-04-15T174110Z--live-closeout--live--credential-blocker--live-pass.txt`, `audit-map/17-artifacts/live/2026-04-15T174110Z--live-capture-path--live--environment-blocker--live-pass.md`
- Mismatch: not yet verified live; this pass proves the blocker, not the authenticated behavior
- Confidence: high on the blocker, low on the underlying live UI truth
- Follow-up: export live credentials and rerun `bash scripts/verify-final-closeout-live.sh` from a network-enabled browser environment

## Entry 3

- Surface or workflow: governed request flow
- Live URL or endpoint: `https://raed2180416.github.io/AirMentor/#/admin/requests`
- Route or state variant tested: request list/detail flow expected by `scripts/system-admin-live-request-flow.mjs`
- Credentials and session context: live system-admin credentials absent; no authenticated session
- Local expectation: live request list/detail navigation, notes, transitions, and deep links should pass through the deployed stack
- Live observation: no live request UI was reached in either live-pass attempt because the wrapper failed on missing credentials and the available browser/network paths were blocked
- Network evidence: repeated wrapper fail-fast output and environment blocker note
- Artifact paths: `audit-map/17-artifacts/live/2026-04-15T164512Z--live-closeout--live--credential-blocker--live-pass.txt`, `audit-map/17-artifacts/live/2026-04-15T164513Z--live-capture-path--live--environment-blocker--live-pass.md`, `audit-map/17-artifacts/live/2026-04-15T174110Z--live-closeout--live--credential-blocker--live-pass.txt`, `audit-map/17-artifacts/live/2026-04-15T174110Z--live-capture-path--live--environment-blocker--live-pass.md`
- Mismatch: not yet verified live
- Confidence: high on the blocker, low on live request behavior
- Follow-up: rerun the request-flow script with live credentials after the environment blockers are cleared

## Entry 4

- Surface or workflow: proof dashboard, teaching parity, HoD proof analytics, risk explorer, and student-shell proof parity
- Live URL or endpoint: `https://raed2180416.github.io/AirMentor/#/admin/faculties/academic_faculty_engineering_and_technology/departments/dept_cse/branches/branch_mnc_btech/batches/batch_branch_mnc_btech_2023`
- Route or state variant tested: proof dashboard semester walk plus teacher/HoD/student proof surfaces expected by `scripts/system-admin-proof-risk-smoke.mjs` and `scripts/system-admin-teaching-parity-smoke.mjs`
- Credentials and session context: live system-admin credentials absent; no authenticated session; no fresh Railway endpoint capture available
- Local expectation: the deployed proof dashboard and dependent teaching/HoD/student proof surfaces should load with aligned checkpoint-scoped truth
- Live observation: no proof or teaching parity surface was freshly rendered in either live-pass attempt because the wrapper failed on missing credentials and the available browser/network paths were blocked
- Network evidence: repeated wrapper fail-fast output, repeated environment blocker note, and carry-forward Railway `/health` contradiction
- Artifact paths: `audit-map/17-artifacts/live/2026-04-15T164512Z--live-closeout--live--credential-blocker--live-pass.txt`, `audit-map/17-artifacts/live/2026-04-15T164513Z--live-capture-path--live--environment-blocker--live-pass.md`, `audit-map/17-artifacts/live/2026-04-15T174110Z--live-closeout--live--credential-blocker--live-pass.txt`, `audit-map/17-artifacts/live/2026-04-15T174110Z--live-capture-path--live--environment-blocker--live-pass.md`, `audit-map/17-artifacts/live/2026-04-15T221301Z--railway-health--live--headers--bootstrap.txt`
- Mismatch: live semantic parity across sysadmin, course leader, mentor, HoD, and student-shell remains unproven
- Confidence: medium on the backend risk because `/health` still contradicts the documented readiness contract; low on the current UI truth because this pass could not render the authenticated surfaces
- Follow-up: rerun the live proof and teaching-parity scripts with credentials in a network-enabled browser environment

## Entry 5

- Surface or workflow: accessibility regression, keyboard regression, and session-security regression
- Live URL or endpoint: deployed Pages frontend plus deployed Railway API
- Route or state variant tested: the live closeout regression family expected by `scripts/system-admin-live-accessibility-regression.mjs`, `scripts/system-admin-live-keyboard-regression.mjs`, and `scripts/system-admin-live-session-security.mjs`
- Credentials and session context: live system-admin credentials absent; no authenticated session
- Local expectation: the deployed admin shell should remain accessible, keyboard-safe, and session-safe under live routing and cookie posture
- Live observation: no live regression suite was executed in either live-pass attempt because the live wrapper failed on missing credentials and the environment could not supply a working browser/network capture path
- Network evidence: repeated wrapper fail-fast output and environment blocker note
- Artifact paths: `audit-map/17-artifacts/live/2026-04-15T164512Z--live-closeout--live--credential-blocker--live-pass.txt`, `audit-map/17-artifacts/live/2026-04-15T164513Z--live-capture-path--live--environment-blocker--live-pass.md`, `audit-map/17-artifacts/live/2026-04-15T174110Z--live-closeout--live--credential-blocker--live-pass.txt`, `audit-map/17-artifacts/live/2026-04-15T174110Z--live-capture-path--live--environment-blocker--live-pass.md`
- Mismatch: not yet verified live
- Confidence: high on the blocker, low on the actual live regression status
- Follow-up: rerun the full live closeout wrapper or the individual regression scripts once credentials and browser/network access are available
