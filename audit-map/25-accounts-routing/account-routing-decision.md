# Account Routing Decision

Date: 2026-04-15

## Current Pass Decision

- Task: `account-routing-pass`
- Risk class: `high`
- Preferred provider: `native-codex`
- Preferred account: `native-codex-session`
- Preferred model: `gpt-5.4`
- Preferred reasoning effort: `xhigh`
- Fallback: no automatic provider fallback for this pass; `task-classify-route.sh` marks `account-routing-pass` as `provider_admission_policy=native-only`
- Manual action required: only if native Codex is cooling down, unauthenticated, or runtime-failing; resume with `bash audit-map/16-scripts/run-audit-pass.sh account-routing-pass --context bootstrap --model gpt-5.4 --reasoning-effort xhigh --provider-mode auto`
- Evidence / reason:
  - `audit-map/16-scripts/task-classify-route.sh`
  - `audit-map/16-scripts/check-model-budget.sh`
  - `audit-map/16-scripts/select-execution-route.sh`
  - `audit-map/25-accounts-routing/current-model-availability.md`
  - `audit-map/29-status/route-health-native-codex.status`
  - `/home/raed/.codex/models_cache.json`

## Compatibility Check

- Requested route `gpt-5.4` + `xhigh` is directly compatible with native Codex on this machine.
- `bash audit-map/16-scripts/select-execution-route.sh account-routing-pass --requested-model gpt-5.4` returns `route_state=ready`, `selected_provider=native-codex`, `selected_model=gpt-5.4`, and `provider_admission_policy=native-only`.
- `bash audit-map/16-scripts/select-execution-route.sh account-routing-pass --requested-model gpt-5.4 --require-provider codex` returns `route_state=manual_required` because the pass is policy-locked to native Codex for high-stakes work.

## Alternate Route Posture

- All six Arctic `codex-*` slots are now execution-verified on `gpt-5.3-codex`, and both Copilot slots plus `google-main` are execution-verified on their recorded runtime models.
- That does not change the current pass decision, because the audit controller still reserves `account-routing-pass`, `ml-audit-pass`, `live-behavior-pass`, `audit-the-audit-pass`, and `synthesis-pass` for native Codex.
- The routing controller was tightened in this pass so non-native automatic routing now pins to a slot's execution-verified model instead of silently promoting to a higher merely visible model.

## Blockers And Risks

- Native Codex is the only locally verified route with direct reasoning-effort control, so a native outage still forces a deterministic stop for this pass rather than an unattended provider switch.
- Arctic Codex `gpt-5.4` and `gpt-5.4-mini` remain visible but not separately execution-verified; only `gpt-5.3-codex` is currently proven across all six slots.
- tmux visibility is inconsistent in this shell: `tmux ls` works, but `tmux has-session` against the detached `account-routing-pass` hit `Operation not permitted`. The duplicate detached pass did not show a live supervisor PID during this review, so file updates proceeded interactively.

## Pass Output

- Covered: routing controller scripts, budget guardrail, slot status files, execution-smoke artifacts, queue state, and the account-routing documentation set
- Files updated: `audit-map/16-scripts/select-execution-route.sh`, `audit-map/25-accounts-routing/*`, coverage/memory/reconciliation ledgers, and `audit-map/31-queues/pending.queue`
- Remains uncovered: live authenticated routing recovery under a true native Codex outage; end-to-end reasoning-effort control on Arctic providers; separate execution proof for Arctic-visible `gpt-5.4` / `gpt-5.4-mini`
- Contradictions found: routing docs and reports had drifted behind slot-status truth for Arctic Codex execution readiness
- Risks discovered: provider-level verification had been allowing higher visible but unverified Arctic models to auto-route before this pass tightened the selector
- Routing changed: documentation reconciled; controller behavior changed for alternate providers; current pass decision remained native Codex
- Caveman used: no
- Live verification performed: no
- Next pass: `cost-optimization-pass`
- Manual checkpoint required: no
