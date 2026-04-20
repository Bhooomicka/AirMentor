# UX Friction Ledger

Pass: `ux-friction-pass`
Scope: local code, tests, configs, and audit artifacts only. Live browser verification was not performed in this pass.

## Pass Meta

- Model: `gpt-5.4-mini`
- Provider/account: native Codex / native-codex-session
- Caveman used: no
- Live verification: no
- Next pass: `live-behavior-pass`
- Manual checkpoint required: no

## Coverage Notes

- Every important workflow in this pass has either a friction assessment below or an explicit low-friction note.
- The strongest friction cluster is still the sysadmin proof/request/hierarchy stack, followed by course setup, then mentor/HoD/proof drilldowns.
- Live behavior, live auth/session parity, and live production-data legibility remain unverified in this pass.

## Workflow-Level Friction Notes

- The main UX burden comes from screens that expose multiple state families at once: canonical state, active state, restore state, and proof or policy provenance.
- The most error-prone action models are the ones that compress several backend transitions into one visible button or rely on a label that changes meaning by status.
- Dense tab sets are acceptable when the surrounding states are obvious, but they become fragile when combined with stage locks, proof vocabulary, or hidden restore semantics.
- Mentor and HoD drilldowns are structurally clearer than the admin control plane, but they still hide state transitions inside filters, chips, and secondary actions.
- The system-admin history archive and recycle-bin restore page is comparatively low friction and mostly self-explanatory.

## Control-Level Friction Notes

- Status buttons that morph by current state are hard to scan because the user has to infer the hidden next transition rather than reading it directly.
- Lock icons on tabs help, but they do not explain why a tab is locked or what unlocks it.
- Summary cards that double as filters are easy to miss as navigation controls.
- Restore and reset labels recur across proof, history, and queue surfaces, but they refer to different state families.
- Advanced toggles hidden behind warning copy are discoverable only after the user understands the default flow.
- Several surfaces rely on terminology such as `checkpoint`, `proof rail`, `no-action comparator`, `Watching`, and `policy-derived`, which is precise but expensive to parse on first contact.

## Role-Specific Asymmetry Notes

- `SYSTEM_ADMIN` gets the richest control plane and also the highest hidden-state burden.
- Course Leader has a relatively simple dashboard bridge, but the downstream course setup screens become dense and stage-gated.
- Mentor sees the most card-based shortcut density; the same card patterns are used as metrics, filters, and drilldowns.
- HoD has read-only governance framing, but queue semantics split between `Action Needed`, `Watching`, `Resolved`, and separate unlock-review handling.
- Student shell is intentionally bounded and lower-risk; the chat cannot override policy-derived records, which is clear but not obvious to users who expect a conversational authority.

## UX Friction Entries

### Course Leader Dashboard Bridge
- Surface or workflow: Course Leader Dashboard overview and its quick jump into calendar/timetable planning
- Role: Course Leader
- User goal: See a high-level course summary and jump quickly into planning or pending actions
- Friction point: Low-to-moderate friction; the only subtlety is that the statistic cards are also navigation targets, so the screen mixes readout and action without a strong affordance
- Trigger or state: Dashboard with non-zero high-watch students or pending actions
- Affected controls: `Open Calendar / Timetable` button, `Total Students`, `High Watch Students`, and `Pending Actions` cards
- Cognitive-load source: Summary cards are simultaneously metrics and shortcuts
- Discoverability issue: The cards do not obviously read as clickable controls unless the user already knows the pattern
- Consequence: Users may miss a shortcut, but the workflow itself remains straightforward
- Evidence: `src/academic-route-pages.tsx:139-150`
- Suggested follow-up: Add a small click affordance or secondary label if user testing shows missed discovery
- Confidence: Medium

### System-Admin Request Lifecycle Buttons
- Surface or workflow: System-admin request list/detail workspace
- Role: `SYSTEM_ADMIN`
- User goal: Move a request through its lifecycle and keep the status history visible
- Friction point: The visible action is a single status-driven button that changes label by current state, while the backend still supports `Needs Info` and `Rejected` transitions that are not surfaced as direct actions
- Trigger or state: A selected request in `New`, `In Review`, `Needs Info`, `Approved`, or `Implemented`
- Affected controls: Selected-request status chip, advance button, status history cards, notes, request metadata
- Cognitive-load source: The action surface and the backend state machine do not expose the same branching model
- Discoverability issue: There is no direct affordance for `Needs Info` or `Rejected`, so the operator must infer whether the omission is intentional
- Consequence: Smart users can hesitate, take the wrong next step, or trust the history panel more than the action panel itself
- Evidence: `src/system-admin-request-workspace.tsx:81-92`; `air-mentor-api/src/modules/admin-requests.ts:60-66, 308-383`
- Suggested follow-up: Expose explicit `Needs Info` and `Rejected` actions or rename the current button to show the actual next transition
- Confidence: High

### System-Admin Proof Control Plane and Checkpoint Playback
- Surface or workflow: Dedicated proof dashboard, checkpoint rail, and playback controls
- Role: `SYSTEM_ADMIN`
- User goal: Inspect the active proof run, choose a checkpoint, and replay or reset proof state with confidence
- Friction point: The screen mixes active semester selection, checkpoint selection, playback stepping, session-storage tab restore, and override banners, so a user can be looking at multiple authoritative states at once
- Trigger or state: Selected checkpoint changes, playback is blocked, or a tab restores from session storage
- Affected controls: Proof rail, semester buttons, checkpoint buttons, `Reset Playback To Semester 1`, `Reset Branch From Scratch`, `Previous`, `Next`, `Play To End`, tab strip, launcher popup
- Cognitive-load source: Hidden coupling between active semester, checkpoint selection, selected tab, restore notices, and queue progression
- Discoverability issue: Terms such as `no-action comparator`, `playback override`, and `runtime evidence` are precise but not self-explanatory to a first-time operator
- Consequence: The operator can confuse the canonical proof state with the displayed checkpoint or miss why playback is blocked
- Evidence: `src/system-admin-proof-dashboard-workspace.tsx:34-35, 249-269, 488-649, 682-878`
- Suggested follow-up: Collapse the canonical state into one more obvious summary chip or add a tighter legend for the active semester, selected checkpoint, and blocked-progress reasons
- Confidence: High

### System-Admin Hierarchy Rail and Canonical Proof Batch
- Surface or workflow: Hierarchy navigator, batch scope selection, and canonical proof batch handoff
- Role: `SYSTEM_ADMIN`
- User goal: Move through faculty, department, branch, batch, and course levels without losing scope
- Friction point: The same concept is described as year, batch, pilot cohort, active simulation batch, and canonical proof batch, so scope semantics are easy to blur
- Trigger or state: Any hierarchy node selection, especially when the current batch is not the canonical proof batch
- Affected controls: Selector controls, `Open Canonical Proof Batch`, restore notice, hierarchy cards, batch navigation chips
- Cognitive-load source: The hierarchy rail, proof-batch provenance, and restore messaging all describe the current scope in different terms
- Discoverability issue: The `Year` alias is explicitly documented, but the alias still forces the user to translate UI vocabulary into backend vocabulary
- Consequence: Users can easily inspect or edit the wrong scope or misunderstand whether they are on the active simulation target
- Evidence: `src/system-admin-faculties-workspace.tsx:1522, 1585, 1822-1834`
- Suggested follow-up: Use a single primary label for the canonical scope and keep aliases visually secondary
- Confidence: High

### System-Admin Curriculum Inputs and Synthetic Provisioning
- Surface or workflow: Curriculum model inputs, linkage review, binding mode selection, and provisioning controls
- Role: `SYSTEM_ADMIN`
- User goal: Edit curriculum rows, bind them at the right scope, regenerate linkage candidates, and provision live offerings safely
- Friction point: The panel combines binding mode, target scope, profile pinning, generator status, prerequisite validation, model-input editing, and an advanced synthetic provisioning switch in one dense workspace
- Trigger or state: Batch-local override active, target mode is `scope-profile`, or synthetic provisioning is disabled by default
- Affected controls: Binding mode select, pinned profile select, target mode select, target scope select, `Save Binding`, `Regenerate Selected Course`, `Approve Link`, `Reject Link`, curriculum textareas, synthetic provisioning toggle
- Cognitive-load source: Several different scopes and data flows share one form, while the advanced test path is intentionally hidden from the default flow
- Discoverability issue: The user must understand the difference between inherited profile, local override, shared model inputs, and mock-identity provisioning before making safe changes
- Consequence: Users may write to the wrong scope, miss why a binding is inherited versus local-only, or be surprised when mock identities are hidden until the advanced switch is enabled
- Evidence: `src/system-admin-faculties-workspace.tsx:1020-1046, 1145-1420, 1843-2039`
- Suggested follow-up: Split binding, modeling, and synthetic provisioning into clearer subpanels or add stronger scope labels to the save actions
- Confidence: High

### Course Detail Tabs, Stage Locks, and TT Blueprint Builder
- Surface or workflow: Course detail page, assessment tabs, and TT1 / TT2 blueprint editing
- Role: Course Leader
- User goal: Review the semester checklist, open the right tab, and edit term-test structure safely
- Friction point: The page exposes many tabs at once, some tabs are stage-locked, and the TT builder changes behavior after marks exist, so the user has to track both stage readiness and structural editability
- Trigger or state: Stage below 2, TT scores already entered, or scheme not yet configured
- Affected controls: Tab strip, locked tab indicators, semester checklist rows, `Add Question`, `Add Part`, blueprint inputs, gradebook and assessment tables
- Cognitive-load source: The UI mixes navigation, readiness tracking, and score-entry rules into one horizontal space
- Discoverability issue: The lock icon signals that something is blocked, but it does not explain why or what action unlocks it; `Structure Frozen` and `Locked` are also easy to conflate
- Consequence: Users may try to edit a locked blueprint, misread whether a structure can still be changed, or lose time translating CE / SEE and weightage terminology
- Evidence: `src/pages/course-pages.tsx:67-138, 179-184, 193-234, 435-454, 560-770`
- Suggested follow-up: Add reason text for locked tabs and frozen structures, and keep the editability rules near the action buttons
- Confidence: High

### Calendar/Timetable Dual-Mode Planning
- Surface or workflow: Calendar month/day view and timetable week canvas
- Role: Course Leader or any editable role
- User goal: Inspect scheduled work and make date-bound or time-bound changes without losing context
- Friction point: The same page switches between two mental models, and editability depends on role, mode, and selected date; the day panel is also conditional, which makes the screen feel like it changes shape underneath the user
- Trigger or state: Mode switch, read-only role, hidden day panel, Sunday selection, timetable bounds edit
- Affected controls: Calendar / Timetable mode toggle, previous / next month, previous / next day, `Expand`, day panel, `Update bounds`, time inputs
- Cognitive-load source: Selected date, month anchor, selected week, visible bounds, and role editability all influence what the controls mean
- Discoverability issue: The day panel can disappear and Sunday is intentionally unscheduled, so the user has to infer why a selected date no longer yields an edit surface
- Consequence: Planning edits can feel like they vanish when the user switches views, and the week-bounds workflow is easy to miss until they discover the time inputs
- Evidence: `src/pages/calendar-pages.tsx:1114-1283`
- Suggested follow-up: Show the current mode and editing scope more aggressively, especially when the day panel is hidden or the role is read-only
- Confidence: High

### Mentor Workbench Filters and Queue Drilldowns
- Surface or workflow: Mentor dashboard, filter cards, and action queue
- Role: Mentor
- User goal: Find mentees, prioritize risk, and jump to the right student context quickly
- Friction point: The summary cards are both metrics and filters, but they look like passive stats; the action queue also duplicates the same student drilldowns already available from the cards
- Trigger or state: Pending mentor actions are present or risk filters are applied
- Affected controls: Search field, total / high / medium / low cards, action queue, `Open Student`, `Risk Explorer`, `Student Shell` buttons
- Cognitive-load source: The same task can be reached from several places, so the hierarchy between filter, queue, and student card is not obvious
- Discoverability issue: Clickable stats are under-signaled, and the duplicate drilldowns make the navigation model feel flatter than it is
- Consequence: Users can miss a useful shortcut or waste time bouncing between the queue and the list
- Evidence: `src/academic-route-pages.tsx:408-496, 680-681`
- Suggested follow-up: Add an explicit filter affordance to the stat cards or group the queue actions into a single clearer primary action
- Confidence: Medium

### HoD Watchlist, Queue History, and Unlock Review
- Surface or workflow: HoD watchlist, queue history, and student drilldown surfaces
- Role: HoD
- User goal: Distinguish blocking work from monitored work and open the correct drilldown or review path
- Friction point: `Action Needed` versus `View All` is semantically useful but still hides the governed queue state machine, while queue history adds more states such as `Active`, `Resolved`, `Dismissed`, and `Series dismissed`
- Trigger or state: Governed open case, watching case, dismissed task, or HoD unlock request
- Affected controls: `Action Needed`, `View All`, `Inspect`, `Success Profile`, `Shell`, `Restore`, `Resume series`, `Open Unlock Review`, `Acknowledge`
- Cognitive-load source: The same student can be present in the watchlist, queue history, and drilldown modal with different blocking semantics in each place
- Discoverability issue: Watching rows remain visible but are not blocking, so the label system requires careful reading before action
- Consequence: Smart users can over-prioritize watching rows or choose restore versus unlock review incorrectly
- Evidence: `src/pages/hod-pages.tsx:412-645, 877-894`; `src/academic-route-pages.tsx:848-887, 920-997`
- Suggested follow-up: Add a short legend that distinguishes open, watching, resolved, and dismissed cases where the filters live
- Confidence: High

### Risk Explorer Proof Framing
- Surface or workflow: Risk explorer checkpoint-bound analysis
- Role: Academic roles and `SYSTEM_ADMIN`
- User goal: Understand risk, compare policy-derived status to no-action baselines, and inspect the effect of simulated interventions
- Friction point: The surface is carefully framed, but it still stacks trained heads, derived scenario heads, feature completeness, no-action comparison, simulated intervention, and policy-derived status into a single dense explanation layer
- Trigger or state: Selected checkpoint, active-risk view, or missing no-action comparator
- Affected controls: `Overview`, `Assessment Details`, `Advanced Diagnostics` tabs, provenance popup, completeness card, no-action comparator messaging
- Cognitive-load source: Several model layers and evidence layers share one screen and use similar language
- Discoverability issue: The difference between trained, derived, advisory, and policy-replayed values is not obvious from the table at a glance
- Consequence: Users may not know which value is model output and which is advisory, which weakens trust even when the computation is correct
- Evidence: `src/pages/risk-explorer.tsx:257, 265, 297, 327-333, 451, 563`
- Suggested follow-up: Add a compact legend for trained versus advisory versus policy-derived values near the headline cards
- Confidence: High

### Student Shell Proof-Bounded Explainer
- Surface or workflow: Student shell proof explainer, timeline, and bounded chat session
- Role: Academic roles and `SYSTEM_ADMIN`
- User goal: Read the authoritative student card, inspect the timeline, and ask bounded questions without leaving the proof surface
- Friction point: Lower friction than the admin control plane, but the user still has to absorb proof-specific vocabulary and the fact that chat is intentionally non-authoritative
- Trigger or state: Student shell loaded for a checkpoint-bound run
- Affected controls: `Overview`, `Topic & CO`, `Assessment Evidence`, `Interventions`, `Timeline`, `Shell Chat`, `Start Session`, `Send Prompt`
- Cognitive-load source: The proof explainer is bounded on purpose, so the user has to adjust from open-ended chat to a constrained record reader
- Discoverability issue: The chat restriction is clear once read, but users may still expect the assistant to answer outside the proof card
- Consequence: Users may have to switch back to timeline or overview for the actual record after trying chat first
- Evidence: `src/pages/student-shell.tsx:248, 368-373, 607-628`
- Suggested follow-up: Keep the bounded-chat restriction near the prompt box and keep the proof card summary prominent
- Confidence: Medium

### System-Admin History Archive and Recycle-Bin Restore
- Surface or workflow: System-admin history archive and delete-restore page
- Role: `SYSTEM_ADMIN`
- User goal: Recover archived or deleted records and review recent audit activity
- Friction point: No meaningful friction was evidenced beyond a mild archive-versus-deleted terminology split
- Trigger or state: Archived records present, soft-deleted records present, or audit trail review needed
- Affected controls: Archive list, deleted list, restore buttons, recent audit feed
- Cognitive-load source: The page is already scoped narrowly to restore and audit, so there is little hidden state to decode
- Discoverability issue: Minimal; the restore window is explicit and the page separates archived from deleted records
- Consequence: The workflow should be easy to complete with low interpretation cost
- Evidence: `src/system-admin-history-workspace.tsx:46-68, 87-128`
- Suggested follow-up: No major follow-up needed unless user testing shows confusion about archive versus deleted terminology
- Confidence: High
