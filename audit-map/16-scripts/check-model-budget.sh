#!/usr/bin/env bash
set -euo pipefail

pass_name="${1:-}"
requested_model="${2:-}"
[ -n "$pass_name" ] || { echo "Usage: $0 <pass-name> [model]" >&2; exit 64; }

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

eval "$("$SCRIPT_DIR/task-classify-route.sh" "$pass_name")"
model="${requested_model:-$recommended_model}"
budget_state="ok"
telemetry_source="class-based+observed-route-health"
note="No native Codex spend API is wired into this audit OS; using class-based guardrails plus observed route health."

if [ -f "$HOME/.codex/models_cache.json" ] && ! grep -q "\"slug\": \"$model\"" "$HOME/.codex/models_cache.json"; then
  case "$model" in
    gpt-*)
      budget_state="stop"
      note="Requested model '$model' is not exposed in the local Codex model cache."
      ;;
    *)
      budget_state="warn"
      note="Requested model '$model' is not exposed in the local Codex model cache. Treat it as an external-provider model and verify availability through the slot/provider status files."
      ;;
  esac
fi

if [ "${AUDIT_FORBID_GPT54:-0}" = "1" ] && [ "$model" = "gpt-5.4" ]; then
  budget_state="stop"
  note="AUDIT_FORBID_GPT54=1 blocked the high-cost tier."
fi

if [ "$risk_class" = "high" ] && [ "$model" = "gpt-5.4" ]; then
  budget_state="${budget_state/ok/warn}"
fi

native_health_file="$(provider_health_file_for native-codex)"
if cooldown_active_in_file "$native_health_file"; then
  budget_state="${budget_state/ok/warn}"
  native_cooldown_until="$(read_env_value "$native_health_file" cooldown_next_eligible_at 2>/dev/null || true)"
  note="Observed native Codex cooldown is active until ${native_cooldown_until:-an observed reset window}; route selection should prefer a verified alternate provider."
fi

printf 'budget_state=%q\n' "$budget_state"
printf 'telemetry_source=%q\n' "$telemetry_source"
printf 'model=%q\n' "$model"
printf 'note=%q\n' "$note"
