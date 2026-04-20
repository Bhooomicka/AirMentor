import { createHash } from 'node:crypto';
import { existsSync, readFileSync } from 'node:fs';
import path from 'node:path';
import XLSXModule from 'xlsx';
import curriculumSeedJson from '../db/seeds/msruas-mnc-curriculum.json' with { type: 'json' };
const XLSX = XLSXModule.default ?? XLSXModule;
export const MSRUAS_PROOF_COMPILER_VERSION = 'msruas-proof-compiler-v2';
export const MSRUAS_PROOF_VALIDATOR_VERSION = 'msruas-proof-validator-v2';
export const EMBEDDED_CURRICULUM_SOURCE_PATH = 'embedded:msruas-mnc-curriculum.json';
export const EMBEDDED_CURRICULUM_SOURCE_LABEL = 'msruas-mnc-curriculum.json';
const bundledCurriculumManifest = curriculumSeedJson;
function nonEmpty(value) {
    return typeof value === 'string' ? value.trim() : String(value ?? '').trim();
}
function splitWorkbookList(value) {
    const raw = nonEmpty(value);
    if (!raw)
        return [];
    return raw
        .split(';')
        .map(item => item.trim())
        .filter(Boolean);
}
function normalizeTitle(value) {
    return value.trim().toLowerCase().replace(/\s+/g, ' ');
}
function sheetRows(workbook, name) {
    const sheet = workbook.Sheets[name];
    if (!sheet)
        throw new Error(`Workbook sheet "${name}" is missing`);
    return XLSX.utils.sheet_to_json(sheet, {
        defval: '',
        raw: false,
    });
}
function detectCycle(courses) {
    const adjacency = new Map();
    for (const course of courses) {
        adjacency.set(course.title, [...course.explicitPrerequisites, ...course.addedPrerequisites]);
    }
    const visiting = new Set();
    const visited = new Set();
    const stack = [];
    let cyclePath = [];
    const visit = (courseTitle) => {
        if (visiting.has(courseTitle)) {
            const startIndex = stack.indexOf(courseTitle);
            cyclePath = startIndex >= 0 ? [...stack.slice(startIndex), courseTitle] : [courseTitle];
            return true;
        }
        if (visited.has(courseTitle))
            return false;
        visiting.add(courseTitle);
        stack.push(courseTitle);
        for (const prerequisite of adjacency.get(courseTitle) ?? []) {
            if (!adjacency.has(prerequisite))
                continue;
            if (visit(prerequisite))
                return true;
        }
        stack.pop();
        visiting.delete(courseTitle);
        visited.add(courseTitle);
        return false;
    };
    for (const course of courses) {
        if (visit(course.title)) {
            return {
                cycleDetected: true,
                cyclePath,
            };
        }
    }
    return {
        cycleDetected: false,
        cyclePath: [],
    };
}
export function resolveDefaultCurriculumWorkbookPath() {
    const candidates = [
        '/home/raed/Downloads/airmentor_curriculum_compiler_reconciled.xlsx',
        '/home/raed/projects/air-mentor-ui/air-mentor-api/airmentor_msruas_structured_course_graph.xlsx',
    ];
    for (const candidate of candidates) {
        if (existsSync(candidate))
            return candidate;
    }
    return EMBEDDED_CURRICULUM_SOURCE_PATH;
}
function cloneBundledRows(items) {
    return items.map(item => ({ ...item }));
}
function compileBundledCurriculumManifest() {
    const sourceChecksum = createHash('sha256').update(JSON.stringify(bundledCurriculumManifest)).digest('hex');
    return {
        sourcePath: EMBEDDED_CURRICULUM_SOURCE_PATH,
        sourceLabel: EMBEDDED_CURRICULUM_SOURCE_LABEL,
        sourceChecksum,
        sourceType: 'bundled-json',
        compilerVersion: MSRUAS_PROOF_COMPILER_VERSION,
        courses: cloneBundledRows(bundledCurriculumManifest.courses),
        explicitEdges: cloneBundledRows(bundledCurriculumManifest.explicitEdges),
        addedEdges: cloneBundledRows(bundledCurriculumManifest.addedEdges),
        electives: cloneBundledRows(bundledCurriculumManifest.electives),
        sourceNotes: [{
                sourceType: 'bundled-json',
                reference: EMBEDDED_CURRICULUM_SOURCE_LABEL,
                use: 'Fallback proof curriculum manifest embedded in the backend for deployed bootstrap flows.',
            }],
        mappingNotes: [{
                field: 'fallback',
                value: 'Workbook unavailable; compiled from the bundled MSRUAS MNC curriculum manifest.',
            }],
    };
}
export function compileMsruasCurriculumWorkbook(sourcePath = resolveDefaultCurriculumWorkbookPath()) {
    if (sourcePath === EMBEDDED_CURRICULUM_SOURCE_PATH) {
        return compileBundledCurriculumManifest();
    }
    const workbook = XLSX.readFile(sourcePath);
    const sourceChecksum = createHash('sha256').update(readFileSync(sourcePath)).digest('hex');
    const courses = sheetRows(workbook, 'Courses').map(row => ({
        title: nonEmpty(row['Course Title']),
        semester: Number(row['Sem']),
        credits: Number(row['Credits']),
        assessmentProfile: nonEmpty(row['AssessmentProfile']) || 'theory_heavy',
        explicitPrerequisites: splitWorkbookList(row['Prerequisites (explicit)']),
        addedPrerequisites: splitWorkbookList(row['Prerequisites (added)']),
        bridgeModules: splitWorkbookList(row['Bridge Modules']),
        tt1Topics: splitWorkbookList(row['TT1 Topics']),
        tt2Topics: splitWorkbookList(row['TT2 Topics']),
        seeTopics: splitWorkbookList(row['SEE Focus Topics']),
        workbookTopics: splitWorkbookList(row['Workbook Topics']),
        internalCompilerId: nonEmpty(row['Internal Compiler ID']),
        officialWebCode: nonEmpty(row['Official Web Code']) || null,
        officialWebTitle: nonEmpty(row['Official Web Title']) || null,
        matchStatus: nonEmpty(row['Match Status']) || 'unknown',
        mappingNote: nonEmpty(row['Mapping Note']),
    })).filter(course => course.title);
    const explicitEdges = sheetRows(workbook, 'ExplicitEdges').map(row => ({
        targetCourse: nonEmpty(row['Target Course']),
        sourceCourse: nonEmpty(row['Source Course']),
        edgeType: nonEmpty(row['Edge Type']) || 'explicit',
    })).filter(edge => edge.targetCourse && edge.sourceCourse);
    const addedEdges = sheetRows(workbook, 'AddedEdges').map(row => ({
        targetCourse: nonEmpty(row['Target Course']),
        sourceCourse: nonEmpty(row['Source Course']),
        edgeType: nonEmpty(row['Edge Type']) || 'added',
        whyAdded: nonEmpty(row['Why Added']) || undefined,
    })).filter(edge => edge.targetCourse && edge.sourceCourse);
    const electives = sheetRows(workbook, 'OfficialElectives').map(row => ({
        stream: nonEmpty(row['Stream']),
        pceGroup: nonEmpty(row['PCE Group']),
        code: nonEmpty(row['Code']),
        title: nonEmpty(row['Title']),
        semesterSlot: nonEmpty(row['Semester Slot']),
    })).filter(elective => elective.stream && elective.code);
    const sourceNotes = sheetRows(workbook, 'SourceNotes').map(row => ({
        sourceType: nonEmpty(row['Source Type']),
        reference: nonEmpty(row['Reference']),
        use: nonEmpty(row['Use']),
    })).filter(note => note.sourceType);
    const mappingNotes = sheetRows(workbook, 'OfficialMappingNotes').map(row => ({
        field: nonEmpty(row['Field']),
        value: nonEmpty(row['Value']),
    })).filter(note => note.field);
    return {
        sourcePath,
        sourceLabel: path.basename(sourcePath),
        sourceChecksum,
        sourceType: 'workbook',
        compilerVersion: MSRUAS_PROOF_COMPILER_VERSION,
        courses,
        explicitEdges,
        addedEdges,
        electives,
        sourceNotes,
        mappingNotes,
    };
}
export function buildCurriculumOutputChecksum(compiled) {
    return createHash('sha256').update(JSON.stringify({
        courses: compiled.courses,
        explicitEdges: compiled.explicitEdges,
        addedEdges: compiled.addedEdges,
        electives: compiled.electives,
    })).digest('hex');
}
export function validateCompiledCurriculum(compiled) {
    const warnings = [];
    const errors = [];
    const internalIdSeen = new Set();
    const titleSemesterSeen = new Set();
    const duplicateInternalIds = [];
    const duplicateTitleSemesterPairs = [];
    const missingTopicPartitions = [];
    const missingOfficialCodeRows = [];
    const mappingBreakdown = {};
    for (const course of compiled.courses) {
        if (internalIdSeen.has(course.internalCompilerId))
            duplicateInternalIds.push(course.internalCompilerId);
        internalIdSeen.add(course.internalCompilerId);
        const titleSemesterKey = `${course.semester}::${normalizeTitle(course.title)}`;
        if (titleSemesterSeen.has(titleSemesterKey))
            duplicateTitleSemesterPairs.push(titleSemesterKey);
        titleSemesterSeen.add(titleSemesterKey);
        if (course.tt1Topics.length === 0 || course.tt2Topics.length === 0 || course.seeTopics.length === 0 || course.workbookTopics.length === 0) {
            missingTopicPartitions.push(course.internalCompilerId);
        }
        if (!course.officialWebCode)
            missingOfficialCodeRows.push(course.internalCompilerId);
        mappingBreakdown[course.matchStatus] = (mappingBreakdown[course.matchStatus] ?? 0) + 1;
    }
    const semesters = compiled.courses.map(course => course.semester).sort((left, right) => left - right);
    const semesterCoverage = [semesters[0] ?? 0, semesters[semesters.length - 1] ?? 0];
    const semesterCreditTotals = Array.from({ length: 6 }, (_, index) => {
        const semesterNumber = index + 1;
        const semesterCourses = compiled.courses.filter(course => course.semester === semesterNumber);
        return {
            semesterNumber,
            credits: semesterCourses.reduce((sum, course) => sum + course.credits, 0),
            courseCount: semesterCourses.length,
        };
    });
    const totalCredits = compiled.courses.reduce((sum, course) => sum + course.credits, 0);
    const bridgeModuleCount = compiled.courses.filter(course => course.bridgeModules.length > 0).length;
    const cycle = detectCycle(compiled.courses);
    const unresolvedMappingCount = compiled.courses.filter(course => !course.matchStatus.startsWith('exact')).length;
    if (semesterCoverage[0] !== 1 || semesterCoverage[1] !== 6) {
        errors.push(`Expected semester coverage 1-6, received ${semesterCoverage[0]}-${semesterCoverage[1]}.`);
    }
    if (compiled.courses.length !== 36)
        errors.push(`Expected 36 courses, found ${compiled.courses.length}.`);
    if (totalCredits !== 118)
        errors.push(`Expected 118 credits, found ${totalCredits}.`);
    if (compiled.explicitEdges.length !== 24)
        errors.push(`Expected 24 explicit edges, found ${compiled.explicitEdges.length}.`);
    if (compiled.addedEdges.length !== 20)
        errors.push(`Expected 20 added edges, found ${compiled.addedEdges.length}.`);
    if (bridgeModuleCount !== 10)
        errors.push(`Expected 10 bridge-module rows, found ${bridgeModuleCount}.`);
    if (compiled.electives.length !== 18)
        errors.push(`Expected 18 elective mappings, found ${compiled.electives.length}.`);
    if (duplicateInternalIds.length > 0)
        errors.push(`Duplicate internal compiler IDs found: ${duplicateInternalIds.join(', ')}`);
    if (duplicateTitleSemesterPairs.length > 0)
        errors.push(`Duplicate title/semester pairs found: ${duplicateTitleSemesterPairs.join(', ')}`);
    if (cycle.cycleDetected)
        errors.push(`Prerequisite cycle detected: ${cycle.cyclePath.join(' -> ')}`);
    if (missingTopicPartitions.length > 0)
        warnings.push(`Missing one or more topic partitions on ${missingTopicPartitions.length} courses.`);
    if (missingOfficialCodeRows.length > 0)
        warnings.push(`${missingOfficialCodeRows.length} courses have no reliable public web code.`);
    if (unresolvedMappingCount > 0)
        warnings.push(`${unresolvedMappingCount} curriculum mappings still require review before full sign-off.`);
    return {
        status: errors.length > 0 || warnings.length > 0 ? 'review-required' : 'pass',
        semesterCoverage,
        courseCount: compiled.courses.length,
        totalCredits,
        explicitEdgeCount: compiled.explicitEdges.length,
        addedEdgeCount: compiled.addedEdges.length,
        bridgeModuleCount,
        electiveOptionCount: compiled.electives.length,
        unresolvedMappingCount,
        mappingBreakdown,
        duplicateInternalIds,
        duplicateTitleSemesterPairs,
        missingTopicPartitions,
        missingOfficialCodeRows,
        cycleDetected: cycle.cycleDetected,
        cyclePath: cycle.cyclePath,
        semesterCreditTotals,
        sourceNotes: compiled.sourceNotes,
        warnings,
        errors,
    };
}
export function buildCompletenessCertificate(compiled, validation) {
    return {
        sourceLabel: compiled.sourceLabel,
        sourcePath: compiled.sourcePath,
        sourceChecksum: compiled.sourceChecksum,
        compilerVersion: compiled.compilerVersion,
        outputChecksum: buildCurriculumOutputChecksum(compiled),
        validationStatus: validation.status,
        semesterCoverage: validation.semesterCoverage,
        courseCount: validation.courseCount,
        totalCredits: validation.totalCredits,
        explicitEdgeCount: validation.explicitEdgeCount,
        addedEdgeCount: validation.addedEdgeCount,
        bridgeModuleCount: validation.bridgeModuleCount,
        electiveOptionCount: validation.electiveOptionCount,
        unresolvedMappingCount: validation.unresolvedMappingCount,
        mappingBreakdown: validation.mappingBreakdown,
        semesterCreditTotals: validation.semesterCreditTotals,
        warnings: validation.warnings,
        errors: validation.errors,
        sourceNotes: compiled.sourceNotes,
        mappingNotes: compiled.mappingNotes,
    };
}
