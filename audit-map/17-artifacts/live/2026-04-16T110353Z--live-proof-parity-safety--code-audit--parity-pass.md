# Live Proof And Parity Safety Audit

- Run: `live-credentialed-parity-pass`
- Generated at: `2026-04-16T11:03:53Z`

## Safe Or Conditionally Safe Paths

- `air-mentor-api/package.json` -> `verify:live-session-contract` calls `scripts/check-railway-deploy-readiness.mjs session-contract`.
- `scripts/check-railway-deploy-readiness.mjs` only performs live login and session-restore verification when the explicit live admin credentials are present.
- `scripts/proof-risk-semester-walk-probe.mjs` is only conditionally reversible: it posts `activate-semester` requests but restores the previous operational semester when the original semester is known and differs from the last target.

## Unsafe Blind Live Paths

- `scripts/system-admin-proof-risk-smoke.mjs` is not read-only.
  - It can create proof imports.
  - It can validate imports.
  - It can review crosswalks.
  - It can approve imports.
  - It can recompute risk.
  - It can create proof runs.
  - It can activate semesters.
- `scripts/system-admin-teaching-parity-smoke.mjs` is not read-only.
  - It patches faculty display name, phone, and designation.
  - It patches appointment records.
  - No full restore sequence is proven inside the same run.

## Safety Conclusion

- The current repo does not expose a trustworthy read-only live proof/parity observer for `SYSTEM_ADMIN`, `COURSE_LEADER`, `MENTOR`, `HOD`, and student-shell same-target comparison.
- Under the pass safety rule, those scripts must not be used on the deployed stack until a full restore path is proven or a dedicated read-only observer is added.
