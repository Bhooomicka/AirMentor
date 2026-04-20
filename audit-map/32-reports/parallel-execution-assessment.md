# Parallel Execution Assessment

Date: 2026-04-15

## Current On-Disk Reality

- The durable unattended automation is a sequential tmux-backed queue driven by `audit-map/16-scripts/night-run-orchestrator.sh`.
- There is no repo-local durable subagent scheduler, no persisted fan-out planner, and no resumable multi-pass merge controller on disk.
- A repo-wide text search over `audit-map/`, `scripts/`, `src/`, `air-mentor-api/`, and `.github/` found no repo-local use of `spawn_agent`, `/fleet`, `delegate`, or any equivalent persisted subagent orchestration hook.
- Current unattended failover is provider/model/account failover, not parallel task execution.

## Why This Is Not A Bug By Itself

- The main forensic passes all write shared durability files:
  - `23-coverage/coverage-ledger.md`
  - `24-agent-memory/working-knowledge.md`
  - `14-reconciliation/contradiction-matrix.md`
  - final-map outputs under `15-final-maps/`
- Running multiple major passes concurrently without a merge discipline would create write races, stale overwrites, contradiction loss, or false completeness signals.
- For this audit, deterministic resumability is more important than naive parallel fan-out.

## Research / Documentation Implication

- Official GitHub Copilot docs now document autonomous task completion, custom agents, and parallel task execution in Copilot CLI, but that is not wired into this repo's Arctic/tmux automation today.
- Recent agent research supports decomposition plus selective subtask parallelism, not blanket parallelism:
  - hierarchical planner + subagents can improve throughput on decomposable tasks
  - planning quality remains a limiting factor, so weak planning or over-parallelization increases backtracking and drift
- Therefore the optimal posture for this repo is:
  - sequential macro-pipeline for shared-ledger forensic passes
  - bounded provider/model failover for resilience
  - optional parallelism only for disjoint write scopes or read-only extraction waves

## Safe Recommendation

- Keep the main overnight forensic pipeline sequential.
- Allow parallel fan-out only for narrowly scoped tasks that do not share write targets, for example:
  - read-only inventory refresh helpers
  - provider/model verification probes
  - artifact capture into separate timestamped files
  - isolated exploratory analyses that write only to pass-specific scratch files before a later merge pass
- Do not run `role-surface-pass`, `feature-atom-pass`, `dependency-pass`, `data-flow-pass`, `state-flow-pass`, `ml-audit-pass`, or `audit-the-audit-pass` concurrently against the same shared ledgers without a dedicated merge controller.

## Practical Conclusion

- The current setup is efficient for durability and resumability.
- It is not yet a durable parallel-subagent operating system on disk.
- For this project, that is mostly the correct tradeoff until a merge-safe parallel layer exists.
