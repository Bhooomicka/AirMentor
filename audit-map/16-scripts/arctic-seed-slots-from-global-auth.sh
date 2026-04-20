#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

usage() {
  cat >&2 <<'EOF'
Usage: arctic-seed-slots-from-global-auth.sh [--slot <slot>] [--all] [--force] [--dry-run]

Seed isolated Arctic slot auth files from global Arctic auth store using
slot-map auth_source_key values.

Defaults to --all when no --slot is provided.
EOF
  exit 64
}

requested_slots=()
force="0"
dry_run="0"
all_slots="0"
global_auth_file="${ARCTIC_GLOBAL_AUTH_FILE:-$HOME/.local/share/arctic/auth.json}"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --slot)
      requested_slots+=("$(arctic_slot_slug "${2:-}")")
      shift 2
      ;;
    --all)
      all_slots="1"
      shift
      ;;
    --force)
      force="1"
      shift
      ;;
    --dry-run)
      dry_run="1"
      shift
      ;;
    --help|-h)
      usage
      ;;
    *)
      usage
      ;;
  esac
done

ensure_audit_dirs
[ -f "$global_auth_file" ] || {
  echo "Global auth file not found: $global_auth_file" >&2
  exit 66
}

if [ "$all_slots" = "1" ] || [ "${#requested_slots[@]}" -eq 0 ]; then
  mapfile -t requested_slots < <(list_slots_from_map)
fi

[ "${#requested_slots[@]}" -gt 0 ] || {
  echo "No slots selected." >&2
  exit 66
}

printf 'global_auth_file=%s\n' "$global_auth_file"

seed_slot() {
  local slot="${1:-}"
  local provider=""
  local canonical_label=""
  local identity_hint=""
  local auth_key=""
  local auth_file=""
  local auth_dir=""
  local status_file=""
  local data_home=""
  local config_home=""
  local temp_file=""
  local account_label=""
  local prior_state=""

  [ -n "$slot" ] || return 0
  provider="$(provider_for_slot "$slot" 2>/dev/null || true)"
  [ -n "$provider" ] || {
    printf 'slot=%s action=skip reason=%s\n' "$slot" "unknown-provider"
    return 0
  }

  canonical_label="$(canonical_account_label_for_slot "$slot" 2>/dev/null || true)"
  identity_hint="$(identity_hint_for_slot "$slot" 2>/dev/null || true)"
  auth_key="$(auth_source_key_for_slot "$slot" 2>/dev/null || true)"
  [ -n "$auth_key" ] || auth_key="$provider"

  data_home="$(arctic_slot_data_home "$slot")"
  config_home="$(arctic_slot_config_home "$slot")"
  auth_dir="$data_home/arctic"
  auth_file="$auth_dir/auth.json"
  status_file="$(status_path_for_slot "$slot")"

  if [ "$force" != "1" ] && [ -f "$auth_file" ]; then
    if XDG_DATA_HOME="$data_home" XDG_CONFIG_HOME="$config_home" arctic auth list 2>/dev/null | grep -qv '0 credentials'; then
      printf 'slot=%s provider=%s action=skip reason=%s\n' "$slot" "$provider" "already-seeded"
      return 0
    fi
  fi

  temp_file="$(mktemp /tmp/arctic-slot-seed.XXXXXX.json)"
  if ! python - "$global_auth_file" "$auth_key" "$provider" "$temp_file" <<'PY'
import json
import pathlib
import sys

source_path = pathlib.Path(sys.argv[1])
auth_key = sys.argv[2]
provider = sys.argv[3]
out_path = pathlib.Path(sys.argv[4])

obj = json.loads(source_path.read_text())
if auth_key not in obj:
    print(f"missing-auth-key:{auth_key}", file=sys.stderr)
    raise SystemExit(2)

slot_obj = {provider: obj[auth_key]}
out_path.write_text(json.dumps(slot_obj, indent=2) + "\n")
PY
  then
    rm -f "$temp_file"
    printf 'slot=%s provider=%s action=skip reason=%s auth_key=%s\n' "$slot" "$provider" "missing-global-auth-key" "$auth_key"
    return 0
  fi

  if [ "$dry_run" = "1" ]; then
    rm -f "$temp_file"
    printf 'slot=%s provider=%s action=dry-run auth_key=%s\n' "$slot" "$provider" "$auth_key"
    return 0
  fi

  mkdir -p "$auth_dir"
  mv "$temp_file" "$auth_file"

  account_label="${canonical_label:-$auth_key}"
  if [ -f "$status_file" ]; then
    prior_state="$(read_env_value "$status_file" state 2>/dev/null || true)"
    if [ -z "$prior_state" ]; then
      prior_state="authenticated"
    fi
    upsert_env "$status_file" slot "$slot"
    upsert_env "$status_file" provider "$provider"
    upsert_env "$status_file" state "$prior_state"
    upsert_env "$status_file" account_label "$account_label"
    upsert_env "$status_file" canonical_account_label "${canonical_label:-}"
    upsert_env "$status_file" entered_account_label ""
    upsert_env "$status_file" identity_hint "${identity_hint:-}"
    upsert_env "$status_file" label_policy_state "canonical-match"
    upsert_env "$status_file" auth_source_key "$auth_key"
    upsert_env "$status_file" seeded_from_global_auth "1"
    upsert_env "$status_file" xdg_data_home "$data_home"
    upsert_env "$status_file" xdg_config_home "$config_home"
    upsert_env "$status_file" updated_at "$(timestamp_utc)"
  else
    write_env_file "$status_file" \
      slot "$slot" \
      provider "$provider" \
      state "authenticated" \
      account_label "$account_label" \
      canonical_account_label "${canonical_label:-}" \
      entered_account_label "" \
      identity_hint "${identity_hint:-}" \
      label_policy_state "canonical-match" \
      auth_source_key "$auth_key" \
      seeded_from_global_auth "1" \
      xdg_data_home "$data_home" \
      xdg_config_home "$config_home" \
      updated_at "$(timestamp_utc)"
  fi

  printf 'slot=%s provider=%s action=seeded auth_key=%s auth_file=%s status_file=%s\n' \
    "$slot" "$provider" "$auth_key" "$auth_file" "$status_file"
}

for slot in "${requested_slots[@]}"; do
  seed_slot "$slot"
done
