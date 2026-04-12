import { createElement } from 'react'
import { renderToStaticMarkup } from 'react-dom/server'
import { describe, expect, it } from 'vitest'
import { AcademicProofSummaryStrip } from '../src/academic-proof-summary-strip'

describe('AcademicProofSummaryStrip', () => {
  it('renders proof-semester wording and model usefulness guidance for proof scopes', () => {
    const markup = renderToStaticMarkup(createElement(AcademicProofSummaryStrip, {
      profile: {
        proofOperations: {
          scopeDescriptor: {
            scopeType: 'proof',
            scopeId: 'checkpoint_001',
            label: '2023 Mathematics and Computing',
            batchId: 'batch_mnc_2023',
            sectionCode: null,
            branchName: 'B.Tech Mathematics and Computing',
            simulationRunId: 'run_001',
            simulationStageCheckpointId: 'checkpoint_001',
            studentId: null,
          },
          resolvedFrom: {
            kind: 'proof-checkpoint',
            scopeType: 'proof',
            scopeId: 'checkpoint_001',
            label: 'Semester Close · Proof Run 1',
          },
          scopeMode: 'proof',
          countSource: 'proof-checkpoint',
          activeOperationalSemester: 6,
          activeRunContexts: [
            {
              batchId: 'batch_mnc_2023',
              simulationRunId: 'run_001',
              runLabel: 'Proof Run 1',
              batchLabel: '2023 Mathematics and Computing',
              branchName: 'B.Tech Mathematics and Computing',
              status: 'active',
              seed: 42,
              createdAt: '2026-03-16T00:00:00.000Z',
            },
          ],
          selectedCheckpoint: {
            simulationStageCheckpointId: 'checkpoint_001',
            simulationRunId: 'run_001',
            semesterNumber: 6,
            stageKey: 'semester-close',
            stageLabel: 'Semester Close',
            stageDescription: 'Final checkpoint.',
            stageOrder: 6,
            previousCheckpointId: 'checkpoint_000',
            nextCheckpointId: null,
            highRiskCount: 8,
            openQueueCount: 13,
          },
          monitoringQueue: [
            { studentId: 'student_001', riskBand: 'High' },
            { studentId: 'student_002', riskBand: 'High' },
          ],
          electiveFits: [
            { studentId: 'student_001' },
          ],
        },
      } as any,
      surfaceId: 'faculty-profile',
      surfaceLabel: 'Faculty Profile',
    }))

    expect(markup).toContain('data-proof-surface="academic-proof-summary"')
    expect(markup).toContain('data-proof-summary-mode="proof"')
    expect(markup).toContain('Proof Semester')
    expect(markup).toContain('Model usefulness')
    expect(markup).toContain('policy-derived status, no-action comparator, and simulated intervention / realized path')
  })
})
