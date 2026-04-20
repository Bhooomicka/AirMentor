#!/usr/bin/env bash
set -euo pipefail
cd /home/raed/projects/air-mentor-ui
codex exec -C /home/raed/projects/air-mentor-ui -m gpt-5.4-mini -c model_reasoning_effort=\"high\" -o /home/raed/projects/air-mentor-ui/audit-map/32-reports/audit-air-mentor-ui-bootstrap-route-map-pass.last-message.md --full-auto - < /home/raed/projects/air-mentor-ui/audit-map/31-queues/audit-air-mentor-ui-bootstrap-route-map-pass.prompt.md
