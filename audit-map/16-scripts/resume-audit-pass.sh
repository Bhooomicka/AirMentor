#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

pass_name="${1:-}"
context="${2:-local}"
[ -n "$pass_name" ] || { echo "Usage: $0 <pass-name> [context]" >&2; exit 64; }

session_name="$(session_name_for "$context" "$pass_name")"
checkpoint_file="$(checkpoint_path_for "$session_name")"
[ -f "$checkpoint_file" ] || { echo "No checkpoint found for $session_name" >&2; exit 66; }

extra_instruction="Resume from checkpoint file $(printf '%q' "$checkpoint_file"). Read it first, continue the same pass, and update the checkpoint plus coverage and memory ledgers."
bash "$SCRIPT_DIR/run-audit-pass.sh" "$pass_name" --context "$context" --extra-instruction "$extra_instruction"
