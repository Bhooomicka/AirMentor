export function pickAuthoritativeFirstList(authoritative, runtime) {
    return authoritative.length > 0 ? authoritative : runtime;
}
export function pickAuthoritativeFirstRecord(input) {
    const visibleIds = input.visibleIds instanceof Set ? input.visibleIds : new Set(input.visibleIds);
    const entries = input.authoritativeById.size > 0
        ? Array.from(visibleIds).flatMap(id => {
            const authoritativeValue = input.authoritativeById.get(id);
            return authoritativeValue ? [[id, authoritativeValue]] : [];
        })
        : Array.from(visibleIds).flatMap(id => {
            const runtimeValue = input.parseRuntimeValue(input.runtimeById[id]);
            return runtimeValue ? [[id, runtimeValue]] : [];
        });
    return Object.fromEntries(entries);
}
