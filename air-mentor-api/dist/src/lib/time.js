export function nowIso(now = new Date()) {
    return now.toISOString();
}
export function addHours(iso, hours) {
    const next = new Date(iso);
    next.setHours(next.getHours() + hours);
    return next.toISOString();
}
