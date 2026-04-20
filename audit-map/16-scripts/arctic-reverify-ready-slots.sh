#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

usage() {
  cat >&2 <<'EOF'
Usage: arctic-reverify-ready-slots.sh [--slot <slot>] [--force]

Re-probe slots after cooldown expiry or when their current execution model
falls below the enforced provider floor.
EOF
  exit 64
}

requested_slots=()
force="0"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --slot) requested_slots+=("$(arctic_slot_slug "${2:-}")"); shift 2 ;;
    --force) force="1"; shift ;;
    --help|-h) usage ;;
    *) usage ;;
  esac
done

collect_slots() {
  local status_file=""
  local slot=""
  if [ "${#requested_slots[@]}" -gt 0 ]; then
    printf '%s\n' "${requested_slots[@]}" | sort -u
    return 0
  fi
  if list_slots_from_map >/dev/null 2>&1; then
    list_slots_from_map | sort -u
    return 0
  fi
  for status_file in "$AUDIT_STATUS_ROOT"/arctic-slot-*.status; do
    [ -f "$status_file" ] || continue
    slot="$(basename "$status_file")"
    slot="${slot#arctic-slot-}"
    slot="${slot%.status}"
    printf '%s\n' "$slot"
  done | sort -u
}

should_probe_slot() {
  local status_file="${1:-}"
  local provider=""
  local execution_verification_state=""
  local execution_model=""
  local execution_route_state=""
  local model_rank="0"
  local min_rank="0"

  [ -f "$status_file" ] || return 1
  provider="$(read_env_value "$status_file" provider 2>/dev/null || true)"
  execution_verification_state="$(read_env_value "$status_file" execution_verification_state 2>/dev/null || true)"
  execution_model="$(read_env_value "$status_file" execution_model 2>/dev/null || true)"
  execution_route_state="$(read_env_value "$status_file" execution_route_state 2>/dev/null || true)"
  model_rank="$(provider_model_rank "$provider" "$execution_model")"
  min_rank="$(minimum_execution_rank_for_provider "$provider")"

  [ "$force" = "1" ] && return 0
  cooldown_active_in_file "$status_file" && return 1
  case "$execution_route_state" in
    verified)
      [ "$model_rank" -lt "$min_rank" ] && return 0
      return 1
      ;;
    quota-blocked|cooling-down)
      return 1
      ;;
    *)
      return 0
      ;;
  esac
}

while IFS= read -r slot; do
  [ -n "$slot" ] || continue
  status_file="$(status_path_for_slot "$slot")"
  [ -f "$status_file" ] || continue
  if should_probe_slot "$status_file"; then
    set +e
    bash "$SCRIPT_DIR/arctic-verify-slot-execution.sh" --slot "$slot" --probe-best --format default >/dev/null
    probe_rc="$?"
    set -e
    if [ "$probe_rc" -ne 0 ]; then
      upsert_env "$status_file" execution_last_probe_failure_class "probe-command-failed"
      upsert_env "$status_file" execution_last_error_summary "Batch reverify probe command exited with code $probe_rc"
      upsert_env "$status_file" execution_last_checked_at "$(timestamp_utc)"
      upsert_env "$status_file" updated_at "$(timestamp_utc)"
      update_slot_execution_route_state "$status_file"
    fi
  fi
done < <(collect_slots)
