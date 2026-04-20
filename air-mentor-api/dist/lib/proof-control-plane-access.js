export function isFacultyProofQueueItemVisible(input) {
    if (input.viewerRoleCode === 'COURSE_LEADER')
        return input.matchesOwnedOffering;
    if (input.viewerRoleCode === 'MENTOR')
        return input.matchesAssignedStudent;
    return input.matchesOwnedOffering || input.matchesAssignedStudent;
}
export function isFacultyProofStudentVisible(input) {
    if (input.viewerRoleCode === 'COURSE_LEADER')
        return input.visibleViaOwnedOffering;
    if (input.viewerRoleCode === 'MENTOR')
        return input.visibleViaAssignedMentorScope;
    return input.visibleViaOwnedOffering || input.visibleViaAssignedMentorScope;
}
export function queueDecisionTypeFromStatus(status) {
    if (status === 'Resolved')
        return 'suppress';
    if (status === 'Watching')
        return 'watch';
    return 'alert';
}
export function queueReassessmentStatusFromStatus(status) {
    if (status === 'Resolved')
        return 'Resolved';
    if (status === 'Watching')
        return 'Watching';
    return 'Open';
}
