# Autoswitch Readiness Snapshot

Date: `2026-04-18`

## Scope

Validation of Arctic/native account fallback behavior for unattended overnight passes.

## Files Reviewed

- `audit-map/16-scripts/select-execution-route.sh`
- `audit-map/16-scripts/rotate-provider-or-stop.sh`
- `audit-map/16-scripts/execute-pass-with-failover.sh`
- `audit-map/16-scripts/wait-for-provider-readiness.sh`
- `audit-map/16-scripts/arctic-refresh-usage-report.sh`
- `audit-map/16-scripts/arctic-slot-usage.sh`
- `audit-map/25-accounts-routing/usage-status.md`

## Hardening Applied

1. Slot readiness now rejects unusable routes when:
   - usage view reports blocked/limit reached
   - route state is provider-rejected/quota-blocked/auth-or-entitlement/unexpected-output
   - last probe failure class indicates provider rejection, quota block, auth failure, or transient provider failure
2. Orchestrator startup now reclaims stale idle-shell tmux sessions.
3. Duplicate-session race in `tmux-start-job.sh` no longer hard-fails launch.

## Effective Fallback Order (Observed)

1. native-codex (`native-codex-session`)
2. github-copilot verified slot (`copilot-accneww432`)
3. codex verified slots (for example `codex-05`)
4. google verified slot (`google-main`) when higher-ranked routes are unavailable

## Excluded Routes (Current)

- `copilot-raed2180416`: provider-rejected probe history
- `codex-03`: quota blocked / cooling down
- `codex-04`: cooling down
- `antigravity-main`: unexpected-output execution failure

## Next Actions

1. Keep `usage-refresh-orchestrator.sh` running overnight.
2. Regenerate `usage-status.md` at run start and on wake-up.
3. Re-verify excluded routes after reset windows before promoting them back into fallback.
