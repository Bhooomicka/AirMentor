#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

ensure_audit_dirs

printf 'slot\tprovider\taccount_label\tentered_account_label\tlabel_policy_state\n'

for status_file in "$AUDIT_STATUS_ROOT"/arctic-slot-*.status; do
  [ -f "$status_file" ] || continue
  unset slot provider account_label entered_account_label canonical_account_label identity_hint label_policy_state
  # shellcheck disable=SC1090
  source "$status_file"

  [ -n "${slot:-}" ] || continue

  canonical_label="$(canonical_account_label_for_slot "$slot" 2>/dev/null || true)"
  expected_provider="$(provider_for_slot "$slot" 2>/dev/null || true)"
  hint="$(identity_hint_for_slot "$slot" 2>/dev/null || true)"
  auth_source_key="$(auth_source_key_for_slot "$slot" 2>/dev/null || true)"
  existing_label="${account_label:-}"
  existing_entered="${entered_account_label:-}"

  if [ -n "$canonical_label" ]; then
    if [ -z "$existing_entered" ] && [ -n "$existing_label" ] && [ "$existing_label" != "$canonical_label" ]; then
      existing_entered="$existing_label"
    fi
    account_label="$canonical_label"
    canonical_account_label="$canonical_label"
    if [ -n "$existing_entered" ] && [ "$existing_entered" != "$canonical_label" ]; then
      label_policy_state="entered-differs-from-canonical"
    else
      existing_entered=""
      label_policy_state="canonical-match"
    fi
  else
    canonical_account_label=""
    label_policy_state="${label_policy_state:-no-canonical-map}"
  fi

  upsert_env "$status_file" provider "${expected_provider:-${provider:-unknown}}"
  upsert_env "$status_file" account_label "${account_label:-unknown}"
  upsert_env "$status_file" canonical_account_label "${canonical_account_label:-}"
  upsert_env "$status_file" entered_account_label "${existing_entered:-}"
  upsert_env "$status_file" identity_hint "${hint:-}"
  upsert_env "$status_file" auth_source_key "${auth_source_key:-}"
  upsert_env "$status_file" label_policy_state "$label_policy_state"
  upsert_env "$status_file" updated_at "$(timestamp_utc)"

  printf '%s\t%s\t%s\t%s\t%s\n' \
    "${slot:-unknown}" \
    "${expected_provider:-${provider:-unknown}}" \
    "${account_label:-unknown}" \
    "${existing_entered:-}" \
    "$label_policy_state"
done
