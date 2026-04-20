# Arctic VS Code On NixOS Runbook

- Launch Arctic from an integrated terminal that inherited the login shell.
- If VS Code cannot see `arctic`, confirm `~/.npm-global/bin` remains in `PATH`.
- Prefer workspace tasks or the `audit-map/16-scripts/arctic-*.sh` wrappers over raw manual switching commands.
- For multi-account login on this machine, prefer the `Audit: Arctic slot login plan` task or `arctic-slot-login.sh`, not repeated global `arctic auth login` calls.
