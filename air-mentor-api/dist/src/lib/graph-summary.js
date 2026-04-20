function clamp(value, min, max) {
    return Math.min(max, Math.max(min, value));
}
function roundToTwo(value) {
    return Math.round(value * 100) / 100;
}
function roundToFour(value) {
    return Math.round(value * 10000) / 10000;
}
function average(values) {
    const filtered = values.filter(value => Number.isFinite(value));
    if (filtered.length === 0)
        return 0;
    return filtered.reduce((sum, value) => sum + value, 0) / filtered.length;
}
function normalizeGraphKey(value) {
    return value.trim().toUpperCase();
}
function collectGraphDistances(startGraphKey, adjacency) {
    const distances = new Map();
    const queue = [{ graphKey: normalizeGraphKey(startGraphKey), distance: 0 }];
    while (queue.length > 0) {
        const current = queue.shift();
        if (!current)
            continue;
        const nextGraphKeys = adjacency.get(current.graphKey) ?? [];
        nextGraphKeys.forEach(nextGraphKey => {
            const normalizedNext = normalizeGraphKey(nextGraphKey);
            const nextDistance = current.distance + 1;
            const existing = distances.get(normalizedNext);
            if (existing != null && existing <= nextDistance)
                return;
            distances.set(normalizedNext, nextDistance);
            queue.push({ graphKey: normalizedNext, distance: nextDistance });
        });
    }
    return distances;
}
function buildFeatureCompleteness(input) {
    const graphAvailable = input?.graphAvailable ?? false;
    const historyAvailable = input?.historyAvailable ?? false;
    const complete = graphAvailable && historyAvailable;
    const confidenceClass = complete
        ? 'high'
        : graphAvailable || historyAvailable
            ? 'medium'
            : 'low';
    return {
        graphAvailable,
        historyAvailable,
        complete,
        missing: [
            ...(!graphAvailable ? ['graph'] : []),
            ...(!historyAvailable ? ['history'] : []),
        ],
        fallbackMode: complete ? 'graph-aware' : 'policy-only',
        confidenceClass,
    };
}
function collectGraphNodeCount(adjacencyMaps) {
    const nodes = new Set();
    for (const adjacency of adjacencyMaps) {
        for (const [graphKey, relatedKeys] of adjacency.entries()) {
            nodes.add(normalizeGraphKey(graphKey));
            for (const relatedKey of relatedKeys)
                nodes.add(normalizeGraphKey(relatedKey));
        }
    }
    return nodes.size;
}
function collectGraphEdgeCount(adjacency) {
    return [...adjacency.values()].reduce((sum, relatedKeys) => sum + relatedKeys.length, 0);
}
function buildFeatureProvenance(input) {
    return {
        curriculumImportVersionId: input?.curriculumImportVersionId ?? null,
        curriculumFeatureProfileFingerprint: input?.curriculumFeatureProfileFingerprint ?? null,
        graphNodeCount: input?.graphNodeCount ?? 0,
        graphEdgeCount: input?.graphEdgeCount ?? 0,
        historyCourseCount: input?.historyCourseCount ?? 0,
    };
}
export function buildMissingGraphAwarePrerequisiteSummary(input) {
    const featureCompleteness = buildFeatureCompleteness({
        graphAvailable: input?.graphAvailable ?? false,
        historyAvailable: input?.historyAvailable ?? false,
    });
    const featureProvenance = buildFeatureProvenance({
        curriculumImportVersionId: input?.curriculumImportVersionId ?? null,
        curriculumFeatureProfileFingerprint: input?.curriculumFeatureProfileFingerprint ?? null,
        graphNodeCount: input?.graphNodeCount ?? 0,
        graphEdgeCount: input?.graphEdgeCount ?? 0,
        historyCourseCount: input?.historyCourseCount ?? 0,
    });
    return {
        prerequisiteAveragePct: 0,
        prerequisiteFailureCount: 0,
        prerequisiteCourseCodes: [],
        prerequisiteWeakCourseCodes: [],
        downstreamDependencyLoad: 0,
        weakPrerequisiteChainCount: 0,
        repeatedWeakPrerequisiteFamilyCount: 0,
        featureCompleteness,
        featureProvenance,
        completeness: featureCompleteness,
    };
}
export function buildGraphAwarePrerequisiteSummary(input) {
    if (!input.source || !input.sourceGraphKey) {
        return buildMissingGraphAwarePrerequisiteSummary({
            graphAvailable: input.graphAvailable,
            historyAvailable: false,
        });
    }
    const sourceSemesterNumber = input.getSemesterNumber(input.source);
    const sourceGraphKey = normalizeGraphKey(input.sourceGraphKey);
    const prerequisiteGraphKeys = [...new Set((input.prerequisiteGraphByGraphKey.get(sourceGraphKey) ?? []).map(normalizeGraphKey))];
    const prerequisiteSourcesRaw = prerequisiteGraphKeys
        .map(graphKey => {
        const source = input.sourceByHistoricalKey.get(input.historicalSourceKeyForGraphKey(graphKey)) ?? null;
        return source ? { source, graphKey } : null;
    })
        .filter(Boolean);
    const prerequisiteSources = prerequisiteSourcesRaw;
    const directPrerequisiteSources = prerequisiteSources.filter(entry => input.getSemesterNumber(entry.source) < sourceSemesterNumber);
    const prerequisiteAveragePct = directPrerequisiteSources.length > 0
        ? roundToTwo(average(directPrerequisiteSources.map(entry => input.getFinalMark(entry.source))))
        : 0;
    const prerequisiteFailureCount = directPrerequisiteSources.filter(entry => input.getResult(entry.source) !== 'Passed').length;
    const prerequisiteCourseCodes = directPrerequisiteSources.map(entry => input.getCourseCode(entry.source));
    const prerequisiteWeakCourseCodes = directPrerequisiteSources
        .filter(entry => input.getResult(entry.source) !== 'Passed' || input.getFinalMark(entry.source) < 55)
        .map(entry => input.getCourseCode(entry.source));
    const transitivePrerequisiteDistances = collectGraphDistances(sourceGraphKey, input.prerequisiteGraphByGraphKey);
    const transitivePrerequisiteSourcesRaw = [...transitivePrerequisiteDistances.entries()]
        .map(([graphKey, distance]) => {
        const source = input.sourceByHistoricalKey.get(input.historicalSourceKeyForGraphKey(graphKey)) ?? null;
        return source ? { source, graphKey, distance } : null;
    })
        .filter(Boolean);
    const transitivePrerequisiteSources = transitivePrerequisiteSourcesRaw
        .filter(entry => input.getSemesterNumber(entry.source) < sourceSemesterNumber);
    const weakTransitiveSources = transitivePrerequisiteSources.filter(entry => input.getResult(entry.source) !== 'Passed' || input.getFinalMark(entry.source) < 55);
    const repeatedWeakPrerequisiteFamilyCount = [...weakTransitiveSources.reduce((accumulator, entry) => {
            const family = input.getCourseFamily(input.getCourseCode(entry.source));
            accumulator.set(family, (accumulator.get(family) ?? 0) + 1);
            return accumulator;
        }, new Map()).values()].filter(count => count >= 2).length;
    const downstreamDistances = collectGraphDistances(sourceGraphKey, input.downstreamGraphByGraphKey);
    const downstreamSourcesRaw = [...downstreamDistances.entries()]
        .map(([graphKey, distance]) => {
        const source = input.sourceByHistoricalKey.get(input.historicalSourceKeyForGraphKey(graphKey)) ?? null;
        return source ? { source, graphKey, distance } : null;
    })
        .filter(Boolean);
    const downstreamSources = downstreamSourcesRaw
        .filter(entry => input.getSemesterNumber(entry.source) > sourceSemesterNumber);
    const weightedLoad = downstreamSources.reduce((sum, entry) => sum + (1 / Math.max(1, entry.distance)), 0);
    const downstreamDependencyLoad = downstreamSources.length === 0
        ? 0
        : roundToFour(clamp(weightedLoad / 4, 0, 1));
    const historyAvailable = prerequisiteSources.length === prerequisiteGraphKeys.length
        && transitivePrerequisiteSources.length === transitivePrerequisiteDistances.size
        && downstreamSources.length === downstreamDistances.size;
    const featureCompleteness = buildFeatureCompleteness({
        graphAvailable: input.graphAvailable,
        historyAvailable,
    });
    const featureProvenance = buildFeatureProvenance({
        curriculumImportVersionId: input.curriculumImportVersionId ?? null,
        curriculumFeatureProfileFingerprint: input.curriculumFeatureProfileFingerprint ?? null,
        graphNodeCount: input.graphNodeCount ?? collectGraphNodeCount([input.prerequisiteGraphByGraphKey, input.downstreamGraphByGraphKey]),
        graphEdgeCount: input.graphEdgeCount ?? collectGraphEdgeCount(input.prerequisiteGraphByGraphKey),
        historyCourseCount: input.historyCourseCount ?? input.sourceByHistoricalKey.size,
    });
    return {
        prerequisiteAveragePct,
        prerequisiteFailureCount,
        prerequisiteCourseCodes,
        prerequisiteWeakCourseCodes,
        downstreamDependencyLoad,
        weakPrerequisiteChainCount: weakTransitiveSources.length,
        repeatedWeakPrerequisiteFamilyCount,
        featureCompleteness,
        featureProvenance,
        completeness: featureCompleteness,
    };
}
