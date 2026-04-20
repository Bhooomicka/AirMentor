# Live Verification Runbook

## Baseline

1. Capture Pages shell:
   - `curl -I https://raed2180416.github.io/AirMentor/`
2. Capture Railway health:
   - `curl -I https://api-production-ab72.up.railway.app/health`
3. Record results in `10-live-behavior/` before assuming deploy health.

## Authenticated Verification

When credentials are available, run the repo's existing live suites:

- `npm run verify:proof-closure:live`
- `npm run playwright:admin-live:acceptance`
- `npm run playwright:admin-live:request-flow`
- `npm run playwright:admin-live:teaching-parity`
- `npm run playwright:admin-live:accessibility-regression`
- `npm run playwright:admin-live:keyboard-regression`
- `npm run playwright:admin-live:session-security`
