# Decision Log

| Date | ID | Decision | Reason | Follow-up |
| --- | --- | --- | --- | --- |
| 2026-04-15 | D-001 | Build new audit control plane under `audit-map/` instead of extending `/audit/` directly. | `/audit/` already contains analysis artifacts; the new layer needs resumable workflow state, prompts, and automation. | Cross-link old audit docs from inventory and synthesis passes. |
| 2026-04-15 | D-002 | Use actual local Codex model cache, not assumed marketing names, for automation defaults. | The machine currently exposes `gpt-5.4`, `gpt-5.4-mini`, `gpt-5.3-codex`, and `gpt-5.2`. | Re-run model inventory if `~/.codex/models_cache.json` changes. |
| 2026-04-15 | D-003 | Install Arctic, but treat provider/account switching as guarded until credentials are verified. | CLI works; `arctic auth list` currently shows zero credentials. | Complete auth and update account matrices. |
| 2026-04-15 | D-004 | Install Caveman as global skills only; do not force always-on mode. | Global install succeeded safely; repo-local auto-hooks are blocked by an existing `.codex` file and high-risk reasoning should stay uncompressed. | Revisit only if user approves replacing repo-local `.codex` file. |
| 2026-04-15 | D-005 | Treat live Railway health as unresolved drift. | Bootstrap check observed `404` on `/health` despite repo docs expecting `200`. | Capture fresh live artifacts before trusting deployment assumptions. |
| 2026-04-15 | D-006 | Use isolated Arctic slots for multi-account handling. | The installed Arctic CLI on this machine does not accept the documented `--name` account flag, so shared-store repeated logins are overwrite-risky. | Authenticate the planned slots and verify model visibility per slot. |
