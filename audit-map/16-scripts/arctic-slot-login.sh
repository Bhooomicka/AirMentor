#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

usage() {
  cat >&2 <<'EOF'
Usage:
  arctic-slot-login.sh <provider:slot> [provider:slot...]
  arctic-slot-login.sh codex:codex-01 codex:codex-02 google:google-main github-copilot:copilot-raed

Each slot uses its own isolated Arctic state directory under:
  ~/.local/share/air-mentor-audit/arctic-slots/<slot>/data
  ~/.config/air-mentor-audit/arctic-slots/<slot>/config
EOF
  exit 64
}

[ "$#" -gt 0 ] || usage
command -v arctic >/dev/null 2>&1 || { echo "arctic is not installed or not on PATH" >&2; exit 69; }

ensure_audit_dirs

for spec in "$@"; do
  provider="${spec%%:*}"
  raw_slot="${spec#*:}"
  [ -n "$provider" ] || usage
  [ "$raw_slot" != "$spec" ] || usage

  slot="$(arctic_slot_slug "$raw_slot")"
  data_home="$(arctic_slot_data_home "$slot")"
  config_home="$(arctic_slot_config_home "$slot")"
  snapshot_dir="$(account_snapshot_dir_for_slot "$slot")"
  status_file="$(status_path_for_slot "$slot")"
  canonical_label="$(canonical_account_label_for_slot "$slot" 2>/dev/null || true)"
  identity_hint="$(identity_hint_for_slot "$slot" 2>/dev/null || true)"
  existing_auth_source_key="$(read_env_value "$status_file" auth_source_key 2>/dev/null || true)"
  existing_seeded_from_global_auth="$(read_env_value "$status_file" seeded_from_global_auth 2>/dev/null || true)"
  mkdir -p "$snapshot_dir"

  printf '\n=== Arctic slot %s (%s) ===\n' "$slot" "$provider"
  printf 'Credential store:\n'
  printf '  XDG_DATA_HOME=%s\n' "$data_home"
  printf '  XDG_CONFIG_HOME=%s\n' "$config_home"
  printf 'Browser guidance:\n'
  printf '  - Complete auth in the intended browser account only.\n'
  printf '  - Use a fresh browser profile or incognito window if the chooser is sticky.\n'
  printf '  - Close the browser auth tab after Arctic reports success.\n\n'

  write_env_file "$status_file" \
    slot "$slot" \
    provider "$provider" \
    state "starting-login" \
    auth_source_key "${existing_auth_source_key:-}" \
    seeded_from_global_auth "${existing_seeded_from_global_auth:-}" \
    xdg_data_home "$data_home" \
    xdg_config_home "$config_home" \
    updated_at "$(timestamp_utc)"

  run_arctic_for_slot "$slot" auth login "$provider" || true
  auth_output="$(arctic_auth_list_output "$slot")"
  snapshot_file="$snapshot_dir/auth-list-$(compact_timestamp).txt"
  printf '%s\n' "$auth_output" >"$snapshot_file"

  slot_state="missing"
  account_label=""
  entered_account_label=""
  label_policy_state="not-authenticated"
  if printf '%s' "$auth_output" | grep -qv '0 credentials'; then
    slot_state="authenticated"
    label_policy_state="manual-review"
    if [ -n "$canonical_label" ]; then
      printf 'Canonical slot label: %s\n' "$canonical_label"
    fi
    if [ -n "$identity_hint" ]; then
      printf 'Expected identity hint: %s\n' "$identity_hint"
    fi
    if [ "$provider" = "anthropic" ]; then
      printf 'Anthropic requires explicit account labeling for deterministic re-auth and troubleshooting.\n'
      while [ -z "$entered_account_label" ]; do
        printf 'Type exact Anthropic account email/name used in Zen browser (required): '
        read -r entered_account_label
      done
      account_label="$entered_account_label"
      if [ -n "$canonical_label" ] && [ "$entered_account_label" != "$canonical_label" ]; then
        label_policy_state="anthropic-explicit-label-differs-from-canonical"
      else
        label_policy_state="anthropic-explicit-label"
      fi
    else
      printf 'Press Enter to accept the canonical label, or type the actual authenticated label if it differs.\n'
      printf '(examples: Raed, GeoWake App, accneww432, youaretalkingtoraed@gmail.com): '
      read -r entered_account_label
      if [ -n "$canonical_label" ]; then
        account_label="$canonical_label"
        if [ -z "$entered_account_label" ] || [ "$entered_account_label" = "$canonical_label" ]; then
          entered_account_label=""
          label_policy_state="canonical-match"
        else
          label_policy_state="entered-differs-from-canonical"
        fi
      else
        account_label="${entered_account_label:-unknown}"
        entered_account_label=""
        label_policy_state="entered-without-canonical-map"
      fi
    fi
  fi

  write_env_file "$status_file" \
    slot "$slot" \
    provider "$provider" \
    state "$slot_state" \
    account_label "${account_label:-unknown}" \
    canonical_account_label "${canonical_label:-}" \
    entered_account_label "${entered_account_label:-}" \
    identity_hint "${identity_hint:-}" \
    label_policy_state "$label_policy_state" \
    auth_source_key "${existing_auth_source_key:-}" \
    seeded_from_global_auth "${existing_seeded_from_global_auth:-}" \
    xdg_data_home "$data_home" \
    xdg_config_home "$config_home" \
    snapshot_file "$snapshot_file" \
    updated_at "$(timestamp_utc)"

  printf 'Auth list for slot %s:\n\n%s\n\n' "$slot" "$auth_output"
  printf 'Snapshot saved to %s\n' "$snapshot_file"
  printf 'Status saved to %s\n' "$status_file"
  printf 'Press Enter to continue to the next slot, or Ctrl+C to stop.\n'
  read -r _
done

printf '\nAll requested Arctic slot logins have been attempted.\n'
