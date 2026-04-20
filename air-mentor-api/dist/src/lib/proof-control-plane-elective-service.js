import { parseJson } from './json.js';
function matchesSemesterScopedElectiveFilter(row, filter) {
    if (filter.simulationRunId != null && row.simulationRunId !== filter.simulationRunId)
        return false;
    if (filter.semesterNumber != null && row.semesterNumber !== filter.semesterNumber)
        return false;
    return true;
}
export function filterElectiveRecommendationsForSemester(rows, filter) {
    return rows.filter(row => matchesSemesterScopedElectiveFilter(row, filter));
}
export function latestElectiveRecommendationForSemester(rows, filter) {
    return rows
        .filter(row => row.studentId === filter.studentId)
        .filter(row => matchesSemesterScopedElectiveFilter(row, filter))
        .slice()
        .sort((left, right) => right.updatedAt.localeCompare(left.updatedAt))[0] ?? null;
}
export function toElectiveFitPayload(row) {
    if (!row)
        return null;
    return {
        recommendedCode: row.recommendedCode,
        recommendedTitle: row.recommendedTitle,
        stream: row.stream,
        rationale: parseJson(row.rationaleJson, []),
        alternatives: parseJson(row.alternativesJson, []),
    };
}
