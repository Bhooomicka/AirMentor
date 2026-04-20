export function buildSectionRiskRateByStage(input, deps) {
    const sectionRiskRateByStage = new Map();
    deps.PLAYBACK_STAGE_DEFS.forEach(stage => {
        const sectionAccumulator = new Map();
        input.sources.forEach(source => {
            const evidence = deps.buildStageEvidenceSnapshot({
                source,
                stageKey: stage.key,
                policy: input.policy,
                templatesById: input.templatesById,
            });
            const sectionKey = `${source.semesterNumber}::${source.sectionCode}::${stage.key}`;
            sectionAccumulator.set(sectionKey, [
                ...(sectionAccumulator.get(sectionKey) ?? []),
                deps.observableSectionPressureFromEvidence(evidence),
            ]);
        });
        sectionAccumulator.forEach((values, key) => {
            sectionRiskRateByStage.set(key, deps.roundToTwo(deps.average(values)));
        });
    });
    return sectionRiskRateByStage;
}
