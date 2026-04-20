# Arctic Switching Limitations

- Automatic account switching is only safe between already-authenticated isolated slots.
- Automatic provider switching is only safe between already-authenticated isolated slots.
- The installed build showed provider lookup limitations after `arctic models --refresh`.
- The documented `--name` account syntax is not accepted by the installed CLI surface here.
- Therefore, repeated logins into the global Arctic auth store are treated as overwrite-risky.
- Current automation may prepare and checkpoint a switch, but must stop for manual auth/verification until the first successful end-to-end Arctic slot session is recorded.
