# Rate Limit Recovery Policy

- on first rate-limit event, checkpoint immediately
- if an alternate verified provider/account exists, switch only if the task class allows it
- record the before/after route in `25-accounts-routing/switch-history.md`
- if no alternate verified route exists, wait only within the bounded readiness window
- if the bounded wait expires, stop, write manual action required, and do not loop
