Role-surface pass is mapped locally and persisted into the audit map.

What I covered
- Enumerated the five role families end to end: public/unauthenticated, Course Leader, Mentor, HoD, and `SYSTEM_ADMIN`.
- Captured visible UI, hidden/conditional UI, indirect drilldowns, backend authorization, scope filters, and blocked/locked/error states for each role.
- Recorded cross-role truth coupling for student, course, proof-run, faculty, and request surfaces.
- Recorded the admin request workflow mismatch where the UI only exposes a status-driven path but the backend still supports `Needs Info` and `Rejected`.

Files updated
- [audit-map/15-final-maps/role-feature-matrix.md](/home/raed/projects/air-mentor-ui/audit-map/15-final-maps/role-feature-matrix.md#L1)
- [audit-map/23-coverage/coverage-ledger.md](/home/raed/projects/air-mentor-ui/audit-map/23-coverage/coverage-ledger.md#L8)
- [audit-map/24-agent-memory/working-knowledge.md](/home/raed/projects/air-mentor-ui/audit-map/24-agent-memory/working-knowledge.md#L15)
- [audit-map/24-agent-memory/known-facts.md](/home/raed/projects/air-mentor-ui/audit-map/24-agent-memory/known-facts.md#L32)
- [audit-map/24-agent-memory/known-ambiguities.md](/home/raed/projects/air-mentor-ui/audit-map/24-agent-memory/known-ambiguities.md#L16)
- [audit-map/24-agent-memory/stale-findings-watchlist.md](/home/raed/projects/air-mentor-ui/audit-map/24-agent-memory/stale-findings-watchlist.md#L7)
- [audit-map/14-reconciliation/contradiction-matrix.md](/home/raed/projects/air-mentor-ui/audit-map/14-reconciliation/contradiction-matrix.md#L10)
- [audit-map/14-reconciliation/reconciliation-log.md](/home/raed/projects/air-mentor-ui/audit-map/14-reconciliation/reconciliation-log.md#L10)

What remains uncovered
- Live verification of these role surfaces on deployed GitHub Pages / Railway.
- Feature-atom pass and dependency pass.
- End-to-end confirmation of whether the sysadmin request UI omission is intentional or a missing control path.

Contradictions found
- New contradiction recorded as `C-006` in [contradiction-matrix.md](/home/raed/projects/air-mentor-ui/audit-map/14-reconciliation/contradiction-matrix.md#L10):
- Sysadmin request UI does not expose `Needs Info` / `Rejected`, while the backend still supports those transitions.

Risks discovered
- Bootstrap-derived `allowedRoles` can hide a grant that still exists in the session.
- Cross-surface student truth is role-dependent and easy to misread as equivalent when it is not.
- The admin request queue is narrower in the UI than in the backend transition graph.

Routing / model / account changes
- None.

Caveman
- Not used.

Live verification
- Not performed in this pass.

Next pass
1. `feature-atom-pass`
2. `dependency-pass`

Manual checkpoint
- None required right now.