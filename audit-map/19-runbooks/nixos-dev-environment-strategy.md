# NixOS Dev Environment Strategy

Verified from `flake.nix`:

- Node 24
- Python 3.11
- `uv`
- Playwright test runtime

Recommended posture:

- Use `nix develop` as the base shell.
- Keep user-level npm installs in `~/.npm-global`, which is already on `PATH`.
- Keep provider CLIs user-scoped, not system-scoped, unless explicitly managed by Nix later.
