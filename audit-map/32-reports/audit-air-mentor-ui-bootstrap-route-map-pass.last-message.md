Route-map pass is complete and the audit trail is updated.

Covered:
- Portal hashes: `#/`, `#/app`, `#/admin`
- Academic internal route families: page states, course tabs, student-shell tabs, risk-explorer tabs, HOD tabs, and calendar mode
- Academic bootstrap and restore sources: `mock*` query params, `routeHistory`, `historyBackPage`, `selectedUnlockTaskId`, and related drilldown state
- Sysadmin hash families: overview, proof-dashboard, students, faculty-members, requests, history, and the canonical faculties proof hierarchy
- Sysadmin subviews and persistence: `universityTab`, `selectedSectionCode`, proof-dashboard tabs, proof playback restore state, and route-scoped `sessionStorage` snapshots
- Route-affecting state sources: hash, query string, localStorage, sessionStorage, auth/session restore
- Local-vs-live notes: local parsing and restore behavior are tested; live route capture is deferred to the later live-behavior pass

Updated files:
- [route-map.md](/home/raed/projects/air-mentor-ui/audit-map/15-final-maps/route-map.md)
- [coverage-ledger.md](/home/raed/projects/air-mentor-ui/audit-map/23-coverage/coverage-ledger.md)
- [working-knowledge.md](/home/raed/projects/air-mentor-ui/audit-map/24-agent-memory/working-knowledge.md)
- [route-index.md](/home/raed/projects/air-mentor-ui/audit-map/01-inventory/route-index.md)
- [route-map-pass.status](/home/raed/projects/air-mentor-ui/audit-map/29-status/audit-air-mentor-ui-bootstrap-route-map-pass.status)
- [route-map-pass.checkpoint](/home/raed/projects/air-mentor-ui/audit-map/30-checkpoints/audit-air-mentor-ui-bootstrap-route-map-pass.checkpoint)

Not updated:
- `contradiction-matrix.md` had no new contradictions to record

Residual scope:
- Live GitHub Pages and Railway route capture still belongs in the later live-behavior pass
- Backend endpoint families are still summarized at module level, not exhaustively re-labeled as a separate route ledger pass

Manual checkpoint:
- None required for this pass

I left unrelated dirty worktree changes untouched.