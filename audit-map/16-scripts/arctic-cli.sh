#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

usage() {
  cat >&2 <<'EOF'
Usage: arctic-cli.sh <method> [args...]

Methods:
  run                Run model call via arctic-session-wrapper.sh
  reset-auth         Fresh Claude auth reset for CLI/VS Code state
  seed-slots         Seed mapped isolated slots from global Arctic auth store
  enable-caveman     Enable caveman mode across Arctic pipeline + Codex/Claude policies
  disable-caveman    Disable caveman mode across Arctic pipeline + Codex/Claude policies
  verify-caveman     Verify deterministic caveman coverage for all required paths
  auth-doctor        Diagnose Vertex env leakage and auth truth divergence
  status             Show slot status + caveman status

Examples:
  arctic-cli.sh run --slot codex-04 --message "ping"
  arctic-cli.sh reset-auth --full
  arctic-cli.sh seed-slots --all --force
  arctic-cli.sh enable-caveman full
  arctic-cli.sh disable-caveman
  arctic-cli.sh verify-caveman
  arctic-cli.sh auth-doctor
  arctic-cli.sh status
EOF
  exit 64
}

method="${1:-}"
[ -n "$method" ] || usage
shift || true

case "$method" in
  run)
    exec bash "$SCRIPT_DIR/arctic-session-wrapper.sh" --method run "$@"
    ;;
  reset-auth|fresh-auth-reset)
    exec bash "$SCRIPT_DIR/arctic-session-wrapper.sh" --method fresh-auth-reset "$@"
    ;;
  seed-slots|seed-slot-auth)
    exec bash "$SCRIPT_DIR/arctic-seed-slots-from-global-auth.sh" "$@"
    ;;
  enable-caveman|caveman-enable)
    if [ "$#" -gt 0 ]; then
      mode="$1"
      shift
      exec bash "$SCRIPT_DIR/arctic-session-wrapper.sh" --method enable-caveman --caveman-mode "$mode" "$@"
    fi
    exec bash "$SCRIPT_DIR/arctic-session-wrapper.sh" --method enable-caveman "$@"
    ;;
  disable-caveman|caveman-disable)
    exec bash "$SCRIPT_DIR/arctic-session-wrapper.sh" --method disable-caveman "$@"
    ;;
  verify-caveman)
    exec bash "$SCRIPT_DIR/verify-caveman-all-paths.sh" "$@"
    ;;
  auth-doctor|doctor-auth)
    exec bash "$SCRIPT_DIR/arctic-auth-doctor.sh" "$@"
    ;;
  status)
    bash "$SCRIPT_DIR/arctic-slot-status.sh"
    echo "---"
    bash "$SCRIPT_DIR/caveman-check.sh"
    echo "---"
    exec bash "$SCRIPT_DIR/verify-caveman-all-paths.sh"
    ;;
  --help|-h)
    usage
    ;;
  *)
    usage
    ;;
esac
