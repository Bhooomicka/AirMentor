# Account Status

## Verified Current State

- Native Codex CLI: logged in via ChatGPT
- Arctic global store: installed with credential keys for `anthropic`, `antigravity`, `codex`, `google`, and `github-copilot`
- Arctic slot-isolation framework: ready and mapped to full `19` slots (`1 anthropic`, `9 antigravity`, `6 codex`, `2 copilot`, `1 google`)
- Slot auth seeding automation is available via `bash audit-map/16-scripts/arctic-seed-slots-from-global-auth.sh --all --force`
- Current execution-verified slots (`13/19`):
	- `codex-01..06`
	- `google-main`
	- `copilot-raed2180416`
	- `copilot-accneww432`
	- `antigravity-main`
	- `antigravity-02`
	- `antigravity-03`
	- `antigravity-04`
- Current execution-blocked slots (`6/19`):
	- `anthropic-main`: `provider-unavailable` (`Provider not found: anthropic` in current Arctic build)
	- `antigravity-05..09`: `auth-or-entitlement` (`Status: 403`, `Verify your account to continue`)
- Verification diagnostics now persist clean failure summaries and route-state classes (`provider-unavailable`, `auth-or-entitlement`) for faster rotation decisions
- Caveman: installed as global skills under `~/.agents/skills/`

## Safe Interpretation

- Native Codex is ready now.
- Arctic account continuity is structurally configured through isolated slots sourced from global auth keys.
- Arctic login is complete for the requested slots.
- Arctic model visibility is complete for mapped slots except `anthropic`, which is unsupported by the current Arctic provider runtime.
- Arctic Codex execution is proven across all six slots at `gpt-5.3-codex`.
- Arctic Google execution is proven through `google-main`.
- Arctic GitHub Copilot execution is proven on both slots (`gemini-3.1-pro-preview` currently selected in status files).
- Arctic Antigravity execution is partially proven (`4/9` slots verified, `5/9` blocked at provider account verification).
- Accounts that fail execution verification are now automatically quarantined from route-ready rotation.
- High-stakes audit passes now prefer native Codex first, but can continue on execution-verified alternates when native is cooling down.
- Caveman is available as an optional skill layer, not as an always-on system behavior.

## Plain-English Readiness

- local audit OS: ready
- native Codex execution: ready
- Arctic slot-aware multi-account routing: fully mapped/authenticated; execution-verified alternates currently include Codex, Google, Copilot, and 4 Antigravity slots
- Caveman deterministic per-pass policy: ready
- Caveman deterministic skill auto-application: not yet verified

## Intended Slots

Use `25-accounts-routing/desired-provider-account-plan.md` as the current slot map.

Operational status after login can be listed with:

- `bash audit-map/16-scripts/arctic-slot-status.sh`
- `25-accounts-routing/current-model-availability.md`
