#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

risk="${1:-low}"
shift || true
[ "$#" -gt 0 ] || { echo "Usage: $0 <risk-class> <command...>" >&2; exit 64; }

if [ "$risk" = "high" ] || ! is_caveman_enabled; then
  exec "$@"
fi

export AUDIT_CAVEMAN_MODE=1
exec "$@"
