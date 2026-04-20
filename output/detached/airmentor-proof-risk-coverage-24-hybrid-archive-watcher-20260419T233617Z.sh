#!/usr/bin/env bash
set -euo pipefail
repo_root="$1"
log_path="$2"
main_log="$3"
out_json="$4"
out_md="$5"
shift 5
cd "$repo_root"
{
  printf '[%s] cwd=%s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$repo_root"
  printf '[%s] watch_main_log=%s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$main_log"
  set +e
  while true; do
    if rg -q "wrote JSON report to" "$main_log"; then
      break
    fi
    if rg -q "\\[.*\\] exit=[1-9]" "$main_log"; then
      echo "main run exited nonzero; not archiving"
      exit 1
    fi
    sleep 20
  done
  ts="$(date -u +%Y-%m-%dT%H%M%SZ)"
  json_copy="/home/raed/projects/air-mentor-ui/audit-map/17-artifacts/json/${ts}--proof-risk-coverage-24-hybrid-router--local--evaluation-report.json"
  md_copy="/home/raed/projects/air-mentor-ui/audit-map/17-artifacts/local/${ts}--proof-risk-coverage-24-hybrid-router--local--evaluation-report.md"
  mkdir -p "$(dirname "$json_copy")" "$(dirname "$md_copy")"
  cp "$out_json" "$json_copy"
  cp "$out_md" "$md_copy"
  echo "archived_json=$json_copy"
  echo "archived_md=$md_copy"
  status=0
  set -e
  printf '[%s] exit=%s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$status"
  exit "$status"
} >>"$log_path" 2>&1
