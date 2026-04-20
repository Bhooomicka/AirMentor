# Dependency: Proof Playback And Bootstrap Selection

- Dependency name: Academic proof playback checkpoint selection
- Dependency type: runtime, persistence, auth/session
- Source surface or action: academic bootstrap and proof playback restore
- Upstream dependency: `airmentor-proof-playback-selection`, `simulationStageCheckpointId`, active session role, `VITE_AIRMENTOR_API_BASE_URL`
- Downstream impacted surfaces: academic bootstrap payload, proof playback overlay, active checkpoint selection, fallback reset notices
- Trigger: app load, session restore, checkpoint selection change, stale selection recovery
- Data contract or key fields: `{ simulationRunId, simulationStageCheckpointId, updatedAt }`, `ApiAcademicBootstrap.proofPlayback`
- Runtime conditions: if the saved checkpoint is invalid or inaccessible, the client clears the saved selection and falls back to the active bootstrap view
- Persistence or config coupling: localStorage holds the proof playback selection and can override the initial academic scope until it is cleared
- Hidden coupling sources: a saved checkpoint may come from a different proof run than the current active session; this can pin the workspace to an older semantic slice without a visible route change
- Failure mode: stale checkpoint selection can reset the proof view, emit a restore notice, or leave the user in a fallback-heavy playback mode
- Drift risk: high
- Evidence: `src/App.tsx:3498-3666, 3713-3749`, `src/proof-playback.ts:1-41`, `air-mentor-api/src/modules/academic-bootstrap-routes.ts:20-58`, `air-mentor-api/src/modules/academic.ts:926-1045`
- Notes: the same proof checkpoint key is also consumed by the sysadmin proof dashboard, so academic and admin surfaces can diverge if the selection is stale

