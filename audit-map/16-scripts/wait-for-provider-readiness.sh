#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

usage() {
  echo "Usage: $0 <pass-name> [--requested-model <slug>] [--require-provider <provider>] [--exclude-provider <provider>] [--exclude-slot <slot>] [--timeout-seconds <n>] [--poll-seconds <n>]" >&2
  echo "  --timeout-seconds 0 means wait indefinitely until a route is ready or a manual-required state is returned." >&2
  exit 64
}

pass_name="${1:-}"
[ -n "$pass_name" ] || usage
shift || true

requested_model=""
require_provider=""
exclude_provider=""
exclude_slot=""
timeout_seconds="1800"
poll_seconds="60"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --requested-model) requested_model="${2:-}"; shift 2 ;;
    --require-provider) require_provider="${2:-}"; shift 2 ;;
    --exclude-provider) exclude_provider="${2:-}"; shift 2 ;;
    --exclude-slot) exclude_slot="${2:-}"; shift 2 ;;
    --timeout-seconds) timeout_seconds="${2:-}"; shift 2 ;;
    --poll-seconds) poll_seconds="${2:-}"; shift 2 ;;
    --help|-h) usage ;;
    *) usage ;;
  esac
done

start_epoch="$(date +%s)"
deadline="0"
if [ "${timeout_seconds:-0}" -gt 0 ]; then
  deadline="$((start_epoch + timeout_seconds))"
fi
attempt="0"
route_args=(bash "$SCRIPT_DIR/select-execution-route.sh" "$pass_name")
[ -n "$requested_model" ] && route_args+=(--requested-model "$requested_model")
[ -n "$require_provider" ] && route_args+=(--require-provider "$require_provider")
[ -n "$exclude_provider" ] && route_args+=(--exclude-provider "$exclude_provider")
[ -n "$exclude_slot" ] && route_args+=(--exclude-slot "$exclude_slot")

while :; do
  attempt="$((attempt + 1))"
  eval "$("${route_args[@]}")"
  if [ "$route_state" = "ready" ]; then
    printf 'route_state=%q\n' "$route_state"
    printf 'selected_provider=%q\n' "$selected_provider"
    printf 'selected_slot=%q\n' "$selected_slot"
    printf 'selected_account=%q\n' "$selected_account"
    printf 'selected_account_label=%q\n' "${selected_account_label:-}"
    printf 'selected_model=%q\n' "$selected_model"
    printf 'reasoning_effort=%q\n' "$reasoning_effort"
    printf 'attempt=%q\n' "$attempt"
    exit 0
  fi

  now_epoch="$(date +%s)"
  if { [ "$deadline" -gt 0 ] && [ "$now_epoch" -ge "$deadline" ]; } || [ "$route_state" = "manual_required" ]; then
    printf 'route_state=%q\n' "$route_state"
    printf 'route_reason=%q\n' "$route_reason"
    printf 'attempt=%q\n' "$attempt"
    exit 65
  fi

  printf '[%s] wait-attempt=%s route_state=%s reason=%s\n' "$(timestamp_utc)" "$attempt" "$route_state" "$route_reason" >&2
  sleep "$poll_seconds"
done
