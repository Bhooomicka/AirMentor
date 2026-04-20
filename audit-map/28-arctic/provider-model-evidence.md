# Provider And Model Evidence

This file separates official-source claims from local-machine evidence.

## Official Arctic Sources

Arctic official provider docs:

- Providers page: <https://www.usearctic.sh/docs/providers>
- Projects page: <https://www.usearctic.sh/docs/projects>

Relevant documented claims:

- coding-plan providers include Codex, Gemini CLI, and GitHub Copilot
- multiple accounts per provider are documented with `arctic auth login <provider> --name <account>`
- project-level config is supported through `.arctic/arctic.json`
- provider model filtering is supported through config

## Local Arctic CLI Evidence

Verified on this machine with Arctic `v0.0.0-main-202603151831`:

- `arctic auth login codex` opens a login-method picker
- `arctic auth login google` opens a login-method picker
- `arctic auth login github-copilot` exists in the local provider surface
- `arctic auth login <provider> --name <slot>` is not accepted by this installed CLI surface
- `arctic models --help` locally supports `--refresh` and `--verbose`
- project-level `.arctic/arctic.json` is supported by docs and now configured in this repo

Safe consequence:

- use isolated Arctic slots instead of global multi-account auth

## Official GitHub Copilot Source

GitHub official model comparison:

- <https://docs.github.com/en/copilot/reference/ai-models/model-comparison>

Relevant documented models for deep reasoning and debugging:

- `GPT-5.4`
- `Claude Opus 4.6`
- `Gemini 3.1 Pro`
- `Gemini 2.5 Pro`

Relevant documented models for agentic software development:

- `GPT-5.3-Codex`
- `GPT-5.4 mini`

Policy consequence for this project:

- GitHub Copilot slots should use only the top available models after authenticated slot refresh

## Official OpenAI Source

OpenAI official GPT-5.4 mini and nano launch post:

- <https://openai.com/index/introducing-gpt-5-4-mini-and-nano/>

Relevant documented claims:

- `GPT-5.4 mini` is available in Codex
- `GPT-5.4 nano` is API-only
- benchmark tables use `xhigh` reasoning effort for GPT-5.4 / mini / nano comparisons

Local consequence:

- native Codex on this machine should remain the authoritative path for GPT-5.4 and GPT-5.4 mini routing
- `GPT-5.4 nano` must not be assumed locally because it is not present in the local Codex cache

## Official Google Source

Google official thinking controls documentation:

- <https://ai.google.dev/gemini-api/docs/thinking>

Relevant documented claims:

- Gemini 3.1 Pro uses `thinkingLevel`
- Gemini 3.1 Pro defaults to dynamic `"high"` thinking and does not support disabling thinking
- Gemini 2.5 series uses `thinkingBudget`
- Gemini 2.5 Pro defaults to dynamic thinking and does not support disabling thinking

Local policy consequence:

- if Arctic exposes Google thinking controls after slot login, prefer high/default reasoning for Pro-class audit work
- if Arctic does not expose those controls, route by model class and record the missing control surface

## Local Native Codex Evidence

Verified from the local Codex cache during bootstrap:

- `gpt-5.4`
- `gpt-5.4-mini`
- `gpt-5.3-codex`
- `gpt-5.2`

Verified local reasoning-effort values through the installed Codex CLI:

- `low`
- `medium`
- `high`
- `xhigh`

## Local Arctic Binary Evidence For Google Models

The installed Arctic binary includes Google model identifiers consistent with Pro-class routing:

- `google/gemini-3.1-pro-preview`
- `google/gemini-2.5-pro`

It also includes Flash-class identifiers, which this project should not auto-route to:

- `google/gemini-3-flash-preview`
- `google/gemini-2.5-flash`
- `google/gemini-2.5-flash-lite`
