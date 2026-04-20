#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

pass_name="${1:-}"
context="${2:-local}"
[ -n "$pass_name" ] || { echo "Usage: $0 <pass-name> [context]" >&2; exit 64; }

session_name="$(session_name_for "$context" "$pass_name")"
file="$(checkpoint_path_for "$session_name")"
[ -f "$file" ] || { echo "No checkpoint file found for $session_name" >&2; exit 66; }
cat "$file"
