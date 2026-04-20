# Dependency: Backend Session Cookie And CSRF Config

- Dependency name: Backend session cookie, CSRF, and origin config
- Dependency type: deployment/config, auth/session
- Source surface or action: API startup, login, restore session, every mutating client request
- Upstream dependency: `DATABASE_URL`, `RAILWAY_TEST_DATABASE_URL`, `SESSION_COOKIE_NAME`, `SESSION_COOKIE_SAME_SITE`, `SESSION_COOKIE_SECURE`, `CSRF_COOKIE_NAME`, `CSRF_SECRET`, `CORS_ALLOWED_ORIGINS`, `SESSION_TTL_HOURS`
- Downstream impacted surfaces: all authenticated API routes, session restore, login, role switching, proof and admin mutations
- Trigger: server startup, session issue/refresh, mutation requests, cross-origin browser traffic
- Data contract or key fields: session cookie name, CSRF cookie name, CSRF token, cookie flags, allowed origin list, session expiry
- Runtime conditions: production-like targets default to `SameSite=None` and `Secure=true`; the frontend must send credentials and attach the CSRF header on mutating requests
- Persistence or config coupling: session and CSRF cookies are backed by database session rows and UI preference rows
- Hidden coupling sources: deployment mode changes cookie flags and origin rules; frontend API base URL fallback changes whether the browser talks to the live backend at all
- Failure mode: missing or wrong CSRF/origin config can break login or mutations; a bad cookie policy can appear as session loss even when the backend session exists
- Drift risk: medium
- Evidence: `air-mentor-api/src/config.ts:65-92`, `air-mentor-api/src/modules/session.ts:25-305`, `src/api/client.ts:1471-1501`, `src/App.tsx:3474-3749`
- Notes: this config layer is a hidden dependency for every live authenticated surface

