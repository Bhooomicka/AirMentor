#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

usage() {
  cat >&2 <<'EOF'
Usage: arctic-slot-usage.sh --slot <slot>

Collect slot-local Arctic session stats JSON plus the human-readable usage view,
then persist parsed usage fields into the slot status file.
EOF
  exit 64
}

slot=""

while [ "$#" -gt 0 ]; do
  case "$1" in
    --slot) slot="${2:-}"; shift 2 ;;
    --help|-h) usage ;;
    *) usage ;;
  esac
done

[ -n "$slot" ] || usage
slot="$(arctic_slot_slug "$slot")"
provider="$(provider_for_slot "$slot" 2>/dev/null || true)"
[ -n "$provider" ] || { echo "Unknown provider for slot '$slot'." >&2; exit 66; }

ensure_audit_dirs
snapshot_dir="$(account_snapshot_dir_for_slot "$slot")"
status_file="$(status_path_for_slot "$slot")"
mkdir -p "$snapshot_dir"
touch "$status_file"

stats_snapshot="$snapshot_dir/stats-$(compact_timestamp).json"
usage_snapshot="$snapshot_dir/usage-view-$(compact_timestamp).txt"
stats_tmp="$(mktemp /tmp/arctic-slot-stats.XXXXXX.json)"
usage_tmp="$(mktemp /tmp/arctic-slot-usage.XXXXXX.txt)"

cleanup() {
  rm -f "$stats_tmp" "$usage_tmp"
}
trap cleanup EXIT

set +e
run_arctic_for_slot "$slot" stats --json --view all >"$stats_tmp" 2>"${stats_tmp}.err"
stats_rc="$?"
set -e

if [ "$stats_rc" -eq 0 ] && [ -s "$stats_tmp" ]; then
  cp "$stats_tmp" "$stats_snapshot"
else
  : >"$stats_snapshot"
fi

set +e
timeout 25s bash -lc "source '$SCRIPT_DIR/_audit-common.sh' && run_arctic_for_slot '$slot' run --command usage" >"$usage_tmp" 2>&1
usage_rc="$?"
set -e

if [ "$usage_rc" -eq 0 ] || [ "$usage_rc" -eq 124 ] || [ -s "$usage_tmp" ]; then
  cp "$usage_tmp" "$usage_snapshot"
else
  : >"$usage_snapshot"
fi

parse_output="$(
  python3 - "$stats_snapshot" "$usage_snapshot" <<'PY'
import json
import pathlib
import re
import sys

stats_path = pathlib.Path(sys.argv[1])
usage_path = pathlib.Path(sys.argv[2])

stats = {}
if stats_path.exists() and stats_path.read_text().strip():
    try:
        stats = json.loads(stats_path.read_text())
    except Exception:
        stats = {}

usage_raw = usage_path.read_text() if usage_path.exists() else ""
usage_clean = re.sub(r"\x1B\[[0-9;]*[A-Za-z]", "", usage_raw).replace("\r", "")

model_usage = stats.get("modelUsage") or {}
top_model = ""
top_model_tokens = 0
top_model_cost = 0
for model, meta in model_usage.items():
    tokens = int(meta.get("tokens") or 0)
    if tokens > top_model_tokens:
        top_model = model
        top_model_tokens = tokens
        top_model_cost = meta.get("cost") or 0

def grab(pattern):
    match = re.search(pattern, usage_clean, re.MULTILINE)
    return match.group(1).strip(" \t\r\n│") if match else ""

access_status = grab(r"Access\s*:\s*([^\n]+)")
credits_status = grab(r"Credits\s*:\s*([^\n]+)")
primary_percent = grab(r"Primary\s+([0-9]+(?:\.[0-9]+)?)")
primary_reset_at = grab(r"Primary[^\n]*\(([^)]+)\)")
secondary_percent = grab(r"Secondary\s+([0-9]+(?:\.[0-9]+)?)")
secondary_reset_at = grab(r"Secondary[^\n]*\(([^)]+)\)")
usage_summary_line = ""
for line in usage_clean.splitlines():
    stripped = line.strip()
    if stripped.startswith("Primary"):
      usage_summary_line = stripped
      break

out = {
    "usage_total_sessions": stats.get("totalSessions", ""),
    "usage_total_tokens": stats.get("totalTokens", ""),
    "usage_total_cost": stats.get("totalCost", ""),
    "usage_active_days": stats.get("activeDays", ""),
    "usage_longest_session": stats.get("longestSession", ""),
    "usage_peak_hour": stats.get("peakHour", ""),
    "usage_token_input": (stats.get("tokenBreakdown") or {}).get("input", ""),
    "usage_token_output": (stats.get("tokenBreakdown") or {}).get("output", ""),
    "usage_token_cache_read": (stats.get("tokenBreakdown") or {}).get("cacheRead", ""),
    "usage_token_cache_write": (stats.get("tokenBreakdown") or {}).get("cacheWrite", ""),
    "usage_cost_input": (stats.get("costBreakdown") or {}).get("input", ""),
    "usage_cost_output": (stats.get("costBreakdown") or {}).get("output", ""),
    "usage_cost_cache_read": (stats.get("costBreakdown") or {}).get("cacheRead", ""),
    "usage_cost_cache_write": (stats.get("costBreakdown") or {}).get("cacheWrite", ""),
    "usage_top_model": top_model,
    "usage_top_model_tokens": top_model_tokens,
    "usage_top_model_cost": top_model_cost,
    "usage_access_status": access_status,
    "usage_credits_status": credits_status,
    "usage_limit_primary_percent": primary_percent,
    "usage_limit_primary_reset_at": primary_reset_at,
    "usage_limit_secondary_percent": secondary_percent,
    "usage_limit_secondary_reset_at": secondary_reset_at,
    "usage_limit_summary": usage_summary_line,
  }

for key, value in out.items():
    print(f"{key}\t{value}")
PY
)"

while IFS=$'\t' read -r key value; do
  [ -n "$key" ] || continue
  upsert_env "$status_file" "$key" "$value"
done <<<"$parse_output"

upsert_env "$status_file" usage_stats_snapshot_file "$stats_snapshot"
upsert_env "$status_file" usage_view_snapshot_file "$usage_snapshot"
upsert_env "$status_file" usage_last_checked_at "$(timestamp_utc)"

usage_access_status="$(read_env_value "$status_file" usage_access_status 2>/dev/null || true)"
usage_primary_percent="$(read_env_value "$status_file" usage_limit_primary_percent 2>/dev/null || true)"
usage_primary_reset_at="$(read_env_value "$status_file" usage_limit_primary_reset_at 2>/dev/null || true)"

if printf '%s' "$usage_access_status" | grep -Eqi 'blocked|limit reached'; then
  set_cooldown_in_file "$status_file" "cooling-down" "Provider usage view reported '$usage_access_status'." "$usage_primary_reset_at" "arctic-usage-view"
elif [ -n "$usage_primary_percent" ] && awk "BEGIN { exit !($usage_primary_percent <= 1.0) }"; then
  set_cooldown_in_file "$status_file" "cooling-down" "Provider usage window is nearly exhausted (${usage_primary_percent}%% remaining)." "$usage_primary_reset_at" "arctic-usage-view"
else
  clear_cooldown_in_file "$status_file"
fi
update_slot_execution_route_state "$status_file"

printf 'slot=%s\n' "$slot"
printf 'provider=%s\n' "$provider"
printf 'stats_snapshot=%s\n' "$stats_snapshot"
printf 'usage_snapshot=%s\n' "$usage_snapshot"
