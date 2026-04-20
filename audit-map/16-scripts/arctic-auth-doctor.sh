#!/usr/bin/env bash
set -euo pipefail

vertex_env_pattern='CLAUDE_CODE_USE_VERTEX|ANTHROPIC_VERTEX_PROJECT_ID|CLOUDSDK_CORE_ACCOUNT|CLOUD_ML_REGION|GOOGLE_CLOUD_PROJECT|GOOGLE_APPLICATION_CREDENTIALS'

print_env_var() {
  local key="$1"
  local value="${!key-}"
  if [ -n "$value" ]; then
    printf 'shell_env_%s=%s\n' "$key" "$value"
  else
    printf 'shell_env_%s=<unset>\n' "$key"
  fi
}

extract_logged_in_flag() {
  local payload="$1"
  if printf '%s\n' "$payload" | rg -q '"loggedIn"[[:space:]]*:[[:space:]]*true'; then
    printf '1'
    return
  fi
  if printf '%s\n' "$payload" | rg -q '"loggedIn"[[:space:]]*:[[:space:]]*false'; then
    printf '0'
    return
  fi
  printf 'unknown'
}

report_parent_vertex_env() {
  local p="$$"
  local pp=""
  local cmd=""
  local found="0"
  local i=""

  for i in 1 2 3 4 5 6 7 8 9 10; do
    pp="$(ps -o ppid= -p "$p" 2>/dev/null | tr -d ' ' || true)"
    [ -n "$pp" ] || break
    cmd="$(ps -o cmd= -p "$pp" 2>/dev/null || true)"

    if cat "/proc/$pp/environ" 2>/dev/null | tr '\0' '\n' | rg -q "$vertex_env_pattern"; then
      found="1"
      printf 'ancestor_vertex_env_pid=%s cmd=%s\n' "$pp" "$cmd"
    fi

    [ "$pp" = "1" ] && break
    p="$pp"
  done

  printf 'ancestor_vertex_env=%s\n' "$found"
}

printf 'doctor_script=arctic-auth-doctor\n'
printf 'timestamp=%s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)"

print_env_var CLAUDE_CODE_USE_VERTEX
print_env_var ANTHROPIC_VERTEX_PROJECT_ID
print_env_var CLOUDSDK_CORE_ACCOUNT
print_env_var CLOUD_ML_REGION
print_env_var GOOGLE_CLOUD_PROJECT
print_env_var GOOGLE_APPLICATION_CREDENTIALS

if command -v claude >/dev/null 2>&1; then
  set +e
  raw_status="$(claude auth status 2>&1)"
  raw_rc="$?"
  sanitized_status="$(env -u CLAUDE_CODE_USE_VERTEX -u ANTHROPIC_VERTEX_PROJECT_ID -u CLOUDSDK_CORE_ACCOUNT -u CLOUD_ML_REGION -u GOOGLE_CLOUD_PROJECT -u GOOGLE_APPLICATION_CREDENTIALS claude auth status 2>&1)"
  sanitized_rc="$?"
  set -e

  raw_logged_in="$(extract_logged_in_flag "$raw_status")"
  sanitized_logged_in="$(extract_logged_in_flag "$sanitized_status")"

  printf 'claude_auth_status_raw_rc=%s\n' "$raw_rc"
  printf 'claude_auth_status_raw_logged_in=%s\n' "$raw_logged_in"
  printf '%s\n' "$raw_status"
  printf 'claude_auth_status_sanitized_rc=%s\n' "$sanitized_rc"
  printf 'claude_auth_status_sanitized_logged_in=%s\n' "$sanitized_logged_in"
  printf '%s\n' "$sanitized_status"
else
  raw_logged_in='unknown'
  sanitized_logged_in='unknown'
  printf 'claude_binary=missing\n'
fi

if command -v systemctl >/dev/null 2>&1; then
  session_env_vertex_lines="$(systemctl --user show-environment 2>/dev/null | rg "$vertex_env_pattern" || true)"
  if [ -n "$session_env_vertex_lines" ]; then
    printf 'systemd_user_env_vertex_present=1\n'
    printf '%s\n' "$session_env_vertex_lines"
  else
    printf 'systemd_user_env_vertex_present=0\n'
  fi
else
  printf 'systemd_user_env_vertex_present=unknown\n'
fi

report_parent_vertex_env

diagnosis='inconclusive'
if [ "$raw_logged_in" = '1' ] && [ "$sanitized_logged_in" = '0' ]; then
  diagnosis='vertex-env-leak'
elif [ "$sanitized_logged_in" = '1' ]; then
  diagnosis='auth-active-after-sanitize'
elif [ "$raw_logged_in" = '0' ] && [ "$sanitized_logged_in" = '0' ]; then
  diagnosis='clean-logged-out'
fi

printf 'diagnosis=%s\n' "$diagnosis"

if [ "$diagnosis" = 'vertex-env-leak' ]; then
  printf 'likely_cause=session-env-or-parent-process-injecting-vertex-vars\n'
  printf 'recommended_fix_1=bash audit-map/16-scripts/arctic-cli.sh reset-auth --full --strict\n'
  printf 'recommended_fix_2=fully-restart-vscode-process\n'
fi
