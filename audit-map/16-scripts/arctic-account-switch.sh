#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

provider="${1:-unknown-provider}"
account="${2:-unknown-account}"
slot="${3:-}"
[ -n "$slot" ] || { echo "Usage: $0 <provider> <account-label> <slot>" >&2; exit 64; }

if [ -n "$slot" ] && arctic_has_credentials "$slot"; then
  echo "automatic_account_switch=slot-ready"
  echo "recommended_slot=$slot"
  echo "recommended_command=bash audit-map/16-scripts/arctic-session-wrapper.sh --slot $slot"
  exit 0
fi
record_manual_action "Arctic account switch requested" "Authenticate or verify Arctic slot '$slot' for provider '$provider' and account label '$account', then resume."
echo "automatic_account_switch=unverified"
exit 65
