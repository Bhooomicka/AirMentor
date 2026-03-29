# Stage 00B - Evidence Ledger And Assertion Backbone

Hard stop: do not start unless `stage-00a-pilot-freeze-and-boundaries.md` is marked passed in the execution ledger, its artifacts are present in the evidence manifest/index, and no unresolved blocker tagged to `00A` remains open in the defect register.

Operational rule: run every non-trivial verify/build/deploy command through `bash scripts/run-detached.sh <job-name> <command...>`, deploy the current frontend/backend before live proof, and carry forward the lessons in `docs/closeout/operational-execution-rules.md` before continuing.


## Goal
- Create the handoff backbone required before product implementation:
  - execution ledger
  - evidence manifest
  - evidence index
  - defect register
  - missing closeout support-doc tasks called out by the authoritative plan
- Translate the authoritative plan into assertion-bearing work items before code changes begin.

## Repo Truth Anchors
- `docs/closeout/final-authoritative-plan.md` names deliverables that are still absent from the repo:
  - `final-authoritative-plan-security-observability-annex.md`
  - `deploy-env-contract.md`
  - `operational-event-taxonomy.md`
  - evidence artifacts under `output/playwright/`
- `audit/43-manual-closeout-checklist.md` defines the current human-run closeout boundary.
- `scripts/check-railway-deploy-readiness.mjs` and live session-security scripts provide the existing deploy/session proof path.

## Inputs Required From Previous Stage
- `00A` ledger row
- baseline local and live closeout artifacts

## Allowed Change Surface
- `docs/closeout/`
- `output/playwright/`
- no product code changes in this stage

## Ordered Implementation Tasks
### backend
- Do not edit backend code.
- Extract backend-facing documentation tasks for:
  - build metadata exposure
  - session contract verification
  - telemetry/audit taxonomy

### frontend
- Do not edit frontend code.
- Extract frontend-facing documentation tasks for:
  - proof shell evidence capture
  - theme/motion verification
  - proof-scoped count provenance display

### tests
- Confirm the current live session contract path is wired:
  - `RAILWAY_PUBLIC_API_URL=<railway-url> EXPECTED_FRONTEND_ORIGIN=<pages-origin> AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> npm --workspace air-mentor-api run verify:live-session-contract`
- Confirm the current proof smoke path is wired:
  - `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> npm run verify:proof-closure:live`

### evidence
- Create or normalize:
  - `output/playwright/execution-ledger.jsonl`
  - `output/playwright/proof-evidence-manifest.json`
  - `output/playwright/proof-evidence-index.md`
  - `output/playwright/defect-register.json`
- Seed these files with the baseline artifacts from `00A`.
- Add explicit TODO references for the missing annex/support docs so later stages cannot ignore them.

### non-goals
- Do not implement build metadata, telemetry taxonomy, or new proof commands yet.
- Do not accept undocumented proof artifacts.

## Modularity Constraints
- Centralize the proof contract here. Later stages must reference this backbone instead of inventing stage-specific ledger formats.
- Keep this stage documentation-only. No product code is allowed.

## Required Proof Before Exit
- Ledger, manifest, evidence index, and defect register all exist and are non-empty.
- Missing closeout support-doc tasks are explicitly tracked in the prompt pack.
- Live session contract and proof-closure entrypoints are referenced in the backbone without ambiguity.

## Commands And Expected Artifacts
| Command | Expected Artifacts | Pass Signal |
| --- | --- | --- |
| `RAILWAY_PUBLIC_API_URL=<railway-url> EXPECTED_FRONTEND_ORIGIN=<pages-origin> AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> npm --workspace air-mentor-api run verify:live-session-contract` | live session contract output; ledger reference | session cookie, CSRF contract, and origin posture verify |
| `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> npm run verify:proof-closure:live` | proof screenshots and live proof outputs; ledger reference | proof surfaces load on deployed stack |
| `npm run verify:final-closeout` | local closeout artifacts; ledger reference | local closeout remains green after backbone creation |

## Regression Watchlist
- Ad-hoc evidence file names that do not reconcile with the manifest/index
- Ledger entries without artifact references
- Support-doc deliverables left implicit

## Blockers That Stop The Next Stage
- Missing backbone files
- Empty manifest/index/ledger/register
- Missing references to the absent annex/support docs

## Exit Contract
- Stage `00B` is `passed` only when the evidence backbone exists, is populated, and is referenced by the pack index and both matrices.

## Handoff Update Required In Ledger
- `stageId: 00B`
- created artifact files
- baseline live session contract result
- baseline live proof result
- tracked missing-doc tasks for the annex/env/taxonomy deliverables
