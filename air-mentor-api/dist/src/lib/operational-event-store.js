import { desc } from 'drizzle-orm';
import { operationalTelemetryEvents } from '../db/schema.js';
import { createId } from './ids.js';
import { parseJson, stringifyJson } from './json.js';
export async function persistOperationalTelemetryEvent(db, event, createdAt = new Date().toISOString()) {
    await db.insert(operationalTelemetryEvents).values({
        operationalTelemetryEventId: createId('ops_evt'),
        source: event.source,
        name: event.name,
        level: event.level,
        eventTimestamp: event.timestamp,
        payloadJson: stringifyJson(event.details ?? {}),
        createdAt,
    });
}
export async function listRecentOperationalTelemetryEvents(db, limit = 12) {
    const rows = await db.select().from(operationalTelemetryEvents)
        .orderBy(desc(operationalTelemetryEvents.eventTimestamp), desc(operationalTelemetryEvents.createdAt))
        .limit(limit);
    return rows.map(row => ({
        operationalTelemetryEventId: row.operationalTelemetryEventId,
        source: row.source,
        name: row.name,
        level: row.level,
        timestamp: row.eventTimestamp,
        details: parseJson(row.payloadJson, {}),
        createdAt: row.createdAt,
    }));
}
