# Stage 00A - Pilot Freeze And Boundaries

Hard stop: do not start unless this is the first stage in the sequence or a prior failed attempt has been recorded in the execution ledger with a resolved blocker disposition.

Operational rule: run every non-trivial verify/build/deploy command through `bash scripts/run-detached.sh <job-name> <command...>`, deploy the current frontend/backend before live proof, and carry forward the lessons in `docs/closeout/operational-execution-rules.md` before continuing.


## Goal
- Freeze the closeout program to the authoritative pilot slice:
  - `Proof MNC 2023`
  - `120` students
  - sections `A/B`
  - semesters `1..6`
  - one faculty and one HoD operating slice
- Prove that the stage pack starts from current repo truth instead of expanding into later CSE `M/C` work.

## Repo Truth Anchors
- `docs/closeout/final-authoritative-plan.md` is the source of truth and must remain unchanged.
- `scripts/system-admin-proof-risk-smoke.mjs` already encodes the seeded proof batch route for `batch_branch_mnc_btech_2023`.
- `audit/21-feature-inventory-and-traceability-matrix.md` and `audit/41-current-state-reconciliation-and-gap-analysis.md` already describe the current live surface inventory and remaining parity gaps.
- `scripts/verify-final-closeout.sh` and `scripts/verify-final-closeout-live.sh` define the current repo-local and live closeout bars.

## Inputs Required From Previous Stage
- None.

## Allowed Change Surface
- `docs/closeout/`
- `output/playwright/` evidence files if they do not exist yet
- no product code changes in this stage

## Ordered Implementation Tasks
### backend
- Do not edit backend code.
- Record the current backend facts that the rest of the pack must not re-decide:
  - proof sandbox is `1..6`
  - semester activation endpoint does not exist yet
  - mentor assignment is single-record create/patch only

### frontend
- Do not edit frontend code.
- Record the current frontend facts that the rest of the pack must not re-decide:
  - `section` exists as display data but not authoritative scope
  - extracted faculties workspace still contains parity-placeholder blocks
  - proof/admin surfaces already have extracted shells that future stages must prefer

### tests
- Confirm the current route and closeout baseline:
  - `npm run inventory:compat-routes -- --assert-runtime-clean`
  - `npm run verify:final-closeout`

### evidence
- Record the pilot boundary note and the “no CSE `M/C` expansion in this pass” note in the execution ledger.
- Seed the evidence manifest/index with the existing closeout artifact family produced by the baseline commands.

### non-goals
- Do not author new product requirements.
- Do not add new stage files beyond the prompt pack itself.
- Do not change runtime scope, seeds, or pilot totals in product code.

## Modularity Constraints
- This is a documentation-and-evidence freeze stage. If implementation pressure appears here, defer it to later stages instead of sneaking in code changes.
- All later stages must inherit the frozen pilot boundaries from this stage instead of restating them from memory.

## Required Proof Before Exit
- Repo-local closeout bar completes without changing the authoritative plan.
- Compatibility-route inventory stays assert-clean.
- The prompt pack explicitly records the frozen pilot slice and out-of-scope note.

## Commands And Expected Artifacts
| Command | Expected Artifacts | Pass Signal |
| --- | --- | --- |
| `npm run inventory:compat-routes -- --assert-runtime-clean` | compatibility-route inventory output; ledger reference | no first-party runtime callers |
| `npm run verify:final-closeout` | existing local closeout artifacts under `output/playwright/`; ledger reference | repo-local closeout completes cleanly |
| `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> npm run verify:final-closeout:live` | live closeout artifact set; ledger reference | deployed stack is reachable and live closeout passes |

## Regression Watchlist
- Any prompt text that reopens the pilot size, sections, or semester range
- Any stage that assumes semesters `7..8`
- Any stage that treats later CSE expansion as part of this closeout

## Blockers That Stop The Next Stage
- Missing or failing local/live closeout baseline
- Missing pilot boundary note in the ledger
- Missing compatibility-route inventory evidence

## Exit Contract
- Stage `00A` is `passed` only when the pilot slice, boundary note, and baseline proof commands are all recorded in the ledger/manifest/index.

## Handoff Update Required In Ledger
- `stageId: 00A`
- frozen pilot identifiers and scope
- local baseline command results
- live baseline command results
- artifact list referencing current closeout outputs
