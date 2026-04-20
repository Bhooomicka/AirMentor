Recorded the UX friction pass and wrote the supporting audit-map updates.

- Main findings:
  - `C-006` remains the core UX trust gap: the sysadmin request UI still compresses backend `Needs Info` and `Rejected` transitions into a single morphing button.
  - The highest-density friction is in the proof control plane, hierarchy/curriculum binding, course TT setup, and calendar/timetable planning.
  - Mentor, HoD, risk-explorer, and student-shell surfaces are clearer but still carry terminology and drilldown load; the system-admin archive/recycle-bin restore page is comparatively low friction.
  - No new contradiction was added; the pass reinforced the existing mismatch rather than discovering a new one.

- Updated files:
  - [ux-friction-ledger.md](/home/raed/projects/air-mentor-ui/audit-map/11-ux-audit/ux-friction-ledger.md)
  - [coverage-ledger.md](/home/raed/projects/air-mentor-ui/audit-map/23-coverage/coverage-ledger.md)
  - [review-status-by-path.md](/home/raed/projects/air-mentor-ui/audit-map/23-coverage/review-status-by-path.md)
  - [working-knowledge.md](/home/raed/projects/air-mentor-ui/audit-map/24-agent-memory/working-knowledge.md)
  - [known-facts.md](/home/raed/projects/air-mentor-ui/audit-map/24-agent-memory/known-facts.md)
  - [critical-risks.md](/home/raed/projects/air-mentor-ui/audit-map/15-final-maps/critical-risks.md)

- Pass meta:
  - Live verification was not performed.
  - Model/provider/account routing did not change.
  - Caveman was not used.
  - No manual checkpoint is required.
  - Next pass should be `live-behavior-pass`.