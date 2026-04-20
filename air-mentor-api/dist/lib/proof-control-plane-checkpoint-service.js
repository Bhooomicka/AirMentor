import { parseJson } from './json.js';
function average(values) {
    if (values.length === 0)
        return 0;
    return values.reduce((sum, value) => sum + value, 0) / values.length;
}
function roundToOne(value) {
    return Math.round(value * 10) / 10;
}
export function stageSummaryPayload(input) {
    const queueDetails = input.queueRows.map(row => ({
        row,
        detail: parseJson(row.detailJson, {}),
    }));
    const studentRiskByStudentId = new Map();
    input.studentRows.forEach(row => {
        const bandWeight = row.riskBand === 'High' ? 2 : row.riskBand === 'Medium' ? 1 : 0;
        const existing = studentRiskByStudentId.get(row.studentId) ?? {
            bandWeight: -1,
            riskBand: 'Low',
            noActionHighRisk: false,
        };
        if (bandWeight > existing.bandWeight) {
            existing.bandWeight = bandWeight;
            existing.riskBand = row.riskBand === 'High' || row.riskBand === 'Medium' ? row.riskBand : 'Low';
        }
        if (row.noActionRiskBand === 'High')
            existing.noActionHighRisk = true;
        studentRiskByStudentId.set(row.studentId, existing);
    });
    const studentRiskRows = [...studentRiskByStudentId.values()];
    const primaryQueueDetails = queueDetails.filter(item => Boolean(item.detail.primaryCase));
    const highRiskCount = studentRiskRows.filter(row => row.riskBand === 'High').length;
    const mediumRiskCount = studentRiskRows.filter(row => row.riskBand === 'Medium').length;
    const openQueueCount = queueDetails.filter(item => item.row.status === 'Open'
        && Boolean(item.detail.primaryCase)
        && Boolean(item.detail.countsTowardCapacity)).length;
    const watchQueueCount = primaryQueueDetails.filter(item => item.row.status === 'Watching').length;
    const resolvedQueueCount = primaryQueueDetails.filter(item => item.row.status === 'Resolved').length;
    const watchStudentCount = new Set(primaryQueueDetails
        .filter(item => item.row.status === 'Watching')
        .map(item => item.row.studentId)).size;
    const averageRiskDeltaScaled = roundToOne(average(input.studentRows.map(row => {
        const payload = parseJson(row.projectionJson, {});
        return Number(payload.riskChangeFromPreviousCheckpointScaled ?? payload.riskDeltaScaled ?? 0);
    })));
    const averageCounterfactualLiftScaled = roundToOne(average(input.studentRows.map(row => {
        const payload = parseJson(row.projectionJson, {});
        return Number(payload.counterfactualLiftScaled ?? (payload.noActionComparator?.deltaScaled ?? 0));
    })));
    return {
        simulationStageCheckpointId: input.checkpoint.simulationStageCheckpointId,
        simulationRunId: input.checkpoint.simulationRunId,
        semesterNumber: input.checkpoint.semesterNumber,
        stageKey: input.checkpoint.stageKey,
        stageLabel: input.checkpoint.stageLabel,
        stageDescription: input.checkpoint.stageDescription,
        stageOrder: input.checkpoint.stageOrder,
        previousCheckpointId: input.checkpoint.previousCheckpointId ?? null,
        nextCheckpointId: input.checkpoint.nextCheckpointId ?? null,
        totalStudentProjectionCount: input.studentRows.length,
        studentCount: studentRiskByStudentId.size,
        offeringCount: input.offeringRows.length,
        highRiskCount,
        mediumRiskCount,
        lowRiskCount: studentRiskByStudentId.size - highRiskCount - mediumRiskCount,
        openQueueCount,
        watchQueueCount,
        watchStudentCount,
        resolvedQueueCount,
        noActionHighRiskCount: studentRiskRows.filter(row => row.noActionHighRisk).length,
        electiveVisibleCount: input.electiveVisibleCount,
        averageRiskDeltaScaled,
        averageRiskChangeFromPreviousCheckpointScaled: averageRiskDeltaScaled,
        averageCounterfactualLiftScaled,
        stageAdvanceBlocked: openQueueCount > 0,
        blockingQueueItemCount: openQueueCount,
    };
}
export function queueStatusPriority(status) {
    if (status === 'Open')
        return 2;
    if (status === 'Watching')
        return 1;
    if (status === 'Resolved')
        return 0;
    return -1;
}
export function queueProjectionDetail(row) {
    return parseJson(row.detailJson, {});
}
export function queueProjectionAssignedFacultyId(row) {
    if (row.assignedFacultyId)
        return row.assignedFacultyId;
    const detail = queueProjectionDetail(row);
    return typeof detail.assignedFacultyId === 'string' ? detail.assignedFacultyId : null;
}
export function parseProofCheckpointSummary(row) {
    return parseJson(row.summaryJson, {
        simulationStageCheckpointId: row.simulationStageCheckpointId,
        simulationRunId: row.simulationRunId,
        semesterNumber: row.semesterNumber,
        stageKey: row.stageKey,
        stageLabel: row.stageLabel,
        stageDescription: row.stageDescription,
        stageOrder: row.stageOrder,
        previousCheckpointId: row.previousCheckpointId ?? null,
        nextCheckpointId: row.nextCheckpointId ?? null,
    });
}
export function withProofPlaybackGate(summaries) {
    const firstBlockedIndex = summaries.findIndex(summary => Number(summary.blockingQueueItemCount ?? summary.openQueueCount ?? 0) > 0);
    return summaries.map((summary, index) => {
        const stageAdvanceBlocked = Number(summary.blockingQueueItemCount ?? summary.openQueueCount ?? 0) > 0;
        const playbackAccessible = firstBlockedIndex === -1 || index <= firstBlockedIndex;
        const blockedByCheckpointId = firstBlockedIndex !== -1 && index > firstBlockedIndex
            ? summaries[firstBlockedIndex]?.simulationStageCheckpointId ?? null
            : null;
        return {
            ...summary,
            stageAdvanceBlocked,
            blockingQueueItemCount: Number(summary.blockingQueueItemCount ?? summary.openQueueCount ?? 0),
            playbackAccessible,
            blockedByCheckpointId,
            blockedProgressionReason: !playbackAccessible && blockedByCheckpointId
                ? `Playback is blocked until all queue items for checkpoint ${blockedByCheckpointId} are resolved.`
                : stageAdvanceBlocked
                    ? 'Playback cannot advance past this checkpoint until all queue items are resolved.'
                    : null,
        };
    });
}
