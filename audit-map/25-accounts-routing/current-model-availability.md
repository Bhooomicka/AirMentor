# Current Model Availability

Date: 2026-04-15

This file is based on current local machine evidence only.

## Ground Truth

- Native Codex model cache: `/home/raed/.codex/models_cache.json`
- Arctic slot status files: `audit-map/29-status/arctic-slot-*.status`
- Arctic model snapshots in `audit-map/18-snapshots/accounts/`
- Arctic execution-smoke snapshots in `audit-map/18-snapshots/accounts/`

## Native Codex

Exact locally exposed models:

- `gpt-5.4`
- `gpt-5.4-mini`
- `gpt-5.3-codex`
- `gpt-5.2`

Exact locally verified reasoning-effort values:

- `low`
- `medium`
- `high`
- `xhigh`

Operational interpretation:

- this is the only path on this machine where both model visibility and reasoning-effort control are directly verified end-to-end
- this remains the primary execution path

## Arctic `codex` Across All Six Accounts

Authenticated slots:

- `codex-01`
- `codex-02`
- `codex-03`
- `codex-04`
- `codex-05`
- `codex-06`

Cross-account drift:

- no model-list drift observed across the six authenticated Codex slots

Exact visible models:

- `codex/gpt-5.1-codex`
- `codex/gpt-5.1-codex-max`
- `codex/gpt-5.1-codex-mini`
- `codex/gpt-5.2`
- `codex/gpt-5.2-codex`
- `codex/gpt-5.3-codex`
- `codex/gpt-5.4`

Execution-readiness:

- `audit-map/16-scripts/arctic-verify-slot-execution.sh` probes ordered candidates per provider and records the strongest execution-verified runtime model for each slot
- all six current Codex slot status files now show `execution_verification_state=verified` on `codex/gpt-5.3-codex`
- the preferred visible `gpt-5.4` model remains model-visible but is not separately execution-verified on Arctic Codex
- the routing controller now pins automatic Arctic routes to each slot's execution-verified model instead of silently selecting a higher merely visible model

## Arctic `github-copilot` Across Both Accounts

Authenticated slots:

- `copilot-raed2180416`
- `copilot-accneww432`

Cross-account drift:

- no model-list drift observed across the two authenticated Copilot slots

Exact visible models:

- `github-copilot/claude-haiku-4.5`
- `github-copilot/claude-opus-4.5`
- `github-copilot/claude-opus-4.6`
- `github-copilot/claude-opus-41`
- `github-copilot/claude-sonnet-4`
- `github-copilot/claude-sonnet-4.5`
- `github-copilot/claude-sonnet-4.6`
- `github-copilot/gemini-2.5-pro`
- `github-copilot/gemini-3-flash-preview`
- `github-copilot/gemini-3-pro-preview`
- `github-copilot/gemini-3.1-pro-preview`
- `github-copilot/gpt-4.1`
- `github-copilot/gpt-4o`
- `github-copilot/gpt-5`
- `github-copilot/gpt-5-mini`
- `github-copilot/gpt-5.1`
- `github-copilot/gpt-5.1-codex`
- `github-copilot/gpt-5.1-codex-max`
- `github-copilot/gpt-5.1-codex-mini`
- `github-copilot/gpt-5.2`
- `github-copilot/gpt-5.2-codex`
- `github-copilot/gpt-5.3-codex`
- `github-copilot/gpt-5.4`
- `github-copilot/gpt-5.4-mini`
- `github-copilot/grok-code-fast-1`

Execution-readiness:

- explicit execution smoke on both Copilot slots now uses provider-qualified refs like `github-copilot/gpt-5.4`
- the visible `gpt-5.4` path is rejected at runtime as `model_not_supported`
- `github-copilot/gpt-5.3-codex` is execution-verified on both Copilot slots
- `github-copilot/gemini-3.1-pro-preview` is execution-verified on both Copilot slots
- `github-copilot/gpt-4.1` is also execution-verified on `copilot-raed2180416`
- treat visible Copilot models as discovery data until the specific runtime model is separately verified
- the operator-approved Copilot auto-routing allowlist is narrower than the visible list; see `25-accounts-routing/provider-model-preferences.md`
- `gemini-2.1-pro` is not visible in either Copilot slot on this machine; `gemini-2.5-pro` is the nearest visible Pro-tier fallback

## Arctic `antigravity`

Authenticated slot:

- `antigravity-main`

Exact visible models:

- `antigravity/claude-opus-4-5-thinking`
- `antigravity/claude-sonnet-4-5`
- `antigravity/claude-sonnet-4-5-thinking`
- `antigravity/gemini-3-flash`
- `antigravity/gemini-3-pro-high`
- `antigravity/gemini-3-pro-low`

Execution-readiness:

- the project-level Arctic config now enables `antigravity`, so slot-local model discovery succeeds
- a direct runtime probe against `antigravity/claude-sonnet-4-5` reaches the provider path, but returns `404 Requested entity was not found`
- no `gpt-5.3-codex` or `gpt-5.4` class model is visible on `antigravity-main`
- under the current queue policy floor, `antigravity` is integrated for discovery but not eligible for automatic routing

## Arctic `google`

Authenticated slot:

- `google-main`

Exact visible models:

- `google/gemini-1.5-flash`
- `google/gemini-1.5-flash-8b`
- `google/gemini-1.5-pro`
- `google/gemini-2.0-flash`
- `google/gemini-2.0-flash-lite`
- `google/gemini-2.5-flash`
- `google/gemini-2.5-flash-image`
- `google/gemini-2.5-flash-image-preview`
- `google/gemini-2.5-flash-lite`
- `google/gemini-2.5-flash-lite-preview-06-17`
- `google/gemini-2.5-flash-lite-preview-09-2025`
- `google/gemini-2.5-flash-preview-04-17`
- `google/gemini-2.5-flash-preview-05-20`
- `google/gemini-2.5-flash-preview-09-2025`
- `google/gemini-2.5-flash-preview-tts`
- `google/gemini-2.5-pro`
- `google/gemini-2.5-pro-preview-05-06`
- `google/gemini-2.5-pro-preview-06-05`
- `google/gemini-2.5-pro-preview-tts`
- `google/gemini-3-flash-preview`
- `google/gemini-3-pro-preview`
- `google/gemini-3.1-flash-image-preview`
- `google/gemini-3.1-flash-lite-preview`
- `google/gemini-3.1-pro-preview`
- `google/gemini-3.1-pro-preview-customtools`
- `google/gemini-embedding-001`
- `google/gemini-flash-latest`
- `google/gemini-flash-lite-latest`
- `google/gemini-live-2.5-flash`
- `google/gemini-live-2.5-flash-preview-native-audio`
- `google/gemma-3-12b-it`
- `google/gemma-3-27b-it`
- `google/gemma-3-4b-it`
- `google/gemma-3n-e2b-it`
- `google/gemma-3n-e4b-it`
- `google/gemma-4-26b-it`
- `google/gemma-4-31b-it`

Execution-readiness:

- explicit execution smoke on `google-main` with `google/gemini-3.1-pro-preview` returned the exact expected marker
- `google-main` is execution-verified for unattended alternate routing

## Practical Bottom Line

Actually execution-ready now:

- native Codex with `gpt-5.4`, `gpt-5.4-mini`, `gpt-5.3-codex`, `gpt-5.2`
- Arctic `codex-01` through `codex-06` with `codex/gpt-5.3-codex`
- Arctic `google-main` with `google/gemini-3.1-pro-preview`
- Arctic `copilot-accneww432` with `github-copilot/gpt-5.3-codex`
- Arctic `copilot-raed2180416` with `github-copilot/gpt-5.3-codex`
- Arctic `copilot-accneww432` with `github-copilot/gemini-3.1-pro-preview`
- Arctic `copilot-raed2180416` with `github-copilot/gemini-3.1-pro-preview`
- Arctic `copilot-raed2180416` with `github-copilot/gpt-4.1`

Authenticated and model-visible, but not yet safe to promote to unattended automatic execution:

- Arctic Codex `gpt-5.4` and `gpt-5.4-mini`, which are visible but not separately execution-verified
- Copilot models that are only visible but not separately execution-verified, including `github-copilot/gpt-5.4`
- Antigravity models, because the visible set does not currently contain the required `gpt-5.3-codex` or `gpt-5.4` family

Reasoning-control truth:

- native Codex: exact reasoning-effort controls verified
- Arctic Codex slots: `gpt-5.3-codex` execution is verified, but reasoning-effort control and higher-model execution proof are not yet verified end-to-end
- Arctic GitHub Copilot slots: some runtime models are execution-verified, but no reasoning-effort control surface has been locally verified
- Arctic Google slot: execution is verified, but no provider-specific thinking-control surface has been locally verified through the current wrapper
- high-stakes passes now remain native-first, but can continue on execution-verified alternates when native Codex is cooling down
