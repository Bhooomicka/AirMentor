# Operator Tooling Options

Date: 2026-04-15

## Current Decision

The current operator dashboard should remain:

- file-backed
- script-generated
- dependency-light
- safe to run on NixOS without network or package-manager coupling

That is why the first implementation uses:

- `operator-dashboard.py`
- `operator-dashboard.sh`
- existing tmux/status/checkpoint/log files

This gives a durable dashboard immediately, without making the audit OS more fragile.

## Strong Fits For Future Integration

### 1. Textual

Best candidate for a richer interactive dashboard.

Why it fits:

- mature Python terminal UI framework
- data tables, widgets, command palette, and async-friendly event loops
- can render a much better live operator cockpit than raw shell output
- works well with the current file-backed status model

Best use here:

- a future full-screen operator console reading the existing status/checkpoint/report files
- interactive drilldown into active pass, queue, slot cooldowns, and logs

Main risk:

- adds a Python UI dependency and a larger maintenance surface than the current zero-extra-dependency renderer

### 2. Gum

Best candidate for shell-native polish without rewriting the stack.

Why it fits:

- purpose-built for prettier shell UX
- includes table, style, pager, log, filter, and spinner primitives
- easy to layer onto the current bash workflow

Best use here:

- decorate `operator-dashboard.sh`
- improve selection menus and guided recovery prompts
- keep the current shell-first architecture while making it easier on the eyes

Main risk:

- still fundamentally shell-driven, so it improves presentation more than architecture

### 3. Watchexec

Best candidate for auto-refresh and local event triggers.

Why it fits:

- cross-platform watcher
- can restart or rerun commands when files change
- available across package-manager ecosystems, including Nix-friendly setups

Best use here:

- auto-refresh the operator dashboard when status/checkpoint/log files change
- trigger sidecar refresh commands in development

Main risk:

- it is a watcher and supervisor helper, not a dashboard by itself

## Not The First Move

### Full Textual migration right now

Not the first move because the workflow needed better correctness before better visuals.

### More brittle shell parsing around live provider internals

Not worth it unless Arctic exposes a cleaner machine-readable progress/status surface than we already have.

## Recommended Path

1. Keep the new dashboard/report path as the stable baseline.
2. Keep stall detection and recovery logic in the execution wrapper.
3. If you want a better UI next, build a Textual view on top of the same files rather than replacing the file-backed system.
4. If you want a quick visual upgrade before that, add optional Gum formatting to `operator-dashboard.sh`.
5. If you want auto-refresh on local file changes outside tmux workers, add Watchexec as an optional dev-side convenience wrapper.

## Source Links

- Arctic homepage: <https://www.usearctic.sh/>
- Textual: <https://github.com/Textualize/textual>
- Gum: <https://github.com/charmbracelet/gum>
- Watchexec: <https://github.com/watchexec/watchexec>
