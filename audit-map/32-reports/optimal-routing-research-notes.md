# Optimal Routing Research Notes

Date: 2026-04-15

This note combines current local machine evidence with current external documentation and research.

## Local Ground Truth That Wins Over Generic Advice

- Native Codex is still the strongest fully verified execution path on this machine because both model visibility and reasoning-effort control are locally proven.
- Arctic `google-main` is execution-verified on `google/gemini-3.1-pro-preview`.
- Arctic `copilot-raed2180416` is execution-verified on `github-copilot/gemini-3.1-pro-preview`.
- Visible Copilot `gpt-5.4` still fails local runtime smoke as `model_not_supported`, so it cannot be treated as a safe unattended route despite appearing in the visible model list.

## Current External Findings

### GitHub Copilot

- GitHub documents that different Copilot models have different premium-request multipliers and that Copilot Auto picks a model based on availability.
- GitHub also documents that discounted multipliers apply when Auto is used in Copilot Chat.
- GitHub documents autonomous task completion, custom agents, and parallel task execution in Copilot CLI.

Implication for this repo:

- For a forensic audit, deterministic routing matters more than the small Auto discount.
- Therefore this repo should not hand unattended routing to Copilot Auto, even though Auto may be cheaper in some contexts.
- Instead, it should use a strict allowlist plus execution verification.

### Google Gemini

- Google documents that Gemini 3 uses `thinkingLevel`.
- Google documents that Gemini 3.1 Pro cannot disable thinking and defaults to dynamic `"high"` thinking if no level is specified.
- Google documents that Gemini 2.5 uses `thinkingBudget`, not `thinkingLevel`.

Implication for this repo:

- Treat Gemini 3 Pro-class routes as inherently strong reasoning alternates.
- Do not invent a fake Codex-style reasoning-effort control layer for Gemini when the current wrapper does not expose it.
- `gemini-2.1-pro` is not locally visible here; `gemini-2.5-pro` is the nearest real Pro fallback.

### Parallel / Subagent Research

- HPTSA shows that a planning agent launching task-specific subagents can outperform prior single-agent frameworks by up to `4.3x` on complex exploit tasks.
- DEVIL'S ADVOCATE shows that decomposition plus anticipatory reflection improved efficiency by reducing trials and plan revisions by `45%`.
- PlanBench shows that even state-of-the-art LLMs still fall short on critical planning capabilities.

Implication for this repo:

- Parallel subagents are useful only when there is a strong planner and the subtasks are cleanly decomposable.
- A weak planner or overly broad fan-out increases backtracking, drift, and false completion.
- Therefore the best setup for this audit is not blanket parallelization. It is:
  - strong planner on the critical path
  - sequential shared-ledger forensic passes
  - selective parallelism only for disjoint or read-only work
  - hard checkpointing and bounded failover

## Final Practical Conclusion

- Keep Native Codex as the primary unattended execution layer.
- Keep Google `gemini-3.1-pro-preview` as the top verified alternate.
- Keep Copilot restricted to the operator-approved allowlist.
- Do not let Copilot Auto decide unattended forensic routing, despite the potential request discount.
- Do not market the current automation as a durable parallel-subagent system on disk; it is a resilient sequential pipeline with selective verified failover.
