# Arctic Capability Map

Verified from Arctic docs and local CLI:

- installable on this NixOS machine through npm global prefix
- supports terminal TUI and one-shot CLI runs
- stores project-scoped sessions and snapshots
- exposes session listing and session fork commands
- exposes usage and cost stats via `arctic stats`
- exposes provider-limit and reset visibility via `arctic run --command usage`
- designed for multiple providers and multiple accounts per provider
- coding-plan providers use browser/device auth flows
- API providers use environment-variable authentication, not browser OAuth
- installed binary evidence shows real provider handling for `codex`, `google`, and `github-copilot`
- repo-local project config is supported via `.arctic/arctic.json`
- per-account slot isolation works on this machine via `XDG_DATA_HOME` and `XDG_CONFIG_HOME`

Not yet verified locally:

- authenticated provider switching
- mid-session account switching for the current user across authenticated slots
- authenticated model enumeration for each slot
- exact provider/model entitlements for each user account

Rejected locally:

- the documented `arctic auth login <provider> --name <account>` flow is not accepted by this installed CLI build

Safe workaround:

- use one isolated Arctic slot per account
- run `arctic` with slot-specific `XDG_DATA_HOME` and `XDG_CONFIG_HOME`
- store only snapshots and status in `audit-map`, never raw auth tokens

Current integration direction:

- collect slot-local session tokens/cost with `arctic stats --json`
- collect human-visible limit/reset state with `arctic run --command usage`
- persist parsed usage fields into slot status files plus `25-accounts-routing/usage-status.md`
- treat the usage view as parseable CLI output, not as a documented structured API
