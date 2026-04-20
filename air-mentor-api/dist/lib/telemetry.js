let telemetryPersistenceDispatch = null;
function sanitizeValue(value, depth = 0) {
    if (depth > 5)
        return '[truncated]';
    if (value == null)
        return null;
    if (typeof value === 'string' || typeof value === 'number' || typeof value === 'boolean')
        return value;
    if (value instanceof Date)
        return value.toISOString();
    if (value instanceof Error) {
        const normalized = {
            name: value.name,
            message: value.message,
        };
        const code = Reflect.get(value, 'code');
        if (typeof code === 'string')
            normalized.code = code;
        return normalized;
    }
    if (Array.isArray(value)) {
        return value
            .map(item => sanitizeValue(item, depth + 1))
            .filter((item) => item !== undefined);
    }
    if (typeof value === 'object') {
        const entries = Object.entries(value)
            .map(([key, item]) => [key, sanitizeValue(item, depth + 1)])
            .filter((entry) => entry[1] !== undefined);
        return Object.fromEntries(entries);
    }
    return String(value);
}
async function persistOperationalEventRecord(event) {
    if (!telemetryPersistenceDispatch)
        return;
    try {
        await Promise.resolve(telemetryPersistenceDispatch(event)).catch(error => {
            console.warn(JSON.stringify({
                type: 'airmentor-operational-event',
                name: 'telemetry.persistence_failed',
                level: 'warn',
                timestamp: new Date().toISOString(),
                details: {
                    source: event.source,
                    eventName: event.name,
                    error: sanitizeValue(error) ?? { message: 'Unknown telemetry persistence error' },
                },
            }));
        });
    }
    catch (error) {
        console.warn(JSON.stringify({
            type: 'airmentor-operational-event',
            name: 'telemetry.persistence_failed',
            level: 'warn',
            timestamp: new Date().toISOString(),
            details: {
                source: event.source,
                eventName: event.name,
                error: sanitizeValue(error) ?? { message: 'Unknown telemetry persistence error' },
            },
        }));
    }
}
function telemetryEnabled() {
    return process.env.NODE_ENV !== 'test' && process.env.AIRMENTOR_TELEMETRY_ENABLED !== 'false';
}
function resolveTelemetrySinkUrl(explicit, env = process.env) {
    if (explicit === null)
        return null;
    if (typeof explicit === 'string') {
        const normalized = explicit.trim();
        return normalized.length > 0 ? normalized : null;
    }
    const configured = env.AIRMENTOR_TELEMETRY_SINK_URL;
    if (typeof configured !== 'string')
        return null;
    const normalized = configured.trim();
    return normalized.length > 0 ? normalized : null;
}
function logSinkFailure(sinkUrl, eventName, error) {
    const payload = {
        type: 'airmentor-operational-event',
        name: 'telemetry.sink_failed',
        level: 'warn',
        timestamp: new Date().toISOString(),
        details: {
            sinkUrl,
            eventName,
            error: sanitizeValue(error) ?? { message: 'Unknown telemetry sink error' },
        },
    };
    console.warn(JSON.stringify(payload));
}
function defaultTelemetryDispatch(sinkUrl, serializedPayload, bearerToken) {
    if (typeof fetch !== 'function')
        return;
    void fetch(sinkUrl, {
        method: 'POST',
        headers: {
            'content-type': 'application/json',
            ...(bearerToken ? { authorization: `Bearer ${bearerToken}` } : {}),
        },
        body: serializedPayload,
    }).catch(error => {
        logSinkFailure(sinkUrl, 'telemetry.dispatch_failed', error);
    });
}
export function forwardTelemetryPayload(payload, sinkUrl, options) {
    if (!sinkUrl)
        return false;
    const serializedPayload = typeof payload === 'string'
        ? payload
        : JSON.stringify(sanitizeValue(payload) ?? {});
    const dispatch = options?.dispatch ?? defaultTelemetryDispatch;
    try {
        return Promise.resolve(dispatch(sinkUrl, serializedPayload, options?.bearerToken))
            .then(() => true)
            .catch(error => {
            logSinkFailure(sinkUrl, 'telemetry.relay_failed', error);
            return false;
        });
    }
    catch (error) {
        logSinkFailure(sinkUrl, 'telemetry.relay_failed', error);
        return false;
    }
}
export function normalizeTelemetryError(error) {
    return sanitizeValue(error);
}
export function configureOperationalTelemetryPersistence(dispatch) {
    const previous = telemetryPersistenceDispatch;
    telemetryPersistenceDispatch = dispatch;
    return () => {
        if (telemetryPersistenceDispatch === dispatch) {
            telemetryPersistenceDispatch = previous;
        }
    };
}
export function persistOperationalEvent(input) {
    const persistedEvent = {
        source: input.source,
        name: input.name,
        level: input.level,
        timestamp: input.timestamp ?? new Date().toISOString(),
        details: sanitizeValue(input.details ?? {}) ?? {},
    };
    return persistOperationalEventRecord(persistedEvent).then(() => persistedEvent);
}
export function emitOperationalEvent(name, details, options) {
    if (!telemetryEnabled())
        return null;
    const payload = {
        type: 'airmentor-operational-event',
        name,
        level: options?.level ?? 'info',
        timestamp: options?.timestamp ?? new Date().toISOString(),
        details: sanitizeValue(details ?? {}) ?? {},
    };
    const line = JSON.stringify(payload);
    if (payload.level === 'error') {
        console.error(line);
    }
    else if (payload.level === 'warn') {
        console.warn(line);
    }
    else {
        console.info(line);
    }
    void persistOperationalEvent({
        source: 'backend',
        name: payload.name,
        level: payload.level,
        timestamp: payload.timestamp,
        details: payload.details,
    });
    const sinkUrl = resolveTelemetrySinkUrl(options?.sinkUrl);
    if (sinkUrl) {
        void Promise.resolve((options?.dispatch ?? defaultTelemetryDispatch)(sinkUrl, line, process.env.AIRMENTOR_TELEMETRY_SINK_BEARER_TOKEN?.trim() || undefined)).catch(error => {
            logSinkFailure(sinkUrl, payload.name, error);
        });
    }
    return payload;
}
