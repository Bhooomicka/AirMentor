# Sysadmin And Teaching Proof Coverage Matrix

This file maps every sysadmin surface, every teaching-profile-reachable surface, and every negative path to its owner, runtime dependency, proof path, artifact family, and owning stage.

The execution ledger, evidence manifest, evidence index, and defect register under `output/playwright/` are the shared proof backbone for every artifact named here. The Stage `00B` support-doc deliverables `final-authoritative-plan-security-observability-annex.md`, `deploy-env-contract.md`, and `operational-event-taxonomy.md` provide the closeout-wide security, deployment, and telemetry context that this coverage matrix assumes.

Current status as of `2026-03-30`: `DEF-02A-LIVE-GITHUB-PAGES-BANDS-DRIFT` is closed. Repo-local proof, `LIVE-PROOF`, `LIVE-TEACHING`, and refreshed `LIVE-ACCEPTANCE` are current on the deployed GitHub Pages + Railway stack.

## Backbone And Support Docs
- Evidence backbone:
  - `output/playwright/execution-ledger.jsonl`
  - `output/playwright/proof-evidence-manifest.json`
  - `output/playwright/proof-evidence-index.md`
  - `output/playwright/defect-register.json`
- Support docs:
  - `docs/closeout/final-authoritative-plan-security-observability-annex.md`
  - `docs/closeout/deploy-env-contract.md`
  - `docs/closeout/operational-event-taxonomy.md`

## Sysadmin Surfaces
| Surface | Owner Role | Entry Route Or Surface | Backend/API Dependency | Repo-local Proof | Live Proof | Primary Artifact | Owning Stage |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Operations dashboard | `SYSTEM_ADMIN` | `#/admin` overview | admin bootstrap + search/audit/reminders | `LOCAL-CLOSEOUT` | `LIVE-ACCEPTANCE` | `system-admin-live-acceptance-report.json` | 03A |
| Search | `SYSTEM_ADMIN` | overview search rail | `/api/admin/search` | targeted frontend tests | `LIVE-ACCEPTANCE` | acceptance report | 03A |
| Recent audit/history | `SYSTEM_ADMIN` | overview + history workspace | `/api/admin/audit-events`, `/recent` | `LOCAL-WEB` | `LIVE-REQUESTS` | request-flow report | 03A |
| Reminders | `SYSTEM_ADMIN` | overview reminder controls | `/api/admin/reminders*` | targeted reminder tests | `LIVE-ACCEPTANCE` | acceptance report | 03A |
| Faculties workspace shell | `SYSTEM_ADMIN` | `#/admin/faculties/...` | structure + section-aware resolved policy/stage-policy + curriculum routes | `LOCAL-FRONTEND` | `LIVE-ACCEPTANCE` | acceptance report | 01A, 02A |
| Hierarchy selectors | `SYSTEM_ADMIN` | faculties workspace top controls | academic-faculty, department, branch, batch, and section selector state | `npm test -- --run tests/system-admin-live-data.test.ts tests/system-admin-accessibility-contracts.test.tsx` | `LIVE-ACCEPTANCE`, `LIVE-A11Y` | acceptance report, accessibility report | 01A, 03B |
| Policy override editors | `SYSTEM_ADMIN` | faculties workspace governance tabs | `/api/admin/policy-overrides*`, batch resolved policy, optional `sectionCode` query | `LOCAL-BACKEND`, `LOCAL-FRONTEND` | `LIVE-ACCEPTANCE` | acceptance report | 01A, 06A |
| Stage policy editors | `SYSTEM_ADMIN` | faculties workspace lifecycle tab | `/api/admin/stage-policy-overrides*`, batch resolved stage policy, optional `sectionCode` query | `LOCAL-BACKEND`, `LOCAL-FRONTEND` | `LIVE-ACCEPTANCE` | acceptance report | 01A, 02A, 06A |
| Curriculum rows and course-leader assignment | `SYSTEM_ADMIN` | faculties workspace year editors | curriculum + offerings + ownership routes | admin/offering tests | `LIVE-TEACHING` | teaching parity screenshot | 02A, 06B |
| Curriculum feature config and linkage review | `SYSTEM_ADMIN` | faculties workspace curriculum model inputs | curriculum feature + linkage routes | targeted curriculum tests | `LIVE-ACCEPTANCE` | acceptance report | 02A |
| Provisioning | `SYSTEM_ADMIN` | faculties workspace provision tab | `/api/admin/batches/:batchId/provision` | provisioning tests | `LIVE-ACCEPTANCE`, `LIVE-TEACHING` | acceptance report, teaching parity screenshot | 06B |
| Students registry and student detail | `SYSTEM_ADMIN` | `#/admin/students` | students/enrollments/promotion + resolved policy + proof provenance | `cd air-mentor-api && npx vitest run tests/admin-hierarchy.test.ts`; `npm test -- --run tests/system-admin-live-data.test.ts` | `LIVE-ACCEPTANCE` | acceptance report | 03B |
| Faculty-members registry and faculty detail | `SYSTEM_ADMIN` | `#/admin/faculty-members` | faculty, appointments, grants, ownership, calendar, labeled scope provenance | `cd air-mentor-api && npx vitest run tests/admin-hierarchy.test.ts`; `npm test -- --run tests/system-admin-live-data.test.ts tests/system-admin-accessibility-contracts.test.tsx` | `LIVE-ACCEPTANCE`, `LIVE-A11Y` | acceptance report, accessibility report | 03B |
| Requests workflow | `SYSTEM_ADMIN` | `#/admin/requests` | admin requests routes | request tests | `LIVE-REQUESTS` | `system-admin-live-request-flow-report.json` | 03A |
| Hidden/archive restore flows | `SYSTEM_ADMIN` | overview + detail recycle actions | entity patch routes | targeted restore tests | `LIVE-REQUESTS`, `LIVE-KEYBOARD` | request-flow report, keyboard report | 03A, 05B |
| Proof control plane | `SYSTEM_ADMIN` | faculties workspace proof panel | proof dashboard/import/run/checkpoint routes + shared proof provenance selectors | `LOCAL-PROOF` | `LIVE-PROOF`, `LIVE-ACCEPTANCE` | `system-admin-proof-control-plane.png`, acceptance report | 01B, 02B |
| Semester activation | `SYSTEM_ADMIN` | proof control plane | `POST /api/admin/proof-runs/:simulationRunId/activate-semester` + activeOperationalSemester propagation | proof-control-plane tests | `LIVE-PROOF` | proof screenshots | 02B |
| Queue and worker diagnostics | `SYSTEM_ADMIN` | proof control plane diagnostics cards | dashboard service + operational telemetry + active semester context | dashboard service tests | `LIVE-PROOF` | `system-admin-proof-control-plane.png` | 02B |
| Faculty calendar oversight | `SYSTEM_ADMIN` | faculty detail calendar workspace | faculty calendar admin workspace routes | `cd air-mentor-api && npx vitest run tests/academic-parity.test.ts`; `npm test -- --run tests/system-admin-accessibility-contracts.test.tsx` | `LIVE-A11Y` | accessibility report | 03B |
| Scoped registry launches | `SYSTEM_ADMIN` | faculties workspace launch cards | route state + selection state, including section-scoped launch context | `npm test -- --run tests/system-admin-live-data.test.ts tests/system-admin-accessibility-contracts.test.tsx` | `LIVE-ACCEPTANCE`, `LIVE-A11Y` | acceptance report, accessibility report | 01A, 03B |

## Teaching-Profile-Reachable Surfaces
| Surface | Owner Role | Entry Route Or Surface | Backend/API Dependency | Repo-local Proof | Live Proof | Primary Artifact | Owning Stage |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Faculty profile | `COURSE_LEADER`, `MENTOR`, `HOD` | academic workspace `faculty-profile` | `/api/academic/faculty-profile/:facultyId` | `npm test -- --run tests/faculty-profile-proof.test.tsx` | `LIVE-TEACHING` | `system-admin-teaching-parity-smoke.png` | 04A |
| Teacher proof panel | `COURSE_LEADER` | faculty profile proof section | faculty profile + proof bundle + proof provenance formatting | targeted faculty/profile tests, `LOCAL-PROOF` | `LIVE-PROOF`, `LIVE-TEACHING` | `teacher-proof-panel.png`, `system-admin-teaching-parity-smoke.png` | 01B, 04A |
| Course leader dashboard | `COURSE_LEADER` | academic dashboard | `/api/academic/bootstrap` | selectors/page tests | `LIVE-TEACHING` | teaching parity screenshot | 04A |
| Course detail | `COURSE_LEADER`, `HOD` | academic route `course` | offering attendance, assessment, scheme, question paper | academic parity tests | `LIVE-TEACHING` | teaching parity screenshot | 04A |
| Scheme setup | `COURSE_LEADER` | academic route `scheme-setup` | `/api/academic/offerings/:offeringId/scheme` | academic parity tests | `LIVE-TEACHING` | teaching parity screenshot | 04A |
| Upload workspace | `COURSE_LEADER` | academic route `upload` | attendance and assessment entry routes | academic parity tests | `LIVE-TEACHING` | teaching parity screenshot | 04A |
| Entry workspace | `COURSE_LEADER` | academic route `entry-workspace` | entry commits + lock/unlock routes | academic parity tests | `LIVE-TEACHING` | teaching parity screenshot | 04A |
| Calendar and timetable | `COURSE_LEADER`, `MENTOR`, `HOD` | academic route `calendar` | meetings, placements, calendar audit, faculty timetable | calendar tests | `LIVE-TEACHING` | teaching parity screenshot | 04A |
| Mentor mentee list | `MENTOR` | academic route `mentees` | bootstrap + mentor assignments | mentor-specific tests | `LIVE-TEACHING` | teaching parity screenshot | 04A |
| Mentee detail | `MENTOR` | academic route `mentee-detail` | bootstrap + student history | mentor/history tests | `LIVE-TEACHING` | teaching parity screenshot | 04A |
| Queue history | `COURSE_LEADER`, `MENTOR`, `HOD` | academic route `queue-history` | academic task routes | domain/runtime tests | `LIVE-TEACHING`, `LIVE-KEYBOARD` | keyboard report | 04A, 08A |
| Unlock review | `HOD` | academic route `unlock-review` | admin requests + academic locks | targeted unlock tests | `LIVE-REQUESTS` | request-flow report | 08A, 08B |
| HoD overview | `HOD` | academic route `department` | `/api/academic/hod/proof-*` + proof provenance selectors | `cd air-mentor-api && npx vitest run tests/hod-proof-analytics.test.ts`, `LOCAL-PROOF` | `LIVE-PROOF` | `hod-proof-analytics.png` | 01B, 04B |
| HoD course hotspots | `HOD` | HoD overview course tab | `/api/academic/hod/proof-courses` | HoD proof tests | `LIVE-PROOF` | HoD screenshot | 04B |
| HoD faculty operations | `HOD` | HoD overview faculty tab | `/api/academic/hod/proof-faculty` | HoD proof tests | `LIVE-PROOF` | HoD screenshot | 04B |
| HoD reassessment audit | `HOD` | HoD overview reassessment tab | `/api/academic/hod/proof-reassessments` | HoD proof tests | `LIVE-PROOF` | HoD screenshot | 04B |
| Risk explorer | `COURSE_LEADER`, `MENTOR`, `HOD` | student drilldown to risk explorer | `/api/academic/students/:studentId/risk-explorer` + shared proof provenance copy | `npm test -- --run tests/risk-explorer.test.tsx` and backend risk tests, `LOCAL-PROOF` | `LIVE-PROOF` | `teacher-risk-explorer-proof.png`, `hod-risk-explorer-proof.png` | 01B, 04B |
| Student shell | `COURSE_LEADER`, `MENTOR`, `HOD`, `SYSTEM_ADMIN` archived inspection | student drilldown to student shell | `/api/academic/student-shell/*` + shared proof provenance copy | `npm test -- --run tests/student-shell.test.tsx` and backend student-shell tests, `LOCAL-PROOF` | `LIVE-PROOF` | `student-shell-proof.png` | 01B, 04B |
| Student history / partial profile drilldown | `COURSE_LEADER`, `MENTOR`, `SYSTEM_ADMIN` | all students, mentee detail, admin student detail | bootstrap + student history + student shell routes | selectors/page tests | `LIVE-TEACHING`, `LIVE-PROOF` | teaching parity screenshot, student-shell screenshot | 04A, 04B |

## Negative Paths
| Negative Path | Owner Role | Entry Route Or Surface | Backend/API Dependency | Repo-local Proof | Live Proof | Primary Artifact | Owning Stage |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Non-admin blocked from sysadmin routes | `COURSE_LEADER`, `MENTOR`, `HOD` | session + admin route fetch | session/auth guards | `cd air-mentor-api && npx vitest run tests/session.test.ts` | `LIVE-SESSION` | session-security report | 08B |
| Non-active proof run selection blocked for academic roles | `COURSE_LEADER`, `MENTOR`, `HOD` | proof run selection | academic access rules | `cd air-mentor-api && npx vitest run tests/academic-access.test.ts` | `LIVE-SESSION`, `LIVE-PROOF` | session-security report, proof screenshots | 08B |
| Mentor blocked from out-of-scope student shell | `MENTOR` | student shell | student-shell scope rules | backend student-shell tests | `LIVE-PROOF` | student-shell screenshot | 08B |
| HoD blocked outside supervised scope | `HOD` | faculty profile, HoD analytics, student shell | faculty context access + HoD analytics | backend HoD/profile tests | `LIVE-PROOF` | HoD screenshot | 08B |
| Missing CSRF token rejected | any authenticated role | mutating admin/academic routes | session CSRF contract | `cd air-mentor-api && npx vitest run tests/session.test.ts` | `LIVE-SESSION` | session-security report | 08B |
| Bad origin rejected | browser client | session/login and mutations | CORS + origin enforcement | session tests | `LIVE-CONTRACT`, `LIVE-SESSION` | session-security report | 08B |
| Invalid checkpoint fallback is explicit | all proof viewers | proof playback restore | proof playback selection + checkpoint routes | proof playback tests | `LIVE-PROOF`, `LIVE-KEYBOARD` | keyboard report, proof screenshots | 08B |
| No mock data on proof-scoped surfaces | all proof viewers | teacher, HoD, risk explorer, student shell | proof routes + runtime selectors + provenance-bearing payload contracts | `LOCAL-PROOF` | `LIVE-PROOF`, `LIVE-TEACHING` | proof screenshot family, teaching parity screenshot | 01B, 04B |
| Proof-inactive HoD slice returns empty state instead of false data | `HOD` | HoD overview | HoD proof summary | HoD proof tests | `LIVE-PROOF` | HoD screenshot | 04B |
| Queue/state diagnostics do not hide degraded conditions | `SYSTEM_ADMIN` | proof control plane | dashboard service + telemetry | dashboard service tests | `LIVE-PROOF`, `LIVE-CLOSEOUT` | proof screenshot, closeout artifacts | 02B, 08C |
| Accessibility tab/panel contracts hold on dense proof/admin surfaces | all keyboard users | proof/admin tab rails | shared shell + accessibility contracts | `npm test -- --run tests/system-admin-accessibility-contracts.test.tsx tests/system-admin-proof-dashboard-workspace.test.tsx tests/faculty-profile-proof.test.tsx tests/risk-explorer.test.tsx tests/student-shell.test.tsx` | `LIVE-A11Y`, `LIVE-KEYBOARD` | accessibility report, keyboard report | 05A, 05B, 08B |
