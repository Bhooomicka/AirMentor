# Stage 08C - Live Closeout Proof Pack Completion

Hard stop: do not start unless `stage-08b-role-e2e-hod-student-session-security.md` is marked passed in the execution ledger, its artifacts are present in the evidence manifest/index, and no unresolved blocker tagged to `08B` remains open in the defect register.

Operational rule: run every non-trivial verify/build/deploy command through `bash scripts/run-detached.sh <job-name> <command...>`, deploy the current frontend/backend before live proof, and carry forward the lessons in `docs/closeout/operational-execution-rules.md` before continuing.


## Goal
- Complete the final closeout proof pack with a full local and live verification sweep, a three-pass self-audit, and fully updated coverage and assertion documents.

## Repo Truth Anchors
- `scripts/verify-final-closeout.sh` already runs the local closeout verification chain.
- `scripts/verify-final-closeout-live.sh` already runs the live closeout verification chain, including Railway deploy preflight when context is available and the cross-origin session contract.
- `docs/closeout/assertion-traceability-matrix.md` maps authoritative claims to proof commands and pass criteria.
- `docs/closeout/sysadmin-teaching-proof-coverage-matrix.md` maps sysadmin, teaching-profile, and negative-path coverage to owners, routes, commands, and artifacts.
- `docs/closeout/stage-gate-protocol.md` already defines the execution ledger, evidence manifest/index, and defect-register requirements.

## Inputs Required From Previous Stage
- `08B` ledger row
- all local and live role-path artifacts
- fully updated assertion and coverage matrices up to `08B`

## Allowed Change Surface
- `docs/closeout/*.md`
- evidence manifest/index files under `output/playwright/`
- narrowly scoped verification scripts only if the proof pack is missing an explicit artifact or pass/fail signal

## Ordered Implementation Tasks
### backend
- Run the full backend-inclusive closeout verification chain and fix only blocking issues proven by the owned commands.
- Preserve all public contracts and startup/session safeguards introduced in earlier stages.

### frontend
- Run the full frontend-inclusive closeout verification chain and fix only blocking issues proven by the owned commands.
- Keep any final fixes in the owning extracted workspace or helper.

### tests
- Execute the full local closeout suite.
- Execute the full live closeout suite on GitHub Pages plus Railway.
- Complete the three-pass self-audit:
- pass 1: authoritative-plan claim coverage
- pass 2: current repo/test/script crosswalk
- pass 3: full sysadmin plus teaching-profile functionality coverage, including HoD, mentor, risk explorer, student shell, denied paths, session/CSRF/origin behavior, and deployed verification

### evidence
- Ensure the execution ledger, evidence manifest, evidence index, and defect register are complete and internally consistent.
- Update `assertion-traceability-matrix.md` and `sysadmin-teaching-proof-coverage-matrix.md` with final commands, artifacts, and owning stages.
- Produce the final local and live artifact bundle references in one closeout ledger entry.

### non-goals
- Do not reopen already passed stages without recording a new blocker and its evidence.
- Do not hand-wave missing artifacts, screenshots, or JSON outputs.

## Modularity Constraints
- Final fixes still belong in the owning modules surfaced by the failed proof command.
- Do not use this stage to dump unrelated logic into root files because the finish line is close.

## Required Proof Before Exit
- Full local closeout verification passes.
- Full live closeout verification passes.
- The three-pass self-audit confirms that every authoritative claim and every sysadmin or teaching-profile-reachable functionality is mapped to proof.
- The prompt pack documents, ledger, and evidence artifacts all agree.

## Commands And Expected Artifacts
| Command | Expected Artifacts | Pass Signal |
| --- | --- | --- |
| `npm run verify:final-closeout` | full local artifact set under `output/playwright/`; ledger reference | full local closeout suite passes |
| `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> npm run verify:final-closeout:live` | full live artifact set plus live session-contract output; ledger reference | full live closeout suite passes |
| `npm run lint` | lint output; ledger reference | no closeout-pack or source regressions |
| `npm run inventory:compat-routes -- --assert-runtime-clean` | runtime-route inventory output; ledger reference | runtime compatibility inventory is clean |

## Regression Watchlist
- Final suite passing locally while live artifacts remain incomplete or inconsistent
- Assertion or coverage matrices drifting from the actual commands and artifacts produced
- Unlogged blocker fixes applied during final sweep

## Blockers That Stop The Next Stage
- Any failing local or live closeout command
- Any authoritative-plan claim missing from the assertion matrix
- Any sysadmin, teaching-profile, or negative-path coverage row missing from the coverage matrix
- Any evidence-manifest, ledger, or defect-register inconsistency

## Exit Contract
- Stage `08C` is `passed` only when the complete local and live closeout suites pass, the three-pass self-audit is done, and the full proof pack is internally consistent.

## Handoff Update Required In Ledger
- `stageId: 08C`
- final local suite result
- final live suite result
- three-pass self-audit completion note
- final artifact bundle references
