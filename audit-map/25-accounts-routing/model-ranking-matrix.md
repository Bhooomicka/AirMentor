# Model Ranking Matrix

Date: 2026-04-15

This matrix ranks models using current local machine evidence only.

Read this together with:

- `25-accounts-routing/current-model-availability.md`
- `25-accounts-routing/provider-model-preferences.md`
- `00-governance/model-routing-policy.md`

## Ranking Vocabulary

| Tier | Meaning | Automatic use |
| --- | --- | --- |
| `A1` | execution-ready and preferred | yes |
| `A2` | execution-ready fallback | yes |
| `B1` | model-visible and high-value, but execution-guarded | no unattended auto-use |
| `B2` | model-visible and acceptable manual fallback, but execution-guarded | no unattended auto-use |
| `C` | manual-only, low-priority, or niche | no automatic routing |
| `D` | do not auto-route for this audit | no |

## Native Codex

| Model | Tier | Reasoning control | Best use |
| --- | --- | --- | --- |
| `gpt-5.4` | `A1` | `low`, `medium`, `high`, `xhigh` | architecture, reconciliation, ML semantics, live-vs-local high-stakes work |
| `gpt-5.4-mini` | `A1` | `low`, `medium`, `high`, `xhigh` | structured audit passes, feature/role/dependency mapping |
| `gpt-5.3-codex` | `A2` | `low`, `medium`, `high`, `xhigh` | compatibility fallback for coding-heavy work |
| `gpt-5.2` | `A2` | `low`, `medium`, `high`, `xhigh` | long-running fallback and control tasks |

## Arctic Codex

Identical visible model list across all six authenticated slots.

| Model | Tier | Reasoning control | Best use |
| --- | --- | --- | --- |
| `gpt-5.4` | `B1` | not locally execution-verified | discovery-only until a slot proves it directly |
| `gpt-5.4-mini` | `B1` | not locally execution-verified | discovery-only until a slot proves it directly |
| `gpt-5.3-codex` | `A2` | execution verified, but no proven reasoning-effort control | automatic structured-pass fallback when native is unavailable |
| `gpt-5.2-codex` | `B2` | not locally execution-verified | acceptable alternate fallback |
| `gpt-5.2` | `B2` | not locally execution-verified | acceptable alternate control/fallback |
| `gpt-5.1-codex-max` | `C` | not locally execution-verified | manual-only if stronger options fail |
| `gpt-5.1-codex` | `C` | not locally execution-verified | manual-only if stronger options fail |
| `gpt-5.1-codex-mini` | `C` | not locally execution-verified | low-priority manual-only |

## GitHub Copilot

Identical visible model list across both authenticated slots.

| Model | Tier | Reasoning control | Best use |
| --- | --- | --- | --- |
| `gpt-5.4` | `B1` | not locally execution-verified | strongest approved Copilot alternate if runtime support becomes real |
| `claude-opus-4.6` | `B1` | not locally execution-verified | deep alternate reasoning if runtime support becomes real |
| `claude-opus-4.5` | `B1` | not locally execution-verified | approved alternate deep-reasoning option |
| `gpt-5.4-mini` | `B1` | not locally execution-verified | approved structured-pass alternate |
| `gpt-5.3-codex` | `B1` | not locally execution-verified | approved coding-oriented alternate |
| `gemini-3.1-pro-preview` | `A2` | execution verified on both slots, but no proven reasoning-effort control | currently strongest actually verified Copilot route |
| `gemini-3-pro-preview` | `B2` | not locally execution-verified | approved but not yet runtime-proven |
| `gemini-2.5-pro` | `B2` | not locally execution-verified | approved fallback for requested Gemini Pro class |
| `claude-sonnet-4.6` | `B2` | not locally execution-verified | approved but not yet runtime-proven |
| `claude-sonnet-4.5` | `B2` | not locally execution-verified | approved but not yet runtime-proven |
| `gpt-5` | `D` | not locally execution-verified | operator-excluded from Copilot auto-routing |
| `gpt-5.1` | `D` | not locally execution-verified | operator-excluded from Copilot auto-routing |
| `gpt-5.1-codex` | `D` | not locally execution-verified | operator-excluded from Copilot auto-routing |
| `gpt-5.1-codex-max` | `D` | not locally execution-verified | operator-excluded from Copilot auto-routing |
| `gpt-5.1-codex-mini` | `D` | not locally execution-verified | operator-excluded from Copilot auto-routing |
| `claude-sonnet-4` | `D` | not locally execution-verified | operator-excluded from Copilot auto-routing |
| `gpt-5-mini` | `D` | not locally execution-verified | operator-excluded from Copilot auto-routing |
| `gpt-4.1` | `D` | verified on `copilot-raed2180416` | runtime-proven but operator-excluded from automatic Copilot routing |
| `gpt-4o` | `D` | not locally execution-verified | operator-excluded from Copilot auto-routing |
| `grok-code-fast-1` | `D` | not locally execution-verified | operator-excluded from Copilot auto-routing |
| `gemini-3-flash-preview` | `D` | not locally execution-verified | do not auto-route |
| `claude-opus-41` | `D` | not locally execution-verified | operator-excluded from Copilot auto-routing |
| `claude-haiku-4.5` | `D` | not locally execution-verified | do not auto-route for this audit |

Operator note:

- `gemini-2.1-pro` was requested, but it is not locally visible in either Copilot slot
- the nearest actually visible Pro-class Gemini candidate is `gemini-2.5-pro`

## Google

The Google slot exposes many models, but only Pro-class models are acceptable for this audit.

| Model | Tier | Reasoning control | Best use |
| --- | --- | --- | --- |
| `gemini-3.1-pro-preview` | `A2` | execution verified, but no proven thinking-control surface | strongest Google alternate |
| `gemini-3.1-pro-preview-customtools` | `B1` | not locally execution-verified | strongest Google alternate if execution becomes verified |
| `gemini-3-pro-preview` | `B1` | not locally execution-verified | high-end alternate comparison work |
| `gemini-2.5-pro` | `B1` | not locally execution-verified | high-end alternate reasoning work |
| `gemini-2.5-pro-preview-06-05` | `B2` | not locally execution-verified | acceptable manual fallback |
| `gemini-2.5-pro-preview-05-06` | `B2` | not locally execution-verified | acceptable manual fallback |
| `gemini-1.5-pro` | `C` | not locally execution-verified | manual-only fallback |

All other currently visible Google models are `D` for this audit:

- `gemini-1.5-flash`
- `gemini-1.5-flash-8b`
- `gemini-2.0-flash`
- `gemini-2.0-flash-lite`
- `gemini-2.5-flash`
- `gemini-2.5-flash-image`
- `gemini-2.5-flash-image-preview`
- `gemini-2.5-flash-lite`
- `gemini-2.5-flash-lite-preview-06-17`
- `gemini-2.5-flash-lite-preview-09-2025`
- `gemini-2.5-flash-preview-04-17`
- `gemini-2.5-flash-preview-05-20`
- `gemini-2.5-flash-preview-09-2025`
- `gemini-2.5-flash-preview-tts`
- `gemini-2.5-pro-preview-tts`
- `gemini-3-flash-preview`
- `gemini-3.1-flash-image-preview`
- `gemini-3.1-flash-lite-preview`
- `gemini-embedding-001`
- `gemini-flash-latest`
- `gemini-flash-lite-latest`
- `gemini-live-2.5-flash`
- `gemini-live-2.5-flash-preview-native-audio`
- `gemma-3-12b-it`
- `gemma-3-27b-it`
- `gemma-3-4b-it`
- `gemma-3n-e2b-it`
- `gemma-3n-e4b-it`
- `gemma-4-26b-it`
- `gemma-4-31b-it`

## Practical Controller Rules

1. Use native Codex by default for all unattended audit passes.
2. Use Arctic only when a slot is both model-visible and execution-verified, and pin the selected model to the slot's execution-verified runtime model.
3. Prefer `A1` models first, then `A2`.
4. Never auto-route to `C` or `D` tiers.
5. Use Caveman only as an output-compression aid on low-risk tasks; it does not upgrade a weak model into a safe model.
