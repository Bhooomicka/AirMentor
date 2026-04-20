# Inventory Pass Prompt v1.0

Objective: enumerate the scoped files, routes, scripts, configs, and evidence sources without over-interpreting behavior.

Required inputs:

- target path or subsystem
- current coverage ledger
- current known facts and contradictions

Required outputs:

- update the relevant inventory index
- add coverage status
- add new ambiguities if discovered

Rules:

- name every file path explicitly
- separate frontend, backend, test, script, docs, and deploy surfaces
- do not infer behavior that has not been evidenced
