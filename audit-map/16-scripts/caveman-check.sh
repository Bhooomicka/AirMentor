#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

echo "installed_skill_root=$HOME/.agents/skills"
if [ -d "$HOME/.agents/skills/caveman" ]; then
  echo "caveman_installed=1"
else
  echo "caveman_installed=0"
fi

if is_caveman_enabled; then
  echo "caveman_enabled=1"
  cat "$(caveman_state_file)"
else
  echo "caveman_enabled=0"
fi
