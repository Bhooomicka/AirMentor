import { createElement } from 'react'
import { renderToStaticMarkup } from 'react-dom/server'
import { describe, expect, it } from 'vitest'
import type { ApiAcademicFacultyProfile } from '../src/api/types'
import { AcademicProofSummaryStrip } from '../src/academic-proof-summary-strip'

describe('AcademicProofSummaryStrip', () => {
  it('renders checkpoint wording and plain-language proof guidance for proof scopes', () => {
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
          activeOperationalSemester: 5,
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
      } as unknown as ApiAcademicFacultyProfile,
      surfaceId: 'faculty-profile',
      surfaceLabel: 'Faculty Profile',
    }))

    expect(markup).toContain('data-proof-surface="academic-proof-summary"')
    expect(markup).toContain('data-proof-summary-mode="proof"')
    expect(markup).toContain('data-proof-launcher="floating"')
    expect(markup).toContain('data-proof-launcher-mode="popup-capable"')
    expect(markup).toContain('Selected Checkpoint')
    expect(markup).toContain('Preview data')
    expect(markup).toContain('You are viewing a saved preview checkpoint')
    expect(markup).toContain('Every number on this page is fixed to this point in time')
    expect(markup).toMatch(/data-proof-summary-value="selected-checkpoint"[^>]*>Semester 6 · Semester Close<\/div>/)
    expect(markup).not.toMatch(/data-proof-summary-value="selected-checkpoint"[^>]*>Semester 5<\/div>/)
  })

  it('shows an explicit unavailable state instead of hiding the strip when proof context is missing', () => {
    const markup = renderToStaticMarkup(createElement(AcademicProofSummaryStrip, {
      profile: null,
      surfaceId: 'mentor-view',
      surfaceLabel: 'Mentor View',
    }))

    expect(markup).toContain('Proof context unavailable')
    expect(markup).toContain('The summary stays empty instead of guessing queue counts')
  })
})
