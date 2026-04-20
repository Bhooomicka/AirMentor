# Context Compaction Policy

- Externalize memory to files first; compaction is a secondary tool, not the primary memory system.
- Compact only after a pass has written a faithful checkpoint and updated ledgers.
- Never compact away contradictions, evidence paths, or unresolved questions.
- Use terse summaries for low-risk bookkeeping only; keep high-stakes reasoning prompts explicit.
