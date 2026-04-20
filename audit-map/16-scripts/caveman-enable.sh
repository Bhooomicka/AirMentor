#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

usage() {
	echo "Usage: $0 [mode] [--force-all]" >&2
	exit 64
}

mode="full"
force_all="0"

while [ "$#" -gt 0 ]; do
	case "$1" in
		--force-all)
			force_all="1"
			shift
			;;
		--help|-h)
			usage
			;;
		lite|full|ultra|wenyan-lite|wenyan-full|wenyan-ultra)
			mode="$1"
			shift
			;;
		*)
			usage
			;;
	esac
done

file="$(caveman_state_file)"
ensure_audit_dirs
write_env_file "$file" enabled "1" mode "$mode" force_all "$force_all" updated_at "$(timestamp_utc)"
echo "caveman_enabled=1"
echo "caveman_mode=$mode"
echo "caveman_force_all=$force_all"
