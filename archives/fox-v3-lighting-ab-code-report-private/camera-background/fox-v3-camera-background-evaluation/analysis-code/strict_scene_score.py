#!/usr/bin/env python3
"""Read-only admission and unchanged formal-v3 scoring for pinned scene composition.

Writes only fresh reports under analysis-code. Never renders, patches inputs, fits
thresholds, runs heavy benchmarks, or treats the background control as geometry.
"""
from __future__ import annotations
import argparse
import hashlib
import json
import math
from pathlib import Path, PurePosixPath
import re
import sys
import types
import numpy as np

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
VIEWS = ('front', 'oblique')
CASES = ('baseline', 'direction', 'intensity', 'ambient', 'albedo')
KEYS = {(v, c, r) for v in VIEWS for c in CASES for r in (False, True)}
EXTS = {'.u16le', '.f32le', '.snapshot', '.targets.u8', '.json', '.aa.json', '.samples.jsonl'}
TIMINGS = {'transportBuildNs', 'visibilityBuildNs', 'appendNs', 'evaluateNs', 'hostRenderNsFirstFrame'}
OLD_WORK = set('visibilityRays visibilityNodeVisits visibilityTriangleTests transportRays transportNodeVisits transportTriangleTests primary_ground_hits primary_ground_emission_hits secondary_ground_hits primary_rays primary_hits primary_misses secondary_world_rays secondary_direct_queries primary_direct_queries zero_reflection_ns_v back_single_discard grazing_ng_v shadeUpdates diskSamples'.split())
ARM_DIR = {'off': 'off', 'on': 'on', 'background': 'background-control'}
LUMA = np.array([.2126, .7152, .0722], dtype=np.float64)


def require(value, message):
    if not value:
        raise ValueError(message)


def sha(path):
    h = hashlib.sha256()
    with Path(path).open('rb') as f:
        for block in iter(lambda: f.read(1048576), b''):
            h.update(block)
    return h.hexdigest()


def sha_bytes(data):
    return hashlib.sha256(data).hexdigest()


def canonical(obj):
    return json.dumps(obj, sort_keys=True, separators=(',', ':'), allow_nan=False).encode()


def _pairs(rows):
    result = {}
    for k, v in rows:
        require(k not in result, 'duplicate JSON key: ' + k)
        result[k] = v
    return result


def read_json(path):
    def invalid(x):
        raise ValueError('nonfinite JSON constant: ' + x)
    def finite(x):
        n = float(x)
        require(math.isfinite(n), 'nonfinite JSON number')
        return n
    return json.loads(Path(path).read_bytes(), object_pairs_hook=_pairs,
                      parse_constant=invalid, parse_float=finite)


def contained(root, name):
    require(type(name) is str and name, 'missing relative file name')
    p = PurePosixPath(name)
    require(not p.is_absolute() and '..' not in p.parts and str(p) == name,
            'unnormalized relative path: ' + name)
    path = root / name
    require(path.resolve().is_relative_to(root.resolve()) and path.is_file(), 'missing/outside file: ' + name)
    # Symlink aliases are not admitted, including aliases to an internal file.
    require(not any((root / Path(*p.parts[:i])).is_symlink() for i in range(1, len(p.parts) + 1)),
            'symlink input forbidden: ' + name)
    return path


def verify(path, digest):
    require(type(digest) is str and re.fullmatch('[0-9a-f]{64}', digest), 'invalid SHA256')
    require(sha(path) == digest, 'hash mismatch: ' + str(path))
    return path


def check_pins(root, pins):
    require(type(pins) is dict and pins, 'empty pin inventory')
    for name, digest in pins.items():
        verify(contained(root, name), digest)


def frame_key(row):
    require(type(row) is dict, 'frame row must be object')
    require(type(row.get('reverse')) is bool, 'reverse must be a JSON boolean')
    key = (row.get('view'), row.get('case'), row['reverse'])
    require(key in KEYS, 'unexpected view/case/order')
    return key


def index_frames(rows):
    require(type(rows) is list and len(rows) == 20, 'exact all20 required')
    result = {}
    for row in rows:
        key = frame_key(row)
        require(key not in result, 'duplicate frame key')
        expected = 'private-partial/native-' + key[0] + '-' + key[1] + ('-reverse' if key[2] else '')
        require(row.get('prefix') == expected, 'frame prefix/key mismatch')
        result[key] = row
    require(set(result) == KEYS, 'missing all20 key')
    return result


def load_module(name, path):
    module = types.ModuleType(name)
    module.__file__ = str(path)
    exec(compile(path.read_bytes(), str(path), 'exec'), module.__dict__)
    return module


def compare_metadata(actual, declared, baseline, arm):
    require(canonical(actual) == canonical(declared), 'COMPLETED metadata differs from actual .json')
    require(set(actual) == set(baseline), 'metadata exact keyset differs from A2')
    for key in actual:
        value = actual[key]
        if key in TIMINGS:
            require(type(value) is int and value >= 0, 'invalid timing ' + key)
        elif arm == 'background' and key in OLD_WORK:
            require(type(value) is int and value == 0, 'background character work is not zero: ' + key)
        else:
            require(canonical(value) == canonical(baseline[key]), 'A2 metadata mismatch: ' + key)


def read_rgb(path):
    data = path.read_bytes()
    require(len(data) == 64800, 'wrong RGB565 size')
    a = np.frombuffer(data, '<u2').reshape(135, 240)
    return np.stack([(a >> 11) / 31, ((a >> 5) & 63) / 63, (a & 31) / 31], -1)


def read_depth(path, background=False):
    data = path.read_bytes()
    require(len(data) == 129600, 'wrong f32 depth size')
    a = np.frombuffer(data, '<f4').reshape(135, 240)
    require(not np.isnan(a).any() and not np.isposinf(a).any(), 'invalid character depth')
    require(np.isneginf(a).all() if background else np.isfinite(a).any(),
            'background control has character depth' if background else 'no finite character depth')
    return a


def target_mask(path):
    a = np.frombuffer(path.read_bytes(), np.uint8)
    require(a.size == 32400 and np.isin(a, (0, 1)).all(), 'invalid target mask')
    return a.reshape(135, 240).astype(bool)


class Admission:
    def __init__(self, workspace, trust_path, trust_sha, output_pins_path, output_pins_sha):
        require(__debug__, 'do not run with -O: frozen validators use assertions')
        self.workspace = workspace.resolve()
        self.trust = read_json(verify(trust_path, trust_sha))
        require(self.trust['version'] == 'camera-background-external-admission-v1', 'trust version')
        self.pins = read_json(verify(output_pins_path, output_pins_sha))
        require(self.pins['version'] == 'camera-background-completed-output-pins-v1', 'output pins version')
        self.trust_sha, self.output_pins_sha = trust_sha, output_pins_sha
        check_pins(self.workspace, self.trust['files'])
        check_pins(self.workspace, self.pins['files'])
        self.root = self.workspace / self.trust['preparedRoot']
        self.baseline = self.workspace / self.trust['baselineRoot']
        require(self.root.is_relative_to(self.workspace) and self.baseline.is_relative_to(self.workspace), 'root outside workspace')
        self.prepared = read_json(self.root / 'PREPARED.json')
        self.input_pins = read_json(self.root / 'input-hashes.json')
        check_pins(self.root, self.input_pins)
        require(self.prepared['inputsSHA256'] == sha(self.root / 'input-hashes.json'), 'PREPARED input pin mismatch')
        verify(self.root / 'native-render', self.prepared['binarySHA256'])
        require(self.prepared['oldWork8MFit'] is False and self.prepared['oldDirect1MFit'] is False and
                self.prepared['geometryAndFormalReferenceUnchanged'] is True, 'prepared scope mismatch')
        require(self.prepared['coreFreezeSHA256'] == sha(self.root / 'CORE_SOURCE_FREEZE.json') and
                self.prepared['planFreezeSHA256'] == sha(self.root / 'PLAN_FREEZE.json'), 'PREPARED source freeze mismatch')
        bd = read_json(self.baseline / 'COMPLETED.json')
        require(bd['status'] == 'ALL20_ACTUAL_COMPLETE' and bd['allForwardReverseRGBDepthExact'] is True and
                bd['sourceInputsUnchanged'] is True, 'A2 completion mismatch')
        self.base_rows = index_frames(bd['frames'])
        for row in self.base_rows.values():
            for ext, digest in row['files'].items():
                verify(contained(self.baseline, row['prefix'] + ext), digest)
            m = read_json(self.baseline / (row['prefix'] + '.json'))
            require(canonical(m) == canonical(row['metadata']), 'A2 metadata mismatch')
        self.fixed = {frame_key(r): r for r in read_json(self.root / 'private/BACKGROUND_INPUTS.json')['rows']}
        require(set(self.fixed) == KEYS, 'fixed input keyset mismatch')
        self.preflight = {frame_key(r): r for r in read_json(self.root / 'PREFLIGHT_CONTRACT.json')['arms']['A']['rows']}
        require(set(self.preflight) == KEYS, 'preflight keyset mismatch')
        self.core = read_json(self.root / 'CORE-WORK-DESIGN.json')
        self.aa = load_module('frozen_camera_aa_contract', self.root / 'code/aa_contract.py')
        self.bg = load_module('frozen_camera_background_contract', self.root / 'code/background_contract.py')
        self.loaded = {}

    def externally_pinned(self, path):
        name = str(path.relative_to(self.workspace))
        require(name in self.pins['files'], 'output absent from external inventory: ' + name)
        return verify(path, self.pins['files'][name])

    def load(self, arm):
        require(arm in ('off', 'on', 'background'), 'unsupported arm')
        if arm in self.loaded:
            return self.loaded[arm]
        if arm != 'off':
            self.load('off')
        root = self.root / ARM_DIR[arm]
        require(not (root / 'FAILED.json').exists() and not (root / 'REJECTED.json').exists(), 'failed/rejected arm cannot score')
        done_path = self.externally_pinned(root / 'COMPLETED.json')
        done = read_json(done_path)
        require(set(done) == {'status', 'arm', 'frames', 'oldA2BuffersExact', 'characterDepthAndRawHDRExact',
                'allForwardReverseRGBDepthExact', 'sourceInputsUnchanged', 'inputHashesSHA256', 'binarySHA256', 'contract'},
                'COMPLETED exact keyset mismatch')
        require(done['status'] == 'ALL20_ACTUAL_COMPLETE' and done['arm'] == arm, 'not a complete matching arm')
        require(done['oldA2BuffersExact'] is (arm == 'off') and done['characterDepthAndRawHDRExact'] is (arm != 'background'), 'false completion provenance')
        require(done['allForwardReverseRGBDepthExact'] is True and done['sourceInputsUnchanged'] is True, 'incomplete consistency gates')
        require(done['inputHashesSHA256'] == sha(self.root / 'input-hashes.json') and
                done['binarySHA256'] == self.prepared['binarySHA256'], 'completion input identity mismatch')
        require(done['contract'] == 'independent-camera-floor-scene-composition; old1M-and8M-FAIL; separate-host-background-budgets', 'unexpected arm contract')
        rows = index_frames(done['frames'])
        frames = {}
        for key, row in rows.items():
            require(set(row) == {'view', 'case', 'reverse', 'prefix', 'metadata', 'files'}, 'frame exact keyset mismatch')
            exts = EXTS | ({'.background.json', '.background.jsonl'} if arm != 'off' else set())
            require(set(row['files']) == exts, 'frame output exact keyset mismatch')
            for ext, digest in row['files'].items():
                verify(self.externally_pinned(contained(root, row['prefix'] + ext)), digest)
            base = self.base_rows[key]
            stem = root / row['prefix']
            old = self.baseline / base['prefix']
            path = lambda ext: Path(str(stem) + ext)
            m = read_json(path('.json'))
            compare_metadata(m, row['metadata'], base['metadata'], arm)
            require(type(m['reverse']) is bool and m['reverse'] == key[2], 'metadata order mismatch')
            for ext in ('.snapshot', '.targets.u8'):
                require(path(ext).read_bytes() == Path(str(old) + ext).read_bytes(), 'A2 preserved file mismatch: ' + ext)
            target = target_mask(path('.targets.u8'))
            require(int(target.sum()) == (2385 if key[0] == 'front' else 2391), 'target count mismatch')
            depth = read_depth(path('.f32le'), arm == 'background')
            if arm != 'background':
                for ext in ('.f32le', '.samples.jsonl'):
                    require(path(ext).read_bytes() == Path(str(old) + ext).read_bytes(), 'character provenance mismatch: ' + ext)
                self.aa.validate(read_json(path('.aa.json')),
                    list(map(int, (self.root / ('ledger-' + key[0] + '.txt')).read_text().split())),
                    int(target.sum()), '912ba9aa3cfbfb2c', self.preflight[key]['sampleHits'], m['visibilitySnapshotFingerprint'])
            else:
                require(path('.samples.jsonl').stat().st_size == 0, 'background-only has character samples')
            if arm == 'off':
                require(path('.u16le').read_bytes() == Path(str(old) + '.u16le').read_bytes(), 'OFF differs from A2 RGB')
            else:
                self.bg.validate(read_json(path('.background.json')), m, self.fixed[key], arm,
                                 self.core, sha(self.root / 'private/BACKGROUND_INPUTS.json'))
            frames[key] = {'rgb': read_rgb(path('.u16le')), 'depth': depth, 'row': row}
        for v in VIEWS:
            for c in CASES:
                a, b = rows[(v, c, False)], rows[(v, c, True)]
                for ext in ('.u16le', '.f32le'):
                    require(a['files'][ext] == b['files'][ext], 'forward/reverse output mismatch')
                require(np.array_equal(frames[(v, c, False)]['depth'], frames[(v, 'baseline', False)]['depth']), 'case-dependent character shape')
        if arm != 'off':
            self.validate_composition_audit(arm, rows)
        result = {'arm': arm, 'frames': frames, 'rows': rows, 'completionSHA256': sha(done_path)}
        self.loaded[arm] = result
        return result

    def validate_composition_audit(self, arm, rows):
        audit = read_json(self.externally_pinned(self.root / ARM_DIR[arm] / 'COMPOSITION_AUDIT.json'))
        require(audit['status'] == 'ALL20_EXACT' and audit['shapeNotInferredFromSceneRGB'] is True,
                'composition audit missing exact gate')
        code = contained(self.workspace, self.pins['compositionAuditCode'])
        encoder = contained(self.workspace, self.pins['compositionEncoder'])
        self.externally_pinned(code)
        self.externally_pinned(encoder)
        require(sha(encoder) == audit['encoderSHA256'], 'composition encoder hash mismatch')
        require(sha(code) == audit['auditSourceSHA256'], 'composition audit source hash mismatch')
        require(type(audit['frames']) is list and len(audit['frames']) == 20, 'composition audit incomplete')
        seen = set()
        for a in audit['frames']:
            key = frame_key(a)
            require(key not in seen, 'duplicate composition audit row')
            seen.add(key)
            row, fixed = rows[key], self.fixed[key]
            for k in ('completeUniqueDomain', 'all565Exact'):
                require(a[k] is True, 'composition audit failed ' + k)
            require(a['characterDepthRetained'] is (arm == 'on') and a['rawCharacterHDRExact'] is (arm == 'on'), 'composition character claim mismatch')
            for field, ext in [('sampleFileSHA256', '.samples.jsonl'), ('compositionFileSHA256', '.background.jsonl'), ('targetsSHA256', '.targets.u8')]:
                require(a[field] == row['files'][ext], 'composition audit/output hash mismatch')
            floor = fixed['runtimeSlots'] if arm == 'background' else fixed['combinedEmptySlots'] + fixed['expectedFinalFloorOverrides']
            expected = {'keep': fixed['runtimeSlots'] - floor, 'floor': floor, 'world': 0,
                        'characterOverrides': fixed['expectedFinalFloorOverrides'] if arm == 'on' else 0}
            require(canonical(a['counts']) == canonical(expected), 'composition audited domain count mismatch')
        require(seen == KEYS, 'composition audit domain mismatch')

    def recheck(self):
        check_pins(self.workspace, self.trust['files'])
        check_pins(self.workspace, self.pins['files'])
        check_pins(self.root, self.input_pins)
        verify(self.root / 'native-render', self.prepared['binarySHA256'])


def load_formal(admission):
    path = admission.workspace / admission.trust['formalScorer']
    # These imports are pinned in TRUST_INPUTS and never write bytecode.
    dependency_dir = path.parent.parent / 'code'
    for name in ('geometry_certificate', 'codec_audit'):
        sys.modules[name] = load_module(name, dependency_dir / (name + '.py'))
    S = load_module('frozen_formal_v3_scene', path)
    ref = S.load_reference(admission.workspace / admission.trust['referenceRoot'])
    require(tuple(S.VIEWS) == VIEWS and tuple(S.CASES) == CASES, 'formal domain changed')
    require(ref['evaluator'].T == 2 / 255 and ref['evaluator'].N == 8, 'formal numeric contract changed')
    return S, ref


def fixed_domains(admission, ref):
    domains, summaries = {}, {}
    attribution = read_json(admission.workspace / 'fox-v3-aa-response-attribution/analysis.json')
    for view in VIEWS:
        row = admission.base_rows[(view, 'baseline', False)]
        stem = admission.baseline / row['prefix']
        covered = np.isfinite(read_depth(Path(str(stem) + '.f32le')))
        target = target_mask(Path(str(stem) + '.targets.u8'))
        winners = read_json(admission.workspace / ('fox-v3-lid-transport-point-audit/verified-winners-v2/' + view + '-baseline.json'))
        ids = np.full((135, 240), -1, dtype=np.int64)
        seen = set()
        for p in winners['points']:
            key = (p['x'], p['y'])
            require(key not in seen and 0 <= key[0] < 240 and 0 <= key[1] < 135, 'invalid frozen center winner')
            seen.add(key)
            ids[key[1], key[0]] = p['sourceObjectId']
        require(np.array_equal(covered, ids >= 0), 'A2 center coverage differs from original attribution')
        pad = np.pad(ids, 1, constant_values=-1)
        derived_target = np.logical_or.reduce([ids != pad[1 + dy:136 + dy, 1 + dx:241 + dx]
                                               for dx, dy in [(1, 0), (-1, 0), (0, 1), (0, -1)]])
        require(np.array_equal(target, derived_target), 'A2 target differs from original attribution')
        alpha = ref['alphas'][view]
        fg = ref['foreground'][view]
        ds = {'fullFrame': np.ones(fg.shape, bool), 'background': ~fg, 'fullForeground': fg,
              'opaqueAlpha': alpha == 255, 'partialAlpha': (alpha > 0) & (alpha < 255),
              'centerCovered': fg & covered, 'centerMissing': fg & ~covered,
              'coveredBoundary': fg & covered & target, 'coveredInterior': fg & covered & ~target,
              'missingBoundary': fg & ~covered & target, 'missingNonTarget': fg & ~covered & ~target,
              'opaqueCoveredInterior': (alpha == 255) & covered & ~target,
              'opaqueCoveredBoundary': (alpha == 255) & covered & target}
        for name in ('fullForeground', 'opaqueAlpha', 'partialAlpha', 'centerCovered', 'centerMissing', 'coveredBoundary', 'coveredInterior', 'missingBoundary', 'missingNonTarget'):
            old = attribution['views'][view]['direction']['on'][name]
            require(int(ds[name].sum()) == old['pixels'], 'original attribution domain count changed: ' + name)
        domains[view] = ds
        summaries[view] = {name: {'pixels': int(mask.sum()), 'sha256BooleanRowMajorU8': sha_bytes(mask.astype(np.uint8).tobytes())}
                           for name, mask in ds.items()}
    return domains, summaries


def error_summary(reference, candidate, mask):
    if not mask.any():
        return {'pixels': 0, 'status': 'N/A_NOT_PASS', 'rgbMAE': None, 'rgbRMSE': None,
                'signedRGBMeanCandidateMinusReference': None, 'signedLumaMeanCandidateMinusReference': None}
    e = (candidate - reference)[mask]
    return {'pixels': int(mask.sum()), 'status': 'DESCRIPTIVE_ONLY_NOT_ACCEPTANCE',
            'rgbMAE': float(abs(e).mean()), 'rgbRMSE': float(np.sqrt(np.mean(e * e))),
            'signedRGBMeanCandidateMinusReference': e.mean(0).tolist(),
            'signedLumaMeanCandidateMinusReference': float((e @ LUMA).mean())}


def response_confusion(st, delta, mask, threshold):
    labels = {'bright': delta > threshold, 'dark': delta < -threshold, 'inactive': abs(delta) <= threshold}
    conf = {r: {c: int((mask & st[r] & labels[c]).sum()) for c in labels}
            for r in ('bright', 'dark', 'inactive', 'uncertain')}
    stable, unknown = mask & st['stable'], mask & st['uncertain']
    require(sum(sum(row.values()) for row in conf.values()) == int(mask.sum()), 'confusion domain not exhaustive')
    active = mask & (st['bright'] | st['dark'])
    return {'pixels': int(mask.sum()), 'status': 'DESCRIPTIVE_ONLY_NOT_ACCEPTANCE', 'confusion': conf,
            'stable': int(stable.sum()), 'unknown': int(unknown.sum()), 'unknownCountedAsPass': False,
            'activeToInactive': conf['bright']['inactive'] + conf['dark']['inactive'],
            'reverse': conf['bright']['dark'] + conf['dark']['bright'],
            'brightFN': conf['bright']['dark'] + conf['bright']['inactive'],
            'darkFN': conf['dark']['bright'] + conf['dark']['inactive'],
            'brightFP': conf['dark']['bright'] + conf['inactive']['bright'],
            'darkFP': conf['bright']['dark'] + conf['inactive']['dark'],
            'inactiveFP': conf['inactive']['bright'] + conf['inactive']['dark'],
            'stableLumaAbsErrorSum': float(abs(delta[stable] - st['mean'][stable]).sum()),
            'activeReferenceAbsResponseSum': float(abs(st['mean'][active]).sum()),
            'activeCandidateAbsResponseSum': float(abs(delta[active]).sum()),
            'unknownCandidateClassCounts': conf['uncertain']}


def describe(ref, frames, domains):
    E = ref['evaluator']
    results = {}
    for view in VIEWS:
        base = frames[(view, 'baseline', False)]['rgb']
        for case in CASES:
            samples = ref['arrays'][(view, case)]
            rgb = frames[(view, case, False)]['rgb']
            means = (samples.astype(np.float64) / 255).mean(0)
            color_st = E.classify_color(samples.astype(np.float64) / 255)
            if case != 'baseline':
                samples0 = ref['arrays'][(view, 'baseline')]
                st = E.classify_png8(samples0, samples)
                delta = (rgb - base) @ LUMA
            item = {}
            for name, mask in domains[view].items():
                cs = {'all': error_summary(means, rgb, mask),
                      'stable': error_summary(means, rgb, mask & color_st['stable']),
                      'unknown': error_summary(means, rgb, mask & color_st['uncertain']),
                      'eachReferenceSeed': [error_summary(a.astype(np.float64) / 255, rgb, mask) for a in samples]}
                entry = {'color': cs, 'response': {'status': 'N/A_BASELINE_NO_CONTRAST'}}
                if case != 'baseline':
                    # Reuse the exact frozen numerical evaluator, then strip subset PASS claims.
                    r, _ = E.evaluate_response_png8(samples0, samples, mask, base, rgb)
                    entry['response'] = {'confusionAndUnknown': response_confusion(st, delta, mask, E.T),
                        'metrics': E.descriptive_only(r['candidateScores']),
                        'signedRGBDeltaError': error_summary((samples.astype(np.float64) / 255).mean(0) - (samples0.astype(np.float64) / 255).mean(0),
                                                           rgb - base, mask)}
                item[name] = entry
            results[view + '-' + case] = item
    return {'scope': 'DESCRIPTIVE_ONLY_NOT_ACCEPTANCE', 'sixtyPercentGoal': 'NOT_ESTABLISHED',
            'aggregationIntoFormalScore': False, 'conditions': results}


def formal_score(S, ref, admitted, admission):
    arm = admitted['arm']
    require(arm in ('off', 'on'), 'background-only control is never a formal candidate')
    manifest = {'schemaVersion': 'host-camera-floor-scene-composition-v1',
        'candidate': {'label': 'lid8-A2-camera-background-' + arm, 'sourceGeometryUnchanged': True,
                      'formalCharacterDepthRetained': True, 'sceneRGBOutsideCharacterDepthAllowed': arm == 'on',
                      'oldWork8MFit': False, 'oldDirect1MFit': False},
        'externalTrustSHA256': admission.trust_sha, 'externalOutputPinsSHA256': admission.output_pins_sha,
        'runtimeCompleteSHA256': admitted['completionSHA256'], 'referenceThresholdsUnchanged': True,
        'strictLoaderSHA256': sha(Path(__file__)), 'frozenScoreSHA256': sha(admission.workspace / admission.trust['formalScorer']),
        'frames': [admitted['rows'][(v, c, False)] for v in VIEWS for c in CASES]}
    candidate = {'frames': {(v, c): admitted['frames'][(v, c, False)] for v in VIEWS for c in CASES},
                 'manifest': manifest, 'manifestSHA256': sha_bytes(canonical(manifest))}
    result, _ = S.score(ref, candidate)
    require(result['sixtyPercentGoal'] == 'NOT_ESTABLISHED_CONDITIONAL_METRICS_ONLY' and
            result['globalAcceptance'] == 'NOT_ESTABLISHED', 'formal acceptance scope changed')
    return result


def numeric_conditions(result):
    return {key: {k: v for k, v in value.items() if k != 'candidateMetadata'}
            for key, value in result['conditions'].items()}


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--workspace', type=Path, default=HERE.parents[1])
    parser.add_argument('--trust', type=Path, default=HERE / 'TRUST_INPUTS.json')
    parser.add_argument('--trust-sha256', required=True)
    parser.add_argument('--output-pins', type=Path, required=True)
    parser.add_argument('--output-pins-sha256', required=True)
    parser.add_argument('--arms', nargs='+', choices=['off', 'on', 'background'], required=True)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--admit-only', action='store_true')
    args = parser.parse_args(argv)
    output = args.output.resolve()
    require(not args.output.exists() and not args.output.is_symlink(), 'fresh output directory required')
    require(output.is_relative_to(HERE) and output != HERE, 'output must be a fresh directory under analysis-code')
    require(len(args.arms) == len(set(args.arms)), 'duplicate requested arm')
    A = Admission(args.workspace, args.trust, args.trust_sha256, args.output_pins, args.output_pins_sha256)
    loaded = {arm: A.load(arm) for arm in args.arms}
    reports = {'ADMISSION.json': {'status': 'STRICT_COMPLETE_INPUTS_AND_OUTPUTS_ADMITTED',
        'trustSHA256': args.trust_sha256, 'outputPinsSHA256': args.output_pins_sha256,
        'loaderSHA256': sha(Path(__file__)), 'arms': {arm: value['completionSHA256'] for arm, value in loaded.items()},
        'backgroundControlNeverFormal': True, 'sourceInputsUnchanged': True,
        'oldWork8MFit': False, 'oldDirect1MFit': False}}
    if not args.admit_only:
        S, ref = load_formal(A)
        domains, domain_summary = fixed_domains(A, ref)
        reports['FIXED_DOMAINS.json'] = {'status': 'FIXED_GEOMETRY_REFERENCE_ONLY', 'views': domain_summary,
            'foregroundEdge': 'partialAlpha (1..254); coveredBoundary is the separately named native target boundary',
            'originalAttributionDefinitionSHA256': A.trust['files']['fox-v3-aa-response-attribution/analyze.py']}
        formal = {}
        for arm, admitted in loaded.items():
            if arm in ('off', 'on'):
                formal[arm] = formal_score(S, ref, admitted, A)
                reports['formal-' + arm + '.json'] = formal[arm]
            reports['descriptive-' + arm + '.json'] = describe(ref, admitted['frames'], domains)
        if 'off' in formal:
            prior = read_json(A.baseline / 'score-v3/evaluation.json')
            require(canonical(numeric_conditions(formal['off'])) == canonical(numeric_conditions(prior)),
                    'OFF formal numeric results differ from unchanged actual-A2 scoring')
            reports['OFF_A2_PARITY.json'] = {'status': 'ALL10_FORMAL_NUMERIC_EXACT', 'candidateMetadataTimingExcluded': True}
        if 'off' in formal and 'on' in formal:
            for key in formal['off']['conditions']:
                require(formal['off']['conditions'][key]['shapeFullFrame'] == formal['on']['conditions'][key]['shapeFullFrame'],
                        'formal character shape changed')
            reports['SHAPE_PARITY.json'] = {'status': 'ALL10_CHARACTER_SHAPE_EXACT', 'sceneFillIsNotGeometryRepair': True}
    A.recheck()
    output.mkdir()
    inventory = {}
    for name, obj in reports.items():
        path = output / name
        path.write_text(json.dumps(obj, indent=2, allow_nan=False) + '\n')
        inventory[name] = {'sha256': sha(path), 'bytes': path.stat().st_size}
    A.recheck()
    (output / 'COMPLETED.json').write_text(json.dumps({'status': 'ANALYSIS_COMPLETE_NOT_GLOBAL_ACCEPTANCE',
        'files': inventory, 'codeReportOnly': True, 'noReferenceSourceOrRawImageCopy': True}, indent=2) + '\n')
    print('STRICT_SCENE_ANALYSIS_COMPLETE', ','.join(args.arms), output)


if __name__ == '__main__':
    main()
