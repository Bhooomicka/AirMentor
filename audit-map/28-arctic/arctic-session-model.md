# Arctic Session Model

Verified from docs and local CLI:

- sessions are project-scoped
- `arctic session list` exists
- `arctic session fork <session-id>` exists
- `arctic run --continue` exists
- `arctic stats --json` exists and currently reports zero usage

Version-specific discrepancy:

- Docs page reported auth under `~/.config/arctic/auth.json`
- Installed CLI reported credentials file under `~/.local/share/arctic/auth.json`

Treat the CLI output as authoritative for this installed build until a successful login proves otherwise.

Local slot-isolation strategy:

- global Arctic auth is not used for repeated providers
- each account slot runs Arctic with isolated `XDG_DATA_HOME` and `XDG_CONFIG_HOME`
- example slot paths:
  - `~/.local/share/air-mentor-audit/arctic-slots/codex-01/data/arctic/auth.json`
  - `~/.config/air-mentor-audit/arctic-slots/codex-01/config/`

This keeps account continuity and rate limits isolated even though the local CLI does not expose named multi-account syntax.
