# OpenCode Alternative Runbook

Use this only if Arctic proves too thin for real multi-provider workflow control.

## Verified Baseline

- `nix shell nixpkgs#opencode --command opencode --help` succeeded
- nix package name: `opencode`
- nix version observed: `1.4.0`
- repo flake dev shell currently resolves `opencode --version` to `1.2.24`

## Use Cases

- alternative multi-provider coding workflow
- explicit session continuation and forking
- separate cost and session telemetry from native Codex

## Recommended Posture

- do not replace native Codex for the main audit flow by default
- treat OpenCode as a fallback or comparison workflow layer
- keep its session and provider state documented separately if you start using it
