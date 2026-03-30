import type { ApiAcademicFacultyProfile } from './api/types'
import { T, mono, sora } from './data'
import { describeProofAvailability, describeProofProvenance } from './proof-provenance'
import { InfoBanner } from './system-admin-ui'
import { Card, Chip } from './ui-primitives'

type AcademicProofSummaryStripProps = {
  profile: ApiAcademicFacultyProfile | null
  surfaceId: string
  surfaceLabel: string
}

function toMetricId(label: string) {
  return label.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '')
}

function SummaryMetric({ label, value }: { label: string; value: string }) {
  const metricId = toMetricId(label)
  return (
    <div
      data-proof-summary-metric={metricId}
      style={{ padding: '10px 12px', borderRadius: 10, background: T.surface2, display: 'grid', gap: 4 }}
    >
      <div style={{ ...mono, fontSize: 9, color: T.muted, textTransform: 'uppercase', letterSpacing: '0.08em' }}>{label}</div>
      <div data-proof-summary-value={metricId} style={{ ...sora, fontSize: 17, fontWeight: 700, color: T.text }}>{value}</div>
    </div>
  )
}

export function AcademicProofSummaryStrip({
  profile,
  surfaceId,
  surfaceLabel,
}: AcademicProofSummaryStripProps) {
  const proofOps = profile?.proofOperations ?? null
  if (!profile || !proofOps) return null

  const selectedCheckpoint = proofOps.selectedCheckpoint
  const highWatchCount = selectedCheckpoint?.highRiskCount ?? proofOps.monitoringQueue.filter(item => item.riskBand === 'High').length
  const openQueueCount = selectedCheckpoint?.openQueueCount ?? proofOps.monitoringQueue.length

  return (
    <Card
      data-proof-surface="academic-proof-summary"
      data-proof-scope={surfaceId}
      style={{ padding: 16, display: 'grid', gap: 12, marginBottom: 20 }}
    >
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', gap: 12, flexWrap: 'wrap' }}>
        <div>
          <div style={{ ...mono, fontSize: 10, color: T.accent, textTransform: 'uppercase', letterSpacing: '0.12em' }}>Proof Summary</div>
          <div style={{ ...sora, fontSize: 18, fontWeight: 700, color: T.text, marginTop: 6 }}>{surfaceLabel}</div>
        </div>
        <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
          <div data-proof-summary-scope-label={proofOps.scopeDescriptor.label}>
            <Chip color={T.accent}>{proofOps.scopeDescriptor.label}</Chip>
          </div>
          <div data-proof-summary-mode={proofOps.scopeMode}>
            <Chip color={proofOps.scopeMode === 'proof' ? T.warning : T.success}>
              {proofOps.scopeMode === 'proof' ? 'Proof mode' : 'Operational mode'}
            </Chip>
          </div>
        </div>
      </div>

      <InfoBanner message={`Authoritative ${surfaceLabel.toLowerCase()} proof context. Use these checkpoint-bound counts and scope labels when comparing teacher, mentor, and queue surfaces.`} />
      <InfoBanner tone="neutral" message={describeProofProvenance(proofOps)} />
      <InfoBanner tone="neutral" message={describeProofAvailability(proofOps)} />

      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(150px, 1fr))', gap: 10 }}>
        <SummaryMetric label="Operational Semester" value={proofOps.activeOperationalSemester ? `Semester ${proofOps.activeOperationalSemester}` : 'Unavailable'} />
        <SummaryMetric label="High Watch" value={String(highWatchCount)} />
        <SummaryMetric label="Open Queue" value={String(openQueueCount)} />
        <SummaryMetric label="Mentor Scope" value={String(profile.mentorScope.activeStudentCount)} />
        <SummaryMetric label="Requests" value={String(profile.requestSummary.openCount)} />
        <SummaryMetric label="Owned Classes" value={String(profile.currentOwnedClasses.length)} />
      </div>
    </Card>
  )
}
