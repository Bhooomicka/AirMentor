# Model Routing Eval

The routing system is acceptable only if:

- the chosen slug is actually available locally
- the execution path is distinguished between `model-visible` and `execution-verified`
- the task class and risk class are written down
- escalations are recorded
- unavailable official variants fall back explicitly, not implicitly
- provider waiting is bounded rather than infinite
- slot selection is ranked deterministically, not first-match accidental
- native account context is not mislabeled as a specific user account when the session identity is not proven
