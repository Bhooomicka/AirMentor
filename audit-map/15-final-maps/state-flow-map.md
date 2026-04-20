# State Flow Map

This map aggregates the state-machine families confirmed in `07-state-flows/` for bootstrap-pass local analysis.

## Coverage Snapshot

- State-flow family count: 5
- Evidence mode: local implementation + test references
- Live verification: not performed in this pass
- Contradiction carry-forward: no open local state-flow contradiction remains after current `C-006` and `C-021` reconciliations; live verification is still pending.

## Flow Index

1. `audit-map/07-state-flows/academic-session-role-page-state.md`
   - Scope: Academic session bootstrap/login, role-sync guards, route snapshot restore, proof playback restore coupling
   - Key states: `boot-loading`, `session-restoring`, `session-ready`, `page-guard-fallback`, `history-available`, `proof-restore-notice`
   - Uncertainty: live cookie/session behavior under deployed conditions

2. `audit-map/07-state-flows/admin-session-route-state.md`
   - Scope: Sysadmin hash parse/serialize, restore/login loops, workspace restore/reset
   - Key states: `route-parsed`, `session-restoring`, `workspace-restored`, `workspace-restore-invalid`, `authenticated-admin`
   - Uncertainty: live persistence and cross-browser storage behavior

3. `audit-map/07-state-flows/proof-playback-checkpoint-state.md`
   - Scope: Checkpoint persistence, invalidation, blocked progression, queued/running polling
   - Key states: `auto`, `restored`, `manual`, `checkpoint-detail-loading`, `blocked-progression`, `active-run-view`
   - Uncertainty: live queue consumer timing and stale persisted checkpoint drift

4. `audit-map/07-state-flows/runtime-shadow-conflict-and-drift-state.md`
   - Scope: Backend runtime shadow persistence, conflict guards, compatibility `/sync` routes, drift event emission
   - Key states: `validated`, `persisted-primary`, `shadow-synced`, `compatibility-route-warning`, conflict rejections
   - Uncertainty: live drift-event frequency and operator response loops

5. `audit-map/07-state-flows/admin-request-lifecycle-state.md`
   - Scope: Request status transitions across backend/UI, including hidden branch transitions
   - Key states: `New`, `In Review`, `Approved`, `Implemented`, `Closed`, backend `Needs Info`, backend `Rejected`
   - Uncertainty: whether backend/UI mismatch is intentional product policy or missing control-path parity

## State Family Checklist

- Normal/empty/loading/stale/disabled: covered where applicable
- Blocked/error/retry: covered (`blocked progression`, 401 restore loops, conflict retries)
- Suspended/resumed/restored: covered through restore/session replay and playback re-entry paths
- Archived/terminal: covered in proof/admin-request families (`archived`, `Closed`, `Rejected`)

## Frontend Microinteraction Overlay

- Detailed component-cluster interaction flows are captured in `audit-map/12-frontend-microinteractions/component-cluster-microinteraction-map.md`.
- Overlay coverage includes trigger, visible effect, local/persisted state, API consequence, downstream UI consequence, restore/re-entry, error/retry, and hidden coupling notes for six high-density clusters.
- Persisted restore-state keys explicitly covered in this overlay: `airmentor-proof-playback-selection`, `airmentor-system-admin-proof-dashboard-tab`, and `airmentor-admin-ui:<hash>`.
- Overlay contradiction carry-forward: no current local admin-request transition mismatch remains; residual risk is deployed parity, not local control-path omission.

## Confidence and Limits

- Local implementation confidence: high
- Test-backed confidence: high for routing, playback, and key admin/academic guards
- Live confidence: medium-to-low pending dedicated live-behavior pass with browser/API capture artifacts

## Backend Provenance State Families

6. `audit-map/13-backend-provenance/backend-provenance-map.md`
   - Scope: backend proof run lifecycle and provenance guarantees from migration to activated projection.
   - Key states: `queued`, `running` (leased), `failed`, `completed`, `active`, `archived`; stage-reset pending, checkpoint rebuilt, active risk recomputed, and operational projection republished.
   - Restore/re-entry states: reset snapshot restore (`restored-run-created`), parent run linkage, semester pointer activation (`activeOperationalSemester`) plus `batches.currentSemester` sync, and republish gating on active runs only.
   - Hybrid slice states: default faculty/HoD/student proof views can transition into a checkpoint-backed slice for the activated semester while keeping checkpoint-explicit provenance when `activeOperationalSemester` diverges from `batches.currentSemester` or active-risk rows are absent.
   - Derived-data regeneration states: batch-wide artifact deactivation/reactivation, active risk recompute enabled/disabled, and fallback provenance mode (`fallback-simulated`) when stage evidence is unavailable.
   - Uncertainty: live worker scheduling/atomicity under deployment constraints and transaction-level guarantees for large delete+insert projection rewrites.
