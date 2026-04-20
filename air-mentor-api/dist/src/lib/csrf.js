import { createHmac, timingSafeEqual } from 'node:crypto';
export function buildCsrfToken(secret, sessionId) {
    return createHmac('sha256', secret).update(sessionId).digest('base64url');
}
export function readSingleHeaderValue(value) {
    if (Array.isArray(value))
        return value[0] ?? '';
    return value ?? '';
}
export function secureTokenEquals(left, right) {
    if (left.length !== right.length)
        return false;
    return timingSafeEqual(Buffer.from(left), Buffer.from(right));
}
