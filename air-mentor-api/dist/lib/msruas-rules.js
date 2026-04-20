export function roundStatusMark(value, rules) {
    if (rules.statusMarkRounding === 'nearest-integer')
        return Math.round(value);
    return Math.round(value);
}
export function roundToDecimals(value, decimals) {
    const factor = 10 ** decimals;
    return Math.round(value * factor) / factor;
}
export function evaluateAttendanceStatus(input) {
    const attendancePercent = Math.max(0, Math.min(100, input.attendancePercent));
    const shortfallPercent = Math.max(0, input.policy.attendanceRules.minimumPercent - attendancePercent);
    if (attendancePercent >= input.policy.attendanceRules.minimumPercent) {
        return {
            status: 'eligible',
            condonationRequired: false,
            shortfallPercent,
        };
    }
    const condonableMinimum = input.policy.condonationRules.minimumPercent;
    if (attendancePercent >= condonableMinimum) {
        return {
            status: input.condoned ? 'eligible' : 'condonable',
            condonationRequired: !input.condoned,
            shortfallPercent,
        };
    }
    return {
        status: 'ineligible',
        condonationRequired: false,
        shortfallPercent,
    };
}
export function mapGradeBand(mark, gradeBands) {
    const safeMark = Math.max(0, Math.min(100, mark));
    return gradeBands.find(band => safeMark >= band.minimumMark && safeMark <= band.maximumMark)
        ?? gradeBands.slice().sort((left, right) => left.minimumMark - right.minimumMark)[0];
}
export function evaluateCourseStatus(input) {
    const attendance = evaluateAttendanceStatus({
        attendancePercent: input.attendancePercent,
        condoned: input.condoned,
        policy: input.policy,
    });
    const ceRounded = roundStatusMark(input.ceMark, input.policy.roundingRules);
    const seeRounded = roundStatusMark(input.seeMark, input.policy.roundingRules);
    const overallRounded = roundStatusMark(input.ceMark + input.seeMark, input.policy.roundingRules);
    const attendanceEligible = attendance.status === 'eligible';
    const seeEligible = attendanceEligible && ceRounded >= input.policy.eligibilityRules.minimumCeForSee;
    const passed = attendanceEligible
        && ceRounded >= input.policy.passRules.ceMinimum
        && seeRounded >= input.policy.passRules.seeMinimum
        && overallRounded >= input.policy.passRules.overallMinimum;
    const gradeBand = passed
        ? mapGradeBand((overallRounded / input.policy.passRules.overallMaximum) * 100, input.policy.gradeBands)
        : mapGradeBand(0, input.policy.gradeBands);
    return {
        attendance,
        ceRounded,
        seeRounded,
        overallRounded,
        seeEligible,
        passed,
        result: passed ? 'Passed' : 'Failed',
        gradeLabel: passed ? gradeBand.grade : 'F',
        gradePoint: passed ? gradeBand.gradePoint : 0,
    };
}
export function calculateSgpa(input) {
    const filtered = input.attempts.filter(attempt => {
        if (input.policy.sgpaCgpaRules.includeFailedCredits)
            return true;
        return attempt.result === 'Passed' || attempt.gradePoint > 0;
    });
    const credits = filtered.reduce((sum, attempt) => sum + attempt.credits, 0);
    if (credits === 0)
        return 0;
    const weighted = filtered.reduce((sum, attempt) => sum + (attempt.credits * attempt.gradePoint), 0);
    return roundToDecimals(weighted / credits, input.policy.roundingRules.sgpaCgpaDecimals);
}
export function calculateCgpa(input) {
    const flattened = input.termAttempts.flat();
    return calculateSgpa({
        attempts: flattened,
        policy: input.policy,
    });
}
