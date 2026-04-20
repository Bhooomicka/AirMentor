# Cost Escalation Policy

- start with the lowest safe verified model tier
- escalate when ambiguity cost exceeds token cost
- do not escalate by habit
- log the escalation reason in checkpoint state
- if budget telemetry is unavailable, fall back to class-based guardrails instead of pretending exact spend is known
- use Caveman only on low-risk repetitive output shaping, never as a substitute for a stronger model on high-risk reasoning
