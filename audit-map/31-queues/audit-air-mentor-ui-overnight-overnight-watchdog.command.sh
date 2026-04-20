#!/usr/bin/env bash
set -euo pipefail
cd /home/raed/projects/air-mentor-ui
bash /home/raed/projects/air-mentor-ui/audit-map/16-scripts/overnight-watchdog.sh --worker --duration-seconds 0 --interval-seconds 600 --shutdown-on-complete 1
