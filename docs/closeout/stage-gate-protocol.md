# Stage Gate Protocol

This document defines the universal execution contract for every stage prompt in this pack.

## Stage Statuses
- `blocked`: predecessor evidence is missing, a required artifact is missing, or a recorded defect has no disposition.
- `ready-for-implementation`: predecessor evidence is complete and no blocking defect remains open against the incoming stage.
- `ready-for-proof`: implementation changes are complete, but repo-local or live proof has not finished.
- `passed`: repo-local proof, live proof, ledger entry, manifest updates, and defect-register updates are all complete.
- `failed`: a proof command or acceptance check failed. The next stage is forbidden until the failure is resolved or explicitly deferred in the defect register with owner and rationale.

## Execution Discipline
- Run every non-trivial verify, build, proof, and deploy command through `bash scripts/run-detached.sh <job-name> <command...>` so the job survives terminal closure and leaves a durable log in `output/detached/`.
- Do not continue a stage against a stale live stack. After frontend or backend changes that affect live verification, deploy the current surface first and then rerun the required live commands.
- Before rerunning expensive live browser proof, confirm deploy propagation with a cheap deterministic live probe against the exact dependency that changed, such as proof bundle, checkpoint route, or build metadata.
- If the live probe still returns stale, `null`, or inactive proof state, treat that as propagation lag or stale deployment until a direct probe proves otherwise.
- Reuse shared shell primitives only where the target surface actually matches their interaction contract. If a proof surface is intentionally all-visible, do not convert it to tabs just to match neighboring pages unless the stage explicitly changes that behavior and its tests.
- Carry forward the current failure-memory rules from `docs/closeout/operational-execution-rules.md` before continuing into the next stage.
- Shared-contract stages must preserve the surface-specific evidence model. Reuse shared owners where they fit, but do not force every surface into tabs, carousels, or hidden panels unless the stage contract explicitly requires that behavior.
- New jsdom contract tests must respect the repo runtime assumptions. Prefer `createElement` harnesses or explicitly import the React runtime before using JSX so transform mismatches do not masquerade as product regressions.

## Mandatory Files And Artifacts
- `output/playwright/execution-ledger.jsonl`
- `output/playwright/proof-evidence-manifest.json`
- `output/playwright/proof-evidence-index.md`
- `output/playwright/defect-register.json`

If any of these files do not exist when stage execution begins, the current stage must create them before changing product code.

## Recording Discipline
- A stage cannot move to `passed` until `execution-ledger.jsonl`, `proof-evidence-manifest.json`, and `proof-evidence-index.md` are all updated and agree on the stage artifact ids.
- `proof-evidence-manifest.json` must preserve its top-level `artifacts` array and the established artifact-record field shape.
- Negative-path or denied-path findings discovered during a stage must be recorded as first-class artifacts in the same stage and linked from the relevant assertion and coverage documents.
- Do not force every proof-aware surface into the same navigation pattern during shared-shell or shared-UI stages. Stable always-visible control planes can adopt shared owners without being turned into tabs.
- If a stage claims adoption of a shared owner or extracted primitive, the stage tests must assert the owner markers and linkage semantics directly instead of relying only on content assertions.

## Universal Stage Template
Every stage file must contain these headings in this order:
1. `Goal`
2. `Repo Truth Anchors`
3. `Inputs Required From Previous Stage`
4. `Allowed Change Surface`
5. `Ordered Implementation Tasks`
6. `Modularity Constraints`
7. `Required Proof Before Exit`
8. `Commands And Expected Artifacts`
9. `Regression Watchlist`
10. `Blockers That Stop The Next Stage`
11. `Exit Contract`
12. `Handoff Update Required In Ledger`

Inside `Ordered Implementation Tasks`, always split work into:
- `backend`
- `frontend`
- `tests`
- `evidence`
- `non-goals`

## Hard Stop Rule
Every stage file must open with a hard stop sentence in this form:

`Hard stop: do not start unless <previous stage> is marked passed in the execution ledger, its artifacts are present in the evidence manifest/index, and no unresolved blocker tagged to that stage remains open in the defect register.`

## Command Bank
Use these exact commands unless a stage explicitly adds a narrower verifier.

### Repo-local
- `LOCAL-LINT`
  - `npm run lint`
- `LOCAL-COMPAT`
  - `npm run inventory:compat-routes -- --assert-runtime-clean`
- `LOCAL-WEB`
  - `npm test -- --reporter=dot`
- `LOCAL-API`
  - `npm --workspace air-mentor-api test -- --reporter=dot`
- `LOCAL-PROOF`
  - `npm run verify:proof-closure:proof-rc`
- `LOCAL-CLOSEOUT`
  - `npm run verify:final-closeout`

### Live
- `LIVE-CONTRACT`
  - `RAILWAY_PUBLIC_API_URL=<railway-url> EXPECTED_FRONTEND_ORIGIN=<pages-origin> AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> npm --workspace air-mentor-api run verify:live-session-contract`
- `LIVE-PROOF`
  - `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> npm run verify:proof-closure:live`
- `LIVE-ACCEPTANCE`
  - `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:acceptance`
- `LIVE-REQUESTS`
  - `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:request-flow`
- `LIVE-TEACHING`
  - `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:teaching-parity`
- `LIVE-A11Y`
  - `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:accessibility-regression`
- `LIVE-KEYBOARD`
  - `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:keyboard-regression`
- `LIVE-SESSION`
  - `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:session-security`
- `LIVE-CLOSEOUT`
  - `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> npm run verify:final-closeout:live`

## Expected Existing Playwright Evidence
- `output/playwright/system-admin-live-acceptance-report.json`
- `output/playwright/system-admin-live-acceptance.png`
- `output/playwright/system-admin-live-request-flow-report.json`
- `output/playwright/system-admin-live-request-flow.png`
- `output/playwright/system-admin-teaching-parity-smoke.png`
- `output/playwright/system-admin-live-accessibility-report.json`
- `output/playwright/system-admin-live-screen-reader-preflight.md`
- `output/playwright/system-admin-live-accessibility-regression.png`
- `output/playwright/system-admin-live-keyboard-regression-report.json`
- `output/playwright/system-admin-live-keyboard-regression.png`
- `output/playwright/system-admin-live-session-security-report.json`
- `output/playwright/system-admin-proof-control-plane.png`
- `output/playwright/teacher-proof-panel.png`
- `output/playwright/teacher-risk-explorer-proof.png`
- `output/playwright/hod-proof-analytics.png`
- `output/playwright/hod-risk-explorer-proof.png`
- `output/playwright/student-shell-proof.png`

## Ledger Rules
- Append one JSONL record per stage pass and one JSONL record per stage failure.
- Each record must include:
  - `stageId`
  - `status`
  - `authoritativePlanSections`
  - `repoLocalCommands`
  - `liveCommands`
  - `artifacts`
  - `defectsOpened`
  - `defectsClosed`
  - `notes`
- The manifest and evidence index must reference the same artifact set as the ledger entry.

## Defect Register Rules
- Any failed proof command must open or update a defect entry before retry.
- Every deferred defect must include:
  - owner
  - scope
  - blocking or non-blocking classification
  - explicit reason it does or does not block the next stage
- Any failure lesson that would otherwise be rediscovered later must be added to `docs/closeout/operational-execution-rules.md` or an equivalent closeout instruction doc before the next stage starts.

## Modularity Rule
- A stage fails review if it solves the right behavior in the wrong owner.
- Before touching a large integration file, the stage owner must check whether the change belongs in an extracted workspace, route module, or proof-control-plane service first.
