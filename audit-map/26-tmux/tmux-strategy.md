# tmux Strategy

- one deterministic session per major pass
- stdout/stderr logged to `22-logs/`
- status in `29-status/`
- checkpoints in `30-checkpoints/`
- command record in `31-queues/`
- do not rely on editor-integrated terminals to preserve state
