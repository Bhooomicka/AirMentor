# Role Surface Pass Prompt v2.0

Objective: map what each role can see, trigger, depend on, and be blocked from in the scoped surface, with exhaustive coverage of visible, hidden, conditional, and indirectly reachable UI.

Required outputs:

- role-surface entries using `templates/role-surface-template.md`
- per-role inventories of screens, menus, toolbars, tabs, modals, cards, tables, filters, drilldowns, search results, and action rails
- route guards, data-visibility rules, backend authorization rules, and cross-role truth-coupling notes
- role-specific loading, empty, error, disabled, locked, and out-of-scope states

Traversal rules:

- crawl role by role; do not summarize across roles until each role has been enumerated separately
- distinguish visible UI from backend-enforced authority
- record hidden or conditional controls even when they are reachable only from drilldowns or queue/history paths
- record whether the same student, course, proof run, or faculty truth is presented differently across roles
- include indirect access paths such as notifications, search, history links, row clicks, hover actions, and modal follow-through

Completion gate:

- no role is complete until all visible and conditional surfaces in the scoped subsystem are enumerated
- if a role has only partial evidence, mark exactly which surfaces remain undercovered
