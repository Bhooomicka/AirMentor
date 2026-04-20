#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

usage() {
  echo "Usage: caveman-disable-everywhere.sh [--strict|--no-strict]" >&2
  exit 64
}

strict_mode="1"
policy_version="AIRMENTOR_CAVEMAN_POLICY_DISABLED"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --strict)
      strict_mode="1"
      shift
      ;;
    --no-strict)
      strict_mode="0"
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

codex_agents_file="$HOME/.codex/AGENTS.md"
claude_global_policy_file="$HOME/.claude/CLAUDE.md"
claude_user_rule_file="$HOME/.claude/rules/caveman.md"
copilot_user_instruction_file="$HOME/.copilot/instructions/caveman.instructions.md"

repo_agents_file="$AUDIT_REPO_ROOT/AGENTS.md"
repo_policy_file="$AUDIT_REPO_ROOT/CLAUDE.md"
repo_claude_rule_file="$AUDIT_REPO_ROOT/.claude/rules/caveman.md"
repo_instruction_file="$AUDIT_REPO_ROOT/.github/instructions/caveman.instructions.md"

vscode_settings_file="$HOME/.config/Code/User/settings.json"

mkdir -p "$(dirname "$codex_agents_file")"
mkdir -p "$(dirname "$claude_global_policy_file")"
mkdir -p "$(dirname "$claude_user_rule_file")"
mkdir -p "$(dirname "$copilot_user_instruction_file")"
mkdir -p "$(dirname "$repo_agents_file")"
mkdir -p "$(dirname "$repo_policy_file")"
mkdir -p "$(dirname "$repo_claude_rule_file")"
mkdir -p "$(dirname "$repo_instruction_file")"

bash "$SCRIPT_DIR/caveman-disable.sh" >/dev/null

cat >"$codex_agents_file" <<EOF
# $policy_version

Caveman mode disabled for Codex CLI sessions.
Use normal response mode unless user explicitly asks for caveman.
CAVEMAN_ENFORCED=0
CAVEMAN_MODE=off
EOF

cat >"$claude_global_policy_file" <<EOF
# $policy_version

Caveman mode disabled for Claude CLI sessions.
Use normal response mode unless user explicitly asks for caveman.
CAVEMAN_ENFORCED=0
CAVEMAN_MODE=off
EOF

cat >"$claude_user_rule_file" <<EOF
# $policy_version

Caveman mode disabled for Claude sessions.
Use normal response mode unless user explicitly asks for caveman.
CAVEMAN_ENFORCED=0
CAVEMAN_MODE=off
EOF

cat >"$repo_agents_file" <<EOF
# $policy_version

Caveman mode disabled for workspace agents.
Use normal response mode unless user explicitly asks for caveman.
CAVEMAN_ENFORCED=0
CAVEMAN_MODE=off
EOF

cat >"$repo_policy_file" <<EOF
# $policy_version

Caveman mode disabled for repository Claude sessions.
Use normal response mode unless user explicitly asks for caveman.
CAVEMAN_ENFORCED=0
CAVEMAN_MODE=off
EOF

cat >"$repo_claude_rule_file" <<EOF
# $policy_version

Caveman mode disabled for repository Claude rules.
Use normal response mode unless user explicitly asks for caveman.
CAVEMAN_ENFORCED=0
CAVEMAN_MODE=off
EOF

cat >"$copilot_user_instruction_file" <<EOF
---
name: AirMentor Caveman Global
description: Caveman response style disabled globally.
applyTo: "**"
---
# $policy_version

Use normal response mode unless user explicitly asks for caveman.
CAVEMAN_ENFORCED=0
CAVEMAN_MODE=off
EOF

cat >"$repo_instruction_file" <<EOF
---
name: AirMentor Caveman Workspace
description: Caveman response style disabled in this workspace.
applyTo: "**"
---
# $policy_version

Use normal response mode unless user explicitly asks for caveman.
CAVEMAN_ENFORCED=0
CAVEMAN_MODE=off
EOF

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required to update VS Code settings deterministically." >&2
  exit 65
fi

if [ ! -f "$vscode_settings_file" ]; then
  mkdir -p "$(dirname "$vscode_settings_file")"
  printf '{}\n' >"$vscode_settings_file"
fi

tmp_settings_file="$(mktemp "${vscode_settings_file}.XXXXXX.tmp")"
jq '
  .["chat.useClaudeMdFile"] = true |
  .["chat.useAgentsMdFile"] = true |
  .["chat.useNestedAgentsMdFiles"] = true |
  .["chat.includeApplyingInstructions"] = true |
  .["chat.includeReferencedInstructions"] = true |
  .["chat.instructionsFilesLocations"] = ((.["chat.instructionsFilesLocations"] // {}) + {
    ".github/instructions": true,
    ".claude/rules": true,
    "~/.copilot/instructions": true,
    "~/.claude/rules": true
  })
' "$vscode_settings_file" >"$tmp_settings_file"
mv "$tmp_settings_file" "$vscode_settings_file"

if [ "$strict_mode" = "1" ]; then
  bash "$SCRIPT_DIR/verify-caveman-all-paths.sh" --expected-enabled 0 --expected-mode off
fi

printf 'caveman_enabled=0\n'
printf 'caveman_mode=off\n'
printf 'codex_agents_file=%s\n' "$codex_agents_file"
printf 'claude_global_policy_file=%s\n' "$claude_global_policy_file"
printf 'claude_user_rule_file=%s\n' "$claude_user_rule_file"
printf 'repo_agents_file=%s\n' "$repo_agents_file"
printf 'repo_policy_file=%s\n' "$repo_policy_file"
printf 'repo_claude_rule_file=%s\n' "$repo_claude_rule_file"
printf 'copilot_user_instruction_file=%s\n' "$copilot_user_instruction_file"
printf 'repo_instruction_file=%s\n' "$repo_instruction_file"
printf 'vscode_settings_file=%s\n' "$vscode_settings_file"
