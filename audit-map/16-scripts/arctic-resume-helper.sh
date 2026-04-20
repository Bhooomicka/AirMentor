#!/usr/bin/env bash
set -euo pipefail

if ! command -v arctic >/dev/null 2>&1; then
  echo "arctic is not installed." >&2
  exit 69
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

slot=""
continue_flag="0"
global_mode="0"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --global) global_mode="1"; shift ;;
    --slot) slot="${2:-}"; shift 2 ;;
    --continue) continue_flag="1"; shift ;;
    *) break ;;
  esac
done

[ -n "$slot" ] || [ "$global_mode" = "1" ] || {
  echo "Usage: $0 --slot <slot> [--continue] | --global [--continue]" >&2
  exit 64
}

if [ "$continue_flag" = "1" ]; then
  if [ -n "$slot" ]; then
    exec bash "$SCRIPT_DIR/arctic-session-wrapper.sh" --slot "$slot" --continue
  fi
  exec arctic run --continue
fi

if [ -n "$slot" ]; then
  run_arctic_for_slot "$slot" session list
  exit $?
fi

exec arctic session list
