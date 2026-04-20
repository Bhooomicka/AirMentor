export function buildProofCountProvenance(input) {
    const normalizedSectionCode = input.sectionCode?.trim().toUpperCase() ?? null;
    const countSource = input.simulationStageCheckpointId ? 'proof-checkpoint' : 'proof-run';
    const scopeLabelParts = [
        input.studentLabel ?? input.batchLabel,
        normalizedSectionCode ? `Section ${normalizedSectionCode}` : null,
        input.studentLabel ? input.batchLabel : null,
    ].filter((value) => Boolean(value));
    const resolvedFromLabel = input.simulationStageCheckpointId
        ? `${input.checkpointLabel ?? 'Selected checkpoint'} · ${input.runLabel}`
        : input.runLabel;
    return {
        scopeDescriptor: {
            scopeType: input.studentId ? 'student' : 'proof',
            scopeId: input.studentId ?? input.simulationStageCheckpointId ?? input.simulationRunId,
            label: scopeLabelParts.join(' · '),
            batchId: input.batchId,
            sectionCode: normalizedSectionCode,
            branchName: input.branchName ?? null,
            simulationRunId: input.simulationRunId,
            simulationStageCheckpointId: input.simulationStageCheckpointId ?? null,
            studentId: input.studentId ?? null,
        },
        resolvedFrom: {
            kind: input.simulationStageCheckpointId ? 'proof-checkpoint' : 'proof-run',
            scopeType: 'proof',
            scopeId: input.simulationStageCheckpointId ?? input.simulationRunId,
            label: resolvedFromLabel,
        },
        scopeMode: 'proof',
        countSource,
        activeOperationalSemester: input.activeOperationalSemester,
    };
}
export function buildUnavailableCountProvenance(input = {}) {
    const normalizedSectionCode = input.sectionCode?.trim().toUpperCase() ?? null;
    return {
        scopeDescriptor: {
            scopeType: 'proof',
            scopeId: input.batchId ?? 'proof-unavailable',
            label: input.batchLabel
                ? `${input.batchLabel}${normalizedSectionCode ? ` · Section ${normalizedSectionCode}` : ''}`
                : 'Proof unavailable',
            batchId: input.batchId ?? null,
            sectionCode: normalizedSectionCode,
            branchName: input.branchName ?? null,
            simulationRunId: null,
            simulationStageCheckpointId: null,
            studentId: null,
        },
        resolvedFrom: {
            kind: 'proof-unavailable',
            scopeType: 'proof',
            scopeId: input.batchId ?? null,
            label: 'No active proof run is available for this scope.',
        },
        scopeMode: 'proof',
        countSource: 'unavailable',
        activeOperationalSemester: input.activeOperationalSemester ?? null,
    };
}
