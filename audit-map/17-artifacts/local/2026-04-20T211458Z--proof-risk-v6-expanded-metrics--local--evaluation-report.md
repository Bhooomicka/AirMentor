# Proof Risk Model Evaluation

Generated at: 2026-04-19T21:14:58.954Z

## Corpus

- Requested seeds: 101, 4141, 5353
- Governed seeds evaluated: 101, 4141, 5353
- Reused existing governed runs: 0
- Created governed runs: 3
- Skipped requested non-manifest seeds: none
- Proof runs in corpus: 3
- Total checkpoint evidence rows: 64800
- Held-out test rows: 21600
- Active run used for UI parity: simulation_run_9b12baad-d1db-4a81-a752-9aa47641b929
- Duplicate governed runs skipped: 1
- Non-manifest runs skipped: 0
- Stage definitions per semester: 5
- Complete requested runs: 3
- Incomplete requested runs: 1

| Seed | Run ID | Semester Span | Checkpoints (actual/expected) | Stage Evidence Rows | Complete |
| --- | --- | --- | --- | --- | --- |
| 101 | sim_mnc_2023_first6_v1 | 1-6 | 0/30 | 0 | false |
| 101 | simulation_run_d925c289-3e5a-45ba-a2b7-7a4ba11e45cd | 1-6 | 30/30 | 21600 | true |
| 4141 | simulation_run_370b5f3d-1796-4f9e-b684-798b23c69632 | 1-6 | 30/30 | 21600 | true |
| 5353 | simulation_run_9b12baad-d1db-4a81-a752-9aa47641b929 | 1-6 | 30/30 | 21600 | true |

## Overall Course Runtime Risk

| Scorer | Brier | Log Loss | ROC-AUC | PR-AUC | ECE | Slope | Intercept | Positive Rate | Support |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| model | 0.1677 | 0.5088 | 0.7635 | 0.5388 | 0.0408 | 0.8908 | 0.097 | 0.2794 | 21600 |
| heuristic | 0.2551 | 0.7414 | 0.7124 | 0.4971 | 0.2605 | 0.5269 | -0.7237 | 0.2794 | 21600 |

- Overall-course runtime Brier lift: 0.0874
- Overall-course runtime AUC lift: 0.0511

## Head Metrics

| Head | Model Brier | Heuristic Brier | Brier Lift | Model Log Loss | Heuristic Log Loss | Model ROC-AUC | Heuristic ROC-AUC | AUC Lift | Model PR-AUC | Heuristic PR-AUC | Model ECE | Heuristic ECE |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| attendanceRisk | 0.0367 | 0.3183 | 0.2816 | 0.1379 | 0.9317 | 0.9427 | 0.7588 | 0.1839 | 0.6806 | 0.1604 | 0.041 | 0.4709 |
| ceRisk | 0.048 | 0.3154 | 0.2674 | 0.1783 | 0.9174 | 0.8585 | 0.7977 | 0.0608 | 0.3407 | 0.2111 | 0.0172 | 0.4744 |
| seeRisk | 0.1778 | 0.2696 | 0.0918 | 0.5393 | 0.7853 | 0.725 | 0.675 | 0.05 | 0.4661 | 0.4339 | 0.0523 | 0.2669 |
| overallCourseRisk | 0.1677 | 0.2551 | 0.0874 | 0.5088 | 0.7414 | 0.7635 | 0.7124 | 0.0511 | 0.5388 | 0.4971 | 0.0408 | 0.2605 |
| downstreamCarryoverRisk | 0.0894 | 0.3001 | 0.2107 | 0.2655 | 0.8725 | 0.9512 | 0.5647 | 0.3865 | 0.8942 | 0.3844 | 0.0608 | 0.2085 |

## Action Rollups

| Action | Cases | Immediate Benefit (scaled points) | Next-Checkpoint Lift (Lower is Better) | Recovery Rate |
| --- | --- | --- | --- | --- |
| targeted-tutoring | 998 | 6.3 | -10.1 | 0.048 |
| pre-see-rescue | 917 | 8.1 | -6.2 | 0.0989 |
| prerequisite-bridge | 914 | 8.5 | -5.4 | 0.0575 |
| attendance-recovery-follow-up | 293 | 4 | -8.2 | 0.1094 |

## Policy Diagnostics

| Phenotype | Support | Avg Lift | Avg Regret | Beats No Action | Teacher Efficacy Allowed |
| --- | --- | --- | --- | --- | --- |
| late-semester-acute | 8707 | 1.13 | 0 | true | true |
| persistent-nonresponse | 2511 | 6.05 | 0 | true | true |
| prerequisite-dominant | 11978 | 5.45 | 0 | true | true |
| academic-weakness | 5243 | 10.29 | 0 | true | true |
| attendance-dominant | 1621 | 3.96 | 0 | true | true |
| diffuse-amber | 3992 | 9.25 | 0 | true | true |

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
| 1 | post-tt1 | 3 | 0.1361 | 0.175 | 0.2333 | 0.2333 | 0.0389 | 0.075 | 0.3 | 0.4647 | 0.4533 | 0.3 |
| 1 | post-tt2 | 3 | 0.1917 | 0.275 | 0.3 | 0.3 | 0.1583 | 0.275 | 0.3 | 0.577 | 0.57 | 0.3 |
| 1 | post-assignments | 3 | 0.1861 | 0.2583 | 0.3 | 0.3 | 0.1667 | 0.3167 | 0.3 | 0.5983 | 0.5897 | 0.3 |
| 1 | post-see | 3 | 0.2333 | 0.35 | 0.35 | 0.35 | 0.2417 | 0.425 | 0.35 | 0.8556 | 0.8514 | 0.35 |
| 2 | pre-tt1 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0.55 | 0.3 |
| 2 | post-tt1 | 3 | 0.2444 | 0.3 | 0.3 | 0.3 | 0.3694 | 0.6583 | 0.3 | 0.6408 | 0.4575 | 0.3 |
| 2 | post-tt2 | 3 | 0.2028 | 0.3 | 0.3 | 0.3 | 0.4111 | 0.6583 | 0.3 | 0.7109 | 0.54 | 0.3 |
| 2 | post-assignments | 3 | 0.2083 | 0.3 | 0.3 | 0.3 | 0.4083 | 0.6583 | 0.3 | 0.7349 | 0.61 | 0.3 |
| 2 | post-see | 3 | 0.2583 | 0.35 | 0.35 | 0.35 | 0.3222 | 0.5167 | 0.35 | 0.7782 | 0.56 | 0.35 |
| 3 | pre-tt1 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0.55 | 0.3 |
| 3 | post-tt1 | 3 | 0.2833 | 0.3 | 0.3 | 0.3 | 0.375 | 0.6333 | 0.3 | 0.6773 | 0.492 | 0.3 |
| 3 | post-tt2 | 3 | 0.2639 | 0.3 | 0.3 | 0.3 | 0.4028 | 0.65 | 0.3 | 0.742 | 0.55 | 0.3 |
| 3 | post-assignments | 3 | 0.2611 | 0.3 | 0.3 | 0.3 | 0.3972 | 0.65 | 0.3 | 0.7465 | 0.56 | 0.3 |
| 3 | post-see | 3 | 0.3056 | 0.35 | 0.35 | 0.35 | 0.3167 | 0.5167 | 0.35 | 0.7928 | 0.5935 | 0.35 |
| 4 | pre-tt1 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0.55 | 0.3 |
| 4 | post-tt1 | 3 | 0.2944 | 0.3 | 0.3 | 0.3 | 0.4167 | 0.6417 | 0.3 | 0.7051 | 0.5229 | 0.3 |
| 4 | post-tt2 | 3 | 0.2806 | 0.3 | 0.3 | 0.3 | 0.4056 | 0.6583 | 0.3 | 0.7616 | 0.5772 | 0.3 |
| 4 | post-assignments | 3 | 0.2806 | 0.3 | 0.3 | 0.3 | 0.4083 | 0.6583 | 0.3 | 0.7576 | 0.5848 | 0.3 |
| 4 | post-see | 3 | 0.325 | 0.35 | 0.35 | 0.35 | 0.325 | 0.5 | 0.35 | 0.7929 | 0.5894 | 0.35 |
| 5 | pre-tt1 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0.55 | 0.3 |
| 5 | post-tt1 | 3 | 0.2944 | 0.3 | 0.3 | 0.3 | 0.4222 | 0.6667 | 0.3 | 0.7389 | 0.5665 | 0.3 |
| 5 | post-tt2 | 3 | 0.2806 | 0.3 | 0.3 | 0.3 | 0.4306 | 0.675 | 0.3 | 0.7972 | 0.6314 | 0.3 |
| 5 | post-assignments | 3 | 0.275 | 0.3 | 0.3 | 0.3 | 0.4417 | 0.675 | 0.3 | 0.799 | 0.6267 | 0.3 |
| 5 | post-see | 3 | 0.325 | 0.35 | 0.35 | 0.35 | 0.2917 | 0.4917 | 0.35 | 0.8035 | 0.6055 | 0.35 |
| 6 | pre-tt1 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0.55 | 0.3 |
| 6 | post-tt1 | 3 | 0.2778 | 0.3 | 0.3 | 0.3 | 0.4556 | 0.6583 | 0.3 | 0.7485 | 0.6064 | 0.3 |
| 6 | post-tt2 | 3 | 0.2889 | 0.3 | 0.3 | 0.3 | 0.4806 | 0.6917 | 0.3 | 0.8087 | 0.6378 | 0.3 |
| 6 | post-assignments | 3 | 0.2833 | 0.3 | 0.3 | 0.3 | 0.4806 | 0.6917 | 0.3 | 0.8133 | 0.651 | 0.3 |
| 6 | post-see | 3 | 0.3222 | 0.35 | 0.35 | 0.35 | 0.3361 | 0.5167 | 0.35 | 0.8146 | 0.6356 | 0.35 |

- Queue burden acceptance gates: {"actionableRatesWithinLimit":true,"sectionToleranceWithinLimit":true,"watchRatesWithinLimit":false,"actionableQueuePpvProxyWithinLimit":true}

### Queue Burden Diagnostic Cross-Run Union

| Semester | Stage | Unique Students | Open Queue Students | Watch Students | Open Rate | Watch Rate | PPV Proxy | Threshold | Section Max Rate |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | pre-tt1 | 120 | 0 | 0 | 0 | 0 | 0 | 0.3 | 0 |
| 1 | post-tt1 | 120 | 43 | 12 | 0.3583 | 0.1 | 0.4742 | 0.3 | 0.5 |
| 1 | post-tt2 | 120 | 58 | 39 | 0.4833 | 0.325 | 0.5847 | 0.3 | 0.5 |
| 1 | post-assignments | 120 | 59 | 40 | 0.4917 | 0.3333 | 0.6022 | 0.3 | 0.5333 |
| 1 | post-see | 120 | 69 | 45 | 0.575 | 0.375 | 0.8606 | 0.35 | 0.6167 |
| 2 | pre-tt1 | 120 | 0 | 0 | 0 | 0 | 0 | 0.3 | 0 |
| 2 | post-tt1 | 120 | 66 | 54 | 0.55 | 0.45 | 0.7192 | 0.3 | 0.55 |
| 2 | post-tt2 | 120 | 55 | 65 | 0.4583 | 0.5417 | 0.8085 | 0.3 | 0.4667 |
| 2 | post-assignments | 120 | 57 | 63 | 0.475 | 0.525 | 0.8081 | 0.3 | 0.4833 |
| 2 | post-see | 120 | 71 | 47 | 0.5917 | 0.3917 | 0.8752 | 0.35 | 0.6167 |
| 3 | pre-tt1 | 120 | 0 | 0 | 0 | 0 | 0 | 0.3 | 0 |
| 3 | post-tt1 | 120 | 76 | 44 | 0.6333 | 0.3667 | 0.7188 | 0.3 | 0.6667 |
| 3 | post-tt2 | 120 | 74 | 46 | 0.6167 | 0.3833 | 0.7909 | 0.3 | 0.65 |
| 3 | post-assignments | 120 | 75 | 45 | 0.625 | 0.375 | 0.7996 | 0.3 | 0.6667 |
| 3 | post-see | 120 | 78 | 39 | 0.65 | 0.325 | 0.8513 | 0.35 | 0.6667 |
| 4 | pre-tt1 | 120 | 0 | 0 | 0 | 0 | 0 | 0.3 | 0 |
| 4 | post-tt1 | 120 | 75 | 44 | 0.625 | 0.3667 | 0.7501 | 0.3 | 0.6333 |
| 4 | post-tt2 | 120 | 76 | 44 | 0.6333 | 0.3667 | 0.8066 | 0.3 | 0.6833 |
| 4 | post-assignments | 120 | 77 | 43 | 0.6417 | 0.3583 | 0.7957 | 0.3 | 0.6833 |
| 4 | post-see | 120 | 81 | 39 | 0.675 | 0.325 | 0.8433 | 0.35 | 0.6833 |
| 5 | pre-tt1 | 120 | 0 | 0 | 0 | 0 | 0 | 0.3 | 0 |
| 5 | post-tt1 | 120 | 80 | 39 | 0.6667 | 0.325 | 0.7719 | 0.3 | 0.6833 |
| 5 | post-tt2 | 120 | 77 | 43 | 0.6417 | 0.3583 | 0.8295 | 0.3 | 0.6667 |
| 5 | post-assignments | 120 | 75 | 45 | 0.625 | 0.375 | 0.8357 | 0.3 | 0.6667 |
| 5 | post-see | 120 | 92 | 26 | 0.7667 | 0.2167 | 0.8424 | 0.35 | 0.8 |
| 6 | pre-tt1 | 120 | 0 | 0 | 0 | 0 | 0 | 0.3 | 0 |
| 6 | post-tt1 | 120 | 75 | 45 | 0.625 | 0.375 | 0.7803 | 0.3 | 0.65 |
| 6 | post-tt2 | 120 | 74 | 46 | 0.6167 | 0.3833 | 0.8503 | 0.3 | 0.6167 |
| 6 | post-assignments | 120 | 74 | 46 | 0.6167 | 0.3833 | 0.8611 | 0.3 | 0.6333 |
| 6 | post-see | 120 | 84 | 36 | 0.7 | 0.3 | 0.8685 | 0.35 | 0.7333 |

## Carryover Head

| Metric | Value |
| --- | --- |
| Brier lift | 0.2107 |
| AUC lift | 0.3865 |
| Calibration method | isotonic |
| Display probability allowed | true |
| Support warning | NA |

## Stage Rollups

| Semester | Stage | Projection Rows | Unique Students | High Risk Rows | High Risk Students | Medium Risk Rows | Avg Risk | Avg Lift | Open Queue Rows | Open Queue Students | Watch Students |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | pre-tt1 | 2160 | 120 | 0 | 0 | 0 | 8.5 | 0 | 0 | 0 | 0 |
| 1 | post-tt1 | 2160 | 120 | 0 | 0 | 118 | 15.7 | 0 | 90 | 43 | 12 |
| 1 | post-tt2 | 2160 | 120 | 21 | 17 | 241 | 17.9 | 0.8 | 106 | 58 | 39 |
| 1 | post-assignments | 2160 | 120 | 29 | 24 | 257 | 18.3 | 0.8 | 106 | 59 | 40 |
| 1 | post-see | 2160 | 120 | 477 | 101 | 621 | 41.3 | 5.3 | 233 | 69 | 45 |
| 2 | pre-tt1 | 2160 | 120 | 0 | 0 | 573 | 24.9 | 0 | 0 | 0 | 0 |
| 2 | post-tt1 | 2160 | 120 | 118 | 46 | 861 | 33.1 | 0 | 352 | 66 | 54 |
| 2 | post-tt2 | 2160 | 120 | 240 | 78 | 728 | 35.8 | 4.9 | 190 | 55 | 65 |
| 2 | post-assignments | 2160 | 120 | 252 | 79 | 724 | 36 | 4.8 | 185 | 57 | 63 |
| 2 | post-see | 2160 | 120 | 603 | 105 | 638 | 47.1 | 5.1 | 223 | 71 | 47 |
| 3 | pre-tt1 | 2160 | 120 | 2 | 2 | 872 | 29.9 | 0 | 0 | 0 | 0 |
| 3 | post-tt1 | 2160 | 120 | 181 | 61 | 980 | 38.4 | 0 | 463 | 76 | 44 |
| 3 | post-tt2 | 2160 | 120 | 338 | 93 | 836 | 41.3 | 5.4 | 254 | 74 | 46 |
| 3 | post-assignments | 2160 | 120 | 347 | 94 | 834 | 41.6 | 5.4 | 252 | 75 | 45 |
| 3 | post-see | 2160 | 120 | 662 | 112 | 732 | 51.3 | 5.4 | 259 | 78 | 39 |
| 4 | pre-tt1 | 2160 | 120 | 2 | 2 | 1099 | 33.3 | 0 | 0 | 0 | 0 |
| 4 | post-tt1 | 2160 | 120 | 233 | 72 | 1089 | 42.3 | 0 | 498 | 75 | 44 |
| 4 | post-tt2 | 2160 | 120 | 410 | 98 | 918 | 45.5 | 5.9 | 290 | 76 | 44 |
| 4 | post-assignments | 2160 | 120 | 432 | 98 | 900 | 45.9 | 5.7 | 299 | 77 | 43 |
| 4 | post-see | 2160 | 120 | 753 | 108 | 767 | 55.5 | 4.8 | 285 | 81 | 39 |
| 5 | pre-tt1 | 2160 | 120 | 5 | 5 | 1183 | 35.9 | 0 | 0 | 0 | 0 |
| 5 | post-tt1 | 2160 | 120 | 307 | 90 | 1146 | 46.3 | 0 | 541 | 80 | 39 |
| 5 | post-tt2 | 2160 | 120 | 485 | 106 | 958 | 49.6 | 6.2 | 303 | 77 | 43 |
| 5 | post-assignments | 2160 | 120 | 505 | 107 | 941 | 50 | 6 | 289 | 75 | 45 |
| 5 | post-see | 2160 | 120 | 889 | 115 | 780 | 60.6 | 4.4 | 272 | 92 | 26 |
| 6 | pre-tt1 | 2160 | 120 | 5 | 4 | 1412 | 38.8 | 0 | 0 | 0 | 0 |
| 6 | post-tt1 | 2160 | 120 | 370 | 94 | 1209 | 49.7 | 0 | 557 | 75 | 45 |
| 6 | post-tt2 | 2160 | 120 | 639 | 116 | 975 | 55.2 | 6.1 | 324 | 74 | 46 |
| 6 | post-assignments | 2160 | 120 | 661 | 116 | 958 | 55.5 | 5.9 | 314 | 74 | 46 |
| 6 | post-see | 2160 | 120 | 964 | 119 | 772 | 63.4 | 4.2 | 279 | 84 | 36 |

