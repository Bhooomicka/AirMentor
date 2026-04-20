AirMentor audit OS pass: inventory-pass

Read these files first:
- audit-map/index.md
- audit-map/24-agent-memory/known-facts.md
- audit-map/14-reconciliation/contradiction-matrix.md
- audit-map/23-coverage/coverage-ledger.md

Pass context:
- context: bootstrap
- task class: structured
- risk class: medium
- model: gpt-5.4-mini
- reasoning effort: medium

Extra instruction:
Dry-run usage check only

Always persist important results into audit-map files before ending.

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

