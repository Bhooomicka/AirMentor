# Known Facts

- Repo root: `/home/raed/projects/air-mentor-ui`
- The root workspace uses npm workspaces with `air-mentor-api` as a child workspace.
- The repository contains `.github/workflows/ci-verification.yml`, `.github/workflows/deploy-pages.yml`, `.github/workflows/deploy-railway-api.yml`, `.github/workflows/proof-browser-cadence.yml`, and `.github/workflows/verify-live-closeout.yml`.
- Frontend scripts include `dev`, `build`, `test`, and multiple Playwright live-verification scripts.
- Backend scripts include `dev`, `build`, `test`, `db:migrate`, `db:seed`, and proof-risk evaluation.
- Backend tests use `embedded-postgres`.
- Optional ML helper dependencies are `spacy==3.7.5` and `sentence-transformers==3.0.1`.
- The frontend tree contains both `src/data.ts` and `src/data.old.ts`.
- The backend tree contains `air-mentor-api/scripts/curriculum_linkage_nlp.py`.
- Frontend routing is hash-based at the portal level: `#/` is the chooser, `#/app` is the academic portal, and `#/admin` is the sysadmin portal; academic workspace pages are internal state, while sysadmin deep links extend through `students`, `faculty-members`, `requests`, and the proof-scoped `faculties/.../batches/...` hierarchy.
- Verified live URLs documented repeatedly in repo docs:
  - Pages: `https://raed2180416.github.io/AirMentor/`
  - Railway: `https://api-production-ab72.up.railway.app/`
- Verified local Codex models on this machine:
  - `gpt-5.4`
  - `gpt-5.4-mini`
  - `gpt-5.3-codex`
  - `gpt-5.2`
- `tmux` is installed and usable.
- Arctic CLI version `0.0.0-main-202603151831` is installed in `~/.npm-global/bin/arctic`.
- Project-level Arctic config now exists in `.arctic/arctic.json` and limits provider discovery to `codex`, `google`, and `github-copilot`.
- Multi-account Arctic handling on this machine is implemented through isolated per-slot `XDG_DATA_HOME` / `XDG_CONFIG_HOME` stores.
- All six Arctic `codex-*` slots are now execution-verified on `codex/gpt-5.3-codex`.
- Both Arctic GitHub Copilot slots are execution-verified on `github-copilot/gemini-3.1-pro-preview`, and `copilot-raed2180416` is also verified on `github-copilot/gpt-4.1`.
- `task-classify-route.sh` marks `account-routing-pass`, `ml-audit-pass`, `live-behavior-pass`, and `synthesis-pass` as `provider_admission_policy=native-only`.
- `select-execution-route.sh` now pins non-native automatic routes to the slot execution-verified model instead of promoting to a higher merely visible model on that provider.
- Caveman global skills are installed under `~/.agents/skills/`.
- OpenCode is available as an optional alternative workflow layer through Nix.
- Route parser coverage was verified locally on 2026-04-15 via `tests/portal-routing.test.ts` and `tests/proof-pilot.test.ts`.
- The current feature registry carries 24 feature-atom files plus 1 cross-surface microinteraction row (25 rows total in `audit-map/15-final-maps/feature-registry.md`).
- The dependency layer now has a v2.0 map covering portal hash routing, academic session bootstrap, route sync, proof playback selection, student-shell access, sysadmin proof scope, admin request transitions, admin search scope, runtime shadow state, and backend session/CSRF config.
- The academic proof playback selection key is shared across the academic bootstrap path and the sysadmin proof dashboard, so a stale checkpoint can pin both surfaces until it is cleared.
- Academic session role switching is session-backed: `POST /api/session/role-context` switches only among the current session's active grants, and login initially selects the highest-priority active grant.
- The teaching workspace role switcher is driven by bootstrap-derived `allowedRoles`, and the academic UI excludes `SYSTEM_ADMIN` from that switcher.
- The academic faculty-profile surface is self-access for the same faculty, with HoD/admin access only when the backend overlap checks pass.
- The academic runtime shadow-state layer persists tasks, drafts, cell values, locks, timetable templates, task placements, and calendar audit data through dedicated runtime keys and compatibility routes.
- The student-shell and risk-explorer routes are indirect drilldown surfaces that remain available to academic roles and `SYSTEM_ADMIN`, but the message/session APIs still enforce active-run and student-scope checks.
- The teaching portal homes resolve to `dashboard` for Course Leader, `mentees` for Mentor, and `department` for HoD; the shared drilldown pages are `student-history`, `student-shell`, `risk-explorer`, `queue-history`, and `faculty-profile`.
- `src/system-admin-request-workspace.tsx` exposes only the status-driven `Take Review` / `Approve` / `Mark Implemented` / `Close` control path, while `air-mentor-api/src/modules/admin-requests.ts` still supports `Needs Info` and `Rejected` transitions.
- The HoD `unlock-review` page is a separate academic unlock workflow, not the sysadmin admin-request queue.
- The UX friction ledger now records the highest-density operator surfaces as the sysadmin request/proof/hierarchy stack, the course TT builder, the calendar/timetable planner, and the mentor/HoD/risk-explorer/student-shell drilldowns.
- The system-admin history archive/recycle-bin restore workflow is comparatively low friction and is scoped narrowly to restore and audit activity.
- The main proof-risk trained artifact family uses feature schema `observable-risk-features-v3`, production model version `observable-risk-logit-v5`, challenger version `observable-risk-stump-v4`, correlation artifact version `observable-risk-correlations-v4`, calibration version `post-hoc-calibration-v1`, and manifest version `proof-corpus-v1`.
- Proof-risk head probability display is suppressed unless held-out support and calibration quality clear explicit gates, and `ceRisk` is intentionally band-only.
- Active proof-risk artifacts, challenger artifacts, correlation artifacts, and evaluation JSON are stored in the `riskModelArtifacts` table, while row-level provenance is stored in `riskEvidenceSnapshots`.
- Runtime active recompute can synthesize `fallback-simulated` source refs and still score through the trained-risk path when checkpoint evidence is incomplete.
- `deriveScenarioRiskHeads()` produces advisory SGPA-drop, CGPA-drop, and elective-mismatch heads from trained overall risk and pressure terms; these are explicitly not separate trained models.
- Academic proof surfaces reuse the active proof model through `computeRiskFromActiveModelOrPolicy()`.
- Curriculum linkage candidate generation reports provider status such as `python-nlp` or `typescript-fallback`, prefers deterministic matches first, and can optionally use `sentence-transformers` and local Ollama assist.
- `air-mentor-api/src/app.ts` and `air-mentor-api/railway.json` still define `/health` as the expected Railway health endpoint.
- Root-workspace `npx vitest run ...` uses the frontend config include (`tests/**/*.test.ts(x)` only); backend workspace suites such as `air-mentor-api/tests/gap-closure-intent.test.ts` and `air-mentor-api/tests/academic-bootstrap-routes.test.ts` must be run from `air-mentor-api/` or through backend workspace script entrypoints.
- A focused 2026-04-20 gap-closure validation rerun confirmed:
  - `tests/domain.test.ts`, `tests/calendar-utils.test.ts`, and `tests/academic-session-shell.test.tsx` all pass locally with explicit proof-virtual-date anchor coverage for GAP-7.
  - `air-mentor-api/tests/academic-bootstrap-routes.test.ts` plus the GAP-5-filtered subset of `air-mentor-api/tests/gap-closure-intent.test.ts` pass locally after updating the route test mock to satisfy the active-run gate.
  - The full embedded-Postgres integration portion of `air-mentor-api/tests/gap-closure-intent.test.ts` remains sandbox-blocked by `listen EPERM: operation not permitted 127.0.0.1`.
- `scripts/verify-final-closeout-live.sh` requires `PLAYWRIGHT_APP_URL`, `PLAYWRIGHT_API_URL`, and explicit `AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER` plus `AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD`; in live mode it does not fall back to seeded local credentials.
- GitHub Pages root and `#/admin` were re-observed on 2026-04-15 via `web.open` and still resolve to the `air-mentor-ui` HTML shell at the document level.
- A direct 2026-04-16 session-contract preflight re-proved that the current shell has no live admin credentials available: `npm --workspace air-mentor-api run verify:live-session-contract` fails immediately on missing `AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER` when the documented live Pages and Railway URLs are supplied.
- A direct 2026-04-16 Playwright MCP probe to `https://raed2180416.github.io/AirMentor/` still returned `user cancelled MCP tool call`, so the current shell cannot refresh browser-rendered live evidence through the MCP browser path.
- A direct 2026-04-16T18:21Z shell env check re-proved that the current shell still has none of the required live vars exported: `PLAYWRIGHT_APP_URL`, `PLAYWRIGHT_API_URL`, `AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER`, `AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD`, and `AIRMENTOR_LIVE_TEACHER_IDENTIFIER` were all unset.
- A direct 2026-04-16T18:21Z shell transport check re-proved that this shell still cannot resolve the live hosts directly: Node fetch to Pages root, Railway `/health`, and Railway session login all failed with `getaddrinfo EBUSY`.
- `audit-map/29-status/audit-air-mentor-ui-live-live-credentialed-parity-pass.status` and the paired checkpoint regressed again at `2026-04-16T18:17:46Z` to a stale `running` state with `pid=1431641` / `execution_supervisor_pid=1432544`, but `ps` found no matching processes; the pass was manually reconciled back to terminal blocked truth at `2026-04-16T18:21:12Z`.
- `scripts/system-admin-proof-risk-smoke.mjs` is not a read-only live observer: it can create proof imports, validate/review/approve them, recompute risk, create proof runs, and activate semesters before collecting proof screenshots.
- `scripts/system-admin-teaching-parity-smoke.mjs` is not a read-only live observer: it patches faculty profile and appointment state and does not prove a full restore path inside the same run.
- The current live academic helper chain implies one multi-grant faculty identity rather than separate `COURSE_LEADER`, `MENTOR`, and `HOD` credentials: the scripts perform a single academic login and then role-switch inside that session.
- No separate student live credential path was found in the current parity helper chain; student shell evidence is reached through teacher or HoD drilldown actions.

## Script Behavior Facts

- `script-behavior-pass` is durably mapped in `audit-map/32-reports/script-behavior-registry.md` and now covers live auth credential helpers, live Playwright wrappers, Railway readiness/recovery, parity-seed generation, seeded runtime harnesses, proof-risk evaluation harnesses, detached execution, and closeout evidence promotion.
- `scripts/system-admin-live-auth.mjs` is a read-only env resolver for `AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER` and `AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD`.
- `scripts/teaching-password-resolution.mjs` probes `POST /api/session/login` with candidate passwords and an origin header; it is read-only with respect to product data but still exercises the live auth/session surface.
- `scripts/check-railway-deploy-readiness.mjs` can sync Railway service vars when `SYNC_RAILWAY_SERVICE_VARS=1` and writes JSON diagnostics under `output/`.
- `scripts/verify-final-closeout-live.sh` requires `PLAYWRIGHT_APP_URL`, `PLAYWRIGHT_API_URL`, and live admin credentials; it does not fall back to seeded local credentials in live mode.
- `scripts/run-detached.sh` launches jobs via tmux or nohup and writes wrapper, log, and pid files.
- `scripts/closeout-stage-*.mjs` and `scripts/finalize-stage-*-after-session.sh` rewrite ledgers, manifests, indexes, assertion matrices, defect registers, coverage matrices, and stage docs after detached completion.
- `scripts/snapshot-final-closeout-artifacts.mjs` copies stage-scoped artifacts into prefixed bundles and writes bundle metadata.
- `air-mentor-api/scripts/generate-academic-parity-seed.ts` writes `air-mentor-api/src/db/seeds/platform.seed.json`.
- `air-mentor-api/scripts/start-seeded-server.ts` starts embedded Postgres, runs migrations and seed, and emits a readiness payload for the seeded API.
- `air-mentor-api/scripts/run-vitest-suite.mjs` excludes proof-rc files by default unless `AIRMENTOR_BACKEND_SUITE=proof-rc`.
- `air-mentor-api/scripts/evaluate-proof-risk-model.ts` writes proof-risk JSON and Markdown reports under `air-mentor-api/output/proof-risk-model/`.
- `air-mentor-api/scripts/curriculum_linkage_nlp.py` can degrade from spaCy/embedding/Ollama paths and still emit JSON, so deployment dependency posture must be verified separately.

## Backend Provenance Facts

- `air-mentor-api/src/db/migrate.ts` applies migrations in lexical filename order and records applied filenames in `schema_migrations`.
- `seedDatabase()` / `seedIntoDatabase()` is a destructive reset-and-replay boundary: broad auth, academic, and proof-runtime tables are deleted before `platform.seed.json` is replayed and the MSRUAS proof sandbox is rebuilt.
- `rebuildSimulationStagePlayback(...)` resets only checkpoint-scoped artifacts, then rebuilds checkpoints, stage summaries, student/offering/queue projections, queue cases, and checkpoint-bound `riskEvidenceSnapshots`.
- `rebuildProofRiskArtifacts(...)` is batch-scoped governed-corpus regeneration, not current-run-only retraining: active artifact rows are replaced for the batch and persist `sourceRunIdsJson`.
- `publishOperationalProjection(...)` is the active-run mirror writer that rewrites transcript and proof attendance/assessment mirrors and refreshes active risk/alert/elective timestamps from the selected active run.
- Default faculty, HoD, and student proof slices can be checkpoint-backed while still labeled `countSource=proof-run` when the activated semester context diverges or active-risk rows are absent.

## Deterministic Remediation Facts (2026-04-16)

- Runtime and playback governance paths now fail fast when policy comparison returns an invalid action catalog candidate or recommendation.
- The canonical action-policy diagnostics currently rely on the `policy-action-catalog-v1` stage/phenotype mapping and emit `actionCatalog` metadata for downstream consumers.
- Targeted deterministic proof/parity regression verification is more reliable with direct `npx vitest run <file>` invocations than `npm --workspace air-mentor-api test -- <file>` wrappers, which can fan out wider than expected.
- Local deterministic verification for this remediation wave is captured in `audit-map/17-artifacts/local/2026-04-16T2054Z--deterministic-proof-remediation--local--test-evidence.md` with passing suites (`3/3`, `4/4`, `7/7`, `5/5`) and clean edited-file diagnostics.
- A direct 2026-04-18T00:23:43Z control-plane snapshot re-proved that `audit-map/31-queues/pending.queue` is not empty: it still held 17 entries beginning with `truth-drift-reconciliation-pass`, while the older `audit-map/32-reports/current-run-status.md` still claimed the queue was empty and the pipeline was finished.
- The current 2026-04-18 status/checkpoint truth no longer reproduces the earlier supervisor-drift findings for `frontend-long-tail-pass`, `live-credentialed-parity-pass`, `unknown-omission-pass`, or `same-student-cross-surface-parity-pass`: each now shows terminal `completed` state with checkpoint `last_event=completed`, and the current status files no longer carry the earlier `watching` supervisor restamps.
- `audit-map/20-prompts/prompt-index.md`, `audit-map/20-prompts/prompt-version-history.md`, and `audit-map/20-prompts/prompt-change-log.md` are coherent on 2026-04-18: default prompt version is `v5.4`, and the Prompt `0-14` expansion plus the six new deep-integrity passes are consistently recorded across all three files.
- A direct 2026-04-18T00:45:56Z control-plane snapshot re-proved that the queue still held the same 17 entries beginning with `truth-drift-reconciliation-pass`, and that the current control-plane wave restarted `night-run-orchestrator` at `2026-04-18T00:40:27Z`, `usage-refresh-orchestrator` at `2026-04-18T00:40:26Z`, and `truth-drift-reconciliation-pass` at `2026-04-18T00:40:31Z`.
- Direct `tmux ls` and `tmux has-session` probes from this shell returned `error connecting to /run/user/1002/tmux-1002/default (Operation not permitted)` at `2026-04-18T00:45:56Z`, so tmux visibility is currently inaccessible from this shell even while status/checkpoint/log files remain readable.
- The truth-drift pass now has a durable artifact bundle on disk: `audit-map/32-reports/truth-drift-reconciliation-report.md`, `audit-map/32-reports/audit-air-mentor-ui-bootstrap-truth-drift-reconciliation-pass.last-message.md`, and `audit-map/17-artifacts/local/2026-04-18T004556Z--truth-drift-reconciliation--local--findings.json`.

## Contradiction Closure Facts (2026-04-18)

- Superseding local fact for `C-006`: `src/system-admin-request-workspace.tsx` now includes status-gated `Needs Info` and `Reject` actions, and targeted frontend regression `tests/system-admin-request-workspace.test.tsx` passes (`3/3`).
- Superseding local fact for `C-011`: section selector options in `src/system-admin-faculties-workspace.tsx` are batch-metadata-backed from `selectedBatch.sectionLabels`, and `tests/system-admin-faculties-workspace.test.tsx` passes (`10/10`) for canonical-section coverage.
- Superseding local fact for `C-021`: default fallback provenance across faculty / HoD / risk-explorer / student-shell remains checkpoint-explicit (no relabel to `proof-run`) under forced run-vs-batch semester divergence, verified by backend regression `air-mentor-api/tests/risk-explorer.test.ts` (`keeps default proof surfaces checkpoint-explicit when semester pointers diverge`).
