# Synthesis Pass Prompt v2.0

Objective: synthesize a scoped subsystem from prior ledgers and artifacts into a coherent evidence-backed map without hiding unresolved gaps.

Required outputs:

- synthesis using `templates/final-synthesis-template.md`
- explicit contradictions, confidence levels, and unresolved questions
- exact next implementation and validation steps

Rules:

- cite evidence paths, not vague impressions
- do not compress away unresolved contradictions
- use coverage ledger state to prove the subsystem is ready for synthesis
- if route, role, feature, dependency, data, state, ML, test, UX, or live families remain materially undercovered, refuse premature synthesis and redirect to the missing pass

Completion gate:

- synthesis is allowed only after audit-the-audit confirms the scoped coverage is complete enough
