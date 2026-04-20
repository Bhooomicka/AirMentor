# No Expenses Spared Final Closure Campaign

Version: `v1.0`

You are not here to strengthen an already-good audit.

You are here to break any false sense of completeness that still exists in the AirMentor audit corpus and either close those gaps or leave only sharply bounded, evidence-backed blockers.

Assume the current corpus is strong but still incomplete.
Assume previously "completed" passes can still hide omission through underrepresentation, stale evidence, shallow coverage, weak artifact quality, or unchallenged synthesis drift.

## Mission

Run the most adversarial, detail-maximizing closure sweep practical against the current repository and audit corpus.

Your job is to answer, with evidence rather than optimism:

1. what still is not fully mapped
2. where the current audit is too coarse to be trusted as exhaustive
3. which remaining gaps are real blockers versus harmless structure placeholders
4. whether any path family can still surprise the operator during later fix work

You must prefer omission discovery over narrative polish.

## Current Closure Blockers To Treat As Seed Evidence

These are mandatory starting points, not an exhaustive list. You must challenge them and also look beyond them.

- exhaustive every-component interaction mapping outside currently mapped frontend clusters
- `src/data.old.ts` archival vs deletion disposition
- duplicate `audit-map/06-data-flow/` vs `audit-map/06-data-flows/` naming drift and cleanup decision
- deployed proof-refresh worker liveness / continuity
- fresh proof-risk artifact regeneration in a less restricted environment
- live proof-risk artifact availability, fallback frequency, and same-student cross-surface parity
- telemetry and startup-diagnostics family across frontend and backend
- backend helper cluster around active-run / authoritative-first / live-run / section-risk / provisioning
- same-student parity seed generator and its consumers
- closeout artifact snapshot and Railway recovery helper scripts
- safe read-only live proof / parity observer for deployed same-target comparisons
- deployment dependency posture for Python NLP, `sentence-transformers`, and optional Ollama support
- workflow semantic gap hardening where local-seeded runs can be misread as live truth
- live authenticated admin flows
- live teacher / HoD / mentor / student flows
- deployment automation edge cases and stale artifact detection
- seed-data-to-live parity

## Non-Negotiable Audit Posture

1. Treat "mapped" as suspect until you verify representation depth.
2. Treat family-level descriptions as insufficient when later fix work would require component-, helper-, or route-level determinism.
3. Treat empty audit-map folders as needing classification: intentional placeholder, stale structure drift, or missed corpus.
4. Treat pass completion metadata as weak if durable artifacts or report bodies are missing.
5. Treat live claims as invalid unless directly observed or explicitly blocked with deterministic resume instructions.
6. Treat "nothing left" as disallowed unless the remaining uncovered list becomes either near-empty or fully justified.

## Required Method

Perform all of the following:

1. Rebuild the current inventory from repository truth, not memory:
   - frontend components, pages, route shells, route helpers, repositories, selectors, telemetry, diagnostics, and restore paths
   - backend modules, helper libraries, migrations, queue workers, seed/provisioning flows, and parity/proof scripts
   - scripts, workflow files, live verification helpers, deployment helpers, and closeout automation
   - tests and what exact semantics they do or do not cover
2. Cross-diff that inventory against:
   - `audit-map/23-coverage/coverage-ledger.md`
   - `audit-map/23-coverage/unreviewed-surface-list.md`
   - `audit-map/23-coverage/review-status-by-path.md`
   - `audit-map/32-reports/unknown-omission-ledger.md`
   - `audit-map/32-reports/closure-readiness-verdict.md`
   - current final maps and deep-pass artifacts
3. Identify every place where representation is still too coarse for later deterministic fix work.
4. Separate:
   - newly discovered omissions
   - previously known omissions that are still open
   - stale blockers that are no longer real
   - claimed coverage that must be downgraded
5. Force a line-of-attack for each surviving blocker:
   - mapped this run
   - blocked by environment / credentials / billing / deployment state
   - requires dedicated next pass

## Mandatory Depth Questions

For each significant uncovered or weakly-covered family, answer:

1. what exact files are in scope
2. what user-visible or operator-visible behavior they control
3. what hidden state, persistence, replay, restore, seed, queue, or workflow semantics they carry
4. whether the current audit already captures them at usable granularity
5. what contradiction or drift risk remains if left as-is

## Required Output Updates

You must update all relevant files touched by findings. Minimum expected outputs:

1. `audit-map/32-reports/unknown-omission-ledger.md`
2. `audit-map/23-coverage/unreviewed-surface-list.md`
3. `audit-map/23-coverage/review-status-by-path.md`
4. `audit-map/23-coverage/coverage-ledger.md`
5. `audit-map/24-agent-memory/known-ambiguities.md`
6. `audit-map/24-agent-memory/working-knowledge.md`
7. `audit-map/32-reports/closure-readiness-verdict.md`
8. `audit-map/14-reconciliation/contradiction-matrix.md` if any claim strength changes or drift is discovered
9. `audit-map/32-reports/no-expenses-spared-final-closure-report.md`

## Required Final Report Contract

`no-expenses-spared-final-closure-report.md` must contain:

1. audited scope this run
2. inventory-vs-coverage diff results
3. newly discovered omissions
4. prior blockers closed this run
5. blockers that survived and why
6. any downgraded prior confidence claims
7. whether "nothing left" is supportable
8. exact remaining blockers with deterministic next actions
9. final verdict:
   - `closure-achieved`
   - `closure-partial`
   - `closure-blocked`

## Completion Gate

This run is not complete unless one of these becomes true:

- you materially reduce the remaining uncovered set with durable evidence, or
- you prove the current remaining gaps are already the true terminal blockers and no significant additional omissions were found

If you cannot satisfy either condition, the run is incomplete and must say so explicitly.

## Prohibited Failure Modes

Do not:

- restate existing maps without challenging them
- treat broad nouns as exhaustive representation
- confuse "pass completed" with "semantics covered"
- claim closure because the queue or status files look healthy
- hide behind uncertainty without naming the exact missing evidence

If there is still something left, say exactly what it is.
