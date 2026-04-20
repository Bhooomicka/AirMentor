#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

provider="${1:-}"
slot="${2:-}"
[ -n "$provider" ] || { echo "Usage: $0 <provider> <slot>" >&2; exit 64; }
[ -n "$slot" ] || { echo "Usage: $0 <provider> <slot>" >&2; exit 64; }

if [ -n "$slot" ] && arctic_has_credentials "$slot"; then
  echo "automatic_provider_switch=slot-ready"
  echo "recommended_slot=$slot"
  echo "recommended_command=bash audit-map/16-scripts/arctic-session-wrapper.sh --slot $slot"
  exit 0
fi
record_manual_action "Arctic provider switch requested" "Authenticate or verify Arctic slot '$slot' for provider '$provider', then resume the queued pass."
echo "automatic_provider_switch=unverified"
exit 65
