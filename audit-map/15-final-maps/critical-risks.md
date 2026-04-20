# Critical Risks

Aggregate the highest-risk contradictions, stale assumptions, and blind spots here.

- Role drift risk: the academic UI computes `allowedRoles` from proof-scoped bootstrap data while the session keeps its own active grants. A role can disappear from the UI without disappearing from the session.
- Role drift risk: `canAccessPage()` and the route sync logic can briefly accept a deep link and then snap it back to the role home page, which can mask route-level exposure in manual testing.
- Authorization blind spot: `Faculty Profile`, `student-shell`, and `risk-explorer` are easy to reach indirectly, but each has a backend scope gate that is narrower than the visible UI label suggests.
- UX density risk: the sysadmin request/proof/hierarchy surfaces and the course TT builder compress hidden state, restore behavior, scope aliases, and lock semantics into dense control planes, which can make correct behavior hard to interpret even when the code is right.
