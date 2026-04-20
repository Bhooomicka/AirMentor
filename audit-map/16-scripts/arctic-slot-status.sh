#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

ensure_audit_dirs

printf 'slot\tprovider\tauth_source_key\taccount_label\tentered_account_label\tlabel_policy_state\tstate\tpreferred_model\texecution_model\texecution_verification_state\texecution_route_state\texecution_last_probe_failure_class\tusage_access\tprimary_remaining_pct\tprimary_reset_at\tsecondary_remaining_pct\tsecondary_reset_at\tcooldown_state\tcooldown_next_eligible_at\txdg_data_home\tsnapshot\n'
found=0
for status_file in "$AUDIT_STATUS_ROOT"/arctic-slot-*.status; do
  [ -f "$status_file" ] || continue
  found=1
  unset slot provider auth_source_key account_label entered_account_label label_policy_state state preferred_model execution_model execution_verification_state execution_route_state execution_last_probe_failure_class usage_access_status usage_limit_primary_percent usage_limit_primary_reset_at usage_limit_secondary_percent usage_limit_secondary_reset_at cooldown_state cooldown_next_eligible_at xdg_data_home snapshot_file
  # shellcheck disable=SC1090
  source "$status_file"
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
    "${slot:-unknown}" \
    "${provider:-unknown}" \
    "${auth_source_key:--}" \
    "${account_label:-unknown}" \
    "${entered_account_label:--}" \
    "${label_policy_state:-unknown}" \
    "${state:-unknown}" \
    "${preferred_model:-}" \
    "${execution_model:-}" \
    "${execution_verification_state:-unverified}" \
    "${execution_route_state:-unverified}" \
    "${execution_last_probe_failure_class:-}" \
    "${usage_access_status:-}" \
    "${usage_limit_primary_percent:-}" \
    "${usage_limit_primary_reset_at:-}" \
    "${usage_limit_secondary_percent:-}" \
    "${usage_limit_secondary_reset_at:-}" \
    "${cooldown_state:-}" \
    "${cooldown_next_eligible_at:-}" \
    "${xdg_data_home:-unknown}" \
    "${snapshot_file:-}"
done

[ "$found" = "1" ] || printf 'none\tnone\tnone\tnone\tnone\tnone\tnone\tnone\tnone\tnone\tnone\tnone\tnone\tnone\tnone\tnone\tnone\tnone\tnone\tnone\tnone\n'
