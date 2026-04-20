`ml-audit-pass` is complete and persisted into the audit map.

The main outputs are [audit-map/08-ml-audit/README.md](/home/raed/projects/air-mentor-ui/audit-map/08-ml-audit/README.md:1), [audit-map/15-final-maps/ml-system-map.md](/home/raed/projects/air-mentor-ui/audit-map/15-final-maps/ml-system-map.md:1), [audit-map/23-coverage/coverage-ledger.md](/home/raed/projects/air-mentor-ui/audit-map/23-coverage/coverage-ledger.md:1), [audit-map/24-agent-memory/working-knowledge.md](/home/raed/projects/air-mentor-ui/audit-map/24-agent-memory/working-knowledge.md:1), [audit-map/24-agent-memory/known-facts.md](/home/raed/projects/air-mentor-ui/audit-map/24-agent-memory/known-facts.md:1), [audit-map/24-agent-memory/known-ambiguities.md](/home/raed/projects/air-mentor-ui/audit-map/24-agent-memory/known-ambiguities.md:1), plus the pass markers in [audit-map/29-status/audit-air-mentor-ui-bootstrap-ml-audit-pass.status](/home/raed/projects/air-mentor-ui/audit-map/29-status/audit-air-mentor-ui-bootstrap-ml-audit-pass.status:1) and [audit-map/30-checkpoints/audit-air-mentor-ui-bootstrap-ml-audit-pass.checkpoint](/home/raed/projects/air-mentor-ui/audit-map/30-checkpoints/audit-air-mentor-ui-bootstrap-ml-audit-pass.checkpoint:1).

Key findings:
- AirMentor’s proof-risk stack is layered, not one model: deterministic fallback scoring, trained multi-head proof-risk artifacts, deterministic calibration/display suppression, deterministic correlation-driver augmentation, deterministic policy replay and queue heuristics, and UI-only advisory scenario heads.
- The main trained family is the governed proof-risk artifact path in `riskModelArtifacts`; most other “intelligent” behavior is heuristic or rule-based.
- Runtime active recompute can still serve model-shaped output with `fallback-simulated` provenance when checkpoint evidence or graph/history context is missing.
- Curriculum linkage is a mixed pipeline: deterministic matching first, optional Python NLP / `sentence-transformers` next, optional local Ollama assist last.

Verification:
- Passed locally: frontend proof/risk UI tests and backend pure model/heuristic tests.
- Blocked here: fresh route-level backend proof tests and fresh `evaluate:proof-risk-model` regeneration, both due local listener `EPERM`.
- Not done in this pass: fresh live GitHub Pages / Railway verification. I logged that as remaining uncovered scope rather than claiming parity.

No new contradiction was strong enough to elevate into the contradiction matrix from this pass alone; the unresolved issues were recorded as ambiguities and coverage gaps. The next high-value pass is `test-gap-pass`, followed by live proof-behavior verification.