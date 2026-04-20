#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

file="$(caveman_state_file)"
ensure_audit_dirs
write_env_file "$file" enabled "0" mode "off" updated_at "$(timestamp_utc)"
echo "caveman_enabled=0"
