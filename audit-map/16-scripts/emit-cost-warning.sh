#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

message="${*:-High-cost route requested.}"
warning_file="$AUDIT_REPORT_ROOT/cost-warnings.md"
ensure_audit_dirs
printf '[%s] COST WARNING: %s\n' "$(timestamp_utc)" "$message" >&2
printf '\n- %s %s\n' "$(timestamp_utc)" "$message" >>"$warning_file"
