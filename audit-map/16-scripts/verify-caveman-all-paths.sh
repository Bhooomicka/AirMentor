#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

usage() {
  echo "Usage: verify-caveman-all-paths.sh [--expected-enabled <0|1>] [--expected-mode <mode>] [--quiet]" >&2
  exit 64
}

expected_mode=""
expected_enabled=""
quiet="0"
policy_version="AIRMENTOR_CAVEMAN_POLICY_V1"
disabled_policy_version="AIRMENTOR_CAVEMAN_POLICY_DISABLED"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --expected-enabled)
      expected_enabled="${2:-}"
      shift 2
      ;;
    --expected-mode)
      expected_mode="${2:-}"
      shift 2
      ;;
    --quiet)
      quiet="1"
      shift
      ;;
    --help|-h)
      usage
      ;;
    *)
      usage
      ;;
  esac
done

if [ -z "$expected_enabled" ]; then
  expected_enabled="$(read_env_value "$(caveman_state_file)" enabled 2>/dev/null || true)"
fi

if [ -z "$expected_enabled" ]; then
  if [ "$expected_mode" = "off" ]; then
    expected_enabled="0"
  else
    expected_enabled="1"
  fi
fi

case "$expected_enabled" in
  0|1) ;;
  *)
    echo "Invalid --expected-enabled value: $expected_enabled" >&2
    usage
    ;;
esac

if [ "$expected_enabled" = "0" ]; then
  expected_mode="off"
fi

if [ -z "$expected_mode" ]; then
  expected_mode="$(read_env_value "$(caveman_state_file)" mode 2>/dev/null || true)"
fi

if [ -z "$expected_mode" ]; then
  if [ "$expected_enabled" = "1" ]; then
    expected_mode="full"
  else
    expected_mode="off"
  fi
fi

fail_count="0"

ok() {
  [ "$quiet" = "1" ] || printf 'ok=%s\n' "$1"
}

fail() {
  fail_count="$((fail_count + 1))"
  printf 'missing=%s\n' "$1"
}

expect_file_marker_enabled() {
  local file="$1"
  local label="$2"
  if [ ! -f "$file" ]; then
    fail "$label:file-not-found:$file"
    return
  fi
  if ! rg -q "$policy_version" "$file"; then
    fail "$label:policy-version-missing:$file"
    return
  fi
  if ! rg -q 'CAVEMAN_ENFORCED=1' "$file"; then
    fail "$label:enforced-flag-missing:$file"
    return
  fi
  if ! rg -q "CAVEMAN_MODE=$expected_mode" "$file"; then
    fail "$label:mode-mismatch:$file"
    return
  fi
  ok "$label:$file"
}

expect_file_marker_disabled() {
  local file="$1"
  local label="$2"
  if [ ! -f "$file" ]; then
    fail "$label:file-not-found:$file"
    return
  fi
  if ! rg -q "$disabled_policy_version" "$file"; then
    fail "$label:disabled-policy-marker-missing:$file"
    return
  fi
  if ! rg -q 'CAVEMAN_ENFORCED=0' "$file"; then
    fail "$label:disabled-enforced-flag-missing:$file"
    return
  fi
  if ! rg -q 'CAVEMAN_MODE=off' "$file"; then
    fail "$label:disabled-mode-missing:$file"
    return
  fi
  ok "$label:$file"
}

expect_file_marker() {
  local file="$1"
  local label="$2"
  if [ "$expected_enabled" = "1" ]; then
    expect_file_marker_enabled "$file" "$label"
  else
    expect_file_marker_disabled "$file" "$label"
  fi
}

expect_settings_true() {
  local settings_file="$1"
  local key="$2"
  local label="$3"
  if [ ! -f "$settings_file" ]; then
    fail "$label:settings-missing:$settings_file"
    return
  fi
  if ! jq -e --arg key "$key" '.[ $key ] == true' "$settings_file" >/dev/null 2>&1; then
    fail "$label:setting-false:$key"
    return
  fi
  ok "$label:$key"
}

expect_settings_map_true() {
  local settings_file="$1"
  local parent="$2"
  local child="$3"
  local label="$4"
  if [ ! -f "$settings_file" ]; then
    fail "$label:settings-missing:$settings_file"
    return
  fi
  if ! jq -e --arg parent "$parent" --arg child "$child" '.[ $parent ][ $child ] == true' "$settings_file" >/dev/null 2>&1; then
    fail "$label:setting-false:$parent.$child"
    return
  fi
  ok "$label:$parent.$child"
}

# 1) Pipeline state gate
if [ "$expected_enabled" = "1" ]; then
  if ! is_caveman_enabled; then
    fail "pipeline:caveman-disabled"
  else
    mode_value="$(read_env_value "$(caveman_state_file)" mode 2>/dev/null || true)"
    if [ "$mode_value" != "$expected_mode" ]; then
      fail "pipeline:mode-mismatch:expected=$expected_mode,actual=$mode_value"
    else
      ok "pipeline:caveman-status"
    fi
  fi
else
  if is_caveman_enabled; then
    fail "pipeline:caveman-still-enabled"
  else
    ok "pipeline:caveman-status"
  fi
fi

# 2) Claude CLI
expect_file_marker "$HOME/.claude/CLAUDE.md" "claude-cli"
expect_file_marker "$HOME/.claude/rules/caveman.md" "claude-cli-rules"

# 3) Claude in VS Code
expect_file_marker "$AUDIT_REPO_ROOT/CLAUDE.md" "claude-vscode-workspace"
expect_file_marker "$AUDIT_REPO_ROOT/.claude/rules/caveman.md" "claude-vscode-rules"

# 4) Codex CLI
expect_file_marker "$HOME/.codex/AGENTS.md" "codex-cli"

# 5) Codex in VS Code
expect_file_marker "$AUDIT_REPO_ROOT/AGENTS.md" "codex-vscode-workspace"
expect_file_marker "$HOME/.copilot/instructions/caveman.instructions.md" "codex-vscode-user-instruction"
expect_file_marker "$AUDIT_REPO_ROOT/.github/instructions/caveman.instructions.md" "codex-vscode-workspace-instruction"

# VS Code settings checks for instruction loading determinism
settings_file="$HOME/.config/Code/User/settings.json"
expect_settings_true "$settings_file" "chat.useClaudeMdFile" "vscode-settings"
expect_settings_true "$settings_file" "chat.useAgentsMdFile" "vscode-settings"
expect_settings_true "$settings_file" "chat.useNestedAgentsMdFiles" "vscode-settings"
expect_settings_true "$settings_file" "chat.includeApplyingInstructions" "vscode-settings"
expect_settings_true "$settings_file" "chat.includeReferencedInstructions" "vscode-settings"
expect_settings_map_true "$settings_file" "chat.instructionsFilesLocations" ".github/instructions" "vscode-settings"
expect_settings_map_true "$settings_file" "chat.instructionsFilesLocations" ".claude/rules" "vscode-settings"
expect_settings_map_true "$settings_file" "chat.instructionsFilesLocations" "~/.copilot/instructions" "vscode-settings"
expect_settings_map_true "$settings_file" "chat.instructionsFilesLocations" "~/.claude/rules" "vscode-settings"

# Arctic wrapper deterministic injection marker
if rg -q 'CAVEMAN_PIPELINE_PREFIX' "$SCRIPT_DIR/arctic-session-wrapper.sh"; then
  ok "arctic-pipeline:wrapper-prefix-marker"
else
  fail "arctic-pipeline:wrapper-prefix-marker-missing"
fi

if [ "$fail_count" -gt 0 ]; then
  printf 'verification=failed count=%s\n' "$fail_count"
  exit 65
fi

printf 'verification=passed\n'
printf 'expected_enabled=%s\n' "$expected_enabled"
printf 'expected_mode=%s\n' "$expected_mode"
