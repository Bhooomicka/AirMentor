# Stage 01B - Proof Count Parity And Provenance

Hard stop: do not start unless `stage-01a-section-scope-contract.md` is marked passed in the execution ledger, its artifacts are present in the evidence manifest/index, and no unresolved blocker tagged to `01A` remains open in the defect register.

Operational rule: run every non-trivial verify/build/deploy command through `bash scripts/run-detached.sh <job-name> <command...>`, deploy the current frontend/backend before live proof, and carry forward the lessons in `docs/closeout/operational-execution-rules.md` before continuing.


## Goal
- Make proof-scoped counts authoritative whenever an active proof run or active operational semester exists.
- Expose count provenance and scope provenance in backend payloads and frontend states.

## Repo Truth Anchors
- `docs/closeout/final-authoritative-plan.md` calls out mixed proof/institution totals as a current problem.
- `src/api/types.ts` resolved policy and proof-facing types do not yet expose `scopeDescriptor`, `resolvedFrom`, `scopeMode`, `countSource`, or `activeOperationalSemester`.
- `src/system-admin-live-app.tsx`, faculty profile proof views, HoD analytics, risk explorer, and student shell already surface proof metrics that later stages will align.
- No-mock-data behavior is already expected on proof-scoped surfaces.

## Inputs Required From Previous Stage
- `01A` ledger row
- section-scope contract proof

## Allowed Change Surface
- proof-facing API payloads
- resolved policy/stage-policy payloads
- frontend surfaces that display counts and scope context
- targeted tests and live proof scripts

## Ordered Implementation Tasks
### backend
- Extend resolved policy, stage policy, and proof-facing payloads with:
  - `scopeDescriptor`
  - `resolvedFrom`
  - `scopeMode`
  - `countSource`
  - `activeOperationalSemester`
- Make proof-scoped counts default when the viewer is inside an active proof context.
- Replace fabricated fallback counts with explicit unavailable states.

### frontend
- Render provenance and scope metadata wherever proof counts are shown.
- Remove or rewrite any UI that silently mixes proof totals with institutional totals.
- Ensure clickable count cards open the exact filtered list they summarize.

### tests
- Add backend tests proving proof-vs-global provenance.
- Add frontend parity tests for:
  - sysadmin overview counts
  - teacher proof panel counts
  - HoD totals
  - risk explorer and student shell scope messaging

### evidence
- Update the assertion matrix and coverage matrix with provenance-bearing payload references.
- Record before/after count behavior in the evidence index.

### non-goals
- Do not move editors between workspaces in this stage.
- Do not implement semester activation in this stage.

## Modularity Constraints
- Keep count-derivation logic in reusable selectors/services, not inline card components.
- Proof provenance formatting should be shared across proof-aware surfaces instead of duplicated five times.

## Required Proof Before Exit
- Proof context no longer shows mixed institutional totals.
- Public payloads expose the required provenance fields.
- Missing data is rendered as unavailable, never invented.

## Commands And Expected Artifacts
| Command | Expected Artifacts | Pass Signal |
| --- | --- | --- |
| `npm run verify:proof-closure:proof-rc` | repo-local proof screenshots and test output; ledger reference | proof bar stays green after count/provenance changes |
| `npm test -- --run tests/faculty-profile-proof.test.tsx tests/hod-pages.test.ts tests/risk-explorer.test.tsx tests/student-shell.test.tsx` | frontend parity test output; ledger reference | proof-facing UI contracts stay green |
| `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> npm run verify:proof-closure:live` | `system-admin-proof-control-plane.png`, `teacher-proof-panel.png`, `teacher-risk-explorer-proof.png`, `hod-proof-analytics.png`, `hod-risk-explorer-proof.png`, `student-shell-proof.png` | live proof surfaces show aligned proof-scoped metrics |
| `PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:teaching-parity` | `system-admin-teaching-parity-smoke.png` | teaching views remain aligned after provenance changes |

## Regression Watchlist
- Old overview cards still showing seeded institutional totals
- HoD totals or teacher counts showing `240` while proof cohort is `120`
- Provenance fields present in API but ignored in UI

## Blockers That Stop The Next Stage
- Any proof surface still showing mixed totals
- Any missing provenance field in public contracts
- Any proof-closure regression locally or live

## Exit Contract
- Stage `01B` is `passed` only when proof-scoped totals are authoritative, provenance is visible, and no proof-facing surface fabricates missing data.

## Handoff Update Required In Ledger
- `stageId: 01B`
- provenance fields added
- proof count parity proof results
- local and live proof artifact references
