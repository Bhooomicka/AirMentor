import { asc, eq } from 'drizzle-orm';
import { batches, simulationRuns, simulationStageCheckpoints, } from '../db/schema.js';
export async function activateProofOperationalSemester(db, input, deps) {
    const [run] = await db.select().from(simulationRuns).where(eq(simulationRuns.simulationRunId, input.simulationRunId));
    if (!run)
        throw new Error('Simulation run not found');
    if (input.semesterNumber < run.semesterStart || input.semesterNumber > run.semesterEnd) {
        throw new Error(`Semester ${input.semesterNumber} is outside the proof run range ${run.semesterStart}-${run.semesterEnd}`);
    }
    const checkpointRows = await db.select().from(simulationStageCheckpoints).where(eq(simulationStageCheckpoints.simulationRunId, run.simulationRunId)).orderBy(asc(simulationStageCheckpoints.semesterNumber), asc(simulationStageCheckpoints.stageOrder));
    const availableSemesters = Array.from(new Set(checkpointRows.map(row => row.semesterNumber))).sort((left, right) => left - right);
    if (availableSemesters.length > 0 && !availableSemesters.includes(input.semesterNumber)) {
        throw new Error(`Semester ${input.semesterNumber} is not available for this proof run`);
    }
    const previousOperationalSemester = run.activeOperationalSemester ?? run.semesterEnd ?? null;
    await db.update(simulationRuns).set({
        activeOperationalSemester: input.semesterNumber,
        updatedAt: input.now,
    }).where(eq(simulationRuns.simulationRunId, run.simulationRunId));
    await db.update(batches).set({
        currentSemester: input.semesterNumber,
        updatedAt: input.now,
    }).where(eq(batches.batchId, run.batchId));
    if (run.activeFlag === 1) {
        await deps.publishOperationalProjection(db, {
            simulationRunId: run.simulationRunId,
            batchId: run.batchId,
            now: input.now,
        });
    }
    await deps.emitSimulationAudit(db, {
        simulationRunId: run.simulationRunId,
        batchId: run.batchId,
        actionType: 'semester-activated',
        payload: {
            previousOperationalSemester,
            activeOperationalSemester: input.semesterNumber,
            availableSemesters,
        },
        createdByFacultyId: input.actorFacultyId ?? null,
        now: input.now,
    });
    return {
        ok: true,
        simulationRunId: run.simulationRunId,
        batchId: run.batchId,
        activeOperationalSemester: input.semesterNumber,
        previousOperationalSemester,
    };
}
