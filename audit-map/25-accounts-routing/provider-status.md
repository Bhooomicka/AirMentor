# Provider Status

| Provider path | Status | Notes |
| --- | --- | --- |
| Native Codex | Ready, but auth can still fail at runtime | Logged in via ChatGPT; local model cache verified; recent `role-surface-pass` failure showed native runtime auth must still be treated as a live check, not a static guarantee |
| Arctic provider routing | Authenticated and execution-verified on pinned fallback models | Use isolated slots instead of the global auth store for repeated providers |
| Arctic provider discovery | Verified across requested slots | All requested `codex`, `google`, `github-copilot`, and `antigravity` slots have refreshed visible model lists |
| Arctic `anthropic` | Mapped but provider-unavailable | Slotized as `anthropic-main`, but current Arctic build returns `Provider not found: anthropic`; slot is now explicitly marked `provider-unavailable` and excluded from route-ready rotation |
| Arctic `codex` | Execution-verified at `gpt-5.3-codex` | Six authenticated slots; no model-list drift observed; all six slot status files now record `execution_verification_state=verified` with `execution_model=gpt-5.3-codex`; higher visible Codex tiers are still not separately execution-verified |
| Arctic `google` | Execution-verified | `google-main` authenticated; preferred visible and execution-verified model is `gemini-3.1-pro-preview` |
| Arctic `github-copilot` | Execution-verified on both slots | Two authenticated slots refreshed; current slot status selects `gemini-3.1-pro-preview` as execution model on both Copilot slots |
| Arctic `antigravity` | Partially execution-ready (`4/9` verified) | `antigravity-main`, `-02`, `-03`, and `-04` are verified; `antigravity-05..09` fail execution probes with `Status: 403` / `Verify your account to continue` and are classified `auth-or-entitlement` |
| Caveman | Ready as optional skills | Installed globally; no always-on hook enabled |
| OpenCode | Ready as optional alternative | Verified through Nix; not the primary audit execution path |
