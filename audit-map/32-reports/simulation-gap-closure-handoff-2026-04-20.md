# 模擬缺口閉合移交 2026-04-20

Date: 2026-04-20  
Root: `/home/raed/projects/air-mentor-ui`  
Branch: `promote-proof-dashboard-origin`  
Intent: 確定性閉合所有模擬流程缺口，使演示完整可運行。

---

## 0) 前置說明 — 已完成事項

前次移交 (`next-ai-handoff-extreme-detail-2026-04-19.md`) 之 Step A/B/C/D 均已完成：

| 步驟 | 狀態 | 說明 |
|------|------|------|
| Step A | ✅ | `settleCookieBackedSession` 完全移除。登入/切換直接信任POST回應。 |
| Step B | ✅ | `GET /api/admin/batches/:batchId/setup-readiness` 已存在，前端已接入。 |
| Step C | ✅ | Cross-surface parity contract 已完成。 |
| Step D | ✅ | Email transport hardening 已完成。 |

---

## 1) 完整驗證後之缺口清單

### P0 — 致命阻斷（不修則演示必崩）

---

**GAP-1: `offeringAssessmentSchemes` 未種入 → 所有階段推進被阻**

- 位置：`air-mentor-api/src/modules/academic.ts:1740`
- 邏輯：`if (!explicitScheme || explicitScheme.status === 'Needs Setup') → blockingReasons.push('Assessment scheme is not configured for this class')`
- 根因：`publishOperationalProjection`（`msruas-proof-control-plane.ts:3153`）寫入出勤/評估分數，但從不插入 `offeringAssessmentSchemes` 行。
- 驗證：`grep -rn "offeringAssessmentSchemes" air-mentor-api/src/lib/msruas-proof-control-plane.ts` → 無結果。
- Bootstrap 中 `buildDefaultSchemeFromPolicy` 僅作回退（`academic.ts:3998`），不持久化，`buildOfferingStageEligibility` 直接查 DB。
- **修法**：在 `publishOperationalProjection` 函數尾部（現有分數插入之後，`air-mentor-api/src/lib/msruas-proof-control-plane.ts:3353` 之後），對每個 `proofOfferingId` 插入 `offeringAssessmentSchemes` 行：
  - `schemeJson`：MSRUAS DEFAULT_POLICY 預設值（ce=60, see=40, 2 TT, 2 quiz, 2 assignment）
  - `status: 'Configured'`（非 'Needs Setup'，否則仍被阻）
  - `configuredByFacultyId: null`（系統自動配置）
  - 若已存在則跳過（upsert on conflict do nothing）
- **循環依賴警告**：`buildDefaultSchemeFromPolicy` 在 `modules/academic.ts`，該文件已 import `lib/msruas-proof-control-plane.js`。直接 import 會造成循環。解決：在 control plane 中硬編碼 MSRUAS 預設 scheme JSON 常數。
- DEFAULT_POLICY scheme 計算結果：
  ```json
  {
    "finalsMax": 50,
    "termTestWeights": { "tt1": 15, "tt2": 15 },
    "quizWeight": 15,
    "assignmentWeight": 15,
    "quizCount": 2,
    "assignmentCount": 2,
    "quizComponents": [
      { "id": "quiz-1", "label": "Quiz 1", "rawMax": 10, "weightage": 7 },
      { "id": "quiz-2", "label": "Quiz 2", "rawMax": 10, "weightage": 8 }
    ],
    "assignmentComponents": [
      { "id": "assignment-1", "label": "Assignment 1", "rawMax": 10, "weightage": 7 },
      { "id": "assignment-2", "label": "Assignment 2", "rawMax": 10, "weightage": 8 }
    ],
    "policyContext": { "ce": 60, "see": 40, "maxTermTests": 2, "maxQuizzes": 2, "maxAssignments": 2 },
    "status": "Configured"
  }
  ```
- policySnapshotJson：序列化 DEFAULT_POLICY 結構（`modules/admin-structure.ts:342`）
- 需在 schema import 加入 `offeringAssessmentSchemes`（現缺）

---

**GAP-3: 解鎖批准不清除 DB 鎖列 → 解鎖功能完全損壞**

- 根因鏈：
  1. 教師提交評分 + `lock: true` → `academic-runtime-routes.ts:1238`：`if (body.lock && lockField) nextOfferingPatch[lockField] = 1` → `sectionOfferings.tt1Locked = 1` 寫入 DB
  2. HOD 批准解鎖 → `handleResetComplete`（`src/App.tsx:3144`） → `setLockByOffering` 更新前端狀態 → `saveAcademicLockByOffering` → `PUT /api/academic/runtime/lock-by-offering` → 僅更新 `academicRuntimeState` JSON blob
  3. 教師重新提交評分 → `academic-runtime-routes.ts:1123`：`if (lockField && offering[lockField] === 1) throw forbidden('This assessment dataset is locked')` → **讀 `sectionOfferings` DB 列（非 runtime blob）→ 仍為 1 → 拒絕**
- **修法**：
  - 後端：新增路由 `POST /api/academic/offerings/:offeringId/assessment-entries/:kind/clear-lock`（`academic-runtime-routes.ts`）
    - 角色：HoD（`requireRole(request, ['HOD'])`）
    - 操作：`db.update(sectionOfferings).set({ [lockField]: 0 }).where(eq(sectionOfferings.offeringId, offeringId))`
    - 同時清除 runtime blob 中對應 key
  - API client：`src/api/client.ts` 新增 `clearOfferingAssessmentLock(offeringId, kind)`
  - 前端：`handleResetComplete`（`src/App.tsx:3144`）在 `setLockByOffering` 前先 await `repositories.locksAudit.clearRemoteLock(offeringId, unlockKind)`

---

### P1 — 重要（演示完整性）

---

**GAP-5: 教師學術登入未設防護門 — 無活躍模擬時可進入**

- 根因：學術 bootstrap 路由不檢查 `proofActiveRun` 是否存在。
- 現象：無模擬運行時，教師可登入並看到空白或錯誤的學術介面。
- **修法**：學術 bootstrap 端點（`air-mentor-api/src/modules/academic.ts` 中的 `GET /api/academic/bootstrap`）：
  - 若 `proofActiveRun = null` 且當前為 proof 批次學期 → 回傳結構化錯誤 `{ code: 'NO_ACTIVE_PROOF_RUN', message: '...' }`
  - 前端 `academic-session-shell.tsx` 攔截此錯誤碼 → 顯示「No active simulation」閘門頁面
- 注意：僅對 proof batch 學術使用者啟用此門；常規 live 教師不受影響

---

**GAP-4（舊草案殘留風險，非本輪已閉合 GAP-4 定義）: 重置不刪除教師/學生帳號 — 憑證洩漏**

- 說明：此段描述的是較早草案中的 restore/account-lifecycle 風險，與本輪 Track A 已閉合的 GAP-4（archive/activate 後 branch-scoped faculty session invalidation）不是同一件事。當前閉合的是 session invalidation；full account reaping 仍屬後續設計風險。
- 現象：重置後舊教師 session 仍有效，舊憑證仍可登入。
- **修法**：在 `restoreProofSimulationSnapshot` 調用 `startProofSimulationRun` 之前：
  1. 查詢 `simulationRuns.simulationRunId = input.simulationRunId` 的所有 proof-scoped `userAccounts`（通過 `facultyProfiles.proofSimulationRunId` 或類似欄位）
  2. 刪除其 `sessions`、`roleGrants`、`userAccounts`
  3. 若無 `proofSimulationRunId` 欄位，需先添加（migration needed）
- **複雜度**：高。需先確認 user 表結構與 sim-scoping 機制。**暫緩至 P2**，記錄為已知風險。

---

**GAP-6: Section A/B env params 非 slider 可配置**

- 根因：`teacherStrictnessIndex`、`assessmentDifficultyIndex`、`interventionCapacity` 皆由 `stableBetween(seed, min, max)` 確定性生成，範圍：
  - Section A: strictness[0.32, 0.78], difficulty[0.38, 0.84], capacity[0.34, 0.82]
  - Section B: 同範圍但不同 seed（`(courseIndex+1) % courseLeaderFaculty.length` offset）
- ML 參數硬編碼：learning rate 0.08（校準 sigmoid）、0.22（main logistic regression）；風險閾值 `medium:0.40`, `high:0.85`
- **修法**：
  - DB：`proofSimulationRuns` 加欄位 `configJson text`
  - 新 migration：`0020_proof_sim_config.sql`
  - UI：sysadmin 在 proof run 啟動前，顯示 config 表單：
    - Section A: strictness / difficulty / capacity sliders（各有 range + default）
    - Section B: 同上（獨立 sliders）
    - Scenario mix: 下拉或 radio（realistic / stressed / mixed）
    - Global: risk threshold medium / high（可選，有 default）
  - `activateProofSimulationRun` 在種入前讀取 `configJson` 並傳入 `stableBetween` bounds

---

**GAP-2: 所有分數在種入時一次性寫入 → 階段門邏輯可被繞過**

- 根因：`publishOperationalProjection`（`msruas-proof-control-plane.ts:3258-3354`）在激活學期時，將 TT1、TT2、quiz、assignment、SEE 所有分數一次性插入 `studentAssessmentScores`。
- 現象：教師在 `pre-tt1` 階段即可鎖定 TT2 分數（後端僅檢查 `offering.tt2Locked`，不檢查當前階段）。
- **修法選項**：
  - A（簡單）：提交端點（`academic-runtime-routes.ts:1086`）加階段驗證：`if (params.kind === 'tt2' && offering.stage < POST_TT1_STAGE_ORDER) throw forbidden('TT2 not yet unlocked')`
  - B（複雜）：分數按階段寫入（`pre-tt1` 只寫 attendance，`post-tt1` 寫 TT1，`post-tt2` 寫 TT2…）
  - **推薦 A**：最小改動，與現有 stage-gate 邏輯一致
- 實施：`air-mentor-api/src/modules/academic-runtime-routes.ts` 的 `PUT .../assessment-entries/:kind`，在 lock-check 之後加 stage-order 驗證。需查 `STAGE_KEY_ORDER` 映射（`stage-policy.ts`）。

---

**GAP-7: 虛擬日期未驅動任務到期顯示**

- 根因：`academicTasks.dueDateIso` 存在，但 App.tsx 中任務到期標籤（'Today', 'This week'）以 wall clock 計算。`proofActiveRun.currentDate` 未傳入任務計算。
- 現象：演示中推進虛擬日期，任務到期顯示不跟隨。
- **修法**：
  - `src/App.tsx` 中傳遞 `proofCurrentDate`（若存在）到任務到期計算函數
  - 到期標籤計算：`computeDueLabel(dueDateIso, anchorDate: proofCurrentDate ?? Date.now())`
- **複雜度**：低。`proofCurrentDate` 已在 bootstrap 中返回。

---

### P2 — 次要

**GAP-8: 出勤 totalClasses 差異（proof=32, admin scaffold=50）**

- 模擬種入：`totalClasses=32`，checkpoints: wk4=8, wk8=16, wk12=24, wk16=32
- 管理員腳手架路由（`academic-admin-offerings-routes.ts:682`）：`totalClasses=50`
- 非模擬演示路徑不觸發，不影響 demo。記錄為已知差異。

---

## 2) 已確認正常（無需修復）

| 項目 | 狀態 | 驗證位置 |
|------|------|---------|
| HOD 升級個別學生按鈕 | ✅ | `App.tsx:3065` `handleOpenStudentEscalation`，task escalated=true |
| 解鎖請求結構 | ✅ | `sharedTaskSchema.unlockRequest`，HOD approve/reject/reset 按鈕已連線 |
| Scheme 教師自訂（quizCount/assignmentCount） | ✅ | `PUT /api/academic/offerings/:offeringId/scheme`，weightage 政策強制 |
| Snapshot 還原清除所有鎖列 | ✅ | `academic-admin-offerings-routes.ts:670-674`，stage reset 設 all Locked=0 |
| 出勤種入（32 classes, 4 checkpoints） | ✅ | `msruas-proof-control-plane.ts:3269-3270` |
| 登入移除多餘 settle RTT | ✅ | `repositories.ts` `settleCookieBackedSession` 已移除 |

---

## 3) 確定性執行計劃（優先序）

### Step 1：GAP-1 — scheme 種入（msruas-proof-control-plane.ts）

```
文件：air-mentor-api/src/lib/msruas-proof-control-plane.ts
位置：publishOperationalProjection 函數，assessmentRows 插入之後（~line 3354）
操作：
  1. import offeringAssessmentSchemes from schema（加入 line 4 的 import 塊）
  2. 取 proofOfferingIds（已有）
  3. 查詢已存在 scheme 的 offering ids
  4. 對不存在者批量插入 MSRUAS 預設 scheme（schemeJson 硬編碼常數，status='Configured'）
```

### Step 2：GAP-3 後端 — clear-lock 路由（academic-runtime-routes.ts）

```
文件：air-mentor-api/src/modules/academic-runtime-routes.ts
新增路由：POST /api/academic/offerings/:offeringId/assessment-entries/:kind/clear-lock
角色：HOD
操作：
  1. 驗證 kind（tt1/tt2/quiz/assignment/attendance/finals）→ lockField
  2. db.update(sectionOfferings).set({ [lockField]: 0 })
  3. 同步清除 runtime lockByOffering blob
  4. 返回 { ok: true, offeringId, kind, cleared: true }
```

### Step 3：GAP-3 前端 — API client + repositories + App.tsx

```
文件 1：src/api/client.ts
  - 新增 clearOfferingAssessmentLock(offeringId, kind) → POST .../clear-lock

文件 2：src/repositories.ts（HTTP mode locksAudit）
  - 新增 clearRemoteLock(offeringId, kind) → calls apiClient.clearOfferingAssessmentLock

文件 3：src/App.tsx:3144 handleResetComplete
  - 在 setLockByOffering 之前 await repositories.locksAudit.clearRemoteLock(offeringId, unlockKind)
```

### Step 4：GAP-5 — 教師登入門（academic bootstrap）

```
文件：air-mentor-api/src/modules/academic.ts
位置：bootstrap 路由 handler
操作：
  - 若用戶 role 為學術教師 且 batchId 為 MSRUAS_PROOF_BATCH_ID
  - 查 proofActiveRun = pickMostRecentActiveRun(...)
  - 若 null → return 403 { code: 'NO_ACTIVE_PROOF_RUN' }

文件：src/academic-session-shell.tsx
  - 攔截 code === 'NO_ACTIVE_PROOF_RUN' → 渲染閘門頁面
```

### Step 5：GAP-2 — 提交端點加階段驗證（academic-runtime-routes.ts）

```
文件：air-mentor-api/src/modules/academic-runtime-routes.ts:1086
位置：PUT .../assessment-entries/:kind，lock-check 之後
新增：
  const stageGate: Record<string, number> = { tt1: 1, tt2: 2, quiz: 2, assignment: 3, finals: 4 }
  const requiredStageOrder = stageGate[params.kind] ?? 0
  if (offering.stage < requiredStageOrder) throw forbidden(`Cannot lock ${params.kind} at current stage`)
  (stage numbers from stage-policy.ts STAGE_DEFS)
```

### Step 6：GAP-7 — 虛擬日期驅動任務到期（App.tsx）

```
文件：src/App.tsx
位置：任務到期標籤計算
操作：取 proofCurrentDate（已在 bootstrap 回傳），傳入 computeDueLabel anchor
```

---

## 4) 已實施之修復（本次執行，2026-04-20）

| GAP | 狀態 | 實施內容 | 主要檔案 |
|---|---|---|---|
| GAP-1 | ✅ 已閉合 | proof activation 後寫入 `offeringAssessmentSchemes`，`status='Configured'`，衝突時 idempotent skip | `air-mentor-api/src/lib/msruas-proof-control-plane.ts` |
| GAP-2 | ✅ 已閉合 | `PUT .../assessment-entries/:kind` 新增 stage-order gate，阻止未開放階段鎖定未來證據 | `air-mentor-api/src/modules/academic-runtime-routes.ts` |
| GAP-3 | ✅ 已閉合 | 新增 HOD `clear-lock` 路由清除 DB 鎖列，前端 reset 流程先清遠端鎖再更新本地狀態 | `air-mentor-api/src/modules/academic-runtime-routes.ts`, `src/api/client.ts`, `src/repositories.ts`, `src/App.tsx` |
| GAP-4 | ✅ 已閉合 | `archive` / `activate` 流程新增 `invalidateProofBatchSessions`，刪除 branch-scoped faculty sessions | `air-mentor-api/src/lib/msruas-proof-control-plane.ts` |
| GAP-5 | ✅ 已閉合 | bootstrap 在無 active run 時回傳 `403 NO_ACTIVE_PROOF_RUN`，前端顯示 gate page | `air-mentor-api/src/modules/academic-bootstrap-routes.ts`, `air-mentor-api/src/modules/academic.ts`, `src/academic-session-shell.tsx` |
| GAP-7 | ✅ 已閉合 | `proofPlayback.currentDateISO` 駕動 due label anchor，proof mode 不再依賴 wall clock | `air-mentor-api/src/modules/academic.ts`, `src/domain.ts`, `src/calendar-utils.ts`, `src/App.tsx` |
| GAP-6 | 🟡 遞延 | 仍需 migration + slider UI + activation wiring，暫不阻斷 demo | 後續設計/實作 |
| GAP-8 | 🟢 低優先 | `totalClasses` 差異保留為已知，不影響 proof demo 主路徑 | `air-mentor-api/src/lib/msruas-proof-control-plane.ts`, `air-mentor-api/src/modules/academic-admin-offerings-routes.ts` |

補充：

1. intent 測試已新增：`air-mentor-api/tests/gap-closure-intent.test.ts`（10 tests）。
2. 下一步需補強 `invalidateProofBatchSessions` 的安全邊界測試（sysadmin 不刪、跨 branch 不刪、無 session graceful）。

---

## 5) 測試驗證清單

每個 GAP 修復後執行：

```bash
# 後端
cd air-mentor-api
npx vitest run tests/academic-proof-routes.test.ts tests/admin-control-plane.test.ts tests/proof-run-queue.test.ts

# 前端
npx vitest run tests/repositories-http.test.ts tests/system-admin-proof-dashboard-workspace.test.tsx

# 完整套件（改動較大時）
npx vitest run
```

整合驗證（local seeded stack）：
```bash
npm run dev:live
# 驗證：
# 1. Activate sim → 每個 offering 的 offeringAssessmentSchemes 已建立（status=Configured）
# 2. Teacher lock TT1 → HOD approve unlock → teacher 可重新提交（不再 forbidden）
# 3. 無活躍 sim 時 teacher bootstrap 返回 NO_ACTIVE_PROOF_RUN
# 4. 每個階段提交各自限制（TT2 在 pre-tt1 被阻）
```

---

## 6) 已知風險與遞延項

| 項目 | 風險 | 遞延原因 |
|------|------|---------|
| GAP-4 舊草案殘留風險：憑證生命週期 | 高：重置後舊帳號仍有效 | 與本輪已閉合 GAP-4 不同；需 migration + user scoping 設計 |
| GAP-6 slider config UI | 中：演示環境固定 env params | 需完整前端表單 + DB 遷移 |
| Circular import（scheme defaults） | 低：已用硬編碼繞過 | 未來提取至 lib/scheme-defaults.ts |

---

## 7) 指令快查

```bash
# 本地開發
npm run dev:live

# API 遷移
cd air-mentor-api && npx drizzle-kit migrate

# 後端聚焦測試
cd air-mentor-api && npx vitest run tests/academic-proof-routes.test.ts

# 前端聚焦測試
npx vitest run tests/repositories-http.test.ts

# 完整
npx vitest run && cd air-mentor-api && npx vitest run
```

---

## 8) 檔案修改清單（本次執行）

- `air-mentor-api/src/lib/msruas-proof-control-plane.ts` — scheme 種入（GAP-1）
- `air-mentor-api/src/modules/academic-runtime-routes.ts` — clear-lock 路由 + 階段門（GAP-3、GAP-2）
- `src/api/client.ts` — clearOfferingAssessmentLock（GAP-3）
- `src/repositories.ts` — clearRemoteLock（GAP-3）
- `src/App.tsx` — handleResetComplete + 虛擬日期任務（GAP-3、GAP-7）
- `air-mentor-api/src/modules/academic.ts` — bootstrap 登入門（GAP-5）
- `src/academic-session-shell.tsx` — NO_ACTIVE_PROOF_RUN 閘門（GAP-5）
