import { inArray } from 'drizzle-orm';
import { offeringQuestionPapers, } from '../db/schema.js';
export async function buildSeededScaffolding(db, input, deps) {
    const questionPaperRows = input.offerings.length > 0
        ? await db.select().from(offeringQuestionPapers).where(inArray(offeringQuestionPapers.offeringId, input.offerings.map(offering => offering.offeringId)))
        : [];
    const blueprintByOfferingKind = new Map();
    for (const paper of questionPaperRows) {
        const parsed = deps.parseJson(paper.blueprintJson, {});
        if (Array.isArray(parsed.nodes)) {
            blueprintByOfferingKind.set(`${paper.offeringId}::${paper.kind}`, { nodes: parsed.nodes });
        }
    }
    const teacherAllocationRows = [];
    const worldContextRows = [];
    const questionTemplateRows = [];
    const loadsByFacultyId = new Map();
    const questionTemplatesByScope = new Map();
    for (let semesterNumber = 1; semesterNumber <= 6; semesterNumber += 1) {
        const semesterCourses = input.runtimeCourses.filter(course => course.semesterNumber === semesterNumber);
        ['A', 'B'].forEach((sectionCode, sectionOffset) => {
            const sectionContext = {
                sectionAbilityMean: deps.roundToTwo(deps.average(input.trajectories.filter(student => student.sectionCode === sectionCode).map(student => student.latentBase.academicPotential))),
                sectionAttendanceCulture: deps.roundToTwo(deps.average(input.trajectories.filter(student => student.sectionCode === sectionCode).map(student => student.profile.behavior.attendancePropensity))),
                teacherStrictnessIndex: deps.roundToTwo(deps.stableBetween(`run-${input.runSeed}-sem-${semesterNumber}-${sectionCode}-strict`, 0.32, 0.78)),
                assessmentDifficultyIndex: deps.roundToTwo(deps.stableBetween(`run-${input.runSeed}-sem-${semesterNumber}-${sectionCode}-difficulty`, 0.38, 0.84)),
                interventionCapacity: deps.roundToTwo(deps.stableBetween(`run-${input.runSeed}-sem-${semesterNumber}-${sectionCode}-capacity`, 0.34, 0.82)),
            };
            worldContextRows.push({
                worldContextSnapshotId: deps.createId('world_context'),
                simulationRunId: input.simulationRunId,
                semesterNumber,
                sectionCode,
                contextType: 'section',
                contextKey: `semester-${semesterNumber}-${sectionCode}`,
                contextJson: JSON.stringify(sectionContext),
                createdAt: input.now,
                updatedAt: input.now,
            });
            semesterCourses.forEach((course, courseIndex) => {
                const faculty = input.courseLeaderFaculty[(courseIndex + sectionOffset) % input.courseLeaderFaculty.length];
                const offeringId = semesterNumber === 6
                    ? input.sem6OfferingByCourseTitleSection.get(`${course.title}::${sectionCode}`)?.offeringId ?? null
                    : null;
                teacherAllocationRows.push({
                    teacherAllocationId: deps.createId('teacher_allocation'),
                    simulationRunId: input.simulationRunId,
                    facultyId: faculty.facultyId,
                    offeringId,
                    curriculumNodeId: course.curriculumNodeId,
                    semesterNumber,
                    sectionCode,
                    allocationRole: 'course-leader',
                    plannedContactHours: deps.weeklyContactHoursForCourse(course),
                    createdAt: input.now,
                    updatedAt: input.now,
                });
                if (offeringId) {
                    const current = loadsByFacultyId.get(faculty.facultyId) ?? [];
                    current.push({
                        offeringId,
                        courseCode: deps.courseCodeForRuntime(course),
                        courseName: course.title,
                        sectionCode,
                        semesterNumber,
                        weeklyHours: deps.weeklyContactHoursForCourse(course),
                    });
                    loadsByFacultyId.set(faculty.facultyId, current);
                }
                const simulatedTemplates = deps.buildSimulatedQuestionTemplates({
                    simulationRunId: input.simulationRunId,
                    semesterNumber,
                    course,
                    offeringId,
                    tt1Topics: course.tt1Topics,
                    tt2Topics: course.tt2Topics,
                    seeTopics: course.seeTopics,
                });
                const templateGroup = semesterNumber === 6 && offeringId
                    ? [
                        ...(blueprintByOfferingKind.has(`${offeringId}::tt1`)
                            ? deps.buildTemplatesFromBlueprint({
                                simulationRunId: input.simulationRunId,
                                semesterNumber,
                                course,
                                offeringId,
                                componentType: 'tt1',
                                blueprint: blueprintByOfferingKind.get(`${offeringId}::tt1`) ?? { nodes: [] },
                                topicFallback: course.tt1Topics,
                            })
                            : simulatedTemplates.filter(template => template.componentType === 'tt1')),
                        ...(blueprintByOfferingKind.has(`${offeringId}::tt2`)
                            ? deps.buildTemplatesFromBlueprint({
                                simulationRunId: input.simulationRunId,
                                semesterNumber,
                                course,
                                offeringId,
                                componentType: 'tt2',
                                blueprint: blueprintByOfferingKind.get(`${offeringId}::tt2`) ?? { nodes: [] },
                                topicFallback: course.tt2Topics,
                            })
                            : simulatedTemplates.filter(template => template.componentType === 'tt2')),
                        ...(blueprintByOfferingKind.has(`${offeringId}::see`)
                            ? deps.buildTemplatesFromBlueprint({
                                simulationRunId: input.simulationRunId,
                                semesterNumber,
                                course,
                                offeringId,
                                componentType: 'see',
                                blueprint: blueprintByOfferingKind.get(`${offeringId}::see`) ?? { nodes: [] },
                                topicFallback: course.seeTopics,
                            })
                            : simulatedTemplates.filter(template => template.componentType === 'see')),
                    ]
                    : simulatedTemplates;
                questionTemplatesByScope.set(offeringId ?? course.curriculumNodeId, templateGroup);
                templateGroup.forEach(template => {
                    questionTemplateRows.push({
                        simulationQuestionTemplateId: template.simulationQuestionTemplateId,
                        simulationRunId: template.simulationRunId,
                        semesterNumber: template.semesterNumber,
                        curriculumNodeId: template.curriculumNodeId,
                        offeringId: template.offeringId,
                        componentType: template.componentType,
                        questionIndex: template.questionIndex,
                        questionCode: template.questionCode,
                        questionType: template.questionType,
                        questionMarks: template.questionMarks,
                        difficultyScaled: template.difficultyScaled,
                        transferDemandScaled: template.transferDemandScaled,
                        coTagsJson: JSON.stringify(template.coTags),
                        topicTagsJson: JSON.stringify(template.topicTags),
                        microSkillTagsJson: JSON.stringify(template.microSkillTags),
                        sourceType: template.sourceType,
                        templateJson: JSON.stringify(template.templateJson),
                        createdAt: input.now,
                        updatedAt: input.now,
                    });
                });
            });
        });
    }
    return {
        loadsByFacultyId,
        questionTemplateRows,
        questionTemplatesByScope,
        teacherAllocationRows,
        worldContextRows,
    };
}
