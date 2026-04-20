# Proof Risk Model Evaluation

Generated at: 2026-04-19T23:24:57.785Z

## Corpus

- Seed profile: coverage-24
- Requested seeds: 101, 202, 303, 404, 505, 606, 707, 808, 4141, 4242, 4343, 4444, 4545, 4646, 4747, 4848, 5757, 5858, 5959, 6060, 6161, 6262, 6363, 6464
- Governed seeds evaluated: 101, 202, 303, 404, 505, 606, 707, 808, 4141, 4242, 4343, 4444, 4545, 4646, 4747, 4848, 5757, 5858, 5959, 6060, 6161, 6262, 6363, 6464
- Reused existing governed runs: 0
- Created governed runs: 24
- Skipped requested non-manifest seeds: none
- Proof runs in corpus: 24
- Total checkpoint evidence rows: 518400
- Held-out test rows: 172800
- Active run used for UI parity: simulation_run_0276c210-53a8-4453-b6c2-98868802d54d
- Duplicate governed runs skipped: 1
- Scenario-mismatch governed runs skipped: 0
- Non-manifest runs skipped: 0
- Stage definitions per semester: 5
- Complete requested runs: 24
- Incomplete requested runs: 1

| Seed | Run ID | Semester Span | Checkpoints (actual/expected) | Stage Evidence Rows | Complete |
| --- | --- | --- | --- | --- | --- |
| 101 | sim_mnc_2023_first6_v1 | 1-6 | 0/30 | 0 | false |
| 101 | simulation_run_b7a8b190-1179-415b-9acd-2916223a7ba3 | 1-6 | 30/30 | 21600 | true |
| 202 | simulation_run_1186c7ff-da6f-4621-81de-6d4e8ef82299 | 1-6 | 30/30 | 21600 | true |
| 303 | simulation_run_ce978d59-7f82-444f-b28e-daeaf5d1ae11 | 1-6 | 30/30 | 21600 | true |
| 404 | simulation_run_d4fe375f-69db-4b47-9636-e622d5ff0970 | 1-6 | 30/30 | 21600 | true |
| 505 | simulation_run_35c99de3-8b9b-4000-ad00-cb87c1b1c9f5 | 1-6 | 30/30 | 21600 | true |
| 606 | simulation_run_3ec48246-8e4a-44ee-8b04-970b53164293 | 1-6 | 30/30 | 21600 | true |
| 707 | simulation_run_17deff5c-ce59-47d9-9055-177afc554f7f | 1-6 | 30/30 | 21600 | true |
| 808 | simulation_run_73f3a78f-b9de-4cb0-aaca-86926cf67d55 | 1-6 | 30/30 | 21600 | true |
| 4141 | simulation_run_2b234c5c-a7b8-423f-991c-7f0bba48ba6a | 1-6 | 30/30 | 21600 | true |
| 4242 | simulation_run_b2f5439f-71da-4709-9962-b4c5616cb42c | 1-6 | 30/30 | 21600 | true |
| 4343 | simulation_run_45486392-d14c-498e-b909-95ba50da4c93 | 1-6 | 30/30 | 21600 | true |
| 4444 | simulation_run_14ae47fd-166c-4903-bc84-6775633454d0 | 1-6 | 30/30 | 21600 | true |
| 4545 | simulation_run_4920d27d-be5c-41dd-b50f-ee8c7beb945e | 1-6 | 30/30 | 21600 | true |
| 4646 | simulation_run_714f3e8a-8181-4f5b-8f42-29f9c643d12c | 1-6 | 30/30 | 21600 | true |
| 4747 | simulation_run_db835b94-f499-409f-b56e-93789f41669d | 1-6 | 30/30 | 21600 | true |
| 4848 | simulation_run_d26b67cd-7ee7-4b64-9d9c-7a096765b2ac | 1-6 | 30/30 | 21600 | true |
| 5757 | simulation_run_56f17501-a45e-432e-a3e2-af7d44c4ed25 | 1-6 | 30/30 | 21600 | true |
| 5858 | simulation_run_f2758ab7-e845-433e-a0c8-a2869e464ebc | 1-6 | 30/30 | 21600 | true |
| 5959 | simulation_run_95bd9566-d050-4229-9854-3935cd775b5d | 1-6 | 30/30 | 21600 | true |
| 6060 | simulation_run_15582c1b-62df-4b2e-a12d-4b9b866885e6 | 1-6 | 30/30 | 21600 | true |
| 6161 | simulation_run_17df4556-1acc-43a9-9744-8195de660522 | 1-6 | 30/30 | 21600 | true |
| 6262 | simulation_run_c94ab002-d7be-46c6-a65c-de221b2db73e | 1-6 | 30/30 | 21600 | true |
| 6363 | simulation_run_078f9b9e-276e-4d61-9358-e380690b2d11 | 1-6 | 30/30 | 21600 | true |
| 6464 | simulation_run_0276c210-53a8-4453-b6c2-98868802d54d | 1-6 | 30/30 | 21600 | true |

## Overall Course Runtime Risk

| Scorer | Brier | Log Loss | ROC-AUC | PR-AUC | ECE | Slope | Intercept | Positive Rate | Support |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| model | 0.1361 | 0.4212 | 0.7886 | 0.486 | 0.0074 | 1.0043 | 0.0048 | 0.211 | 172800 |
| heuristic | 0.2345 | 0.6916 | 0.7513 | 0.446 | 0.2794 | 0.6058 | -0.8377 | 0.211 | 172800 |

- Overall-course runtime Brier lift: 0.0984
- Overall-course runtime AUC lift: 0.0373

## Head Metrics

| Head | Model Brier | Heuristic Brier | Brier Lift | Model Log Loss | Heuristic Log Loss | Model ROC-AUC | Heuristic ROC-AUC | AUC Lift | Model PR-AUC | Heuristic PR-AUC | Model ECE | Heuristic ECE |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| attendanceRisk | 0.0522 | 0.2624 | 0.2102 | 0.182 | 0.7782 | 0.9238 | 0.7741 | 0.1497 | 0.6687 | 0.25 | 0.0055 | 0.3878 |
| ceRisk | 0.0309 | 0.2867 | 0.2558 | 0.1201 | 0.8438 | 0.857 | 0.8143 | 0.0427 | 0.2131 | 0.1502 | 0.001 | 0.4547 |
| seeRisk | 0.1378 | 0.2525 | 0.1147 | 0.4306 | 0.7441 | 0.7479 | 0.7049 | 0.043 | 0.3965 | 0.3544 | 0.0062 | 0.2949 |
| overallCourseRisk | 0.1361 | 0.2345 | 0.0984 | 0.4212 | 0.6916 | 0.7886 | 0.7513 | 0.0373 | 0.486 | 0.446 | 0.0074 | 0.2794 |
| downstreamCarryoverRisk | 0.0949 | 0.2741 | 0.1792 | 0.2849 | 0.8026 | 0.9325 | 0.6082 | 0.3243 | 0.832 | 0.3567 | 0.0041 | 0.2048 |

## Variant Comparison

| Variant | Brier | Log Loss | ROC-AUC | PR-AUC | ECE |
| --- | --- | --- | --- | --- | --- |
| current-v6 | 0.1361 | 0.4212 | 0.7886 | 0.486 | 0.0074 |
| baseline-v5-like | 0.1369 | 0.4247 | 0.7846 | 0.4829 | 0.0063 |
| challenger | 0.1349 | 0.4312 | 0.7418 | 0.4879 | 0.0028 |
| heuristic | 0.2345 | 0.6916 | 0.7513 | 0.446 | 0.2794 |

| Head | Current ROC-AUC | Baseline ROC-AUC | Challenger ROC-AUC | Current-Baseline AUC Lift | Current-Challenger AUC Lift | Current-Baseline Brier Lift | Current-Challenger Brier Lift |
| --- | --- | --- | --- | --- | --- | --- | --- |
| attendanceRisk | 0.9238 | 0.9193 | 0.9246 | 0.0045 | -0.0008 | 0.001 | -0.0106 |
| ceRisk | 0.857 | 0.8491 | 0.8447 | 0.0079 | 0.0123 | 0.0002 | -0.0024 |
| seeRisk | 0.7479 | 0.7437 | 0.7255 | 0.0042 | 0.0224 | 0.0005 | 0.0004 |
| overallCourseRisk | 0.7886 | 0.7846 | 0.7418 | 0.004 | 0.0468 | 0.0008 | -0.0012 |
| downstreamCarryoverRisk | 0.9325 | 0.9324 | 0.9207 | 0.0001 | 0.0118 | 0.0001 | 0.0018 |

## Action Rollups

| Action | Cases | Immediate Benefit (scaled points) | Next-Checkpoint Lift (Lower is Better) | Recovery Rate |
| --- | --- | --- | --- | --- |
| pre-see-rescue | 10281 | 8 | -6 | 0.0967 |
| targeted-tutoring | 9926 | 7.2 | -10.2 | 0.0458 |
| prerequisite-bridge | 4410 | 11.6 | -8.8 | 0.0422 |
| attendance-recovery-follow-up | 3992 | 3.8 | -7.1 | 0.1103 |
| outreach-plus-tutoring | 1 | 16 | -53 | 0 |

## Policy Diagnostics

| Phenotype | Support | Avg Lift | Avg Regret | Beats No Action | Teacher Efficacy Allowed |
| --- | --- | --- | --- | --- | --- |
| late-semester-acute | 103225 | 1.04 | 0 | true | true |
| persistent-nonresponse | 10491 | 12.12 | 0 | true | true |
| prerequisite-dominant | 111245 | 6.82 | 0 | true | true |
| academic-weakness | 55894 | 10.32 | 0 | true | true |
| attendance-dominant | 18095 | 4.37 | 0 | true | true |
| diffuse-amber | 44523 | 9.4 | 0 | true | true |

- Policy acceptance gates: {"structuredStudyPlanWithinLimit":true,"targetedTutoringBeatsStructuredStudyPlanAcademicSlice":true,"noRecommendedActionUnderperformsNoAction":true}

## CO Evidence Diagnostics

| Metric | Value |
| --- | --- |
| totalRows | 518400 |
| fallbackCount | 0 |
| theoryFallbackCount | 0 |
| labFallbackCount | 0 |

- CO evidence acceptance gates: {"theoryCoursesDefaultToBlueprintEvidence":true,"fallbackOnlyInExplicitCases":true}

## Queue Burden

| Semester | Stage | Runs | Mean Open | Median Open | P95 Open | Max Open | Mean Watch | P95 Watch | P95 Section Max | Mean PPV | Min PPV | Threshold |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | pre-tt1 | 24 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0.55 | 0.3 |
| 1 | post-tt1 | 24 | 0.2101 | 0.2167 | 0.2583 | 0.3 | 0.0135 | 0.0667 | 0.3 | 0.4697 | 0.4427 | 0.3 |
| 1 | post-tt2 | 24 | 0.2566 | 0.275 | 0.3 | 0.3 | 0.0431 | 0.1917 | 0.3 | 0.6006 | 0.5618 | 0.3 |
| 1 | post-assignments | 24 | 0.2635 | 0.2833 | 0.3 | 0.3 | 0.0465 | 0.225 | 0.3 | 0.6137 | 0.5667 | 0.3 |
| 1 | post-see | 24 | 0.3354 | 0.35 | 0.35 | 0.35 | 0.059 | 0.3333 | 0.35 | 0.8642 | 0.8357 | 0.35 |
| 2 | pre-tt1 | 24 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0.55 | 0.3 |
| 2 | post-tt1 | 24 | 0.2899 | 0.3 | 0.3 | 0.3 | 0.0837 | 0.45 | 0.3 | 0.7108 | 0.4486 | 0.3 |
| 2 | post-tt2 | 24 | 0.2896 | 0.3 | 0.3 | 0.3 | 0.0792 | 0.4417 | 0.3 | 0.7804 | 0.5233 | 0.3 |
| 2 | post-assignments | 24 | 0.2896 | 0.3 | 0.3 | 0.3 | 0.0889 | 0.45 | 0.3 | 0.7805 | 0.535 | 0.3 |
| 2 | post-see | 24 | 0.3375 | 0.35 | 0.35 | 0.35 | 0.0549 | 0.3 | 0.35 | 0.866 | 0.6267 | 0.35 |
| 3 | pre-tt1 | 24 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0.55 | 0.3 |
| 3 | post-tt1 | 24 | 0.2941 | 0.3 | 0.3 | 0.3 | 0.0927 | 0.4583 | 0.3 | 0.7595 | 0.5263 | 0.3 |
| 3 | post-tt2 | 24 | 0.2941 | 0.3 | 0.3 | 0.3 | 0.0993 | 0.4917 | 0.3 | 0.8236 | 0.5958 | 0.3 |
| 3 | post-assignments | 24 | 0.2944 | 0.3 | 0.3 | 0.3 | 0.1066 | 0.4917 | 0.3 | 0.8235 | 0.58 | 0.3 |
| 3 | post-see | 24 | 0.3427 | 0.35 | 0.35 | 0.35 | 0.0632 | 0.35 | 0.35 | 0.8745 | 0.5895 | 0.35 |
| 4 | pre-tt1 | 24 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0.55 | 0.3 |
| 4 | post-tt1 | 24 | 0.2976 | 0.3 | 0.3 | 0.3 | 0.0931 | 0.45 | 0.3 | 0.7786 | 0.5366 | 0.3 |
| 4 | post-tt2 | 24 | 0.2969 | 0.3 | 0.3 | 0.3 | 0.0847 | 0.4417 | 0.3 | 0.8445 | 0.5911 | 0.3 |
| 4 | post-assignments | 24 | 0.2972 | 0.3 | 0.3 | 0.3 | 0.0868 | 0.425 | 0.3 | 0.8454 | 0.5957 | 0.3 |
| 4 | post-see | 24 | 0.3451 | 0.35 | 0.35 | 0.35 | 0.0594 | 0.3167 | 0.35 | 0.8854 | 0.6 | 0.35 |
| 5 | pre-tt1 | 24 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0.55 | 0.3 |
| 5 | post-tt1 | 24 | 0.299 | 0.3 | 0.3 | 0.3 | 0.0903 | 0.4667 | 0.3 | 0.8066 | 0.5412 | 0.3 |
| 5 | post-tt2 | 24 | 0.2976 | 0.3 | 0.3 | 0.3 | 0.0979 | 0.4583 | 0.3 | 0.8604 | 0.6231 | 0.3 |
| 5 | post-assignments | 24 | 0.2972 | 0.3 | 0.3 | 0.3 | 0.1014 | 0.45 | 0.3 | 0.8634 | 0.6339 | 0.3 |
| 5 | post-see | 24 | 0.3455 | 0.35 | 0.35 | 0.35 | 0.0604 | 0.3583 | 0.35 | 0.8882 | 0.6162 | 0.35 |
| 6 | pre-tt1 | 24 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0.55 | 0.3 |
| 6 | post-tt1 | 24 | 0.2976 | 0.3 | 0.3 | 0.3 | 0.0854 | 0.45 | 0.3 | 0.8186 | 0.5907 | 0.3 |
| 6 | post-tt2 | 24 | 0.2972 | 0.3 | 0.3 | 0.3 | 0.083 | 0.4833 | 0.3 | 0.8795 | 0.6311 | 0.3 |
| 6 | post-assignments | 24 | 0.2969 | 0.3 | 0.3 | 0.3 | 0.0924 | 0.4833 | 0.3 | 0.8797 | 0.6452 | 0.3 |
| 6 | post-see | 24 | 0.3448 | 0.35 | 0.35 | 0.35 | 0.0667 | 0.3417 | 0.35 | 0.8942 | 0.6322 | 0.35 |

- Queue burden acceptance gates: {"actionableRatesWithinLimit":true,"sectionToleranceWithinLimit":true,"watchRatesWithinLimit":false,"actionableQueuePpvProxyWithinLimit":true}

### Queue Burden Diagnostic Cross-Run Union

| Semester | Stage | Unique Students | Open Queue Students | Watch Students | Open Rate | Watch Rate | PPV Proxy | Threshold | Section Max Rate |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | pre-tt1 | 120 | 0 | 0 | 0 | 0 | 0 | 0.3 | 0 |
| 1 | post-tt1 | 120 | 120 | 0 | 1 | 0 | 0.5565 | 0.3 | 1 |
| 1 | post-tt2 | 120 | 120 | 0 | 1 | 0 | 0.7122 | 0.3 | 1 |
| 1 | post-assignments | 120 | 120 | 0 | 1 | 0 | 0.731 | 0.3 | 1 |
| 1 | post-see | 120 | 120 | 0 | 1 | 0 | 0.9391 | 0.35 | 1 |
| 2 | pre-tt1 | 120 | 0 | 0 | 0 | 0 | 0 | 0.3 | 0 |
| 2 | post-tt1 | 120 | 120 | 0 | 1 | 0 | 0.864 | 0.3 | 1 |
| 2 | post-tt2 | 120 | 120 | 0 | 1 | 0 | 0.894 | 0.3 | 1 |
| 2 | post-assignments | 120 | 119 | 1 | 0.9917 | 0.0083 | 0.8917 | 0.3 | 1 |
| 2 | post-see | 120 | 120 | 0 | 1 | 0 | 0.9458 | 0.35 | 1 |
| 3 | pre-tt1 | 120 | 0 | 0 | 0 | 0 | 0 | 0.3 | 0 |
| 3 | post-tt1 | 120 | 120 | 0 | 1 | 0 | 0.9026 | 0.3 | 1 |
| 3 | post-tt2 | 120 | 120 | 0 | 1 | 0 | 0.9188 | 0.3 | 1 |
| 3 | post-assignments | 120 | 120 | 0 | 1 | 0 | 0.9196 | 0.3 | 1 |
| 3 | post-see | 120 | 120 | 0 | 1 | 0 | 0.9472 | 0.35 | 1 |
| 4 | pre-tt1 | 120 | 0 | 0 | 0 | 0 | 0 | 0.3 | 0 |
| 4 | post-tt1 | 120 | 120 | 0 | 1 | 0 | 0.9082 | 0.3 | 1 |
| 4 | post-tt2 | 120 | 120 | 0 | 1 | 0 | 0.9328 | 0.3 | 1 |
| 4 | post-assignments | 120 | 119 | 1 | 0.9917 | 0.0083 | 0.9303 | 0.3 | 1 |
| 4 | post-see | 120 | 120 | 0 | 1 | 0 | 0.9486 | 0.35 | 1 |
| 5 | pre-tt1 | 120 | 0 | 0 | 0 | 0 | 0 | 0.3 | 0 |
| 5 | post-tt1 | 120 | 120 | 0 | 1 | 0 | 0.9208 | 0.3 | 1 |
| 5 | post-tt2 | 120 | 120 | 0 | 1 | 0 | 0.9363 | 0.3 | 1 |
| 5 | post-assignments | 120 | 120 | 0 | 1 | 0 | 0.9363 | 0.3 | 1 |
| 5 | post-see | 120 | 120 | 0 | 1 | 0 | 0.9482 | 0.35 | 1 |
| 6 | pre-tt1 | 120 | 0 | 0 | 0 | 0 | 0 | 0.3 | 0 |
| 6 | post-tt1 | 120 | 120 | 0 | 1 | 0 | 0.9248 | 0.3 | 1 |
| 6 | post-tt2 | 120 | 120 | 0 | 1 | 0 | 0.9444 | 0.3 | 1 |
| 6 | post-assignments | 120 | 120 | 0 | 1 | 0 | 0.9437 | 0.3 | 1 |
| 6 | post-see | 120 | 120 | 0 | 1 | 0 | 0.9489 | 0.35 | 1 |

## Carryover Head

| Metric | Value |
| --- | --- |
| Brier lift | 0.1792 |
| AUC lift | 0.3243 |
| Calibration method | isotonic |
| Display probability allowed | true |
| Support warning | NA |

## Stage Rollups

| Semester | Stage | Projection Rows | Unique Students | High Risk Rows | High Risk Students | Medium Risk Rows | Avg Risk | Avg Lift | Open Queue Rows | Open Queue Students | Watch Students |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | pre-tt1 | 17280 | 120 | 0 | 0 | 39 | 9.2 | 0 | 0 | 0 | 0 |
| 1 | post-tt1 | 17280 | 120 | 10 | 9 | 1530 | 19.4 | 0 | 1076 | 120 | 0 |
| 1 | post-tt2 | 17280 | 120 | 246 | 76 | 3157 | 23.5 | 1.3 | 1243 | 120 | 0 |
| 1 | post-assignments | 17280 | 120 | 315 | 82 | 3322 | 24 | 1.4 | 1319 | 120 | 0 |
| 1 | post-see | 17280 | 120 | 5751 | 120 | 7099 | 54.8 | 7.5 | 2685 | 120 | 0 |
| 2 | pre-tt1 | 17280 | 120 | 38 | 23 | 6732 | 30.7 | 0 | 0 | 0 | 0 |
| 2 | post-tt1 | 17280 | 120 | 1487 | 109 | 9725 | 41.6 | 0 | 3718 | 120 | 0 |
| 2 | post-tt2 | 17280 | 120 | 2935 | 120 | 8134 | 45.6 | 7.2 | 2073 | 120 | 0 |
| 2 | post-assignments | 17280 | 120 | 3110 | 120 | 8048 | 46.1 | 7.1 | 2061 | 119 | 1 |
| 2 | post-see | 17280 | 120 | 7117 | 120 | 6577 | 59.7 | 7.3 | 2491 | 120 | 0 |
| 3 | pre-tt1 | 17280 | 120 | 53 | 28 | 9234 | 34.7 | 0 | 0 | 0 | 0 |
| 3 | post-tt1 | 17280 | 120 | 2403 | 119 | 10048 | 46.5 | 0 | 4335 | 120 | 0 |
| 3 | post-tt2 | 17280 | 120 | 4273 | 120 | 8114 | 51.2 | 7.6 | 2385 | 120 | 0 |
| 3 | post-assignments | 17280 | 120 | 4470 | 120 | 7978 | 51.7 | 7.4 | 2344 | 120 | 0 |
| 3 | post-see | 17280 | 120 | 8275 | 120 | 6056 | 63.9 | 6.8 | 2594 | 120 | 0 |
| 4 | pre-tt1 | 17280 | 120 | 61 | 38 | 10781 | 37.3 | 0 | 0 | 0 | 0 |
| 4 | post-tt1 | 17280 | 120 | 2968 | 120 | 10252 | 49.7 | 0 | 4648 | 120 | 0 |
| 4 | post-tt2 | 17280 | 120 | 4996 | 120 | 8135 | 54.4 | 7.9 | 2817 | 120 | 0 |
| 4 | post-assignments | 17280 | 120 | 5220 | 120 | 7974 | 54.9 | 7.7 | 2758 | 119 | 1 |
| 4 | post-see | 17280 | 120 | 9076 | 120 | 5653 | 66.7 | 6.5 | 2569 | 120 | 0 |
| 5 | pre-tt1 | 17280 | 120 | 77 | 39 | 11848 | 39.1 | 0 | 0 | 0 | 0 |
| 5 | post-tt1 | 17280 | 120 | 3626 | 120 | 10389 | 52.6 | 0 | 4890 | 120 | 0 |
| 5 | post-tt2 | 17280 | 120 | 5833 | 120 | 8113 | 57.8 | 8.1 | 2791 | 120 | 0 |
| 5 | post-assignments | 17280 | 120 | 6054 | 120 | 7926 | 58.3 | 7.9 | 2710 | 120 | 0 |
| 5 | post-see | 17280 | 120 | 10069 | 120 | 5190 | 70.3 | 6 | 2517 | 120 | 0 |
| 6 | pre-tt1 | 17280 | 120 | 89 | 47 | 12935 | 40.9 | 0 | 0 | 0 | 0 |
| 6 | post-tt1 | 17280 | 120 | 4158 | 120 | 10487 | 55.1 | 0 | 4968 | 120 | 0 |
| 6 | post-tt2 | 17280 | 120 | 7150 | 120 | 7645 | 62.7 | 8.4 | 2738 | 120 | 0 |
| 6 | post-assignments | 17280 | 120 | 7378 | 120 | 7449 | 63.2 | 8.2 | 2686 | 120 | 0 |
| 6 | post-see | 17280 | 120 | 10957 | 120 | 4708 | 73.8 | 5.5 | 2485 | 120 | 0 |

