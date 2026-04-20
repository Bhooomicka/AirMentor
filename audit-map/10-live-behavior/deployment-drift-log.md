# Deployment Drift Log

## 2026-04-15 Bootstrap

- `curl -I https://raed2180416.github.io/AirMentor/` returned `HTTP/2 200`.
- `curl https://raed2180416.github.io/AirMentor/` returned the expected Vite HTML shell with `/AirMentor/assets/...` references.
- `curl -I https://api-production-ab72.up.railway.app/health` returned `HTTP/2 404`.
- `curl https://api-production-ab72.up.railway.app/health` also returned `404`.

Interpretation:

- GitHub Pages is up.
- Railway API readiness is currently inconsistent with repo documentation and prior closeout evidence.
- Do not assume the deployed backend contract is healthy until fresh live verification is captured.

## 2026-04-15 Live Behavior Pass

- `web.open("https://raed2180416.github.io/AirMentor/")` and `web.open("https://raed2180416.github.io/AirMentor/#/admin")` both resolved to the `air-mentor-ui` HTML shell in the current pass.
- A clean committed `HEAD` build run under Pages-style env (`GITHUB_ACTIONS=1`, `GITHUB_REPOSITORY=raed2180416/AirMentor`, `VITE_AIRMENTOR_API_BASE_URL=https://api-production-ab72.up.railway.app`) produced an HTML shell byte-identical to the bootstrap live Pages shell.
- A dirty-worktree Pages-style build produced different `index` and `app-shared` chunk hashes during this pass, but that variance came from undeployed local edits and is not authoritative for live deployment drift.
- Fresh Railway recapture was blocked in the current terminal environment: shell and Node fetches could not resolve the live hosts, Playwright MCP browser calls were cancelled, and the available web fetcher path did not materialize Railway response bodies.
- The canonical live closeout wrapper failed immediately on missing `AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER` and `AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD`, so no authenticated live browser suites were re-run in this pass.

Interpretation:

- The deployed GitHub Pages HTML shell currently aligns with committed source at `HEAD`.
- The existing Railway `/health` contradiction remains open; this pass did not clear it.
- Authenticated live semantic truth remains unproven and is now explicitly blocked by both missing live credentials and current environment capture limitations.

## 2026-04-15 Live Behavior Pass Rerun (17:41Z)

- `web.open("https://raed2180416.github.io/AirMentor/")` and `web.open("https://raed2180416.github.io/AirMentor/#/admin")` still resolved to the `air-mentor-ui` HTML shell in the rerun.
- Direct `node fetch(...)` refreshes for both live hostnames failed again with `getaddrinfo EBUSY`, so the native Codex shell still cannot provide fresh terminal-side live captures.
- `web.open` still did not materialize result rows for Railway `/health`, `/`, or `/openapi.json` in the rerun.
- Playwright MCP browser calls still returned `user cancelled MCP tool call`, so runtime-rendered UI evidence could not be refreshed.
- The canonical live closeout wrapper was rerun with the documented live URLs and still failed immediately on missing `AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER` and `AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD`.

Interpretation:

- GitHub Pages shell reachability remains reconfirmed at the HTML-shell level only.
- The repo still expects Railway `/health`, `/`, and `/openapi.json`, but this rerun could not refresh the API surface because the environment remains blocked before the network round trip.
- Authenticated live semantic truth remains blocked by two independent conditions: missing live credentials and the current shell/browser capture failure.
