# Dependency: System Admin Proof Dashboard And Canonical Scope

- Dependency name: System admin proof dashboard, checkpoint rail, and canonical proof scope
- Dependency type: runtime, persistence, user-state, auth/session
- Source surface or action: admin proof dashboard, checkpoint selection, proof playback restore
- Upstream dependency: `window.location.hash`, `selectedSectionCode`, `registryScope`, canonical proof batch scope, `airmentor-system-admin-proof-dashboard-tab`, `airmentor-proof-playback-selection`
- Downstream impacted surfaces: proof dashboard tabs, checkpoint rail, queue preview, operational semester banner, proof refresh and recompute actions
- Trigger: admin hash navigation, selecting a checkpoint, changing section scope, refreshing proof data
- Data contract or key fields: `ApiProofDashboard`, `ApiSimulationStageCheckpointSummary`, `ApiProofRunCheckpointDetail`, `proofDashboardTabStorageKey`, route snapshot storage key
- Runtime conditions: checkpoint selection can auto-open the checkpoint tab; if the checkpoint disappears, the tab falls back to summary; blocked checkpoints disable step-forward and play-to-end
- Persistence or config coupling: the dashboard tab is stored in sessionStorage while proof playback selection is stored in localStorage; route snapshots are also stored in sessionStorage per route hash
- Hidden coupling sources: canonical proof route normalization rewrites the visible hierarchy and the search scope; proof-dashboard scope can supersede the normal registry scope and make the same records appear differently
- Failure mode: stale checkpoint state or a missing active run can pin the dashboard to a previous semester, show restore notices, or disable playback progression
- Drift risk: high
- Evidence: `src/system-admin-live-app.tsx:1999-2054, 2081-2086, 2303-2335, 2639-2999, 3030-3037, 6103-6187, 6471-6677`, `src/system-admin-proof-dashboard-workspace.tsx:29-38, 244-377, 416-675, 690-1005`, `src/proof-pilot.ts:15-125`, `src/proof-playback.ts:1-41`
- Notes: canonical proof scope is a hidden dependency that affects the same admin surface without any visible URL change once normalized

