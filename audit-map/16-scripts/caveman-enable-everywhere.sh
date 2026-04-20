#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

usage() {
  echo "Usage: caveman-enable-everywhere.sh [lite|full|ultra|wenyan-lite|wenyan-full|wenyan-ultra] [--strict|--no-strict]" >&2
  exit 64
}

mode="full"
strict_mode="1"
policy_version="AIRMENTOR_CAVEMAN_POLICY_V1"

while [ "$#" -gt 0 ]; do
  case "$1" in
    lite|full|ultra|wenyan-lite|wenyan-full|wenyan-ultra)
      mode="$1"
      shift
      ;;
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

bash "$SCRIPT_DIR/caveman-enable.sh" "$mode" --force-all >/dev/null

cat >"$codex_agents_file" <<EOF
# $policy_version

Use caveman mode ($mode) by default for Codex CLI sessions.

Rules:
- Keep technical accuracy exact.
- Keep code blocks and command syntax exact.
- Keep error strings exact when quoted.
- Stay in caveman mode until user says "stop caveman" or "normal mode".
- CAVEMAN_ENFORCED=1
- CAVEMAN_MODE=$mode
EOF

cat >"$claude_global_policy_file" <<EOF
# $policy_version

Use caveman mode ($mode) by default for Claude CLI sessions.

Rules:
- Keep technical accuracy exact.
- Keep code blocks and command syntax exact.
- Keep error strings exact when quoted.
- Stay in caveman mode until user says "stop caveman" or "normal mode".
- CAVEMAN_ENFORCED=1
- CAVEMAN_MODE=$mode
EOF

cat >"$claude_user_rule_file" <<EOF
# $policy_version

Always use caveman mode ($mode) for Claude sessions.

Rules:
- Keep technical accuracy exact.
- Keep code blocks and command syntax exact.
- Keep error strings exact when quoted.
- Stay in caveman mode until user says "stop caveman" or "normal mode".
- CAVEMAN_ENFORCED=1
- CAVEMAN_MODE=$mode
EOF

cat >"$repo_agents_file" <<EOF
# $policy_version

Use caveman mode ($mode) by default for workspace agents.

Rules:
- Keep technical accuracy exact.
- Keep code blocks and command syntax exact.
- Keep error strings exact when quoted.
- Stay in caveman mode until user says "stop caveman" or "normal mode".
- CAVEMAN_ENFORCED=1
- CAVEMAN_MODE=$mode
EOF

cat >"$repo_policy_file" <<EOF
# $policy_version

Use caveman mode ($mode) by default for this repository.

Rules:
- Keep technical accuracy exact.
- Keep code blocks and command syntax exact.
- Keep error strings exact when quoted.
- Stay in caveman mode until user says "stop caveman" or "normal mode".
- CAVEMAN_ENFORCED=1
- CAVEMAN_MODE=$mode
EOF

cat >"$repo_claude_rule_file" <<EOF
# $policy_version

Always use caveman mode ($mode) for Claude sessions in this repository.

Rules:
- Keep technical accuracy exact.
- Keep code blocks and command syntax exact.
- Keep error strings exact when quoted.
- Stay in caveman mode until user says "stop caveman" or "normal mode".
- CAVEMAN_ENFORCED=1
- CAVEMAN_MODE=$mode
EOF

cat >"$copilot_user_instruction_file" <<EOF
---
name: AirMentor Caveman Global
description: Enforce caveman response style globally.
applyTo: "**"
---
# $policy_version

Respond in caveman mode ($mode) unless the user explicitly asks to stop caveman.
Keep technical accuracy exact.
Keep code blocks and error text exact.
CAVEMAN_ENFORCED=1
CAVEMAN_MODE=$mode
EOF

cat >"$repo_instruction_file" <<EOF
---
name: AirMentor Caveman Workspace
description: Enforce caveman response style in this workspace.
applyTo: "**"
---
# $policy_version

Respond in caveman mode ($mode) unless the user explicitly asks to stop caveman.
Keep technical accuracy exact.
Keep code blocks and error text exact.
CAVEMAN_ENFORCED=1
CAVEMAN_MODE=$mode
EOF

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
  bash "$SCRIPT_DIR/verify-caveman-all-paths.sh" --expected-enabled 1 --expected-mode "$mode"
fi

printf 'caveman_enabled=1\n'
printf 'caveman_mode=%s\n' "$mode"
printf 'codex_agents_file=%s\n' "$codex_agents_file"
printf 'claude_global_policy_file=%s\n' "$claude_global_policy_file"
printf 'claude_user_rule_file=%s\n' "$claude_user_rule_file"
printf 'repo_agents_file=%s\n' "$repo_agents_file"
printf 'repo_policy_file=%s\n' "$repo_policy_file"
printf 'repo_claude_rule_file=%s\n' "$repo_claude_rule_file"
printf 'copilot_user_instruction_file=%s\n' "$copilot_user_instruction_file"
printf 'repo_instruction_file=%s\n' "$repo_instruction_file"
printf 'vscode_settings_file=%s\n' "$vscode_settings_file"
