#!/usr/bin/env python3
"""External, observation-only display admission and unchanged formal-v3 scoring.

No renderer, profile evaluator, inverse color transform or reference modification.
All10 reconstructed legacy byte gates precede any alternate RGB loading/scoring.
"""
from __future__ import annotations
import argparse
import hashlib
import json
from pathlib import Path
import sys
import types
import numpy as np

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
WORKSPACE = ROOT.parent
OLD = WORKSPACE / 'fox-v3-camera-background-evaluation/analysis-code'
OLD_LOADER_SHA = 'c265987817d6c3508d0b794f0a945b45d60d24f59e2f1f8e38b067565196f2fb'
OLD_TRUST_SHA = 'd4392ca85bf91d6c287241549d0d8c5bd43941723bd846db6bd8803554714183'
OLD_OUTPUT_SHA = '88c5f4d7d68e111795cc25b53d55e472dfec8da58c27d63985e02823e7b05259'
OLD_FREEZE_SHA = 'dda4c1d1dabdc5c72ab0ed4c100be0f1dae187dda0c9e2988e54c5e9e54f5685'
PLAN_FREEZE_SHA = 'a40fcdd14a154778b6a51e31620c5b0a6a0283cd6e2299a4eb954c937da90903'
PROFILE_FREEZE_SHA = '073725203b53ea1680920c48804a02ae4f95071efa475327427c4d242e9c7e50'


def frozen_scene_module():
    path = OLD / 'strict_scene_score.py'
    if path.is_symlink() or hashlib.sha256(path.read_bytes()).hexdigest() != OLD_LOADER_SHA:
        raise ValueError('frozen original scene loader changed')
    module = types.ModuleType('unchanged_scene_score')
    module.__file__ = str(path)
    exec(compile(path.read_bytes(), str(path), 'exec'), module.__dict__)
    return module


O = frozen_scene_module()
require, read_json, verify, sha = O.require, O.read_json, O.verify, O.sha
from compare_metrics import compare, compact_summary, report


def frozen_inventory(path, digest):
    inventory = read_json(verify(path, digest))
    require(type(inventory) is dict and inventory, 'external pin inventory required')
    rows = inventory.get('files', inventory)
    require(type(rows) is dict and rows, 'external pin inventory must contain files')
    pins = {}
    for name, item in rows.items():
        p = Path(name)
        if p.is_absolute():
            require(p.is_relative_to(WORKSPACE), 'absolute input outside workspace')
            name = str(p.relative_to(WORKSPACE))
        require(name not in pins, 'duplicate normalized pin path')
        pins[name] = item if type(item) is str else item['sha256']
    O.check_pins(WORKSPACE, pins)
    return inventory, pins


def pinned(path, pins):
    path = Path(path)
    require(path.is_absolute() and path.is_relative_to(WORKSPACE), 'absolute workspace path required')
    name = str(path.relative_to(WORKSPACE))
    require(name in pins, 'required file absent from external inventory: ' + name)
    return verify(O.contained(WORKSPACE, name), pins[name])


def ten_rows(rows):
    require(type(rows) is list and len(rows) == 10, 'exact all10 rows required')
    result = {}
    for row in rows:
        require(type(row) is dict, 'frame row must be object')
        key = row.get('view'), row.get('case')
        require(key in {(v, c) for v in O.VIEWS for c in O.CASES}, 'unknown frame')
        require(key not in result, 'duplicate frame')
        result[key] = row
    return result


def admit_display(args, old):
    """Gate schema is deliberately explicit and fail-closed.

    Caller pins the parent's complete run and reconstruction gate. This loader
    then independently byte-compares the complete legacy image with current ON.
    """
    _, inputs = frozen_inventory(args.input_pins, args.input_pins_sha256)
    _, outputs = frozen_inventory(args.output_pins, args.output_pins_sha256)
    plan = read_json(verify(ROOT / 'PLAN_FREEZE.json', PLAN_FREEZE_SHA))
    verify(ROOT / 'PLAN.md', plan['planSHA256'])
    O.check_pins(WORKSPACE, plan['files'])
    gate = read_json(pinned(args.legacy_gate, outputs))
    done = read_json(pinned(args.completion, outputs))
    require(gate['status'] == 'ALL10_LEGACY_BYTE_EXACT', 'all10 legacy reconstruction gate not complete')
    gate_rows = ten_rows(gate['frames'])
    require(done['status'] == 'ALL10_DISPLAY_COMPLETE', 'display run not complete')
    done_rows = ten_rows(done['frames'])
    require(done['legacyGateSHA256'] == sha(args.legacy_gate), 'completion gate identity mismatch')
    require(done['inputPinsSHA256'] == args.input_pins_sha256, 'completion input pin identity mismatch')
    require(done['sameHDRBothArms'] is True and done['sourceInputsUnchanged'] is True,
            'shared HDR or immutable-input gate missing')
    require(done['formalCharacterDepthUnchanged'] is True and done['clampExcludedFromScoring'] is False,
            'changed shape or clamp exclusion forbidden')
    proof = read_json(pinned(Path(gate['centerProof']), inputs))
    require(sha(Path(gate['centerProof'])) == gate['centerProofSHA256'] and
            proof['status'] == 'PASS_SOURCE_INPUT_DERIVED_CENTER_HDR_EQUIVALENCE' and
            proof['allReadInputsUnchanged'] is True, 'center HDR provenance not complete')
    require(done['profileInputFreezeSHA256'] == gate['profileInputFreezeSHA256'] == PROFILE_FREEZE_SHA,
            'different profile input freeze')
    profile = read_json(verify(pinned(ROOT / 'PROFILE_INPUT_FREEZE.json', inputs), PROFILE_FREEZE_SHA))
    for name, digest in profile['files'].items():
        path = Path(name) if Path(name).is_absolute() else WORKSPACE / name
        require(path.is_relative_to(WORKSPACE) or path.is_relative_to('/usr/share/blender/datafiles/colormanagement'),
                'profile pin outside known installed/copied inputs')
        verify(path, digest)
    run = args.completion.parent
    require(run == ROOT / 'run-001', 'only the fresh fixed display run is admitted')
    require(not any((run / n).exists() for n in ('FAILED.json', 'REJECTED.json')), 'failed run cannot score')
    # Complete every old/new byte check BEFORE reading any alternate profile file.
    for (view, case), row in gate_rows.items():
        path = pinned(run / ('legacy-' + view + '-' + case + '.u16le'), outputs)
        old_row = old['rows'][(view, case, False)]
        completed = done_rows[(view, case)]
        require(row['hdr'] == 'hdr-' + view + '-' + case + '.f64le' and
                row['legacy'] == path.name and row['hdrSHA256'] == completed['hdrSHA256'],
                'gate and display completion name different HDR inputs')
        require(row['characterDepthSHA256'] == completed['characterDepthSHA256'] == old_row['files']['.f32le'],
                'gate and display character depth identity mismatch')
        old_path = ROOT.parent / 'fox-v3-camera-background-evaluation/actual-002/on' / (old_row['prefix'] + '.u16le')
        require(path.read_bytes() == old_path.read_bytes(), 'independent legacy byte mismatch: ' + view + '-' + case)
        require(row['all565Exact'] is True and row['pixels'] == 32400,
                'per-frame legacy gate failed')
        require(row['legacySHA256'] == sha(path) == row['sourceSceneSHA256'], 'legacy gate hash mismatch')
    frames = {'legacy': {}, 'agx': {}}
    for view in O.VIEWS:
        for case in O.CASES:
            key = (view, case, False)
            for arm in frames:
                path = pinned(run / (arm + '-' + view + '-' + case + '.u16le'), outputs)
                r = done_rows[(view, case)]
                require(r[arm + 'SHA256'] == sha(path), 'completion output hash mismatch')
                require(r['characterDepthSHA256'] == old['rows'][key]['files']['.f32le'],
                        'declared display character depth changed')
                frames[arm][key] = {'rgb': O.read_rgb(path), 'depth': old['frames'][key]['depth'],
                    'row': {'view': view, 'case': case, 'reverse': False,
                        'metadata': {'sourceRendererMetadata': old['rows'][key]['metadata'],
                            'observationOnlyDisplayProfile': arm,
                            'formalCharacterDepthSourceSHA256': old['rows'][key]['files']['.f32le'],
                            'rgb565SHA256': sha(path), 'sameHDRBothArms': True}}}
    return frames, inputs, outputs, done


def recompute_clamp_flags(raw, legacy, agx):
    require(np.isfinite(raw).all() and (raw >= 0).all(), 'invalid HDR')
    with np.errstate(over='ignore'):
        raw32 = raw.astype(np.float32)
    require(np.isfinite(raw32).all(), 'float-overflow HDR')
    return {'profileDomainClamp': np.any(raw32.astype(np.float64) > 5898.240000132513, axis=2),
        'legacySaturation': np.any(raw > 1, axis=2),
        'agxQuantizedAnyZero': np.any(agx == 0, axis=2), 'agxQuantizedAnyMax': np.any(agx == 1, axis=2)}


def clamp_summary(ref, frames, domains, outputs, done, run):
    """Count flags in fixed domains only; never feed flags into a scoring mask."""
    E = ref['evaluator']
    global_report = read_json(pinned(run / 'CLAMPS.json', outputs))
    require(global_report['clampExclusion'] is False and
            global_report['profileDomainMaximum'] == 5898.240000132513, 'clamp contract changed')
    declared = ten_rows(global_report['frames'])
    completion = ten_rows(done['frames'])
    results = {}
    flag_keys = {'profileDomainClamp', 'legacySaturation', 'agxQuantizedAnyZero', 'agxQuantizedAnyMax'}
    for view in O.VIEWS:
        for case in O.CASES:
            key = view + '-' + case
            row, completed = declared[(view, case)], completion[(view, case)]
            fp = pinned(run / ('profile-clamps-' + key + '.npz'), outputs)
            hp = pinned(run / ('hdr-' + key + '.f64le'), outputs)
            require(fp.name == row['flagsFile'] and sha(fp) == row['flagsSHA256'] == completed['clampFlagsSHA256'],
                    'clamp flag identity mismatch')
            require(sha(hp) == completed['hdrSHA256'] and hp.stat().st_size == 777600, 'HDR input identity mismatch')
            raw = np.fromfile(hp, '<f8').reshape(135, 240, 3)
            with np.load(fp, allow_pickle=False) as archive:
                require(set(archive.files) == flag_keys, 'clamp flag keyset changed')
                flags = {name: archive[name] for name in archive.files}
            require(all(a.dtype == np.bool_ and a.shape == (135, 240) for a in flags.values()),
                    'invalid clamp mask dtype/shape')
            agx = frames['agx'][(view, case, False)]['rgb']
            legacy = frames['legacy'][(view, case, False)]['rgb']
            expected = recompute_clamp_flags(raw, legacy, agx)
            require(row['pixels'] == 32400 and row['noExcludedPixels'] is True and
                    row['endpointCountsAreQuantizedNotLUTDomainClipping'] is True, 'clamp report scope changed')
            for name in flag_keys:
                require(np.array_equal(flags[name], expected[name]) and int(flags[name].sum()) == row[name + 'Pixels'],
                        'independent clamp count/mask mismatch: ' + key + '/' + name)
            flags.update(legacyQuantizedAnyZero=np.any(legacy == 0, axis=2),
                         legacyQuantizedAnyMax=np.any(legacy == 1, axis=2))
            samples = ref['arrays'][(view, case)]
            color = E.classify_color(samples.astype(np.float64) / 255)
            subsets = {'all': np.ones((135, 240), bool),
                'stableColor': color['stable'], 'unknownColor': color['uncertain']}
            if case != 'baseline':
                response = E.classify_png8(ref['arrays'][(view, 'baseline')], samples)
                subsets.update(stableResponse=response['stable'], unknownResponse=response['uncertain'])
            results[key] = {name: {subset: {'pixels': int((mask & submask).sum()),
                **{flag: int((mask & submask & value).sum()) for flag, value in flags.items()}}
                for subset, submask in subsets.items()} for name, mask in domains[view].items()}
    return {'status': 'DESCRIPTIVE_ONLY_FIXED_DOMAIN_FLAG_COUNTS',
        'noPixelsExcludedFromScoring': True, 'flagsIndependentlyRecomputedFromPinnedHDRAndRGB565': True,
        'inputDomainClampingAndQuantizedEndpointsAreSeparate': True,
        'unknownsNeverPass': True, 'conditions': results}


def score(S, ref, frames, arm, args):
    manifest = {'schemaVersion': 'host-fixed-camera-composition-display-observation-v1',
        'candidate': {'label': 'v38-camera-floor-fixed-HDR-' + arm,
            'sourceGeometryUnchanged': True, 'formalCharacterDepthRetained': True,
            'sceneRGBOutsideCharacterDepthAllowed': True, 'displayOnly': True,
            'oldWork8MFit': False, 'oldDirect1MFit': False,
            'profileIsLUTApproximationNotExactOCIO': arm == 'agx'},
        'externalInputPinsSHA256': args.input_pins_sha256,
        'externalOutputPinsSHA256': args.output_pins_sha256,
        'runtimeCompleteSHA256': sha(args.completion),
        'legacyByteGateSHA256': sha(args.legacy_gate),
        'strictLoaderSHA256': sha(Path(__file__)), 'unchangedOriginalLoaderSHA256': OLD_LOADER_SHA,
        'referenceThresholdsUnchanged': True, 'clampExcludedFromScoring': False,
        'frames': [frames[(v, c, False)]['row'] for v in O.VIEWS for c in O.CASES]}
    candidate = {'frames': {(v, c): frames[(v, c, False)] for v in O.VIEWS for c in O.CASES},
        'manifest': manifest, 'manifestSHA256': O.sha_bytes(O.canonical(manifest))}
    result, _ = S.score(ref, candidate)
    require(result['sixtyPercentGoal'] == 'NOT_ESTABLISHED_CONDITIONAL_METRICS_ONLY' and
            result['globalAcceptance'] == 'NOT_ESTABLISHED', 'formal acceptance scope changed')
    return result


def add_seed_confusions(ref, frames, domains, descriptive):
    E = ref['evaluator']
    for view in O.VIEWS:
        base = frames[(view, 'baseline', False)]['rgb']
        for case in O.CASES[1:]:
            samples0, samples = ref['arrays'][(view, 'baseline')], ref['arrays'][(view, case)]
            st = E.classify_png8(samples0, samples)
            delta = (frames[(view, case, False)]['rgb'] - base) @ O.LUMA
            for name, mask in domains[view].items():
                rows = []
                for numerator in st['numerator']:
                    seed = {'bright': numerator > E.PNG_THRESHOLD, 'dark': numerator < -E.PNG_THRESHOLD,
                        'inactive': abs(numerator) <= E.PNG_THRESHOLD,
                        'stable': np.ones(mask.shape, bool), 'uncertain': np.zeros(mask.shape, bool),
                        'mean': numerator / E.PNG_DENOM}
                    row = O.response_confusion(seed, delta, mask, E.T)
                    row['classificationScope'] = 'SINGLE_REFERENCE_SEED_ONLY_NOT_CONSENSUS_STABILITY'
                    rows.append(row)
                descriptive['conditions'][view + '-' + case][name]['response']['eachReferenceSeedConfusion'] = rows


def write_json(path, value):
    path.write_text(json.dumps(value, indent=2, allow_nan=False) + '\n')


def main(argv=None):
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--input-pins', type=Path, required=True)
    p.add_argument('--input-pins-sha256', required=True)
    p.add_argument('--output-pins', type=Path, required=True)
    p.add_argument('--output-pins-sha256', required=True)
    p.add_argument('--legacy-gate', type=Path, required=True)
    p.add_argument('--completion', type=Path, required=True)
    p.add_argument('--output', type=Path, required=True)
    a = p.parse_args(argv)
    require(__debug__, 'do not run with -O')
    for field in ('input_pins', 'output_pins', 'legacy_gate', 'completion'):
        setattr(a, field, getattr(a, field).absolute())
    output = a.output.resolve()
    require(output.is_relative_to(HERE) and output != HERE and not output.exists() and not output.is_symlink(),
            'fresh output under new analysis-code required')
    require(not any(p.is_symlink() for p in output.parents if p.is_relative_to(HERE)), 'symlink output forbidden')
    A = O.Admission(WORKSPACE, OLD / 'TRUST_INPUTS.json', OLD_TRUST_SHA,
                    OLD / 'ALL_OUTPUT_PINS.json', OLD_OUTPUT_SHA)
    old = A.load('on')
    frames, inputs, outputs, done = admit_display(a, old)
    S, ref = O.load_formal(A)
    domains, domain_summary = O.fixed_domains(A, ref)
    clamps = clamp_summary(ref, frames, domains, outputs, done, a.completion.parent)
    formal = {arm: score(S, ref, data, arm, a) for arm, data in frames.items()}
    descriptive = {arm: O.describe(ref, data, domains) for arm, data in frames.items()}
    # Pin the old saved reports via the historical code/report inventory.
    old_freeze = read_json(verify(OLD.parent / 'CODE_REPORT_FREEZE.json', OLD_FREEZE_SHA))
    def previous(name):
        path = OLD / 'all-analysis-001' / name
        item = old_freeze['files'][str(path.relative_to(WORKSPACE))]
        return read_json(verify(path, item['sha256']))
    require(O.canonical(O.numeric_conditions(formal['legacy'])) ==
            O.canonical(O.numeric_conditions(previous('formal-on.json'))), 'legacy formal v38 numeric parity failed')
    require(O.canonical(descriptive['legacy']) == O.canonical(previous('descriptive-on.json')),
            'legacy descriptive fixed-domain numeric parity failed')
    require(O.canonical(domain_summary) == O.canonical(previous('FIXED_DOMAINS.json')['views']),
            'fixed attribution domain changed')
    for key in formal['legacy']['conditions']:
        require(formal['legacy']['conditions'][key]['shapeFullFrame'] == formal['agx']['conditions'][key]['shapeFullFrame'],
                'character shape changed')
    for arm, data in frames.items():
        add_seed_confusions(ref, data, domains, descriptive[arm])
    summary = compact_summary(formal, descriptive)
    trees = {arm: {'formal': O.numeric_conditions(formal[arm]), 'descriptive': descriptive[arm]['conditions']}
             for arm in frames}
    audit = compare(trees['legacy'], trees['agx'])
    reports = {'ADMISSION.json': {'status': 'STRICT_ALL10_DISPLAY_ADMITTED',
        'legacyAll10ByteExactIndependentlyChecked': True, 'legacyAll10FormalAndDescriptiveNumericExact': True,
        'all10CharacterShapeExact': True, 'allFixedDomainMasksExact': True,
        'all10ColorAll8ContrastsAll8ReferenceSeeds': True,
        'inputPinsSHA256': a.input_pins_sha256, 'outputPinsSHA256': a.output_pins_sha256,
        'oldTrustSHA256': OLD_TRUST_SHA, 'oldOutputPinsSHA256': OLD_OUTPUT_SHA,
        'oldLoaderSHA256': OLD_LOADER_SHA, 'loaderSHA256': sha(Path(__file__)),
        'completionSHA256': sha(a.completion), 'legacyGateSHA256': sha(a.legacy_gate),
        'sourceInputsUnchanged': True, 'clampExcludedFromScoring': False},
        'FIXED_DOMAINS.json': {'status': 'UNCHANGED_GEOMETRY_REFERENCE_ONLY', 'views': domain_summary},
        'CLAMP_STRATA.json': clamps,
        'COMPARISON.json': {'status': 'DESCRIPTIVE_NOT_GLOBAL_ACCEPTANCE',
            'sixtyPercentGoal': 'NOT_ESTABLISHED', 'conditions': summary}, 'SCALAR_AUDIT.json': audit}
    for arm in frames:
        reports['formal-' + arm + '.json'] = formal[arm]
        reports['descriptive-' + arm + '.json'] = descriptive[arm]
    A.recheck()
    O.check_pins(WORKSPACE, inputs)
    O.check_pins(WORKSPACE, outputs)
    verify(a.input_pins, a.input_pins_sha256)
    verify(a.output_pins, a.output_pins_sha256)
    output.mkdir()
    for name, obj in reports.items():
        write_json(output / name, obj)
    (output / 'REPORT.md').write_text(report(summary, audit))
    inventory = {p.name: {'sha256': sha(p), 'bytes': p.stat().st_size} for p in sorted(output.iterdir())}
    A.recheck()
    O.check_pins(WORKSPACE, inputs)
    O.check_pins(WORKSPACE, outputs)
    write_json(output / 'COMPLETED.json', {'status': 'DISPLAY_ANALYSIS_COMPLETE_NOT_GLOBAL_ACCEPTANCE',
        'files': inventory, 'codeReportOnly': True, 'noRawAssetsCopied': True})
    print('DISPLAY_ANALYSIS_COMPLETE', output)


if __name__ == '__main__':
    main()
