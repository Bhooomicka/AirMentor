#!/usr/bin/env bash
set -euo pipefail

repo_root="$1"
log_path="$2"
shift 2

cd "$repo_root"

{
  printf '[%s] cwd=%s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$repo_root"
  printf '[%s] command=' "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  printf '%q ' "$@"
  printf '\n'
  "$@"
  status=$?
  printf '[%s] exit=%s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$status"
  exit "$status"
} >>"$log_path" 2>&1
