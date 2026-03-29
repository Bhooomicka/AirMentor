# Deploy Environment Contract

## Status
- Stage `00B` deploy contract is implemented and kept current with the live closeout flow.
- Live verifier scripts use the canonical system-admin credential pair and fail fast without them in live mode.

## Purpose
- Capture the deploy-time environment contract for GitHub Pages, Railway, and the closeout verification scripts.
- Provide one stable reference for required origins, URLs, and live verification entrypoints before later stages add more detailed deployment evidence.

## Consumers
- Engineers running live closeout verification
- Operators validating Railway and GitHub Pages readiness
- Reviewers checking deployed-stack assumptions against the closeout pack

## Repo Truth Anchors
- `docs/closeout/final-authoritative-plan.md`
- `scripts/verify-final-closeout-live.sh` runs the Railway deploy preflight before the live session contract and browser sweeps whenever Railway auth/context is present.
- `scripts/check-railway-deploy-readiness.mjs`
- `scripts/live-admin-common.sh`
- `air-mentor-api/.env.example`
- `src/startup-diagnostics.ts`
- Canonical live admin env vars: `AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER` and `AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD`.
- Live mode no longer falls back to `sysadmin` / `admin1234`.

## Required Inputs
- Stage `00A` and `00B` ledger rows in `output/playwright/execution-ledger.jsonl`
- Current live session-contract report and live closeout artifacts
- Current frontend/backend startup diagnostics and deploy-readiness findings

## Planned Completion Stage(s)
- Stage `08C`: keep the deploy contract aligned with the completed live closeout sweep and any future deploy changes
