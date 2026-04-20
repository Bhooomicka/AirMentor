#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

message=""
message_file=""
model=""
session_id=""
continue_flag="0"
format="default"
slot=""
global_mode="0"
method="run"
caveman_mode="full"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --method) method="${2:-run}"; shift 2 ;;
    --caveman-mode) caveman_mode="${2:-full}"; shift 2 ;;
    --global) global_mode="1"; shift ;;
    --slot) slot="${2:-}"; shift 2 ;;
    --message) message="${2:-}"; shift 2 ;;
    --message-file) message_file="${2:-}"; shift 2 ;;
    --model) model="${2:-}"; shift 2 ;;
    --session) session_id="${2:-}"; shift 2 ;;
    --continue) continue_flag="1"; shift ;;
    --format) format="${2:-default}"; shift 2 ;;
    *) break ;;
  esac
done

case "$method" in
  run|fresh-auth-reset|reset-auth|enable-caveman|caveman-enable|disable-caveman|caveman-disable|auth-doctor|doctor-auth) ;;
  *)
    echo "Unknown method: $method" >&2
    echo "Supported methods: run, fresh-auth-reset, enable-caveman, disable-caveman, auth-doctor" >&2
    exit 64
    ;;
esac

if [ "$method" = "fresh-auth-reset" ] || [ "$method" = "reset-auth" ]; then
  exec bash "$SCRIPT_DIR/arctic-fresh-auth-reset.sh" "$@"
fi

if [ "$method" = "enable-caveman" ] || [ "$method" = "caveman-enable" ]; then
  exec bash "$SCRIPT_DIR/caveman-enable-everywhere.sh" "$caveman_mode" "$@"
fi

if [ "$method" = "disable-caveman" ] || [ "$method" = "caveman-disable" ]; then
  exec bash "$SCRIPT_DIR/caveman-disable-everywhere.sh" "$@"
fi

if [ "$method" = "auth-doctor" ] || [ "$method" = "doctor-auth" ]; then
  exec bash "$SCRIPT_DIR/arctic-auth-doctor.sh" "$@"
fi

[ -n "$slot" ] || [ "$global_mode" = "1" ] || {
  echo "Usage: $0 [--method run] --slot <slot> [--message ... | --message-file <file>] [--model ...] [--session ...] [--continue] [--format ...]" >&2
  echo "Methods: run (default), fresh-auth-reset, enable-caveman, disable-caveman, auth-doctor" >&2
  echo "Use --global only for intentional legacy shared-store sessions." >&2
  exit 64
}

if [ -n "$message" ] && [ -n "$message_file" ]; then
  echo "Use either --message or --message-file, not both." >&2
  exit 64
fi

if [ -n "$message_file" ]; then
  [ -f "$message_file" ] || { echo "Message file not found: $message_file" >&2; exit 66; }
  message="$(cat "$message_file")"
fi

if is_caveman_enabled && [ -n "$message" ]; then
  active_caveman_mode="$(read_env_value "$(caveman_state_file)" mode 2>/dev/null || printf 'full')"
  CAVEMAN_PIPELINE_PREFIX="CAVEMAN_ENFORCED=1 CAVEMAN_MODE=${active_caveman_mode}. Respond in caveman style while keeping technical accuracy exact."
  message="$(printf '%s\n\n%s' "$CAVEMAN_PIPELINE_PREFIX" "$message")"
fi

if [ -n "$slot" ]; then
  bash "$SCRIPT_DIR/arctic-login-check.sh" --slot "$slot"
  slot_provider="$(provider_for_slot "$slot" 2>/dev/null || true)"
else
  bash "$SCRIPT_DIR/arctic-login-check.sh" --global
  slot_provider=""
fi

args=(run --format "$format")
if [ -n "$model" ]; then
  args+=(--model "$(provider_model_ref "$slot_provider" "$model")")
fi
[ "$continue_flag" = "1" ] && args+=(--continue)
[ -n "$session_id" ] && args+=(--session "$session_id")
[ -n "$message" ] && args+=("$message")

if [ -n "$slot" ]; then
  run_arctic_for_slot "$slot" "${args[@]}"
else
  arctic "${args[@]}"
fi
