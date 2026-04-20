# Proof Evidence Index

This index is the human-readable companion to `output/playwright/proof-evidence-manifest.json` and `output/playwright/execution-ledger.jsonl`.

## Stage 00A

### Command `LOCAL-COMPAT`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-00A-001, ATM-00A-002 | npm run inventory:compat-routes -- --assert-runtime-clean | No file artifact; runtime-clean result is recorded in the Stage 00A ledger row. |

### Command `LOCAL-CLOSEOUT`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 00A--LOCAL-CLOSEOUT--teacher-proof-panel.png | /home/raed/projects/air-mentor-ui/output/playwright/teacher-proof-panel.png | ATM-00A-001, ATM-00A-002 | npm run verify:final-closeout | Proof screenshot captured from the local proof-risk smoke after Semester 6 Post SEE playback selection. |
| 00A--LOCAL-CLOSEOUT--teacher-risk-explorer-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/teacher-risk-explorer-proof.png | ATM-00A-001, ATM-00A-002 | npm run verify:final-closeout | Proof screenshot captured from the local proof-risk smoke after Semester 6 Post SEE playback selection. |
| 00A--LOCAL-CLOSEOUT--hod-proof-analytics.png | /home/raed/projects/air-mentor-ui/output/playwright/hod-proof-analytics.png | ATM-00A-001, ATM-00A-002 | npm run verify:final-closeout | Proof screenshot captured from the local proof-risk smoke after Semester 6 Post SEE playback selection. |
| 00A--LOCAL-CLOSEOUT--hod-risk-explorer-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/hod-risk-explorer-proof.png | ATM-00A-001, ATM-00A-002 | npm run verify:final-closeout | Proof screenshot captured from the local proof-risk smoke after Semester 6 Post SEE playback selection. |
| 00A--LOCAL-CLOSEOUT--student-shell-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/student-shell-proof.png | ATM-00A-001, ATM-00A-002 | npm run verify:final-closeout | Proof screenshot captured from the local proof-risk smoke after Semester 6 Post SEE playback selection. |

### Command `LIVE-CLOSEOUT`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 00A--LIVE-CLOSEOUT--system-admin-live-acceptance-report.json | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-acceptance-report.json | ATM-00A-001, ATM-00A-002 | PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ npm run verify:final-closeout:live | Deployed-stack acceptance report refreshed during Stage 00A live closeout. |
| 00A--LIVE-CLOSEOUT--system-admin-live-acceptance.png | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-acceptance.png | ATM-00A-001, ATM-00A-002 | PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ npm run verify:final-closeout:live | Deployed-stack acceptance screenshot refreshed during Stage 00A live closeout. |
| 00A--LIVE-CLOSEOUT--system-admin-live-request-flow-report.json | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-request-flow-report.json | ATM-00A-001, ATM-00A-002 | PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ npm run verify:final-closeout:live | Deployed-stack request workflow report refreshed during Stage 00A live closeout. |
| 00A--LIVE-CLOSEOUT--system-admin-live-request-flow.png | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-request-flow.png | ATM-00A-001, ATM-00A-002 | PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ npm run verify:final-closeout:live | Deployed-stack request workflow screenshot refreshed during Stage 00A live closeout. |
| 00A--LIVE-CLOSEOUT--system-admin-teaching-parity-smoke.png | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-teaching-parity-smoke.png | ATM-00A-001, ATM-00A-002 | PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ npm run verify:final-closeout:live | Deployed-stack teaching-parity screenshot refreshed during Stage 00A live closeout. |
| 00A--LIVE-CLOSEOUT--system-admin-live-accessibility-report.json | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-accessibility-report.json | ATM-00A-001, ATM-00A-002 | PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ npm run verify:final-closeout:live | Deployed-stack accessibility report refreshed during Stage 00A live closeout. |
| 00A--LIVE-CLOSEOUT--system-admin-live-screen-reader-preflight.md | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-screen-reader-preflight.md | ATM-00A-001, ATM-00A-002 | PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ npm run verify:final-closeout:live | Screen-reader preflight transcript refreshed during Stage 00A live closeout. |
| 00A--LIVE-CLOSEOUT--system-admin-live-accessibility-regression.png | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-accessibility-regression.png | ATM-00A-001, ATM-00A-002 | PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ npm run verify:final-closeout:live | Deployed-stack accessibility screenshot refreshed during Stage 00A live closeout. |
| 00A--LIVE-CLOSEOUT--system-admin-live-keyboard-regression-report.json | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-keyboard-regression-report.json | ATM-00A-001, ATM-00A-002 | PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ npm run verify:final-closeout:live | Deployed-stack keyboard report refreshed during Stage 00A live closeout. |
| 00A--LIVE-CLOSEOUT--system-admin-live-keyboard-regression.png | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-keyboard-regression.png | ATM-00A-001, ATM-00A-002 | PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ npm run verify:final-closeout:live | Deployed-stack keyboard screenshot refreshed during Stage 00A live closeout. |
| 00A--LIVE-CLOSEOUT--system-admin-live-session-security-report.json | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-session-security-report.json | ATM-00A-001, ATM-00A-002 | PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ npm run verify:final-closeout:live | Deployed-stack session-security report refreshed during Stage 00A live closeout. |
| 00A--LIVE-CLOSEOUT--system-admin-proof-control-plane.png | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-proof-control-plane.png | ATM-00A-001, ATM-00A-002 | PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ npm run verify:final-closeout:live | System-admin proof control-plane screenshot refreshed from the deployed proof route at Semester 1 Post SEE. |

### Command `LIVE-CONTRACT`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 00A--LIVE-CONTRACT--railway-live-session-contract.json | /home/raed/projects/air-mentor-ui/output/railway-live-session-contract.json | ATM-00A-001, ATM-00A-002 | RAILWAY_PUBLIC_API_URL=https://api-production-ab72.up.railway.app EXPECTED_FRONTEND_ORIGIN=https://raed2180416.github.io AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> npm --workspace air-mentor-api run verify:live-session-contract | Cross-origin deployed session-contract report referenced by the live closeout bar. |

## Stage 00B

### Command `BACKBONE`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 00B--BACKBONE--execution-ledger.jsonl | /home/raed/projects/air-mentor-ui/output/playwright/execution-ledger.jsonl | ATM-00B-001, ATM-00B-002 | manual Stage 00B backbone normalization | Append-only ledger preserved the existing Stage 00A row and added the Stage 00B pass row. |
| 00B--BACKBONE--proof-evidence-manifest.json | /home/raed/projects/air-mentor-ui/output/playwright/proof-evidence-manifest.json | ATM-00B-001, ATM-00B-002 | manual Stage 00B backbone normalization | Canonical manifest schema now records both Stage 00A and Stage 00B artifact families. |
| 00B--BACKBONE--proof-evidence-index.md | /home/raed/projects/air-mentor-ui/output/playwright/proof-evidence-index.md | ATM-00B-001, ATM-00B-002 | manual Stage 00B backbone normalization | Human-readable index now groups the Stage 00B artifact family by command. |
| 00B--BACKBONE--defect-register.json | /home/raed/projects/air-mentor-ui/output/playwright/defect-register.json | ATM-00B-001, ATM-00B-002 | manual Stage 00B backbone normalization | No Stage 00A or Stage 00B blocking defects were opened, so the canonical register remains empty. |

### Command `DOCS`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 00B--DOCS--final-authoritative-plan-security-observability-annex.md | /home/raed/projects/air-mentor-ui/docs/closeout/final-authoritative-plan-security-observability-annex.md | ATM-00B-001, ATM-00B-002 | manual Stage 00B support-doc creation | Support doc created in Stage 00B and finalized in Stage 08C with the security, observability, and redaction contract tied to the closeout backbone. |
| 00B--DOCS--deploy-env-contract.md | /home/raed/projects/air-mentor-ui/docs/closeout/deploy-env-contract.md | ATM-00B-001, ATM-00B-002 | manual Stage 00B support-doc creation | Support doc created in Stage 00B and finalized in Stage 08C with the live deploy URL, origin, credential, and verification-entrypoint contract. |
| 00B--DOCS--operational-event-taxonomy.md | /home/raed/projects/air-mentor-ui/docs/closeout/operational-event-taxonomy.md | ATM-00B-001, ATM-00B-002 | manual Stage 00B support-doc creation | Support doc created in Stage 00B and finalized in Stage 08C with the current telemetry-vs-audit taxonomy and closeout evidence ownership. |

### Command `LOCAL-CLOSEOUT`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-00B-001, ATM-00B-002 | npm run verify:final-closeout | Repo-local closeout verification passed after the Stage 00B backbone and support-doc work; no new Stage 00B-local artifact family was introduced beyond the normalized backbone files. |

### Command `LIVE-CONTRACT`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 00B--LIVE-CONTRACT--railway-live-session-contract.json | /home/raed/projects/air-mentor-ui/output/railway-live-session-contract.json | ATM-00B-001, ATM-00B-002 | RAILWAY_PUBLIC_API_URL=https://api-production-ab72.up.railway.app EXPECTED_FRONTEND_ORIGIN=https://raed2180416.github.io AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> npm --workspace air-mentor-api run verify:live-session-contract | Cross-origin live session-contract verification re-passed during Stage 00B. |

### Command `LIVE-PROOF`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 00B--LIVE-PROOF--system-admin-proof-control-plane.png | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-proof-control-plane.png | ATM-00B-001, ATM-00B-002 | PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ npm run verify:proof-closure:live | Deployed proof-control-plane screenshot refreshed during the Stage 00B live proof-closure run. |

## Stage 01A

### Command `LOCAL-BACKEND`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-01A-001 | cd air-mentor-api && npx vitest run tests/admin-hierarchy.test.ts tests/admin-control-plane.test.ts tests/academic-access.test.ts | Repo-local backend proof passed for canonical `<batchId>::<SECTION>` scope ids, section-over-batch precedence, section stage-policy rollback, and invalid section scope-id rejection. |

### Command `LOCAL-FRONTEND`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-01A-001 | npm test -- --run tests/system-admin-live-data.test.ts tests/system-admin-accessibility-contracts.test.tsx | Repo-local frontend proof passed for section governance chain construction, section-aware governance messaging, and distinct batch-vs-section snapshot keys without changing the admin route hash shape. |

### Command `LIVE-ACCEPTANCE`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 01A--LIVE-ACCEPTANCE--system-admin-live-acceptance-report.json | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-acceptance-report.json | ATM-01A-001 | PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:acceptance | Deployed-stack acceptance report refreshed after section became an authoritative governance scope. |
| 01A--LIVE-ACCEPTANCE--system-admin-live-acceptance.png | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-acceptance.png | ATM-01A-001 | PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:acceptance | Deployed-stack acceptance screenshot refreshed after section became an authoritative governance scope. |

### Command `LIVE-TEACHING`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 01A--LIVE-TEACHING--system-admin-teaching-parity-smoke.png | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-teaching-parity-smoke.png | ATM-01A-001 | PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:teaching-parity | Deployed-stack teaching-parity screenshot refreshed after the section-scope contract rollout. |

## Stage 01B

### Command `LOCAL-BACKEND`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-01B-001, ATM-01B-002 | cd air-mentor-api && timeout 420s npx vitest run --maxWorkers=1 --reporter=verbose tests/admin-hierarchy.test.ts tests/admin-control-plane.test.ts tests/academic-access.test.ts tests/risk-explorer.test.ts tests/student-agent-shell.test.ts | Targeted backend proof passed for resolved-policy provenance, proof-bundle provenance, and proof-scoped defaults across risk explorer and student shell routes. |

### Command `LOCAL-HOD`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-01B-001, ATM-01B-002 | cd air-mentor-api && timeout 240s npx vitest run --maxWorkers=1 --reporter=verbose tests/hod-proof-analytics.test.ts | HoD checkpoint analytics proof passed with checkpoint-scoped totals, backlog distribution parity, and provenance fields on the summary payload. |

### Command `LOCAL-FRONTEND`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-01B-001, ATM-01B-002 | npm test -- --run tests/faculty-profile-proof.test.tsx tests/hod-pages.test.ts tests/risk-explorer.test.tsx tests/student-shell.test.tsx tests/system-admin-proof-dashboard-workspace.test.tsx tests/system-admin-accessibility-contracts.test.tsx | Targeted frontend proof passed for shared provenance messaging and unavailable-state copy across all proof-aware surfaces. |

### Command `LOCAL-PROOF`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 01B--LOCAL-PROOF--teacher-proof-panel.png | /home/raed/projects/air-mentor-ui/output/playwright/teacher-proof-panel.png | ATM-01B-001, ATM-01B-002 | npm run verify:proof-closure:proof-rc | Repo-local proof closure refreshed the teacher proof panel after Semester 6 Post SEE provenance rollout. |
| 01B--LOCAL-PROOF--teacher-risk-explorer-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/teacher-risk-explorer-proof.png | ATM-01B-001, ATM-01B-002 | npm run verify:proof-closure:proof-rc | Repo-local proof closure refreshed the course-leader risk explorer after Semester 6 Post SEE provenance rollout. |
| 01B--LOCAL-PROOF--hod-proof-analytics.png | /home/raed/projects/air-mentor-ui/output/playwright/hod-proof-analytics.png | ATM-01B-001, ATM-01B-002 | npm run verify:proof-closure:proof-rc | Repo-local proof closure refreshed the HoD analytics surface after Semester 6 Post SEE provenance rollout. |
| 01B--LOCAL-PROOF--hod-risk-explorer-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/hod-risk-explorer-proof.png | ATM-01B-001, ATM-01B-002 | npm run verify:proof-closure:proof-rc | Repo-local proof closure refreshed the HoD risk explorer after Semester 6 Post SEE provenance rollout. |
| 01B--LOCAL-PROOF--student-shell-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/student-shell-proof.png | ATM-01B-001, ATM-01B-002 | npm run verify:proof-closure:proof-rc | Repo-local proof closure refreshed the student shell after Semester 6 Post SEE provenance rollout. |

### Command `LIVE-PROOF`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 01B--LIVE-PROOF--system-admin-proof-control-plane.png | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-proof-control-plane.png | ATM-01B-001, ATM-01B-002 | PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ npm run verify:proof-closure:live | Deployed proof-control-plane screenshot refreshed during Stage 01B live proof closure at the active Post SEE checkpoint. |

### Command `LIVE-TEACHING`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 01B--LIVE-TEACHING--system-admin-teaching-parity-smoke.png | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-teaching-parity-smoke.png | ATM-01B-001 | PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:teaching-parity | Deployed teaching-parity screenshot refreshed after proof-count provenance reached the shared academic surfaces. |

### Command `LIVE-ACCEPTANCE`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 01B--LIVE-ACCEPTANCE--system-admin-live-acceptance-report.json | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-acceptance-report.json | ATM-01B-002 | PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:acceptance | Deployed acceptance report refreshed after the 01B provenance fields landed in the admin-facing contract surface. |
| 01B--LIVE-ACCEPTANCE--system-admin-live-acceptance.png | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-acceptance.png | ATM-01B-002 | PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:acceptance | Deployed acceptance screenshot refreshed after the 01B provenance rollout. |

## Stage 02A

### Command `LOCAL-FRONTEND`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-02A-001 | npm test -- --run tests/system-admin-faculties-workspace.test.tsx tests/system-admin-accessibility-contracts.test.tsx tests/system-admin-proof-dashboard-workspace.test.tsx tests/api-client.test.ts tests/live-admin-common.test.ts tests/railway-deploy-readiness.test.ts tests/verify-final-closeout-live.test.ts | Repo-local frontend proof passed for extracted-workspace parity, workspace accessibility contracts, proof dashboard affordances, and deterministic live-wrapper coverage. |

### Command `LIVE-TEACHING`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 02A--LIVE-TEACHING--system-admin-teaching-parity-smoke.png | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-teaching-parity-smoke.png | ATM-02A-001 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:teaching-parity | Refreshed teaching-parity screenshot confirms the extracted faculties workspace remains aligned with teaching-facing surfaces on the live stack. |

### Command `LIVE-ACCEPTANCE`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 02A--LIVE-ACCEPTANCE--system-admin-live-acceptance-report.json | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-acceptance-report.json | ATM-02A-001 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:acceptance | Refreshed acceptance report confirms Overview, Bands, CE / SEE, CGPA Formula, Stage Gates, Courses, and Provision all pass from the extracted faculties workspace on the deployed stack. |
| 02A--LIVE-ACCEPTANCE--system-admin-live-acceptance.png | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-acceptance.png | ATM-02A-001 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:acceptance | Refreshed acceptance screenshot supersedes the earlier Pages drift blocker and shows the extracted faculties workspace active on the live stack. |

Historical Stage 02A failure artifacts remain in the manifest for traceability, but the deployed-stack blocker is now closed and the stage is passed.


## Stage 02B

### Command `LOCAL-FRONTEND`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-02B-001, ATM-02B-002, ATM-07A-001 | npm test -- --run tests/system-admin-faculties-workspace.test.tsx tests/system-admin-accessibility-contracts.test.tsx tests/system-admin-proof-dashboard-workspace.test.tsx tests/api-client.test.ts tests/live-admin-common.test.ts tests/railway-deploy-readiness.test.ts tests/verify-final-closeout-live.test.ts | Frontend proof passed for semester activation controls, playback-override messaging, extracted-workspace accessibility coverage, and live-auth/preflight hardening. |

### Command `LOCAL-BUILD`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-02B-001, ATM-02B-002, ATM-07A-001 | npm --workspace air-mentor-api run build | Backend build passed after the activation contract, activeOperationalSemester persistence, and proof-context propagation changes landed. |

### Command `LOCAL-OPENAPI`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-02B-001, ATM-02B-002, ATM-07A-001 | cd air-mentor-api && timeout 240s npx vitest run --maxWorkers=1 --reporter=verbose tests/openapi.test.ts -u | OpenAPI proof passed with `POST /api/admin/proof-runs/:simulationRunId/activate-semester` recorded in the public backend contract. |

### Command `LOCAL-ADMIN-CONTROL`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-02B-001, ATM-02B-002, ATM-07A-001 | cd air-mentor-api && timeout 420s npx vitest run --maxWorkers=1 --reporter=verbose tests/admin-control-plane.test.ts | Admin proof-control-plane backend proof passed with semester activation, queue/worker diagnostics, and activeOperationalSemester propagation. |

### Command `LOCAL-HOD`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-02B-001, ATM-02B-002, ATM-07A-001 | cd air-mentor-api && timeout 420s npx vitest run --maxWorkers=1 --reporter=verbose tests/hod-proof-analytics.test.ts | HoD analytics proof passed with activated-semester context while explicit playback remained a separate override. |

### Command `LOCAL-RISK`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-02B-001, ATM-02B-002, ATM-07A-001 | cd air-mentor-api && timeout 420s npx vitest run --maxWorkers=1 --reporter=verbose tests/risk-explorer.test.ts | Risk explorer proof passed with activeOperationalSemester as the default proof context when playback is not explicitly pinned. |

### Command `LOCAL-STUDENT`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-02B-001, ATM-02B-002, ATM-07A-001 | cd air-mentor-api && timeout 420s npx vitest run --maxWorkers=1 --reporter=verbose tests/student-agent-shell.test.ts | Student shell proof passed with activeOperationalSemester kept separate from explicit checkpoint playback. |

### Command `LOCAL-PROOF`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 02B--LOCAL-PROOF--teacher-proof-panel.png | /home/raed/projects/air-mentor-ui/output/playwright/teacher-proof-panel.png | ATM-02B-001, ATM-02B-002, ATM-07A-001 | npm run verify:proof-closure:proof-rc | Repo-local proof closure refreshed the teacher proof panel after semester activation and proof-context propagation landed. |
| 02B--LOCAL-PROOF--teacher-risk-explorer-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/teacher-risk-explorer-proof.png | ATM-02B-001, ATM-02B-002, ATM-07A-001 | npm run verify:proof-closure:proof-rc | Repo-local proof closure refreshed the course-leader risk explorer with activated-semester defaults intact. |
| 02B--LOCAL-PROOF--hod-proof-analytics.png | /home/raed/projects/air-mentor-ui/output/playwright/hod-proof-analytics.png | ATM-02B-001, ATM-02B-002, ATM-07A-001 | npm run verify:proof-closure:proof-rc | Repo-local proof closure refreshed the HoD analytics surface after the activation contract rollout. |
| 02B--LOCAL-PROOF--hod-risk-explorer-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/hod-risk-explorer-proof.png | ATM-02B-001, ATM-02B-002, ATM-07A-001 | npm run verify:proof-closure:proof-rc | Repo-local proof closure refreshed the HoD risk explorer after the activation contract rollout. |
| 02B--LOCAL-PROOF--student-shell-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/student-shell-proof.png | ATM-02B-001, ATM-02B-002, ATM-07A-001 | npm run verify:proof-closure:proof-rc | Repo-local proof closure refreshed the student shell with activeOperationalSemester as the default proof context outside explicit playback. |

### Command `LIVE-PROOF`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 02B--LIVE-PROOF--system-admin-proof-control-plane.png | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-proof-control-plane.png | ATM-02B-001, ATM-02B-002, ATM-07A-001 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ npm run verify:proof-closure:live | Refreshed deployed proof-control-plane screenshot confirms the semester-activation capable dashboard remains healthy after the predecessor blocker cleared. |

### Command `LIVE-TEACHING`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 02B--LIVE-TEACHING--system-admin-teaching-parity-smoke.png | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-teaching-parity-smoke.png | ATM-02B-001 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:teaching-parity | Refreshed deployed teaching-parity screenshot confirms the proof control-plane completion did not regress teaching-facing parity. |

### Command `LIVE-ACCEPTANCE`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 02B--LIVE-ACCEPTANCE--system-admin-live-acceptance-report.json | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-acceptance-report.json | ATM-02B-001 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:acceptance | Refreshed acceptance report confirms the proof control plane remains reachable inside the extracted faculties workspace after 02A re-cleared on the live stack. |
| 02B--LIVE-ACCEPTANCE--system-admin-live-acceptance.png | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-acceptance.png | ATM-02B-001 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:acceptance | Refreshed acceptance screenshot confirms the completed proof control plane coexists with the extracted faculties workspace on the deployed stack. |

## Stage 03A

### Command `LOCAL-BACKEND`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-03A-001, ATM-03A-002 | cd air-mentor-api && npx vitest run tests/admin-foundation.test.ts tests/admin-hierarchy.test.ts | Backend proof passed for request decision flow audit detail, chronological notes/transitions ordering, and scoped request/hierarchy behavior. |

### Command `LOCAL-FRONTEND`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-03A-001, ATM-03A-002 | npm test -- --run tests/system-admin-live-data.test.ts tests/system-admin-ui.test.tsx tests/portal-routing.test.ts tests/system-admin-overview-helpers.test.ts | Frontend proof passed for extracted overview scoped-count helpers, request search shaping, admin deep-link parsing, and workspace rendering contracts. |

### Command `LIVE-ACCEPTANCE`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 03A--LIVE-ACCEPTANCE--system-admin-live-acceptance-report.json | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-acceptance-report.json | ATM-03A-001 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:acceptance | Refreshed deployed acceptance report confirms overview refresh, workspace navigation, hierarchy refresh, and request closeout still pass on the current live stack. |
| 03A--LIVE-ACCEPTANCE--system-admin-live-acceptance.png | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-acceptance.png | ATM-03A-001 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:acceptance | Refreshed deployed acceptance screenshot rerecords the overview-bearing sysadmin surface for Stage 03A parity. |

### Command `LIVE-REQUESTS`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 03A--LIVE-REQUESTS--system-admin-live-request-flow-report.json | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-request-flow-report.json | ATM-03A-002 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:request-flow | Refreshed deployed request-flow report confirms request list open, detail open, deep-link persistence, and closeout on the live stack. |
| 03A--LIVE-REQUESTS--system-admin-live-request-flow.png | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-request-flow.png | ATM-03A-002 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:request-flow | Refreshed deployed request-flow screenshot captures the request detail surface after the Stage 03A parity hardening. |

### Command `LIVE-KEYBOARD`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 03A--LIVE-KEYBOARD--system-admin-live-keyboard-regression-report.json | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-keyboard-regression-report.json | ATM-03A-002 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:keyboard-regression | Refreshed deployed keyboard report confirms request-flow keyboard navigation, modal focus restore, portal switching, and proof playback reset all pass live. |
| 03A--LIVE-KEYBOARD--system-admin-live-keyboard-regression.png | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-keyboard-regression.png | ATM-03A-002 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:keyboard-regression | Refreshed deployed keyboard screenshot captures the live request/proof navigation path after the Stage 03A parity fixes. |

## Stage 03B

### Command `LOCAL-BACKEND`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-03B-001, ATM-03B-002, ATM-03B-003 | cd air-mentor-api && npx vitest run tests/admin-hierarchy.test.ts tests/academic-access.test.ts tests/academic-parity.test.ts | Backend proof passed for section-aware student provenance, labeled faculty appointments/grants, and ownership-derived faculty operational context. |

### Command `LOCAL-FRONTEND`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-03B-001, ATM-03B-002, ATM-03B-003 | npm test -- --run tests/system-admin-live-data.test.ts tests/system-admin-accessibility-contracts.test.tsx tests/system-admin-ui.test.tsx | Frontend proof passed for extracted registry helpers, hierarchy accessibility linkage, and student/faculty proof-banner formatting contracts. |

### Command `LIVE-ACCEPTANCE`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 03B--LIVE-ACCEPTANCE--system-admin-live-acceptance-report.json | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-acceptance-report.json | ATM-03B-001, ATM-03B-002, ATM-03B-003 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:acceptance | Refreshed deployed acceptance report confirms hierarchy navigation plus student and faculty detail parity remain aligned on the live stack. |
| 03B--LIVE-ACCEPTANCE--system-admin-live-acceptance.png | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-acceptance.png | ATM-03B-001, ATM-03B-002, ATM-03B-003 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:acceptance | Refreshed deployed acceptance screenshot rerecords the hierarchy, student, and faculty-bearing sysadmin surface for Stage 03B. |

### Command `LIVE-A11Y`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 03B--LIVE-A11Y--system-admin-live-accessibility-report.json | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-accessibility-report.json | ATM-03B-001, ATM-03B-003 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:accessibility-regression | Live accessibility report confirms proof/admin surfaces, including faculty detail tabs, still satisfy the Stage 03B keyboard and semantics contract. |
| 03B--LIVE-A11Y--system-admin-live-accessibility-regression.png | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-accessibility-regression.png | ATM-03B-001, ATM-03B-003 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:accessibility-regression | Live accessibility screenshot captures the post-regression system-admin route used for the Stage 03B a11y sweep. |
| 03B--LIVE-A11Y--system-admin-live-screen-reader-preflight.md | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-screen-reader-preflight.md | ATM-03B-001, ATM-03B-003 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:accessibility-regression | Screen-reader preflight transcript records the live route discovery and focused accessibility walkthrough used before the Stage 03B axe pass. |

## Stage 04A

### Command `LOCAL-BACKEND`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-04A-001, ATM-04A-002, ATM-04A-003 | cd air-mentor-api && npx vitest run tests/academic-parity.test.ts tests/academic-access.test.ts tests/academic-runtime-narrow-routes.test.ts | Backend proof passed for faculty profile, course-leader, mentor, queue-history, and narrowed academic runtime routes with proof provenance intact. |

### Command `LOCAL-FRONTEND`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-04A-001, ATM-04A-002, ATM-04A-003 | npm test -- --run tests/faculty-profile-proof.test.tsx tests/academic-route-pages.test.tsx tests/academic-workspace-route-surface.test.tsx tests/academic-workspace-route-helpers.test.ts tests/portal-routing.test.ts | Frontend proof passed for the extracted faculty profile surface, shared proof summary strip, route helpers, and partial-profile/deep-link parity. |

### Command `LIVE-TEACHING`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 04A--LIVE-TEACHING--system-admin-teaching-parity-smoke.png | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-teaching-parity-smoke.png | ATM-04A-001, ATM-04A-002, ATM-04A-003 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> AIRMENTOR_LIVE_TEACHER_IDENTIFIER=devika.shetty PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:teaching-parity | Refreshed deployed faculty-profile parity screenshot anchors the Stage 04A teaching path after the extracted academic route surfaces landed. |
| 04A--LIVE-TEACHING--course-leader-dashboard-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/course-leader-dashboard-proof.png | ATM-04A-001 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> AIRMENTOR_LIVE_TEACHER_IDENTIFIER=devika.shetty PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:teaching-parity | Refreshed deployed course-leader dashboard screenshot shows the shared proof summary strip aligned to the active faculty proof context. |
| 04A--LIVE-TEACHING--mentor-view-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/mentor-view-proof.png | ATM-04A-002 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> AIRMENTOR_LIVE_TEACHER_IDENTIFIER=devika.shetty PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:teaching-parity | Refreshed deployed mentor screenshot confirms mentor assignments and summary metrics remain live-data-driven. |
| 04A--LIVE-TEACHING--queue-history-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/queue-history-proof.png | ATM-04A-001, ATM-04A-003 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> AIRMENTOR_LIVE_TEACHER_IDENTIFIER=devika.shetty PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:teaching-parity | Refreshed deployed queue-history screenshot confirms the proof summary strip stays aligned when the teaching role switches into the queue surface. |

### Command `LIVE-TEACHING-PROOF`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 04A--LIVE-TEACHING-PROOF--system-admin-proof-control-plane.png | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-proof-control-plane.png | ATM-04A-001 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> AIRMENTOR_LIVE_TEACHER_IDENTIFIER=kavitha.rao PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ npm run verify:proof-closure:teaching-live | Refreshed deployed proof-control-plane screenshot confirms Stage 04A rerecorded the same Post SEE checkpoint before handing off HoD/risk/student strictness to Stage 04B. |
| 04A--LIVE-TEACHING-PROOF--teacher-proof-panel.png | /home/raed/projects/air-mentor-ui/output/playwright/teacher-proof-panel.png | ATM-04A-001 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> AIRMENTOR_LIVE_TEACHER_IDENTIFIER=kavitha.rao PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ npm run verify:proof-closure:teaching-live | Refreshed deployed teacher proof panel screenshot confirms the teaching-only live proof path stops after the teacher/control-plane contract for Stage 04A. |

## Stage 04B

### Command `LOCAL-BACKEND`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-04B-001, ATM-04A-003 | cd air-mentor-api && timeout 900s npx vitest run --maxWorkers=1 --reporter=verbose tests/hod-proof-analytics.test.ts tests/risk-explorer.test.ts tests/student-agent-shell.test.ts tests/academic-access.test.ts | Backend proof passed for HoD analytics, risk explorer, student shell, and academic access with sibling-branch scope, duplicate grants, out-of-scope behavior, archived-run inspection, and activated-semester playback covered. |

### Command `LOCAL-FRONTEND`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-04B-001, ATM-04A-003 | npm test -- --run tests/hod-pages.test.ts tests/risk-explorer.test.tsx tests/student-shell.test.tsx | Frontend proof passed for HoD overview, risk explorer, and student shell proof-section contracts across 3 files and 9 tests. |

### Command `LIVE-PROOF`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 04B--LIVE-PROOF--hod-proof-analytics.png | /home/raed/projects/air-mentor-ui/output/playwright/hod-proof-analytics.png | ATM-04B-001 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> AIRMENTOR_LIVE_TEACHER_IDENTIFIER=kavitha.rao PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ npm run verify:proof-closure:live | Refreshed deployed HoD analytics screenshot confirms the live Post SEE proof context now resolves for HoD summary tabs instead of falling into a false inactive state. |
| 04B--LIVE-PROOF--hod-risk-explorer-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/hod-risk-explorer-proof.png | ATM-04B-001 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> AIRMENTOR_LIVE_TEACHER_IDENTIFIER=kavitha.rao PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ npm run verify:proof-closure:live | Refreshed deployed HoD risk explorer screenshot confirms HoD drilldowns inherit the same active checkpoint used by the analytics surface. |
| 04B--LIVE-PROOF--student-shell-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/student-shell-proof.png | ATM-04B-001, ATM-04A-003 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> AIRMENTOR_LIVE_TEACHER_IDENTIFIER=kavitha.rao PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ npm run verify:proof-closure:live | Refreshed deployed student-shell screenshot confirms the HoD-to-student drilldown stays proof-bounded on the same live checkpoint. |

### Command `LIVE-KEYBOARD`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 04B--LIVE-KEYBOARD--system-admin-live-keyboard-regression-report.json | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-keyboard-regression-report.json | ATM-04B-001, ATM-04A-003 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:keyboard-regression | Refreshed deployed keyboard report confirms proof-dashboard playback controls, academic-portal handoff, and restore/reset navigation remain stable after the HoD parity fix. |
| 04B--LIVE-KEYBOARD--system-admin-live-keyboard-regression.png | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-keyboard-regression.png | ATM-04B-001, ATM-04A-003 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:keyboard-regression | Refreshed deployed keyboard screenshot anchors the same restore-path regression run used to validate 04B drilldown stability. |

### Command `LIVE-A11Y`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 04B--LIVE-A11Y--system-admin-live-accessibility-report.json | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-accessibility-report.json | ATM-04B-001 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:accessibility-regression | Refreshed deployed accessibility report confirms proof dashboard, academic portal, teacher risk explorer, and related parity surfaces stay accessible on the current stack. |
| 04B--LIVE-A11Y--system-admin-live-screen-reader-preflight.md | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-screen-reader-preflight.md | ATM-04B-001 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:accessibility-regression | Refreshed deployed screen-reader preflight notes document the same accessibility regression session recorded for Stage 04B. |
| 04B--LIVE-A11Y--system-admin-live-accessibility-regression.png | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-accessibility-regression.png | ATM-04B-001 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:accessibility-regression | Refreshed deployed accessibility screenshot anchors the 04B live a11y rerun after the HoD proof fix propagated. |

### Command `LIVE-DENIED`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 04B--LIVE-DENIED--hod-proof-invalid-checkpoint-live.json | /home/raed/projects/air-mentor-ui/output/playwright/hod-proof-invalid-checkpoint-live.json | ATM-04B-001 | js_repl live API probe: login kavitha.rao as HOD, fetch a real in-scope HoD student from proof-bundle, then request /api/academic/students/:studentId/risk-explorer with simulationStageCheckpointId=stage_checkpoint_invalid_04b | Live negative-path artifact confirms invalid checkpoint playback returns explicit `404 NOT_FOUND` instead of producing a false proof state. |

## Stage 05A

### Command `LOCAL-FRONTEND`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-05A-001 | npm test -- --run tests/system-admin-accessibility-contracts.test.tsx tests/proof-surface-shell.test.tsx tests/system-admin-proof-dashboard-workspace.test.tsx tests/faculty-profile-proof.test.tsx tests/hod-pages.test.ts tests/risk-explorer.test.tsx tests/student-shell.test.tsx | Frontend proof passed for shared proof-shell owner markers, launcher adoption, direct owner coverage, and proof-section tab semantics across system-admin, faculty proof, HoD, risk explorer, and student shell surfaces. |

### Command `LOCAL-BUILD`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-05A-001 | npm run build | Frontend build passed after the proof-hero contrast fix that was republished to GitHub Pages for the live 05A reruns. |

### Command `LIVE-A11Y`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 05A--LIVE-A11Y--system-admin-live-accessibility-report.json | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-accessibility-report.json | ATM-05A-001 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:accessibility-regression | Refreshed deployed accessibility report confirms the shared proof shell, launcher, proof dashboard, academic portal, teacher risk explorer, and faculty-detail semantics pass after the contrast fix propagated. |
| 05A--LIVE-A11Y--system-admin-live-screen-reader-preflight.md | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-screen-reader-preflight.md | ATM-05A-001 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:accessibility-regression | Screen-reader preflight transcript records the same live shared-shell accessibility walkthrough used for the Stage 05A axe pass. |
| 05A--LIVE-A11Y--system-admin-live-accessibility-regression.png | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-accessibility-regression.png | ATM-05A-001 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:accessibility-regression | Refreshed deployed accessibility screenshot anchors the republished shared proof-shell surface after the 05A contrast defect was closed. |

### Command `LIVE-KEYBOARD`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 05A--LIVE-KEYBOARD--system-admin-live-keyboard-regression-report.json | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-keyboard-regression-report.json | ATM-05A-001 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:keyboard-regression | Refreshed deployed keyboard report confirms request-flow navigation, proof launcher focus, checkpoint controls, portal switching, teacher proof traversal, and playback restore/reset all pass under the shared shell contract. |
| 05A--LIVE-KEYBOARD--system-admin-live-keyboard-regression.png | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-keyboard-regression.png | ATM-05A-001 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:keyboard-regression | Refreshed deployed keyboard screenshot anchors the same live restore-path regression run used to validate Stage 05A launcher and tab behavior. |

### Command `LIVE-PROOF`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 05A--LIVE-PROOF--system-admin-proof-control-plane.png | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-proof-control-plane.png | ATM-05A-001 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run verify:proof-closure:live | Refreshed deployed proof-control-plane screenshot confirms the shared proof shell and launcher are live on the republished Post SEE control-plane route. |
| 05A--LIVE-PROOF--teacher-proof-panel.png | /home/raed/projects/air-mentor-ui/output/playwright/teacher-proof-panel.png | ATM-05A-001 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run verify:proof-closure:live | Refreshed deployed teacher proof-panel screenshot confirms the faculty proof surface now consumes the shared proof hero and launcher contract on the same live checkpoint. |
| 05A--LIVE-PROOF--hod-proof-analytics.png | /home/raed/projects/air-mentor-ui/output/playwright/hod-proof-analytics.png | ATM-05A-001 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run verify:proof-closure:live | Refreshed deployed HoD analytics screenshot confirms the shared proof shell tabs and banner placement remain aligned on the live Post SEE checkpoint. |
| 05A--LIVE-PROOF--hod-risk-explorer-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/hod-risk-explorer-proof.png | ATM-05A-001 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run verify:proof-closure:live | Refreshed deployed HoD risk-explorer screenshot proves the shared risk-explorer shell on the same checkpoint used by the Stage 05A proof walk. |
| 05A--LIVE-PROOF--student-shell-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/student-shell-proof.png | ATM-05A-001 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run verify:proof-closure:live | Refreshed deployed student-shell screenshot confirms the shared proof shell remains stable after the HoD drilldown on the live Post SEE checkpoint. |

Teacher row-backed monitoring/elective-fit drilldown was not available on the selected live Post SEE checkpoint during the Stage 05A proof walk, so risk-explorer proof evidence is intentionally anchored by the shared HoD risk-explorer surface instead of a second teacher-specific screenshot.

## Stage 05B

### Command `LOCAL-FRONTEND`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-05B-001 | npm test -- --run tests/system-admin-ui.test.tsx tests/system-admin-action-queue.test.ts tests/system-admin-accessibility-contracts.test.tsx | Frontend queue and accessibility contracts passed for bulk hide/restore controls, shared queue chrome, and contrast-safe reminder CTA behavior across 3 targeted test files and 12 assertions. |

### Command `LOCAL-BUILD`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-05B-001 | npm run build | Frontend build passed after the shared queue badge and quick-action contrast fix was republished for the live 05B reruns. |

### Command `LIVE-ACCEPTANCE`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 05B--LIVE-ACCEPTANCE--system-admin-live-acceptance-report.json | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-acceptance-report.json | ATM-05B-001 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:acceptance | Refreshed deployed acceptance report confirms request detail, queue rail, reminder CTA, and proof/dashboard navigation remain stable after the 05B queue polish republish. |
| 05B--LIVE-ACCEPTANCE--system-admin-live-acceptance.png | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-acceptance.png | ATM-05B-001 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:acceptance | Refreshed deployed acceptance screenshot anchors the republished queue-control shell and request-detail surface used for the Stage 05B pass. |

### Command `LIVE-A11Y`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 05B--LIVE-A11Y--system-admin-live-accessibility-report.json | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-accessibility-report.json | ATM-05B-001 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:accessibility-regression | Refreshed deployed accessibility report confirms the request-detail queue chrome, reminder CTA, proof dashboard, academic portal handoff, and faculty-detail semantics all pass after the 05B contrast fix. |
| 05B--LIVE-A11Y--system-admin-live-screen-reader-preflight.md | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-screen-reader-preflight.md | ATM-05B-001 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:accessibility-regression | Screen-reader preflight transcript records the same live queue/shell accessibility walkthrough used for the Stage 05B axe pass. |
| 05B--LIVE-A11Y--system-admin-live-accessibility-regression.png | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-accessibility-regression.png | ATM-05B-001 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:accessibility-regression | Refreshed deployed accessibility screenshot anchors the republished request-detail queue rail after the 05B contrast defect was closed. |

### Command `LIVE-KEYBOARD`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 05B--LIVE-KEYBOARD--system-admin-live-keyboard-regression-report.json | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-keyboard-regression-report.json | ATM-05B-001 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:keyboard-regression | Refreshed deployed keyboard report confirms request-flow navigation, queue focus order, proof-dashboard traversal, academic-portal handoff, and playback restore/reset all remain stable after the queue polish republish. |
| 05B--LIVE-KEYBOARD--system-admin-live-keyboard-regression.png | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-keyboard-regression.png | ATM-05B-001 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:keyboard-regression | Refreshed deployed keyboard screenshot anchors the same live restore-path regression run used to validate Stage 05B queue and shell behavior. |

The initial live 05B accessibility failure on the queue count badge and reminder CTA is closed after GitHub Pages deploy run `23749718170` served `index-icg13pEx.js` plus `app-shared-CaDGII2H.js` with `#1d4ed8` and `#b91c1c`; the rerun artifacts above are the authoritative pass evidence for Stage 05B.

## Stage 06A

### Command `LOCAL-BACKEND`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-06A-001 | env -C air-mentor-api npx vitest run tests/admin-hierarchy.test.ts tests/admin-control-plane.test.ts tests/policy-phenotypes.test.ts | Backend hierarchy suites passed with section-aware resolved policy/stage-policy lineage plus rollback fallback coverage across 17 passing tests and 5 intentional skips. |

### Command `LOCAL-FRONTEND`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-06A-001 | npm test -- --run tests/system-admin-live-data.test.ts tests/system-admin-accessibility-contracts.test.tsx tests/system-admin-faculties-workspace.test.tsx | Frontend lineage/accessibility contracts passed for explicit scope/source/mode copy, rollback-target messaging, and extracted workspace rendering across 22 assertions. |

### Command `LOCAL-BUILD`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-06A-001 | npm run build | Frontend build passed after the extracted workspace adopted authoritative lineage helpers and thin-wired rollback messaging. |

### Command `LIVE-ACCEPTANCE`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 06A--LIVE-ACCEPTANCE--system-admin-live-acceptance-report.json | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-acceptance-report.json | ATM-06A-001 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:acceptance | Refreshed deployed acceptance report confirms the extracted faculties workspace governance and lifecycle surfaces remain stable after the 06A lineage rollout. |
| 06A--LIVE-ACCEPTANCE--system-admin-live-acceptance.png | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-acceptance.png | ATM-06A-001 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:acceptance | Refreshed deployed acceptance screenshot anchors the live 06A hierarchy and override workflow after Pages deploy run 23750850452. |

### Command `LIVE-KEYBOARD`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 06A--LIVE-KEYBOARD--system-admin-live-keyboard-regression-report.json | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-keyboard-regression-report.json | ATM-06A-001 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:keyboard-regression | Refreshed deployed keyboard report confirms request-flow traversal, proof dashboard checkpoint controls, academic-portal handoff, and playback restore/reset remain stable after the 06A lineage rollout. |
| 06A--LIVE-KEYBOARD--system-admin-live-keyboard-regression.png | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-keyboard-regression.png | ATM-06A-001 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:keyboard-regression | Refreshed deployed keyboard screenshot anchors the same 06A live regression run after the served Pages asset index-BJ-jvkyu.js exposed the new lineage strings. |

## Stage 06B

### Command `LOCAL-BACKEND`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-06B-001, ATM-06B-002 | env -C air-mentor-api npx vitest run tests/admin-control-plane.test.ts tests/admin-foundation.test.ts tests/openapi.test.ts | Backend provisioning and public-contract suites passed with mentor-eligibility derivation, bulk mentor preview/apply coverage, and the OpenAPI route surface recorded across 12 passing tests and 5 intentional skips. |

### Command `LOCAL-FRONTEND`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-06B-001, ATM-06B-002 | npm test -- --run tests/system-admin-live-data.test.ts tests/system-admin-accessibility-contracts.test.tsx tests/api-client.test.ts tests/system-admin-faculties-workspace.test.tsx | Frontend workspace and client suites passed with mentor-ready faculty pool derivation, extracted bulk-apply controls, and API confirmation coverage across 32 assertions. |

### Command `LOCAL-BUILD`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-06B-001, ATM-06B-002 | npm run build | The frontend build passed after the extracted provisioning helper and bulk mentor-assignment UI landed, emitting `dist/assets/index-CITX0gQD.js` locally before the published Pages asset was probed. |

### Command `LOCAL-PROOF`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-06B-001, ATM-06B-002 | npm run verify:proof-closure:proof-rc | Repo-local proof closure passed after the TypeScript inference, stale HoD out-of-scope fixture, and transient teaching-parity navigation issues were closed in the 06B defect register. |

### Command `LOCAL-ACCEPTANCE`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-06B-001, ATM-06B-002 | npm run playwright:admin-live:acceptance | Repo-local acceptance passed on the preview stack after the 06B provisioning and bulk mentor-assignment rollout. |

### Command `LOCAL-TEACHING`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-06B-001, ATM-06B-002 | npm run playwright:admin-live:teaching-parity | Repo-local teaching parity passed with faculty-profile, dashboard, mentor-view, and queue-history parity still aligned after the 06B changes. |

### Command `LIVE-PROOF`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 06B--LIVE-PROOF--system-admin-proof-control-plane.png | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-proof-control-plane.png | ATM-06B-001, ATM-06B-002 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ npm run verify:proof-closure:live | Refreshed deployed proof-control-plane screenshot anchors the successful 06B live proof rerun after the transient harness lock collision cleared. |
| 06B--LIVE-PROOF--teacher-proof-panel.png | /home/raed/projects/air-mentor-ui/output/playwright/teacher-proof-panel.png | ATM-06B-002 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ npm run verify:proof-closure:live | Refreshed deployed teacher proof panel confirms the bulk mentor-assignment rollout did not disturb proof-facing faculty parity on the live stack. |
| 06B--LIVE-PROOF--hod-proof-analytics.png | /home/raed/projects/air-mentor-ui/output/playwright/hod-proof-analytics.png | ATM-06B-002 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ npm run verify:proof-closure:live | Refreshed deployed HoD analytics screenshot confirms downstream proof-scope visibility remained coherent after the 06B mentor updates. |
| 06B--LIVE-PROOF--hod-risk-explorer-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/hod-risk-explorer-proof.png | ATM-06B-002 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ npm run verify:proof-closure:live | Refreshed deployed HoD risk-explorer screenshot confirms drilldown parity remains intact on the 06B stack. |
| 06B--LIVE-PROOF--student-shell-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/student-shell-proof.png | ATM-06B-002 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ npm run verify:proof-closure:live | Refreshed deployed student-shell screenshot confirms the proof-bounded student view still restores correctly after the 06B mentor-assignment rollout. |

### Command `LIVE-ACCEPTANCE`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 06B--LIVE-ACCEPTANCE--system-admin-live-acceptance-report.json | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-acceptance-report.json | ATM-06B-001, ATM-06B-002 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:acceptance | Refreshed deployed acceptance report confirms the extracted provisioning workspace and downstream admin flow remain stable on the 06B live stack. |
| 06B--LIVE-ACCEPTANCE--system-admin-live-acceptance.png | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-live-acceptance.png | ATM-06B-001, ATM-06B-002 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:acceptance | Refreshed deployed acceptance screenshot anchors the same 06B live acceptance run after Pages served `index-savaPUFX.js`. |

### Command `LIVE-TEACHING`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 06B--LIVE-TEACHING--system-admin-teaching-parity-smoke.png | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-teaching-parity-smoke.png | ATM-06B-001, ATM-06B-002 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:teaching-parity | Refreshed deployed teaching-parity screenshot confirms the sysadmin-to-teaching handoff remained stable after the 06B provisioning and bulk mentor rollout. |
| 06B--LIVE-TEACHING--course-leader-dashboard-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/course-leader-dashboard-proof.png | ATM-06B-001 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:teaching-parity | Refreshed deployed dashboard screenshot confirms provisioned teaching surfaces remain reachable on the 06B stack. |
| 06B--LIVE-TEACHING--mentor-view-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/mentor-view-proof.png | ATM-06B-002 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:teaching-parity | Refreshed deployed mentor-view screenshot confirms live mentor surfaces still read the updated assignment state after the 06B rollout. |
| 06B--LIVE-TEACHING--queue-history-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/queue-history-proof.png | ATM-06B-001, ATM-06B-002 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:teaching-parity | Refreshed deployed queue-history screenshot confirms downstream teaching drilldowns remain stable and proof-bounded after the 06B mentor changes. |

GitHub Pages run `23756005841` and Railway run `23756005867` deployed commit `1fb9b68c399bc071d243b3a3050bc4529bb4b1b7`; pre-live probes confirmed Pages was serving `index-savaPUFX.js` with `sysadmin-bulk-mentor-apply`, `Mentor on`, and `Preview the scoped cohort before applying mentor changes`, and Railway `/openapi.json` exposed `/api/admin/mentor-assignments/bulk-apply` before the clean live proof, acceptance, and teaching reruns above. The earlier lock collision in `DEF-06B-LIVE-PROOF-LOCK-COLLISION` remains closed, and the latest authoritative 06B live verification logs are `output/detached/airmentor-airmentor-06b-live-proof-20260330T164403Z.log`, `output/detached/airmentor-airmentor-06b-live-acceptance-20260330T165017Z.log`, and `output/detached/airmentor-airmentor-06b-live-teaching-20260330T165426Z.log`. The live proof checkpoint exposed no row-backed teacher monitoring or elective-fit entries, so `teacher-risk-explorer-proof.png` was not rerecorded as part of this stage.

## Stage 07A

### Command `LOCAL-BUILD`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-07A-001 | cd air-mentor-api && npm run build | Backend build passed after the 07A activation-projection refresh hardening landed in commit `abcdb25`. |

### Command `LOCAL-IDEMPOTENCE`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-07A-001 | cd air-mentor-api && CI=1 AIRMENTOR_PROOF_RC=1 npx vitest run --reporter=verbose tests/admin-control-plane.test.ts -t 're-activates proof semesters without duplicating the published operational projection' | Targeted backend regression passed, proving re-activating the seeded semester context replaces instead of duplicating the published operational projection. |

### Command `LOCAL-PROOF`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 07A--LOCAL-PROOF--system-admin-proof-semester-activation-local-request.json | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-proof-semester-activation-local-request.json | ATM-07A-001 | npm run playwright:admin-live:proof-risk | Repo-local proof-risk walkthrough captured the local activation request against `sim_mnc_2023_first6_v1` for `batch_branch_mnc_btech_2023` before the proof route was replayed. |
| 07A--LOCAL-PROOF--system-admin-proof-semester-activation-local-response.json | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-proof-semester-activation-local-response.json | ATM-07A-001 | npm run playwright:admin-live:proof-risk | Repo-local proof-risk walkthrough captured the matching activation response with `activeOperationalSemester: 4` and `previousOperationalSemester: 6`. |

### Command `LIVE-PROBE`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 07A--LIVE-PROBE--system-admin-proof-semester-activation-live-request.json | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-proof-semester-activation-live-request.json | ATM-07A-001 | PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> node --input-type=module (login + proof-dashboard + POST /api/admin/proof-runs/:simulationRunId/activate-semester for semesters 4 and 6) | Cheap live route probe pinned the seeded batch and captured the exact activation request before the full browser rerun. |
| 07A--LIVE-PROBE--system-admin-proof-semester-activation-live-response.json | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-proof-semester-activation-live-response.json | ATM-07A-001 | PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> node --input-type=module (login + proof-dashboard + POST /api/admin/proof-runs/:simulationRunId/activate-semester for semesters 4 and 6) | Cheap live route probe confirmed the deployed Railway API cleanly toggled the seeded proof run `6 -> 4 -> 6` before the expensive proof-risk walkthrough. |

### Command `LIVE-PROOF`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 07A--LIVE-PROOF--system-admin-proof-control-plane.png | /home/raed/projects/air-mentor-ui/output/playwright/system-admin-proof-control-plane.png | ATM-07A-001 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:proof-risk | Final live proof-risk walkthrough refreshed the system-admin proof control plane after seeded activation, checkpoint restore, and semester reset succeeded on the deployed stack. |
| 07A--LIVE-PROOF--teacher-proof-panel.png | /home/raed/projects/air-mentor-ui/output/playwright/teacher-proof-panel.png | ATM-07A-001 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:proof-risk | Live proof-risk walkthrough refreshed the course-leader proof panel after the seeded activation contract completed and checkpoint playback restored. |
| 07A--LIVE-PROOF--hod-proof-analytics.png | /home/raed/projects/air-mentor-ui/output/playwright/hod-proof-analytics.png | ATM-07A-001 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:proof-risk | Live proof-risk walkthrough refreshed HoD analytics after the restored checkpoint replay proved `activeOperationalSemester` propagation on the live stack. |
| 07A--LIVE-PROOF--hod-risk-explorer-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/hod-risk-explorer-proof.png | ATM-07A-001 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:proof-risk | Live proof-risk walkthrough refreshed the HoD risk explorer after the seeded semester activation and playback restore succeeded. |
| 07A--LIVE-PROOF--student-shell-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/student-shell-proof.png | ATM-07A-001 | AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 npm run playwright:admin-live:proof-risk | Live proof-risk walkthrough refreshed the student shell from the HoD drilldown after the live run restored checkpoint `stage_checkpoint_654335929a345857eab259b0`. |

GitHub Pages run `23766526075` and Railway run `23766526081` deployed commit `abcdb25`. The direct activation probe in `output/detached/airmentor-airmentor-07a-live-activation-route-probe-rerun-20260330T204759Z.log` was intentionally run before the expensive browser pass, because earlier 07A reruns were blocked first by the cross-origin CSRF harness and then by non-seeded batch selection. The final authoritative 07A logs are `output/detached/airmentor-airmentor-07a-activation-build-20260330T203557Z.log`, `output/detached/airmentor-airmentor-07a-activation-count-stability-20260330T203633Z.log`, `output/detached/airmentor-airmentor-07a-activation-idempotence-exact2-20260330T203637Z.log`, `output/detached/airmentor-airmentor-07a-local-proof-risk-20260330T205105Z.log`, `output/detached/airmentor-airmentor-07a-live-activation-route-probe-rerun-20260330T204759Z.log`, and `output/detached/airmentor-airmentor-07a-live-proof-risk-rerun7-20260330T204819Z.log`.

## Stage 07B

### Command `LOCAL-BACKEND`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-07B-001 | env -C air-mentor-api npx vitest run --reporter=verbose --maxWorkers=1 tests/hod-proof-analytics.test.ts tests/risk-explorer.test.ts tests/student-agent-shell.test.ts | Repo-local backend parity passed for semesters 1 through 3 and kept the default HoD slice aligned with each activated semester. |

### Command `LOCAL-FRONTEND`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-07B-001 | npm test -- --run tests/proof-playback.test.ts tests/proof-risk-semester-walk.test.ts tests/system-admin-proof-dashboard-workspace.test.tsx tests/hod-pages.test.ts tests/risk-explorer.test.tsx tests/student-shell.test.tsx | Repo-local frontend parity passed for the semester-walk proof dashboard, playback helpers, and proof-page coverage. |

### Command `LOCAL-PROOF`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 07B--LOCAL-PROOF--07b-local-semester-walk-summary.json | /home/raed/projects/air-mentor-ui/output/playwright/07b-local-semester-walk-summary.json | ATM-07B-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-local npm run playwright:admin-live:proof-risk | Combined local semester-walk summary for semesters 1, 2, and 3. |
| 07B--LOCAL-PROOF--07b-local-semester-1-proof-risk-walk-summary.json | /home/raed/projects/air-mentor-ui/output/playwright/07b-local-semester-1-proof-risk-walk-summary.json | ATM-07B-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-local npm run playwright:admin-live:proof-risk | Semester 1 checkpoint stage_checkpoint_78ee47d5a45be74db6419d24. detail summary JSON. |
| 07B--LOCAL-PROOF--07b-local-semester-1-system-admin-proof-control-plane.png | /home/raed/projects/air-mentor-ui/output/playwright/07b-local-semester-1-system-admin-proof-control-plane.png | ATM-07B-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-local npm run playwright:admin-live:proof-risk | Semester 1 checkpoint stage_checkpoint_78ee47d5a45be74db6419d24. system-admin-proof-control-plane. |
| 07B--LOCAL-PROOF--07b-local-semester-1-teacher-proof-panel.png | /home/raed/projects/air-mentor-ui/output/playwright/07b-local-semester-1-teacher-proof-panel.png | ATM-07B-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-local npm run playwright:admin-live:proof-risk | Semester 1 checkpoint stage_checkpoint_78ee47d5a45be74db6419d24. teacher-proof-panel. |
| 07B--LOCAL-PROOF--07b-local-semester-1-teacher-risk-explorer-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/07b-local-semester-1-teacher-risk-explorer-proof.png | ATM-07B-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-local npm run playwright:admin-live:proof-risk | Semester 1 checkpoint stage_checkpoint_78ee47d5a45be74db6419d24. teacher-risk-explorer. |
| 07B--LOCAL-PROOF--07b-local-semester-1-hod-proof-analytics.png | /home/raed/projects/air-mentor-ui/output/playwright/07b-local-semester-1-hod-proof-analytics.png | ATM-07B-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-local npm run playwright:admin-live:proof-risk | Semester 1 checkpoint stage_checkpoint_78ee47d5a45be74db6419d24. hod-proof-analytics. |
| 07B--LOCAL-PROOF--07b-local-semester-1-hod-risk-explorer-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/07b-local-semester-1-hod-risk-explorer-proof.png | ATM-07B-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-local npm run playwright:admin-live:proof-risk | Semester 1 checkpoint stage_checkpoint_78ee47d5a45be74db6419d24. hod-risk-explorer. |
| 07B--LOCAL-PROOF--07b-local-semester-1-student-shell-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/07b-local-semester-1-student-shell-proof.png | ATM-07B-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-local npm run playwright:admin-live:proof-risk | Semester 1 checkpoint stage_checkpoint_78ee47d5a45be74db6419d24. student-shell. |
| 07B--LOCAL-PROOF--07b-local-semester-1-system-admin-proof-semester-activation-local-request.json | /home/raed/projects/air-mentor-ui/output/playwright/07b-local-semester-1-system-admin-proof-semester-activation-local-request.json | ATM-07B-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-local npm run playwright:admin-live:proof-risk | Semester 1 checkpoint stage_checkpoint_78ee47d5a45be74db6419d24. system-admin-proof-semester-activation-request. |
| 07B--LOCAL-PROOF--07b-local-semester-1-system-admin-proof-semester-activation-local-response.json | /home/raed/projects/air-mentor-ui/output/playwright/07b-local-semester-1-system-admin-proof-semester-activation-local-response.json | ATM-07B-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-local npm run playwright:admin-live:proof-risk | Semester 1 checkpoint stage_checkpoint_78ee47d5a45be74db6419d24. system-admin-proof-semester-activation-response. |
| 07B--LOCAL-PROOF--07b-local-semester-2-proof-risk-walk-summary.json | /home/raed/projects/air-mentor-ui/output/playwright/07b-local-semester-2-proof-risk-walk-summary.json | ATM-07B-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-local npm run playwright:admin-live:proof-risk | Semester 2 checkpoint stage_checkpoint_d6aa3455a8cf8433f94ab773. detail summary JSON. |
| 07B--LOCAL-PROOF--07b-local-semester-2-system-admin-proof-control-plane.png | /home/raed/projects/air-mentor-ui/output/playwright/07b-local-semester-2-system-admin-proof-control-plane.png | ATM-07B-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-local npm run playwright:admin-live:proof-risk | Semester 2 checkpoint stage_checkpoint_d6aa3455a8cf8433f94ab773. system-admin-proof-control-plane. |
| 07B--LOCAL-PROOF--07b-local-semester-2-teacher-proof-panel.png | /home/raed/projects/air-mentor-ui/output/playwright/07b-local-semester-2-teacher-proof-panel.png | ATM-07B-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-local npm run playwright:admin-live:proof-risk | Semester 2 checkpoint stage_checkpoint_d6aa3455a8cf8433f94ab773. teacher-proof-panel. |
| 07B--LOCAL-PROOF--07b-local-semester-2-teacher-risk-explorer-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/07b-local-semester-2-teacher-risk-explorer-proof.png | ATM-07B-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-local npm run playwright:admin-live:proof-risk | Semester 2 checkpoint stage_checkpoint_d6aa3455a8cf8433f94ab773. teacher-risk-explorer. |
| 07B--LOCAL-PROOF--07b-local-semester-2-hod-proof-analytics.png | /home/raed/projects/air-mentor-ui/output/playwright/07b-local-semester-2-hod-proof-analytics.png | ATM-07B-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-local npm run playwright:admin-live:proof-risk | Semester 2 checkpoint stage_checkpoint_d6aa3455a8cf8433f94ab773. hod-proof-analytics. |
| 07B--LOCAL-PROOF--07b-local-semester-2-hod-risk-explorer-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/07b-local-semester-2-hod-risk-explorer-proof.png | ATM-07B-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-local npm run playwright:admin-live:proof-risk | Semester 2 checkpoint stage_checkpoint_d6aa3455a8cf8433f94ab773. hod-risk-explorer. |
| 07B--LOCAL-PROOF--07b-local-semester-2-student-shell-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/07b-local-semester-2-student-shell-proof.png | ATM-07B-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-local npm run playwright:admin-live:proof-risk | Semester 2 checkpoint stage_checkpoint_d6aa3455a8cf8433f94ab773. student-shell. |
| 07B--LOCAL-PROOF--07b-local-semester-2-system-admin-proof-semester-activation-local-request.json | /home/raed/projects/air-mentor-ui/output/playwright/07b-local-semester-2-system-admin-proof-semester-activation-local-request.json | ATM-07B-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-local npm run playwright:admin-live:proof-risk | Semester 2 checkpoint stage_checkpoint_d6aa3455a8cf8433f94ab773. system-admin-proof-semester-activation-request. |
| 07B--LOCAL-PROOF--07b-local-semester-2-system-admin-proof-semester-activation-local-response.json | /home/raed/projects/air-mentor-ui/output/playwright/07b-local-semester-2-system-admin-proof-semester-activation-local-response.json | ATM-07B-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-local npm run playwright:admin-live:proof-risk | Semester 2 checkpoint stage_checkpoint_d6aa3455a8cf8433f94ab773. system-admin-proof-semester-activation-response. |
| 07B--LOCAL-PROOF--07b-local-semester-3-proof-risk-walk-summary.json | /home/raed/projects/air-mentor-ui/output/playwright/07b-local-semester-3-proof-risk-walk-summary.json | ATM-07B-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-local npm run playwright:admin-live:proof-risk | Semester 3 checkpoint stage_checkpoint_6452ecb8ca56b5b88168e2da. detail summary JSON. |
| 07B--LOCAL-PROOF--07b-local-semester-3-system-admin-proof-control-plane.png | /home/raed/projects/air-mentor-ui/output/playwright/07b-local-semester-3-system-admin-proof-control-plane.png | ATM-07B-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-local npm run playwright:admin-live:proof-risk | Semester 3 checkpoint stage_checkpoint_6452ecb8ca56b5b88168e2da. system-admin-proof-control-plane. |
| 07B--LOCAL-PROOF--07b-local-semester-3-teacher-proof-panel.png | /home/raed/projects/air-mentor-ui/output/playwright/07b-local-semester-3-teacher-proof-panel.png | ATM-07B-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-local npm run playwright:admin-live:proof-risk | Semester 3 checkpoint stage_checkpoint_6452ecb8ca56b5b88168e2da. teacher-proof-panel. |
| 07B--LOCAL-PROOF--07b-local-semester-3-teacher-risk-explorer-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/07b-local-semester-3-teacher-risk-explorer-proof.png | ATM-07B-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-local npm run playwright:admin-live:proof-risk | Semester 3 checkpoint stage_checkpoint_6452ecb8ca56b5b88168e2da. teacher-risk-explorer. |
| 07B--LOCAL-PROOF--07b-local-semester-3-hod-proof-analytics.png | /home/raed/projects/air-mentor-ui/output/playwright/07b-local-semester-3-hod-proof-analytics.png | ATM-07B-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-local npm run playwright:admin-live:proof-risk | Semester 3 checkpoint stage_checkpoint_6452ecb8ca56b5b88168e2da. hod-proof-analytics. |
| 07B--LOCAL-PROOF--07b-local-semester-3-hod-risk-explorer-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/07b-local-semester-3-hod-risk-explorer-proof.png | ATM-07B-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-local npm run playwright:admin-live:proof-risk | Semester 3 checkpoint stage_checkpoint_6452ecb8ca56b5b88168e2da. hod-risk-explorer. |
| 07B--LOCAL-PROOF--07b-local-semester-3-student-shell-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/07b-local-semester-3-student-shell-proof.png | ATM-07B-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-local npm run playwright:admin-live:proof-risk | Semester 3 checkpoint stage_checkpoint_6452ecb8ca56b5b88168e2da. student-shell. |
| 07B--LOCAL-PROOF--07b-local-semester-3-system-admin-proof-semester-activation-local-request.json | /home/raed/projects/air-mentor-ui/output/playwright/07b-local-semester-3-system-admin-proof-semester-activation-local-request.json | ATM-07B-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-local npm run playwright:admin-live:proof-risk | Semester 3 checkpoint stage_checkpoint_6452ecb8ca56b5b88168e2da. system-admin-proof-semester-activation-request. |
| 07B--LOCAL-PROOF--07b-local-semester-3-system-admin-proof-semester-activation-local-response.json | /home/raed/projects/air-mentor-ui/output/playwright/07b-local-semester-3-system-admin-proof-semester-activation-local-response.json | ATM-07B-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-local npm run playwright:admin-live:proof-risk | Semester 3 checkpoint stage_checkpoint_6452ecb8ca56b5b88168e2da. system-admin-proof-semester-activation-response. |

### Command `LIVE-PROBE`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 07B--LIVE-PROBE--07b-live-probe-semester-probe.json | /home/raed/projects/air-mentor-ui/output/playwright/07b-live-probe-semester-probe.json | ATM-07B-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-live-probe node scripts/proof-risk-semester-walk-probe.mjs | Cheap live probe confirmed semesters 1, 2, 3 were activatable and mapped to deterministic checkpoints before the browser pass. |

### Command `LIVE-PROOF`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 07B--LIVE-PROOF--07b-live-semester-walk-summary.json | /home/raed/projects/air-mentor-ui/output/playwright/07b-live-semester-walk-summary.json | ATM-07B-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-live npm run playwright:admin-live:proof-risk | Combined live semester-walk summary for semesters 1, 2, and 3. |
| 07B--LIVE-PROOF--07b-live-semester-1-proof-risk-walk-summary.json | /home/raed/projects/air-mentor-ui/output/playwright/07b-live-semester-1-proof-risk-walk-summary.json | ATM-07B-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-live npm run playwright:admin-live:proof-risk | Semester 1 checkpoint stage_checkpoint_78ee47d5a45be74db6419d24. detail summary JSON. |
| 07B--LIVE-PROOF--07b-live-semester-1-system-admin-proof-control-plane.png | /home/raed/projects/air-mentor-ui/output/playwright/07b-live-semester-1-system-admin-proof-control-plane.png | ATM-07B-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-live npm run playwright:admin-live:proof-risk | Semester 1 checkpoint stage_checkpoint_78ee47d5a45be74db6419d24. system-admin-proof-control-plane. |
| 07B--LIVE-PROOF--07b-live-semester-1-teacher-proof-panel.png | /home/raed/projects/air-mentor-ui/output/playwright/07b-live-semester-1-teacher-proof-panel.png | ATM-07B-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-live npm run playwright:admin-live:proof-risk | Semester 1 checkpoint stage_checkpoint_78ee47d5a45be74db6419d24. teacher-proof-panel. |
| 07B--LIVE-PROOF--07b-live-semester-1-teacher-risk-explorer-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/07b-live-semester-1-teacher-risk-explorer-proof.png | ATM-07B-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-live npm run playwright:admin-live:proof-risk | Semester 1 checkpoint stage_checkpoint_78ee47d5a45be74db6419d24. teacher-risk-explorer. |
| 07B--LIVE-PROOF--07b-live-semester-1-hod-proof-analytics.png | /home/raed/projects/air-mentor-ui/output/playwright/07b-live-semester-1-hod-proof-analytics.png | ATM-07B-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-live npm run playwright:admin-live:proof-risk | Semester 1 checkpoint stage_checkpoint_78ee47d5a45be74db6419d24. hod-proof-analytics. |
| 07B--LIVE-PROOF--07b-live-semester-1-hod-risk-explorer-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/07b-live-semester-1-hod-risk-explorer-proof.png | ATM-07B-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-live npm run playwright:admin-live:proof-risk | Semester 1 checkpoint stage_checkpoint_78ee47d5a45be74db6419d24. hod-risk-explorer. |
| 07B--LIVE-PROOF--07b-live-semester-1-student-shell-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/07b-live-semester-1-student-shell-proof.png | ATM-07B-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-live npm run playwright:admin-live:proof-risk | Semester 1 checkpoint stage_checkpoint_78ee47d5a45be74db6419d24. student-shell. |
| 07B--LIVE-PROOF--07b-live-semester-1-system-admin-proof-semester-activation-live-request.json | /home/raed/projects/air-mentor-ui/output/playwright/07b-live-semester-1-system-admin-proof-semester-activation-live-request.json | ATM-07B-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-live npm run playwright:admin-live:proof-risk | Semester 1 checkpoint stage_checkpoint_78ee47d5a45be74db6419d24. system-admin-proof-semester-activation-request. |
| 07B--LIVE-PROOF--07b-live-semester-1-system-admin-proof-semester-activation-live-response.json | /home/raed/projects/air-mentor-ui/output/playwright/07b-live-semester-1-system-admin-proof-semester-activation-live-response.json | ATM-07B-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-live npm run playwright:admin-live:proof-risk | Semester 1 checkpoint stage_checkpoint_78ee47d5a45be74db6419d24. system-admin-proof-semester-activation-response. |
| 07B--LIVE-PROOF--07b-live-semester-2-proof-risk-walk-summary.json | /home/raed/projects/air-mentor-ui/output/playwright/07b-live-semester-2-proof-risk-walk-summary.json | ATM-07B-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-live npm run playwright:admin-live:proof-risk | Semester 2 checkpoint stage_checkpoint_d6aa3455a8cf8433f94ab773. detail summary JSON. |
| 07B--LIVE-PROOF--07b-live-semester-2-system-admin-proof-control-plane.png | /home/raed/projects/air-mentor-ui/output/playwright/07b-live-semester-2-system-admin-proof-control-plane.png | ATM-07B-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-live npm run playwright:admin-live:proof-risk | Semester 2 checkpoint stage_checkpoint_d6aa3455a8cf8433f94ab773. system-admin-proof-control-plane. |
| 07B--LIVE-PROOF--07b-live-semester-2-teacher-proof-panel.png | /home/raed/projects/air-mentor-ui/output/playwright/07b-live-semester-2-teacher-proof-panel.png | ATM-07B-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-live npm run playwright:admin-live:proof-risk | Semester 2 checkpoint stage_checkpoint_d6aa3455a8cf8433f94ab773. teacher-proof-panel. |
| 07B--LIVE-PROOF--07b-live-semester-2-teacher-risk-explorer-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/07b-live-semester-2-teacher-risk-explorer-proof.png | ATM-07B-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-live npm run playwright:admin-live:proof-risk | Semester 2 checkpoint stage_checkpoint_d6aa3455a8cf8433f94ab773. teacher-risk-explorer. |
| 07B--LIVE-PROOF--07b-live-semester-2-hod-proof-analytics.png | /home/raed/projects/air-mentor-ui/output/playwright/07b-live-semester-2-hod-proof-analytics.png | ATM-07B-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-live npm run playwright:admin-live:proof-risk | Semester 2 checkpoint stage_checkpoint_d6aa3455a8cf8433f94ab773. hod-proof-analytics. |
| 07B--LIVE-PROOF--07b-live-semester-2-hod-risk-explorer-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/07b-live-semester-2-hod-risk-explorer-proof.png | ATM-07B-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-live npm run playwright:admin-live:proof-risk | Semester 2 checkpoint stage_checkpoint_d6aa3455a8cf8433f94ab773. hod-risk-explorer. |
| 07B--LIVE-PROOF--07b-live-semester-2-student-shell-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/07b-live-semester-2-student-shell-proof.png | ATM-07B-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-live npm run playwright:admin-live:proof-risk | Semester 2 checkpoint stage_checkpoint_d6aa3455a8cf8433f94ab773. student-shell. |
| 07B--LIVE-PROOF--07b-live-semester-2-system-admin-proof-semester-activation-live-request.json | /home/raed/projects/air-mentor-ui/output/playwright/07b-live-semester-2-system-admin-proof-semester-activation-live-request.json | ATM-07B-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-live npm run playwright:admin-live:proof-risk | Semester 2 checkpoint stage_checkpoint_d6aa3455a8cf8433f94ab773. system-admin-proof-semester-activation-request. |
| 07B--LIVE-PROOF--07b-live-semester-2-system-admin-proof-semester-activation-live-response.json | /home/raed/projects/air-mentor-ui/output/playwright/07b-live-semester-2-system-admin-proof-semester-activation-live-response.json | ATM-07B-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-live npm run playwright:admin-live:proof-risk | Semester 2 checkpoint stage_checkpoint_d6aa3455a8cf8433f94ab773. system-admin-proof-semester-activation-response. |
| 07B--LIVE-PROOF--07b-live-semester-3-proof-risk-walk-summary.json | /home/raed/projects/air-mentor-ui/output/playwright/07b-live-semester-3-proof-risk-walk-summary.json | ATM-07B-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-live npm run playwright:admin-live:proof-risk | Semester 3 checkpoint stage_checkpoint_6452ecb8ca56b5b88168e2da. detail summary JSON. |
| 07B--LIVE-PROOF--07b-live-semester-3-system-admin-proof-control-plane.png | /home/raed/projects/air-mentor-ui/output/playwright/07b-live-semester-3-system-admin-proof-control-plane.png | ATM-07B-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-live npm run playwright:admin-live:proof-risk | Semester 3 checkpoint stage_checkpoint_6452ecb8ca56b5b88168e2da. system-admin-proof-control-plane. |
| 07B--LIVE-PROOF--07b-live-semester-3-teacher-proof-panel.png | /home/raed/projects/air-mentor-ui/output/playwright/07b-live-semester-3-teacher-proof-panel.png | ATM-07B-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-live npm run playwright:admin-live:proof-risk | Semester 3 checkpoint stage_checkpoint_6452ecb8ca56b5b88168e2da. teacher-proof-panel. |
| 07B--LIVE-PROOF--07b-live-semester-3-teacher-risk-explorer-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/07b-live-semester-3-teacher-risk-explorer-proof.png | ATM-07B-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-live npm run playwright:admin-live:proof-risk | Semester 3 checkpoint stage_checkpoint_6452ecb8ca56b5b88168e2da. teacher-risk-explorer. |
| 07B--LIVE-PROOF--07b-live-semester-3-hod-proof-analytics.png | /home/raed/projects/air-mentor-ui/output/playwright/07b-live-semester-3-hod-proof-analytics.png | ATM-07B-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-live npm run playwright:admin-live:proof-risk | Semester 3 checkpoint stage_checkpoint_6452ecb8ca56b5b88168e2da. hod-proof-analytics. |
| 07B--LIVE-PROOF--07b-live-semester-3-hod-risk-explorer-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/07b-live-semester-3-hod-risk-explorer-proof.png | ATM-07B-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-live npm run playwright:admin-live:proof-risk | Semester 3 checkpoint stage_checkpoint_6452ecb8ca56b5b88168e2da. hod-risk-explorer. |
| 07B--LIVE-PROOF--07b-live-semester-3-student-shell-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/07b-live-semester-3-student-shell-proof.png | ATM-07B-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-live npm run playwright:admin-live:proof-risk | Semester 3 checkpoint stage_checkpoint_6452ecb8ca56b5b88168e2da. student-shell. |
| 07B--LIVE-PROOF--07b-live-semester-3-system-admin-proof-semester-activation-live-request.json | /home/raed/projects/air-mentor-ui/output/playwright/07b-live-semester-3-system-admin-proof-semester-activation-live-request.json | ATM-07B-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-live npm run playwright:admin-live:proof-risk | Semester 3 checkpoint stage_checkpoint_6452ecb8ca56b5b88168e2da. system-admin-proof-semester-activation-request. |
| 07B--LIVE-PROOF--07b-live-semester-3-system-admin-proof-semester-activation-live-response.json | /home/raed/projects/air-mentor-ui/output/playwright/07b-live-semester-3-system-admin-proof-semester-activation-live-response.json | ATM-07B-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=1,2,3 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07b-live npm run playwright:admin-live:proof-risk | Semester 3 checkpoint stage_checkpoint_6452ecb8ca56b5b88168e2da. system-admin-proof-semester-activation-response. |

## Stage 07C

### Command `LOCAL-BACKEND`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-07C-001 | env -C air-mentor-api npx vitest run --reporter=verbose --maxWorkers=1 tests/hod-proof-analytics.test.ts tests/risk-explorer.test.ts tests/student-agent-shell.test.ts tests/proof-control-plane-dashboard-service.test.ts | Repo-local backend proof passed for semesters 4, 5, and 6 with explicit late-stage checkpoint semantics. |

### Command `LOCAL-FRONTEND`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-07C-001 | npm test -- --run tests/proof-playback.test.ts tests/system-admin-proof-dashboard-workspace.test.tsx tests/hod-pages.test.ts tests/risk-explorer.test.tsx tests/student-shell.test.tsx | Repo-local frontend proof passed for late-stage playback banners, blocked-state rendering, and proof-page parity. |

### Command `LOCAL-PROOF`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 07C--LOCAL-PROOF--07c-local-semester-walk-summary.json | /home/raed/projects/air-mentor-ui/output/playwright/07c-local-semester-walk-summary.json | ATM-07C-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-local npm run playwright:admin-live:proof-risk | Combined local semester-walk summary for semesters 4, 5, and 6. |
| 07C--LOCAL-PROOF--07c-local-semester-4-proof-risk-walk-summary.json | /home/raed/projects/air-mentor-ui/output/playwright/07c-local-semester-4-proof-risk-walk-summary.json | ATM-07C-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-local npm run playwright:admin-live:proof-risk | Semester 4 checkpoint stage_checkpoint_fd713de15d3771038ced9bfd. detail summary JSON. |
| 07C--LOCAL-PROOF--07c-local-semester-4-system-admin-proof-control-plane.png | /home/raed/projects/air-mentor-ui/output/playwright/07c-local-semester-4-system-admin-proof-control-plane.png | ATM-07C-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-local npm run playwright:admin-live:proof-risk | Semester 4 checkpoint stage_checkpoint_fd713de15d3771038ced9bfd. system-admin-proof-control-plane. |
| 07C--LOCAL-PROOF--07c-local-semester-4-teacher-proof-panel.png | /home/raed/projects/air-mentor-ui/output/playwright/07c-local-semester-4-teacher-proof-panel.png | ATM-07C-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-local npm run playwright:admin-live:proof-risk | Semester 4 checkpoint stage_checkpoint_fd713de15d3771038ced9bfd. teacher-proof-panel. |
| 07C--LOCAL-PROOF--07c-local-semester-4-teacher-risk-explorer-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/07c-local-semester-4-teacher-risk-explorer-proof.png | ATM-07C-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-local npm run playwright:admin-live:proof-risk | Semester 4 checkpoint stage_checkpoint_fd713de15d3771038ced9bfd. teacher-risk-explorer. |
| 07C--LOCAL-PROOF--07c-local-semester-4-hod-proof-analytics.png | /home/raed/projects/air-mentor-ui/output/playwright/07c-local-semester-4-hod-proof-analytics.png | ATM-07C-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-local npm run playwright:admin-live:proof-risk | Semester 4 checkpoint stage_checkpoint_fd713de15d3771038ced9bfd. hod-proof-analytics. |
| 07C--LOCAL-PROOF--07c-local-semester-4-hod-risk-explorer-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/07c-local-semester-4-hod-risk-explorer-proof.png | ATM-07C-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-local npm run playwright:admin-live:proof-risk | Semester 4 checkpoint stage_checkpoint_fd713de15d3771038ced9bfd. hod-risk-explorer. |
| 07C--LOCAL-PROOF--07c-local-semester-4-student-shell-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/07c-local-semester-4-student-shell-proof.png | ATM-07C-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-local npm run playwright:admin-live:proof-risk | Semester 4 checkpoint stage_checkpoint_fd713de15d3771038ced9bfd. student-shell. |
| 07C--LOCAL-PROOF--07c-local-semester-4-system-admin-proof-semester-activation-local-request.json | /home/raed/projects/air-mentor-ui/output/playwright/07c-local-semester-4-system-admin-proof-semester-activation-local-request.json | ATM-07C-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-local npm run playwright:admin-live:proof-risk | Semester 4 checkpoint stage_checkpoint_fd713de15d3771038ced9bfd. system-admin-proof-semester-activation-request. |
| 07C--LOCAL-PROOF--07c-local-semester-4-system-admin-proof-semester-activation-local-response.json | /home/raed/projects/air-mentor-ui/output/playwright/07c-local-semester-4-system-admin-proof-semester-activation-local-response.json | ATM-07C-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-local npm run playwright:admin-live:proof-risk | Semester 4 checkpoint stage_checkpoint_fd713de15d3771038ced9bfd. system-admin-proof-semester-activation-response. |
| 07C--LOCAL-PROOF--07c-local-semester-5-proof-risk-walk-summary.json | /home/raed/projects/air-mentor-ui/output/playwright/07c-local-semester-5-proof-risk-walk-summary.json | ATM-07C-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-local npm run playwright:admin-live:proof-risk | Semester 5 checkpoint stage_checkpoint_19ede662df23cf9be4d8c7e8. detail summary JSON. |
| 07C--LOCAL-PROOF--07c-local-semester-5-system-admin-proof-control-plane.png | /home/raed/projects/air-mentor-ui/output/playwright/07c-local-semester-5-system-admin-proof-control-plane.png | ATM-07C-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-local npm run playwright:admin-live:proof-risk | Semester 5 checkpoint stage_checkpoint_19ede662df23cf9be4d8c7e8. system-admin-proof-control-plane. |
| 07C--LOCAL-PROOF--07c-local-semester-5-teacher-proof-panel.png | /home/raed/projects/air-mentor-ui/output/playwright/07c-local-semester-5-teacher-proof-panel.png | ATM-07C-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-local npm run playwright:admin-live:proof-risk | Semester 5 checkpoint stage_checkpoint_19ede662df23cf9be4d8c7e8. teacher-proof-panel. |
| 07C--LOCAL-PROOF--07c-local-semester-5-teacher-risk-explorer-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/07c-local-semester-5-teacher-risk-explorer-proof.png | ATM-07C-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-local npm run playwright:admin-live:proof-risk | Semester 5 checkpoint stage_checkpoint_19ede662df23cf9be4d8c7e8. teacher-risk-explorer. |
| 07C--LOCAL-PROOF--07c-local-semester-5-hod-proof-analytics.png | /home/raed/projects/air-mentor-ui/output/playwright/07c-local-semester-5-hod-proof-analytics.png | ATM-07C-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-local npm run playwright:admin-live:proof-risk | Semester 5 checkpoint stage_checkpoint_19ede662df23cf9be4d8c7e8. hod-proof-analytics. |
| 07C--LOCAL-PROOF--07c-local-semester-5-hod-risk-explorer-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/07c-local-semester-5-hod-risk-explorer-proof.png | ATM-07C-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-local npm run playwright:admin-live:proof-risk | Semester 5 checkpoint stage_checkpoint_19ede662df23cf9be4d8c7e8. hod-risk-explorer. |
| 07C--LOCAL-PROOF--07c-local-semester-5-student-shell-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/07c-local-semester-5-student-shell-proof.png | ATM-07C-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-local npm run playwright:admin-live:proof-risk | Semester 5 checkpoint stage_checkpoint_19ede662df23cf9be4d8c7e8. student-shell. |
| 07C--LOCAL-PROOF--07c-local-semester-5-system-admin-proof-semester-activation-local-request.json | /home/raed/projects/air-mentor-ui/output/playwright/07c-local-semester-5-system-admin-proof-semester-activation-local-request.json | ATM-07C-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-local npm run playwright:admin-live:proof-risk | Semester 5 checkpoint stage_checkpoint_19ede662df23cf9be4d8c7e8. system-admin-proof-semester-activation-request. |
| 07C--LOCAL-PROOF--07c-local-semester-5-system-admin-proof-semester-activation-local-response.json | /home/raed/projects/air-mentor-ui/output/playwright/07c-local-semester-5-system-admin-proof-semester-activation-local-response.json | ATM-07C-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-local npm run playwright:admin-live:proof-risk | Semester 5 checkpoint stage_checkpoint_19ede662df23cf9be4d8c7e8. system-admin-proof-semester-activation-response. |
| 07C--LOCAL-PROOF--07c-local-semester-6-proof-risk-walk-summary.json | /home/raed/projects/air-mentor-ui/output/playwright/07c-local-semester-6-proof-risk-walk-summary.json | ATM-07C-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-local npm run playwright:admin-live:proof-risk | Semester 6 checkpoint stage_checkpoint_654335929a345857eab259b0. detail summary JSON. |
| 07C--LOCAL-PROOF--07c-local-semester-6-system-admin-proof-control-plane.png | /home/raed/projects/air-mentor-ui/output/playwright/07c-local-semester-6-system-admin-proof-control-plane.png | ATM-07C-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-local npm run playwright:admin-live:proof-risk | Semester 6 checkpoint stage_checkpoint_654335929a345857eab259b0. system-admin-proof-control-plane. |
| 07C--LOCAL-PROOF--07c-local-semester-6-teacher-proof-panel.png | /home/raed/projects/air-mentor-ui/output/playwright/07c-local-semester-6-teacher-proof-panel.png | ATM-07C-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-local npm run playwright:admin-live:proof-risk | Semester 6 checkpoint stage_checkpoint_654335929a345857eab259b0. teacher-proof-panel. |
| 07C--LOCAL-PROOF--07c-local-semester-6-teacher-risk-explorer-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/07c-local-semester-6-teacher-risk-explorer-proof.png | ATM-07C-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-local npm run playwright:admin-live:proof-risk | Semester 6 checkpoint stage_checkpoint_654335929a345857eab259b0. teacher-risk-explorer. |
| 07C--LOCAL-PROOF--07c-local-semester-6-hod-proof-analytics.png | /home/raed/projects/air-mentor-ui/output/playwright/07c-local-semester-6-hod-proof-analytics.png | ATM-07C-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-local npm run playwright:admin-live:proof-risk | Semester 6 checkpoint stage_checkpoint_654335929a345857eab259b0. hod-proof-analytics. |
| 07C--LOCAL-PROOF--07c-local-semester-6-hod-risk-explorer-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/07c-local-semester-6-hod-risk-explorer-proof.png | ATM-07C-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-local npm run playwright:admin-live:proof-risk | Semester 6 checkpoint stage_checkpoint_654335929a345857eab259b0. hod-risk-explorer. |
| 07C--LOCAL-PROOF--07c-local-semester-6-student-shell-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/07c-local-semester-6-student-shell-proof.png | ATM-07C-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-local npm run playwright:admin-live:proof-risk | Semester 6 checkpoint stage_checkpoint_654335929a345857eab259b0. student-shell. |
| 07C--LOCAL-PROOF--07c-local-semester-6-system-admin-proof-semester-activation-local-request.json | /home/raed/projects/air-mentor-ui/output/playwright/07c-local-semester-6-system-admin-proof-semester-activation-local-request.json | ATM-07C-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-local npm run playwright:admin-live:proof-risk | Semester 6 checkpoint stage_checkpoint_654335929a345857eab259b0. system-admin-proof-semester-activation-request. |
| 07C--LOCAL-PROOF--07c-local-semester-6-system-admin-proof-semester-activation-local-response.json | /home/raed/projects/air-mentor-ui/output/playwright/07c-local-semester-6-system-admin-proof-semester-activation-local-response.json | ATM-07C-001 | AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-local npm run playwright:admin-live:proof-risk | Semester 6 checkpoint stage_checkpoint_654335929a345857eab259b0. system-admin-proof-semester-activation-response. |

### Command `LOCAL-KEYBOARD`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 07C--LOCAL-KEYBOARD--07c-local-system-admin-live-keyboard-regression-report.json | /home/raed/projects/air-mentor-ui/output/playwright/07c-local-system-admin-live-keyboard-regression-report.json | ATM-07C-001 | AIRMENTOR_KEYBOARD_ARTIFACT_PREFIX=07c-local npm run playwright:admin-live:keyboard-regression | Local late-stage keyboard regression report. |
| 07C--LOCAL-KEYBOARD--07c-local-system-admin-live-keyboard-regression.png | /home/raed/projects/air-mentor-ui/output/playwright/07c-local-system-admin-live-keyboard-regression.png | ATM-07C-001 | AIRMENTOR_KEYBOARD_ARTIFACT_PREFIX=07c-local npm run playwright:admin-live:keyboard-regression | Local late-stage keyboard regression screenshot. |

### Command `LIVE-PROBE`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 07C--LIVE-PROBE--07c-live-probe-semester-probe.json | /home/raed/projects/air-mentor-ui/output/playwright/07c-live-probe-semester-probe.json | ATM-07C-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-live-probe node scripts/proof-risk-semester-walk-probe.mjs | Cheap live probe confirmed semesters 4, 5, and 6 were activatable and mapped to deterministic checkpoints before the browser pass. |

### Command `LIVE-PROOF`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 07C--LIVE-PROOF--07c-live-semester-walk-summary.json | /home/raed/projects/air-mentor-ui/output/playwright/07c-live-semester-walk-summary.json | ATM-07C-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-live npm run playwright:admin-live:proof-risk | Combined live semester-walk summary for semesters 4, 5, and 6. |
| 07C--LIVE-PROOF--07c-live-semester-4-proof-risk-walk-summary.json | /home/raed/projects/air-mentor-ui/output/playwright/07c-live-semester-4-proof-risk-walk-summary.json | ATM-07C-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-live npm run playwright:admin-live:proof-risk | Semester 4 checkpoint stage_checkpoint_fd713de15d3771038ced9bfd. detail summary JSON. |
| 07C--LIVE-PROOF--07c-live-semester-4-system-admin-proof-control-plane.png | /home/raed/projects/air-mentor-ui/output/playwright/07c-live-semester-4-system-admin-proof-control-plane.png | ATM-07C-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-live npm run playwright:admin-live:proof-risk | Semester 4 checkpoint stage_checkpoint_fd713de15d3771038ced9bfd. system-admin-proof-control-plane. |
| 07C--LIVE-PROOF--07c-live-semester-4-teacher-proof-panel.png | /home/raed/projects/air-mentor-ui/output/playwright/07c-live-semester-4-teacher-proof-panel.png | ATM-07C-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-live npm run playwright:admin-live:proof-risk | Semester 4 checkpoint stage_checkpoint_fd713de15d3771038ced9bfd. teacher-proof-panel. |
| 07C--LIVE-PROOF--07c-live-semester-4-teacher-risk-explorer-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/07c-live-semester-4-teacher-risk-explorer-proof.png | ATM-07C-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-live npm run playwright:admin-live:proof-risk | Semester 4 checkpoint stage_checkpoint_fd713de15d3771038ced9bfd. teacher-risk-explorer. |
| 07C--LIVE-PROOF--07c-live-semester-4-hod-proof-analytics.png | /home/raed/projects/air-mentor-ui/output/playwright/07c-live-semester-4-hod-proof-analytics.png | ATM-07C-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-live npm run playwright:admin-live:proof-risk | Semester 4 checkpoint stage_checkpoint_fd713de15d3771038ced9bfd. hod-proof-analytics. |
| 07C--LIVE-PROOF--07c-live-semester-4-hod-risk-explorer-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/07c-live-semester-4-hod-risk-explorer-proof.png | ATM-07C-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-live npm run playwright:admin-live:proof-risk | Semester 4 checkpoint stage_checkpoint_fd713de15d3771038ced9bfd. hod-risk-explorer. |
| 07C--LIVE-PROOF--07c-live-semester-4-student-shell-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/07c-live-semester-4-student-shell-proof.png | ATM-07C-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-live npm run playwright:admin-live:proof-risk | Semester 4 checkpoint stage_checkpoint_fd713de15d3771038ced9bfd. student-shell. |
| 07C--LIVE-PROOF--07c-live-semester-4-system-admin-proof-semester-activation-live-request.json | /home/raed/projects/air-mentor-ui/output/playwright/07c-live-semester-4-system-admin-proof-semester-activation-live-request.json | ATM-07C-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-live npm run playwright:admin-live:proof-risk | Semester 4 checkpoint stage_checkpoint_fd713de15d3771038ced9bfd. system-admin-proof-semester-activation-request. |
| 07C--LIVE-PROOF--07c-live-semester-4-system-admin-proof-semester-activation-live-response.json | /home/raed/projects/air-mentor-ui/output/playwright/07c-live-semester-4-system-admin-proof-semester-activation-live-response.json | ATM-07C-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-live npm run playwright:admin-live:proof-risk | Semester 4 checkpoint stage_checkpoint_fd713de15d3771038ced9bfd. system-admin-proof-semester-activation-response. |
| 07C--LIVE-PROOF--07c-live-semester-5-proof-risk-walk-summary.json | /home/raed/projects/air-mentor-ui/output/playwright/07c-live-semester-5-proof-risk-walk-summary.json | ATM-07C-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-live npm run playwright:admin-live:proof-risk | Semester 5 checkpoint stage_checkpoint_19ede662df23cf9be4d8c7e8. detail summary JSON. |
| 07C--LIVE-PROOF--07c-live-semester-5-system-admin-proof-control-plane.png | /home/raed/projects/air-mentor-ui/output/playwright/07c-live-semester-5-system-admin-proof-control-plane.png | ATM-07C-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-live npm run playwright:admin-live:proof-risk | Semester 5 checkpoint stage_checkpoint_19ede662df23cf9be4d8c7e8. system-admin-proof-control-plane. |
| 07C--LIVE-PROOF--07c-live-semester-5-teacher-proof-panel.png | /home/raed/projects/air-mentor-ui/output/playwright/07c-live-semester-5-teacher-proof-panel.png | ATM-07C-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-live npm run playwright:admin-live:proof-risk | Semester 5 checkpoint stage_checkpoint_19ede662df23cf9be4d8c7e8. teacher-proof-panel. |
| 07C--LIVE-PROOF--07c-live-semester-5-teacher-risk-explorer-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/07c-live-semester-5-teacher-risk-explorer-proof.png | ATM-07C-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-live npm run playwright:admin-live:proof-risk | Semester 5 checkpoint stage_checkpoint_19ede662df23cf9be4d8c7e8. teacher-risk-explorer. |
| 07C--LIVE-PROOF--07c-live-semester-5-hod-proof-analytics.png | /home/raed/projects/air-mentor-ui/output/playwright/07c-live-semester-5-hod-proof-analytics.png | ATM-07C-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-live npm run playwright:admin-live:proof-risk | Semester 5 checkpoint stage_checkpoint_19ede662df23cf9be4d8c7e8. hod-proof-analytics. |
| 07C--LIVE-PROOF--07c-live-semester-5-hod-risk-explorer-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/07c-live-semester-5-hod-risk-explorer-proof.png | ATM-07C-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-live npm run playwright:admin-live:proof-risk | Semester 5 checkpoint stage_checkpoint_19ede662df23cf9be4d8c7e8. hod-risk-explorer. |
| 07C--LIVE-PROOF--07c-live-semester-5-student-shell-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/07c-live-semester-5-student-shell-proof.png | ATM-07C-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-live npm run playwright:admin-live:proof-risk | Semester 5 checkpoint stage_checkpoint_19ede662df23cf9be4d8c7e8. student-shell. |
| 07C--LIVE-PROOF--07c-live-semester-5-system-admin-proof-semester-activation-live-request.json | /home/raed/projects/air-mentor-ui/output/playwright/07c-live-semester-5-system-admin-proof-semester-activation-live-request.json | ATM-07C-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-live npm run playwright:admin-live:proof-risk | Semester 5 checkpoint stage_checkpoint_19ede662df23cf9be4d8c7e8. system-admin-proof-semester-activation-request. |
| 07C--LIVE-PROOF--07c-live-semester-5-system-admin-proof-semester-activation-live-response.json | /home/raed/projects/air-mentor-ui/output/playwright/07c-live-semester-5-system-admin-proof-semester-activation-live-response.json | ATM-07C-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-live npm run playwright:admin-live:proof-risk | Semester 5 checkpoint stage_checkpoint_19ede662df23cf9be4d8c7e8. system-admin-proof-semester-activation-response. |
| 07C--LIVE-PROOF--07c-live-semester-6-proof-risk-walk-summary.json | /home/raed/projects/air-mentor-ui/output/playwright/07c-live-semester-6-proof-risk-walk-summary.json | ATM-07C-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-live npm run playwright:admin-live:proof-risk | Semester 6 checkpoint stage_checkpoint_654335929a345857eab259b0. detail summary JSON. |
| 07C--LIVE-PROOF--07c-live-semester-6-system-admin-proof-control-plane.png | /home/raed/projects/air-mentor-ui/output/playwright/07c-live-semester-6-system-admin-proof-control-plane.png | ATM-07C-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-live npm run playwright:admin-live:proof-risk | Semester 6 checkpoint stage_checkpoint_654335929a345857eab259b0. system-admin-proof-control-plane. |
| 07C--LIVE-PROOF--07c-live-semester-6-teacher-proof-panel.png | /home/raed/projects/air-mentor-ui/output/playwright/07c-live-semester-6-teacher-proof-panel.png | ATM-07C-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-live npm run playwright:admin-live:proof-risk | Semester 6 checkpoint stage_checkpoint_654335929a345857eab259b0. teacher-proof-panel. |
| 07C--LIVE-PROOF--07c-live-semester-6-teacher-risk-explorer-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/07c-live-semester-6-teacher-risk-explorer-proof.png | ATM-07C-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-live npm run playwright:admin-live:proof-risk | Semester 6 checkpoint stage_checkpoint_654335929a345857eab259b0. teacher-risk-explorer. |
| 07C--LIVE-PROOF--07c-live-semester-6-hod-proof-analytics.png | /home/raed/projects/air-mentor-ui/output/playwright/07c-live-semester-6-hod-proof-analytics.png | ATM-07C-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-live npm run playwright:admin-live:proof-risk | Semester 6 checkpoint stage_checkpoint_654335929a345857eab259b0. hod-proof-analytics. |
| 07C--LIVE-PROOF--07c-live-semester-6-hod-risk-explorer-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/07c-live-semester-6-hod-risk-explorer-proof.png | ATM-07C-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-live npm run playwright:admin-live:proof-risk | Semester 6 checkpoint stage_checkpoint_654335929a345857eab259b0. hod-risk-explorer. |
| 07C--LIVE-PROOF--07c-live-semester-6-student-shell-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/07c-live-semester-6-student-shell-proof.png | ATM-07C-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-live npm run playwright:admin-live:proof-risk | Semester 6 checkpoint stage_checkpoint_654335929a345857eab259b0. student-shell. |
| 07C--LIVE-PROOF--07c-live-semester-6-system-admin-proof-semester-activation-live-request.json | /home/raed/projects/air-mentor-ui/output/playwright/07c-live-semester-6-system-admin-proof-semester-activation-live-request.json | ATM-07C-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-live npm run playwright:admin-live:proof-risk | Semester 6 checkpoint stage_checkpoint_654335929a345857eab259b0. system-admin-proof-semester-activation-request. |
| 07C--LIVE-PROOF--07c-live-semester-6-system-admin-proof-semester-activation-live-response.json | /home/raed/projects/air-mentor-ui/output/playwright/07c-live-semester-6-system-admin-proof-semester-activation-live-response.json | ATM-07C-001 | AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_SEMESTER_TARGETS=4,5,6 AIRMENTOR_PROOF_ARTIFACT_PREFIX=07c-live npm run playwright:admin-live:proof-risk | Semester 6 checkpoint stage_checkpoint_654335929a345857eab259b0. system-admin-proof-semester-activation-response. |

### Command `LIVE-KEYBOARD`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 07C--LIVE-KEYBOARD--07c-live-system-admin-live-keyboard-regression-report.json | /home/raed/projects/air-mentor-ui/output/playwright/07c-live-system-admin-live-keyboard-regression-report.json | ATM-07C-001 | PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> AIRMENTOR_LIVE_STACK=1 AIRMENTOR_KEYBOARD_ARTIFACT_PREFIX=07c-live npm run playwright:admin-live:keyboard-regression | Live late-stage keyboard regression report. |
| 07C--LIVE-KEYBOARD--07c-live-system-admin-live-keyboard-regression.png | /home/raed/projects/air-mentor-ui/output/playwright/07c-live-system-admin-live-keyboard-regression.png | ATM-07C-001 | PLAYWRIGHT_APP_URL=<pages-url> PLAYWRIGHT_API_URL=<railway-url> AIRMENTOR_LIVE_STACK=1 AIRMENTOR_KEYBOARD_ARTIFACT_PREFIX=07c-live npm run playwright:admin-live:keyboard-regression | Live late-stage keyboard regression screenshot. |

## Stage 08A

### Command `LOCAL-PROOF-RC`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-08A-001, ATM-08A-002 | npm run verify:proof-closure:proof-rc | The authoritative repo-local proof-rc suite passed before the stage-scoped 08A proof rerun, keeping the broader proof closure bar green. |

### Command `LOCAL-ACCEPTANCE`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 08A--LOCAL-ACCEPTANCE--08a-local-acceptance-system-admin-live-acceptance-report.json | /home/raed/projects/air-mentor-ui/output/playwright/08a-local-acceptance-system-admin-live-acceptance-report.json | ATM-08A-001 | AIRMENTOR_ACCEPTANCE_ARTIFACT_PREFIX=08a-local-acceptance npm run playwright:admin-live:acceptance | Local system-admin acceptance artifact for the end-to-end governance journey. |
| 08A--LOCAL-ACCEPTANCE--08a-local-acceptance-system-admin-live-acceptance.png | /home/raed/projects/air-mentor-ui/output/playwright/08a-local-acceptance-system-admin-live-acceptance.png | ATM-08A-001 | AIRMENTOR_ACCEPTANCE_ARTIFACT_PREFIX=08a-local-acceptance npm run playwright:admin-live:acceptance | Local system-admin acceptance artifact for the end-to-end governance journey. |

### Command `LOCAL-REQUESTS`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 08A--LOCAL-REQUESTS--08a-local-request-flow-system-admin-live-request-flow-report.json | /home/raed/projects/air-mentor-ui/output/playwright/08a-local-request-flow-system-admin-live-request-flow-report.json | ATM-08A-001 | AIRMENTOR_REQUEST_FLOW_ARTIFACT_PREFIX=08a-local-request-flow npm run playwright:admin-live:request-flow | Local governed request workflow artifact for the role-e2e closeout. |
| 08A--LOCAL-REQUESTS--08a-local-request-flow-system-admin-live-request-flow.png | /home/raed/projects/air-mentor-ui/output/playwright/08a-local-request-flow-system-admin-live-request-flow.png | ATM-08A-001 | AIRMENTOR_REQUEST_FLOW_ARTIFACT_PREFIX=08a-local-request-flow npm run playwright:admin-live:request-flow | Local governed request workflow artifact for the role-e2e closeout. |

### Command `LOCAL-TEACHING`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 08A--LOCAL-TEACHING--08a-local-teaching-system-admin-teaching-parity-smoke.png | /home/raed/projects/air-mentor-ui/output/playwright/08a-local-teaching-system-admin-teaching-parity-smoke.png | ATM-08A-001, ATM-08A-002 | AIRMENTOR_TEACHING_PARITY_ARTIFACT_PREFIX=08a-local-teaching npm run playwright:admin-live:teaching-parity | Local sysadmin-to-teaching handoff artifact proving profile parity. |
| 08A--LOCAL-TEACHING--08a-local-teaching-course-leader-dashboard-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/08a-local-teaching-course-leader-dashboard-proof.png | ATM-08A-002 | AIRMENTOR_TEACHING_PARITY_ARTIFACT_PREFIX=08a-local-teaching npm run playwright:admin-live:teaching-parity | Local course leader dashboard artifact after sysadmin handoff. |
| 08A--LOCAL-TEACHING--08a-local-teaching-mentor-view-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/08a-local-teaching-mentor-view-proof.png | ATM-08A-002 | AIRMENTOR_TEACHING_PARITY_ARTIFACT_PREFIX=08a-local-teaching npm run playwright:admin-live:teaching-parity | Local mentor landing artifact proving role-parity after handoff. |
| 08A--LOCAL-TEACHING--08a-local-teaching-queue-history-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/08a-local-teaching-queue-history-proof.png | ATM-08A-002 | AIRMENTOR_TEACHING_PARITY_ARTIFACT_PREFIX=08a-local-teaching npm run playwright:admin-live:teaching-parity | Local mentor queue-history artifact proving downstream teaching navigation. |

### Command `LOCAL-PROOF`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 08A--LOCAL-PROOF--08a-local-proof-risk-smoke-summary.json | /home/raed/projects/air-mentor-ui/output/playwright/08a-local-proof-risk-smoke-summary.json | ATM-08A-001, ATM-08A-002 | AIRMENTOR_PROOF_ARTIFACT_PREFIX=08a-local npm run playwright:admin-live:proof-risk | Local proof-risk smoke summary for the 08A role-facing proof surfaces. |
| 08A--LOCAL-PROOF--08a-local-system-admin-proof-control-plane.png | /home/raed/projects/air-mentor-ui/output/playwright/08a-local-system-admin-proof-control-plane.png | ATM-08A-001 | AIRMENTOR_PROOF_ARTIFACT_PREFIX=08a-local npm run playwright:admin-live:proof-risk | Local proof control-plane screenshot for the 08A sysadmin proof entrypoint. |
| 08A--LOCAL-PROOF--08a-local-teacher-proof-panel.png | /home/raed/projects/air-mentor-ui/output/playwright/08a-local-teacher-proof-panel.png | ATM-08A-002 | AIRMENTOR_PROOF_ARTIFACT_PREFIX=08a-local npm run playwright:admin-live:proof-risk | Local teacher proof-panel screenshot for the 08A course-leader flow. |
| 08A--LOCAL-PROOF--08a-local-teacher-risk-explorer-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/08a-local-teacher-risk-explorer-proof.png | ATM-08A-002 | AIRMENTOR_PROOF_ARTIFACT_PREFIX=08a-local npm run playwright:admin-live:proof-risk | Local teacher risk-explorer screenshot for the 08A downstream proof flow. |

### Command `LIVE-ACCEPTANCE`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 08A--LIVE-ACCEPTANCE--08a-live-acceptance-system-admin-live-acceptance-report.json | /home/raed/projects/air-mentor-ui/output/playwright/08a-live-acceptance-system-admin-live-acceptance-report.json | ATM-08A-001 | PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 AIRMENTOR_ACCEPTANCE_ARTIFACT_PREFIX=08a-live-acceptance npm run playwright:admin-live:acceptance | Live system-admin acceptance artifact for the end-to-end governance journey. |
| 08A--LIVE-ACCEPTANCE--08a-live-acceptance-system-admin-live-acceptance.png | /home/raed/projects/air-mentor-ui/output/playwright/08a-live-acceptance-system-admin-live-acceptance.png | ATM-08A-001 | PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 AIRMENTOR_ACCEPTANCE_ARTIFACT_PREFIX=08a-live-acceptance npm run playwright:admin-live:acceptance | Live system-admin acceptance artifact for the end-to-end governance journey. |

### Command `LIVE-REQUESTS`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 08A--LIVE-REQUESTS--08a-live-request-flow-system-admin-live-request-flow-report.json | /home/raed/projects/air-mentor-ui/output/playwright/08a-live-request-flow-system-admin-live-request-flow-report.json | ATM-08A-001 | PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 AIRMENTOR_REQUEST_FLOW_ARTIFACT_PREFIX=08a-live-request-flow npm run playwright:admin-live:request-flow | Live governed request workflow artifact for the role-e2e closeout. |
| 08A--LIVE-REQUESTS--08a-live-request-flow-system-admin-live-request-flow.png | /home/raed/projects/air-mentor-ui/output/playwright/08a-live-request-flow-system-admin-live-request-flow.png | ATM-08A-001 | PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 AIRMENTOR_REQUEST_FLOW_ARTIFACT_PREFIX=08a-live-request-flow npm run playwright:admin-live:request-flow | Live governed request workflow artifact for the role-e2e closeout. |

### Command `LIVE-TEACHING`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 08A--LIVE-TEACHING--08a-live-teaching-system-admin-teaching-parity-smoke.png | /home/raed/projects/air-mentor-ui/output/playwright/08a-live-teaching-system-admin-teaching-parity-smoke.png | ATM-08A-001, ATM-08A-002 | PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 AIRMENTOR_TEACHING_PARITY_ARTIFACT_PREFIX=08a-live-teaching npm run playwright:admin-live:teaching-parity | Live sysadmin-to-teaching handoff artifact proving profile parity. |
| 08A--LIVE-TEACHING--08a-live-teaching-course-leader-dashboard-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/08a-live-teaching-course-leader-dashboard-proof.png | ATM-08A-002 | PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 AIRMENTOR_TEACHING_PARITY_ARTIFACT_PREFIX=08a-live-teaching npm run playwright:admin-live:teaching-parity | Live course leader dashboard artifact after sysadmin handoff. |
| 08A--LIVE-TEACHING--08a-live-teaching-mentor-view-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/08a-live-teaching-mentor-view-proof.png | ATM-08A-002 | PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 AIRMENTOR_TEACHING_PARITY_ARTIFACT_PREFIX=08a-live-teaching npm run playwright:admin-live:teaching-parity | Live mentor landing artifact proving role-parity after handoff. |
| 08A--LIVE-TEACHING--08a-live-teaching-queue-history-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/08a-live-teaching-queue-history-proof.png | ATM-08A-002 | PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 AIRMENTOR_TEACHING_PARITY_ARTIFACT_PREFIX=08a-live-teaching npm run playwright:admin-live:teaching-parity | Live mentor queue-history artifact proving downstream teaching navigation. |

### Command `LIVE-PROOF`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 08A--LIVE-PROOF--08a-live-proof-risk-smoke-summary.json | /home/raed/projects/air-mentor-ui/output/playwright/08a-live-proof-risk-smoke-summary.json | ATM-08A-001, ATM-08A-002 | PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_ARTIFACT_PREFIX=08a-live npm run playwright:admin-live:proof-risk | Live proof-risk smoke summary for the 08A role-facing proof surfaces. |
| 08A--LIVE-PROOF--08a-live-system-admin-proof-control-plane.png | /home/raed/projects/air-mentor-ui/output/playwright/08a-live-system-admin-proof-control-plane.png | ATM-08A-001 | PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_ARTIFACT_PREFIX=08a-live npm run playwright:admin-live:proof-risk | Live proof control-plane screenshot for the 08A sysadmin proof entrypoint. |
| 08A--LIVE-PROOF--08a-live-teacher-proof-panel.png | /home/raed/projects/air-mentor-ui/output/playwright/08a-live-teacher-proof-panel.png | ATM-08A-002 | PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_ARTIFACT_PREFIX=08a-live npm run playwright:admin-live:proof-risk | Live teacher proof-panel screenshot for the 08A course-leader flow. |
| 08A--LIVE-PROOF--08a-live-teacher-risk-explorer-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/08a-live-teacher-risk-explorer-proof.png | ATM-08A-002 | PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_STACK=1 AIRMENTOR_PROOF_ARTIFACT_PREFIX=08a-live npm run playwright:admin-live:proof-risk | Live teacher risk-explorer screenshot for the 08A downstream proof flow. |

## Stage 08B

### Command `LOCAL-BACKEND`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-08B-001 | env -C air-mentor-api npx vitest run --reporter=verbose --maxWorkers=1 tests/session.test.ts tests/startup-diagnostics.test.ts tests/academic-access.test.ts | Targeted backend session/startup/access suites passed for 08B. |

### Command `LOCAL-FRONTEND`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-08B-001 | npm test -- --run tests/api-client.test.ts tests/frontend-startup-diagnostics.test.ts tests/hod-pages.test.ts tests/student-shell.test.tsx tests/risk-explorer.test.tsx | Targeted frontend client/session/HoD/student/risk suites passed for 08B. |

### Command `LOCAL-SESSION`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 08B--LOCAL-SESSION--08b-local-session-security-system-admin-live-session-security-report.json | /home/raed/projects/air-mentor-ui/output/playwright/08b-local-session-security-system-admin-live-session-security-report.json | ATM-08B-001 | AIRMENTOR_SESSION_SECURITY_ARTIFACT_PREFIX=08b-local-session-security npm run playwright:admin-live:session-security | Local session-security report for login, restore, invalidation recovery, CSRF, and origin posture. |

### Command `LOCAL-PROOF-RC`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 08B--LOCAL-PROOF-RC--08b-local-proof-risk-smoke-summary.json | /home/raed/projects/air-mentor-ui/output/playwright/08b-local-proof-risk-smoke-summary.json | ATM-08B-001 | AIRMENTOR_PROOF_ARTIFACT_PREFIX=08b-local npm run verify:proof-closure:proof-rc | Local HoD/student proof-risk summary for the 08B closeout. |
| 08B--LOCAL-PROOF-RC--08b-local-system-admin-proof-control-plane.png | /home/raed/projects/air-mentor-ui/output/playwright/08b-local-system-admin-proof-control-plane.png | ATM-08B-001 | AIRMENTOR_PROOF_ARTIFACT_PREFIX=08b-local npm run verify:proof-closure:proof-rc | Local seeded proof control-plane screenshot proving deterministic proof entry before HoD/student traversal. |
| 08B--LOCAL-PROOF-RC--08b-local-teacher-proof-panel.png | /home/raed/projects/air-mentor-ui/output/playwright/08b-local-teacher-proof-panel.png | ATM-08B-001 | AIRMENTOR_PROOF_ARTIFACT_PREFIX=08b-local npm run verify:proof-closure:proof-rc | Local teacher proof panel screenshot carried with the 08B proof traversal before HoD/student drilldowns. |
| 08B--LOCAL-PROOF-RC--08b-local-teacher-risk-explorer-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/08b-local-teacher-risk-explorer-proof.png | ATM-08B-001 | AIRMENTOR_PROOF_ARTIFACT_PREFIX=08b-local npm run verify:proof-closure:proof-rc | Local teacher risk explorer screenshot carried with the 08B proof traversal before HoD/student drilldowns. |
| 08B--LOCAL-PROOF-RC--08b-local-hod-proof-analytics.png | /home/raed/projects/air-mentor-ui/output/playwright/08b-local-hod-proof-analytics.png | ATM-08B-001 | AIRMENTOR_PROOF_ARTIFACT_PREFIX=08b-local npm run verify:proof-closure:proof-rc | Local HoD analytics proof screenshot for the 08B role closeout. |
| 08B--LOCAL-PROOF-RC--08b-local-hod-risk-explorer-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/08b-local-hod-risk-explorer-proof.png | ATM-08B-001 | AIRMENTOR_PROOF_ARTIFACT_PREFIX=08b-local npm run verify:proof-closure:proof-rc | Local HoD risk explorer screenshot for the 08B role closeout. |
| 08B--LOCAL-PROOF-RC--08b-local-student-shell-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/08b-local-student-shell-proof.png | ATM-08B-001 | AIRMENTOR_PROOF_ARTIFACT_PREFIX=08b-local npm run verify:proof-closure:proof-rc | Local HoD-launched student-shell screenshot for the 08B role closeout. |
| 08B--LOCAL-PROOF-RC--08b-local-system-admin-proof-semester-activation-local-request.json | /home/raed/projects/air-mentor-ui/output/playwright/08b-local-system-admin-proof-semester-activation-local-request.json | ATM-08B-001 | AIRMENTOR_PROOF_ARTIFACT_PREFIX=08b-local npm run verify:proof-closure:proof-rc | Local proof-semester activation request JSON proving deterministic checkpoint selection context. |
| 08B--LOCAL-PROOF-RC--08b-local-system-admin-proof-semester-activation-local-response.json | /home/raed/projects/air-mentor-ui/output/playwright/08b-local-system-admin-proof-semester-activation-local-response.json | ATM-08B-001 | AIRMENTOR_PROOF_ARTIFACT_PREFIX=08b-local npm run verify:proof-closure:proof-rc | Local proof-semester activation response JSON proving deterministic checkpoint selection context. |

### Command `LIVE-CONTRACT`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 08B--LIVE-CONTRACT--08b-live-contract-railway-live-session-contract.json | /home/raed/projects/air-mentor-ui/air-mentor-api/output/08b-live-contract-railway-live-session-contract.json | ATM-08B-001 | env -C air-mentor-api RAILWAY_PUBLIC_API_URL=https://api-production-ab72.up.railway.app/ EXPECTED_FRONTEND_ORIGIN=https://raed2180416.github.io AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> RAILWAY_DIAGNOSTIC_ARTIFACT_PREFIX=08b-live-contract npm run verify:live-session-contract | Live cross-origin session-contract report from the Railway readiness probe. |

### Command `LIVE-SESSION`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 08B--LIVE-SESSION--08b-live-session-security-system-admin-live-session-security-report.json | /home/raed/projects/air-mentor-ui/output/playwright/08b-live-session-security-system-admin-live-session-security-report.json | ATM-08B-001 | AIRMENTOR_SESSION_SECURITY_ARTIFACT_PREFIX=08b-live-session-security AIRMENTOR_LIVE_STACK=1 PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> npm run playwright:admin-live:session-security | Live session-security report for login, restore, invalidation recovery, CSRF, and origin posture. |

### Command `LIVE-PROOF`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 08B--LIVE-PROOF--08b-live-proof-risk-smoke-summary.json | /home/raed/projects/air-mentor-ui/output/playwright/08b-live-proof-risk-smoke-summary.json | ATM-08B-001 | AIRMENTOR_PROOF_ARTIFACT_PREFIX=08b-live AIRMENTOR_LIVE_STACK=1 PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> npm run playwright:admin-live:proof-risk | Live HoD/student proof-risk summary for the 08B closeout. |
| 08B--LIVE-PROOF--08b-live-system-admin-proof-control-plane.png | /home/raed/projects/air-mentor-ui/output/playwright/08b-live-system-admin-proof-control-plane.png | ATM-08B-001 | AIRMENTOR_PROOF_ARTIFACT_PREFIX=08b-live AIRMENTOR_LIVE_STACK=1 PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> npm run playwright:admin-live:proof-risk | Live seeded proof control-plane screenshot proving deterministic proof entry before HoD/student traversal. |
| 08B--LIVE-PROOF--08b-live-teacher-proof-panel.png | /home/raed/projects/air-mentor-ui/output/playwright/08b-live-teacher-proof-panel.png | ATM-08B-001 | AIRMENTOR_PROOF_ARTIFACT_PREFIX=08b-live AIRMENTOR_LIVE_STACK=1 PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> npm run playwright:admin-live:proof-risk | Live teacher proof panel screenshot carried with the 08B proof traversal before HoD/student drilldowns. |
| 08B--LIVE-PROOF--08b-live-teacher-risk-explorer-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/08b-live-teacher-risk-explorer-proof.png | ATM-08B-001 | AIRMENTOR_PROOF_ARTIFACT_PREFIX=08b-live AIRMENTOR_LIVE_STACK=1 PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> npm run playwright:admin-live:proof-risk | Live teacher risk explorer screenshot carried with the 08B proof traversal before HoD/student drilldowns. |
| 08B--LIVE-PROOF--08b-live-hod-proof-analytics.png | /home/raed/projects/air-mentor-ui/output/playwright/08b-live-hod-proof-analytics.png | ATM-08B-001 | AIRMENTOR_PROOF_ARTIFACT_PREFIX=08b-live AIRMENTOR_LIVE_STACK=1 PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> npm run playwright:admin-live:proof-risk | Live HoD analytics proof screenshot for the 08B role closeout. |
| 08B--LIVE-PROOF--08b-live-hod-risk-explorer-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/08b-live-hod-risk-explorer-proof.png | ATM-08B-001 | AIRMENTOR_PROOF_ARTIFACT_PREFIX=08b-live AIRMENTOR_LIVE_STACK=1 PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> npm run playwright:admin-live:proof-risk | Live HoD risk explorer screenshot for the 08B role closeout. |
| 08B--LIVE-PROOF--08b-live-student-shell-proof.png | /home/raed/projects/air-mentor-ui/output/playwright/08b-live-student-shell-proof.png | ATM-08B-001 | AIRMENTOR_PROOF_ARTIFACT_PREFIX=08b-live AIRMENTOR_LIVE_STACK=1 PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> npm run playwright:admin-live:proof-risk | Live HoD-launched student-shell screenshot for the 08B role closeout. |
| 08B--LIVE-PROOF--08b-live-system-admin-proof-semester-activation-live-request.json | /home/raed/projects/air-mentor-ui/output/playwright/08b-live-system-admin-proof-semester-activation-live-request.json | ATM-08B-001 | AIRMENTOR_PROOF_ARTIFACT_PREFIX=08b-live AIRMENTOR_LIVE_STACK=1 PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> npm run playwright:admin-live:proof-risk | Live proof-semester activation request JSON proving deterministic checkpoint selection context. |
| 08B--LIVE-PROOF--08b-live-system-admin-proof-semester-activation-live-response.json | /home/raed/projects/air-mentor-ui/output/playwright/08b-live-system-admin-proof-semester-activation-live-response.json | ATM-08B-001 | AIRMENTOR_PROOF_ARTIFACT_PREFIX=08b-live AIRMENTOR_LIVE_STACK=1 PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> npm run playwright:admin-live:proof-risk | Live proof-semester activation response JSON proving deterministic checkpoint selection context. |

### Command `LIVE-A11Y`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 08B--LIVE-A11Y--system-admin-live-accessibility-report.json | /home/raed/projects/air-mentor-ui/output/playwright/08b-live-a11y/system-admin-live-accessibility-report.json | ATM-08B-001 | PLAYWRIGHT_OUTPUT_DIR=output/playwright/08b-live-a11y AIRMENTOR_LIVE_STACK=1 PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> npm run playwright:admin-live:accessibility-regression | Live accessibility regression report for the 08B proof/admin/session surfaces. |
| 08B--LIVE-A11Y--system-admin-live-screen-reader-preflight.md | /home/raed/projects/air-mentor-ui/output/playwright/08b-live-a11y/system-admin-live-screen-reader-preflight.md | ATM-08B-001 | PLAYWRIGHT_OUTPUT_DIR=output/playwright/08b-live-a11y AIRMENTOR_LIVE_STACK=1 PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> npm run playwright:admin-live:accessibility-regression | Live screen-reader preflight transcript for the 08B accessibility pass. |
| 08B--LIVE-A11Y--system-admin-live-accessibility-regression.png | /home/raed/projects/air-mentor-ui/output/playwright/08b-live-a11y/system-admin-live-accessibility-regression.png | ATM-08B-001 | PLAYWRIGHT_OUTPUT_DIR=output/playwright/08b-live-a11y AIRMENTOR_LIVE_STACK=1 PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> npm run playwright:admin-live:accessibility-regression | Live accessibility regression screenshot for the 08B proof/admin/session surfaces. |

### Command `LIVE-KEYBOARD`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 08B--LIVE-KEYBOARD--08b-live-keyboard-system-admin-live-keyboard-regression-report.json | /home/raed/projects/air-mentor-ui/output/playwright/08b-live-keyboard-system-admin-live-keyboard-regression-report.json | ATM-08B-001 | AIRMENTOR_KEYBOARD_ARTIFACT_PREFIX=08b-live-keyboard AIRMENTOR_LIVE_STACK=1 PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> npm run playwright:admin-live:keyboard-regression | Live keyboard regression report for request, proof, portal-switch, and restore flows. |
| 08B--LIVE-KEYBOARD--08b-live-keyboard-system-admin-live-keyboard-regression.png | /home/raed/projects/air-mentor-ui/output/playwright/08b-live-keyboard-system-admin-live-keyboard-regression.png | ATM-08B-001 | AIRMENTOR_KEYBOARD_ARTIFACT_PREFIX=08b-live-keyboard AIRMENTOR_LIVE_STACK=1 PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> npm run playwright:admin-live:keyboard-regression | Live keyboard regression screenshot for the 08B closeout. |

### Command `LIVE-DENIED`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 08B--LIVE-DENIED--08b-live-denied-hod-proof-invalid-checkpoint-live.json | /home/raed/projects/air-mentor-ui/output/playwright/08b-live-denied-hod-proof-invalid-checkpoint-live.json | ATM-08B-001 | AIRMENTOR_DENIED_ARTIFACT_PREFIX=08b-live-denied AIRMENTOR_LIVE_STACK=1 PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> node scripts/hod-proof-invalid-checkpoint-probe.mjs | Denied-path artifact proving invalid checkpoint fallback remains explicit instead of returning false data. |

## Stage 08C

### Command `LOCAL-LINT`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-08C-001 | npm run lint | Final lint sweep passed with the latest detached 08C log. |

### Command `LOCAL-COMPAT`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| ledger-only | n/a | ATM-08C-001 | npm run inventory:compat-routes -- --assert-runtime-clean | Runtime compatibility inventory remained clean before the final local/live closeout sweep. |

### Command `LOCAL-CLOSEOUT`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 08C--LOCAL-CLOSEOUT--08c-local-closeout-artifact-bundle.json | /home/raed/projects/air-mentor-ui/output/playwright/08c-local-closeout-artifact-bundle.json | ATM-00B-002, ATM-02B-002, ATM-08C-001 | npm run verify:final-closeout | Final local closeout artifact bundle covering the stage-scoped acceptance, request, teaching parity, proof, accessibility, keyboard, and session-security copies. |

### Command `LIVE-CLOSEOUT`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 08C--LIVE-CLOSEOUT--08c-live-closeout-artifact-bundle.json | /home/raed/projects/air-mentor-ui/output/playwright/08c-live-closeout-artifact-bundle.json | ATM-00B-002, ATM-02B-002, ATM-08C-001 | PLAYWRIGHT_APP_URL=https://raed2180416.github.io/AirMentor/ PLAYWRIGHT_API_URL=https://api-production-ab72.up.railway.app/ AIRMENTOR_LIVE_SYSTEM_ADMIN_IDENTIFIER=<identifier> AIRMENTOR_LIVE_SYSTEM_ADMIN_PASSWORD=<password> npm run verify:final-closeout:live | Final live closeout artifact bundle covering the stage-scoped live session-contract plus the deployed acceptance, request, teaching, proof, accessibility, keyboard, and session-security copies. |

### Command `SELF-AUDIT`

| artifactId | path | assertionIds | source command | notes |
| --- | --- | --- | --- | --- |
| 08C--SELF-AUDIT--08c-self-audit-summary.json | /home/raed/projects/air-mentor-ui/output/playwright/08c-self-audit-summary.json | ATM-00B-002, ATM-02B-002, ATM-08C-001 | stage-local 08C closeout audit | Three-pass self-audit plus historical credential redaction sweep across the proof backbone. |
