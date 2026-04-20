# Railway Deploy Attempt Billing Blocker

Date: `2026-04-16`
Context: `live`
Surface: `Railway api service`

## Goal

Deploy a narrow backend fix that prevents the `air-mentor-api` process from crashing on unhandled `pg` pool idle disconnect errors.

## Preconditions proved in this run

- Railway CLI authentication succeeded in this shell.
- Linked project metadata resolved successfully through Railway CLI.
- The authoritative linked service identity is:
  - project: `71baa9af-c17f-4782-b1a7-f53259a161fe`
  - environment: `d77d0e12-15c1-4b7d-b95a-c8a6cd382b58` (`production`)
  - service: `f81182f4-2023-4ac9-9f26-dad15cb00435`
  - service name: `api`
  - service domain: `https://api-production-ab72.up.railway.app`
- `railway status --json` reported:
  - latest deployment status: `FAILED`
  - active deployments: `[]`
- Public probe still returns Railway fallback `404 Application not found` on `/health`.

## Code fix prepared

An isolated deploy bundle was created from clean `HEAD` plus only the backend pool-error survivability patch:

- `air-mentor-api/src/db/client.ts`

The patch adds a `pool.on('error', ...)` handler so idle PostgreSQL disconnects no longer crash the Node process as an unhandled event.

Local verification completed before deploy attempt:

- targeted test passed: `air-mentor-api/tests/db-client.test.ts`
- backend build passed

## Deploy command attempted

```bash
npx -y @railway/cli@latest up "$tmp_api" --path-as-root -s api -d -m 'Handle pg pool idle errors'
```

## Railway response

```text
Indexing...
Uploading...
Your trial has expired. Please select a plan to continue using Railway.
```

## Interpretation

The backend repair path is blocked by Railway billing state, not by missing auth, missing service identity, or missing code fix.

This means:

- the linked production service is currently known and reachable as a Railway domain
- the service currently has no active working deployment
- the crash fix is ready to deploy
- unattended live closure cannot continue until Railway billing/plan state allows deploy or redeploy operations again

## Exact resume command

After Railway billing/plan access is restored:

```bash
cd /home/raed/projects/air-mentor-ui/air-mentor-api
npx -y @railway/cli@latest up <isolated-fix-bundle-path> --path-as-root -s api -d -m 'Handle pg pool idle errors'
```

After deploy completion, rerun:

```bash
cd /home/raed/projects/air-mentor-ui
RAILWAY_PUBLIC_API_URL='https://api-production-ab72.up.railway.app' \
EXPECTED_FRONTEND_ORIGIN='https://raed2180416.github.io' \
AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER='sysadmin' \
AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD='admin1234' \
npm --workspace air-mentor-api run verify:live-session-contract
```
