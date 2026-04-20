# Proof Risk Model Evaluation

Generated at: 2026-04-19T23:11:58.011Z

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
- Active run used for UI parity: simulation_run_1e6ae270-3a59-49d5-90af-7124227a1d69
- Duplicate governed runs skipped: 1
- Scenario-mismatch governed runs skipped: 0
- Non-manifest runs skipped: 0
- Stage definitions per semester: 5
- Complete requested runs: 3
- Incomplete requested runs: 1

| Seed | Run ID | Semester Span | Checkpoints (actual/expected) | Stage Evidence Rows | Complete |
| --- | --- | --- | --- | --- | --- |
| 101 | sim_mnc_2023_first6_v1 | 1-6 | 0/30 | 0 | false |
| 101 | simulation_run_162c0de2-4ad9-4da4-8b2f-09bee6d4944c | 1-6 | 30/30 | 21600 | true |
| 4141 | simulation_run_57bca04f-376f-4130-89ce-d53671182394 | 1-6 | 30/30 | 21600 | true |
| 5353 | simulation_run_1e6ae270-3a59-49d5-90af-7124227a1d69 | 1-6 | 30/30 | 21600 | true |

## Overall Course Runtime Risk

| Scorer | Brier | Log Loss | ROC-AUC | PR-AUC | ECE | Slope | Intercept | Positive Rate | Support |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| model | 0.1214 | 0.3843 | 0.8056 | 0.4631 | 0.0185 | 0.9472 | 0.0463 | 0.1843 | 21600 |
| heuristic | 0.2153 | 0.6396 | 0.7618 | 0.4327 | 0.273 | 0.7159 | -0.8398 | 0.1843 | 21600 |

- Overall-course runtime Brier lift: 0.0939
- Overall-course runtime AUC lift: 0.0438

## Head Metrics

| Head | Model Brier | Heuristic Brier | Brier Lift | Model Log Loss | Heuristic Log Loss | Model ROC-AUC | Heuristic ROC-AUC | AUC Lift | Model PR-AUC | Heuristic PR-AUC | Model ECE | Heuristic ECE |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| attendanceRisk | 0.0269 | 0.2518 | 0.2249 | 0.1015 | 0.7503 | 0.9549 | 0.8047 | 0.1502 | 0.6487 | 0.1409 | 0.0372 | 0.4163 |
| ceRisk | 0.0255 | 0.254 | 0.2285 | 0.1011 | 0.7537 | 0.8843 | 0.8429 | 0.0414 | 0.2312 | 0.1604 | 0.0048 | 0.4276 |
| seeRisk | 0.1357 | 0.2261 | 0.0904 | 0.4281 | 0.6715 | 0.7571 | 0.721 | 0.0361 | 0.3933 | 0.3753 | 0.0299 | 0.2644 |
| overallCourseRisk | 0.1214 | 0.2153 | 0.0939 | 0.3843 | 0.6396 | 0.8056 | 0.7618 | 0.0438 | 0.4631 | 0.4327 | 0.0185 | 0.273 |
| downstreamCarryoverRisk | 0.1006 | 0.2618 | 0.1612 | 0.299 | 0.7642 | 0.9246 | 0.6014 | 0.3232 | 0.7968 | 0.3437 | 0.0317 | 0.1858 |

## Variant Comparison

| Variant | Brier | Log Loss | ROC-AUC | PR-AUC | ECE |
| --- | --- | --- | --- | --- | --- |
| current-v6 | 0.1214 | 0.3843 | 0.8056 | 0.4631 | 0.0185 |
| baseline-v5-like | 0.1221 | 0.3878 | 0.8011 | 0.4608 | 0.0177 |
| hybrid-router | 0.1125 | 0.3612 | 0.8174 | 0.5633 | 0.0175 |
| challenger | 0.1142 | 0.373 | 0.7712 | 0.5351 | 0.0154 |
| heuristic | 0.2153 | 0.6396 | 0.7618 | 0.4327 | 0.273 |

| Head | Fallback Alpha | Stage Routes |
| --- | --- | --- |
| attendanceRisk | 0 | post-tt1:0, post-see:1, pre-tt1:0, post-assignments:1, post-tt2:1 |
| ceRisk | 1 | post-tt1:1, post-see:1, pre-tt1:1, post-assignments:1, post-tt2:1 |
| seeRisk | 1 | post-tt1:0, post-see:1, pre-tt1:0, post-assignments:0, post-tt2:0 |
| overallCourseRisk | 0 | post-tt1:1, post-see:1, pre-tt1:1, post-assignments:0, post-tt2:0 |
| downstreamCarryoverRisk | 1 | post-tt1:1, post-see:1, pre-tt1:1, post-assignments:1, post-tt2:1 |

| Head | Baseline ROC-AUC | Current ROC-AUC | Hybrid ROC-AUC | Challenger ROC-AUC | Current-Baseline Brier Lift | Current-Hybrid Brier Lift | Hybrid-Challenger Brier Lift |
| --- | --- | --- | --- | --- | --- | --- | --- |
| attendanceRisk | 0.9511 | 0.9549 | 0.9729 | 0.9401 | 0.0006 | -0.0056 | 0.0038 |
| ceRisk | 0.8774 | 0.8843 | 0.8863 | 0.6814 | 0.0004 | 0 | 0.0008 |
| seeRisk | 0.7509 | 0.7571 | 0.7603 | 0.7458 | 0.0007 | -0.0026 | 0.0005 |
| overallCourseRisk | 0.8011 | 0.8056 | 0.8174 | 0.7712 | 0.0007 | -0.0089 | 0.0017 |
| downstreamCarryoverRisk | 0.9242 | 0.9246 | 0.9246 | 0.9141 | 0.0002 | 0 | 0.0008 |

## Action Rollups

| Action | Cases | Immediate Benefit (scaled points) | Next-Checkpoint Lift (Lower is Better) | Recovery Rate |
| --- | --- | --- | --- | --- |
| targeted-tutoring | 884 | 9.2 | -9.8 | 0.048 |
| pre-see-rescue | 822 | 8 | -6.1 | 0.1152 |
| prerequisite-bridge | 799 | 9.5 | -5.3 | 0.0651 |
| attendance-recovery-follow-up | 357 | 3.1 | -6.9 | 0.1151 |

## Policy Diagnostics

| Phenotype | Support | Avg Lift | Avg Regret | Beats No Action | Teacher Efficacy Allowed |
| --- | --- | --- | --- | --- | --- |
| late-semester-acute | 7670 | 1.12 | 0 | true | true |
| persistent-nonresponse | 1651 | 7.92 | 0 | true | true |
| prerequisite-dominant | 9468 | 6.26 | 0 | true | true |
| academic-weakness | 5048 | 10.63 | 0 | true | true |
| attendance-dominant | 1632 | 4.44 | 0 | true | true |
| diffuse-amber | 3739 | 9.57 | 0 | true | true |

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
| 1 | post-tt1 | 3 | 0.1361 | 0.2 | 0.2083 | 0.2083 | 0.0194 | 0.0333 | 0.3 | 0.4713 | 0.4558 | 0.3 |
| 1 | post-tt2 | 3 | 0.175 | 0.2333 | 0.2917 | 0.2917 | 0.125 | 0.2083 | 0.3 | 0.5754 | 0.5751 | 0.3 |
| 1 | post-assignments | 3 | 0.1778 | 0.2333 | 0.3 | 0.3 | 0.1278 | 0.2333 | 0.3 | 0.5961 | 0.5861 | 0.3 |
| 1 | post-see | 3 | 0.2333 | 0.35 | 0.35 | 0.35 | 0.2417 | 0.4417 | 0.35 | 0.8416 | 0.8393 | 0.35 |
| 2 | pre-tt1 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0.55 | 0.3 |
| 2 | post-tt1 | 3 | 0.2083 | 0.3 | 0.3 | 0.3 | 0.3333 | 0.6167 | 0.3 | 0.6167 | 0.43 | 0.3 |
| 2 | post-tt2 | 3 | 0.2028 | 0.3 | 0.3 | 0.3 | 0.3444 | 0.625 | 0.3 | 0.6844 | 0.51 | 0.3 |
| 2 | post-assignments | 3 | 0.2028 | 0.3 | 0.3 | 0.3 | 0.3444 | 0.625 | 0.3 | 0.6876 | 0.51 | 0.3 |
| 2 | post-see | 3 | 0.2389 | 0.35 | 0.35 | 0.35 | 0.2917 | 0.5167 | 0.35 | 0.7534 | 0.525 | 0.35 |
| 3 | pre-tt1 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0.55 | 0.3 |
| 3 | post-tt1 | 3 | 0.2611 | 0.3 | 0.3 | 0.3 | 0.3472 | 0.6333 | 0.3 | 0.6578 | 0.4673 | 0.3 |
| 3 | post-tt2 | 3 | 0.2528 | 0.3 | 0.3 | 0.3 | 0.3667 | 0.65 | 0.3 | 0.7329 | 0.5489 | 0.3 |
| 3 | post-assignments | 3 | 0.25 | 0.3 | 0.3 | 0.3 | 0.3667 | 0.65 | 0.3 | 0.7413 | 0.5706 | 0.3 |
| 3 | post-see | 3 | 0.2806 | 0.35 | 0.35 | 0.35 | 0.2861 | 0.5167 | 0.35 | 0.7751 | 0.5635 | 0.35 |
| 4 | pre-tt1 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0.55 | 0.3 |
| 4 | post-tt1 | 3 | 0.2722 | 0.3 | 0.3 | 0.3 | 0.3639 | 0.6083 | 0.3 | 0.682 | 0.5092 | 0.3 |
| 4 | post-tt2 | 3 | 0.2667 | 0.3 | 0.3 | 0.3 | 0.3694 | 0.6417 | 0.3 | 0.7599 | 0.6012 | 0.3 |
| 4 | post-assignments | 3 | 0.2667 | 0.3 | 0.3 | 0.3 | 0.3694 | 0.6417 | 0.3 | 0.766 | 0.6183 | 0.3 |
| 4 | post-see | 3 | 0.2889 | 0.35 | 0.35 | 0.35 | 0.2889 | 0.5083 | 0.35 | 0.7874 | 0.5905 | 0.35 |
| 5 | pre-tt1 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0.55 | 0.3 |
| 5 | post-tt1 | 3 | 0.2833 | 0.3 | 0.3 | 0.3 | 0.3861 | 0.65 | 0.3 | 0.7301 | 0.5703 | 0.3 |
| 5 | post-tt2 | 3 | 0.2694 | 0.3 | 0.3 | 0.3 | 0.4056 | 0.6667 | 0.3 | 0.7837 | 0.61 | 0.3 |
| 5 | post-assignments | 3 | 0.2694 | 0.3 | 0.3 | 0.3 | 0.3972 | 0.6667 | 0.3 | 0.7872 | 0.6076 | 0.3 |
| 5 | post-see | 3 | 0.3111 | 0.35 | 0.35 | 0.35 | 0.2722 | 0.4583 | 0.35 | 0.8043 | 0.6271 | 0.35 |
| 6 | pre-tt1 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0.55 | 0.3 |
| 6 | post-tt1 | 3 | 0.2917 | 0.3 | 0.3 | 0.3 | 0.4083 | 0.65 | 0.3 | 0.7413 | 0.563 | 0.3 |
| 6 | post-tt2 | 3 | 0.2833 | 0.3 | 0.3 | 0.3 | 0.4222 | 0.6833 | 0.3 | 0.7984 | 0.622 | 0.3 |
| 6 | post-assignments | 3 | 0.2833 | 0.3 | 0.3 | 0.3 | 0.4278 | 0.6917 | 0.3 | 0.8061 | 0.6367 | 0.3 |
| 6 | post-see | 3 | 0.3111 | 0.35 | 0.35 | 0.35 | 0.3028 | 0.4917 | 0.35 | 0.8235 | 0.6361 | 0.35 |

- Queue burden acceptance gates: {"actionableRatesWithinLimit":true,"sectionToleranceWithinLimit":true,"watchRatesWithinLimit":false,"actionableQueuePpvProxyWithinLimit":true}

### Queue Burden Diagnostic Cross-Run Union

| Semester | Stage | Unique Students | Open Queue Students | Watch Students | Open Rate | Watch Rate | PPV Proxy | Threshold | Section Max Rate |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | pre-tt1 | 120 | 0 | 0 | 0 | 0 | 0 | 0.3 | 0 |
| 1 | post-tt1 | 120 | 42 | 7 | 0.35 | 0.0583 | 0.4824 | 0.3 | 0.5 |
| 1 | post-tt2 | 120 | 53 | 33 | 0.4417 | 0.275 | 0.5838 | 0.3 | 0.4667 |
| 1 | post-assignments | 120 | 55 | 32 | 0.4583 | 0.2667 | 0.5993 | 0.3 | 0.4833 |
| 1 | post-see | 120 | 69 | 46 | 0.575 | 0.3833 | 0.8486 | 0.35 | 0.5833 |
| 2 | pre-tt1 | 120 | 0 | 0 | 0 | 0 | 0 | 0.3 | 0 |
| 2 | post-tt1 | 120 | 62 | 56 | 0.5167 | 0.4667 | 0.7203 | 0.3 | 0.55 |
| 2 | post-tt2 | 120 | 63 | 56 | 0.525 | 0.4667 | 0.7797 | 0.3 | 0.5333 |
| 2 | post-assignments | 120 | 63 | 56 | 0.525 | 0.4667 | 0.7852 | 0.3 | 0.5333 |
| 2 | post-see | 120 | 70 | 48 | 0.5833 | 0.4 | 0.8691 | 0.35 | 0.6 |
| 3 | pre-tt1 | 120 | 0 | 0 | 0 | 0 | 0 | 0.3 | 0 |
| 3 | post-tt1 | 120 | 69 | 51 | 0.575 | 0.425 | 0.7113 | 0.3 | 0.6167 |
| 3 | post-tt2 | 120 | 74 | 45 | 0.6167 | 0.375 | 0.7869 | 0.3 | 0.6667 |
| 3 | post-assignments | 120 | 74 | 45 | 0.6167 | 0.375 | 0.7947 | 0.3 | 0.6667 |
| 3 | post-see | 120 | 80 | 39 | 0.6667 | 0.325 | 0.8526 | 0.35 | 0.7167 |
| 4 | pre-tt1 | 120 | 0 | 0 | 0 | 0 | 0 | 0.3 | 0 |
| 4 | post-tt1 | 120 | 70 | 48 | 0.5833 | 0.4 | 0.7291 | 0.3 | 0.6167 |
| 4 | post-tt2 | 120 | 71 | 48 | 0.5917 | 0.4 | 0.8135 | 0.3 | 0.6667 |
| 4 | post-assignments | 120 | 73 | 46 | 0.6083 | 0.3833 | 0.8151 | 0.3 | 0.6833 |
| 4 | post-see | 120 | 76 | 43 | 0.6333 | 0.3583 | 0.865 | 0.35 | 0.6833 |
| 5 | pre-tt1 | 120 | 0 | 0 | 0 | 0 | 0 | 0.3 | 0 |
| 5 | post-tt1 | 120 | 74 | 44 | 0.6167 | 0.3667 | 0.7695 | 0.3 | 0.65 |
| 5 | post-tt2 | 120 | 71 | 49 | 0.5917 | 0.4083 | 0.8354 | 0.3 | 0.6667 |
| 5 | post-assignments | 120 | 73 | 47 | 0.6083 | 0.3917 | 0.8385 | 0.3 | 0.6833 |
| 5 | post-see | 120 | 85 | 31 | 0.7083 | 0.2583 | 0.8526 | 0.35 | 0.7833 |
| 6 | pre-tt1 | 120 | 0 | 0 | 0 | 0 | 0 | 0.3 | 0 |
| 6 | post-tt1 | 120 | 77 | 43 | 0.6417 | 0.3583 | 0.7852 | 0.3 | 0.6833 |
| 6 | post-tt2 | 120 | 79 | 41 | 0.6583 | 0.3417 | 0.8334 | 0.3 | 0.6833 |
| 6 | post-assignments | 120 | 79 | 41 | 0.6583 | 0.3417 | 0.8434 | 0.3 | 0.6833 |
| 6 | post-see | 120 | 84 | 36 | 0.7 | 0.3 | 0.8836 | 0.35 | 0.7 |

## Carryover Head

| Metric | Value |
| --- | --- |
| Brier lift | 0.1612 |
| AUC lift | 0.3232 |
| Calibration method | isotonic |
| Display probability allowed | true |
| Support warning | NA |

## Stage Rollups

| Semester | Stage | Projection Rows | Unique Students | High Risk Rows | High Risk Students | Medium Risk Rows | Avg Risk | Avg Lift | Open Queue Rows | Open Queue Students | Watch Students |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | pre-tt1 | 2160 | 120 | 0 | 0 | 0 | 8.1 | 0 | 0 | 0 | 0 |
| 1 | post-tt1 | 2160 | 120 | 0 | 0 | 94 | 14.3 | 0 | 83 | 42 | 7 |
| 1 | post-tt2 | 2160 | 120 | 17 | 15 | 202 | 16.3 | 0.7 | 93 | 53 | 33 |
| 1 | post-assignments | 2160 | 120 | 23 | 20 | 217 | 16.6 | 0.7 | 100 | 55 | 32 |
| 1 | post-see | 2160 | 120 | 392 | 90 | 614 | 36.9 | 5.1 | 238 | 69 | 46 |
| 2 | pre-tt1 | 2160 | 120 | 0 | 0 | 461 | 22.2 | 0 | 0 | 0 | 0 |
| 2 | post-tt1 | 2160 | 120 | 98 | 42 | 740 | 29.4 | 0 | 311 | 62 | 56 |
| 2 | post-tt2 | 2160 | 120 | 201 | 69 | 653 | 31.8 | 4.5 | 179 | 63 | 56 |
| 2 | post-assignments | 2160 | 120 | 216 | 72 | 650 | 32.1 | 4.4 | 178 | 63 | 56 |
| 2 | post-see | 2160 | 120 | 524 | 98 | 590 | 42.2 | 5 | 218 | 70 | 48 |
| 3 | pre-tt1 | 2160 | 120 | 2 | 2 | 724 | 26.4 | 0 | 0 | 0 | 0 |
| 3 | post-tt1 | 2160 | 120 | 147 | 53 | 855 | 34 | 0 | 410 | 69 | 51 |
| 3 | post-tt2 | 2160 | 120 | 280 | 82 | 742 | 36.6 | 5.1 | 244 | 74 | 45 |
| 3 | post-assignments | 2160 | 120 | 288 | 83 | 741 | 36.9 | 5.1 | 244 | 74 | 45 |
| 3 | post-see | 2160 | 120 | 585 | 103 | 658 | 45.9 | 5.2 | 264 | 80 | 39 |
| 4 | pre-tt1 | 2160 | 120 | 2 | 2 | 909 | 29.5 | 0 | 0 | 0 | 0 |
| 4 | post-tt1 | 2160 | 120 | 189 | 65 | 944 | 37.4 | 0 | 460 | 70 | 48 |
| 4 | post-tt2 | 2160 | 120 | 350 | 93 | 780 | 40.3 | 5.5 | 287 | 71 | 48 |
| 4 | post-assignments | 2160 | 120 | 373 | 93 | 759 | 40.7 | 5.3 | 284 | 73 | 46 |
| 4 | post-see | 2160 | 120 | 676 | 103 | 624 | 49.7 | 4.7 | 268 | 76 | 43 |
| 5 | pre-tt1 | 2160 | 120 | 5 | 5 | 978 | 31.8 | 0 | 0 | 0 | 0 |
| 5 | post-tt1 | 2160 | 120 | 256 | 81 | 995 | 41 | 0 | 497 | 74 | 44 |
| 5 | post-tt2 | 2160 | 120 | 424 | 104 | 822 | 44.2 | 5.9 | 287 | 71 | 49 |
| 5 | post-assignments | 2160 | 120 | 448 | 105 | 799 | 44.6 | 5.7 | 291 | 73 | 47 |
| 5 | post-see | 2160 | 120 | 809 | 113 | 617 | 54.7 | 4.6 | 260 | 85 | 31 |
| 6 | pre-tt1 | 2160 | 120 | 5 | 4 | 1143 | 34.9 | 0 | 0 | 0 | 0 |
| 6 | post-tt1 | 2160 | 120 | 306 | 82 | 1039 | 44.5 | 0 | 534 | 77 | 43 |
| 6 | post-tt2 | 2160 | 120 | 584 | 115 | 777 | 49.9 | 5.5 | 303 | 79 | 41 |
| 6 | post-assignments | 2160 | 120 | 602 | 114 | 769 | 50.3 | 5.4 | 303 | 79 | 41 |
| 6 | post-see | 2160 | 120 | 878 | 115 | 632 | 58 | 4.1 | 257 | 84 | 36 |

