# Pages Shell HEAD Parity

Timestamp: `2026-04-15T16:45:11Z`
Pass: `live-behavior-pass`

Inputs:

- Live shell artifact: `audit-map/17-artifacts/live/2026-04-15T221302Z--pages-root--live--html-shell--bootstrap.html`
- Clean committed build artifact: `audit-map/17-artifacts/local/2026-04-15T164514Z--pages-root--local--html-shell--head-build.html`

Method:

- Archived clean `HEAD` into `/tmp/airmentor-head-8PK8ht`.
- Built with:
  - `GITHUB_ACTIONS=1`
  - `GITHUB_REPOSITORY=raed2180416/AirMentor`
  - `VITE_AIRMENTOR_API_BASE_URL=https://api-production-ab72.up.railway.app`
- Compared the live bootstrap HTML shell against the clean `HEAD` build with `diff -u`.

Result:

- `diff -u` returned exit code `0`; the two HTML shells were byte-identical.

Interpretation:

- The deployed GitHub Pages HTML shell matches committed `HEAD`.
- A local dirty-worktree Pages-style build produced different chunk hashes during this pass, but that difference is not authoritative for deployment drift because the working tree contains undeployed source edits.

