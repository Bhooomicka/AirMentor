# Deterministic Stage Simulation Remediation Plan

## Objective
Deliver a semester-by-semester, checkpoint-by-checkpoint simulation that is reproducible, auditable, and demo-safe for all supported action paths from Semester 1 through Semester 6.

## Deterministic Contract
For every checkpoint payload, the system must produce the same outputs for the same inputs:

- Input tuple:
  - simulationRunId
  - simulationStageCheckpointId
  - activeOperationalSemester
  - studentId
  - offeringId
  - observed evidence window
  - policy version
  - model artifact version
- Output tuple:
  - countSource, resolvedFrom, scopeMode
  - activeOperationalSemester, checkpointContext
  - policyComparison (recommendedAction + candidates)
  - noAction comparator (risk + lift)
  - trained head display state (band/probability gating)

No UI layer may rewrite these fields. Surfaces must render backend truth.

## Stage Walk Requirement (Semesters 1-6)
For each semester and selected checkpoint:

1. Activate semester.
2. Load default student risk explorer.
3. Load explicit checkpoint risk explorer.
4. Assert provenance semantics:
   - default source in {proof-run, proof-checkpoint}
   - checkpoint source is proof-checkpoint
   - activeOperationalSemester equals selected semester
5. Assert action-space semantics:
   - policyComparison.candidates length > 0
   - recommendedAction (if present) exists in candidates
   - noAction comparator exists and is numeric
6. Assert model-output semantics:
   - counterfactualLiftScaled is numeric
   - evidenceWindow matches checkpoint window

## Immediate Deterministic Fixes Applied

1. Checkpoint semester metric now prefers selected checkpoint over active run semester in proof summary strip:
   - src/academic-proof-summary-strip.tsx
2. HoD page no longer rewrites provenance semester client-side:
   - src/pages/hod-pages.tsx
3. Duplicate model-usefulness message removed from risk explorer hero notices:
   - src/pages/risk-explorer.tsx
4. Frontend regression guard added for checkpoint-vs-operational semester mismatch:
   - tests/academic-proof-summary-strip.test.tsx
5. Backend stage-walk tests now enforce action candidate completeness and no-action comparator presence across semesters 1-6:
   - air-mentor-api/tests/risk-explorer.test.ts

## Remaining Deterministic Work (Required for Full Closure)

1. Canonical action catalog by stage key:
   - Implement static, versioned action registry keyed by stageKey and policy phenotype.
   - Validate policyComparison candidates against catalog in runtime and playback paths.
   - Files to extend:
     - air-mentor-api/src/lib/proof-control-plane-playback-service.ts
     - air-mentor-api/src/lib/proof-control-plane-runtime-service.ts
     - air-mentor-api/src/lib/proof-control-plane-playback-governance-service.ts

2. Single scalar semantics for ranking vs displayed risk:
   - Either align queue ranking and displayed official risk scalar, or expose both as explicit fields and enforce UI labels.
   - File:
     - air-mentor-api/src/lib/proof-risk-model.ts

3. Advisory-vs-trained boundary hardening:
   - Keep derivedScenarioHeads explicitly advisory (index scale) or train dedicated heads with labels.
   - Do not present advisory outputs as trained probabilities without uncertainty metadata.
   - File:
     - air-mentor-api/src/lib/proof-control-plane-tail-service.ts

4. Fallback evidence completeness guardrails:
   - On fallback-simulated rows, always emit feature completeness and confidence class.
   - Add test that blocks silent probability presentation when completeness is partial.
   - Files:
     - air-mentor-api/src/lib/proof-control-plane-runtime-service.ts
     - air-mentor-api/tests/risk-explorer.test.ts

5. Cross-surface parity fixture for one student across all proof surfaces:
   - Compare the same checkpoint tuple across:
     - sysadmin proof dashboard
     - HoD analytics
     - faculty profile proof panel
     - student shell
     - risk explorer
   - Assert countSource/resolvedFrom/semester/checkpoint consistency byte-for-byte.

## Validation Commands

```bash
npm test -- tests/academic-proof-summary-strip.test.tsx
npm --workspace air-mentor-api test -- tests/risk-explorer.test.ts
```

Note: The backend test runner currently expands to the fast suite wrapper; treat the risk-explorer stage-walk pass as the deterministic gate for this remediation step.
