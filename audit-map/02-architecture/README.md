# Architecture Corpus Status

Status: mapped, but consolidated elsewhere.

This directory is currently empty because the architecture outputs were written into the canonical final-map set instead of being split into per-domain files here.

Use these as the authoritative architecture artifacts:

- `audit-map/15-final-maps/master-system-map.md`
- `audit-map/15-final-maps/route-map.md`
- `audit-map/15-final-maps/dependency-graph.md`
- `audit-map/15-final-maps/state-flow-map.md`
- `audit-map/15-final-maps/live-vs-local-master-diff.md`

Validation notes:

- The architecture/routing family is claim-verified in `audit-map/32-reports/claim-verification-matrix.md` (`CV-001`, `CV-013`).
- This folder being empty is a structure-normalization issue, not by itself proof that architecture was never mapped.
- The audit is still not closure-ready overall; see `audit-map/23-coverage/unreviewed-surface-list.md`.
