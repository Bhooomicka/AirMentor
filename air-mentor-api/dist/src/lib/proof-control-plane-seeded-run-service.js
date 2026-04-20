import { eq } from 'drizzle-orm';
import { alertDecisions, alertOutcomes, electiveRecommendations, reassessmentEvents, riskAssessments, semesterTransitionLogs, simulationQuestionTemplates, simulationResetSnapshots, simulationRuns, studentAcademicProfiles, studentAssessmentScores, studentAttendanceSnapshots, studentBehaviorProfiles, studentCoStates, studentInterventionResponseStates, studentInterventions, studentLatentStates, studentObservedSemesterStates, studentQuestionResults, studentTopicStates, teacherAllocations, teacherLoadProfiles, transcriptSubjectResults, transcriptTermResults, worldContextSnapshots, } from '../db/schema.js';
import { parseObservedStateRow } from './proof-observed-state.js';
export async function finalizeSeededProofRun(db, input, deps) {
    const teacherLoadRows = [];
    const perFacultySemester = new Map();
    input.teacherAllocationRows.forEach(row => {
        const key = `${row.facultyId}::${row.semesterNumber}`;
        perFacultySemester.set(key, [...(perFacultySemester.get(key) ?? []), row]);
    });
    for (const faculty of deps.PROOF_FACULTY) {
        for (let semesterNumber = 1; semesterNumber <= 6; semesterNumber += 1) {
            const allocations = perFacultySemester.get(`${faculty.facultyId}::${semesterNumber}`) ?? [];
            teacherLoadRows.push({
                teacherLoadProfileId: deps.createId('teacher_load'),
                simulationRunId: input.simulationRunId,
                facultyId: faculty.facultyId,
                semesterNumber,
                sectionLoadCount: allocations.length,
                weeklyContactHours: allocations.reduce((sum, row) => sum + row.plannedContactHours, 0),
                assignedCredits: allocations.reduce((sum, row) => sum + (row.plannedContactHours > 0 ? 1 : 0), 0),
                permissionsJson: JSON.stringify(faculty.permissions),
                createdAt: input.now,
                updatedAt: input.now,
            });
        }
    }
    if (input.teacherAllocationRows.length > 0)
        await deps.insertRowsInChunks(db, teacherAllocations, input.teacherAllocationRows);
    if (teacherLoadRows.length > 0)
        await deps.insertRowsInChunks(db, teacherLoadProfiles, teacherLoadRows);
    if (input.latentRows.length > 0)
        await deps.insertRowsInChunks(db, studentLatentStates, input.latentRows);
    if (input.behaviorRows.length > 0)
        await deps.insertRowsInChunks(db, studentBehaviorProfiles, input.behaviorRows);
    if (input.topicStateRows.length > 0)
        await deps.insertRowsInChunks(db, studentTopicStates, input.topicStateRows);
    if (input.coStateRows.length > 0)
        await deps.insertRowsInChunks(db, studentCoStates, input.coStateRows);
    if (input.worldContextRows.length > 0)
        await deps.insertRowsInChunks(db, worldContextSnapshots, input.worldContextRows);
    if (input.questionTemplateRows.length > 0)
        await deps.insertRowsInChunks(db, simulationQuestionTemplates, input.questionTemplateRows);
    if (input.questionResultRows.length > 0)
        await deps.insertRowsInChunks(db, studentQuestionResults, input.questionResultRows);
    if (input.observedRows.length > 0)
        await deps.insertRowsInChunks(db, studentObservedSemesterStates, input.observedRows);
    if (input.transitionRows.length > 0)
        await deps.insertRowsInChunks(db, semesterTransitionLogs, input.transitionRows);
    if (input.attendanceRows.length > 0)
        await deps.insertRowsInChunks(db, studentAttendanceSnapshots, input.attendanceRows);
    if (input.assessmentRows.length > 0)
        await deps.insertRowsInChunks(db, studentAssessmentScores, input.assessmentRows);
    if (input.transcriptTermRowsInsert.length > 0)
        await deps.insertRowsInChunks(db, transcriptTermResults, input.transcriptTermRowsInsert);
    if (input.transcriptSubjectRowsInsert.length > 0)
        await deps.insertRowsInChunks(db, transcriptSubjectResults, input.transcriptSubjectRowsInsert);
    if (input.riskRows.length > 0)
        await deps.insertRowsInChunks(db, riskAssessments, input.riskRows);
    if (input.reassessmentRows.length > 0)
        await deps.insertRowsInChunks(db, reassessmentEvents, input.reassessmentRows);
    if (input.alertRows.length > 0)
        await deps.insertRowsInChunks(db, alertDecisions, input.alertRows);
    if (input.alertOutcomeRows.length > 0)
        await deps.insertRowsInChunks(db, alertOutcomes, input.alertOutcomeRows);
    if (input.electiveRows.length > 0)
        await deps.insertRowsInChunks(db, electiveRecommendations, input.electiveRows);
    if (input.interventionRows.length > 0)
        await deps.insertRowsInChunks(db, studentInterventions, input.interventionRows);
    if (input.interventionResponseRows.length > 0)
        await deps.insertRowsInChunks(db, studentInterventionResponseStates, input.interventionResponseRows);
    const currentProfiles = await db.select().from(studentAcademicProfiles);
    const currentProfileSet = new Set(currentProfiles.map(row => row.studentId));
    for (const trajectory of input.trajectories) {
        const latestObserved = input.observedRows
            .filter(row => row.studentId === trajectory.studentId && row.semesterNumber <= 5)
            .sort((left, right) => right.semesterNumber - left.semesterNumber)[0];
        if (!latestObserved)
            continue;
        const payload = parseObservedStateRow(latestObserved);
        const prevCgpaScaled = Math.round(Number(payload.cgpaAfterSemester ?? 0) * 100);
        if (currentProfileSet.has(trajectory.studentId)) {
            await db.update(studentAcademicProfiles).set({
                prevCgpaScaled,
                updatedAt: input.now,
            }).where(eq(studentAcademicProfiles.studentId, trajectory.studentId));
        }
    }
    await deps.rebuildSimulationStagePlayback(db, {
        simulationRunId: input.simulationRunId,
        policy: input.policy,
        now: input.now,
    });
    if (!input.skipArtifactRebuild) {
        await deps.rebuildProofRiskArtifacts(db, {
            batchId: input.batchId,
            simulationRunId: input.simulationRunId,
            actorFacultyId: input.actorFacultyId ?? null,
            now: input.now,
        });
    }
    if (!input.skipActiveRiskRecompute) {
        await deps.recomputeObservedOnlyRisk(db, {
            simulationRunId: input.simulationRunId,
            policy: input.policy,
            actorFacultyId: input.actorFacultyId ?? null,
            now: input.now,
            rebuildModelArtifacts: false,
        });
    }
    const snapshot = {
        curriculumImportVersionId: input.curriculumImportVersionId,
        seed: input.runSeed,
        policySnapshot: input.policy,
        sectionCount: 2,
        studentCount: 120,
        facultyCount: deps.PROOF_FACULTY.length,
    };
    await db.insert(simulationResetSnapshots).values({
        simulationResetSnapshotId: deps.createId('simulation_reset'),
        simulationRunId: input.simulationRunId,
        batchId: input.batchId,
        snapshotLabel: 'Baseline snapshot',
        snapshotJson: JSON.stringify(snapshot),
        createdAt: input.now,
    });
    const timetablePayload = deps.buildTimetablePayload(input.loadsByFacultyId);
    await deps.upsertRuntimeSlice(db, 'timetableByFacultyId', timetablePayload, input.now);
    await deps.emitSimulationAudit(db, {
        simulationRunId: input.simulationRunId,
        batchId: input.batchId,
        actionType: input.parentSimulationRunId ? 'restored-run-created' : 'run-created',
        payload: {
            seed: input.runSeed,
            curriculumImportVersionId: input.curriculumImportVersionId,
            activate: input.activate,
        },
        createdByFacultyId: input.actorFacultyId ?? null,
        now: input.now,
    });
    await db.update(simulationRuns).set({
        status: 'completed',
        activeFlag: input.activate ? 1 : 0,
        completedAt: input.now,
        progressJson: JSON.stringify({
            phase: 'completed',
            percent: 100,
            mode: 'seeded-proof',
            scenarioFamily: input.scenarioFamily,
        }),
        metricsJson: JSON.stringify({
            proofGoal: 'adaptation-readiness',
            sectionDistribution: { A: 60, B: 60 },
            coverage: {
                behaviorProfileCount: input.behaviorRows.length,
                topicStateCount: input.topicStateRows.length,
                coStateCount: input.coStateRows.length,
                worldContextCount: input.worldContextRows.length,
                questionTemplateCount: input.questionTemplateRows.length,
                questionResultCount: input.questionResultRows.length,
                attendanceHistoryCoverageCount: input.observedRows.filter(row => {
                    const payload = parseObservedStateRow(row);
                    return Array.isArray(payload.attendanceHistory) || (Array.isArray(payload.subjectScores) && payload.subjectScores.some(item => Array.isArray(item.attendanceHistory)));
                }).length,
                interventionResponseCount: input.interventionResponseRows.length,
            },
        }),
        updatedAt: input.now,
    }).where(eq(simulationRuns.simulationRunId, input.simulationRunId));
    return {
        simulationRunId: input.simulationRunId,
        activeFlag: input.activate,
    };
}
