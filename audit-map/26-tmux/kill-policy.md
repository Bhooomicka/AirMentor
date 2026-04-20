# Kill Policy

- Kill only the targeted deterministic session.
- Update the corresponding status file to `stopped`.
- Never kill unrelated `tmux` sessions.
- If the job was blocked rather than broken, preserve the last checkpoint and command record.
