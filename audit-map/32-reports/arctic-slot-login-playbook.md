# Arctic Slot Login Playbook

Date: 2026-04-15

This is the exact operator flow for authenticating the currently requested account set on this machine.

## Why This Flow Exists

- the installed Arctic CLI here does not accept the documented `--name` account flag
- repeated shared-store login is therefore overwrite-risky
- each account gets its own isolated Arctic slot instead

## Canonical Slot Map

| Slot | Provider | Select this account in the browser | Type this label when prompted |
| --- | --- | --- | --- |
| `codex-06` | `codex` | `stuff rand (You)` | `stuff rand (You)` |
| `google-main` | `google` | `youaretalkingtoraed@gmail.com` | `youaretalkingtoraed@gmail.com` |
| `copilot-raed2180416` | `github-copilot` | GitHub account `Raed2180416` | `Raed2180416` |
| `copilot-accneww432` | `github-copilot` | GitHub account `accneww432` | `accneww432` |
| `codex-01` | `codex` | `dummy account` | `dummy account` |
| `codex-02` | `codex` | `GeoWake App` | `GeoWake App` |
| `codex-03` | `codex` | `Hazzy` | `Hazzy` |
| `codex-04` | `codex` | `Raed` | `Raed` |
| `codex-05` | `codex` | `raed siddiqui` | `raed siddiqui` |

## First Wave

Run:

```bash
cd /home/raed/projects/air-mentor-ui
nix develop --command bash audit-map/16-scripts/arctic-slot-login-plan.sh first-wave
```

What to do during the prompts:

1. For `codex-06`, select the ChatGPT/Codex account shown as `stuff rand (You)`.
2. For `google-main`, select `youaretalkingtoraed@gmail.com`.
3. For `copilot-raed2180416`, sign in with GitHub account `Raed2180416`.
4. Each time the script asks for the authenticated account label, type the exact label from the table above.

After the first wave finishes, verify:

```bash
cd /home/raed/projects/air-mentor-ui
bash audit-map/16-scripts/arctic-slot-status.sh
bash audit-map/16-scripts/arctic-slot-models.sh --slot codex-06 --refresh
bash audit-map/16-scripts/arctic-slot-models.sh --slot google-main --refresh
bash audit-map/16-scripts/arctic-slot-models.sh --slot copilot-raed2180416 --refresh
```

Then run one slot continuation smoke check:

```bash
cd /home/raed/projects/air-mentor-ui
bash audit-map/16-scripts/arctic-session-wrapper.sh --slot codex-06 --message "Reply with provider and model only."
```

## Second Wave

Only proceed if the first wave verified cleanly.

Run:

```bash
cd /home/raed/projects/air-mentor-ui
nix develop --command bash audit-map/16-scripts/arctic-slot-login-plan.sh second-wave
```

What to do during the prompts:

1. For `copilot-accneww432`, sign in with GitHub account `accneww432`.
2. For `codex-01`, select `dummy account`.
3. For `codex-02`, select `GeoWake App`.
4. For `codex-03`, select `Hazzy`.
5. For `codex-04`, select `Raed`.
6. For `codex-05`, select `raed siddiqui`.
7. Each time the script asks for the authenticated account label, type the exact label from the table above.

After the second wave finishes, verify:

```bash
cd /home/raed/projects/air-mentor-ui
bash audit-map/16-scripts/arctic-slot-status.sh
bash audit-map/16-scripts/arctic-slot-models.sh --slot copilot-accneww432 --refresh
bash audit-map/16-scripts/arctic-slot-models.sh --slot codex-01 --refresh
bash audit-map/16-scripts/arctic-slot-models.sh --slot codex-02 --refresh
bash audit-map/16-scripts/arctic-slot-models.sh --slot codex-03 --refresh
bash audit-map/16-scripts/arctic-slot-models.sh --slot codex-04 --refresh
bash audit-map/16-scripts/arctic-slot-models.sh --slot codex-05 --refresh
```

## After Login

Once the first wave is verified, the next main forensic pass is:

```bash
cd /home/raed/projects/air-mentor-ui
nix develop --command bash audit-map/16-scripts/run-audit-pass.sh route-map-pass --context bootstrap --model gpt-5.4-mini --reasoning-effort medium
```

Native Codex remains the primary audit execution path. Arctic slots are the continuity and fallback layer.
