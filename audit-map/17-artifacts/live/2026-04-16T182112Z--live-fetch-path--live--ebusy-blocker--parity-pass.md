# Live Fetch Path EBUSY Blocker

- Date: `2026-04-16T18:21:12Z`
- Pass: `live-credentialed-parity-pass`
- Purpose: verify whether the current shell can directly reach the documented live Pages and Railway hosts even before authenticated parity capture

## Commands

```bash
node -e "fetch('https://raed2180416.github.io/AirMentor/').catch(e=>{console.log(JSON.stringify({name:e?.name,message:e?.message,causeName:e?.cause?.name,causeCode:e?.cause?.code,causeMessage:e?.cause?.message},null,2));process.exit(1)})"

node -e "fetch('https://api-production-ab72.up.railway.app/health').catch(e=>{console.log(JSON.stringify({name:e?.name,message:e?.message,causeName:e?.cause?.name,causeCode:e?.cause?.code,causeMessage:e?.cause?.message},null,2));process.exit(1)})"

node -e "fetch('https://api-production-ab72.up.railway.app/api/session/login',{method:'POST',headers:{origin:'https://raed2180416.github.io','content-type':'application/json'},body:JSON.stringify({identifier:'sysadmin',password:'admin1234'})}).catch(e=>{console.log(JSON.stringify({name:e?.name,message:e?.message,causeName:e?.cause?.name,causeCode:e?.cause?.code,causeMessage:e?.cause?.message},null,2));process.exit(1)})"
```

## Observed

### Pages root

```json
{
  "name": "TypeError",
  "message": "fetch failed",
  "causeName": "Error",
  "causeCode": "EBUSY",
  "causeMessage": "getaddrinfo EBUSY raed2180416.github.io"
}
```

### Railway `/health`

```json
{
  "name": "TypeError",
  "message": "fetch failed",
  "causeName": "Error",
  "causeCode": "EBUSY",
  "causeMessage": "getaddrinfo EBUSY api-production-ab72.up.railway.app"
}
```

### Railway session login

```json
{
  "name": "TypeError",
  "message": "fetch failed",
  "causeName": "Error",
  "causeCode": "EBUSY",
  "causeMessage": "getaddrinfo EBUSY api-production-ab72.up.railway.app"
}
```

## Interpretation

- The current shell still cannot resolve either live hostname directly.
- This reproduces the earlier `getaddrinfo EBUSY` transport blocker with fresh timestamped evidence.
- The same-day direct Railway session-login `404` artifact remains important, but this rerun could not refresh it because transport failed before any HTTP response was received.
