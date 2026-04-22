import { useMemo, useState } from 'react'
import { ArrowLeft, GraduationCap, Shield } from 'lucide-react'
import type { ApiAcademicBootstrap } from './api/types'
import type { ThemeMode } from './domain'
import { T, mono, sora } from './data'
import { applyThemePreset, isLightTheme } from './theme'
import { Btn, Card, Chip } from './ui-primitives'

type StaticAdminTab = 'overview' | 'faculties' | 'students' | 'requests'

function flattenUniqueStudents(bootstrap: ApiAcademicBootstrap) {
  const byUsn = new Map<string, ApiAcademicBootstrap['studentsByOffering'][string][number]>()
  Object.values(bootstrap.studentsByOffering).forEach(students => {
    students.forEach(student => {
      if (!byUsn.has(student.usn)) byUsn.set(student.usn, student)
    })
  })
  return Array.from(byUsn.values())
}

function getRiskColor(probability: number | null) {
  if (probability === null) return T.muted
  if (probability >= 0.7) return T.danger
  if (probability >= 0.35) return T.warning
  return T.success
}

export function StaticDemoAdminApp({
  academicBootstrap,
  onExitPortal,
  onOpenAcademic,
}: {
  academicBootstrap: ApiAcademicBootstrap
  onExitPortal: () => void
  onOpenAcademic: () => void
}) {
  const [themeMode, setThemeMode] = useState<ThemeMode>('frosted-focus-light')
  const [tab, setTab] = useState<StaticAdminTab>('overview')
  const [search, setSearch] = useState('')

  applyThemePreset(themeMode)

  const students = useMemo(() => flattenUniqueStudents(academicBootstrap), [academicBootstrap])
  const faculty = academicBootstrap.faculty
  const offerings = academicBootstrap.offerings
  const tasks = academicBootstrap.runtime.tasks

  const highRiskStudents = students.filter(student => (student.riskProb ?? 0) >= 0.7)
  const mediumRiskStudents = students.filter(student => (student.riskProb ?? 0) >= 0.35 && (student.riskProb ?? 0) < 0.7)

  const normalizedSearch = search.trim().toLowerCase()

  const filteredFaculty = normalizedSearch
    ? faculty.filter(item => (
      item.name.toLowerCase().includes(normalizedSearch)
      || item.facultyId.toLowerCase().includes(normalizedSearch)
      || item.dept.toLowerCase().includes(normalizedSearch)
    ))
    : faculty

  const filteredStudents = normalizedSearch
    ? students.filter(student => (
      student.name.toLowerCase().includes(normalizedSearch)
      || student.usn.toLowerCase().includes(normalizedSearch)
    ))
    : students

  const filteredTasks = normalizedSearch
    ? tasks.filter(task => (
      task.studentName.toLowerCase().includes(normalizedSearch)
      || task.courseCode.toLowerCase().includes(normalizedSearch)
      || task.assignedTo.toLowerCase().includes(normalizedSearch)
      || task.status.toLowerCase().includes(normalizedSearch)
    ))
    : tasks

  return (
    <div style={{ minHeight: '100vh', background: `linear-gradient(180deg, ${T.bg}, ${T.surface2})`, color: T.text, padding: 20 }}>
      <div style={{ maxWidth: 1280, margin: '0 auto', display: 'grid', gap: 16 }}>
        <Card style={{ padding: 18, display: 'grid', gap: 12 }} glow={T.accent}>
          <div style={{ display: 'flex', justifyContent: 'space-between', gap: 12, flexWrap: 'wrap', alignItems: 'center' }}>
            <div style={{ display: 'grid', gap: 6 }}>
              <div style={{ ...mono, fontSize: 10, letterSpacing: '0.12em', textTransform: 'uppercase', color: T.accent }}>AirMentor System Admin</div>
              <div style={{ ...sora, fontSize: 24, fontWeight: 800, color: T.text }}>Operations Control Plane</div>
              <div style={{ ...mono, fontSize: 11, color: T.muted }}>
                Same canonical dataset as Teaching Workspace. Snapshot-safe for presentation.
              </div>
            </div>

            <div style={{ display: 'flex', alignItems: 'center', gap: 8, flexWrap: 'wrap' }}>
              <Chip color={T.success}>Snapshot Mode</Chip>
              <Btn size="sm" variant="ghost" onClick={() => setThemeMode(isLightTheme(themeMode) ? 'frosted-focus-dark' : 'frosted-focus-light')}>
                {isLightTheme(themeMode) ? 'Dark' : 'Light'}
              </Btn>
              <Btn size="sm" variant="ghost" onClick={onOpenAcademic}>
                <GraduationCap size={14} /> Teaching Workspace
              </Btn>
              <Btn size="sm" variant="ghost" onClick={onExitPortal}>
                <ArrowLeft size={14} /> Portal
              </Btn>
            </div>
          </div>

          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(180px, 1fr))', gap: 10 }}>
            <Card style={{ padding: 12, background: T.surface2 }}>
              <div style={{ ...mono, fontSize: 10, color: T.dim }}>Faculty Profiles</div>
              <div style={{ ...sora, fontSize: 24, fontWeight: 800, color: T.text }}>{faculty.length}</div>
            </Card>
            <Card style={{ padding: 12, background: T.surface2 }}>
              <div style={{ ...mono, fontSize: 10, color: T.dim }}>Course Offerings</div>
              <div style={{ ...sora, fontSize: 24, fontWeight: 800, color: T.text }}>{offerings.length}</div>
            </Card>
            <Card style={{ padding: 12, background: T.surface2 }}>
              <div style={{ ...mono, fontSize: 10, color: T.dim }}>Unique Students</div>
              <div style={{ ...sora, fontSize: 24, fontWeight: 800, color: T.text }}>{students.length}</div>
            </Card>
            <Card style={{ padding: 12, background: T.surface2 }}>
              <div style={{ ...mono, fontSize: 10, color: T.dim }}>Action Queue</div>
              <div style={{ ...sora, fontSize: 24, fontWeight: 800, color: T.text }}>{tasks.length}</div>
            </Card>
          </div>
        </Card>

        <Card style={{ padding: 14, display: 'grid', gap: 10 }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', gap: 10, flexWrap: 'wrap', alignItems: 'center' }}>
            <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
              {(['overview', 'faculties', 'students', 'requests'] as StaticAdminTab[]).map(item => (
                <button
                  key={item}
                  type="button"
                  onClick={() => setTab(item)}
                  style={{
                    ...mono,
                    fontSize: 11,
                    borderRadius: 10,
                    border: `1px solid ${tab === item ? `${T.accent}66` : T.border}`,
                    background: tab === item ? `${T.accent}18` : T.surface,
                    color: tab === item ? T.accent : T.text,
                    padding: '8px 12px',
                    cursor: 'pointer',
                  }}
                >
                  {item === 'overview' ? 'Overview' : item === 'faculties' ? 'Faculties' : item === 'students' ? 'Students' : 'Requests'}
                </button>
              ))}
            </div>

            <input
              value={search}
              onChange={event => setSearch(event.target.value)}
              placeholder="Search by name, USN, course, role..."
              style={{
                ...mono,
                fontSize: 11,
                width: 'min(420px, 100%)',
                borderRadius: 10,
                border: `1px solid ${T.border}`,
                background: T.surface2,
                color: T.text,
                padding: '9px 12px',
              }}
            />
          </div>

          {tab === 'overview' ? (
            <div style={{ display: 'grid', gap: 10 }}>
              <Card style={{ padding: 14, background: T.surface2 }}>
                <div style={{ ...sora, fontSize: 16, fontWeight: 700, color: T.text }}>Risk Distribution</div>
                <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap', marginTop: 10 }}>
                  <Chip color={T.danger}>{`High: ${highRiskStudents.length}`}</Chip>
                  <Chip color={T.warning}>{`Medium: ${mediumRiskStudents.length}`}</Chip>
                  <Chip color={T.success}>{`Low/Stable: ${Math.max(0, students.length - highRiskStudents.length - mediumRiskStudents.length)}`}</Chip>
                </div>
              </Card>

              <Card style={{ padding: 14, background: T.surface2 }}>
                <div style={{ ...sora, fontSize: 16, fontWeight: 700, color: T.text }}>Consistency Check</div>
                <div style={{ ...mono, fontSize: 11, color: T.muted, marginTop: 8, lineHeight: 1.8 }}>
                  Teaching workspace and this admin demo read the same canonical snapshot for faculty, offerings, students, queues, and mentoring assignments.
                </div>
              </Card>
            </div>
          ) : null}

          {tab === 'faculties' ? (
            <div style={{ display: 'grid', gap: 10 }}>
              {filteredFaculty.map(item => (
                <Card key={item.facultyId} style={{ padding: 12, background: T.surface2, display: 'grid', gap: 6 }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', gap: 8, alignItems: 'center', flexWrap: 'wrap' }}>
                    <div style={{ ...sora, fontSize: 14, fontWeight: 700, color: T.text }}>{item.name}</div>
                    <Chip color={T.accent}>{item.facultyId}</Chip>
                  </div>
                  <div style={{ ...mono, fontSize: 11, color: T.muted }}>
                    {`${item.dept} - ${item.roleTitle}`}
                  </div>
                  <div style={{ ...mono, fontSize: 11, color: T.dim }}>
                    {`Roles: ${item.allowedRoles.join(' / ')} | Offerings: ${item.offeringIds.length} | Mentees: ${item.menteeIds.length}`}
                  </div>
                </Card>
              ))}
              {filteredFaculty.length === 0 ? (
                <Card style={{ padding: 14, background: T.surface2 }}>
                  <div style={{ ...mono, fontSize: 11, color: T.muted }}>No faculty matched your search.</div>
                </Card>
              ) : null}
            </div>
          ) : null}

          {tab === 'students' ? (
            <div style={{ display: 'grid', gap: 10 }}>
              {filteredStudents.map(student => (
                <Card key={student.usn} style={{ padding: 12, background: T.surface2, display: 'grid', gap: 6 }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', gap: 8, alignItems: 'center', flexWrap: 'wrap' }}>
                    <div style={{ ...sora, fontSize: 14, fontWeight: 700, color: T.text }}>{student.name}</div>
                    <Chip color={getRiskColor(student.riskProb)}>
                      {student.riskProb === null ? 'No Risk' : `${Math.round(student.riskProb * 100)}% Risk`}
                    </Chip>
                  </div>
                  <div style={{ ...mono, fontSize: 11, color: T.muted }}>{student.usn}</div>
                  <div style={{ ...mono, fontSize: 11, color: T.dim }}>
                    {`CGPA: ${student.prevCgpa.toFixed(1)} | Attendance: ${student.present}/${student.totalClasses}`}
                  </div>
                </Card>
              ))}
              {filteredStudents.length === 0 ? (
                <Card style={{ padding: 14, background: T.surface2 }}>
                  <div style={{ ...mono, fontSize: 11, color: T.muted }}>No students matched your search.</div>
                </Card>
              ) : null}
            </div>
          ) : null}

          {tab === 'requests' ? (
            <div style={{ display: 'grid', gap: 10 }}>
              {filteredTasks.map(task => (
                <Card key={task.id} style={{ padding: 12, background: T.surface2, display: 'grid', gap: 6 }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', gap: 8, alignItems: 'center', flexWrap: 'wrap' }}>
                    <div style={{ ...sora, fontSize: 14, fontWeight: 700, color: T.text }}>{task.title}</div>
                    <Chip color={task.assignedTo === 'HoD' ? T.danger : task.assignedTo === 'Mentor' ? T.warning : T.accent}>
                      {task.assignedTo}
                    </Chip>
                  </div>
                  <div style={{ ...mono, fontSize: 11, color: T.muted }}>
                    {`${task.studentName} (${task.studentUsn}) - ${task.courseCode}`}
                  </div>
                  <div style={{ ...mono, fontSize: 11, color: T.dim }}>
                    {`Status: ${task.status} | Due: ${task.due} | Priority: ${task.priority}`}
                  </div>
                </Card>
              ))}
              {filteredTasks.length === 0 ? (
                <Card style={{ padding: 14, background: T.surface2 }}>
                  <div style={{ ...mono, fontSize: 11, color: T.muted }}>No queue items matched your search.</div>
                </Card>
              ) : null}
            </div>
          ) : null}
        </Card>

        <div style={{ ...mono, fontSize: 10, color: T.dim, display: 'flex', alignItems: 'center', gap: 6 }}>
          <Shield size={12} />
          Static admin demo uses same source data as teaching workspace in this build.
        </div>
      </div>
    </div>
  )
}
