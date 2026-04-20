# Proof Risk Model Evaluation

Generated at: 2026-04-19T22:05:45.315Z

## Corpus

- Seed profile: smoke-3
- Requested seeds: 101, 4141, 5353
- Governed seeds evaluated: 101, 4141, 5353
- Reused existing governed runs: 0
- Created governed runs: 3
- Skipped requested non-manifest seeds: none
- Proof runs in corpus: 3
- Total checkpoint evidence rows: 64800
- Held-out test rows: 21600
- Active run used for UI parity: simulation_run_dd044969-ec57-4a60-8190-52b200acf090
- Duplicate governed runs skipped: 1
- Scenario-mismatch governed runs skipped: 0
- Non-manifest runs skipped: 0
- Stage definitions per semester: 5
- Complete requested runs: 3
- Incomplete requested runs: 1

| Seed | Run ID | Semester Span | Checkpoints (actual/expected) | Stage Evidence Rows | Complete |
| --- | --- | --- | --- | --- | --- |
| 101 | sim_mnc_2023_first6_v1 | 1-6 | 0/30 | 0 | false |
| 101 | simulation_run_af8e0c21-322f-4055-85f4-419d0f50b0f2 | 1-6 | 30/30 | 21600 | true |
| 4141 | simulation_run_93b5925c-e865-49d0-b2a2-8c79b7bc60b5 | 1-6 | 30/30 | 21600 | true |
| 5353 | simulation_run_dd044969-ec57-4a60-8190-52b200acf090 | 1-6 | 30/30 | 21600 | true |

## Overall Course Runtime Risk

| Scorer | Brier | Log Loss | ROC-AUC | PR-AUC | ECE | Slope | Intercept | Positive Rate | Support |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| model | 0.1215 | 0.3843 | 0.8049 | 0.4637 | 0.0183 | 0.948 | 0.0458 | 0.1843 | 21600 |
| heuristic | 0.2157 | 0.6401 | 0.7613 | 0.4351 | 0.2734 | 0.7152 | -0.8406 | 0.1843 | 21600 |

- Overall-course runtime Brier lift: 0.0942
- Overall-course runtime AUC lift: 0.0436

## Head Metrics

| Head | Model Brier | Heuristic Brier | Brier Lift | Model Log Loss | Heuristic Log Loss | Model ROC-AUC | Heuristic ROC-AUC | AUC Lift | Model PR-AUC | Heuristic PR-AUC | Model ECE | Heuristic ECE |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| attendanceRisk | 0.027 | 0.2521 | 0.2251 | 0.1019 | 0.7509 | 0.9536 | 0.8043 | 0.1493 | 0.6411 | 0.136 | 0.0374 | 0.4167 |
| ceRisk | 0.0256 | 0.2543 | 0.2287 | 0.1013 | 0.7541 | 0.8837 | 0.8417 | 0.042 | 0.2271 | 0.1645 | 0.005 | 0.428 |
| seeRisk | 0.1357 | 0.2263 | 0.0906 | 0.4284 | 0.6717 | 0.7562 | 0.7209 | 0.0353 | 0.3951 | 0.3762 | 0.0299 | 0.2648 |
| overallCourseRisk | 0.1215 | 0.2157 | 0.0942 | 0.3843 | 0.6401 | 0.8049 | 0.7613 | 0.0436 | 0.4637 | 0.4351 | 0.0183 | 0.2734 |
| downstreamCarryoverRisk | 0.1006 | 0.2621 | 0.1615 | 0.299 | 0.7647 | 0.9248 | 0.6003 | 0.3245 | 0.7956 | 0.3421 | 0.0311 | 0.1861 |

## Variant Comparison

| Variant | Brier | Log Loss | ROC-AUC | PR-AUC | ECE |
| --- | --- | --- | --- | --- | --- |
| current-v6 | 0.1215 | 0.3843 | 0.8049 | 0.4637 | 0.0183 |
| baseline-v5-like | 0.1222 | 0.388 | 0.8001 | 0.4599 | 0.0177 |
| challenger | 0.1141 | 0.373 | 0.7678 | 0.54 | 0.0154 |
| heuristic | 0.2157 | 0.6401 | 0.7613 | 0.4351 | 0.2734 |

| Head | Current ROC-AUC | Baseline ROC-AUC | Challenger ROC-AUC | Current-Baseline AUC Lift | Current-Challenger AUC Lift | Current-Baseline Brier Lift | Current-Challenger Brier Lift |
| --- | --- | --- | --- | --- | --- | --- | --- |
| attendanceRisk | 0.9536 | 0.9503 | 0.9411 | 0.0033 | 0.0125 | 0.0006 | -0.0017 |
| ceRisk | 0.8837 | 0.8773 | 0.7293 | 0.0064 | 0.1544 | 0.0002 | 0.001 |
| seeRisk | 0.7562 | 0.7508 | 0.7433 | 0.0054 | 0.0129 | 0.0006 | -0.0021 |
| overallCourseRisk | 0.8049 | 0.8001 | 0.7678 | 0.0048 | 0.0371 | 0.0007 | -0.0074 |
| downstreamCarryoverRisk | 0.9248 | 0.9243 | 0.9142 | 0.0005 | 0.0106 | 0.0002 | 0.0008 |

## Action Rollups

| Action | Cases | Immediate Benefit (scaled points) | Next-Checkpoint Lift (Lower is Better) | Recovery Rate |
| --- | --- | --- | --- | --- |
| targeted-tutoring | 855 | 8.9 | -10 | 0.0468 |
| pre-see-rescue | 831 | 8.1 | -6.1 | 0.1175 |
| prerequisite-bridge | 785 | 9 | -5.1 | 0.0624 |
| attendance-recovery-follow-up | 350 | 3.7 | -7.1 | 0.1159 |

## Policy Diagnostics

| Phenotype | Support | Avg Lift | Avg Regret | Beats No Action | Teacher Efficacy Allowed |
| --- | --- | --- | --- | --- | --- |
| late-semester-acute | 7671 | 1.14 | 0 | true | true |
| persistent-nonresponse | 1633 | 7.83 | 0 | true | true |
| prerequisite-dominant | 9482 | 6.2 | 0 | true | true |
| academic-weakness | 5069 | 10.55 | 0 | true | true |
| attendance-dominant | 1636 | 4.44 | 0 | true | true |
| diffuse-amber | 3709 | 9.52 | 0 | true | true |

- Policy acceptance gates: {"structuredStudyPlanWithinLimit":true,"targetedTutoringBeatsStructuredStudyPlanAcademicSlice":true,"noRecommendedActionUnderperformsNoAction":true}

## CO Evidence Diagnostics

| Metric | Value |
| --- | --- |
| totalRows | 64800 |
| fallbackCount | 0 |
| theoryFallbackCount | 0 |
| labFallbackCount | 0 |

- CO evidence acceptance gates: {"theoryCoursesDefaultToBlueprintEvidence":true,"fallbackOnlyInExplicitCases":true}

## Queue Burden

| Semester | Stage | Runs | Mean Open | Median Open | P95 Open | Max Open | Mean Watch | P95 Watch | P95 Section Max | Mean PPV | Min PPV | Threshold |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | pre-tt1 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0.55 | 0.3 |
| 1 | post-tt1 | 3 | 0.1333 | 0.1917 | 0.2083 | 0.2083 | 0.0167 | 0.025 | 0.3 | 0.476 | 0.4652 | 0.3 |
| 1 | post-tt2 | 3 | 0.1833 | 0.25 | 0.3 | 0.3 | 0.1083 | 0.1833 | 0.3 | 0.5678 | 0.567 | 0.3 |
| 1 | post-assignments | 3 | 0.1833 | 0.25 | 0.3 | 0.3 | 0.1194 | 0.2167 | 0.3 | 0.5899 | 0.5814 | 0.3 |
| 1 | post-see | 3 | 0.2333 | 0.35 | 0.35 | 0.35 | 0.2278 | 0.4167 | 0.35 | 0.842 | 0.836 | 0.35 |
| 2 | pre-tt1 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0.55 | 0.3 |
| 2 | post-tt1 | 3 | 0.2111 | 0.3 | 0.3 | 0.3 | 0.3361 | 0.625 | 0.3 | 0.6214 | 0.44 | 0.3 |
| 2 | post-tt2 | 3 | 0.2028 | 0.3 | 0.3 | 0.3 | 0.3389 | 0.625 | 0.3 | 0.6971 | 0.54 | 0.3 |
| 2 | post-assignments | 3 | 0.2028 | 0.3 | 0.3 | 0.3 | 0.3444 | 0.625 | 0.3 | 0.6976 | 0.54 | 0.3 |
| 2 | post-see | 3 | 0.2361 | 0.35 | 0.35 | 0.35 | 0.2944 | 0.4917 | 0.35 | 0.7613 | 0.55 | 0.35 |
| 3 | pre-tt1 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0.55 | 0.3 |
| 3 | post-tt1 | 3 | 0.2639 | 0.3 | 0.3 | 0.3 | 0.3472 | 0.6333 | 0.3 | 0.6624 | 0.4817 | 0.3 |
| 3 | post-tt2 | 3 | 0.2389 | 0.3 | 0.3 | 0.3 | 0.375 | 0.6583 | 0.3 | 0.7412 | 0.5771 | 0.3 |
| 3 | post-assignments | 3 | 0.2389 | 0.3 | 0.3 | 0.3 | 0.3722 | 0.6583 | 0.3 | 0.7464 | 0.5886 | 0.3 |
| 3 | post-see | 3 | 0.2639 | 0.35 | 0.35 | 0.35 | 0.2833 | 0.5 | 0.35 | 0.7791 | 0.5864 | 0.35 |
| 4 | pre-tt1 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0.55 | 0.3 |
| 4 | post-tt1 | 3 | 0.2722 | 0.3 | 0.3 | 0.3 | 0.3583 | 0.6083 | 0.3 | 0.6834 | 0.5131 | 0.3 |
| 4 | post-tt2 | 3 | 0.2611 | 0.3 | 0.3 | 0.3 | 0.3722 | 0.625 | 0.3 | 0.7545 | 0.59 | 0.3 |
| 4 | post-assignments | 3 | 0.2583 | 0.3 | 0.3 | 0.3 | 0.3694 | 0.625 | 0.3 | 0.7633 | 0.6133 | 0.3 |
| 4 | post-see | 3 | 0.2861 | 0.35 | 0.35 | 0.35 | 0.2833 | 0.5083 | 0.35 | 0.7973 | 0.6237 | 0.35 |
| 5 | pre-tt1 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0.55 | 0.3 |
| 5 | post-tt1 | 3 | 0.2833 | 0.3 | 0.3 | 0.3 | 0.3861 | 0.65 | 0.3 | 0.7299 | 0.561 | 0.3 |
| 5 | post-tt2 | 3 | 0.2694 | 0.3 | 0.3 | 0.3 | 0.4056 | 0.6667 | 0.3 | 0.7916 | 0.624 | 0.3 |
| 5 | post-assignments | 3 | 0.2694 | 0.3 | 0.3 | 0.3 | 0.3972 | 0.6667 | 0.3 | 0.795 | 0.624 | 0.3 |
| 5 | post-see | 3 | 0.3028 | 0.35 | 0.35 | 0.35 | 0.2861 | 0.4583 | 0.35 | 0.8026 | 0.62 | 0.35 |
| 6 | pre-tt1 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0.55 | 0.3 |
| 6 | post-tt1 | 3 | 0.2861 | 0.3 | 0.3 | 0.3 | 0.3972 | 0.65 | 0.3 | 0.7433 | 0.5703 | 0.3 |
| 6 | post-tt2 | 3 | 0.2778 | 0.3 | 0.3 | 0.3 | 0.425 | 0.6833 | 0.3 | 0.8002 | 0.6336 | 0.3 |
| 6 | post-assignments | 3 | 0.2722 | 0.3 | 0.3 | 0.3 | 0.4306 | 0.6917 | 0.3 | 0.8125 | 0.6612 | 0.3 |
| 6 | post-see | 3 | 0.3028 | 0.35 | 0.35 | 0.35 | 0.3083 | 0.5083 | 0.35 | 0.8344 | 0.6644 | 0.35 |

- Queue burden acceptance gates: {"actionableRatesWithinLimit":true,"sectionToleranceWithinLimit":true,"watchRatesWithinLimit":false,"actionableQueuePpvProxyWithinLimit":true}

### Queue Burden Diagnostic Cross-Run Union

| Semester | Stage | Unique Students | Open Queue Students | Watch Students | Open Rate | Watch Rate | PPV Proxy | Threshold | Section Max Rate |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | pre-tt1 | 120 | 0 | 0 | 0 | 0 | 0 | 0.3 | 0 |
| 1 | post-tt1 | 120 | 41 | 6 | 0.3417 | 0.05 | 0.4873 | 0.3 | 0.5 |
| 1 | post-tt2 | 120 | 58 | 28 | 0.4833 | 0.2333 | 0.5728 | 0.3 | 0.5 |
| 1 | post-assignments | 120 | 57 | 30 | 0.475 | 0.25 | 0.5937 | 0.3 | 0.5 |
| 1 | post-see | 120 | 72 | 42 | 0.6 | 0.35 | 0.8468 | 0.35 | 0.6167 |
| 2 | pre-tt1 | 120 | 0 | 0 | 0 | 0 | 0 | 0.3 | 0 |
| 2 | post-tt1 | 120 | 63 | 56 | 0.525 | 0.4667 | 0.7176 | 0.3 | 0.5667 |
| 2 | post-tt2 | 120 | 65 | 54 | 0.5417 | 0.45 | 0.7782 | 0.3 | 0.55 |
| 2 | post-assignments | 120 | 63 | 56 | 0.525 | 0.4667 | 0.7852 | 0.3 | 0.5333 |
| 2 | post-see | 120 | 69 | 51 | 0.575 | 0.425 | 0.873 | 0.35 | 0.5833 |
| 3 | pre-tt1 | 120 | 0 | 0 | 0 | 0 | 0 | 0.3 | 0 |
| 3 | post-tt1 | 120 | 69 | 51 | 0.575 | 0.425 | 0.7133 | 0.3 | 0.6167 |
| 3 | post-tt2 | 120 | 71 | 49 | 0.5917 | 0.4083 | 0.7941 | 0.3 | 0.6167 |
| 3 | post-assignments | 120 | 72 | 48 | 0.6 | 0.4 | 0.795 | 0.3 | 0.6333 |
| 3 | post-see | 120 | 76 | 41 | 0.6333 | 0.3417 | 0.8604 | 0.35 | 0.65 |
| 4 | pre-tt1 | 120 | 0 | 0 | 0 | 0 | 0 | 0.3 | 0 |
| 4 | post-tt1 | 120 | 72 | 46 | 0.6 | 0.3833 | 0.7267 | 0.3 | 0.6333 |
| 4 | post-tt2 | 120 | 71 | 48 | 0.5917 | 0.4 | 0.8125 | 0.3 | 0.6667 |
| 4 | post-assignments | 120 | 71 | 48 | 0.5917 | 0.4 | 0.8154 | 0.3 | 0.6667 |
| 4 | post-see | 120 | 75 | 44 | 0.625 | 0.3667 | 0.8685 | 0.35 | 0.6667 |
| 5 | pre-tt1 | 120 | 0 | 0 | 0 | 0 | 0 | 0.3 | 0 |
| 5 | post-tt1 | 120 | 73 | 45 | 0.6083 | 0.375 | 0.7734 | 0.3 | 0.6333 |
| 5 | post-tt2 | 120 | 70 | 50 | 0.5833 | 0.4167 | 0.8446 | 0.3 | 0.6333 |
| 5 | post-assignments | 120 | 73 | 47 | 0.6083 | 0.3917 | 0.8458 | 0.3 | 0.6667 |
| 5 | post-see | 120 | 81 | 35 | 0.675 | 0.2917 | 0.86 | 0.35 | 0.7333 |
| 6 | pre-tt1 | 120 | 0 | 0 | 0 | 0 | 0 | 0.3 | 0 |
| 6 | post-tt1 | 120 | 82 | 38 | 0.6833 | 0.3167 | 0.7711 | 0.3 | 0.7333 |
| 6 | post-tt2 | 120 | 78 | 42 | 0.65 | 0.35 | 0.8414 | 0.3 | 0.6667 |
| 6 | post-assignments | 120 | 77 | 43 | 0.6417 | 0.3583 | 0.8536 | 0.3 | 0.6667 |
| 6 | post-see | 120 | 86 | 34 | 0.7167 | 0.2833 | 0.889 | 0.35 | 0.75 |

## Carryover Head

| Metric | Value |
| --- | --- |
| Brier lift | 0.1615 |
| AUC lift | 0.3245 |
| Calibration method | isotonic |
| Display probability allowed | true |
| Support warning | NA |

## Stage Rollups

| Semester | Stage | Projection Rows | Unique Students | High Risk Rows | High Risk Students | Medium Risk Rows | Avg Risk | Avg Lift | Open Queue Rows | Open Queue Students | Watch Students |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | pre-tt1 | 2160 | 120 | 0 | 0 | 0 | 7.9 | 0 | 0 | 0 | 0 |
| 1 | post-tt1 | 2160 | 120 | 0 | 0 | 96 | 14.3 | 0 | 86 | 41 | 6 |
| 1 | post-tt2 | 2160 | 120 | 18 | 16 | 198 | 16.3 | 0.6 | 98 | 58 | 28 |
| 1 | post-assignments | 2160 | 120 | 24 | 21 | 213 | 16.6 | 0.7 | 105 | 57 | 30 |
| 1 | post-see | 2160 | 120 | 386 | 91 | 626 | 37 | 5.2 | 239 | 72 | 42 |
| 2 | pre-tt1 | 2160 | 120 | 0 | 0 | 461 | 22.2 | 0 | 0 | 0 | 0 |
| 2 | post-tt1 | 2160 | 120 | 97 | 42 | 744 | 29.5 | 0 | 312 | 63 | 56 |
| 2 | post-tt2 | 2160 | 120 | 200 | 69 | 649 | 31.9 | 4.4 | 181 | 65 | 54 |
| 2 | post-assignments | 2160 | 120 | 216 | 72 | 645 | 32.1 | 4.4 | 177 | 63 | 56 |
| 2 | post-see | 2160 | 120 | 527 | 98 | 586 | 42.2 | 5 | 211 | 69 | 51 |
| 3 | pre-tt1 | 2160 | 120 | 2 | 2 | 725 | 26.4 | 0 | 0 | 0 | 0 |
| 3 | post-tt1 | 2160 | 120 | 148 | 53 | 857 | 34 | 0 | 412 | 69 | 51 |
| 3 | post-tt2 | 2160 | 120 | 281 | 83 | 736 | 36.7 | 5 | 235 | 71 | 49 |
| 3 | post-assignments | 2160 | 120 | 289 | 84 | 736 | 37 | 5 | 232 | 72 | 48 |
| 3 | post-see | 2160 | 120 | 577 | 102 | 663 | 45.8 | 5.2 | 252 | 76 | 41 |
| 4 | pre-tt1 | 2160 | 120 | 2 | 2 | 909 | 29.5 | 0 | 0 | 0 | 0 |
| 4 | post-tt1 | 2160 | 120 | 191 | 66 | 943 | 37.5 | 0 | 457 | 72 | 46 |
| 4 | post-tt2 | 2160 | 120 | 353 | 93 | 776 | 40.4 | 5.4 | 267 | 71 | 48 |
| 4 | post-assignments | 2160 | 120 | 376 | 93 | 756 | 40.8 | 5.2 | 269 | 71 | 48 |
| 4 | post-see | 2160 | 120 | 677 | 103 | 624 | 49.7 | 4.7 | 257 | 75 | 44 |
| 5 | pre-tt1 | 2160 | 120 | 5 | 5 | 979 | 31.8 | 0 | 0 | 0 | 0 |
| 5 | post-tt1 | 2160 | 120 | 260 | 80 | 995 | 41.2 | 0 | 502 | 73 | 45 |
| 5 | post-tt2 | 2160 | 120 | 430 | 104 | 818 | 44.3 | 5.9 | 287 | 70 | 50 |
| 5 | post-assignments | 2160 | 120 | 453 | 105 | 797 | 44.7 | 5.7 | 291 | 73 | 47 |
| 5 | post-see | 2160 | 120 | 801 | 113 | 628 | 54.7 | 4.7 | 256 | 81 | 35 |
| 6 | pre-tt1 | 2160 | 120 | 5 | 4 | 1145 | 34.9 | 0 | 0 | 0 | 0 |
| 6 | post-tt1 | 2160 | 120 | 302 | 82 | 1049 | 44.5 | 0 | 530 | 82 | 38 |
| 6 | post-tt2 | 2160 | 120 | 584 | 114 | 775 | 49.9 | 5.5 | 291 | 78 | 42 |
| 6 | post-assignments | 2160 | 120 | 602 | 114 | 766 | 50.3 | 5.4 | 289 | 77 | 43 |
| 6 | post-see | 2160 | 120 | 877 | 115 | 622 | 57.9 | 4.1 | 248 | 86 | 34 |

