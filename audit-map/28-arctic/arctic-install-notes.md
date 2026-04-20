# Arctic Install Notes

- Install method used: `npm install -g @arctic-cli/arctic`
- Install verification:
  - `arctic --version` -> `0.0.0-main-202603151831`
  - `arctic --help` succeeded
  - `arctic auth list` succeeded
- PATH verification:
  - `~/.npm-global/bin` is already in `PATH`
- Current limitation:
  - `arctic auth list` shows `0 credentials`
  - `arctic models --refresh` succeeded, but provider-targeted lookups such as `arctic models openai` returned `Provider not found`
