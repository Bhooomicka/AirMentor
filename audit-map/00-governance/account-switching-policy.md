# Account Switching Policy

- Account switches must be intentional, logged, and tied to a reason: budget, rate limit, outage, or provider-specific capability.
- Do not assume session continuity across accounts unless the tool has already proven it for the current provider.
- When automatic account switching is unverified, write the exact manual action needed and stop safely.
- For Arctic on this machine, treat one slot as one account until proven otherwise.
- Record the before/after account context in `25-accounts-routing/switch-history.md` without storing secrets or raw tokens.
- Slot ID is authoritative. Human-readable account label is metadata only.
