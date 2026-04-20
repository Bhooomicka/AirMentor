import { eq } from 'drizzle-orm';
import { curriculumEdges, curriculumNodes, electiveRecommendations, facultyOfferingOwnerships, mentorAssignments, roleGrants, simulationQuestionTemplates, studentCoStates, studentObservedSemesterStates, studentQuestionResults, students, teacherAllocations, teacherLoadProfiles, } from '../db/schema.js';
import { parseObservedStateRow } from './proof-observed-state.js';
export async function preparePlaybackRebuildContext(db, input, deps) {
    const [studentRows, observedRows, curriculumNodeRows, coRows, questionRows, questionTemplateRows, electiveRows, edgeRows, teacherAllocationRows, teacherLoadRows, ownershipRows, mentorRows, grantRows,] = await Promise.all([
        db.select().from(students),
        db.select().from(studentObservedSemesterStates).where(eq(studentObservedSemesterStates.simulationRunId, input.simulationRunId)),
        db.select().from(curriculumNodes).where(eq(curriculumNodes.batchId, input.run.batchId)),
        db.select().from(studentCoStates).where(eq(studentCoStates.simulationRunId, input.simulationRunId)),
        db.select().from(studentQuestionResults).where(eq(studentQuestionResults.simulationRunId, input.simulationRunId)),
        db.select().from(simulationQuestionTemplates).where(eq(simulationQuestionTemplates.simulationRunId, input.simulationRunId)),
        db.select().from(electiveRecommendations).where(eq(electiveRecommendations.simulationRunId, input.simulationRunId)),
        db.select().from(curriculumEdges).where(eq(curriculumEdges.batchId, input.run.batchId)),
        db.select().from(teacherAllocations).where(eq(teacherAllocations.simulationRunId, input.simulationRunId)),
        db.select().from(teacherLoadProfiles).where(eq(teacherLoadProfiles.simulationRunId, input.simulationRunId)),
        db.select().from(facultyOfferingOwnerships).where(eq(facultyOfferingOwnerships.status, 'active')),
        db.select().from(mentorAssignments),
        db.select().from(roleGrants).where(eq(roleGrants.status, 'active')),
    ]);
    const studentById = new Map(studentRows.map(row => [row.studentId, row]));
    const curriculumNodeBySemesterCode = new Map(curriculumNodeRows.map(row => [`${row.semesterNumber}::${row.courseCode}`, row]));
    const templateById = new Map(questionTemplateRows.map(row => [row.simulationQuestionTemplateId, row]));
    const checkpointBySemesterStage = new Map();
    const semesterNumbers = Array.from({ length: Math.max(1, input.run.semesterEnd - input.run.semesterStart + 1) }, (_, semesterIndex) => input.run.semesterStart + semesterIndex);
    const orderedCheckpointRows = semesterNumbers
        .flatMap(semesterNumber => deps.PLAYBACK_STAGE_DEFS.map(stage => ({
        simulationStageCheckpointId: deps.buildDeterministicId('stage_checkpoint', [input.simulationRunId, semesterNumber, stage.key]),
        simulationRunId: input.simulationRunId,
        semesterNumber,
        stageKey: stage.key,
        stageLabel: stage.label,
        stageDescription: stage.description,
        stageOrder: stage.order,
        previousCheckpointId: null,
        nextCheckpointId: null,
        summaryJson: '{}',
        createdAt: input.now,
        updatedAt: input.now,
    })));
    orderedCheckpointRows.forEach((row, index) => {
        row.previousCheckpointId = orderedCheckpointRows[index - 1]?.simulationStageCheckpointId ?? null;
        row.nextCheckpointId = orderedCheckpointRows[index + 1]?.simulationStageCheckpointId ?? null;
        checkpointBySemesterStage.set(`${row.semesterNumber}::${row.stageKey}`, row);
    });
    const previousSemesterSummaryByStudentSemester = new Map();
    observedRows
        .filter(row => row.semesterNumber <= 5)
        .forEach(row => {
        const payload = parseObservedStateRow(row);
        previousSemesterSummaryByStudentSemester.set(`${row.studentId}::${row.semesterNumber}`, {
            cgpa: Number(payload.cgpaAfterSemester ?? 0),
            backlogCount: Number(payload.backlogCount ?? 0),
        });
    });
    const curriculumNodeById = new Map(curriculumNodeRows.map(row => [row.curriculumNodeId, row]));
    const coRowsBySourceKey = new Map();
    coRows.forEach(row => {
        const node = row.curriculumNodeId ? curriculumNodeById.get(row.curriculumNodeId) ?? null : null;
        const key = `${row.studentId}::${row.semesterNumber}::${row.offeringId ?? ''}::${node?.courseCode ?? row.coCode}`;
        coRowsBySourceKey.set(key, [...(coRowsBySourceKey.get(key) ?? []), row]);
    });
    const questionRowsBySourceKey = new Map();
    questionRows.forEach(row => {
        const node = row.curriculumNodeId ? curriculumNodeById.get(row.curriculumNodeId) ?? null : null;
        const courseCode = node?.courseCode ?? '';
        const key = `${row.studentId}::${row.semesterNumber}::${row.offeringId ?? ''}::${courseCode}`;
        questionRowsBySourceKey.set(key, [...(questionRowsBySourceKey.get(key) ?? []), row]);
    });
    const sources = [];
    observedRows
        .slice()
        .sort((left, right) => left.studentId.localeCompare(right.studentId) || left.semesterNumber - right.semesterNumber || left.createdAt.localeCompare(right.createdAt))
        .forEach(row => {
        const student = studentById.get(row.studentId);
        const payload = parseObservedStateRow(row);
        const previousSummary = previousSemesterSummaryByStudentSemester.get(`${row.studentId}::${row.semesterNumber - 1}`) ?? { cgpa: 0, backlogCount: 0 };
        if (row.semesterNumber <= 5 && typeof payload.offeringId !== 'string') {
            const subjectScores = Array.isArray(payload.subjectScores) ? payload.subjectScores : [];
            subjectScores.forEach(subject => {
                const record = subject;
                const courseCode = String(record.courseCode ?? 'NA');
                const curriculumNode = curriculumNodeBySemesterCode.get(`${row.semesterNumber}::${courseCode}`) ?? null;
                const sourceKey = `${row.studentId}::${row.semesterNumber}::::${courseCode}`;
                const coSourceRows = coRowsBySourceKey.get(sourceKey) ?? [];
                const questionSourceRows = questionRowsBySourceKey.get(sourceKey) ?? [];
                sources.push({
                    studentId: row.studentId,
                    studentName: student?.name ?? row.studentId,
                    usn: student?.usn ?? '',
                    semesterNumber: row.semesterNumber,
                    sectionCode: row.sectionCode,
                    termId: row.termId,
                    offeringId: null,
                    curriculumNodeId: curriculumNode?.curriculumNodeId ?? null,
                    courseCode,
                    courseTitle: String(record.title ?? courseCode),
                    courseFamily: curriculumNode?.assessmentProfile ?? 'general',
                    attendanceHistory: deps.parseJson(JSON.stringify(record.attendanceHistory ?? []), []),
                    attendancePct: Number(record.attendancePct ?? 0),
                    tt1Pct: Number(record.tt1Pct ?? 0),
                    tt2Pct: Number(record.tt2Pct ?? 0),
                    quizPct: Number(record.quizPct ?? 0),
                    assignmentPct: Number(record.assignmentPct ?? 0),
                    cePct: Number(record.cePct ?? 0),
                    seePct: Number(record.seePct ?? 0),
                    finalMark: Number(record.score ?? 0),
                    result: String(record.result ?? 'Unknown'),
                    previousCgpa: previousSummary.cgpa,
                    previousBacklogCount: previousSummary.backlogCount,
                    closingCgpa: Number(payload.cgpaAfterSemester ?? previousSummary.cgpa),
                    closingBacklogCount: Number(payload.backlogCount ?? previousSummary.backlogCount),
                    questionRows: questionSourceRows,
                    coRows: coSourceRows,
                    interventionResponse: deps.toInterventionResponse(record.interventionResponse),
                });
            });
            return;
        }
        const offeringId = typeof payload.offeringId === 'string' ? payload.offeringId : null;
        const courseCode = String(payload.courseCode ?? 'NA');
        const curriculumNode = curriculumNodeBySemesterCode.get(`${row.semesterNumber}::${courseCode}`) ?? null;
        const sourceKey = `${row.studentId}::${row.semesterNumber}::${offeringId ?? ''}::${courseCode}`;
        sources.push({
            studentId: row.studentId,
            studentName: student?.name ?? row.studentId,
            usn: student?.usn ?? '',
            semesterNumber: row.semesterNumber,
            sectionCode: row.sectionCode,
            termId: row.termId,
            offeringId,
            curriculumNodeId: curriculumNode?.curriculumNodeId ?? null,
            courseCode,
            courseTitle: String(payload.courseTitle ?? courseCode),
            courseFamily: curriculumNode?.assessmentProfile ?? 'general',
            attendanceHistory: deps.parseJson(JSON.stringify(payload.attendanceHistory ?? []), []),
            attendancePct: Number(payload.attendancePct ?? 0),
            tt1Pct: Number(payload.tt1Pct ?? 0),
            tt2Pct: Number(payload.tt2Pct ?? 0),
            quizPct: Number(payload.quizPct ?? 0),
            assignmentPct: Number(payload.assignmentPct ?? 0),
            cePct: Number(payload.cePct ?? 0),
            seePct: Number(payload.seePct ?? 0),
            finalMark: Number(payload.finalMark ?? 0),
            result: String(payload.result ?? 'Unknown'),
            previousCgpa: previousSummary.cgpa,
            previousBacklogCount: previousSummary.backlogCount,
            closingCgpa: Number(payload.cgpa ?? previousSummary.cgpa),
            closingBacklogCount: Number(payload.backlogCount ?? previousSummary.backlogCount),
            questionRows: questionRowsBySourceKey.get(sourceKey) ?? [],
            coRows: coRowsBySourceKey.get(sourceKey) ?? [],
            interventionResponse: deps.toInterventionResponse(payload.interventionResponse),
        });
    });
    const sourceByStudentNodeId = new Map();
    sources.forEach(source => {
        if (!source.curriculumNodeId)
            return;
        sourceByStudentNodeId.set(`${source.studentId}::${source.curriculumNodeId}`, source);
    });
    const prerequisiteNodeIdsByTargetNodeId = new Map();
    const downstreamNodeIdsBySourceNodeId = new Map();
    edgeRows
        .filter(row => row.status === 'active')
        .forEach(row => {
        prerequisiteNodeIdsByTargetNodeId.set(row.targetCurriculumNodeId, [...(prerequisiteNodeIdsByTargetNodeId.get(row.targetCurriculumNodeId) ?? []), row.sourceCurriculumNodeId]);
        downstreamNodeIdsBySourceNodeId.set(row.sourceCurriculumNodeId, [...(downstreamNodeIdsBySourceNodeId.get(row.sourceCurriculumNodeId) ?? []), row.targetCurriculumNodeId]);
    });
    const sectionStudentCountBySemesterSection = new Map();
    Array.from(new Set(sources.map(source => `${source.semesterNumber}::${source.sectionCode}::${source.studentId}`)))
        .forEach(key => {
        const [semesterNumber, sectionCode] = key.split('::');
        const sectionKey = `${semesterNumber}::${sectionCode}`;
        sectionStudentCountBySemesterSection.set(sectionKey, (sectionStudentCountBySemesterSection.get(sectionKey) ?? 0) + 1);
    });
    const courseLeaderFacultyIdByOfferingId = new Map();
    ownershipRows
        .filter(row => row.offeringId != null)
        .slice()
        .sort((left, right) => left.facultyId.localeCompare(right.facultyId))
        .forEach(row => {
        if (!row.offeringId || courseLeaderFacultyIdByOfferingId.has(row.offeringId))
            return;
        courseLeaderFacultyIdByOfferingId.set(row.offeringId, row.facultyId);
    });
    const courseLeaderFacultyIdByCurriculumNodeSectionSemester = new Map();
    teacherAllocationRows
        .filter(row => row.allocationRole === 'course-leader' && row.curriculumNodeId != null && row.sectionCode != null)
        .slice()
        .sort((left, right) => left.facultyId.localeCompare(right.facultyId))
        .forEach(row => {
        const allocationKey = `${row.semesterNumber}::${row.sectionCode}::${row.curriculumNodeId}`;
        if (courseLeaderFacultyIdByCurriculumNodeSectionSemester.has(allocationKey))
            return;
        courseLeaderFacultyIdByCurriculumNodeSectionSemester.set(allocationKey, row.facultyId);
    });
    const mentorFacultyIdByStudentId = new Map();
    mentorRows
        .filter(row => row.effectiveTo === null)
        .slice()
        .sort((left, right) => left.facultyId.localeCompare(right.facultyId))
        .forEach(row => {
        if (mentorFacultyIdByStudentId.has(row.studentId))
            return;
        mentorFacultyIdByStudentId.set(row.studentId, row.facultyId);
    });
    const hodFacultyId = grantRows
        .filter(row => row.roleCode === 'HOD' && [input.run.batchId, deps.MSRUAS_PROOF_BRANCH_ID, deps.MSRUAS_PROOF_DEPARTMENT_ID].includes(row.scopeId))
        .slice()
        .sort((left, right) => left.facultyId.localeCompare(right.facultyId))[0]?.facultyId ?? null;
    const overloadPenaltyBySemesterFaculty = new Map();
    for (const semesterNumber of semesterNumbers) {
        const semesterLoads = teacherLoadRows.filter(row => row.semesterNumber === semesterNumber);
        const currentLoadAverage = deps.average(semesterLoads.map(row => row.weeklyContactHours));
        const overloadThreshold = Math.max(8, Math.ceil(currentLoadAverage * 1.25));
        semesterLoads.forEach(row => {
            overloadPenaltyBySemesterFaculty.set(`${semesterNumber}::${row.facultyId}`, row.weeklyContactHours > overloadThreshold ? 2 : 0);
        });
    }
    const mentorAssignmentCountByFacultyId = new Map();
    mentorRows
        .filter(row => row.effectiveTo === null)
        .forEach(row => {
        mentorAssignmentCountByFacultyId.set(row.facultyId, (mentorAssignmentCountByFacultyId.get(row.facultyId) ?? 0) + 1);
    });
    const supervisedSectionCount = new Set(teacherAllocationRows
        .filter(row => row.sectionCode != null)
        .map(row => `${row.semesterNumber}::${row.sectionCode}`)).size;
    const facultyBudgetByKey = new Map();
    teacherLoadRows.forEach(row => {
        const overloadPenalty = overloadPenaltyBySemesterFaculty.get(`${row.semesterNumber}::${row.facultyId}`) ?? 0;
        const ownedOfferingCount = teacherAllocationRows.filter(allocation => allocation.semesterNumber === row.semesterNumber
            && allocation.facultyId === row.facultyId
            && allocation.allocationRole === 'course-leader').length;
        facultyBudgetByKey.set(`Course Leader::${row.facultyId}::${row.semesterNumber}`, deps.clamp(4 + ownedOfferingCount - overloadPenalty, 2, 12));
        facultyBudgetByKey.set(`Mentor::${row.facultyId}::${row.semesterNumber}`, deps.clamp(6 + Math.ceil((mentorAssignmentCountByFacultyId.get(row.facultyId) ?? 0) / 15) - overloadPenalty, 4, 18));
        facultyBudgetByKey.set(`HoD::${row.facultyId}::${row.semesterNumber}`, deps.clamp(8 + supervisedSectionCount - overloadPenalty, 6, 24));
    });
    return {
        checkpointBySemesterStage,
        courseLeaderFacultyIdByCurriculumNodeSectionSemester,
        courseLeaderFacultyIdByOfferingId,
        downstreamNodeIdsBySourceNodeId,
        electiveRows,
        facultyBudgetByKey,
        hodFacultyId,
        mentorFacultyIdByStudentId,
        orderedCheckpointRows,
        prerequisiteNodeIdsByTargetNodeId,
        sectionStudentCountBySemesterSection,
        semesterNumbers,
        sourceByStudentNodeId,
        sources,
        teacherAllocationRows,
        templateById,
    };
}
