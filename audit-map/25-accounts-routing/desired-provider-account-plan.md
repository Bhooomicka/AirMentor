# Desired Provider Account Plan

This plan reflects the current intended account surface for the AirMentor audit environment.

## Arctic Slot Strategy

The installed Arctic build on this machine does not expose the documented `arctic auth login <provider> --name <account>` flag in CLI help and rejected local `--name` attempts.

Therefore, multi-account handling is implemented through isolated Arctic state directories per slot instead of shared global auth.

Each slot gets:

- `~/.local/share/air-mentor-audit/arctic-slots/<slot>/data`
- `~/.config/air-mentor-audit/arctic-slots/<slot>/config`

## Planned Slots (19 Total)

- `1` anthropic slot: `anthropic-main`
- `9` antigravity slots: `antigravity-main` + `antigravity-02`..`antigravity-09`
- `6` codex slots: `codex-01`..`codex-06`
- `2` copilot slots: `copilot-raed2180416`, `copilot-accneww432`
- `1` google slot: `google-main` only

Canonical slot source of truth:

- `audit-map/25-accounts-routing/slot-map.tsv`

The slot map now includes `auth_source_key` so each isolated slot can be seeded from one credential in the global Arctic auth store.

## Non-Interactive Slot Seeding

Run once whenever global auth store has fresh credentials:

```bash
bash audit-map/16-scripts/arctic-seed-slots-from-global-auth.sh --all --force
```

Then refresh models/usage/verification for all mapped slots:

```bash
bash audit-map/16-scripts/arctic-refresh-usage-report.sh
```

Notes:

- `google-main` is intentionally pinned to the only known-working Google account.
- Other Google credentials can exist in global store but are not mapped into pipeline slots.

## Safe Login Order

1. `anthropic-main`
2. `antigravity-main`
3. `codex-06`
4. `copilot-raed2180416`
5. `google-main`
6. all remaining mapped slots (`second-wave`)

Reason:

- validate one slot per provider first
- validate your preferred codex seat early
- confirm singleton Google path before bulk refresh

## Operator Rule

When `arctic-slot-login.sh` asks for account label, use canonical label from `slot-map.tsv` for that slot.

## Post-Login Verification

After each slot login:

1. run `bash audit-map/16-scripts/arctic-slot-status.sh`
2. inspect the slot snapshot in `18-snapshots/accounts/<slot>/`
3. if authentication succeeded, optionally refresh visible models for that slot:
   - `bash audit-map/16-scripts/arctic-slot-models.sh --slot <slot> --refresh`
