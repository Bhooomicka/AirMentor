# Arctic Integration Runbook

## Verified Baseline

- `arctic` installed and runnable
- session and stats commands available
- global shared store still shows `0 credentials`, which is expected because this project uses isolated slot stores instead
- all requested slot stores are authenticated and model-visible
- project-level `.arctic/arctic.json` now limits provider discovery to `codex`, `google`, and `github-copilot`
- slot-aware wrappers now support isolated per-account Arctic state
- execution smoke is still guarded; no slot has yet reached `execution_verification_state=verified`

## What Arctic Can And Cannot Do

- Coding-plan providers use browser/device-style auth flows inside `arctic auth login`
- API-key providers do not use browser login; they require environment variables
- Arctic can represent multiple accounts per provider in docs, but this build has not yet been end-to-end verified locally with a named second account
- the installed CLI rejects local `--name` attempts, so multi-account safety depends on slot isolation instead
- Do not treat "all Google accounts" as one universal Arctic pool; you authenticate per provider class

Examples:

- `codex` or Codex/ChatGPT: coding-plan style auth or import path
- `google`: Google-backed provider path in this installed build
- `GOOGLE_API_KEY`: API-key path for Gemini API style access

## First-Time Setup

1. Prefer slot-aware login, not the global auth store.
2. Authenticate the providers/accounts you want available.
3. Verify:
   - `bash audit-map/16-scripts/arctic-slot-status.sh`
   - `bash audit-map/16-scripts/arctic-slot-models.sh --slot <slot> --refresh`
   - `bash audit-map/16-scripts/arctic-verify-slot-execution.sh --slot <slot>`
4. Record the result in `25-accounts-routing/account-status.md` and slot status files.
5. Refresh usage telemetry when you want current token/cost/limit visibility:
   - `bash audit-map/16-scripts/arctic-slot-usage.sh --slot <slot>`
   - `bash audit-map/16-scripts/arctic-refresh-usage-report.sh`
   - `bash audit-map/16-scripts/usage-refresh-orchestrator.sh`

Recommended explicit commands for this machine instead of the generic picker:

- `bash audit-map/16-scripts/arctic-slot-login.sh codex:codex-06`
- `bash audit-map/16-scripts/arctic-slot-login.sh google:google-main`
- `bash audit-map/16-scripts/arctic-slot-login.sh github-copilot:copilot-raed2180416`

Why explicit is better here:

- avoids ambiguity in the provider picker
- matches locally evidenced provider IDs from the installed binary
- makes it easier to authenticate one provider at a time and verify after each step

## Usage And Limit Visibility

- `arctic stats --json` gives slot-local session token/cost totals
- `arctic run --command usage` gives the human-readable provider usage view, including access state and reset windows when the provider exposes them
- the audit OS now treats that usage view as the authoritative limit/reset surface for Arctic-backed slots
- the generated human-readable summary lives in `25-accounts-routing/usage-status.md`
- the refresh orchestrator shortens its sleep when a primary or secondary reset window is approaching, so 5-hour and longer weekly-style refresh windows are actively revisited instead of left stale

## Recommended Order For This Machine

1. Keep native Codex as the active execution path.
2. Authenticate only the Arctic providers you genuinely expect to switch between.
3. Verify one end-to-end execution path with `arctic-verify-slot-execution.sh` before treating Arctic as operationally trusted.
4. Use OpenCode as fallback if Arctic remains too thin in live use.

## Guided Multi-Login Helper

Use the slot helper when you want to walk several providers or accounts in sequence:

- `bash audit-map/16-scripts/arctic-slot-login-plan.sh first-wave`

Behavior:

- runs one provider login flow at a time
- writes one isolated Arctic store per slot
- shows slot-local `arctic auth list` after each step
- asks you to record the exact account label you authenticated for that slot
- writes a slot status file and auth snapshot after each step
- pauses for you before moving to the next provider
- skips browser login for API-key providers and tells you to set env vars instead
