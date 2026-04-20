# Same-Student Cross-Surface Parity Pass Prompt v2.0

Objective: determine whether the same underlying student truth stays semantically consistent across sysadmin, HoD, mentor, course leader, and student surfaces, while respecting legitimate scope differences.

Primary scope:

- same-student proof views
- risk and playback surfaces
- checkpoint/run/semester coherence
- fallback-heavy live outputs
- role-conditional shaping of the same underlying truth

Explicit closure targets (must cover if present):

- parity seed generator lineage and whether it stabilizes the intended invariants (`air-mentor-api/scripts/generate-academic-parity-seed.ts`)
- proof provenance / count-source explanation invariants across surfaces
- proof playback lifecycle invariants (what should match across roles vs what can differ)
- live parity: if direct live observation is unsafe, build/require a read-only observer or stop with deterministic manual prerequisites

Required outputs:

- parity matrix keyed to the same student/entity truth
- contradiction entries for any incompatible cross-surface claims
- updates to `role-feature-matrix.md`, `live-vs-local-master-diff.md`, `contradiction-matrix.md`, and `known-ambiguities.md`
- explicit evidence labels: directly observed, inferred, blocked

Rules:

- do not confuse permitted scope differences with semantic contradictions
- identify which fields or behaviors should remain invariant across surfaces and which are legitimately filtered
- record where fallback behavior, stale artifacts, or missing evidence make parity uncertain
- if live credentials are unavailable for a role, log the exact blocker and preserve the next direct-observation step
- treat "same student" as a tuple with stable identifiers (studentId + semester + stage + checkpoint/run identifiers) and record how each surface resolves that tuple

Completion gate:

- this pass is not complete until same-entity cross-surface truth has been explicitly compared, with allowed differences versus contradictions clearly separated
