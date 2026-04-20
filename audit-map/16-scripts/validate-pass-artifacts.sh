#!/usr/bin/env bash
set -euo pipefail

pass_name="${1:-}"
[ -n "$pass_name" ] || { echo "Usage: $0 <pass-name>" >&2; exit 64; }

require_substantive_file() {
  local file="${1:-}"
  local min_lines="${2:-10}"
  local min_bytes="${3:-200}"
  [ -f "$file" ] || {
    echo "missing required artifact: $file" >&2
    return 1
  }
  local line_count byte_count
  line_count="$(wc -l <"$file" | tr -d ' ')"
  byte_count="$(wc -c <"$file" | tr -d ' ')"
  if [ "${line_count:-0}" -lt "$min_lines" ] || [ "${byte_count:-0}" -lt "$min_bytes" ]; then
    echo "artifact too thin: $file (lines=$line_count bytes=$byte_count)" >&2
    return 1
  fi
}

case "$pass_name" in
  claim-verification-pass)
    require_substantive_file "audit-map/32-reports/claim-verification-matrix.md" 25 1200
    ;;
  unknown-omission-pass)
    require_substantive_file "audit-map/32-reports/unknown-omission-ledger.md" 20 1000
    ;;
  proof-refresh-completion-pass)
    require_substantive_file "audit-map/13-backend-provenance/proof-refresh-completion-lineage.md" 40 2500
    ;;
  frontend-long-tail-pass)
    require_substantive_file "audit-map/12-frontend-microinteractions/long-tail-interaction-map.md" 40 2500
    require_substantive_file "audit-map/12-frontend-microinteractions/component-cluster-microinteraction-map.md" 40 2500
    ;;
  live-credentialed-parity-pass)
    require_substantive_file "audit-map/10-live-behavior/live-same-student-parity.md" 35 2000
    require_substantive_file "audit-map/32-reports/live-credentialed-parity-report.md" 30 1800
    ;;
  residual-gap-closure-pass)
    require_substantive_file "audit-map/32-reports/residual-gap-closure-report.md" 20 1000
    ;;
  closure-readiness-pass)
    require_substantive_file "audit-map/32-reports/closure-readiness-verdict.md" 20 1000
    ;;
esac
