#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

slot=""
global_mode="0"
while [ "$#" -gt 0 ]; do
  case "$1" in
    --global) global_mode="1"; shift ;;
    --slot) slot="${2:-}"; shift 2 ;;
    *) echo "Usage: $0 [--slot <slot> | --global]" >&2; exit 64 ;;
  esac
done
[ -n "$slot" ] || [ "$global_mode" = "1" ] || { echo "Usage: $0 [--slot <slot> | --global]" >&2; exit 64; }

if ! command -v arctic >/dev/null 2>&1; then
  record_manual_action "Arctic missing" "Install Arctic before using Arctic wrappers."
  echo "arctic is not installed." >&2
  exit 69
fi

if ! arctic_has_credentials "${slot:-}"; then
  if [ -n "$slot" ]; then
    provider="$(provider_for_slot "$slot" 2>/dev/null || true)"
    if [ -n "$provider" ]; then
      record_manual_action "Arctic login required" "Run 'bash audit-map/16-scripts/arctic-slot-login.sh ${provider}:${slot}', then verify with 'bash audit-map/16-scripts/arctic-slot-status.sh' and resume."
    else
      record_manual_action "Arctic login required" "Run 'bash audit-map/16-scripts/arctic-slot-login-plan.sh first-wave', then verify slot status and resume."
    fi
    echo "Arctic slot '$slot' has no configured credentials." >&2
  else
    record_manual_action "Arctic login required" "Run 'arctic auth login', verify 'arctic auth list', then resume the queued Arctic-backed task."
    echo "Arctic has no configured credentials." >&2
  fi
  exit 65
fi

if [ -n "$slot" ]; then
  status_file="$(status_path_for_slot "$slot")"
  current_state="$(read_env_value "$status_file" state 2>/dev/null || true)"
  if [ "$current_state" = "starting-login" ] || [ "$current_state" = "login-interrupted" ] || [ -z "$current_state" ]; then
    canonical_label="$(canonical_account_label_for_slot "$slot" 2>/dev/null || true)"
    current_label="$(read_env_value "$status_file" account_label 2>/dev/null || true)"
    upsert_env "$status_file" state "authenticated"
    [ -n "$current_label" ] || upsert_env "$status_file" account_label "${canonical_label:-unknown}"
    upsert_env "$status_file" updated_at "$(timestamp_utc)"
  fi
  echo "arctic_credentials=ready"
  echo "slot=$slot"
else
  echo "arctic_credentials=ready"
fi
