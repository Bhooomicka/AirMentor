# Provider Model Preferences

This file defines the preferred model surface for the current operator request using current local machine evidence.

- `codex`
- `google` using Pro-class models only
- `github-copilot` using only the strongest models actually exposed after login

## Native Codex Primary Path

Native Codex remains the primary execution path for the forensic audit because its locally exposed model list is verified directly on this machine.

Preferred routing:

| Task class | Preferred model | Reasoning effort | Fallback |
| --- | --- | --- | --- |
| High-stakes synthesis, live-vs-local reconciliation, ML semantics | `gpt-5.4` | `xhigh` | `gpt-5.2` |
| Structured audit passes | `gpt-5.4-mini` | `high` | `gpt-5.2` |
| Low-risk bookkeeping and queue maintenance | `gpt-5.4-mini` | `medium` | shell automation + `gpt-5.2` |

Available locally and evidenced:

- `gpt-5.4`
- `gpt-5.4-mini`
- `gpt-5.3-codex`
- `gpt-5.2`

Cache-declared reasoning-effort support on this machine:

- `gpt-5.4`: `low`, `medium`, `high`, `xhigh`
- `gpt-5.4-mini`: `low`, `medium`, `high`, `xhigh`
- `gpt-5.3-codex`: `low`, `medium`, `high`, `xhigh`
- `gpt-5.2`: `low`, `medium`, `high`, `xhigh`

Not locally exposed:

- `gpt-5.4-nano`
- `GPT-5.4 Thinking / Pro` labels as separately addressable local slugs

## Arctic `codex` Slots

Use Codex slots for continuity or account rotation, not as the default primary path.

Current visible order across all six authenticated slots:

1. `gpt-5.4`
2. `gpt-5.3-codex`
3. `gpt-5.2-codex`
4. `gpt-5.2`
5. `gpt-5.1-codex-max`
6. `gpt-5.1-codex`
7. `gpt-5.1-codex-mini`

Important:

- reasoning-effort control is locally verified in native Codex, not yet end-to-end verified through Arctic
- all six current Codex slots expose the same visible model list
- all six current Codex slots now have `execution_verification_state=verified` at `gpt-5.3-codex`
- visible `gpt-5.4` and `gpt-5.4-mini` remain discovery-only until they are separately execution-verified on Arctic Codex
- automatic alternate routing must pin these slots to the slot execution-verified model `gpt-5.3-codex`, not a higher merely visible model

## Arctic `google` Slots

Only Pro-class Google models should be used for this project.

Current automatic-routing allowlist:

1. `google/gemini-3.1-pro-preview`
2. `google/gemini-3.1-pro-preview-customtools`
3. `google/gemini-3-pro-preview`
4. `google/gemini-2.5-pro`
5. `google/gemini-2.5-pro-preview-06-05`
6. `google/gemini-2.5-pro-preview-05-06`

Rejected for automatic routing:

- Flash tiers
- Flash Lite tiers
- Gemma tiers
- embeddings / live-audio surfaces
- preview/non-Pro fast paths unless the user explicitly overrides

Reasoning/thinking guidance:

- Gemini 3.1 Pro uses `thinkingLevel`, not `thinkingBudget`
- Gemini 3.1 Pro defaults to dynamic `"high"` thinking and does not support a true no-thinking mode
- Gemini 2.5 Pro uses `thinkingBudget`, not `thinkingLevel`
- Gemini 2.5 Pro defaults to dynamic thinking and cannot disable thinking
- if Arctic exposes explicit Google thinking controls after login, prefer:
  - Gemini 3.1 Pro: `thinkingLevel=high` for hard reasoning work, `thinkingLevel=low` only for lighter comparison runs
  - Gemini 2.5 Pro: `thinkingBudget=-1` for dynamic/default, or a high manual budget for difficult reasoning
- if Arctic does not expose those controls, do not fake a reasoning-effort layer; record the absence and route based on model class instead

Current execution truth:

- `google-main` is execution-verified on `google/gemini-3.1-pro-preview`
- automatic routing should pin `google-main` to `gemini-3.1-pro-preview` unless a different Google runtime model is separately execution-verified

## Arctic `github-copilot` Slots

Use only the operator-approved Copilot allowlist plus execution verification.

Operator-approved allowlist, in descending order:

1. `gpt-5.4`
2. `claude-opus-4.6`
3. `claude-opus-4.5`
4. `gpt-5.4-mini`
5. `gpt-5.3-codex`
6. `gemini-3.1-pro-preview`
7. `gemini-3-pro-preview`
8. `gemini-2.5-pro`
9. `claude-sonnet-4.6`
10. `claude-sonnet-4.5`

Important truth:

- `gemini-2.1-pro` is not locally visible in either Copilot slot on this machine
- the nearest currently visible Pro-tier Gemini candidate is `gemini-2.5-pro`
- both currently authenticated Copilot slots expose the same visible model list

Do not auto-route outside the allowlist:

- `gpt-5`
- `gpt-5.1`
- `gpt-5.1-codex`
- `gpt-5.1-codex-max`
- `gpt-5.1-codex-mini`
- `gpt-5-mini`
- `gpt-4.1`
- `gpt-4o`
- `claude-sonnet-4`
- `claude-opus-41`
- `claude-haiku-4.5`
- `gemini-3-flash-preview`
- `grok-code-fast-1`

Copilot-specific note:

- both currently authenticated Copilot slots expose the same visible model list
- visible `github-copilot/gpt-5.4` currently fails runtime smoke with `model_not_supported`
- `github-copilot/gemini-3.1-pro-preview` is execution-verified on both Copilot slots
- `github-copilot/gpt-4.1` is also execution-verified on `copilot-raed2180416`
- only promote Copilot models that are both in the allowlist and have separately passed runtime smoke, not merely those that appear in the visible model list
- automatic routing should pin Copilot alternates to a slot's execution-verified model, not to a higher visible but unverified tier

## Required Verification After Login

For every authenticated slot:

1. `bash audit-map/16-scripts/arctic-slot-models.sh --slot <slot> --refresh`
2. save the output under `18-snapshots/accounts/<slot>/`
3. compare the visible list against this preference file
4. record any drift in `14-reconciliation/contradiction-matrix.md`
