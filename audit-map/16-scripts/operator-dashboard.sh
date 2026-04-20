#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

usage() {
  cat >&2 <<'EOF'
Usage: operator-dashboard.sh [--watch <seconds>] [--refresh-usage] [--write-only] [--no-ansi]

Generate the operator dashboard report and optionally render a live terminal view.
EOF
  exit 64
}

watch_seconds=""
refresh_usage="0"
write_only="0"
no_ansi="0"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --watch) watch_seconds="${2:-}"; shift 2 ;;
    --refresh-usage) refresh_usage="1"; shift ;;
    --write-only) write_only="1"; shift ;;
    --no-ansi) no_ansi="1"; shift ;;
    --help|-h) usage ;;
    *) usage ;;
  esac
done

render_once() {
  if [ "$refresh_usage" = "1" ]; then
    bash "$SCRIPT_DIR/arctic-refresh-usage-report.sh" >/dev/null
  fi
  args=()
  [ "$write_only" = "1" ] && args+=(--write-only)
  [ "$no_ansi" = "1" ] && args+=(--no-ansi)
  python3 "$SCRIPT_DIR/operator-dashboard.py" "${args[@]}"
}

if [ -n "$watch_seconds" ]; then
  while true; do
    clear
    render_once
    sleep "$watch_seconds"
  done
fi

render_once
