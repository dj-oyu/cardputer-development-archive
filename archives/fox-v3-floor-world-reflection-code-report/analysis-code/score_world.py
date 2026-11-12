#!/usr/bin/env python3
"""Read-only, fail-closed all10 world-reflection scoring at fixed floor/background/AgX."""
from __future__ import annotations
import argparse
from collections import Counter
import gzip
import hashlib
import json
from pathlib import Path
import sys
import types
import numpy as np
sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
ROOT, W = HERE.parent, HERE.parent.parent
PRIOR = W / 'fox-v3-floor-display-combination'
PRIOR_ANALYSIS = PRIOR / 'analysis-code/analysis-001'
PRIOR_SCORER_SHA = '2855c6e4bab2ceb891804f9e03ce4127a5cfaeb0c75837d45e4040824cec74b7'
PRIOR_OUTPUT_SHA = '6b62d1f36d62ed2714e585ed33ba8e52527f34a79bb817589909641392797df6'
PRIOR_ANALYSIS_SHA = '9a6683ced5b2d3303927ac79ebc013fdef8973b7e1b9809735daeacbb26fe381'
p = PRIOR / 'analysis-code/score_combination.py'
if p.is_symlink() or hashlib.sha256(p.read_bytes()).hexdigest() != PRIOR_SCORER_SHA:
    raise ValueError('immutable previous metric loader changed')
C = types.ModuleType('immutable_floor_metric_helpers')
C.__file__ = str(p)
exec(compile(p.read_bytes(), str(p), 'exec'), C.__dict__)
H, O, D, M = C.H, C.O, C.D, C.M
require, sha, verify, read_json = O.require, O.sha, O.verify, O.read_json
TIMINGS = C.TIMINGS


class Pins:
    """Remember verified inputs; reject conflicting hashes and changes during scoring."""
    def __init__(self):
        self.files = {}

    def check(self, path, digest):
        path = Path(path)
        require(path.is_absolute() and path.is_relative_to(W) and '..' not in path.parts,
                'pin outside normalized workspace')
        path = O.contained(W, str(path.relative_to(W)))
        if str(path) in self.files:
            require(self.files[str(path)] == digest, 'conflicting input pin: ' + str(path))
        verify(path, digest)
        self.files[str(path)] = digest
        return path

    def json(self, path, digest):
        return read_json(self.check(path, digest))

    def inventory(self, path, digest):
        obj = self.json(path, digest)
        raw = obj.get('files', obj)
        require(type(raw) is dict and raw, 'nonempty pin map required')
        for name, value in raw.items():
            p = Path(name)
            p = p if p.is_absolute() else W / p
            self.check(p, value if type(value) is str else value['sha256'])
        return obj

    def recheck(self):
        H.recheck(self.files)


def fail_markers(root):
    C.fail_markers(root)


def prior_admission(pins):
    pins.inventory(PRIOR / 'OUTPUT_PINS.json', PRIOR_OUTPUT_SHA)
    done = pins.json(PRIOR_ANALYSIS / 'COMPLETED.json', PRIOR_ANALYSIS_SHA)
    require(done['status'] == 'FLOOR_DISPLAY_METRICS_COMPLETE_NOT_GLOBAL_ACCEPTANCE'
            and done['codeAggregateOnly'] is True, 'previous analysis incomplete')
    for name, item in done['files'].items():
        p = pins.check(O.contained(PRIOR_ANALYSIS, name), item['sha256'])
        require(p.stat().st_size == item['bytes'], 'prior aggregate size mismatch')
    archive = read_json(PRIOR_ANALYSIS / 'AGGREGATE_ARCHIVE_MANIFEST.json')
    out = {}
    for row in archive['entries']:
        raw = gzip.decompress(pins.check(PRIOR_ANALYSIS / row['gzipPath'], row['gzipSHA256']).read_bytes())
        require(len(raw) == row['decompressedBytes'] and O.sha_bytes(raw) == row['decompressedSHA256'],
                'prior aggregate decompression mismatch')
        out[row['restorePath']] = json.loads(raw)
    require({'FORMAL_ON.json', 'DESCRIPTIVE_ON.json', 'COMPARISON.json', 'SCALAR_AUDIT.json'} == set(out),
            'prior aggregate set changed')
    return out


def manifest_inventory(args, pins):
    obj = pins.inventory(args.completion_pins, args.completion_pins_sha256)
    expected = {str(ROOT / d / 'COMPLETED.json') for d in ('capture/off', 'capture/on', 'composed-off', 'composed-on')}
    actual = {str(Path(k) if Path(k).is_absolute() else W / k) for k in obj['files']}
    require(expected <= actual, 'all four completed manifests must be externally pinned')
    for directory in (ROOT, ROOT / 'capture', *(ROOT / x for x in ('capture/off', 'capture/on', 'composed-off', 'composed-on'))):
        fail_markers(directory)
    return obj


def score(S, ref, frames, arm, args):
    manifest = {'schemaVersion': 'single-floor-world-fixed-background-agx-v1',
        'candidate': {'label': 'world-' + arm + '-floor-direct-on-same-background-AgX',
            'sourceGeometryUnchanged': True, 'formalCharacterDepthRetained': True,
            'sceneRGBOutsideCharacterDepthAllowed': True, 'singleContrastNotAdditivityProof': True,
            'oldWork8MFit': False, 'oldDirect1MFit': False},
        'completionPinsSHA256': args.completion_pins_sha256,
        'runtimeCompleteSHA256': sha(ROOT / ('composed-' + arm) / 'COMPLETED.json'),
        'loaderSHA256': sha(Path(__file__)), 'formalScorerSHA256': sha(Path(S.__file__)),
        'referenceThresholdsUnchanged': True, 'noExcludedPixels': True,
        'frames': [frames[(v, c, False)]['row'] for v in O.VIEWS for c in O.CASES]}
    result, _ = S.score(ref, {'frames': {(v, c): frames[(v, c, False)] for v in O.VIEWS for c in O.CASES},
        'manifest': manifest, 'manifestSHA256': O.sha_bytes(O.canonical(manifest))})
    require(result['sixtyPercentGoal'] == 'NOT_ESTABLISHED_CONDITIONAL_METRICS_ONLY'
            and result['globalAcceptance'] == 'NOT_ESTABLISHED', 'global acceptance scope changed')
    return result


def numeric(formal):
    def compact(value):
        if isinstance(value, dict):
            return {key: ({'entries': len(item), 'sha256CanonicalJSON': O.sha_bytes(O.canonical(item)),
                    'fixedReferenceDiagnosticNotCopied': True} if key in
                    ('uncertainLocationsYX', 'uncertainSignFrequencyAtLocations') and isinstance(item, list)
                    else compact(item)) for key, item in value.items()}
        if isinstance(value, list):
            return [compact(item) for item in value]
        return value
    return compact(O.numeric_conditions(formal))


def off_byte_gate(rows, pins):
    """Complete all10 control checks before alternate RGB loading or scoring."""
    previous = D.ten_rows(read_json(PRIOR / 'composed-on/COMPLETED.json')['frames'])
    for key, row in rows.items():
        old = previous[key]
        require(row['hdr'] == old['hdr'], 'OFF HDR name differs')
        p = pins.check(O.contained(ROOT / 'composed-off', row['hdr']), row['hdrSHA256'])
        q = pins.check(O.contained(PRIOR / 'composed-on', old['hdr']), old['hdrSHA256'])
        require(p.read_bytes() == q.read_bytes(), 'OFF HDR differs from completed floor ON')
        require(set(row['outputs']) == {'legacy', 'agx'}, 'OFF display profiles changed')
        for profile in ('legacy', 'agx'):
            a, b = row['outputs'][profile], old['outputs'][profile]
            p = pins.check(O.contained(ROOT / 'composed-off', a['path']), a['sha256'])
            q = pins.check(O.contained(PRIOR / 'composed-on', b['path']), b['sha256'])
            require(p.read_bytes() == q.read_bytes(), 'OFF ' + profile + ' differs from completed floor ON')
        require(row['characterDepthSHA256'] == old['characterDepthSHA256'] and
                row['targetSHA256'] == old['targetSHA256'], 'OFF character shape differs')
        for field in ('events', 'actionCounts', 'floorOverrides'):
            require(row[field] == old[field], 'OFF composition domain differs: ' + field)


def summarize(formal, descriptive, flags, domains):
    result = C.summarize(formal, descriptive, flags, domains)
    result['status'] = 'SINGLE_WORLD_REFLECTION_FIXED_FLOOR_BACKGROUND_DISPLAY_CONTRAST_NOT_GLOBAL_ACCEPTANCE'
    result['scope'] = ('World ON minus OFF with floor direct reflection ON and identical background/profile. '
        'Nonlinear display interaction remains; no additive decomposition, default adoption or global acceptance claim.')
    result['ambientColorTradeoff'] = {}
    for view in O.VIEWS:
        row = {}
        for arm in ('off', 'on'):
            r = formal[arm]['conditions'][view + '-ambient']['response']['candidateScores']['stableSubset']
            c = descriptive[arm]['conditions'][view + '-ambient']['fullForeground']['response']['confusionAndUnknown']
            row[arm] = {'colorAll10FullForegroundRMSE': {k: v['colorMeanPrecision']['candidateScores']['pooledFullForegroundDescriptive']['rgbRMSE']
                        for k, v in formal[arm]['conditions'].items() if k.startswith(view + '-')},
                'ambientDirectionAgreementPercent': r['directionAgreementPercent'],
                'ambientMagnitudeAgreementPercent': r['responseMagnitudeAgreementPercent'],
                'ambientDeltaRGBRMSE': r['deltaRGBRMSE'], 'ambientDeltaLumaRMSE': r['deltaLumaRMSE'],
                'ambientBrightIoU': r['brightening']['IoU'], 'ambientDarkIoU': r['darkening']['IoU'],
                'ambientConfusion': c,
                'baselineSignedLumaError': descriptive[arm]['conditions'][view + '-baseline']['fullForeground']['color']['all']['signedLumaMeanCandidateMinusReference']}
        result['ambientColorTradeoff'][view] = row
    return result


def fmt(value):
    return 'N/A' if value is None else format(value, '.9g')


def markdown(result, audit):
    lines = ['# Floor-world OFF versus ON at fixed floor-direct/background/AgX', '',
        'World OFF independently reproduces all ten completed prior floor-ON HDR, legacy RGB565 and AgX RGB565 buffers and original formal values. Both new arms retain original character-only depth, reference, thresholds and all fixed domains.', '',
        'This is one fixed contrast, not global acceptance, additivity, source Principled equivalence, device fit or default adoption. Unknown and undefined values are not passes. No domain-clamp or endpoint flags exclude pixels.', '',
        '## All10 color errors', '', 'Cells are world OFF → ON. All errors are normalized RGB pixel×channel means.', '',
        '| Condition | Stable MAE | Stable RMSE | Uncertain MAE | Uncertain RMSE | FullFG MAE | FullFG RMSE |',
        '|---|---:|---:|---:|---:|---:|---:|']
    for key, arms in result['all10Color'].items():
        values = [' → '.join(fmt(arms[a][s][m]) for a in ('off', 'on'))
            for s in ('stableSubset', 'uncertainSubsetDescriptiveNotAcceptance', 'pooledFullForegroundDescriptive')
            for m in ('rgbMAE', 'rgbRMSE')]
        lines.append('| ' + key + ' | ' + ' | '.join(values) + ' |')
    lines += ['', '## All8 formal stable response', '',
        '| Contrast | Direction % | Magnitude % | Bright IoU | Dark IoU | Δ RGB RMSE | Δ Luma RMSE |',
        '|---|---:|---:|---:|---:|---:|---:|']
    for key, arms in result['all8Response'].items():
        cells = []
        for path in [('directionAgreementPercent',), ('responseMagnitudeAgreementPercent',),
                     ('brightening', 'IoU'), ('darkening', 'IoU'), ('deltaRGBRMSE',), ('deltaLumaRMSE',)]:
            vals = []
            for a in ('off', 'on'):
                val = arms[a]['scores']['stableSubset']
                for name in path:
                    val = val[name]
                vals.append(fmt(val))
            cells.append(' → '.join(vals))
        lines.append('| ' + key + ' | ' + ' | '.join(cells) + ' |')
    lines += ['', '## All8 full-foreground confusion', '',
        'These counts retain stable reference classes and report reference-uncertain pixels separately.', '',
        '| Contrast | Bright FP | Bright FN | Dark FP | Dark FN | Reverse | Active→inactive | Inactive FP | Unknown |',
        '|---|---:|---:|---:|---:|---:|---:|---:|---:|']
    for key, arms in result['all8Response'].items():
        cells = [' → '.join(str(arms[a]['fullForegroundConfusion'][field]) for a in ('off', 'on'))
            for field in ('brightFP', 'brightFN', 'darkFP', 'darkFN', 'reverse', 'activeToInactive', 'inactiveFP', 'unknown')]
        lines.append('| ' + key + ' | ' + ' | '.join(cells) + ' |')
    lines += ['', '## Ambient/color tradeoff', '']
    for view, row in result['ambientColorTradeoff'].items():
        for name in ('ambientDirectionAgreementPercent', 'ambientMagnitudeAgreementPercent', 'ambientBrightIoU',
                     'ambientDeltaRGBRMSE', 'ambientDeltaLumaRMSE', 'baselineSignedLumaError'):
            lines.append('- ' + view + ' ' + name + ': ' + ' → '.join(fmt(row[a][name]) for a in ('off', 'on')) + '.')
    lines += ['', '## Completeness and limits', '',
        '- Conditional status counts: ' + json.dumps(result['conditionalStatusCounts'], sort_keys=True) + '.',
        '- Scalar regressions: ' + str(len(audit['regressions'])) + '. They are overlapping diagnostic scalars, not independent tests or votes.',
        '- Complete saved aggregates retain all 13 domains, stable/uncertain/full-foreground values, eight reference seeds, every confusion class and every scalar regression. Formal per-pixel uncertainty locations are stored only as counts and hashes.',
        '- Character shape is unchanged; reflected lighting does not restore missing geometry. Original resource-budget failures are not reclassified. Reverse render controls are historical unless independently reported elsewhere.',
        '- Profile-domain clamp is separate from quantized channel endpoints; endpoint flags do not exclude pixels.', '']
    return '\n'.join(lines)


def write_aggregates(output, aggregates, admission, domains, report):
    require(not output.exists() and output.is_relative_to(HERE) and output != HERE, 'fresh analysis output required')
    output.mkdir()
    archive_rows = []
    for name, obj in aggregates.items():
        raw = O.canonical(obj) + b'\n'
        encoded = gzip.compress(raw, compresslevel=9, mtime=0)
        require(gzip.decompress(encoded) == raw, 'aggregate gzip roundtrip failed')
        (output / (name + '.gz')).write_bytes(encoded)
        archive_rows.append({'gzipPath': name + '.gz', 'gzipSHA256': O.sha_bytes(encoded), 'gzipBytes': len(encoded),
            'restorePath': name, 'decompressedSHA256': O.sha_bytes(raw), 'decompressedBytes': len(raw)})
    H.compact_write(output / 'AGGREGATE_ARCHIVE_MANIFEST.json', {'entries': archive_rows,
        'deterministicGzipMtime': 0, 'noRawPixelsHDRMasksGeometryOrLUTAssets': True})
    H.compact_write(output / 'ADMISSION.json', admission)
    H.compact_write(output / 'FIXED_DOMAINS.json', domains)
    (output / 'REPORT.md').write_text(report)


def admit_captures(pins, args):
    capture = ROOT / 'capture'
    fr = pins.json(capture / 'SOURCE_FREEZE.json', args.source_freeze_sha256)
    require(fr['baseInputsUnchanged'] is True and fr['baselineSourceFreezeSHA256'] ==
            '707ff996127d0cb1c0ea7756269e9737417f79d5928f55da2e919696d75763db', 'source baseline changed')
    require(fr['flags'] == ['-std=c11', '-O2', '-Wall', '-Wextra', '-Werror', '-Wno-misleading-indentation',
            '-ffp-contract=off', '-fexcess-precision=standard', '-DFOX_FLOOR_WORLD_CAPTURE=1', '-fstack-usage'],
            'numerical build flags changed')
    for name, digest in fr['files'].items():
        pins.check(O.contained(capture, name), digest)
    pins.check(capture / 'native-render', fr['binarySHA256'])
    baseline = pins.json(PRIOR / 'capture-001/CAPTURE_SOURCE_FREEZE.json',
        '707ff996127d0cb1c0ea7756269e9737417f79d5928f55da2e919696d75763db')
    expected_differences = {'product/main/ui/kasane/ksn_boundary_aa_center.inc', 'product/main/ui/kasane/ksn_mesh_depth.c',
        'transport/bounce.h', 'transport/bounce.c', 'transport/pixel_transport.c', 'transport/pixel_transport.h',
        'code/aa_adapter.h', 'code/native_render_v2.c'}
    require(set(fr['differences']) == expected_differences and fr['newFiles'] == ['code/floor_world_adapter.h'],
            'unexpected changed input scope')
    for name, digest in baseline['files'].items():
        require(name in fr['files'], 'baseline source file missing')
        if name not in expected_differences:
            require(fr['files'][name] == digest, 'non-feature baseline source changed: ' + name)
    old_rows = D.ten_rows(read_json(PRIOR / 'capture-001/on/COMPLETED.json')['frames'])
    expected_exts = {'.u16le', '.f32le', '.snapshot', '.targets.u8', '.samples.jsonl', '.aa.json', '.floor.json',
        '.json', '.center.f64le', '.center-capture.json', '.floor-world.json', '.world-center.f64le', '.world-observer.json'}
    result = {}
    for arm in ('off', 'on'):
        run = capture / arm
        done = read_json(run / 'COMPLETED.json')
        require(done['status'] == 'ALL10_FLOOR_WORLD_CAPTURE_COMPLETE' and done['arm'] == arm and
                done['sourceFreezeSHA256'] == args.source_freeze_sha256 and done['allInputsUnchanged'] is True and
                done['all10OldExact'] is (arm == 'off') and done['allOldCounterSemanticsExact'] is True and
                done['forwardOnly'] is True and done['oldReverseEvidenceNotFresh'] is True, 'capture scope incomplete')
        pins.inventory(run / 'INPUT_PINS.json', done['inputsSHA256'])
        rows = D.ten_rows(done['frames'])
        for key, row in rows.items():
            require(row['reverse'] is False and row['prefix'] == 'native-' + '-'.join(key) and
                row['oldNumericalBuffersExact'] is (arm == 'off') and row['oldCounterSemanticsExact'] is True and
                row['transportDeltaExactlyNewWorld'] is True, 'capture frame identity/scope mismatch')
            require(set(row['files']) == expected_exts, 'capture file set changed')
            oldrow = old_rows[key]
            prefix, oldprefix = run / row['prefix'], PRIOR / 'capture-001/on' / oldrow['prefix']
            for ext, digest in row['files'].items():
                pins.check(Path(str(prefix) + ext), digest)
            for ext in ('.f32le', '.snapshot', '.targets.u8', '.aa.json', '.center-capture.json'):
                require(row['files'][ext] == oldrow['files'][ext] and Path(str(prefix) + ext).read_bytes() ==
                        Path(str(oldprefix) + ext).read_bytes(), 'old capture shape/AA/observer changed')
            m, oldm = read_json(Path(str(prefix) + '.json')), read_json(Path(str(oldprefix) + '.json'))
            wr = read_json(Path(str(prefix) + '.floor-world.json'))
            require(wr == row['floorWorld'] and wr['complete'] is True and wr['enabled'] is (arm == 'on'),
                    'world accounting declaration mismatch')
            adjusted = dict(m)
            for wk, mk, limit in (('visibilityRays', 'transportRays', 20000000),
                    ('visibilityNodeVisits', 'transportNodeVisits', 800000000),
                    ('visibilityTriangleTests', 'transportTriangleTests', 300000000)):
                require(type(m[mk]) is int and 0 <= m[mk] <= limit and type(wr[wk]) is int and wr[wk] >= 0,
                        'invalid/over-budget transport count')
                adjusted[mk] -= wr[wk]
            ignore = TIMINGS | {'transportContextBytes'}
            require(set(m) == set(oldm) and {k: v for k, v in adjusted.items() if k not in ignore} ==
                    {k: v for k, v in oldm.items() if k not in ignore}, 'old non-timing counter semantics changed')
            require(all(type(m[k]) is int and m[k] >= 0 for k in TIMINGS), 'capture timing invalid')
            floor, oldfloor = read_json(Path(str(prefix) + '.floor.json')), read_json(Path(str(oldprefix) + '.floor.json'))
            require({k: v for k, v in floor.items() if k != 'contextBytes'} ==
                    {k: v for k, v in oldfloor.items() if k != 'contextBytes'}, 'old floor work changed')
            if arm == 'off':
                for ext in ('.u16le', '.samples.jsonl', '.center.f64le'):
                    require(Path(str(prefix) + ext).read_bytes() == Path(str(oldprefix) + ext).read_bytes(),
                            'OFF numerical capture differs from completed floor ON')
                require(wr['workUsed'] == wr['queries'] == 0, 'OFF world work is nonzero')
            else:
                require(wr['shaderCalls'] == m['shadeUpdates'] and wr['evaluations'] == m['primary_ground_reflection_hits'] and
                        wr['queries'] == 16 * wr['evaluations'] == wr['visibilityRays'] and
                        wr['queries'] == wr['misses'] + wr['blockedFloor'] + wr['blockedCharacter'] and
                        wr['workUsed'] == 64 * wr['shaderCalls'] + 6272 * wr['evaluations'] <= wr['workLimit'],
                        'world accounting/budget mismatch')
            aa = read_json(Path(str(prefix) + '.aa.json'))
            obs, wobs = read_json(Path(str(prefix) + '.center-capture.json')), read_json(Path(str(prefix) + '.world-observer.json'))
            require(obs == row['observer'] and wobs == row['worldObserver'] and obs['updates'] == aa['centerShades'] and
                    obs['writeBytes'] == 24 * obs['updates'] and
                    wobs['centerUpdates'] == (aa['centerShades'] if arm == 'on' else 0), 'observer accounting mismatch')
            depth = O.read_depth(Path(str(prefix) + '.f32le'))
            hdr = np.fromfile(str(prefix) + '.center.f64le', '<f8').reshape(135, 240, 3)
            component = np.fromfile(str(prefix) + '.world-center.f64le', '<f8').reshape(135, 240, 3)
            oldhdr = np.fromfile(str(oldprefix) + '.center.f64le', '<f8').reshape(135, 240, 3)
            for raw in (hdr, component):
                require(np.isfinite(raw).all() and (raw >= 0).all() and (raw[~np.isfinite(depth)] == 0).all(),
                        'invalid center HDR/component')
            require(np.allclose(hdr, oldhdr + component, rtol=2e-15, atol=2e-15), 'center component attribution mismatch')
            if arm == 'off':
                require(not component.any(), 'OFF world component is nonzero')
        result[arm] = {'done': done, 'rows': rows}
    return result


def admit_composed(pins, captures):
    proof_path = PRIOR / 'background-reuse-proof/proof.json'
    proof = pins.json(proof_path, 'a0b3d9a95a45f1258d74b2a610aa671ea67b408def948b7362a1c523ecb52368')
    require(proof['status'] == 'PASS_FROZEN_BACKGROUND_REUSE_WITH_V37_CHARACTER' and proof['allReadInputsUnchanged'] is True
            and proof['resolverDependencyBoundary']['characterRGBInputAbsent'] is True
            and proof['resolverDependencyBoundary']['characterBounceOrFloorWorkDependencyAbsent'] is True,
            'background independence proof incomplete')
    rows = {}
    for arm in ('off', 'on'):
        run = ROOT / ('composed-' + arm)
        done = read_json(run / 'COMPLETED.json')
        require(done['status'] == 'ALL10_FLOOR_WORLD_COMPOSITION_COMPLETE' and done['arm'] == arm and
                done['all10PriorFloorOnHDRLegacyAgxExact'] is (arm == 'off') and done['sourceInputsUnchanged'] is True and
                done['fixedAgxAndQuarterMask'] is True and done['noNewLiveBridge'] is True and
                done['backgroundReuseProofSHA256'] == sha(proof_path) and
                done['captureCompletionSHA256'] == sha(ROOT / 'capture' / arm / 'COMPLETED.json'),
                'composition scope or capture/background link mismatch')
        pins.inventory(run / 'INPUT_PINS.json', done['inputPinsSHA256'])
        rows[arm] = D.ten_rows(done['frames'])
    # No world ON RGB decoded until every world OFF exact-byte gate has passed.
    off_byte_gate(rows['off'], pins)
    return rows


def load_arm(arm, rows, captures, pins):
    run = ROOT / ('composed-' + arm)
    frames, flags = {}, {}
    for (view, case), row in rows[arm].items():
        key = view, case, False
        cp = captures[arm]['rows'][(view, case)]
        depthpath = ROOT / 'capture' / arm / (cp['prefix'] + '.f32le')
        require(row['characterDepthSHA256'] == cp['files']['.f32le'] and row['targetSHA256'] == cp['files']['.targets.u8'] and
                Path(row['characterDepthPath']) == depthpath, 'composition shape link mismatch')
        require(row['events'] == 32400 + 3 * (2385 if view == 'front' else 2391) and
                row['events'] == sum(row['actionCounts'].values()) and
                row['actionCounts'] == rows['off'][(view, case)]['actionCounts'] and
                row['floorOverrides'] == (2 if view == 'front' else 0) and
                row['priorFloorOnExactControl'] is (arm == 'off'), 'composition fixed domain changed')
        require(set(row['outputs']) == {'legacy', 'agx'}, 'display profiles changed')
        decoded = {profile: O.read_rgb(pins.check(O.contained(run, record['path']), record['sha256']))
                   for profile, record in row['outputs'].items()}
        hp = pins.check(O.contained(run, row['hdr']), row['hdrSHA256'])
        wp = pins.check(O.contained(run, row['floorWorld']), row['floorWorldSHA256'])
        require(hp.stat().st_size == wp.stat().st_size == 777600, 'HDR/component size mismatch')
        raw = np.fromfile(hp, '<f8').reshape(135, 240, 3)
        component = np.fromfile(wp, '<f8').reshape(135, 240, 3)
        require(np.isfinite(component).all() and (component >= 0).all(), 'invalid composed world component')
        if arm == 'off':
            require(not component.any(), 'OFF composed component nonzero')
        else:
            base = np.fromfile(ROOT / 'composed-off' / rows['off'][(view, case)]['hdr'], '<f8').reshape(135, 240, 3)
            require(np.allclose(raw, base + component, rtol=2e-15, atol=2e-15), 'composed component attribution mismatch')
        flags[key] = D.recompute_clamp_flags(raw, decoded['legacy'], decoded['agx'])
        require(int(flags[key]['profileDomainClamp'].sum()) == row['clampedPixels'], 'LUT clamp count mismatch')
        frames[key] = {'rgb': decoded['agx'], 'depth': O.read_depth(pins.check(depthpath, row['characterDepthSHA256'])),
            'row': {'view': view, 'case': case, 'reverse': False, 'metadata': {'floorDirectReflection': 'on',
                'floorWorldReflection': arm, 'fixedCameraBackgroundAndAgX': True,
                'rgb565SHA256': row['outputs']['agx']['sha256'], 'composedHDRSHA256': row['hdrSHA256'],
                'characterDepthSHA256': row['characterDepthSHA256']}}}
    return frames, flags



def admit_profile(pins):
    profile = pins.json(H.V39 / 'PROFILE_INPUT_FREEZE.json', D.PROFILE_FREEZE_SHA)
    result = {}
    for name, digest in profile['files'].items():
        path = Path(name) if Path(name).is_absolute() else W / name
        require('..' not in path.parts and (path.is_relative_to(W) or
                path.is_relative_to('/usr/share/blender/datafiles/colormanagement')), 'profile pin outside fixed roots')
        # This immutable historical inventory contains relative/absolute aliases.
        # Identical aliases are valid; conflicting aliases remain fail-closed.
        if str(path) in result:
            require(result[str(path)] == digest, 'conflicting profile aliases')
        else:
            if path.is_relative_to(W):
                pins.check(path, digest)
            else:
                verify(path, digest)
            result[str(path)] = digest
    return result


def raw_component_invariants(rows, pins):
    """Test pre-display invariants separately from response quality; save aggregates only."""
    source = read_json(ROOT / 'capture/inputs/ground-source.json')
    scenario = {r['name']: r for r in source['scenarios']}
    require(set(scenario) == set(O.CASES), 'source ground scenarios changed')
    source_rho = {k: r['actualGroundBaseColor'][:3] for k, r in scenario.items()}
    result = {'status': 'RAW_COMPONENT_INVARIANTS_VERIFIED_SEPARATE_FROM_DISPLAY_RESPONSE',
        'sourceGroundMetadataSHA256': sha(ROOT / 'capture/inputs/ground-source.json'),
        'sourceFloorRhoByCondition': source_rho,
        'albedoFloorRhoRatioToBaseline': (np.asarray(source_rho['albedo']) / source_rho['baseline']).tolist(),
        'albedoInterpretation': 'Both receiver and floor source-derived reflectances change. No blanket 0.6 scaling of the new path is assumed; this report gives observed component ratios only.',
        'views': {}}
    for view in O.VIEWS:
        components = {}
        for case in O.CASES:
            row = rows['on'][(view, case)]
            path = pins.check(O.contained(ROOT / 'composed-on', row['floorWorld']), row['floorWorldSHA256'])
            components[case] = np.fromfile(path, '<f8').reshape(135, 240, 3)
        base = components['baseline']
        require(components['ambient'].tobytes() == (2 * base).tobytes(), 'raw ambient component not bit-exact twice baseline')
        require(all(components[c].tobytes() == base.tobytes() for c in ('direction', 'intensity')),
                'raw direction/intensity component differs from baseline')
        values = {}
        for case, raw in components.items():
            values[case] = {'nonzeroPixels': int(np.any(raw != 0, axis=2).sum()),
                'channelSum': raw.sum(axis=(0, 1)).tolist(), 'channelMaximum': raw.max(axis=(0, 1)).tolist(),
                'channelMeanFullFrame': raw.mean(axis=(0, 1)).tolist()}
        ratios = []
        for channel in range(3):
            mask = base[:, :, channel] > 0
            observed = components['albedo'][:, :, channel][mask] / base[:, :, channel][mask]
            ratios.append({'nonzeroBaselinePixels': int(mask.sum()), 'minimum': float(observed.min()) if observed.size else None,
                'median': float(np.median(observed)) if observed.size else None, 'maximum': float(observed.max()) if observed.size else None,
                'sumRatio': float(components['albedo'][:, :, channel].sum() / base[:, :, channel].sum()) if mask.any() else None})
        result['views'][view] = {'ambientBitExact2xBaseline': True, 'directionBitExactBaseline': True,
            'intensityBitExactBaseline': True, 'componentAggregates': values, 'albedoObservedRatioByChannel': ratios}
    return result

def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--completion-pins', type=Path, required=True)
    parser.add_argument('--completion-pins-sha256', dest='completion_pins_sha256', required=True)
    parser.add_argument('--source-freeze-sha256', required=True)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args(argv)
    require(__debug__, 'do not run with -O')
    args.completion_pins, args.output = args.completion_pins.resolve(), args.output.resolve()
    require(args.output.is_relative_to(HERE) and args.output != HERE and not args.output.exists(), 'fresh analysis output required')
    pins = Pins()
    # No scoring, image loading or output writes before all four completion manifests exist and are pinned.
    manifest_inventory(args, pins)
    previous = prior_admission(pins)
    captures = admit_captures(pins, args)
    rows = admit_composed(pins, captures)
    profile_pins = admit_profile(pins)
    admission = O.Admission(W, D.OLD / 'TRUST_INPUTS.json', D.OLD_TRUST_SHA, D.OLD / 'ALL_OUTPUT_PINS.json', D.OLD_OUTPUT_SHA)
    S, ref = O.load_formal(admission)
    domains, domain_summary = O.fixed_domains(admission, ref)
    require(domain_summary == read_json(PRIOR_ANALYSIS / 'FIXED_DOMAINS.json'), 'fixed domains changed')
    frames, flags, formal, descriptive = {}, {}, {}, {}
    frames['off'], flags['off'] = load_arm('off', rows, captures, pins)
    formal['off'] = score(S, ref, frames['off'], 'off', args)
    require(numeric(formal['off']) == numeric(previous['FORMAL_ON.json']), 'OFF prior-floor-ON formal exact parity failed')
    print('OFF_ALL10_BYTE_AND_FORMAL_PARITY_PASS', flush=True)
    descriptive['off'] = previous['DESCRIPTIVE_ON.json']
    frames['on'], flags['on'] = load_arm('on', rows, captures, pins)
    raw_invariants = raw_component_invariants(rows, pins)
    formal['on'] = score(S, ref, frames['on'], 'on', args)
    descriptive['on'] = O.describe(ref, frames['on'], domains)
    D.add_seed_confusions(ref, frames['on'], domains, descriptive['on'])
    for key in formal['off']['conditions']:
        require(formal['off']['conditions'][key]['shapeFullFrame'] == formal['on']['conditions'][key]['shapeFullFrame'], 'shape changed')
    summary = summarize(formal, descriptive, flags, domains)
    trees = {arm: {'formal': O.numeric_conditions(formal[arm]), 'descriptive': descriptive[arm]['conditions']} for arm in formal}
    audit = H.compact_audit(M.compare(trees['off'], trees['on']), 'worldOFF')
    audit['pairLabels'] = {'left': 'worldOFF', 'right': 'worldON'}
    audit['recordColumns'] = ['path', 'worldOFF', 'worldON', 'comparisonRule']
    aggregates = {'FORMAL_OFF.json': H.without_pixel_lists(formal['off']), 'FORMAL_ON.json': H.without_pixel_lists(formal['on']),
        'DESCRIPTIVE_OFF.json': descriptive['off'], 'DESCRIPTIVE_ON.json': descriptive['on'], 'COMPARISON.json': summary, 'SCALAR_AUDIT.json': audit,
        'RAW_COMPONENT_INVARIANTS.json': raw_invariants}
    record = {'status': 'ALL20_WORLD_REFLECTION_ADMITTED_NOT_GLOBAL_ACCEPTANCE',
        'offAll10PriorFloorOnHDRLegacyAgxByteExact': True, 'offAll10PriorFloorOnFormalNumericExact': True,
        'offDescriptiveReusedAfterExactPixelsDepthReferenceCodeIdentity': True,
        'all10CharacterShapeUnchanged': True, 'allFixedDomainsUnchanged': True, 'noPixelsExcluded': True,
        'referenceSeeds': 8, 'responseThreshold': 2 / 255, 'reverseControlsHistoricalNotFresh': True,
        'sourceFreezeSHA256': args.source_freeze_sha256, 'completionPinsSHA256': args.completion_pins_sha256,
        'loaderSHA256': sha(Path(__file__)), 'observedPinCount': len(pins.files),
        'singleContrastNotAdditivityProof': True, 'transportContextSizeExcludedFromOldByteParity': True}
    admission.recheck()
    pins.recheck()
    H.recheck(profile_pins)
    report = markdown(summary, audit) + '\n## Separate raw-component checks\n\nAmbient is bit-exact 2× baseline in both views before display. Direction and intensity world components are bit-exact baseline. Albedo is source-derived for both receiver and floor, not assumed to be a blanket 0.6 multiplier. Per-channel source floor reflectances and observed component ratios are retained in RAW_COMPONENT_INVARIANTS.json.gz. These raw invariants do not imply equal nonlinear display responses.\n'
    write_aggregates(args.output, aggregates, record, domain_summary, report)
    H.compact_write(args.output / 'READ_INPUT_PINS.json', {'files': pins.files})
    admission.recheck()
    pins.recheck()
    H.recheck(profile_pins)
    files = {p.name: {'sha256': sha(p), 'bytes': p.stat().st_size} for p in args.output.iterdir()}
    H.compact_write(args.output / 'COMPLETED.json', {'status': 'WORLD_REFLECTION_METRICS_COMPLETE_NOT_GLOBAL_ACCEPTANCE',
        'files': files, 'codeAggregateOnly': True, 'originalReferenceAndBaselineUnchanged': True})
    print('WORLD_REFLECTION_METRICS_COMPLETE', args.output)


if __name__ == '__main__':
    main()
