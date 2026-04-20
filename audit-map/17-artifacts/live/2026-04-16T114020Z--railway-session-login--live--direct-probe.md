# Railway Session Login Direct Probe

- Date: `2026-04-16`
- Surface: `POST https://api-production-ab72.up.railway.app/api/session/login`
- Purpose: verify whether the documented live Railway API URL still serves the AirMentor session contract
- Expected:
  - HTTP `200`
  - JSON body with `csrfToken`
  - `Set-Cookie` headers for `airmentor_session` and `airmentor_csrf`

## Command

```bash
node -e "fetch('https://api-production-ab72.up.railway.app/api/session/login',{method:'POST',headers:{origin:'https://raed2180416.github.io','content-type':'application/json'},body:JSON.stringify({identifier:'sysadmin',password:'admin1234'})}).then(async r=>{console.log('status',r.status); console.log('set-cookie',r.headers.get('set-cookie')); console.log((await r.text()).slice(0,500))}).catch(e=>{console.error(e);process.exit(1)})"
```

## Observed

- status: `404`
- `set-cookie`: `null`
- body:

```text
{"status":"error","code":404,"message":"Application not found","request_id":"F08JorwGQ2u_ciYHoB_USg"}
```

## Notes

- This direct live probe supersedes the earlier parity-pass assumption that the shell was only blocked by missing credential environment variables.
- `output/railway-live-session-contract.json` still contains an older `generatedAt: 2026-03-28...` passing report and must be treated as stale local output, not current live truth.
