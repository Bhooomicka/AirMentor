# AirMentor — Master Feature Registry

> Compiled from full codebase audit (110 original) + agent deep-audit delta findings.
> Total: 128 features / behaviors tracked.

---

## SECTION A — Portal, Auth & Session (11)

| # | Feature | Intent |
|---|---------|--------|
| A-01 | Portal chooser home | Let users pick Academic or System Admin entry |
| A-02 | Hash route normalization | Keep navigation stable on unusual/manual hash paths |
| A-03 | Cross-portal workspace hint clearing | Prevent stale context leaking between portals |
| A-04 | Academic session restore gate | Restore active session before showing workspace |
| A-05 | Academic login form | Authenticate faculty and load role-scoped workspace |
| A-06 | Academic role switching | Switch active role inside the same authenticated session |
| A-07 | Illegal page auto-correction | Prevent role staying on a page it cannot access |
| A-08 | Academic bootstrap with proof playback restore | Hydrate workspace using active run or saved checkpoint |
| A-09 | System Admin backend-required gate | Block admin UI if backend config is missing |
| A-10 | System Admin session restore + role-required gate | Ensure active role is SYSTEM_ADMIN before control plane renders |
| A-11 | Cookie settle retry after login or role switch | Reduce race conditions between auth mutation and session-read |

---

## SECTION B — Academic Workspace (48)

### Course Leader / Dashboard
| # | Feature | Intent |
|---|---------|--------|
| B-01 | Course Leader dashboard summary cards | Show high-level load and risk quickly |
| B-02 | Year section collapse/expand on dashboard | Reduce visual noise while preserving grouped course access |
| B-03 | Course card drilldown | Move from dashboard to detailed course workspace |
| B-04 | Course tab switching | Separate overview, risk, and assessment families |
| B-05 | Stage lock behavior in course tabs | Block premature access to stage-dependent tabs |
| B-06 | Course overview metrics and checklist | Summarize class health and stage readiness |
| B-07 | Course risk tab filtering and drilldown | Triage students by risk quickly |
| B-08 | Attendance entry tab and handoff | Capture attendance evidence for assessment and risk logic |

### Assessment / Gradebook
| # | Feature | Intent |
|---|---------|--------|
| B-09 | TT blueprint editing | Design internal test structure before score entry |
| B-10 | TT freeze behavior | Protect structure after score or lock state enters protected mode |
| B-11 | TT marks total validation | Enforce fixed raw marks policy |
| B-12 | Quiz entry hub handoff | Move into quiz scoring workflow from course shell |
| B-13 | Assignment entry hub handoff | Move into assignment scoring workflow from course shell |
| B-14 | CO attainment view | Expose CO-level evidence quality signals |
| B-15 | Gradebook readiness banner and gating | Force scheme readiness before final grade paths |
| B-16 | SEE entry CTA from gradebook context | Progress to final exam-related scoring flow once ready |

### Calendar / Planner
| # | Feature | Intent |
|---|---------|--------|
| B-17 | Academic calendar mode switch | Switch between calendar and timetable mental models |
| B-18 | Calendar navigation controls | Inspect nearby scheduling windows |
| B-19 | Planner block edit surfaces | Open details and mutate scheduling units |
| B-20 | Planner drag and resize | Adjust timings quickly |
| B-21 | Hover add target behavior | Speed insertion of new planning items |
| B-22 | Planner save and reset | Commit or discard draft changes |

### Mentor Workbench
| # | Feature | Intent |
|---|---------|--------|
| B-23 | Mentor workbench search | Find specific mentees rapidly |
| B-24 | Mentor risk filter cards | Switch queue to high, medium, low, or all slices |
| B-25 | Mentor queue row actions | Jump from triage list to deeper student surfaces |
| B-26 | Mentor contact actions | Immediate outreach from queue context |
| B-27 | Mentee detail page timeline and history shell | Keep intervention context visible while drilling deeper |
| B-28 | Mentee detail drilldowns | Pivot from profile to model/explainer surfaces |

### Queue History
| # | Feature | Intent |
|---|---------|--------|
| B-29 | Queue history filtering | Analyze active, resolved, dismissed series |
| B-30 | Queue history restore and resume | Reactivate previously hidden or completed workflow threads |
| B-31 | Queue history role-sensitive row actions | Expose only context-valid next actions per role |

### Unlock Review
| # | Feature | Intent |
|---|---------|--------|
| B-32 | Unlock review decision flow | Make bounded HoD unlock decisions with audit trail |
| B-33 | Unlock review completed-state lock | Prevent duplicate decisions after terminal transition |

### HoD Analytics
| # | Feature | Intent |
|---|---------|--------|
| B-34 | HoD analytics tab family | Split oversight across overview, courses, faculty, reassessments |
| B-35 | HoD action-needed-only toggle | Focus on unresolved governance work |
| B-36 | HoD row-level drilldowns | Trace from department-level pattern to student-level evidence |
| B-37 | HoD queue history jump | Connect high-level oversight with longitudinal queue records |

### Faculty Profile
| # | Feature | Intent |
|---|---------|--------|
| B-38 | Faculty profile read-only panel stack | Expose permissions, appointments, scope, and proof overlays without editing |
| B-39 | Faculty profile drilldowns | Jump into student evidence from faculty context |

### Student Shell
| # | Feature | Intent |
|---|---------|--------|
| B-40 | Student shell tab family | Provide bounded explainer across overview, topic-CO, assessment, interventions, timeline, chat |
| B-41 | Student shell session start and prompt send | Allow constrained Q&A over proof-backed record only |
| B-42 | Student shell timeline on-demand load | Avoid loading heavy timeline until user asks |
| B-43 | Student shell guardrail behavior | Prevent chat from becoming authoritative system-of-record editor |

### Risk Explorer
| # | Feature | Intent |
|---|---------|--------|
| B-44 | Risk explorer tab family | Separate quick view, deeper detail, and advanced diagnostics |
| B-45 | Risk explorer feature completeness gating | Communicate confidence and missing evidence families |
| B-46 | Risk explorer no-action and scenario comparison | Compare current policy posture versus alternative projections |
| B-47 | Risk explorer evidence grid drilldown | Expose drivers and component-level evidence trail |

### Proof Launcher
| # | Feature | Intent |
|---|---------|--------|
| B-48 | Proof launcher popup from academic surfaces | Keep user aware of run and checkpoint context while drilling |

---

## SECTION C — System Admin Control Plane (40)

### Navigation & Search
| # | Feature | Intent |
|---|---------|--------|
| C-01 | Top tab navigation | Move fast between overview, proof, faculties, students, faculty-members, requests |
| C-02 | Admin search dropdown | Jump directly to entity or workspace slice |
| C-03 | Breadcrumb navigation | Preserve orientation inside deep hierarchy and drilldowns |
| C-04 | Overview launch cards | Provide quick launch to critical admin workstreams |

### Action Queue
| # | Feature | Intent |
|---|---------|--------|
| C-05 | Action queue request cards | Surface time-sensitive request work first |
| C-06 | Action queue reminder cards | Keep private operator to-dos inside control plane |
| C-07 | Action queue hidden-record cards | Keep restore-worthy archive/delete events visible for action |
| C-08 | Queue bulk hide and restore controls | Triage noise quickly and recover hidden items |
| C-09 | Quick add reminder | Create operator reminder without leaving current workspace |

### Requests Workspace
| # | Feature | Intent |
|---|---------|--------|
| C-10 | Request workspace list and detail pane | Keep lifecycle actions next to context and notes |
| C-11 | Request lifecycle actions (Take Review, Needs Info, Reject, Approve, Mark Implemented, Close) | Transition requests through governance states |
| C-12 | Request note history and note add | Preserve operational narrative and evidence trail |
| C-13 | Request version conflict protection | Prevent stale overwrite in concurrent workflows |

### Proof Dashboard
| # | Feature | Intent |
|---|---------|--------|
| C-14 | Proof dashboard tabs (summary, checkpoint, diagnostics, operations) | Split run operations into logical views |
| C-15 | Checkpoint selector and detail pane | Inspect stage-specific proof state |
| C-16 | Playback controls (previous, next, play to end, reset) | Step through checkpoint chronology |
| C-17 | Proof import actions (create, validate, review crosswalks, approve) | Manage curriculum import lifecycle |
| C-18 | Proof run actions (run, rerun, retry, recompute risk, archive) | Control simulation lifecycle |
| C-19 | Activation actions (activate run, activate semester) | Set active run and active operational semester |
| C-20 | Snapshot restore actions | Recover prior proof lineage state for replay |
| C-21 | Checkpoint evidence view toggles | Switch perspective between queue and offering evidence slices |
| C-22 | Proof restore notice handling | Make restored checkpoint context explicit after persistence reentry |

### History & Archive
| # | Feature | Intent |
|---|---------|--------|
| C-23 | History workspace archive list | Inspect historical archived entities |
| C-24 | Recycle bin restore flow | Recover soft-deleted records within restore window |
| C-25 | Recent audit route opens | Jump from event log back to affected workspace context |

### Hierarchy & Scope
| # | Feature | Intent |
|---|---------|--------|
| C-26 | Hierarchy navigator chain (faculty > dept > branch > year > section) | Move scope through full institutional tree |
| C-27 | Hierarchy edit modals | Mutate scoped entity data without losing rail context |
| C-28 | Entity creation forms (faculty, department, branch, batch) | Expand institutional structure in-place |
| C-29 | Curriculum linkage candidate review | Accept or reject generated linkage proposals |
| C-30 | Curriculum feature binding controls | Bind feature profiles to scope and save policy config |
| C-31 | Canonical proof batch jump | Route operator to proof-authoritative branch context quickly |
| C-32 | Scoped registry launchers from hierarchy | Open students/faculty-members filtered to current scope |
| C-33 | Section scope selector behavior | Narrow all downstream stats and filters to section |

### Faculty Calendar (Admin)
| # | Feature | Intent |
|---|---------|--------|
| C-34 | Faculty calendar summary panel | Give quick read before heavy planner mode |
| C-35 | Open full planner modal | Focus planning edits in dedicated full-screen workflow |
| C-36 | Faculty planner recurring block edits | Modify repeating teaching schedule |
| C-37 | Faculty planner marker edits | Modify one-off schedule markers |
| C-38 | Planner save and reset in admin calendar | Commit or discard draft schedule changes |
| C-39 | Class editing lock and direct-edit window | Prevent schedule mutation outside allowed governance window |
| C-40 | Alternate timetable editor (unmounted/dormant) | Currently no user-visible entry — code exists but not routed |

---

## SECTION D — Hidden Behaviors & Deep Layer Couplings (11)

| # | Behavior | Effect if misunderstood |
|---|----------|------------------------|
| D-01 | Academic route history is in-app state, not URL router history | Back behavior differs from browser expectations |
| D-02 | Admin faculties route restores tab and section from sessionStorage by hash | Same screen can reopen with previous scoped context unexpectedly |
| D-03 | Proof playback selection persists in localStorage across sessions | Reopening can land on prior checkpoint unless invalidated |
| D-04 | Proof dashboard tab persists in sessionStorage | Reentry can start on diagnostics or checkpoint tab, not summary |
| D-05 | Search scope is route and hierarchy aware | Same query produces different results by scope |
| D-06 | Registry scope breadcrumb return is transient in-memory | Opening full registry can remove quick return path |
| D-07 | Queue dismissals are localStorage-based | Hidden cards outlive route changes and survive user changes unless explicitly cleared |
| D-08 | Role-page legality is auto-corrected | Deep linking can appear to "bounce" to role home |
| D-09 | Stage locks and frozen states are explicit UX contracts | User sees disabled/read-only rather than silent failure |
| D-10 | Empty, loading, and blocked states are first-class surfaces | These are expected user-visible outcomes, not always bugs |
| D-11 | Proof run vs checkpoint-backed slice semantics differ | Same student can present differently across default and explicit checkpoint views |

---

## SECTION E — Agent Delta Findings (18 additional)

> These were NOT in the original 110. Found during adversarial deep audit.

### Observability & Startup
| # | Feature | Severity |
|---|---------|----------|
| E-01 | FE startup environment diagnostics collection and classification | High |
| E-02 | FE startup diagnostic and ready events on both app entrypoints | High |
| E-03 | FE telemetry sink resolution hierarchy (explicit → env → API-derived relay) | High |
| E-04 | BE telemetry intake validation and relay forwarding | High |
| E-05 | BE operational event persistence dispatch and sink failure handling | Medium |

### Session, Security & Preferences
| # | Feature | Severity |
|---|---------|----------|
| E-06 | Origin enforcement + CSRF gate with telemetry path exception | High |
| E-07 | Server-backed UI preferences with version conflict and optimistic update | Medium |

### Admin Scope & Route-State
| # | Feature | Severity |
|---|---------|----------|
| E-08 | Route hash parser/serializer + route-keyed sessionStorage restore | Medium |
| E-09 | In-session routeHistory and scroll restore behavior | Medium |
| E-10 | Section scope ID encode/decode logic duplicated across two modules | Medium |
| E-11 | Dismissed queue persistence and logout clearing semantics | Medium |

### Academic Runtime API & Compatibility
| # | Feature | Severity |
|---|---------|----------|
| E-12 | Authoritative runtime endpoints (tasks, placements, calendar-audit, runtime slices) | High |
| E-13 | Deprecated compatibility sync endpoints + deprecation/sunset headers | High |
| E-14 | Successor-version Link header semantics for migration | Medium |

### Proof Lifecycle & Provenance
| # | Feature | Severity |
|---|---------|----------|
| E-15 | Proof provenance explanation contract reused across surfaces | Medium |
| E-16 | Background proof-run worker lifecycle (queue worker startup, crash, restart) | Medium |
| E-17 | Student evidence timeline endpoint (exists in client + backend, UI coverage unclear) | Medium |

### Infrastructure / Repository
| # | Feature | Severity |
|---|---------|----------|
| E-18 | Legacy data corpus (data.old.ts) — active in repo, fate undecided | Low |

---

## SECTION F — Critical Structural Issues Found (not features, but must track)

| # | Issue | Severity |
|---|-------|----------|
| F-01 | No top-level React error boundary — runtime crash collapses entire shell | Critical |
| F-02 | Admin bootstrap is fail-fast Promise.all — one endpoint failure collapses whole workspace | High |
| F-03 | Audit/contradiction matrix has stale documentation vs current code | Critical |
| F-04 | Live deployment health contract diverges from local app contract | Critical |
| F-05 | No memory leak / cleanup audit done (listeners, intervals, subscriptions on unmount) | High |
| F-06 | No error boundary audit for sub-surfaces either | High |
| F-07 | No ARIA / screen reader / live region accessibility audit done | High |

---

## Summary Count

| Section | Count |
|---------|-------|
| A — Portal, Auth & Session | 11 |
| B — Academic Workspace | 48 |
| C — System Admin Control Plane | 40 |
| D — Hidden Behaviors / Deep Couplings | 11 |
| E — Agent Delta (new finds) | 18 |
| F — Critical Structural Issues | 7 |
| **Total tracked** | **135** |
