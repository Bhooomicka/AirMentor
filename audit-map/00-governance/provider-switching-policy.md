# Provider Switching Policy

- Provider switching is allowed only when it is explicitly recorded in `25-accounts-routing/switch-history.md`.
- Do not switch providers mid-pass unless the task is low-risk or the current provider is hard-blocked.
- When switching would risk semantic drift, stop at a checkpoint and resume as a new pass.
- Arctic may be used to coordinate providers once authenticated, but only `execution-verified` slots may be promoted into unattended execution.
- On this machine, use authenticated Arctic slots instead of the shared global auth store for repeated providers.
- If provider support cannot be verified for a task class, default to native Codex on the verified local models.
- If no verified route is available, bounded wait is allowed; infinite wait is not.
- When a provider or slot is excluded after failure, record the attempted switch in `25-accounts-routing/switch-history.md`.
- Rotation across multiple accounts is allowed only among equally policy-acceptable, execution-verified candidates.
