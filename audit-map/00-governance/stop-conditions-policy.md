# Stop Conditions Policy

Stop a run immediately when any of the following occurs:

- required authentication is missing
- provider/model routing is no longer trustworthy
- live behavior contradicts a deployment assumption and needs manual review
- budget hard stop or rate limit stop is reached
- a script would otherwise spin without progress
- evidence capture failed and would make the pass non-reproducible
