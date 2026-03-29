# Closeout Prompt Pack Index

This pack is the executable decomposition of `docs/closeout/final-authoritative-plan.md`. Do not edit the authoritative plan while executing this pack. Treat the files below as the only allowed stage order.

## Global Rules
- No stage may start until the predecessor stage is marked `passed` in `output/playwright/execution-ledger.jsonl`.
- No missing artifact is allowed at stage exit. If a command fails, add or update `output/playwright/defect-register.json` before retrying.
- Run every non-trivial verify/build/deploy command through `bash scripts/run-detached.sh <job-name> <command...>` so long jobs survive IDE or terminal closure.
- Deploy the current frontend/backend before continuing live stage proof, and carry forward the lessons in `docs/closeout/operational-execution-rules.md` so later stages do not re-debug known failures.
- Every stage requires both repo-local proof and live GitHub Pages + Railway proof for the affected surfaces.
- Prefer extracted owners first:
  - `src/academic-workspace-route-surface.tsx`
  - `src/system-admin-faculties-workspace.tsx`
  - `src/system-admin-proof-dashboard-workspace.tsx`
  - `air-mentor-api/src/modules/academic-proof-routes.ts`
  - extracted proof-control-plane services under `air-mentor-api/src/lib/`
- Treat these files as integration-only surfaces unless the stage explicitly allows a thin wiring change:
  - `src/App.tsx`
  - `src/system-admin-live-app.tsx`
  - `air-mentor-api/src/modules/academic.ts`
  - `air-mentor-api/src/lib/msruas-proof-control-plane.ts`

## Stage Order
| Stage | File | Predecessor | Focus |
| --- | --- | --- | --- |
| 00A | `stage-00a-pilot-freeze-and-boundaries.md` | none | Freeze pilot slice, proof scope, and route inventory. |
| 00B | `stage-00b-evidence-ledger-and-assertion-backbone.md` | 00A | Create the handoff backbone, annex docs, ledger contract, and evidence pack. |
| 01A | `stage-01a-section-scope-contract.md` | 00B | Promote `section` to an authoritative scope layer across backend, frontend, and proof selectors. |
| 01B | `stage-01b-proof-count-parity-and-provenance.md` | 01A | Make proof-scoped counts authoritative and expose provenance fields. |
| 02A | `stage-02a-faculties-workspace-extraction-parity.md` | 01B | Establish and verify extracted-workspace parity for governance, stage-policy, curriculum, and semester editing. |
| 02B | `stage-02b-proof-control-plane-completion.md` | 02A | Complete the dedicated sysadmin proof control plane and semester activation contract. |
| 03A | `stage-03a-sysadmin-overview-requests-history.md` | 02B | Close parity gaps in overview, reminders, requests, history, and drilldowns. |
| 03B | `stage-03b-sysadmin-hierarchy-students-faculty.md` | 03A | Close parity gaps in hierarchy, students, faculty-members, and registry alignment. |
| 04A | `stage-04a-faculty-profile-course-leader-mentor-parity.md` | 03B | Align faculty profile, course-leader flows, mentor data, and student drilldowns. |
| 04B | `stage-04b-hod-risk-explorer-student-shell-parity.md` | 04A | Align HoD analytics, risk explorer, student shell, and cross-surface proof parity. |
| 05A | `stage-05a-shared-proof-shell-and-tab-contract.md` | 04B | Build the shared proof shell, tab contract, and launcher behavior. |
| 05B | `stage-05b-ux-stability-motion-and-queue-polish.md` | 05A | Remove layout drift, standardize motion, and finish queue/theme polish. |
| 06A | `stage-06a-hierarchy-resolution-and-override-rollback.md` | 05B | Prove scope resolution, override rollback, and cross-surface precedence. |
| 06B | `stage-06b-provisioning-permissions-and-bulk-mentor-assignment.md` | 06A | Complete provisioning, permissions, audit coverage, and mentor bulk apply. |
| 07A | `stage-07a-semester-activation-contract-and-seeded-data.md` | 06B | Add semester activation and deterministic `1..6` seeded proof scaffolding. |
| 07B | `stage-07b-semester-1-to-3-proof-walk.md` | 07A | Walk semesters `1..3` through all checkpoints and acceptance rules. |
| 07C | `stage-07c-semester-4-to-6-proof-walk.md` | 07B | Walk semesters `4..6`, including the live operational semester. |
| 08A | `stage-08a-role-e2e-sysadmin-course-leader-mentor.md` | 07C | Verify sysadmin, course-leader, and mentor end-to-end flows. |
| 08B | `stage-08b-role-e2e-hod-student-session-security.md` | 08A | Verify HoD, student-proof surfaces, denied paths, auth, CSRF, and restore flows. |
| 08C | `stage-08c-live-closeout-proof-pack-completion.md` | 08B | Run the final closeout bar, complete the matrices, and seal the evidence pack. |

## Required Companion Docs
- `stage-gate-protocol.md`
- `assertion-traceability-matrix.md`
- `sysadmin-teaching-proof-coverage-matrix.md`

## Evidence Backbone And Support Docs
- Evidence backbone files:
  - `output/playwright/execution-ledger.jsonl`
  - `output/playwright/proof-evidence-manifest.json`
  - `output/playwright/proof-evidence-index.md`
  - `output/playwright/defect-register.json`
- Stage `00B` support-doc deliverables:
  - `final-authoritative-plan-security-observability-annex.md`
  - `deploy-env-contract.md`
  - `operational-event-taxonomy.md`
- No stage may treat the prompt pack as complete until the backbone files exist, the support docs exist, and all three companion docs above reference the same assertion ids and artifact family.

## Completion Standard
- The pack is not complete until:
  - every stage file exists and follows the stage contract exactly
  - every claim in the authoritative plan is mapped in `assertion-traceability-matrix.md`
  - every sysadmin surface, teaching-profile-reachable surface, and negative path is mapped in `sysadmin-teaching-proof-coverage-matrix.md`
  - the evidence backbone and Stage `00B` support docs exist and are referenced consistently by the companion docs
  - the stage ordering above can be executed without making product-level decisions mid-flight
