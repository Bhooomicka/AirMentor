# Stale Findings Watchlist

- Any repo claim that Railway `/health` returns `200` should be treated as stale until re-verified.
- Any routing policy that assumes `GPT-5.4 nano` is locally callable should be treated as stale.
- Any doc or report claim that all Arctic `codex-*` slots still fail execution or remain continuity-only is stale after the 2026-04-15 `gpt-5.3-codex` execution-smoke updates.
- Any Caveman auto-on assumption is stale until the `.codex` file conflict is resolved.
- Any Arctic provider/account switching claim is stale until credentials exist and a switch is verified end-to-end.
- Any route, role, or feature findings produced before prompt suite `v2.0` should be treated as scaffold-level only until the rerun completes.
- Any feature registry claim that the bootstrap scope is "fully mapped" is stale until the v2 registry is treated as the current baseline and the later live/audit-the-audit passes confirm it against runtime truth.
- Any claim that the sysadmin request workspace exposes explicit `Needs Info` or `Rejected` controls should be treated as stale until the UI changes or live verification proves otherwise.
- Any GitHub Pages deployment-drift claim derived from a dirty-worktree build is stale until it is compared against a clean committed Pages-style build.
- Any note that `unattended-run-pass` is still non-terminal or queue-preserved is stale after the authoritative status/checkpoint pair reached `completed` on `2026-04-15T18:41:15Z` / `18:41:16Z`.
- Any queue/status note that the previous `unknown-omission-pass` wrapper is still meaningfully active should be treated as stale unless it is refreshed after `2026-04-16`; the last recorded wrapper state is a stale `running` artifact.
- Any claim that `frontend-long-tail-pass` still lacks a durable artifact is stale after the 2026-04-16 manual rerun that wrote `audit-map/12-frontend-microinteractions/long-tail-interaction-map.md`, the pass last-message file, and the reconciled status/checkpoint pair.
- Any claim that `script-behavior-pass` is non-creditable or missing a durable artifact is stale after the 2026-04-16 `script-behavior-registry.md` / pass last-message reconciliation.
- Any claim that the backend proof provenance, playback-reset, or active-run/helper-service families are only locally partial or merely seeded is stale after the 2026-04-16 backend provenance continuation and final-map/coverage updates.
- Any claim that `audit-map/32-reports/current-run-status.md` still proves an empty queue or a finished pipeline is stale after the 2026-04-18 truth-drift reconciliation refresh.
- Any claim that contradictions `C-012`, `C-016`, `C-020`, or `C-022` are still current open supervisor-drift issues is stale after the 2026-04-18 status/checkpoint recheck unless a newer control-plane snapshot regresses again.
