# Audit The Audit Pass Prompt v2.0

Objective: inspect whether the audit workflow itself is missing surfaces, evidence, safeguards, or completeness checks.

Required outputs:

- workflow gaps
- prompt or template gaps
- automation blind spots
- coverage diff by route, role, feature, dependency, data, state, ML, test, UX, and live evidence family
- exact reruns or remediation steps required

Rules:

- compare the repo tree and current inventories against actual covered artifacts
- identify anything suspiciously thin, summary-like, or unsupported by evidence
- do not treat prior pass completion flags as proof of completeness

Completion gate:

- this pass is not complete until every undercovered family is either requeued or explicitly accepted as blocked with evidence
