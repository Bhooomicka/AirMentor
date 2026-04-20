#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

pass_name=""
context="local"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --pass) pass_name="${2:-}"; shift 2 ;;
    --context) context="${2:-}"; shift 2 ;;
    *) break ;;
  esac
done

[ -n "$pass_name" ] || { echo "Usage: $0 --pass <name> [--context <context>] [key=value ...]" >&2; exit 64; }

session_name="$(session_name_for "$context" "$pass_name")"
file="$(checkpoint_path_for "$session_name")"
ensure_audit_dirs
touch "$file"
upsert_env "$file" last_checkpoint_at "$(timestamp_utc)"

for pair in "$@"; do
  key="${pair%%=*}"
  value="${pair#*=}"
  upsert_env "$file" "$key" "$value"
done

echo "$file"
