# Prompt Governance

- Every reusable prompt gets a stable filename, version line, and intended task class.
- Prompt edits must update `20-prompts/prompt-change-log.md`.
- Prompts should reference file-based memory locations instead of restating long context.
- High-stakes prompts must explicitly require contradiction logging and evidence output.
- Compression or terseness layers are opt-in unless the task class policy says otherwise.
