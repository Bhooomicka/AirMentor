# Account Routing Pass Prompt v2.0

Objective: decide which provider, slot, account identity, model, and reasoning route should run a given pass without violating execution-verification, cost, or safety rules.

Required outputs:

- routing decision using `templates/account-routing-decision-template.md`
- compatibility check between requested model and selected provider
- blocker analysis
- manual action required if needed

Rules:

- use slot IDs as execution identity and treat account labels as metadata only
- do not route to model-visible but execution-unverified Arctic slots for unattended work
- if no safe route exists, emit an exact resume command instead of bluffing
