# Unattended Execution Strategy

- start unattended runs only through detached `tmux`
- keep one queue file and one checkpoint per pass
- prefer sequential overnight execution over uncontrolled parallel fan-out
- stop on auth gaps, hard contradictions, or budget hard stops
