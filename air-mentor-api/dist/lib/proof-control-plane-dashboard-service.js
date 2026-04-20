function diffSeconds(laterIso, earlierIso) {
    if (!earlierIso)
        return null;
    const later = Date.parse(laterIso);
    const earlier = Date.parse(earlierIso);
    if (!Number.isFinite(later) || !Number.isFinite(earlier))
        return null;
    return Math.max(0, Math.round((later - earlier) / 1000));
}
function resolveLeaseState(run, nowIso) {
    if (run.workerLeaseExpiresAt) {
        const expiresAt = Date.parse(run.workerLeaseExpiresAt);
        const now = Date.parse(nowIso);
        if (Number.isFinite(expiresAt) && Number.isFinite(now)) {
            return expiresAt > now ? 'leased' : 'expired';
        }
    }
    if (run.status !== 'queued' && run.status !== 'running')
        return 'released';
    return null;
}
export function decorateProofRunsWithOperationalDiagnostics(runs, nowIso) {
    return runs.map(run => {
        const retryOfSimulationRunId = typeof run.progress?.retryOf === 'string' ? run.progress.retryOf : null;
        const retryState = retryOfSimulationRunId
            ? 'retry-of-previous-run'
            : run.status === 'failed'
                ? 'retryable'
                : null;
        return {
            ...run,
            queueAgeSeconds: run.status === 'queued'
                ? diffSeconds(nowIso, run.createdAt)
                : run.status === 'running'
                    ? diffSeconds(nowIso, run.startedAt ?? run.createdAt)
                    : null,
            leaseState: resolveLeaseState(run, nowIso),
            leaseExpiresAt: run.workerLeaseExpiresAt,
            retryState,
            retryOfSimulationRunId,
            failureState: run.status === 'failed' ? 'retryable' : 'none',
        };
    });
}
export function buildProofQueueDiagnostics(runs) {
    const queuedRuns = runs.filter(run => run.status === 'queued');
    const oldestQueuedRunAgeSeconds = queuedRuns
        .map(run => run.queueAgeSeconds)
        .filter((value) => typeof value === 'number')
        .sort((left, right) => right - left)[0] ?? null;
    return {
        queuedRunCount: queuedRuns.length,
        runningRunCount: runs.filter(run => run.status === 'running').length,
        failedRunCount: runs.filter(run => run.status === 'failed').length,
        retryableRunCount: runs.filter(run => run.retryState === 'retryable').length,
        retryInFlightCount: runs.filter(run => run.retryState === 'retry-of-previous-run').length,
        oldestQueuedRunAgeSeconds,
        expiredLeaseRunCount: runs.filter(run => run.leaseState === 'expired').length,
    };
}
export function buildProofWorkerDiagnostics(activeRun) {
    if (!activeRun)
        return null;
    return {
        queueAgeSeconds: activeRun.queueAgeSeconds,
        leaseState: activeRun.leaseState,
        leaseExpiresAt: activeRun.leaseExpiresAt,
        retryState: activeRun.retryState,
        retryOfSimulationRunId: activeRun.retryOfSimulationRunId,
        failureState: activeRun.failureState,
        progressPhase: typeof activeRun.progress?.phase === 'string' ? activeRun.progress.phase : null,
        progressPercent: typeof activeRun.progress?.percent === 'number' ? activeRun.progress.percent : null,
    };
}
export function buildCheckpointReadinessDiagnostics(checkpoints) {
    const blockedCheckpoints = checkpoints.filter(checkpoint => (checkpoint.playbackAccessible === false
        || checkpoint.stageAdvanceBlocked === true));
    const readyCheckpoints = checkpoints.filter(checkpoint => (checkpoint.playbackAccessible !== false
        && checkpoint.stageAdvanceBlocked !== true));
    return {
        totalCheckpointCount: checkpoints.length,
        readyCheckpointCount: readyCheckpoints.length,
        blockedCheckpointCount: blockedCheckpoints.length,
        playbackBlockedCheckpointCount: checkpoints.filter(checkpoint => checkpoint.playbackAccessible === false).length,
        totalBlockingQueueItemCount: checkpoints.reduce((sum, checkpoint) => (sum + Number(checkpoint.blockingQueueItemCount ?? checkpoint.openQueueCount ?? 0)), 0),
        firstBlockedCheckpointId: blockedCheckpoints[0]?.simulationStageCheckpointId ?? null,
        lastReadyCheckpointId: readyCheckpoints[readyCheckpoints.length - 1]?.simulationStageCheckpointId ?? null,
    };
}
