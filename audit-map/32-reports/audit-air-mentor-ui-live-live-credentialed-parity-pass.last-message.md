Pass verdict is `live-parity-blocked`.

No same-target live parity could be proven in this session. The current shell has none of the required live env exported, direct shell fetches to both Pages and Railway still fail with `getaddrinfo EBUSY`, Playwright MCP still cancels before navigation, and the latest network-backed Railway session probe from earlier on `2026-04-16` still shows `POST /api/session/login` returning `404 Application not found`. The repo also still lacks a safe read-only live proof/parity observer, so I did not run the mutating proof or teaching parity scripts on production.

I persisted the rerun into [live-same-student-parity.md](/home/raed/projects/air-mentor-ui/audit-map/10-live-behavior/live-same-student-parity.md), [live-credentialed-parity-report.md](/home/raed/projects/air-mentor-ui/audit-map/32-reports/live-credentialed-parity-report.md), the fresh `2026-04-16T182112Z` live artifacts under `audit-map/17-artifacts/live/`, and refreshed coverage, memory, and reconciliation. I also repaired the pass status/checkpoint pair; the monitor restamped supervisor metadata again, and that drift remains tracked as `C-016`.

Exact resume command:
```bash
cd /home/raed/projects/air-mentor-ui/air-mentor-api && \
RAILWAY_PUBLIC_API_URL=https://api-production-ab72.up.railway.app \
EXPECTED_FRONTEND_ORIGIN=https://raed2180416.github.io \
AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> \
AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> \
npm run verify:live-session-contract
```

After that passes, do not run `playwright:admin-live:teaching-parity` on production until a read-only proof/parity observer exists or a full restore path is proven inside the same run.