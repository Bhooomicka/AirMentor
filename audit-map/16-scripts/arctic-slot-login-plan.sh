#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

usage() {
  cat >&2 <<'EOF'
Usage:
  arctic-slot-login-plan.sh <first-wave|second-wave|all>

Waves:
  first-wave   one high-signal slot per provider from slot-map
  second-wave  remaining slot-map entries after first-wave
  all          every slot-map entry in order
EOF
  exit 64
}

plan="${1:-}"
[ -n "$plan" ] || usage

mapfile -t all_specs < <(list_slot_specs_from_map)
[ "${#all_specs[@]}" -gt 0 ] || {
  echo "No slot specs found in $ARCTIC_SLOT_MAP_FILE" >&2
  exit 66
}

spec_for_slot() {
  local target_slot="${1:-}"
  local spec=""
  for spec in "${all_specs[@]}"; do
    [ "${spec#*:}" = "$target_slot" ] && {
      printf '%s\n' "$spec"
      return 0
    }
  done
  return 1
}

mapfile -t first_wave_specs < <(
  {
    spec_for_slot anthropic-main || true
    spec_for_slot antigravity-main || true
    spec_for_slot codex-06 || true
    spec_for_slot copilot-raed2180416 || true
    spec_for_slot google-main || true
  } | awk 'NF > 0' | awk '!seen[$0]++'
)

declare -A first_wave_lookup=()
second_wave_specs=()
for spec in "${first_wave_specs[@]}"; do
  [ -n "$spec" ] || continue
  first_wave_lookup["$spec"]="1"
done
for spec in "${all_specs[@]}"; do
  [ -n "$spec" ] || continue
  [ "${first_wave_lookup[$spec]:-0}" = "1" ] && continue
  second_wave_specs+=("$spec")
done

case "$plan" in
  first-wave)
    [ "${#first_wave_specs[@]}" -gt 0 ] || {
      echo "No first-wave slots resolved from slot map." >&2
      exit 66
    }
    exec bash "$SCRIPT_DIR/arctic-slot-login.sh" "${first_wave_specs[@]}"
    ;;
  second-wave)
    [ "${#second_wave_specs[@]}" -gt 0 ] || {
      echo "No second-wave slots resolved from slot map." >&2
      exit 66
    }
    exec bash "$SCRIPT_DIR/arctic-slot-login.sh" "${second_wave_specs[@]}"
    ;;
  all)
    exec bash "$SCRIPT_DIR/arctic-slot-login.sh" "${all_specs[@]}"
    ;;
  *)
    usage
    ;;
esac
