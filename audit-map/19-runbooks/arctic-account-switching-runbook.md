# Arctic Account Switching Runbook

Current posture: slot-aware, authenticated, and still guarded/manual until the first execution-verified alternate route is proven.

## Safe Flow

1. checkpoint the current pass
2. log the intended switch in `25-accounts-routing/switch-history.md`
3. select the intended authenticated slot
4. verify slot state with `bash audit-map/16-scripts/arctic-slot-status.sh`
5. if the slot is missing, authenticate it with `bash audit-map/16-scripts/arctic-slot-login.sh <provider>:<slot>`
6. refresh slot models and record the preferred visible model:
   - `bash audit-map/16-scripts/arctic-slot-models.sh --slot <slot> --refresh`
7. verify execution with `bash audit-map/16-scripts/arctic-verify-slot-execution.sh --slot <slot>`
8. resume the queued pass and update status files

## Unsupported Docs-Only Syntax

Arctic docs support multiple accounts per provider with account-qualified model syntax:

- login second account example: `arctic auth login anthropic --name work`
- use a named account example: `arctic run --model anthropic:work/claude-sonnet-4-5 "..."`

Local caveat:

- the installed CLI help does not currently expose `--name`
- local `--name` attempts returned generic command help instead of entering auth
- do not use this syntax operationally on this machine

Locally evidenced provider identifiers from the installed binary:

- `codex`
- `google`
- `github-copilot`

## Google-Backed Accounts

For Google-backed browser auth such as `google` in this build:

- use one intended Google identity per login pass
- prefer a dedicated browser profile or incognito window if the chooser is sticky
- verify the resulting credential with `bash audit-map/16-scripts/arctic-slot-status.sh` before moving to the next account

## Recommended Slot Naming For This Project

- `codex-01` through `codex-06`
- `google-main`
- `copilot-raed2180416`
- `copilot-accneww432`

Use `25-accounts-routing/desired-provider-account-plan.md` for the canonical account labels to type during login.

## Safe Slot Login Command

```bash
bash audit-map/16-scripts/arctic-slot-status.sh
```

Use `desired-provider-account-plan.md` if a slot needs to be re-authenticated.
