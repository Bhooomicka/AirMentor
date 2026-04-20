# Model Provider Routing Controller

## Controller Inputs

- task class
- risk class
- live-vs-local sensitivity
- auth/provider readiness
- budget posture
- observed cooldown / reset windows
- slot-local Arctic usage snapshots when available

## Current Routing Output

- native Codex + `gpt-5.4` for high-risk synthesis
- native Codex + `gpt-5.4-mini` for structured passes
- Arctic `google-main` + `gemini-3.1-pro-preview` as the strongest current verified alternate route when native execution fails on non-`native-only` passes
- Arctic `copilot-raed2180416` + `gemini-3.1-pro-preview` as the next verified alternate route
- Arctic `codex` remains guarded until its execution path is separately proven with runtime smoke
- Caveman optional only for low-risk terse passes

## Controller Rules

1. Native Codex remains the default execution path until an alternate slot is both `models-verified` and `execution_verification_state=verified`.
2. Automatic alternate routing is allowed only for passes whose task policy is not `native-only`.
3. When multiple verified slots exist for the same provider, rotate across them with the persisted provider rotation cursor instead of pinning the same account forever.
4. When a provider or slot is excluded because it failed, select the next verified candidate deterministically and record the switch in `25-accounts-routing/switch-history.md`.
5. If no verified route is available, wait only for the bounded window configured by `wait-for-provider-readiness.sh`; do not spin indefinitely.
6. If the bounded wait expires, stop cleanly, write `manual-action-required`, and preserve exact requested model/provider context in the resume command.
7. Treat slot IDs as the authoritative execution identity; account labels are display metadata only and must not decide unattended routing.
8. Require canonical slot binding and execution smoke, not mutable entered labels, before any Arctic slot is eligible for unattended routing.
9. Do not remove a queued pass from `pending.queue` until it reaches `state=completed`; launch success alone is not enough.
10. A pass now runs through `execute-pass-with-failover.sh`, which can retry bounded recoverable failures and rotate to a verified alternate route instead of dying on the first provider error.
11. Usage telemetry is split:
   - native Codex: observed runtime failures plus route-health cooldown state
   - Arctic slots: `arctic stats --json` for session tokens/cost and `arctic run --command usage` for provider-limit / reset visibility
12. `arctic-refresh-usage-report.sh` is the supported refresh path for slot usage state and human-readable reporting.
13. `usage-refresh-orchestrator.sh` keeps usage state fresh on a timer and tightens the poll interval as primary or secondary reset windows approach.
14. Future detached job completions trigger a background usage refresh so later route decisions are less likely to run on stale quota data.

## Provider Constraints

- use native Codex as the default execution layer
- use Arctic `google` only on Pro-class models
- use Arctic `github-copilot` only on the operator-approved allowlist and only when the specific model is separately execution-verified
- current approved Copilot allowlist is: `gpt-5.4`, `claude-opus-4.6`, `claude-opus-4.5`, `gpt-5.4-mini`, `gpt-5.3-codex`, `gemini-3.1-pro-preview`, `gemini-3-pro-preview`, `gemini-2.5-pro`, `claude-sonnet-4.6`, `claude-sonnet-4.5`
- `gemini-2.1-pro` is not locally visible in either Copilot slot; the nearest real Copilot fallback is `gemini-2.5-pro`
- visible-only `github-copilot/gpt-5.4` currently fails with `model_not_supported`
- use Arctic slots instead of the shared global auth store for repeated providers
- do not treat model-visible Arctic slots as execution-ready until smoke verification proves they can return stable output
