#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

model="${1:-}"
slot="${2:-}"
[ -n "$model" ] || { echo "Usage: $0 <provider/model> <slot>" >&2; exit 64; }
[ -n "$slot" ] || { echo "Usage: $0 <provider/model> <slot>" >&2; exit 64; }

status_file="$(status_path_for "arctic-model")"
write_env_file "$status_file" \
  requested_model "$model" \
  slot "${slot:-global}" \
  updated_at "$(timestamp_utc)"

if ! arctic_has_credentials "$slot"; then
  record_manual_action "Arctic model switch pending" "Authenticate Arctic slot '$slot', then resume with model '$model'."
  echo "manual_action_required=1"
  exit 65
fi

echo "recommended_command=bash audit-map/16-scripts/arctic-session-wrapper.sh --slot $slot --model $model"
