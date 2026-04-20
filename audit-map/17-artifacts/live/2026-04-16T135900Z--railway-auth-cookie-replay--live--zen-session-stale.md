# Railway Auth Cookie Replay

Date: `2026-04-16`
Context: `live`
Surface: `Railway operator auth`

## Purpose

Determine whether the machine's default Zen browser profile still held a usable authenticated Railway operator session that could be reused to resolve the current live Railway service domain without manual re-login.

## Inputs

- Zen profile cookie store: `~/.zen/default/cookies.sqlite`
- Repo-linked Railway service from local CLI config:
  - project: `71baa9af-c17f-4782-b1a7-f53259a161fe`
  - environment: `d77d0e12-15c1-4b7d-b95a-c8a6cd382b58`
  - service: `f81182f4-2023-4ac9-9f26-dad15cb00435`

## Observed browser-session evidence

Zen currently stores Railway-related cookies, including:

- `.railway.com` `rw.authenticated`
- `.railway.com` `rw.authenticated.sig`
- `backboard.railway.com` `rw.session`
- `backboard.railway.com` `rw.session.sig`

This proves the browser has historical Railway session material, but not that the session is still valid for privileged API access.

## Replay procedure

1. Replayed the stored Railway cookies into an HTTP client.
2. Requested the exact Railway cookie-session auth hop used by the Railway web app:

   - `GET https://backboard.railway.com/csc/auth/login?redirect_uri=https://station-server.railway.com/auth/callback`

3. Followed redirects and inspected the final location.
4. Re-tested GraphQL operator access after the replay using:

   - `POST https://backboard.railway.com/graphql/v2`
   - query: `query { me { name email } }`

## Result

- The cookie-session auth hop redirected to `https://railway.com/login`
- Final result was `200` on the public login page, not an authenticated operator destination
- GraphQL still returned `Not Authorized`

## Interpretation

The local Zen Railway session is stale for privileged Railway reads.

This means:

- the machine does not currently hold a reusable authenticated Railway operator browser session
- the local saved Railway CLI token is not equivalent to a valid `RAILWAY_API_TOKEN`
- the current Railway project/service domain cannot be resolved unattended from this shell without fresh Railway re-authentication or a separate valid Railway API token

## Consequence for the live parity campaign

The Railway deployment mismatch remains real:

- the documented AirMentor Railway URL still returns `404 Application not found` on `/api/session/login`
- the local browser session cannot currently be used to fetch authoritative Railway service metadata

Manual Railway re-authentication is therefore a legitimate blocker, not an omitted automation step.
