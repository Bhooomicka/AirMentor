import {
  CO_MAP,
  FACULTY,
  MENTEES,
  OFFERINGS,
  PROFESSOR,
  SUBJECT_RUNS,
  TEACHERS,
  YEAR_GROUPS,
  getStudentHistoryRecord,
  getStudents,
  type CoAttainmentRow,
  type Offering,
  type Student,
} from './data'
import type {
  ApiAcademicBootstrap,
  ApiAcademicMeeting,
  ApiCoAttainmentRow,
  ApiCourseOutcome,
} from './api/types'
import { createAirMentorRepositories, type AirMentorRepositories } from './repositories'
import type { SharedTask } from './domain'

type DemoStorage = {
  getItem: (key: string) => string | null
  setItem: (key: string, value: string) => void
  removeItem: (key: string) => void
}

function deepClone<T>(value: T): T {
  return JSON.parse(JSON.stringify(value)) as T
}

function hashText(input: string): number {
  let hash = 0
  for (let index = 0; index < input.length; index += 1) {
    hash = ((hash << 5) - hash + input.charCodeAt(index)) | 0
  }
  return Math.abs(hash)
}

function createInMemoryStorage(): DemoStorage {
  const map = new Map<string, string>()
  return {
    getItem(key) {
      return map.has(key) ? map.get(key) ?? null : null
    },
    setItem(key, value) {
      map.set(key, value)
    },
    removeItem(key) {
      map.delete(key)
    },
  }
}

function buildStudentsByOffering(offerings: Offering[]) {
  return Object.fromEntries(
    offerings.map(offering => [offering.offId, deepClone(getStudents(offering))]),
  ) as Record<string, Student[]>
}

function buildStudentHistoryByUsn(studentsByOffering: Record<string, Student[]>, offerings: Offering[]) {
  const historyByUsn: Record<string, ReturnType<typeof getStudentHistoryRecord>> = {}

  offerings.forEach(offering => {
    const students = studentsByOffering[offering.offId] ?? []
    students.forEach(student => {
      if (historyByUsn[student.usn]) return
      historyByUsn[student.usn] = getStudentHistoryRecord({
        usn: student.usn,
        studentName: student.name,
        dept: offering.dept,
        yearLabel: offering.year,
        prevCgpa: student.prevCgpa,
      })
    })
  })

  return historyByUsn
}

function buildCourseOutcomesByOffering(offerings: Offering[]) {
  return Object.fromEntries(
    offerings.map(offering => [
      offering.offId,
      deepClone((CO_MAP[offering.code] ?? CO_MAP.default) as ApiCourseOutcome[]),
    ]),
  ) as Record<string, ApiCourseOutcome[]>
}

function buildCoAttainmentByOffering(
  offerings: Offering[],
  studentsByOffering: Record<string, Student[]>,
): Record<string, ApiCoAttainmentRow[]> {
  return Object.fromEntries(offerings.map(offering => {
    const students = studentsByOffering[offering.offId] ?? []
    const outcomes = CO_MAP[offering.code] ?? CO_MAP.default
    const rows: CoAttainmentRow[] = outcomes.map(outcome => {
      const attainmentValues = students
        .map(student => student.coScores.find(score => score.coId === outcome.id)?.attainment ?? null)
        .filter((value): value is number => value !== null)

      const tt1Average = attainmentValues.length > 0
        ? Math.round(attainmentValues.reduce((sum, value) => sum + value, 0) / attainmentValues.length)
        : null

      const tt2Average = offering.tt2Done && tt1Average !== null
        ? Math.max(0, Math.min(100, tt1Average + ((hashText(`${offering.offId}:${outcome.id}`) % 11) - 5)))
        : null

      const overall = tt1Average === null
        ? null
        : tt2Average === null
          ? tt1Average
          : Math.round((tt1Average + tt2Average) / 2)

      return {
        coId: outcome.id,
        desc: outcome.desc,
        bloom: outcome.bloom,
        target: 60,
        tt1Attainment: tt1Average,
        tt2Attainment: tt2Average,
        overallAttainment: overall,
        studentsCounted: attainmentValues.length,
      }
    })

    return [offering.offId, rows as ApiCoAttainmentRow[]]
  })) as Record<string, ApiCoAttainmentRow[]>
}

function buildSeededTasks(offerings: Offering[], studentsByOffering: Record<string, Student[]>): SharedTask[] {
  const candidates = offerings
    .flatMap(offering => (studentsByOffering[offering.offId] ?? []).map(student => ({ offering, student })))
    .filter(item => item.student.riskProb !== null && item.student.riskBand !== null)
    .sort((left, right) => (right.student.riskProb ?? 0) - (left.student.riskProb ?? 0))
    .slice(0, 10)

  return candidates.map((item, index) => {
    const owner: SharedTask['assignedTo'] = index % 3 === 0
      ? 'HoD'
      : index % 2 === 0
        ? 'Mentor'
        : 'Course Leader'

    return {
      id: `demo-task-${index + 1}`,
      studentId: item.student.id,
      studentName: item.student.name,
      studentUsn: item.student.usn,
      offeringId: item.offering.offId,
      courseCode: item.offering.code,
      courseName: item.offering.title,
      year: item.offering.year,
      riskProb: item.student.riskProb ?? 0,
      riskBand: item.student.riskBand ?? 'Low',
      title: `${item.student.name.split(' ')[0]} - ${item.offering.code} intervention`,
      due: index < 3 ? 'Today' : index < 6 ? 'This week' : 'Next week',
      status: index < 4 ? 'New' : index < 7 ? 'In Progress' : 'Follow-up',
      actionHint: `Review ${item.offering.code} evidence and log faculty action for ${item.student.name}.`,
      priority: Math.round((item.student.riskProb ?? 0) * 100),
      createdAt: Date.now() - index * 60 * 60 * 1000,
      assignedTo: owner,
      taskType: index < 4 ? 'Remedial' : 'Follow-up',
    }
  })
}

function buildSeededMeetings(bootstrap: {
  faculty: ApiAcademicBootstrap['faculty']
  offerings: ApiAcademicBootstrap['offerings']
  studentsByOffering: ApiAcademicBootstrap['studentsByOffering']
}): ApiAcademicMeeting[] {
  const ownerFacultyId = bootstrap.faculty[0]?.facultyId ?? 't1'
  const now = Date.now()
  const anchors = bootstrap.offerings
    .flatMap(offering => (bootstrap.studentsByOffering[offering.offId] ?? [])
      .filter(student => student.riskBand === 'High' || student.riskBand === 'Medium')
      .slice(0, 1)
      .map(student => ({ offering, student })))
    .slice(0, 3)

  return anchors.map((anchor, index) => ({
    meetingId: `demo-meeting-${index + 1}`,
    version: 1,
    facultyId: ownerFacultyId,
    studentId: anchor.student.id,
    studentName: anchor.student.name,
    studentUsn: anchor.student.usn,
    offeringId: anchor.offering.offId,
    courseCode: anchor.offering.code,
    courseName: anchor.offering.title,
    title: `Mentor check-in - ${anchor.offering.code}`,
    notes: 'Meeting seeded from canonical risk list.',
    dateISO: index === 0 ? '2026-04-23' : index === 1 ? '2026-04-24' : '2026-04-25',
    startMinutes: 10 * 60 + index * 45,
    endMinutes: 10 * 60 + index * 45 + 30,
    status: 'scheduled',
    createdByFacultyId: ownerFacultyId,
    createdAt: now - index * 24 * 60 * 60 * 1000,
    updatedAt: now - index * 24 * 60 * 60 * 1000,
  }))
}

export function createStaticDemoRepositories(): AirMentorRepositories {
  return createAirMentorRepositories({
    repositoryMode: 'local',
    storage: createInMemoryStorage(),
  })
}

export function buildStaticDemoAcademicBootstrap(repositories: AirMentorRepositories): ApiAcademicBootstrap {
  const professor = deepClone(PROFESSOR)
  const faculty = deepClone(FACULTY)
  const offerings = deepClone(OFFERINGS)
  const yearGroups = deepClone(YEAR_GROUPS)
  const mentees = deepClone(MENTEES)
  const teachers = deepClone(TEACHERS)
  const subjectRuns = deepClone(SUBJECT_RUNS)

  const studentsByOffering = buildStudentsByOffering(offerings)
  const studentHistoryByUsn = buildStudentHistoryByUsn(studentsByOffering, offerings)
  const seededTasks = buildSeededTasks(offerings, studentsByOffering)

  const schemeByOffering = repositories.entryData.getSchemeStateSnapshot(offerings)
  const ttBlueprintsByOffering = repositories.entryData.getBlueprintSnapshot(offerings)

  const runtime = {
    studentPatches: repositories.entryData.getStudentPatchesSnapshot(),
    schemeByOffering,
    ttBlueprintsByOffering,
    drafts: repositories.entryData.getDraftSnapshot(),
    cellValues: repositories.entryData.getCellValueSnapshot(),
    lockByOffering: repositories.locksAudit.getLockSnapshot(offerings),
    lockAuditByTarget: repositories.locksAudit.getLockAuditSnapshot(),
    tasks: repositories.tasks.getTasksSnapshot(() => seededTasks),
    resolvedTasks: repositories.tasks.getResolvedTasksSnapshot({}),
    timetableByFacultyId: repositories.calendar.getTimetableTemplatesSnapshot(faculty, offerings),
    adminCalendarByFacultyId: {},
    taskPlacements: repositories.calendar.getTaskPlacementsSnapshot(),
    calendarAudit: repositories.calendar.getCalendarAuditSnapshot(),
  }

  const bootstrapBase = {
    professor,
    faculty,
    offerings,
    yearGroups,
    mentees,
    teachers,
    subjectRuns,
    studentsByOffering,
    studentHistoryByUsn,
    runtime,
    courseOutcomesByOffering: buildCourseOutcomesByOffering(offerings),
    assessmentSchemesByOffering: schemeByOffering,
    questionPapersByOffering: ttBlueprintsByOffering,
    coAttainmentByOffering: buildCoAttainmentByOffering(offerings, studentsByOffering),
  }

  const existingMeetings = repositories.calendar.getMeetingsSnapshot()
  return {
    ...bootstrapBase,
    meetings: existingMeetings.length > 0 ? existingMeetings : buildSeededMeetings(bootstrapBase),
    proofPlayback: null,
  }
}
