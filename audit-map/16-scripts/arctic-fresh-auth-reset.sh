#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

usage() {
  cat >&2 <<'EOF'
Usage: arctic-fresh-auth-reset.sh [--quick|--full] [--strict|--no-strict] [--no-backup] [--keep-claude-sessions] [--keep-vscode-cache]

Purpose:
  Force a clean Claude auth state for CLI + VS Code workflow usage.

Modes:
  --full   Logout + purge IDE/session state + remove stale Vertex env blocks (default)
  --quick  Logout + remove lock/session pointers only
EOF
  exit 64
}

mode="full"
strict_mode="1"
backup_enabled="1"
purge_claude_sessions="1"
purge_vscode_cache="1"
vertex_env_pattern='CLAUDE_CODE_USE_VERTEX|ANTHROPIC_VERTEX_PROJECT_ID|CLOUDSDK_CORE_ACCOUNT|CLOUD_ML_REGION|GOOGLE_CLOUD_PROJECT|GOOGLE_APPLICATION_CREDENTIALS'
vertex_assignment_pattern='^[[:space:]]*(export[[:space:]]+)?(CLAUDE_CODE_USE_VERTEX|ANTHROPIC_VERTEX_PROJECT_ID|CLOUDSDK_CORE_ACCOUNT|CLOUD_ML_REGION|GOOGLE_CLOUD_PROJECT|GOOGLE_APPLICATION_CREDENTIALS)[[:space:]]*='
vertex_env_vars=(
  CLAUDE_CODE_USE_VERTEX
  ANTHROPIC_VERTEX_PROJECT_ID
  CLOUDSDK_CORE_ACCOUNT
  CLOUD_ML_REGION
  GOOGLE_CLOUD_PROJECT
  GOOGLE_APPLICATION_CREDENTIALS
)

while [ "$#" -gt 0 ]; do
  case "$1" in
    --full) mode="full"; shift ;;
    --quick) mode="quick"; shift ;;
    --strict) strict_mode="1"; shift ;;
    --no-strict) strict_mode="0"; shift ;;
    --no-backup) backup_enabled="0"; shift ;;
    --keep-claude-sessions) purge_claude_sessions="0"; shift ;;
    --keep-vscode-cache) purge_vscode_cache="0"; shift ;;
    --help|-h) usage ;;
    *) usage ;;
  esac
done

backup_root="$HOME/.claude-reset-backups"
backup_dir="$backup_root/$(compact_timestamp)"

backup_path() {
  local src="$1"
  local rel=""
  local dst=""
  [ "$backup_enabled" = "1" ] || return 0
  [ -e "$src" ] || return 0
  mkdir -p "$backup_dir"
  rel="${src#$HOME/}"
  dst="$backup_dir/$rel"
  mkdir -p "$(dirname "$dst")"
  cp -a "$src" "$dst"
  printf 'backup_path=%s\n' "$src"
}

remove_path() {
  local target="$1"
  [ -e "$target" ] || return 0
  rm -rf "$target"
  printf 'removed_path=%s\n' "$target"
}

remove_vertex_block_from_zprofile() {
  local file="$1"
  local tmp=""
  [ -f "$file" ] || return 0
  if ! grep -q '^# Claude Code + Vertex AI defaults' "$file" 2>/dev/null; then
    return 0
  fi
  tmp="$(mktemp "${file}.XXXXXX.tmp")"
  awk '
    BEGIN { skip=0; depth=0; saw_if=0 }
    /^# Claude Code \+ Vertex AI defaults$/ { skip=1; depth=0; saw_if=0; next }
    skip {
      if ($0 ~ /^[[:space:]]*if[[:space:]]/) {
        depth++
        saw_if=1
        next
      }
      if ($0 ~ /^[[:space:]]*fi[[:space:]]*$/) {
        if (depth > 0) {
          depth--
        }
        if (saw_if == 1 && depth == 0) {
          skip=0
        }
        next
      }
      next
    }
    { print }
  ' "$file" >"$tmp"
  mv "$tmp" "$file"
  printf 'updated_file=%s\n' "$file"
}

ensure_vertex_scrub_block() {
  local file="$1"
  local tmp=""
  [ -f "$file" ] || return 0

  tmp="$(mktemp "${file}.XXXXXX.tmp")"
  {
    cat <<'EOF'
# Scrub inherited Vertex env so Claude CLI stays on first-party auth unless explicitly set.
unset CLAUDE_CODE_USE_VERTEX
unset ANTHROPIC_VERTEX_PROJECT_ID
unset CLOUDSDK_CORE_ACCOUNT
unset CLOUD_ML_REGION
unset GOOGLE_CLOUD_PROJECT
unset GOOGLE_APPLICATION_CREDENTIALS

EOF
    rg -v '^[[:space:]]*# Scrub inherited Vertex env so Claude CLI stays on first-party auth unless explicitly set\.$|^[[:space:]]*unset[[:space:]]+(CLAUDE_CODE_USE_VERTEX|ANTHROPIC_VERTEX_PROJECT_ID|CLOUDSDK_CORE_ACCOUNT|CLOUD_ML_REGION|GOOGLE_CLOUD_PROJECT|GOOGLE_APPLICATION_CREDENTIALS)[[:space:]]*$|^[[:space:]]*(export[[:space:]]+)?(CLAUDE_CODE_USE_VERTEX|ANTHROPIC_VERTEX_PROJECT_ID|CLOUDSDK_CORE_ACCOUNT|CLOUD_ML_REGION|GOOGLE_CLOUD_PROJECT|GOOGLE_APPLICATION_CREDENTIALS)[[:space:]]*=' "$file" || true
  } >"$tmp"

  mv "$tmp" "$file"
  printf 'updated_file=%s\n' "$file"
}

strip_vertex_from_workspace_cache() {
  local root="$HOME/.config/Code/User/workspaceStorage"
  [ -d "$root" ] || return 0
  while IFS= read -r -d '' file; do
    rm -f "$file"
    printf 'removed_path=%s\n' "$file"
  done < <(
    find "$root" -type f -path '*/chatEditingSessions/*/contents/*' -print0 2>/dev/null \
      | xargs -0 -r rg -l -0 'CLAUDE_CODE_USE_VERTEX|ANTHROPIC_VERTEX_PROJECT_ID|CLOUDSDK_CORE_ACCOUNT|CLOUD_ML_REGION' 2>/dev/null || true
  )
}

strip_vertex_from_vscode_terminal_env() {
  local settings_file="$HOME/.config/Code/User/settings.json"
  local tmp_settings=""

  if ! command -v jq >/dev/null 2>&1; then
    printf 'warning=jq-missing-skipped-vscode-terminal-mask\n'
    return 0
  fi

  if [ ! -f "$settings_file" ]; then
    mkdir -p "$(dirname "$settings_file")"
    printf '{}\n' >"$settings_file"
  fi

  tmp_settings="$(mktemp "${settings_file}.XXXXXX.tmp")"
  jq '
    .["terminal.integrated.env.linux"] = ((.["terminal.integrated.env.linux"] // {}) + {
      "CLAUDE_CODE_USE_VERTEX": null,
      "ANTHROPIC_VERTEX_PROJECT_ID": null,
      "CLOUDSDK_CORE_ACCOUNT": null,
      "CLOUD_ML_REGION": null,
      "GOOGLE_CLOUD_PROJECT": null,
      "GOOGLE_APPLICATION_CREDENTIALS": null
    })
  ' "$settings_file" >"$tmp_settings"
  mv "$tmp_settings" "$settings_file"
  printf 'updated_file=%s\n' "$settings_file"
}

clear_vertex_from_user_session_env() {
  if command -v systemctl >/dev/null 2>&1; then
    systemctl --user unset-environment "${vertex_env_vars[@]}" >/dev/null 2>&1 || true
  fi
}

scrub_hyprland_runtime_env() {
  command -v hyprctl >/dev/null 2>&1 || return 0

  case "${XDG_CURRENT_DESKTOP:-}" in
    *Hyprland*|*hyprland*) ;;
    *) return 0 ;;
  esac

  # Keep launcher-spawned GUI processes off Vertex auth defaults in this live session.
  hyprctl keyword env CLAUDE_CODE_USE_VERTEX,0 >/dev/null 2>&1 || true
  hyprctl keyword env ANTHROPIC_VERTEX_PROJECT_ID, >/dev/null 2>&1 || true
  hyprctl keyword env CLOUDSDK_CORE_ACCOUNT, >/dev/null 2>&1 || true
  hyprctl keyword env CLOUD_ML_REGION, >/dev/null 2>&1 || true
  hyprctl keyword env GOOGLE_CLOUD_PROJECT, >/dev/null 2>&1 || true
  hyprctl keyword env GOOGLE_APPLICATION_CREDENTIALS, >/dev/null 2>&1 || true
  printf 'hyprland_runtime_env_scrub=1\n'
}

restart_portal_services_if_present() {
  command -v systemctl >/dev/null 2>&1 || return 0

  local service=""
  local restarted_any="0"
  local services=(
    xdg-desktop-portal-hyprland.service
    xdg-desktop-portal.service
  )

  for service in "${services[@]}"; do
    if systemctl --user list-unit-files "$service" >/dev/null 2>&1; then
      systemctl --user restart "$service" >/dev/null 2>&1 || true
      printf 'portal_service_restarted=%s\n' "$service"
      restarted_any="1"
    fi
  done

  [ "$restarted_any" = "1" ] || printf 'portal_service_restarted=none\n'
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
  [ "$found" = "1" ]
}

printf 'auth_reset_mode=%s\n' "$mode"

backup_path "$HOME/.claude"
backup_path "$HOME/.claude.json"
backup_path "$HOME/.config/zsh/.zprofile"
backup_path "$HOME/.zprofile"
backup_path "$HOME/.config/Code/User/globalStorage/anthropic.claude-code"

remove_vertex_block_from_zprofile "$HOME/.config/zsh/.zprofile"
remove_vertex_block_from_zprofile "$HOME/.zprofile"

# Also strip direct Vertex exports line-by-line for deterministic cleanup even when no named block exists.
for profile_file in "$HOME/.config/zsh/.zprofile" "$HOME/.zprofile"; do
  [ -f "$profile_file" ] || continue
  tmp_profile="$(mktemp "${profile_file}.XXXXXX.tmp")"
  rg -v "$vertex_assignment_pattern" "$profile_file" >"$tmp_profile" || true
  mv "$tmp_profile" "$profile_file"
  ensure_vertex_scrub_block "$profile_file"
done

if command -v claude >/dev/null 2>&1; then
  set +e
  env -u CLAUDE_CODE_USE_VERTEX \
      -u ANTHROPIC_VERTEX_PROJECT_ID \
      -u CLOUDSDK_CORE_ACCOUNT \
      -u CLOUD_ML_REGION \
      -u GOOGLE_CLOUD_PROJECT \
      -u GOOGLE_APPLICATION_CREDENTIALS \
      claude auth logout >/dev/null 2>&1
  set -e
fi

unset CLAUDE_CODE_USE_VERTEX || true
unset ANTHROPIC_VERTEX_PROJECT_ID || true
unset CLOUDSDK_CORE_ACCOUNT || true
unset CLOUD_ML_REGION || true
unset GOOGLE_CLOUD_PROJECT || true
unset GOOGLE_APPLICATION_CREDENTIALS || true

clear_vertex_from_user_session_env
scrub_hyprland_runtime_env
restart_portal_services_if_present
strip_vertex_from_vscode_terminal_env

if [ "$mode" = "quick" ]; then
  remove_path "$HOME/.claude/ide"
else
  remove_path "$HOME/.claude/ide"
  if [ "$purge_claude_sessions" = "1" ]; then
    remove_path "$HOME/.claude/sessions"
  fi
  remove_path "$HOME/.config/Code/User/globalStorage/anthropic.claude-code"
  if [ "$purge_vscode_cache" = "1" ]; then
    strip_vertex_from_workspace_cache
  fi
fi

if [ "$backup_enabled" = "1" ]; then
  printf 'backup_dir=%s\n' "$backup_dir"
fi

if command -v claude >/dev/null 2>&1; then
  set +e
  status_json="$(env -u CLAUDE_CODE_USE_VERTEX -u ANTHROPIC_VERTEX_PROJECT_ID -u CLOUDSDK_CORE_ACCOUNT -u CLOUD_ML_REGION -u GOOGLE_CLOUD_PROJECT -u GOOGLE_APPLICATION_CREDENTIALS claude auth status 2>&1)"
  status_rc="$?"
  set -e
  printf 'claude_auth_status_rc=%s\n' "$status_rc"
  printf '%s\n' "$status_json"

  if [ "$strict_mode" = "1" ]; then
    if ! printf '%s\n' "$status_json" | rg -q '"loggedIn"[[:space:]]*:[[:space:]]*false'; then
      echo "strict_failure=claude-auth-still-logged-in" >&2
      exit 65
    fi
  fi
fi

if command -v systemctl >/dev/null 2>&1; then
  session_env_vertex_lines="$(systemctl --user show-environment 2>/dev/null | rg "$vertex_env_pattern" || true)"
  if [ -n "$session_env_vertex_lines" ]; then
    printf 'session_env_vertex_present=1\n'
    printf '%s\n' "$session_env_vertex_lines"
  else
    printf 'session_env_vertex_present=0\n'
  fi
fi

if [ "$strict_mode" = "1" ]; then
  if rg -q "$vertex_assignment_pattern" "$HOME/.config/zsh/.zprofile" "$HOME/.zprofile" 2>/dev/null; then
    echo "strict_failure=vertex-bootstrap-still-present" >&2
    exit 65
  fi
fi

if [ "$strict_mode" = "1" ] && command -v systemctl >/dev/null 2>&1; then
  if systemctl --user show-environment 2>/dev/null | rg -q "$vertex_env_pattern"; then
    echo "strict_failure=systemd-user-env-still-has-vertex" >&2
    exit 65
  fi
fi

if report_parent_vertex_env; then
  printf 'next_step=fully_restart_vscode_process_then_open_new_terminal\n'
else
  printf 'next_step=open_new_terminal\n'
fi
