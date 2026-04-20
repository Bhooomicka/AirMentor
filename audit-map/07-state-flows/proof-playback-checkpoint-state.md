# State Flow: Proof Playback and Checkpoint Progression

- Flow name: Proof playback selection persistence, checkpoint restore/invalidate, and active-run polling
- Context or scope: Shared proof playback semantics consumed by academic and sysadmin surfaces; persisted checkpoint selection in local storage; active-run checkpoint gating and fallback behavior.
- Start and precondition states: `auto` checkpoint mode when no persisted selection exists; `restored` mode when persisted key exists; `manual` mode after explicit checkpoint selection.
- Trigger: Proof dashboard open, checkpoint select/reset, active run state refresh, stage-progression action.
- Guards: selected checkpoint must exist in active checkpoint set; stage blocked progression (`stageAdvanceBlocked`) influences next selectable checkpoint; route/scoped batch must match persisted proof context.
- Intermediate states: `checkpoint-selected`, `checkpoint-detail-loading`, `checkpoint-detail-ready`, `blocked-progression`, `playback-restore-banner`, `active-run-view`.
- Async or background transitions: polling while run status is `queued|running`; refresh cycles after create/retry proof run; checkpoint detail fetch on selection.
- Invalid or conflict states: saved checkpoint no longer exists in current scope; stale persisted selection crossing academic/admin context boundaries.
- Error states: checkpoint detail load failure; refresh request failure; degraded proof refresh queueing; restore snapshot failure.
- Restore or re-entry states: read persisted `proof-playback` key on app startup; write selection on manual choose; clear selection on reset; fallback to first checkpoint/default when unavailable.
- Terminal states: stable active run view with no checkpoint override; archived or failed run states handled by dashboard action family.
- Recovery path: invalid persisted checkpoint shows invalidation banner and clears/redirects to active run; blocked progression falls back to nearest valid checkpoint or first available checkpoint.
- Observed drift: known coupling risk remains between persisted checkpoint state and current live scope; no new contradiction beyond existing dependency note.
- Evidence: `src/proof-playback.ts`, `src/proof-pilot.ts`, `src/system-admin-live-app.tsx:2052`, `src/system-admin-live-app.tsx:2510`, `src/system-admin-live-app.tsx:2918`, `src/system-admin-live-app.tsx:2934`, `src/system-admin-live-app.tsx:2949`, `src/system-admin-live-app.tsx:2972`, `src/system-admin-live-app.tsx:4497`, `src/system-admin-live-app.tsx:4507`, `src/App.tsx:3559`, `src/App.tsx:3567`, `tests/proof-playback.test.ts`, `tests/proof-pilot.test.ts`, `tests/system-admin-proof-dashboard-workspace.test.tsx`, `tests/proof-surface-shell.test.tsx`.
- Confidence: High for local and test-backed state machine semantics; medium for live async worker completion behavior.
