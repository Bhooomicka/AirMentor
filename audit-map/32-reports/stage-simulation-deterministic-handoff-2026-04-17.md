# Stage Simulation Deterministic Handoff (2026-04-17)

## Purpose
This handoff captures the current deterministic simulation hardening work for stage-by-stage demo playback (Semester 1 through Semester 6), including what was fixed, what was validated, and the exact next implementation blocks.

## Scope Of This Handoff
This handoff is only for the deterministic simulation consistency pass. The repository contains many unrelated in-progress changes and deletions; do not revert unrelated files while continuing this track.

## Completed In This Pass

1. Proof summary semester semantics fixed.
- Checkpoint semester now takes precedence over active operational semester when rendering proof semester metrics.
- File: `src/academic-proof-summary-strip.tsx`

2. HoD provenance rendering made backend-authoritative.
- Removed client-side rewriting of `activeOperationalSemester` in HoD page provenance rendering.
- File: `src/pages/hod-pages.tsx`

3. Risk explorer notice noise reduced.
- Removed duplicated model-usefulness banner in hero notice stack.
- File: `src/pages/risk-explorer.tsx`

4. Frontend regression guard added for checkpoint-vs-operational mismatch.
- Added assertions that lock proof semester metric to selected checkpoint semester.
- File: `tests/academic-proof-summary-strip.test.tsx`

5. Backend stage-walk tests hardened for deterministic action-space semantics.
- Added assertions for every checkpoint in semester walks:
  - `policyComparison.candidates` is non-empty
  - `recommendedAction` (if present) exists in candidates
  - no-action comparator risk is present and numeric
- File: `air-mentor-api/tests/risk-explorer.test.ts`

## Validation Run Results

1. Frontend targeted suite:
- Command:
  - `npm test -- tests/academic-proof-summary-strip.test.tsx`
- Result:
  - Passed (2/2)

2. Backend risk explorer target suite:
- Command:
  - `npm --workspace air-mentor-api test -- tests/risk-explorer.test.ts`
- Result:
  - `tests/risk-explorer.test.ts` passed (5/5, including activated semester walks)
- Note:
  - The backend test wrapper (`run-vitest-suite.mjs`) continues into a broader fast suite by design. The session was terminated after the target suite had already passed.

## Related Deterministic Plan (Primary Reference)
- `audit-map/32-reports/deterministic-stage-simulation-remediation-plan.md`

This plan defines:
- deterministic input/output contract,
- semester walk acceptance requirements,
- remaining mandatory closure tasks.

## Remaining Required Work (Not Yet Implemented)

1. Canonical action catalog by `stageKey`.
- Add static/versioned action registry and validate candidate sets in runtime + playback services.
- Target files:
  - `air-mentor-api/src/lib/proof-control-plane-playback-service.ts`
  - `air-mentor-api/src/lib/proof-control-plane-runtime-service.ts`
  - `air-mentor-api/src/lib/proof-control-plane-playback-governance-service.ts`

2. Queue ranking vs displayed risk scalar consistency.
- Unify semantics or expose dual scalar contract explicitly and enforce in UI labels.
- Target file:
  - `air-mentor-api/src/lib/proof-risk-model.ts`

3. Advisory vs trained output boundary hardening.
- Keep derived scenario outputs explicitly advisory (or train proper heads).
- Target file:
  - `air-mentor-api/src/lib/proof-control-plane-tail-service.ts`

4. Fallback evidence completeness guardrails.
- Ensure fallback rows always ship completeness/confidence metadata and gate probability display accordingly.
- Target files:
  - `air-mentor-api/src/lib/proof-control-plane-runtime-service.ts`
  - `air-mentor-api/tests/risk-explorer.test.ts`

5. Cross-surface same-student parity fixture.
- Byte-level parity checks across:
  - sysadmin proof dashboard
  - HoD analytics
  - faculty profile proof panel
  - student shell
  - risk explorer

## Resume Instructions

1. Read:
- `audit-map/32-reports/deterministic-stage-simulation-remediation-plan.md`
- this handoff file

2. Run deterministic gates first:
- `npm test -- tests/academic-proof-summary-strip.test.tsx`
- `npm --workspace air-mentor-api test -- tests/risk-explorer.test.ts`

3. Implement next block in this order:
- action catalog by stage key,
- scalar consistency,
- advisory/trained boundary,
- fallback completeness gating,
- parity fixture.

4. After each block:
- add focused assertions in backend tests,
- verify frontend provenance copy/labels remain backend-authoritative,
- update `audit-map/32-reports/deterministic-stage-simulation-remediation-plan.md` with completion state.

## Current Working Set Snapshot (Relevant Files)

Modified:
- `src/academic-proof-summary-strip.tsx`
- `src/pages/hod-pages.tsx`
- `src/pages/risk-explorer.tsx`
- `tests/academic-proof-summary-strip.test.tsx`
- `air-mentor-api/tests/risk-explorer.test.ts`

Created:
- `audit-map/32-reports/deterministic-stage-simulation-remediation-plan.md`
- `audit-map/32-reports/stage-simulation-deterministic-handoff-2026-04-17.md`

## Caution
Repository is currently a dirty worktree with extensive unrelated changes. Continue only within deterministic simulation scope unless explicitly expanding scope.
