Track A done. Audit files updated, commit(s) pushed on `promote-proof-dashboard-origin`.

Commits:
- `444c078` `test(audit): preserve gap closure truth`
- `7b82618` `docs(audit): record gap closure push result`
- Current HEAD: `7b82618`

Tests run:
- `npx vitest run tests/domain.test.ts tests/calendar-utils.test.ts tests/academic-session-shell.test.tsx` -> `17/17` passed
- `cd air-mentor-api && npx vitest run tests/academic-bootstrap-routes.test.ts tests/gap-closure-intent.test.ts --testNamePattern "GAP-5|validates a requested playback checkpoint"` -> `3 passed`, `8 skipped`
- `cd air-mentor-api && npx vitest run tests/gap-closure-intent.test.ts` -> listener-backed integration subset blocked in this shell by `listen EPERM: operation not permitted 127.0.0.1`

What changed:
- Fixed backend test drift for GAP-5 active-run gate.
- Added direct GAP-7 proof-virtual-date assertions in frontend tests.
- Reconciled audit canon in `audit-map/15-final-maps/*`, `04-feature-atoms/*`, `05-dependencies/*`, `06-data-flow/*`, `08-ml-audit/*`, coverage/memory/reconciliation files, and gap-closure handoff/plan reports.
- Persisted pass artifact in `audit-map/32-reports/audit-air-mentor-ui-bootstrap-gap-closure-deploy-audit-reconciliation-pass.last-message.md`.
- Reconciled pass control-plane files locally to terminal truth; primary fields are authoritative even though supervisor subfields restamped.

Deferred / low-priority kept as requested:
- `GAP-6` deferred
- `GAP-8` low priority known mismatch

Deploy / CI check:
- `git push` succeeded to `origin/promote-proof-dashboard-origin`
- `gh run list --branch promote-proof-dashboard-origin --limit 20 ...` showed no new auto-triggered runs for current SHA yet
- Only visible branch runs were older manual deploy runs from `2026-04-12` on `84670710...`:
  - `Deploy to GitHub Pages` -> `failure`
  - `Deploy API to Railway` -> `cancelled`

Main residual blocker:
- Full backend intent integration for GAP-1/2/3/4 still needs rerun in listener-permitted environment.
- `invalidateProofBatchSessions` still needs boundary tests for sysadmin exclusion, cross-branch exclusion, and no-session graceful path.