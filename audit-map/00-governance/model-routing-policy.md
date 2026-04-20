# Model Routing Policy

## Verified Local Codex Models

Verified from `/home/raed/.codex/models_cache.json` fetched at 2026-04-14T22:08:04Z:

| Official label | Local slug | Local status | Use |
| --- | --- | --- | --- |
| `GPT-5.4` | `gpt-5.4` | Available | Architecture synthesis, reconciliation, live-vs-local high-stakes comparison, final reports |
| `GPT-5.4 mini` | `gpt-5.4-mini` | Available | Structured audit passes, template filling, route extraction, role mapping |
| `GPT-5.4 nano` | not exposed | Not available in local Codex cache | Planned bookkeeping tier; fallback to `gpt-5.4-mini` plus shell automation |
| `GPT-5.4 pro` / Thinking variants | not exposed | Not available in local Codex cache | Manual-only if later exposed |
| `GPT-5.3 Codex` | `gpt-5.3-codex` | Available | Compatibility fallback only |
| `GPT-5.2` | `gpt-5.2` | Available | Fallback for long-running control tasks if `gpt-5.4` routing is unavailable |

## Routing Rules

- Use `gpt-5.4` for contradiction resolution, ML semantics, cross-system synthesis, and final reporting.
- Use `gpt-5.4-mini` for repeatable structured passes and most ledger-backed extraction work.
- Do not hardcode `GPT-5.4 nano` into automation until it appears in the local Codex cache.
- Do not assume unofficial UI labels such as "Extra High" are product names; treat them as local reasoning aliases layered on top of the selected model.
- For provider-specific Arctic preferences, use `25-accounts-routing/provider-model-preferences.md`.

## Escalation

- Start at `gpt-5.4-mini` for structured passes unless the task is already high-risk.
- Escalate to `gpt-5.4` when semantic ambiguity, contradiction density, or downstream impact is high.
- De-escalate only after the ambiguity has been resolved and written to file.
