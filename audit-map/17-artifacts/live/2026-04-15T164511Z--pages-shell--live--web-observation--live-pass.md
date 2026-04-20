# Pages Shell Web Observation

Timestamp: `2026-04-15T16:45:11Z`
Pass: `live-behavior-pass`
Tool: `web.open`

Direct observations:

- `open("https://raed2180416.github.io/AirMentor/")` returned page title `air-mentor-ui` with `text/html` content.
- `open("https://raed2180416.github.io/AirMentor/#/admin")` returned the same shell title and normalized to the same base page, which is consistent with the repo's hash-only client routing.
- The current shell-side environment could not perform a matching `curl` or `fetch` refresh, so this artifact records the direct web fetcher observation used in this pass.

Related evidence:

- Bootstrap headers: `audit-map/17-artifacts/live/2026-04-15T221302Z--pages-root--live--headers--bootstrap.txt`
- Bootstrap HTML shell: `audit-map/17-artifacts/live/2026-04-15T221302Z--pages-root--live--html-shell--bootstrap.html`

