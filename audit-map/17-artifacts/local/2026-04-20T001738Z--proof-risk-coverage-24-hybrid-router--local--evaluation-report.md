# Proof Risk Model Evaluation

Generated at: 2026-04-20T00:17:33.167Z

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
- Active run used for UI parity: simulation_run_45db0abd-f249-4b4e-93d2-4b86709ba382
- Duplicate governed runs skipped: 1
- Scenario-mismatch governed runs skipped: 0
- Non-manifest runs skipped: 0
- Stage definitions per semester: 5
- Complete requested runs: 24
- Incomplete requested runs: 1

| Seed | Run ID | Semester Span | Checkpoints (actual/expected) | Stage Evidence Rows | Complete |
| --- | --- | --- | --- | --- | --- |
| 101 | sim_mnc_2023_first6_v1 | 1-6 | 0/30 | 0 | false |
| 101 | simulation_run_7bbf3188-3cae-433b-a7c5-4f57b4762e38 | 1-6 | 30/30 | 21600 | true |
| 202 | simulation_run_80832405-1135-48fe-ad94-877b6b43920c | 1-6 | 30/30 | 21600 | true |
| 303 | simulation_run_d3979907-3570-4f23-850f-f4682bbfb0ad | 1-6 | 30/30 | 21600 | true |
| 404 | simulation_run_a196bdbf-51a9-4000-ba21-e222f38423b0 | 1-6 | 30/30 | 21600 | true |
| 505 | simulation_run_8656d3ce-510f-4c4c-8116-1fec3b8c9622 | 1-6 | 30/30 | 21600 | true |
| 606 | simulation_run_d30c032f-066e-456f-a920-cd88d918cbbf | 1-6 | 30/30 | 21600 | true |
| 707 | simulation_run_6fe75f75-e4db-480a-9996-4a4863668c56 | 1-6 | 30/30 | 21600 | true |
| 808 | simulation_run_892da0ea-f425-4f01-be2b-06914cd25f5a | 1-6 | 30/30 | 21600 | true |
| 4141 | simulation_run_97ba9a8a-d869-4551-b7f4-4f27e204629d | 1-6 | 30/30 | 21600 | true |
| 4242 | simulation_run_7760ac8d-fe5f-4cad-b856-c702840ae689 | 1-6 | 30/30 | 21600 | true |
| 4343 | simulation_run_416e1ff1-2755-42d9-a5ee-4f6be35572ca | 1-6 | 30/30 | 21600 | true |
| 4444 | simulation_run_c13c0287-c5d5-470c-8adf-6a24b22baa5a | 1-6 | 30/30 | 21600 | true |
| 4545 | simulation_run_3d46c713-9ab3-456c-89c0-dff0468e87c1 | 1-6 | 30/30 | 21600 | true |
| 4646 | simulation_run_16626987-7159-48db-9f52-7ca43f009525 | 1-6 | 30/30 | 21600 | true |
| 4747 | simulation_run_c9c29ea2-904c-415c-adfd-8684a5c5391f | 1-6 | 30/30 | 21600 | true |
| 4848 | simulation_run_d3dc6c4f-c431-48a8-90be-f4181960db7f | 1-6 | 30/30 | 21600 | true |
| 5757 | simulation_run_90a72025-6825-4225-8d11-cc15ae75d06e | 1-6 | 30/30 | 21600 | true |
| 5858 | simulation_run_d3c7c4de-d0f6-4901-af14-d2d3d85597bd | 1-6 | 30/30 | 21600 | true |
| 5959 | simulation_run_946a1b45-8f8e-4b70-a947-8b0a437a6651 | 1-6 | 30/30 | 21600 | true |
| 6060 | simulation_run_e3c92492-014f-43ea-b985-1cbabd303b65 | 1-6 | 30/30 | 21600 | true |
| 6161 | simulation_run_027d1be5-d140-433e-8327-9a8ffa5ec9eb | 1-6 | 30/30 | 21600 | true |
| 6262 | simulation_run_38e2bd86-f66f-46b0-b1cb-4cdb4dd01cfc | 1-6 | 30/30 | 21600 | true |
| 6363 | simulation_run_27ec6c2a-aefa-4147-aabc-56d3de068a74 | 1-6 | 30/30 | 21600 | true |
| 6464 | simulation_run_45db0abd-f249-4b4e-93d2-4b86709ba382 | 1-6 | 30/30 | 21600 | true |

## Overall Course Runtime Risk

| Scorer | Brier | Log Loss | ROC-AUC | PR-AUC | ECE | Slope | Intercept | Positive Rate | Support |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| model | 0.1361 | 0.4211 | 0.7887 | 0.4866 | 0.0065 | 1.0041 | 0.005 | 0.211 | 172800 |
| heuristic | 0.2344 | 0.6914 | 0.751 | 0.4483 | 0.2793 | 0.6061 | -0.8375 | 0.211 | 172800 |

- Overall-course runtime Brier lift: 0.0983
- Overall-course runtime AUC lift: 0.0377

## Head Metrics

| Head | Model Brier | Heuristic Brier | Brier Lift | Model Log Loss | Heuristic Log Loss | Model ROC-AUC | Heuristic ROC-AUC | AUC Lift | Model PR-AUC | Heuristic PR-AUC | Model ECE | Heuristic ECE |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| attendanceRisk | 0.0522 | 0.2623 | 0.2101 | 0.1821 | 0.7779 | 0.9238 | 0.7742 | 0.1496 | 0.6686 | 0.2493 | 0.0057 | 0.3877 |
| ceRisk | 0.0309 | 0.2866 | 0.2557 | 0.1197 | 0.8435 | 0.8586 | 0.8138 | 0.0448 | 0.2154 | 0.1527 | 0.0012 | 0.4546 |
| seeRisk | 0.1378 | 0.2524 | 0.1146 | 0.4305 | 0.744 | 0.7479 | 0.7046 | 0.0433 | 0.3966 | 0.3552 | 0.0061 | 0.2948 |
| overallCourseRisk | 0.1361 | 0.2344 | 0.0983 | 0.4211 | 0.6914 | 0.7887 | 0.751 | 0.0377 | 0.4866 | 0.4483 | 0.0065 | 0.2793 |
| downstreamCarryoverRisk | 0.0949 | 0.2741 | 0.1792 | 0.2849 | 0.8026 | 0.9325 | 0.6082 | 0.3243 | 0.8319 | 0.3561 | 0.0039 | 0.2047 |

## Variant Comparison

| Variant | Brier | Log Loss | ROC-AUC | PR-AUC | ECE |
| --- | --- | --- | --- | --- | --- |
| current-v6 | 0.1361 | 0.4211 | 0.7887 | 0.4866 | 0.0065 |
| baseline-v5-like | 0.1368 | 0.4246 | 0.7846 | 0.4831 | 0.0066 |
| hybrid-router | 0.1336 | 0.4201 | 0.7846 | 0.5118 | 0.01 |
| challenger | 0.1358 | 0.4333 | 0.739 | 0.4844 | 0.0022 |
| heuristic | 0.2344 | 0.6914 | 0.751 | 0.4483 | 0.2793 |

| Head | Fallback Alpha | Stage Routes |
| --- | --- | --- |
| attendanceRisk | 0 | post-tt1:0, post-see:1, post-tt2:0, pre-tt1:0, post-assignments:0 |
| ceRisk | 1 | post-tt1:0, post-see:0, post-tt2:1, pre-tt1:1, post-assignments:1 |
| seeRisk | 1 | post-tt1:1, post-see:1, post-tt2:0, pre-tt1:1, post-assignments:0 |
| overallCourseRisk | 1 | post-tt1:1, post-see:1, post-tt2:0, pre-tt1:1, post-assignments:0 |
| downstreamCarryoverRisk | 0 | post-tt1:0, post-see:0, post-tt2:0, pre-tt1:0, post-assignments:0 |

| Head | Baseline ROC-AUC | Current ROC-AUC | Hybrid ROC-AUC | Challenger ROC-AUC | Current-Baseline Brier Lift | Current-Hybrid Brier Lift | Hybrid-Challenger Brier Lift |
| --- | --- | --- | --- | --- | --- | --- | --- |
| attendanceRisk | 0.9197 | 0.9238 | 0.9394 | 0.9253 | 0.001 | -0.0116 | 0.001 |
| ceRisk | 0.85 | 0.8586 | 0.8822 | 0.8389 | 0.0002 | -0.0016 | -0.0003 |
| seeRisk | 0.7437 | 0.7479 | 0.7498 | 0.7252 | 0.0005 | -0.0016 | 0.002 |
| overallCourseRisk | 0.7846 | 0.7887 | 0.7846 | 0.739 | 0.0007 | -0.0025 | 0.0022 |
| downstreamCarryoverRisk | 0.9325 | 0.9325 | 0.9186 | 0.9209 | 0.0001 | 0.0018 | 0 |

## Action Rollups

| Action | Cases | Immediate Benefit (scaled points) | Next-Checkpoint Lift (Lower is Better) | Recovery Rate |
| --- | --- | --- | --- | --- |
| pre-see-rescue | 10278 | 8 | -6 | 0.0996 |
| targeted-tutoring | 9899 | 7.2 | -10.2 | 0.0455 |
| prerequisite-bridge | 4409 | 11.6 | -8.9 | 0.041 |
| attendance-recovery-follow-up | 3991 | 3.8 | -7.1 | 0.1085 |

## Policy Diagnostics

| Phenotype | Support | Avg Lift | Avg Regret | Beats No Action | Teacher Efficacy Allowed |
| --- | --- | --- | --- | --- | --- |
| late-semester-acute | 103145 | 1.04 | 0 | true | true |
| persistent-nonresponse | 10473 | 12.13 | 0 | true | true |
| prerequisite-dominant | 111278 | 6.83 | 0 | true | true |
| academic-weakness | 55864 | 10.34 | 0 | true | true |
| attendance-dominant | 18117 | 4.37 | 0 | true | true |
| diffuse-amber | 44582 | 9.38 | 0 | true | true |

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
| 1 | post-tt1 | 24 | 0.208 | 0.2083 | 0.2583 | 0.2917 | 0.0128 | 0.0833 | 0.3 | 0.4683 | 0.4316 | 0.3 |
| 1 | post-tt2 | 24 | 0.2556 | 0.2667 | 0.3 | 0.3 | 0.0427 | 0.2 | 0.3 | 0.6008 | 0.5614 | 0.3 |
| 1 | post-assignments | 24 | 0.2608 | 0.275 | 0.3 | 0.3 | 0.0469 | 0.2333 | 0.3 | 0.6131 | 0.5708 | 0.3 |
| 1 | post-see | 24 | 0.3354 | 0.35 | 0.35 | 0.35 | 0.0587 | 0.325 | 0.35 | 0.863 | 0.8419 | 0.35 |
| 2 | pre-tt1 | 24 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0.55 | 0.3 |
| 2 | post-tt1 | 24 | 0.2899 | 0.3 | 0.3 | 0.3 | 0.0858 | 0.45 | 0.3 | 0.7103 | 0.4514 | 0.3 |
| 2 | post-tt2 | 24 | 0.2896 | 0.3 | 0.3 | 0.3 | 0.0743 | 0.4333 | 0.3 | 0.7812 | 0.5233 | 0.3 |
| 2 | post-assignments | 24 | 0.2896 | 0.3 | 0.3 | 0.3 | 0.0819 | 0.45 | 0.3 | 0.7811 | 0.5317 | 0.3 |
| 2 | post-see | 24 | 0.3382 | 0.35 | 0.35 | 0.35 | 0.0566 | 0.3083 | 0.35 | 0.8638 | 0.5663 | 0.35 |
| 3 | pre-tt1 | 24 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0.55 | 0.3 |
| 3 | post-tt1 | 24 | 0.2941 | 0.3 | 0.3 | 0.3 | 0.0917 | 0.4667 | 0.3 | 0.7596 | 0.5295 | 0.3 |
| 3 | post-tt2 | 24 | 0.2941 | 0.3 | 0.3 | 0.3 | 0.1035 | 0.5083 | 0.3 | 0.8231 | 0.5853 | 0.3 |
| 3 | post-assignments | 24 | 0.2941 | 0.3 | 0.3 | 0.3 | 0.108 | 0.5083 | 0.3 | 0.8239 | 0.6005 | 0.3 |
| 3 | post-see | 24 | 0.3424 | 0.35 | 0.35 | 0.35 | 0.0604 | 0.3333 | 0.35 | 0.8743 | 0.558 | 0.35 |
| 4 | pre-tt1 | 24 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0.55 | 0.3 |
| 4 | post-tt1 | 24 | 0.2976 | 0.3 | 0.3 | 0.3 | 0.092 | 0.4417 | 0.3 | 0.7789 | 0.5407 | 0.3 |
| 4 | post-tt2 | 24 | 0.2965 | 0.3 | 0.3 | 0.3 | 0.0826 | 0.4417 | 0.3 | 0.8458 | 0.6031 | 0.3 |
| 4 | post-assignments | 24 | 0.2969 | 0.3 | 0.3 | 0.3 | 0.0965 | 0.4417 | 0.3 | 0.8462 | 0.5922 | 0.3 |
| 4 | post-see | 24 | 0.3455 | 0.35 | 0.35 | 0.35 | 0.0628 | 0.3167 | 0.35 | 0.8862 | 0.6086 | 0.35 |
| 5 | pre-tt1 | 24 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0.55 | 0.3 |
| 5 | post-tt1 | 24 | 0.2986 | 0.3 | 0.3 | 0.3 | 0.0851 | 0.4667 | 0.3 | 0.8081 | 0.5475 | 0.3 |
| 5 | post-tt2 | 24 | 0.2976 | 0.3 | 0.3 | 0.3 | 0.1014 | 0.4583 | 0.3 | 0.8603 | 0.6279 | 0.3 |
| 5 | post-assignments | 24 | 0.2969 | 0.3 | 0.3 | 0.3 | 0.1035 | 0.4667 | 0.3 | 0.8626 | 0.6367 | 0.3 |
| 5 | post-see | 24 | 0.3448 | 0.35 | 0.35 | 0.35 | 0.059 | 0.3583 | 0.35 | 0.8905 | 0.6467 | 0.35 |
| 6 | pre-tt1 | 24 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0.55 | 0.3 |
| 6 | post-tt1 | 24 | 0.2972 | 0.3 | 0.3 | 0.3 | 0.0833 | 0.4583 | 0.3 | 0.818 | 0.5964 | 0.3 |
| 6 | post-tt2 | 24 | 0.2969 | 0.3 | 0.3 | 0.3 | 0.0799 | 0.4833 | 0.3 | 0.8791 | 0.6319 | 0.3 |
| 6 | post-assignments | 24 | 0.2972 | 0.3 | 0.3 | 0.3 | 0.0889 | 0.4833 | 0.3 | 0.8794 | 0.6454 | 0.3 |
| 6 | post-see | 24 | 0.3462 | 0.35 | 0.35 | 0.35 | 0.0667 | 0.3333 | 0.35 | 0.8961 | 0.639 | 0.35 |

- Queue burden acceptance gates: {"actionableRatesWithinLimit":true,"sectionToleranceWithinLimit":true,"watchRatesWithinLimit":false,"actionableQueuePpvProxyWithinLimit":true}

### Queue Burden Diagnostic Cross-Run Union

| Semester | Stage | Unique Students | Open Queue Students | Watch Students | Open Rate | Watch Rate | PPV Proxy | Threshold | Section Max Rate |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | pre-tt1 | 120 | 0 | 0 | 0 | 0 | 0 | 0.3 | 0 |
| 1 | post-tt1 | 120 | 119 | 0 | 0.9917 | 0 | 0.5534 | 0.3 | 1 |
| 1 | post-tt2 | 120 | 120 | 0 | 1 | 0 | 0.7108 | 0.3 | 1 |
| 1 | post-assignments | 120 | 120 | 0 | 1 | 0 | 0.7292 | 0.3 | 1 |
| 1 | post-see | 120 | 120 | 0 | 1 | 0 | 0.9389 | 0.35 | 1 |
| 2 | pre-tt1 | 120 | 0 | 0 | 0 | 0 | 0 | 0.3 | 0 |
| 2 | post-tt1 | 120 | 120 | 0 | 1 | 0 | 0.8636 | 0.3 | 1 |
| 2 | post-tt2 | 120 | 120 | 0 | 1 | 0 | 0.8919 | 0.3 | 1 |
| 2 | post-assignments | 120 | 120 | 0 | 1 | 0 | 0.889 | 0.3 | 1 |
| 2 | post-see | 120 | 120 | 0 | 1 | 0 | 0.9473 | 0.35 | 1 |
| 3 | pre-tt1 | 120 | 0 | 0 | 0 | 0 | 0 | 0.3 | 0 |
| 3 | post-tt1 | 120 | 120 | 0 | 1 | 0 | 0.9018 | 0.3 | 1 |
| 3 | post-tt2 | 120 | 120 | 0 | 1 | 0 | 0.9201 | 0.3 | 1 |
| 3 | post-assignments | 120 | 120 | 0 | 1 | 0 | 0.9204 | 0.3 | 1 |
| 3 | post-see | 120 | 120 | 0 | 1 | 0 | 0.9474 | 0.35 | 1 |
| 4 | pre-tt1 | 120 | 0 | 0 | 0 | 0 | 0 | 0.3 | 0 |
| 4 | post-tt1 | 120 | 120 | 0 | 1 | 0 | 0.9087 | 0.3 | 1 |
| 4 | post-tt2 | 120 | 120 | 0 | 1 | 0 | 0.9325 | 0.3 | 1 |
| 4 | post-assignments | 120 | 119 | 1 | 0.9917 | 0.0083 | 0.9293 | 0.3 | 1 |
| 4 | post-see | 120 | 120 | 0 | 1 | 0 | 0.9483 | 0.35 | 1 |
| 5 | pre-tt1 | 120 | 0 | 0 | 0 | 0 | 0 | 0.3 | 0 |
| 5 | post-tt1 | 120 | 120 | 0 | 1 | 0 | 0.9211 | 0.3 | 1 |
| 5 | post-tt2 | 120 | 120 | 0 | 1 | 0 | 0.9371 | 0.3 | 1 |
| 5 | post-assignments | 120 | 120 | 0 | 1 | 0 | 0.9374 | 0.3 | 1 |
| 5 | post-see | 120 | 120 | 0 | 1 | 0 | 0.9483 | 0.35 | 1 |
| 6 | pre-tt1 | 120 | 0 | 0 | 0 | 0 | 0 | 0.3 | 0 |
| 6 | post-tt1 | 120 | 120 | 0 | 1 | 0 | 0.9243 | 0.3 | 1 |
| 6 | post-tt2 | 120 | 120 | 0 | 1 | 0 | 0.9437 | 0.3 | 1 |
| 6 | post-assignments | 120 | 120 | 0 | 1 | 0 | 0.9438 | 0.3 | 1 |
| 6 | post-see | 120 | 120 | 0 | 1 | 0 | 0.9486 | 0.35 | 1 |

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
| 1 | post-tt1 | 17280 | 120 | 11 | 10 | 1529 | 19.4 | 0 | 1068 | 119 | 0 |
| 1 | post-tt2 | 17280 | 120 | 241 | 75 | 3181 | 23.5 | 1.3 | 1254 | 120 | 0 |
| 1 | post-assignments | 17280 | 120 | 312 | 84 | 3341 | 24 | 1.4 | 1310 | 120 | 0 |
| 1 | post-see | 17280 | 120 | 5746 | 120 | 7110 | 54.8 | 7.5 | 2684 | 120 | 0 |
| 2 | pre-tt1 | 17280 | 120 | 38 | 23 | 6732 | 30.7 | 0 | 0 | 0 | 0 |
| 2 | post-tt1 | 17280 | 120 | 1488 | 107 | 9707 | 41.6 | 0 | 3710 | 120 | 0 |
| 2 | post-tt2 | 17280 | 120 | 2927 | 120 | 8136 | 45.6 | 7.2 | 2071 | 120 | 0 |
| 2 | post-assignments | 17280 | 120 | 3101 | 120 | 8052 | 46.1 | 7.1 | 2064 | 120 | 0 |
| 2 | post-see | 17280 | 120 | 7131 | 120 | 6561 | 59.7 | 7.3 | 2491 | 120 | 0 |
| 3 | pre-tt1 | 17280 | 120 | 53 | 28 | 9234 | 34.7 | 0 | 0 | 0 | 0 |
| 3 | post-tt1 | 17280 | 120 | 2394 | 119 | 10057 | 46.5 | 0 | 4338 | 120 | 0 |
| 3 | post-tt2 | 17280 | 120 | 4249 | 120 | 8117 | 51.1 | 7.6 | 2381 | 120 | 0 |
| 3 | post-assignments | 17280 | 120 | 4450 | 120 | 7978 | 51.7 | 7.5 | 2337 | 120 | 0 |
| 3 | post-see | 17280 | 120 | 8262 | 120 | 6065 | 63.9 | 6.9 | 2585 | 120 | 0 |
| 4 | pre-tt1 | 17280 | 120 | 61 | 38 | 10782 | 37.3 | 0 | 0 | 0 | 0 |
| 4 | post-tt1 | 17280 | 120 | 2982 | 120 | 10259 | 49.7 | 0 | 4647 | 120 | 0 |
| 4 | post-tt2 | 17280 | 120 | 4985 | 120 | 8144 | 54.4 | 7.9 | 2841 | 120 | 0 |
| 4 | post-assignments | 17280 | 120 | 5209 | 120 | 7983 | 54.9 | 7.8 | 2760 | 119 | 1 |
| 4 | post-see | 17280 | 120 | 9061 | 120 | 5658 | 66.7 | 6.5 | 2602 | 120 | 0 |
| 5 | pre-tt1 | 17280 | 120 | 77 | 39 | 11850 | 39.1 | 0 | 0 | 0 | 0 |
| 5 | post-tt1 | 17280 | 120 | 3619 | 120 | 10389 | 52.6 | 0 | 4884 | 120 | 0 |
| 5 | post-tt2 | 17280 | 120 | 5821 | 120 | 8136 | 57.8 | 8.1 | 2810 | 120 | 0 |
| 5 | post-assignments | 17280 | 120 | 6049 | 120 | 7941 | 58.3 | 7.9 | 2721 | 120 | 0 |
| 5 | post-see | 17280 | 120 | 10077 | 120 | 5191 | 70.4 | 6 | 2534 | 120 | 0 |
| 6 | pre-tt1 | 17280 | 120 | 89 | 47 | 12939 | 40.9 | 0 | 0 | 0 | 0 |
| 6 | post-tt1 | 17280 | 120 | 4155 | 120 | 10476 | 55.1 | 0 | 4957 | 120 | 0 |
| 6 | post-tt2 | 17280 | 120 | 7157 | 120 | 7634 | 62.7 | 8.4 | 2727 | 120 | 0 |
| 6 | post-assignments | 17280 | 120 | 7394 | 120 | 7430 | 63.2 | 8.2 | 2697 | 120 | 0 |
| 6 | post-see | 17280 | 120 | 10973 | 120 | 4696 | 73.8 | 5.5 | 2497 | 120 | 0 |

