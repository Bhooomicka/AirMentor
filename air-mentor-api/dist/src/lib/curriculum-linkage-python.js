import { existsSync } from 'node:fs';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import path from 'node:path';
function resolvePythonExecutable() {
    return [
        process.env.AIRMENTOR_CURRICULUM_LINKAGE_PYTHON,
        'python3',
        'python',
    ].filter((candidate) => !!candidate);
}
function resolveHelperScriptPath() {
    const cwdCandidate = path.resolve(process.cwd(), 'scripts', 'curriculum_linkage_nlp.py');
    if (existsSync(cwdCandidate))
        return cwdCandidate;
    const moduleCandidate = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '../../scripts/curriculum_linkage_nlp.py');
    if (existsSync(moduleCandidate))
        return moduleCandidate;
    return cwdCandidate;
}
export function runCurriculumLinkagePython(input) {
    const scriptPath = resolveHelperScriptPath();
    if (!existsSync(scriptPath))
        return null;
    const timeoutMs = Number(process.env.AIRMENTOR_CURRICULUM_LINKAGE_PYTHON_TIMEOUT_MS ?? 12000);
    for (const executable of resolvePythonExecutable()) {
        const result = spawnSync(executable, [scriptPath], {
            cwd: process.cwd(),
            input: JSON.stringify(input),
            encoding: 'utf8',
            timeout: timeoutMs,
            maxBuffer: 5 * 1024 * 1024,
            env: process.env,
        });
        if (result.error || result.status !== 0 || !result.stdout?.trim()) {
            continue;
        }
        try {
            const parsed = JSON.parse(result.stdout);
            if (!parsed || !Array.isArray(parsed.candidates))
                continue;
            return parsed;
        }
        catch {
            continue;
        }
    }
    return null;
}
