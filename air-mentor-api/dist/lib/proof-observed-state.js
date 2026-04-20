import { parseJson } from './json.js';
export function parseObservedStatePayload(value) {
    return parseJson(value, {});
}
export function parseObservedStateRow(row) {
    return parseObservedStatePayload(row.observedStateJson);
}
