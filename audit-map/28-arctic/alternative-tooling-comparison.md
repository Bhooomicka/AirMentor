# Alternative Tooling Comparison

## Summary

For this machine and this mission:

- `Arctic` is still the better specialized layer for multi-plan and multi-account coding-plan juggling around Codex.
- `OpenCode` is the stronger general-purpose multi-provider coding workflow layer.
- `Aider` remains a solid conservative fallback, especially for Git-centric paired editing.

## Practical Ranking For This Audit OS

1. `Arctic` for account/provider continuity around Codex once authenticated
2. `OpenCode` as the best verified alternative workflow layer on NixOS
3. `Aider` as a stable Git-first backup

## Why OpenCode Beats Arctic In General Workflow Terms

- verified available in Nixpkgs on this machine
- verified `opencode --help` through `nix shell nixpkgs#opencode`
- explicit provider, session, export/import, and stats commands
- explicit `--continue`, `--session`, and `--fork` style session controls
- packaged cleanly for NixOS use

## Why Arctic Still Stays In This Audit OS

- it is explicitly positioned around coding-plan usage tracking and account juggling
- it claims Codex-aware support directly
- the mission explicitly requires Arctic investigation and setup

## Current Recommendation

- keep native Codex as the primary execution path
- keep Arctic as the specialized account/provider continuity layer
- keep OpenCode installed through the Nix shell as the verified better alternative if Arctic proves too immature for real switching

## Sources

- Arctic home: `https://www.usearctic.sh/`
- Arctic docs projects/session continuity: `https://www.usearctic.sh/docs/projects`
- OpenCode docs: `https://opencode.ai/docs/`
- OpenCode providers: `https://opencode.ai/docs/providers/`
- OpenCode Zen cost controls: `https://opencode.ai/docs/zen`
- OpenCode Go spend caps: `https://opencode.ai/docs/go/`
- OpenCode Nix package: `https://mynixos.com/nixpkgs/package/opencode`
- Aider docs: `https://aider.chat/`
- Aider OpenRouter/provider docs: `https://aider.chat/docs/llms/openrouter.html`
- Aider caching docs: `https://aider.chat/docs/usage/caching.html`
- Aider Nix package: `https://mynixos.com/nixpkgs/package/aider-chat`
