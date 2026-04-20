# Adversarial Audit Prompt Suite (Prompts 0-14)

Version: `v1.1`
Date: `2026-04-18`

This file is the canonical, execution-ready prompt pack for adversarial closure work. It includes:

1. Prompt 0: Master Orchestrator
2. Prompt 1-14: Domain prompts with mandatory checks and race scripts
3. Shared schema validation contract
4. Unified closure matrix contract
5. New mandatory schema blocks for truth drift, intent integrity, logic integrity, UX integrity, and recovery integrity
6. Required test output contract for high and critical findings
7. Automation Strategy Appendix with seed data shape, assertion list, and pass criteria

---

## Shared Contracts (Applies To Prompts 0-14)

### A. Severity and Status Enums

Severity enum:
- `critical`
- `high`
- `medium`
- `low`

Status enum:
- `open`
- `closed`
- `blocked`
- `needs-retest`

Gate enum:
- `PASS`
- `FAIL`

### B. Required Finding Schema (Mandatory)

Every finding must contain all fields below:

```json
{
  "finding_id": "string",
  "prompt_id": "P0|P1|P2|P3|P4|P5|P6|P7|P8|P9|P10|P11|P12|P13|P14",
  "check_id": "string",
  "severity": "critical|high|medium|low",
  "status": "open|closed|blocked|needs-retest",
  "confidence": "high|medium|low",
  "adversarial_hypothesis": "string",
  "verification_sequence_executed": ["string"],
  "repro_script_id": "string|null",
  "expected_behavior": "string",
  "observed_behavior": "string",
  "evidence_files": ["string"],
  "evidence_commands": ["string"],
  "artifacts": ["string"],
  "race_condition_assessment": "string",
  "security_impact": "string",
  "user_impact": "string",
  "root_cause": "string",
  "truth_drift_assessment": {
    "drift_detected": true,
    "drift_type": "none|spec-vs-code|code-vs-test|test-vs-live|status-vs-reality|artifact-vs-claim",
    "drift_evidence": ["string"],
    "drift_resolution_state": "resolved|unresolved|needs-retest"
  },
  "intent_integrity_block": {
    "feature_intent": "string",
    "intent_source_refs": ["string"],
    "intent_match": "full|partial|mismatch",
    "intent_gap": "string"
  },
  "logic_integrity_block": {
    "preconditions": ["string"],
    "decision_points": ["string"],
    "failure_modes": ["string"],
    "fallacy_check": "pass|fail",
    "fallacy_notes": "string"
  },
  "ux_integrity_block": {
    "primary_user_journey": "string",
    "friction_points": ["string"],
    "cognitive_load_risk": "low|medium|high",
    "accessibility_impact": "none|minor|major"
  },
  "recovery_integrity_block": {
    "degrade_behavior": "string",
    "retry_or_rollback_strategy": "string",
    "user_safe_state": "string",
    "observability_hook": "string"
  },
  "fix_recommendation": "string",
  "regression_tests": ["string"],
  "closure_criteria": ["string"]
}
```

### C. Mandatory Schema Blocks (Hard Requirements)

The following validation rules are mandatory in every prompt output:

1. `truth_drift_assessment` must be present and populated for every finding.
2. `intent_integrity_block.intent_source_refs` must point to at least one concrete evidence source.
3. `logic_integrity_block.fallacy_check=fail` requires an explicit closure criterion that prevents release.
4. `ux_integrity_block.cognitive_load_risk=high` requires at least one high/critical test spec.
5. `recovery_integrity_block.user_safe_state` cannot be empty for high/critical findings.
6. If `truth_drift_assessment.drift_detected=true` and `drift_resolution_state!=resolved`, the finding cannot be closed.

### D. Required Test Output Schema (Mandatory In Every Prompt)

After findings, each prompt must emit test specs for every finding with severity `critical` or `high`.

```json
{
  "required_test_output": {
    "coverage_rule": "One-to-one mapping: every open or blocked high/critical finding must have at least one test spec",
    "high_critical_test_specs": [
      {
        "test_spec_id": "string",
        "finding_id": "string",
        "prompt_id": "P1|P2|P3|P4|P5|P6|P7|P8|P9|P10|P11|P12|P13|P14",
        "test_layer": "unit|integration|contract|e2e|accessibility|load|reliability",
        "test_type": "regression|race|negative|parity|resilience",
        "target_files": ["string"],
        "seed_requirements": ["string"],
        "preconditions": ["string"],
        "steps": ["string"],
        "assertions": ["string"],
        "flake_controls": ["string"],
        "expected_result": "string",
        "failure_signature": "string"
      }
    ],
    "test_stub_snippets": [
      {
        "test_spec_id": "string",
        "language": "typescript|javascript|bash",
        "framework": "vitest|playwright|supertest|shell",
        "snippet": "string"
      }
    ]
  }
}
```

Validation rule:
- if `severity in [critical, high]` and no matching `high_critical_test_specs.finding_id`, the prompt output is invalid.

### E. Unified Closure Matrix Row Schema (Produced By Prompt 0)

```json
{
  "prompt_id": "P1|P2|P3|P4|P5|P6|P7|P8|P9|P10|P11|P12|P13|P14",
  "checks_total": 0,
  "checks_executed": 0,
  "race_scripts_total": 0,
  "race_scripts_executed": 0,
  "critical_open": 0,
  "high_open": 0,
  "truth_drift_open": 0,
  "intent_mismatch_open": 0,
  "logic_fallacy_open": 0,
  "ux_integrity_open": 0,
  "blocked_total": 0,
  "schema_valid": true,
  "required_test_output_valid": true,
  "gate_result": "PASS|FAIL",
  "notes": "string"
}
```

---

## Prompt 0: Master Orchestrator (Shared Schema Validation + Unified Closure Matrix)

You are the master orchestration agent. Your task is to execute, validate, and gate prompts P1-P14 under one closure decision.

### Scope

Repository root: `/home/raed/projects/air-mentor-ui`

Input artifacts expected from each prompt:
- `prompt-output-P1.json`
- `prompt-output-P2.json`
- `prompt-output-P3.json`
- `prompt-output-P4.json`
- `prompt-output-P5.json`
- `prompt-output-P6.json`
- `prompt-output-P7.json`
- `prompt-output-P8.json`
- `prompt-output-P9.json`
- `prompt-output-P10.json`
- `prompt-output-P11.json`
- `prompt-output-P12.json`
- `prompt-output-P13.json`
- `prompt-output-P14.json`

### Mandatory orchestration procedure

1. Execute prompts in this order unless blocked:
  - P1, P2, P3, P4, P5, P6, P8, P9, P10, P11, P12, P13, P14, P7
2. Validate each prompt output against:
   - Required Finding Schema
  - Mandatory Schema Blocks
   - Required Test Output Schema
3. Reject any prompt output that:
   - omits required fields
   - contains unexecuted mandatory checks
   - contains high/critical findings without test specs
  - contains unresolved truth drift for a closed finding
4. Build unified closure matrix with one row per prompt (P1-P14).
5. Compute global gate:
   - FAIL if any prompt has `gate_result=FAIL`
   - FAIL if any prompt has `critical_open > 0`
  - FAIL if any prompt has `high_open > 0` and no hard blocker evidence
  - FAIL if any prompt has `truth_drift_open > 0`
  - FAIL if any prompt has `intent_mismatch_open > 0`
  - FAIL if any prompt has `logic_fallacy_open > 0`
  - FAIL if any prompt has `ux_integrity_open > 0`
   - FAIL if any prompt has `schema_valid=false`
   - FAIL if any prompt has `required_test_output_valid=false`
  - PASS only if all prompts pass and all critical/high are closed or hard-blocked with evidence and explicit resume steps
6. Emit deterministic resume block if global gate is FAIL.

### Required outputs

1. `unified-closure-matrix.json`
2. `unified-closure-matrix.md`
3. `global-gate-verdict.json`
4. `master-orchestrator-summary.md`
5. `truth-drift-ledger.json`
6. `intent-logic-ux-failure-register.md`

### Required final verdict JSON

```json
{
  "run_id": "string",
  "schema_version": "1.1",
  "prompts_evaluated": ["P1","P2","P3","P4","P5","P6","P7","P8","P9","P10","P11","P12","P13","P14"],
  "unified_closure_matrix": [],
  "truth_drift_open_total": 0,
  "intent_mismatch_open_total": 0,
  "logic_fallacy_open_total": 0,
  "ux_integrity_open_total": 0,
  "global_gate": "PASS|FAIL",
  "fail_reasons": ["string"],
  "resume_plan": ["string"]
}
```

### Required Test Output (Mandatory)

After orchestrator findings, emit:
- matrix validation test specs for every high/critical orchestration finding (for example, schema validator false positives/negatives, missing prompt artifact handling, incorrect gate aggregation)
- truth-drift reconciliation tests proving contradiction matrix and status/checkpoint/log coherence checks are enforced
- stub snippets for validator and aggregation tests

### Hard pass/fail gates

1. Fail if any prompt output is missing.
2. Fail if any prompt output fails schema validation.
3. Fail if any prompt output fails mandatory schema block validation.
4. Fail if any high/critical finding lacks test spec output.
5. Fail if any unresolved truth drift is marked closed.
6. Fail if unified closure matrix and global gate disagree.
7. Pass only when all prompt gates pass and all global rules pass.

---

## Prompt 1: Bootstrap, Auth, and Security Audit

You are an adversarial audit agent. Assume bootstrap/auth/security is broken until proven otherwise.

### Scope and evidence targets

- `src/App.tsx`
- `src/system-admin-app.tsx`
- `src/system-admin-session-shell.tsx`
- `src/repositories.ts`
- `src/system-admin-live-app.tsx`
- `air-mentor-api/src/app.ts`
- `air-mentor-api/src/modules/session.ts`

### Mandatory checks

- P1-C01: Portal routing and bootstrap gate integrity
- P1-C02: Academic login/restore/role-switch contract
- P1-C03: Admin role boundary and authorization
- P1-C04: CSRF and origin enforcement for mutations
- P1-C05: Logout cleanup completeness across storage/in-memory
- P1-C06: Preference roundtrip and version conflict handling
- P1-C07: Mid-session auth revocation and graceful failure handling

### Race and edge scripts

- P1-R01: Double login submit race
- P1-R02: Role switch during in-flight restore
- P1-R03: Logout during in-flight admin refresh
- P1-R04: Invalid CSRF with valid session cookie

### Required Finding Output

Use the shared Required Finding Schema.

### Required Test Output (Mandatory)

After findings, emit test specs and stubs for every high/critical finding.
Include at least one of: contract test, integration test, race test, or e2e test per finding.

### Hard pass/fail gates

- Fail if any mandatory check is unexecuted.
- Fail if any critical/high finding is open without hard blocker evidence.
- Fail if any high/critical finding has no test spec and no stub.
- Pass only if all checks and race scripts execute with evidence.

---

## Prompt 2: Admin Control Plane and State Coupling Audit

You are an adversarial audit agent. Assume admin workflows are state-coupled and brittle until proven otherwise.

### Scope and evidence targets

- `src/system-admin-live-app.tsx`
- `src/system-admin-request-workspace.tsx`
- `src/system-admin-faculties-workspace.tsx`
- `src/admin-section-scope.ts`
- `src/system-admin-action-queue.ts`
- `air-mentor-api/src/modules/admin-requests.ts`
- `air-mentor-api/src/modules/admin-control-plane.ts`

### Mandatory checks

- P2-C01: Request lifecycle parity (UI vs API)
- P2-C02: Scoped launch, breadcrumb, and return integrity
- P2-C03: Section source-of-truth consistency
- P2-C04: Preview/apply stale invalidation safety
- P2-C05: Queue dismiss/restore persistence semantics
- P2-C06: Faculty calendar lock/save/reset behavior
- P2-C07: Hash route restore stability
- P2-C08: Write conflict and retry safety

### Race and edge scripts

- P2-R01: Concurrent request transition actions
- P2-R02: Scope change during in-flight registry load
- P2-R03: Stale preview apply attempt
- P2-R04: Hash restore race with in-memory route history

### Required Finding Output

Use the shared Required Finding Schema.

### Required Test Output (Mandatory)

After findings, emit test specs and stubs for every high/critical finding.
At least one stale-state regression test must exist for each high/critical state-coupling defect.

### Hard pass/fail gates

- Fail if lifecycle transition parity is incomplete.
- Fail if any high/critical coupling bug is open.
- Fail if high/critical findings lack test specs and stubs.
- Pass only when all checks and races are evidenced.

---

## Prompt 3: Proof, Risk, and Cross-Surface Parity Audit

You are an adversarial audit agent. Assume proof/risk semantics diverge across surfaces until proven otherwise.

### Scope and evidence targets

- `src/system-admin-proof-dashboard-workspace.tsx`
- `src/proof-playback.ts`
- `src/proof-provenance.ts`
- `src/pages/risk-explorer.tsx`
- `src/pages/student-shell.tsx`
- `src/pages/hod-pages.tsx`
- `air-mentor-api/src/lib/proof-control-plane-tail-service.ts`
- `air-mentor-api/src/lib/proof-control-plane-hod-service.ts`
- `air-mentor-api/src/lib/proof-risk-model.ts`

### Mandatory checks

- P3-C01: Same-checkpoint parity across all required surfaces
- P3-C02: Default slice vs explicit checkpoint semantics
- P3-C03: Playback persistence/invalidation correctness
- P3-C04: Model display gating and confidence suppression rules
- P3-C05: Worker freshness and dashboard reflection
- P3-C06: Evidence timeline endpoint and consumer contract
- P3-C07: Same-student parity across role switches

### Race and edge scripts

- P3-R01: Stale checkpoint restore race
- P3-R02: Out-of-order checkpoint detail response race
- P3-R03: Double run/recompute trigger race
- P3-R04: Role switch during in-flight proof fetch

### Required Finding Output

Use the shared Required Finding Schema.

### Required Test Output (Mandatory)

After findings, emit test specs and stubs for every high/critical finding.
Each high/critical parity defect must include a parity assertion set across at least two surfaces.

### Hard pass/fail gates

- Fail if parity matrix is incomplete.
- Fail if any high/critical semantic mismatch is open.
- Fail if high/critical findings lack test specs and stubs.
- Pass only with complete parity evidence and closed gates.

---

## Prompt 4: Academic Runtime and Compatibility Route Audit

You are an adversarial audit agent. Assume runtime contracts are drifting and compatibility routes mask defects until proven otherwise.

### Scope and evidence targets

- `src/api/client.ts`
- `air-mentor-api/src/modules/academic-runtime-routes.ts`
- `air-mentor-api/src/modules/academic.ts`
- `air-mentor-api/src/modules/academic-authoritative-first.ts`

### Mandatory checks

- P4-C01: Frontend authoritative endpoint consumption
- P4-C02: Compatibility deprecation header contract completeness
- P4-C03: Version/updatedAt conflict handling correctness
- P4-C04: Scope/role authorization on writes
- P4-C05: Runtime shadow drift signaling behavior
- P4-C06: Authoritative-first fallback correctness

### Race and edge scripts

- P4-R01: Concurrent task update version race
- P4-R02: Placement delete/update overlap
- P4-R03: Deprecated vs authoritative mixed route read-after-write
- P4-R04: Cross-scope crafted payload bypass attempt

### Required Finding Output

Use the shared Required Finding Schema.

### Required Test Output (Mandatory)

After findings, emit test specs and stubs for every high/critical finding.
Every high/critical contract finding must include at least one API contract test case.

### Hard pass/fail gates

- Fail if any compatibility route behavior is unverified.
- Fail if any authorization bypass is open.
- Fail if high/critical findings lack test specs and stubs.
- Pass only with complete route-contract evidence.

---

## Prompt 5: Observability, Startup Diagnostics, and Telemetry Audit

You are an adversarial audit agent. Assume observability is incomplete and diagnostics are misleading until proven otherwise.

### Scope and evidence targets

- `src/startup-diagnostics.ts`
- `src/telemetry.ts`
- `src/App.tsx`
- `src/system-admin-app.tsx`
- `air-mentor-api/src/modules/client-telemetry.ts`
- `air-mentor-api/src/lib/telemetry.ts`
- `air-mentor-api/src/lib/operational-event-store.ts`
- `air-mentor-api/src/app.ts`

### Mandatory checks

- P5-C01: Startup diagnostics severity correctness by environment
- P5-C02: Telemetry sink resolution order correctness
- P5-C03: Frontend emission coverage across critical flows
- P5-C04: Backend intake validation and persistence chain
- P5-C05: Relay forwarding and sink failure behavior
- P5-C06: Security boundary of telemetry route exception

### Race and edge scripts

- P5-R01: Burst telemetry under sink outage
- P5-R02: Invalid payload flood rejection
- P5-R03: Mixed startup environment classification
- P5-R04: Relay token misconfiguration path

### Required Finding Output

Use the shared Required Finding Schema.

### Required Test Output (Mandatory)

After findings, emit test specs and stubs for every high/critical finding.
Each high/critical observability finding must include one negative-path telemetry test.

### Hard pass/fail gates

- Fail if startup scenario matrix is incomplete.
- Fail if any telemetry chain link is unverified.
- Fail if high/critical findings lack test specs and stubs.
- Pass only with complete observability proof chain.

---

## Prompt 6: UX, Accessibility, Interaction Density, and Usability Safety Audit

You are an adversarial audit agent. Assume UX fails in stress states and keyboard flow is fragile until proven otherwise.

### Scope and evidence targets (component source only)

- `src/system-admin-live-app.tsx`
- `src/system-admin-request-workspace.tsx`
- `src/system-admin-faculties-workspace.tsx`
- `src/system-admin-proof-dashboard-workspace.tsx`
- `src/system-admin-faculty-calendar-workspace.tsx`
- `src/system-admin-hierarchy-workspace-shell.tsx`
- `src/system-admin-scoped-registry-launches.tsx`
- `src/system-admin-ui.tsx`
- `src/ui-primitives.tsx`
- `src/proof-surface-shell.tsx`
- `src/pages/risk-explorer.tsx`
- `src/pages/student-shell.tsx`
- `src/pages/hod-pages.tsx`

### Mandatory checks

- P6-C01: Keyboard-only completion for critical paths
- P6-C02: Focus trap, escape, and focus return correctness
- P6-C03: Disabled/loading/error recovery consistency
- P6-C04: Terminology and decision-label consistency
- P6-C05: Deep-link/back-forward navigation resilience
- P6-C06: Search/filter/list behavior under 0/1/large datasets
- P6-C07: Mobile viewport and overflow action accessibility

### Race and edge scripts

- P6-R01: Rapid tab switching under load
- P6-R02: Overlay open then route change
- P6-R03: Search plus scope change race
- P6-R04: Back navigation from deep detail with restore state

### Required Finding Output

Use the shared Required Finding Schema.

### Required Test Output (Mandatory)

After findings, emit test specs and stubs for every high/critical finding.
Every high/critical UX/access issue must include at least one keyboard-flow test or focus-order test.

### Hard pass/fail gates

- Fail if critical flows do not have keyboard/focus proof.
- Fail if any high/critical user-trap issue remains open.
- Fail if high/critical findings lack test specs and stubs.
- Pass only with complete interaction evidence.

---

## Prompt 7: Live Deployment, Session Contract, and Recovery Chain Audit

You are an adversarial audit agent. Assume live deployment checks are optimistic and recovery is unsafe until proven otherwise.

### Scope and evidence targets

- `audit-map/10-live-behavior`
- `audit-map/14-reconciliation/contradiction-matrix.md`
- `scripts/check-railway-deploy-readiness.mjs`
- `scripts/verify-final-closeout-live.sh`
- `scripts/railway-recovery-chain.sh`
- `air-mentor-api/src/app.ts`
- `air-mentor-api/src/modules/session.ts`

### Mandatory checks

- P7-C01: Live health contract parity
- P7-C02: Live session login/csrf contract
- P7-C03: Script success claim vs semantic truth
- P7-C04: Recovery chain idempotence and safety
- P7-C05: Read-only parity proof path availability
- P7-C06: Status/checkpoint truth vs process reality

### Race and edge scripts

- P7-R01: Transport instability classification
- P7-R02: Parallel live script invocation artifact collision
- P7-R03: Recovery re-entry after partial failure
- P7-R04: Missing credentials hard-fail path

### Required Finding Output

Use the shared Required Finding Schema.

### Required Test Output (Mandatory)

After findings, emit test specs and stubs for every high/critical finding.
Each high/critical live-contract issue must include one script-level contract test spec.

### Hard pass/fail gates

- Fail if live health/session contracts are unproven.
- Fail if script claims success without semantic evidence.
- Fail if high/critical findings lack test specs and stubs.
- Pass only with complete live evidence chain.

---

## Prompt 8: Error Boundaries, Memory Leaks, and Full ARIA/Screen Reader Audit

You are an adversarial audit agent. Assume UI crash containment is incomplete, cleanup is leaky, and accessibility semantics are insufficient until proven otherwise.

### Scope and evidence targets

Top-level and surface-level error containment:
- `src/App.tsx`
- `src/main.tsx`
- `src/system-admin-app.tsx`
- `src/system-admin-live-app.tsx`
- `src/academic-session-shell.tsx`
- `src/system-admin-session-shell.tsx`
- `src/proof-surface-shell.tsx`

Likely leak and cleanup hotspots:
- `src/system-admin-live-app.tsx`
- `src/system-admin-proof-dashboard-workspace.tsx`
- `src/system-admin-request-workspace.tsx`
- `src/system-admin-faculty-calendar-workspace.tsx`
- `src/pages/risk-explorer.tsx`
- `src/pages/student-shell.tsx`
- `src/pages/hod-pages.tsx`
- `src/telemetry.ts`
- `src/proof-playback.ts`

ARIA and screen reader semantics:
- `src/system-admin-ui.tsx`
- `src/ui-primitives.tsx`
- `src/system-admin-request-workspace.tsx`
- `src/system-admin-faculties-workspace.tsx`
- `src/system-admin-proof-dashboard-workspace.tsx`
- `src/pages/risk-explorer.tsx`

### Mandatory checks

- P8-C01: Top-level error boundary presence and fallback behavior
- P8-C02: Surface-level boundary isolation for major workspaces
- P8-C03: Async error propagation and user-safe fallback state
- P8-C04: Event listener cleanup on unmount and dependency changes
- P8-C05: Interval/timeout cleanup and stale closure prevention
- P8-C06: Subscription/observer/socket cleanup correctness
- P8-C07: ARIA role/name/value correctness for interactive controls
- P8-C08: Screen-reader narrative order for headings, alerts, and status
- P8-C09: Dynamic content announcements (`aria-live`) correctness
- P8-C10: Modal/dialog semantics (`aria-modal`, label, describedby, focus return)

### Race and edge scripts

- P8-R01: Unmount during in-flight async state update
- P8-R02: Rapid remount loop to expose listener leaks
- P8-R03: Repeated route transitions to detect orphaned intervals
- P8-R04: Concurrent toast/alert emissions and screen reader ordering
- P8-R05: Dialog open/close burst with keyboard-only navigation

### Required Finding Output

Use the shared Required Finding Schema.

### Required Test Output (Mandatory)

After findings, emit test specs and stubs for every high/critical finding.
Each high/critical accessibility finding must include at least one `axe`-style or role-query assertion spec and one keyboard/screen-reader flow spec.
Each high/critical leak finding must include an unmount/remount cleanup test spec.

### Hard pass/fail gates

- Fail if no boundary map exists for top-level and major surfaces.
- Fail if any high/critical leak remains open.
- Fail if any high/critical ARIA/screen-reader issue remains open.
- Fail if high/critical findings lack test specs and stubs.
- Pass only when all boundary, cleanup, and accessibility gates are evidenced.

---

## Prompt 9: Truth Drift and Contradiction Reconciliation Audit

You are an adversarial audit agent. Assume truth drift exists between documentation, status artifacts, and real implementation until proven otherwise.

### Scope and evidence targets

- `audit-map/14-reconciliation/contradiction-matrix.md`
- `audit-map/23-coverage/coverage-ledger.md`
- `audit-map/24-agent-memory/known-facts.md`
- `audit-map/24-agent-memory/working-knowledge.md`
- `audit-map/29-status`
- `audit-map/30-checkpoints`
- `audit-map/32-reports`
- `audit-map/20-prompts/prompt-index.md`
- `audit-map/20-prompts/prompt-version-history.md`
- `audit-map/20-prompts/prompt-change-log.md`
- `audit-map/16-scripts/tmux-list-jobs.sh`
- `audit-map/16-scripts/tmux-job-status.sh`

### Mandatory checks

- P9-C01: Every open contradiction has a current evidence triad (expected, implemented, tested/live)
- P9-C02: Contradiction status labels match latest artifacts and are not stale carryovers
- P9-C03: Status/checkpoint/log precedence is enforced when they disagree
- P9-C04: Pass success claims are backed by required artifacts and not by status text alone
- P9-C05: Coverage ledger entries map to real files and current prompt coverage scope
- P9-C06: Known-facts entries remain append-only and are not silently contradicted downstream
- P9-C07: Prompt index, version history, and change log are mutually coherent
- P9-C08: Truth drift type classification is applied to every high/critical mismatch
- P9-C09: Each unresolved truth drift has deterministic resume instructions

### Race and edge scripts

- P9-R01: Status file restamp during active tmux session transition
- P9-R02: Queue mutation while orchestrator is consuming `pending.queue`
- P9-R03: Concurrent contradiction and coverage updates creating split-brain state
- P9-R04: New evidence snapshot appears after stale report claim was already written

### Required Finding Output

Use the shared Required Finding Schema including all mandatory schema blocks.

### Required Test Output (Mandatory)

After findings, emit test specs and stubs for every high/critical finding.
Each high/critical truth-drift issue must include at least one artifact-coherence contract test and one status/checkpoint/log precedence test.

### Hard pass/fail gates

- Fail if any contradiction is closed without artifact-backed drift resolution evidence.
- Fail if any high/critical truth drift remains open.
- Fail if high/critical findings lack test specs and stubs.
- Pass only when contradiction, coverage, and status/checkpoint truth are coherent.

---

## Prompt 10: Feature Intent Preservation and Logic Cohesion Audit

You are an adversarial audit agent. Assume user-facing feature intent has drifted from implementation until proven otherwise.

### Scope and evidence targets

- `airmentor-feature-registry.md`
- `src/portal-entry.tsx`
- `src/App.tsx`
- `src/system-admin-live-app.tsx`
- `src/system-admin-request-workspace.tsx`
- `src/system-admin-proof-dashboard-workspace.tsx`
- `src/pages/risk-explorer.tsx`
- `src/pages/student-shell.tsx`
- `src/pages/hod-pages.tsx`
- `air-mentor-api/src/modules/admin-requests.ts`
- `air-mentor-api/src/modules/academic.ts`
- `air-mentor-api/src/modules/academic-runtime-routes.ts`

### Mandatory checks

- P10-C01: Feature-registry intent maps to concrete implemented behavior per high-impact feature
- P10-C02: User-value-critical paths do not regress into dead-end or contradictory logic
- P10-C03: Decision labels and action outcomes are semantically aligned (no misleading affordances)
- P10-C04: Business-rule parity is preserved between frontend and backend contracts
- P10-C05: Intent-critical transitions have explicit failure handling and recovery states
- P10-C06: Role-based constraints do not unintentionally break expected user outcomes
- P10-C07: Feature removals/deprecations are explicit and documented, not accidental omissions

### Race and edge scripts

- P10-R01: Concurrent user actions on same intent-critical object (approve/reject/request changes)
- P10-R02: Mid-flow role switch while feature state is partially persisted
- P10-R03: Multi-tab intent drift where stale tab overwrites newer valid intent
- P10-R04: Back/forward replay causing branch logic inversion

### Required Finding Output

Use the shared Required Finding Schema including all mandatory schema blocks.

### Required Test Output (Mandatory)

After findings, emit test specs and stubs for every high/critical finding.
Each high/critical intent mismatch must include one end-to-end intent-preservation test and one backend contract assertion set.

### Hard pass/fail gates

- Fail if any high/critical intent mismatch is open.
- Fail if logic fallacy checks are incomplete for critical user journeys.
- Fail if high/critical findings lack test specs and stubs.
- Pass only when intent and implementation are semantically coherent.

---

## Prompt 11: Cross-Flow Workflow Integrity and Recovery Audit

You are an adversarial audit agent. Assume cross-surface workflows break under realistic interruptions until proven otherwise.

### Scope and evidence targets

- `src/portal-entry.tsx`
- `src/academic-session-shell.tsx`
- `src/system-admin-session-shell.tsx`
- `src/system-admin-live-app.tsx`
- `src/system-admin-request-workspace.tsx`
- `src/system-admin-faculties-workspace.tsx`
- `src/system-admin-proof-dashboard-workspace.tsx`
- `src/repositories.ts`
- `air-mentor-api/src/modules/session.ts`
- `air-mentor-api/src/modules/admin-requests.ts`
- `air-mentor-api/src/modules/academic-authoritative-first.ts`

### Mandatory checks

- P11-C01: Full journey integrity for login -> context selection -> action -> confirmation -> recoverability
- P11-C02: Cross-workspace handoff state consistency (request, proof, faculty, student surfaces)
- P11-C03: Refresh/reload resilience at every step of high-value flows
- P11-C04: Partial failure recovery without data corruption or phantom success UI
- P11-C05: Retry idempotence for mutating actions
- P11-C06: Back/forward navigation preserves workflow invariants
- P11-C07: Multi-role shared-entity coherence (same student/request/proof item)

### Race and edge scripts

- P11-R01: Refresh during in-flight mutation and eventual retry
- P11-R02: Competing updates from two roles against same entity
- P11-R03: Resume from stale deep link after server-side state mutation
- P11-R04: Network blip during optimistic UI transition

### Required Finding Output

Use the shared Required Finding Schema including all mandatory schema blocks.

### Required Test Output (Mandatory)

After findings, emit test specs and stubs for every high/critical finding.
Each high/critical flow-integrity defect must include one reproducible multi-step e2e scenario with deterministic seed and assertions.

### Hard pass/fail gates

- Fail if any critical cross-flow recovery path is unverified.
- Fail if any high/critical workflow integrity defect is open.
- Fail if high/critical findings lack test specs and stubs.
- Pass only with complete start-to-finish plus interruption-recovery proof.

---

## Prompt 12: Fault Tolerance, Error Containment, and Graceful Degradation Audit

You are an adversarial audit agent. Assume fault paths leak inconsistent state or user harm until proven otherwise.

### Scope and evidence targets

- `src/main.tsx`
- `src/App.tsx`
- `src/system-admin-app.tsx`
- `src/system-admin-live-app.tsx`
- `src/academic-session-shell.tsx`
- `src/system-admin-session-shell.tsx`
- `src/repositories.ts`
- `air-mentor-api/src/app.ts`
- `air-mentor-api/src/lib/http-errors.ts`
- `air-mentor-api/src/modules/session.ts`
- `air-mentor-api/src/modules/client-telemetry.ts`

### Mandatory checks

- P12-C01: Frontend error containment prevents global shell collapse for local faults
- P12-C02: Backend error typing and HTTP mapping are deterministic and user-safe
- P12-C03: Degradation paths preserve actionable user feedback without false success states
- P12-C04: Retry/backoff semantics avoid duplicate side effects
- P12-C05: Unsafe fallback behavior (silent drops, stale success banners) is eliminated
- P12-C06: Error telemetry contains enough context for postmortem without leaking sensitive data
- P12-C07: Manual recovery guidance exists for non-recoverable user-facing failures

### Race and edge scripts

- P12-R01: Burst of failing requests under degraded backend dependency
- P12-R02: Rapid retry from multiple UI surfaces on same failed mutation
- P12-R03: Error followed by immediate navigation causing stale success render
- P12-R04: Session expiration during active mutation and replay attempt

### Required Finding Output

Use the shared Required Finding Schema including all mandatory schema blocks.

### Required Test Output (Mandatory)

After findings, emit test specs and stubs for every high/critical finding.
Each high/critical degradation defect must include one negative-path test and one recovery-path test.

### Hard pass/fail gates

- Fail if any high/critical fault containment defect is open.
- Fail if any critical degradation path lacks deterministic recovery behavior.
- Fail if high/critical findings lack test specs and stubs.
- Pass only when fault containment and graceful degradation are evidenced.

---

## Prompt 13: Memory Lifecycle, Cleanup Discipline, and Leak Regression Audit

You are an adversarial audit agent. Assume listener/timer/subscription lifecycle bugs accumulate state leaks until proven otherwise.

### Scope and evidence targets

- `src/system-admin-live-app.tsx`
- `src/system-admin-proof-dashboard-workspace.tsx`
- `src/system-admin-request-workspace.tsx`
- `src/system-admin-faculty-calendar-workspace.tsx`
- `src/pages/risk-explorer.tsx`
- `src/pages/student-shell.tsx`
- `src/pages/hod-pages.tsx`
- `src/telemetry.ts`
- `src/proof-playback.ts`
- `air-mentor-api/src/lib/proof-run-queue.ts`
- `air-mentor-api/src/lib/proof-queue-governance.ts`

### Mandatory checks

- P13-C01: Every listener registration has deterministic cleanup under unmount and dependency change
- P13-C02: Timers/intervals are cleaned and cannot continue mutating stale state
- P13-C03: Subscription/observer resources are released on route and scope transitions
- P13-C04: Effect dependency changes do not create unbounded duplicate side effects
- P13-C05: Queue heartbeat and worker loop resources terminate cleanly on stop/retry paths
- P13-C06: Memory growth under remount loops is bounded and measurable
- P13-C07: Leak regressions are tracked with explicit baseline-vs-post-run metrics

### Race and edge scripts

- P13-R01: Repeated mount/unmount cycle stress test
- P13-R02: Scope switching while background polling is active
- P13-R03: Queue retry storm with worker restarts
- P13-R04: Concurrent route transitions and telemetry emissions

### Required Finding Output

Use the shared Required Finding Schema including all mandatory schema blocks.

### Required Test Output (Mandatory)

After findings, emit test specs and stubs for every high/critical finding.
Each high/critical leak finding must include one remount stress test and one baseline-restoration assertion set.

### Hard pass/fail gates

- Fail if any high/critical leak or cleanup defect is open.
- Fail if lifecycle baseline restoration evidence is missing.
- Fail if high/critical findings lack test specs and stubs.
- Pass only when memory lifecycle behavior is bounded and deterministic.

---

## Prompt 14: UX Consistency, Cognitive Load, and Accessibility Cohesion Audit

You are an adversarial audit agent. Assume UX behavior is internally inconsistent across portals until proven otherwise.

### Scope and evidence targets

- `src/system-admin-ui.tsx`
- `src/ui-primitives.tsx`
- `src/theme.ts`
- `src/system-admin-live-app.tsx`
- `src/system-admin-request-workspace.tsx`
- `src/system-admin-faculties-workspace.tsx`
- `src/system-admin-proof-dashboard-workspace.tsx`
- `src/pages/risk-explorer.tsx`
- `src/pages/student-shell.tsx`
- `src/pages/hod-pages.tsx`
- `src/portal-entry.tsx`

### Mandatory checks

- P14-C01: Terminology, statuses, and action labels are consistent across equivalent workflows
- P14-C02: Cognitive load is bounded for high-risk decision screens (clear hierarchy, no ambiguous CTA)
- P14-C03: Error/empty/loading states are coherent and non-contradictory across surfaces
- P14-C04: Keyboard navigation order and focus semantics remain predictable across reusable primitives
- P14-C05: Accessibility semantics stay consistent when components are reused in different contexts
- P14-C06: Mobile and narrow viewport behavior preserves decision-critical controls
- P14-C07: Progressive disclosure and dense data views do not conceal critical state transitions

### Race and edge scripts

- P14-R01: Rapid filter/scope changes under dense tables
- P14-R02: Keyboard-only traversal across nested overlays and dialogs
- P14-R03: Live updates while user is in a decision-critical form
- P14-R04: Responsive layout shifts during ongoing interaction

### Required Finding Output

Use the shared Required Finding Schema including all mandatory schema blocks.

### Required Test Output (Mandatory)

After findings, emit test specs and stubs for every high/critical finding.
Each high/critical UX cohesion defect must include one keyboard/a11y path test and one terminology/label consistency assertion set.

### Hard pass/fail gates

- Fail if any high/critical UX inconsistency or cognitive-load trap is open.
- Fail if cross-surface accessibility semantics are inconsistent on critical workflows.
- Fail if high/critical findings lack test specs and stubs.
- Pass only with proven UX coherence across portals, roles, and viewports.

---

## Automation Strategy Appendix (Concrete Test Spec)

### Appendix A1: Seed Data Shape (Canonical)

Use deterministic seeded fixtures with this minimum shape:

```json
{
  "seedMeta": {
    "seedVersion": "string",
    "generatedAt": "ISO-8601",
    "scenario": "baseline|conflict|stale-checkpoint|accessibility-stress|live-contract|truth-drift|intent-mismatch"
  },
  "users": [
    {
      "id": "string",
      "email": "string",
      "role": "SYSTEM_ADMIN|HOD|FACULTY|STUDENT",
      "active": true
    }
  ],
  "offerings": [
    {
      "id": "string",
      "name": "string",
      "batches": [
        {
          "id": "string",
          "sectionLabels": ["A", "B", "C"]
        }
      ]
    }
  ],
  "students": [
    {
      "id": "string",
      "offeringId": "string",
      "batchId": "string",
      "sectionLabel": "string",
      "mentorFacultyId": "string|null"
    }
  ],
  "requests": [
    {
      "id": "string",
      "status": "pending|approved|needs_info|rejected",
      "version": 1,
      "updatedAt": "ISO-8601"
    }
  ],
  "proof": {
    "activeRunId": "string|null",
    "checkpoints": [
      {
        "checkpointId": "string",
        "studentId": "string",
        "semester": 1,
        "risk": {
          "attendance": 0.0,
          "gpa": 0.0,
          "ceRiskBand": "low|moderate|high"
        },
        "provenance": {
          "sources": ["string"],
          "snapshotVersion": "string"
        }
      }
    ]
  }
}
```

### Appendix A2: Required Fixture Profiles

- `baseline-seed.json`: all happy-path contracts valid
- `conflict-seed.json`: stale versions and concurrent write collisions
- `stale-checkpoint-seed.json`: invalidated playback checkpoint paths
- `accessibility-stress-seed.json`: dense tables, long labels, repeated alerts
- `live-contract-probe-seed.json`: non-destructive live contract verification inputs
- `truth-drift-seed.json`: intentionally conflicting status/checkpoint/report claims
- `intent-mismatch-seed.json`: intentionally mismatched user intent vs implementation behavior

### Appendix A3: Assertion List (Minimum)

Auth and security assertions:
- A-001 login returns session + csrf contract
- A-002 invalid csrf mutation denied
- A-003 logout clears persisted auth-sensitive keys

Admin control-plane assertions:
- A-101 request lifecycle transitions are parity-safe UI/API
- A-102 scope change invalidates stale previews
- A-103 route restore state remains coherent after reload

Proof and parity assertions:
- A-201 explicit checkpoint parity across 3+ surfaces
- A-202 stale checkpoint restoration is rejected safely
- A-203 role-switch parity does not show stale payloads

Runtime contract assertions:
- A-301 deprecated endpoints emit full deprecation headers
- A-302 expectedVersion conflicts fail deterministically
- A-303 scope-bypass writes are rejected

Observability assertions:
- A-401 startup diagnostics classify severity correctly
- A-402 telemetry intake rejects malformed payloads
- A-403 sink outage does not crash request path

UX/accessibility assertions:
- A-501 keyboard-only completion for critical tasks
- A-502 modal focus trap and return focus correctness
- A-503 mobile critical controls remain reachable

Error boundary/leak/ARIA assertions:
- A-601 top-level boundary fallback renders on forced throw
- A-602 surface boundary isolates crash to local surface
- A-603 listener and interval counts return to baseline after unmount/remount loops
- A-604 screen-reader labels/roles/values are valid for all critical controls
- A-605 aria-live announcements are ordered and non-duplicative

Live and recovery assertions:
- A-701 live health/session contracts match code expectations
- A-702 script success claims are semantically true
- A-703 recovery chain can re-enter safely after partial failure

Truth drift and intent assertions:
- A-801 contradiction matrix status matches latest evidence artifacts
- A-802 status/checkpoint/log precedence rules resolve drift deterministically
- A-803 closed findings cannot retain unresolved drift flags
- A-804 feature intent and decision labels remain semantically aligned

Flow, degradation, and lifecycle assertions:
- A-901 interrupted workflows recover without phantom success
- A-902 degradation paths preserve user-safe fallback state
- A-903 remount stress tests restore listener/timer baseline
- A-904 cross-surface UX terminology and state labels remain consistent

### Appendix A4: Pass Criteria

Per-prompt criteria:
- 100 percent mandatory check execution
- 100 percent race script execution
- 0 open critical findings
- 0 open high findings unless hard-blocked with evidence
- 100 percent high/critical test output coverage

Suite-level criteria:
- unified closure matrix rows for P1-P14 are all schema-valid
- no schema validation errors in prompt outputs
- no unresolved truth drift in closed findings
- no open intent mismatch, logic fallacy, or UX integrity high/critical findings
- global gate is PASS
- all required artifacts generated

Flake control criteria:
- each race test repeats at least 3 times
- a test is marked stable only if pass rate is 3/3
- if below 3/3, mark `needs-retest` and block closure

### Appendix A5: Required Artifact Set

- `artifacts/prompt-output-P1.json` ... `artifacts/prompt-output-P14.json`
- `artifacts/unified-closure-matrix.json`
- `artifacts/unified-closure-matrix.md`
- `artifacts/global-gate-verdict.json`
- `artifacts/truth-drift-ledger.json`
- `artifacts/intent-logic-ux-failure-register.md`
- `artifacts/high-critical-test-specs.json`
- `artifacts/high-critical-test-stubs.md`
- `artifacts/blocked-findings-with-resume-steps.md`

---

## Final Rule

No completion claim is valid unless:
- all prompt outputs are schema-valid,
- all mandatory schema blocks are present and valid,
- all high/critical findings have required test output,
- unified closure matrix is complete,
- all truth drift findings are resolved or hard-blocked with resume evidence,
- and Prompt 0 emits global gate `PASS`.
