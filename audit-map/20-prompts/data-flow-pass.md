# Data Flow Pass Prompt v2.0

Objective: map field-level data lineage, transformations, readers, writers, caches, shadow copies, replay paths, and persistence boundaries.

Required outputs:

- data-flow entries using `templates/data-flow-template.md`
- field or record family lineage tables with source-of-truth, transformations, sinks, cache layers, duplication points, and drift risks
- read/write tables by role and surface where data visibility or mutation differs
- live-vs-local data divergence notes when applicable

Rules:

- trace specific fields where possible; do not stop at broad nouns like "student data" or "proof data"
- distinguish authoritative source, derived data, cached copies, replay snapshots, and UI-only projections
- record serialization boundaries, transport formats, repository caches, and restore/replay mechanisms
- record where the same underlying truth is filtered or reshaped differently by role or route

Completion gate:

- every critical entity or record family in scope must have an origin, transform path, consumer list, and drift-risk note
