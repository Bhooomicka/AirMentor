# Caveman Codex Integration Notes

- Caveman's README documents a repo-local `.codex/hooks.json` path for Codex always-on mode.
- This repo currently has an untracked zero-byte file named `.codex`, not a directory.
- Replacing that file silently would violate the rule against altering user-owned unrelated changes.

Safe posture:

- keep Caveman available as an optional global skill
- use explicit wrappers and policy gates for low-risk passes
- leave always-on repo-local activation disabled until the file conflict is resolved intentionally
