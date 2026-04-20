import { drizzle } from 'drizzle-orm/node-postgres';
import { Pool } from 'pg';
import { emitOperationalEvent, normalizeTelemetryError } from '../lib/telemetry.js';
import { allTables } from './schema.js';
export function createPool(connectionString, options = {}) {
    const pool = new Pool({ connectionString, ...options });
    pool.on('error', error => {
        emitOperationalEvent('database.pool.error', {
            error: normalizeTelemetryError(error),
        }, { level: 'error' });
        console.error('Database pool error', error);
    });
    return pool;
}
export function createDb(pool) {
    return drizzle(pool, { schema: allTables });
}
