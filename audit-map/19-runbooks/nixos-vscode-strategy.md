# NixOS VS Code Strategy

- Keep the terminal on a login shell; `.vscode/settings.json` already uses `zsh -l`.
- Run heavyweight commands inside `nix develop` to inherit Playwright, Python, and Node from `flake.nix`.
- Prefer workspace tasks that call `bash audit-map/16-scripts/...` instead of ad hoc integrated-terminal commands.
- If a VS Code window closes, resume from `tmux`, not from editor history.
