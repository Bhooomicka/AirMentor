# Pages Shell Web Observation

Timestamp: `2026-04-15T17:41:10Z`
Pass: `live-behavior-pass`
Commit baseline: `52c97b8e8500029da003f7410ee3f4ecedc4e899`
Tools: `web.open`, `node fetch`

Direct observations:

- `open("https://raed2180416.github.io/AirMentor/")` and `open("https://raed2180416.github.io/AirMentor/#/admin")` still resolved to the `air-mentor-ui` HTML shell in this rerun.
- The `#/admin` fetch normalized back to the same base Pages document, which remains consistent with the repo's hash-only client routing.
- Matching `node fetch(...)` refreshes from the native Codex shell failed before any HTTP round trip with `getaddrinfo EBUSY` for `raed2180416.github.io`, so this rerun still cannot provide shell-side body or header capture from the terminal itself.
- This artifact therefore reconfirms shell-level Pages reachability only through the web fetcher. It does not prove browser-rendered React behavior after bootstrap.

Related evidence:

- Bootstrap headers: `audit-map/17-artifacts/live/2026-04-15T221302Z--pages-root--live--headers--bootstrap.txt`
- Bootstrap HTML shell: `audit-map/17-artifacts/live/2026-04-15T221302Z--pages-root--live--html-shell--bootstrap.html`
- Clean committed parity diff: `audit-map/17-artifacts/diffs/2026-04-15T164515Z--pages-root--diff--head-parity--live-pass.md`
