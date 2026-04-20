# ML Audit Pass Prompt v2.0

Objective: identify and fully audit ML, heuristic, rule-based inference, scoring, ranking, calibration, thresholding, and fallback logic in the scoped area.

Required outputs:

- ML component entries using `templates/ml-component-template.md`
- explicit separation between deterministic logic, heuristics, trained-model behavior, calibration layers, and fallback behavior
- inputs, outputs, thresholds, gating logic, persistence, evaluation evidence, reproducibility status, and UI explanation surfaces

Rules:

- do not call something ML unless evidence supports it
- do not call a model or heuristic trustworthy until evaluation artifacts, provenance, and reproducibility are checked
- record calibration method, threshold provenance, support-warning logic, suppression logic, and missing-artifact fallbacks explicitly
- record how the outputs are framed to users and where that framing could mislead

Completion gate:

- every scoring, ranking, risk, inference, or fallback component in scope must be classified and evidenced as deterministic, heuristic, calibrated, trained, or unknown
