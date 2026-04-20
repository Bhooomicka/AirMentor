# Dependency: Academic Session Bootstrap And Role Context

- Dependency name: Academic session bootstrap, login, and role-context switching
- Dependency type: auth/session, deployment/config, persistence
- Source surface or action: teaching portal login gate, restore session, role switch
- Upstream dependency: `VITE_AIRMENTOR_API_BASE_URL`, `airmentor_session`, `airmentor_csrf`, `availableRoleGrants`, `activeRoleGrant`, `themeMode`
- Downstream impacted surfaces: `OperationalApp`, role-specific page gating, `academic-session-shell` gate page, session preferences, remote repositories, academic bootstrap payload, proof due-label anchoring
- Trigger: app load, login submit, session restore, role switch, preference save
- Data contract or key fields: `ApiSessionResponse`, `availableRoleGrants`, `activeRoleGrant.roleCode`, `preferences.themeMode`, `proofPlayback.currentDateISO`, `NO_ACTIVE_PROOF_RUN`
- Runtime conditions: remote academic mode only works when the API base URL is present; mutating requests rely on `credentials: include` and `X-AirMentor-CSRF`
- Persistence or config coupling: backend cookie flags and CSRF config control whether the frontend can keep a live session; current faculty ids are persisted to local storage through repository adapters
- Hidden coupling sources: backend role-grant ordering determines the active role seen by the UI; bootstrap now also depends on active proof-run existence before hydration; the frontend maps API role codes back to internal roles and may snap the page to a role home
- Failure mode: missing API base URL, stale session cookie, role-grant mismatch, or missing active proof run can disable live academic mode or reset the workspace to a safe home page / explicit gate screen
- Drift risk: medium
- Evidence: `src/App.tsx:3474-3749`, `src/repositories.ts:213-220, 324-330, 523-587, 868-879`, `air-mentor-api/src/modules/session.ts:25-305`, `air-mentor-api/src/config.ts:65-92`, `air-mentor-api/src/modules/support.ts:25-60`
- Notes: session restore and role switching are backend-authenticated, not mock-only behavior in the live path; proof playback bootstrap also carries a virtual-date anchor (`proofPlayback.currentDateISO`) that downstream due-label helpers must respect during simulation playback
