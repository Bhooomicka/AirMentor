#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

usage() {
  echo "Usage: $0 --global <provider> [provider...]" >&2
  echo "Examples:" >&2
  echo "  $0 --global codex google" >&2
  echo "  $0 codex:codex-01 codex:codex-02 google:google-main" >&2
  exit 64
}

command -v arctic >/dev/null 2>&1 || { echo "arctic is not installed or not on PATH" >&2; exit 69; }
allow_global="0"

[ "$#" -gt 0 ] || usage
if [ "${1:-}" = "--global" ]; then
  allow_global="1"
  shift
fi
[ "$#" -gt 0 ] || usage

for arg in "$@"; do
  if printf '%s' "$arg" | grep -q ':'; then
    exec bash "$SCRIPT_DIR/arctic-slot-login.sh" "$@"
  fi
done

[ "$allow_global" = "1" ] || {
  echo "Global Arctic auth is unsafe for repeated providers on this machine." >&2
  echo "Use arctic-slot-login.sh / arctic-slot-login-plan.sh, or pass --global intentionally." >&2
  exit 64
}

api_key_providers='openai anthropic amazon-bedrock azure google-vertex google-vertex-anthropic perplexity openrouter ollama groq togetherai deepseek cerebras mistral cohere xai'

printf 'Starting guided Arctic login sequence in %s\n' "$AUDIT_REPO_ROOT"
printf 'Current credentials before login:\n\n'
arctic auth list || true
printf '\n'
printf 'Note: this is legacy global-store mode.\n'
printf 'For repeated providers or long-term account continuity, prefer slot mode such as codex:codex-01.\n\n'

for provider in "$@"; do
  printf '=== Provider: %s ===\n' "$provider"

  if printf ' %s ' "$api_key_providers" | grep -Fq " $provider "; then
    printf 'Provider %s is API-key based. Arctic will not do browser OAuth for it.\n' "$provider"
    printf 'Set the required environment variable first, then verify with `arctic auth list` or model usage.\n\n'
    continue
  fi

  printf 'Arctic should now launch the provider auth flow. Choose the intended browser account deliberately.\n'
  printf 'If you want a fresh chooser for Google-backed providers, use a browser profile or incognito window.\n\n'
  arctic auth login "$provider" || true
  printf '\nCredentials after %s:\n\n' "$provider"
  arctic auth list || true
  printf '\nPress Enter to continue to the next provider, or Ctrl+C to stop.\n'
  read -r _
done

printf '\nGuided Arctic login sequence complete.\n'
