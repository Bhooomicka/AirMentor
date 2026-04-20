# Backend Provenance Pass Prompt v2.0

Objective: deterministically map authoritative data origins, migrations, seeds, artifact lineage, worker completion paths, and provenance drift risks across the backend.

Primary scope:

- `air-mentor-api/src/db/`
- migrations, seed logic, schema definitions, repository/service boundaries
- proof runs, checkpoints, semesters, refresh consumers, queued work, artifact production and consumption
- authoritative versus derived data boundaries

Explicit closure targets (must cover if present):

- proof provenance / count-source explanation family across backend services (prove which fields are authoritative vs derived, and what "count" means in each context)
- proof playback lifecycle helpers (deletion/reset/rebuild semantics, queue visibility gates, stage summary rebuild rules)
- tail and role-specific proof services where the same truth is shaped for sysadmin vs HoD vs student (`*-tail-service`, `*-hod-service`, etc)
- active-run / live-run / section-risk / provisioning helper cluster (`proof-active-run`, `academic-authoritative-first`, `academic-provisioning`, etc)

Required outputs:

- provenance maps for major record families
- migration and seed lineage notes
- worker or cron completion-path mapping
- updates to `data-flow-map.md`, `state-flow-map.md`, `dependency-graph.md`, `master-system-map.md`
- explicit drift-risk notes for stale artifacts, duplicated truths, replay state, and restore state
  - include where two APIs can return different "truth" for the same entity and why

Rules:

- do not accept “database writes happen here” as sufficient provenance
- identify origin, transforms, persistence, replay path, restore path, and consumer list for each major record family
- distinguish authoritative source, derived data, cached copies, snapshots, and UI projections
- if a provenance chain is incomplete, log the exact missing join rather than hand-waving it
- if backend code depends on precomputed artifacts (risk model, embeddings, curriculum linkage), record freshness rules and fallback behavior

Completion gate:

- every critical backend record family in scope must have an origin, transform path, persistence boundary, consumer list, and drift-risk note, or be explicitly blocked with evidence
