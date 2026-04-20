# Live Sources

## Direct sources used in this pass

- GitHub Pages frontend: `https://raed2180416.github.io/AirMentor/`
- GitHub Pages admin hash shell: `https://raed2180416.github.io/AirMentor/#/admin`
- Bootstrap live artifacts:
  - `audit-map/17-artifacts/live/2026-04-15T221302Z--pages-root--live--headers--bootstrap.txt`
  - `audit-map/17-artifacts/live/2026-04-15T221302Z--pages-root--live--html-shell--bootstrap.html`
  - `audit-map/17-artifacts/live/2026-04-15T221301Z--railway-health--live--headers--bootstrap.txt`
  - `audit-map/17-artifacts/live/2026-04-15T221301Z--railway-health--live--body--bootstrap.txt`
- Current-pass live artifacts:
  - `audit-map/17-artifacts/live/2026-04-15T164511Z--pages-shell--live--web-observation--live-pass.md`
  - `audit-map/17-artifacts/live/2026-04-15T164512Z--live-closeout--live--credential-blocker--live-pass.txt`
  - `audit-map/17-artifacts/live/2026-04-15T164513Z--live-capture-path--live--environment-blocker--live-pass.md`
- Current-rerun live artifacts:
  - `audit-map/17-artifacts/live/2026-04-15T174110Z--pages-shell--live--web-observation--live-pass.md`
  - `audit-map/17-artifacts/live/2026-04-15T174110Z--live-closeout--live--credential-blocker--live-pass.txt`
  - `audit-map/17-artifacts/live/2026-04-15T174110Z--live-capture-path--live--environment-blocker--live-pass.md`
- Current-pass local comparison artifacts:
  - `audit-map/17-artifacts/local/2026-04-15T164514Z--pages-root--local--html-shell--head-build.html`
  - `audit-map/17-artifacts/diffs/2026-04-15T164515Z--pages-root--diff--head-parity--live-pass.md`

## Supporting local truth anchors

- `docs/closeout/deploy-env-contract.md`
- `.github/workflows/deploy-pages.yml`
- `.github/workflows/deploy-railway-api.yml`
- `.github/workflows/verify-live-closeout.yml`
- `scripts/verify-final-closeout-live.sh`
- `scripts/check-railway-deploy-readiness.mjs`

## Capture blockers observed in this pass

- Direct `node fetch(...)` refreshes for both live hostnames failed with `getaddrinfo EBUSY` from the current terminal environment.
- Playwright MCP browser calls were cancelled before navigation in both live-pass attempts.
- The available `web` fetcher path reached the Pages shell but did not materialize Railway response bodies in either live-pass attempt.
