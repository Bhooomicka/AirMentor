export function pickMostRecentActiveRun(runs) {
    return runs
        .slice()
        .sort((left, right) => (right.updatedAt.localeCompare(left.updatedAt)
        || right.createdAt.localeCompare(left.createdAt)
        || ((right.activeOperationalSemester ?? 0) - (left.activeOperationalSemester ?? 0))
        || left.runLabel.localeCompare(right.runLabel)))[0] ?? null;
}
