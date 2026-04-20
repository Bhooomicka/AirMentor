# Unreviewed Surface List

- `src/` exhaustive every-component interaction mapping outside the six high-density clusters plus the sysadmin long-tail helper addendum now captured in `audit-map/12-frontend-microinteractions/component-cluster-microinteraction-map.md` and `audit-map/12-frontend-microinteractions/long-tail-interaction-map.md`
- `src/data.old.ts` formal archival / deletion decision after zero active repo imports were re-confirmed
- `invalidateProofBatchSessions` security-boundary coverage (`sysadmin` session exclusion, cross-branch faculty exclusion, no-session graceful path) beyond the current happy-path archive invalidation assertion
- duplicate data-flow directory naming drift (`audit-map/06-data-flow/` canonical vs `audit-map/06-data-flows/` placeholder) and cleanup decision
- deployed proof-refresh worker liveness/continuity verification (local ownership path is mapped; live runtime evidence still pending)
- fresh proof-risk evaluation artifact regeneration in a less restricted environment
- live proof-risk artifact availability, fallback frequency, and same-student cross-surface parity
- telemetry and startup-diagnostics family (`src/telemetry.ts`, `src/startup-diagnostics.ts`, `air-mentor-api/src/modules/client-telemetry.ts`, `air-mentor-api/src/lib/telemetry.ts`, `air-mentor-api/src/lib/operational-event-store.ts`, and their frontend/backend tests)
- frontend proof provenance / count-source explanation contract (`src/proof-provenance.ts`, `src/academic-proof-summary-strip.tsx`, `src/academic-faculty-profile-page.tsx`, `src/pages/hod-pages.tsx`, `src/pages/risk-explorer.tsx`, `src/pages/student-shell.tsx`, `src/system-admin-proof-dashboard-workspace.tsx`, `src/system-admin-live-app.tsx`); the backend provenance builders are now locally mapped, but user-visible copy parity and live same-truth confirmation remain open
- live/read-only confirmation of proof playback lifecycle semantics, including invalid-checkpoint handling, denied-path behavior, reset safety, and the default active-semester slice that can recurse into playback checkpoints even when surfaced as run-level provenance
- safe read-only live proof/parity observer for deployed same-target role comparison; the current proof smoke and teaching parity helpers mutate live proof lifecycle or faculty records before parity is proven
- current deployment dependency posture for Python NLP, `sentence-transformers`, and optional Ollama curriculum-linkage assist
- workflow-run semantic gap hardening: enforce explicit live-mode env assertions or naming disambiguation for `proof-browser-cadence.yml` so local-seeded runs cannot be misread as live proof
- live authenticated admin flows
- live teacher, HoD, mentor, and student flows
- deployment automation edge cases and stale artifact detection
- seed-data-to-live parity
