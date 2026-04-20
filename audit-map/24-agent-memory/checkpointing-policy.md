# Checkpointing Policy

- Every pass writes a checkpoint before changing task class, model class, or provider.
- Checkpoints must include:
  - pass name
  - scope
  - files touched
  - next unresolved question
  - evidence paths produced
  - current model/provider/account if known
- Checkpoints belong in `30-checkpoints/`; summaries belong in `24-agent-memory/working-knowledge.md`.
