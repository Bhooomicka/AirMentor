import { eq } from 'drizzle-orm';
import { courses, simulationRuns } from '../db/schema.js';
export async function prepareSeededProofRunBootstrap(db, input, deps) {
    const runtime = await deps.readRuntimeCurriculum(db, input.curriculumImportVersionId);
    const sem6 = runtime.courses.filter(course => course.semesterNumber === 6);
    if (runtime.courses.length === 0 || sem6.length === 0) {
        throw new Error('Approved curriculum import is incomplete');
    }
    const runSeed = input.seed ?? Math.floor(Date.now() % 100000);
    const scenarioProfile = deps.scenarioProfileForSeed(runSeed);
    const deterministicPolicy = deps.deterministicPolicyFromResolved(input.policy);
    const simulationRunId = input.simulationRunId ?? deps.createId('simulation_run');
    const activate = input.activate ?? true;
    if (activate) {
        await db.update(simulationRuns).set({
            activeFlag: 0,
            updatedAt: input.now,
            status: 'completed',
        }).where(eq(simulationRuns.batchId, input.batchId));
    }
    const { offerings } = await deps.ensureSem6Offerings(db, runtime.courses, input.now);
    const courseRows = await db.select().from(courses).where(eq(courses.departmentId, deps.MSRUAS_PROOF_DEPARTMENT_ID));
    const courseById = new Map(courseRows.map(row => [row.courseId, row]));
    const sem6OfferingByCourseTitleSection = new Map();
    for (const offering of offerings) {
        const course = courseById.get(offering.courseId);
        if (!course)
            continue;
        sem6OfferingByCourseTitleSection.set(`${course.title}::${offering.sectionCode}`, offering);
    }
    const runBaseValues = {
        batchId: input.batchId,
        curriculumImportVersionId: input.curriculumImportVersionId,
        curriculumFeatureProfileId: input.curriculumFeatureProfileId ?? null,
        curriculumFeatureProfileFingerprint: input.curriculumFeatureProfileFingerprint ?? null,
        parentSimulationRunId: input.parentSimulationRunId ?? null,
        runLabel: input.runLabel ?? `MSRUAS proof rerun ${runSeed}`,
        seed: runSeed,
        sectionCount: 2,
        studentCount: 120,
        facultyCount: deps.PROOF_FACULTY.length,
        semesterStart: 1,
        semesterEnd: 6,
        activeOperationalSemester: 6,
        sourceType: 'simulation',
        policySnapshotJson: JSON.stringify(input.policy),
        engineVersionsJson: JSON.stringify({
            compilerVersion: deps.MSRUAS_PROOF_VALIDATOR_VERSION,
            worldEngineVersion: deps.WORLD_ENGINE_VERSION,
            inferenceModelVersion: deps.INFERENCE_MODEL_VERSION,
            monitoringPolicyVersion: deps.MONITORING_POLICY_VERSION,
        }),
        metricsJson: JSON.stringify({
            proofGoal: 'adaptation-readiness',
            sectionDistribution: { A: 60, B: 60 },
            scenarioFamily: scenarioProfile.family,
        }),
        updatedAt: input.now,
    };
    if (input.simulationRunId) {
        await db.update(simulationRuns).set(runBaseValues).where(eq(simulationRuns.simulationRunId, simulationRunId));
    }
    else {
        await db.insert(simulationRuns).values({
            simulationRunId,
            ...runBaseValues,
            status: 'running',
            activeFlag: 0,
            createdAt: input.now,
        });
    }
    return {
        activate,
        deterministicPolicy,
        offerings,
        runSeed,
        runtime,
        scenarioProfile,
        sem6,
        sem6OfferingByCourseTitleSection,
        simulationRunId,
    };
}
