#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

title="${1:-Manual switch required}"
detail="${2:-Switch provider/account manually, then resume from the latest checkpoint.}"
record_manual_action "$title" "$detail"
echo "manual_action_recorded=1"
