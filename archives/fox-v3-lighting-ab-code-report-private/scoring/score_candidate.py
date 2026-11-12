#!/usr/bin/env python3
"""Read-only frozen-v3 reference scoring for actual RGB565/depth candidates.

Does not render, modify the reference, infer candidate-dependent scoring masks,
or claim global acceptance. All generated files go into a fresh output folder.
"""
from __future__ import annotations

import argparse
import hashlib
import io
import json
import math
from pathlib import Path, PurePosixPath
import re
import struct
import sys
import types

import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
VIEWS = ('front', 'oblique')
CASES = ('baseline', 'direction', 'intensity', 'ambient', 'albedo')
RESOLUTION = [240, 135]
REFERENCE_CONFIG_SHA = '4a9d836a4dae2fc570f5f0fb99690ab0f13fbe394589f785b56e891e0573dc40'


def require(condition, message):
    if not condition:
        raise ValueError(message)


def sha_bytes(data):
    return hashlib.sha256(data).hexdigest()


def sha(path):
    return sha_bytes(Path(path).read_bytes())


def _pairs(pairs):
    result = {}
    for key, value in pairs:
        require(key not in result, 'duplicate JSON key: ' + key)
        result[key] = value
    return result


def read_json_bytes(data):
    def invalid_constant(value):
        raise ValueError('nonfinite JSON constant: ' + value)
    def finite_float(value):
        number = float(value)
        require(math.isfinite(number), 'nonfinite JSON number: ' + value)
        return number
    return json.loads(data, object_pairs_hook=_pairs, parse_constant=invalid_constant, parse_float=finite_float)


def read_json(path):
    return read_json_bytes(Path(path).read_bytes())


def contained_file(root, name):
    require(isinstance(name, str) and bool(name), 'file path must be a nonempty string')
    path = PurePosixPath(name)
    require(not path.is_absolute() and '..' not in path.parts and str(path) == name,
            'file path must be normalized and relative: ' + name)
    resolved = (root / name).resolve()
    require(resolved.is_relative_to(root.resolve()), 'file outside pack: ' + name)
    require(resolved.is_file(), 'missing file: ' + name)
    return resolved


def checked_file(root, entry, used=None, suffix=None, size=None):
    require(isinstance(entry, dict), 'file entry must be an object')
    name, digest = entry.get('file'), entry.get('sha256')
    require(isinstance(digest, str) and re.fullmatch(r'[0-9a-f]{64}', digest) is not None,
            'invalid SHA256 for ' + str(name))
    path = contained_file(root, name)
    if used is not None:
        require(path not in used, 'reused file path: ' + name)
        used.add(path)
    if suffix is not None:
        require(name.endswith(suffix), 'wrong file suffix: ' + name)
    data = path.read_bytes()
    if size is not None:
        require(len(data) == size, 'wrong file size: ' + name)
    require(sha_bytes(data) == digest, 'file hash mismatch: ' + name)
    return data


def decode_rgb565(data, resolution=RESOLUTION):
    """Direct 5/6/5 to float64. No 8-bit expansion or PNG conversion."""
    width, height = resolution
    require(len(data) == width * height * 2, 'wrong RGB565 byte count')
    packed = np.frombuffer(data, dtype='<u2').reshape(height, width)
    return np.stack(((packed >> 11).astype(np.float64) / 31,
                     ((packed >> 5) & 63).astype(np.float64) / 63,
                     (packed & 31).astype(np.float64) / 31), axis=-1)


def decode_depth(data, resolution=RESOLUTION):
    width, height = resolution
    require(len(data) == width * height * 4, 'wrong depth byte count')
    depth = np.frombuffer(data, dtype='<f4').reshape(height, width)
    require(not np.isnan(depth).any(), 'depth contains NaN')
    require(not np.isposinf(depth).any(), 'depth contains positive infinity')
    require(np.isfinite(depth).any(), 'depth has no finite foreground')
    return depth


def validate_physical_source(source, config):
    require(isinstance(source, dict), 'physical source must be an object')
    require(source.get('sourceSHA256') == config['sourceSHA256'], 'physical source hash mismatch')
    require(source.get('refConfigSHA256') == REFERENCE_CONFIG_SHA, 'physical source reference hash mismatch')
    cases = source.get('cases')
    require(isinstance(cases, list) and len(cases) == len(CASES), 'physical source requires five cases')
    lookup = {}
    for case in cases:
        require(isinstance(case, dict) and case.get('name') in CASES, 'physical source unexpected case')
        name = case['name']
        require(name not in lookup, 'physical source duplicate case')
        lights = case.get('lights')
        require(isinstance(lights, list) and len(lights) == 3, 'physical source requires three DISK lights')
        names = set()
        for light in lights:
            require(isinstance(light, dict) and isinstance(light.get('name'), str) and bool(light['name']), 'physical light identity missing')
            require(light['name'] not in names, 'physical source duplicate light')
            names.add(light['name'])
            require(light.get('shape') == 'DISK', 'physical light must be DISK')
            for field in ('position', 'color', 'normal', 'tangentU', 'tangentV'):
                values = np.asarray(light.get(field), dtype=np.float64)
                require(values.shape == (3,) and np.isfinite(values).all(), 'physical light invalid ' + field)
            for field in ('diameter', 'power'):
                value = light.get(field)
                require(isinstance(value, (int, float)) and not isinstance(value, bool) and math.isfinite(value) and
                        (value > 0 if field == 'diameter' else value >= 0), 'physical light invalid ' + field)
        require(names == {config['keyLightName'], 'Fill', 'Rim'}, 'physical source light names mismatch')
        rgb = np.asarray(case.get('worldRGB'), dtype=np.float64)
        require(rgb.shape == (3,) and np.isfinite(rgb).all() and np.all(rgb >= 0), 'physical source worldRGB invalid')
        strength = case.get('worldStrength')
        require(isinstance(strength, (int, float)) and not isinstance(strength, bool) and math.isfinite(strength) and strength >= 0,
                'physical source worldStrength invalid')
        key = next(light for light in lights if light['name'] == config['keyLightName'])
        expected = config['expectedCaseMetadata'][name]
        require(np.allclose(key['position'], expected['keyLocation'], rtol=0, atol=1e-5) and
                math.isclose(key['power'], expected['keyEnergy'], rel_tol=0, abs_tol=1e-5) and
                math.isclose(strength, expected['worldStrength'], rel_tol=0, abs_tol=1e-5),
                'physical source frozen reference case mismatch')
        lookup[name] = case
    require(set(lookup) == set(CASES), 'physical source incomplete cases')
    return lookup


def load_candidate(path, config):
    path = Path(path).resolve()
    data = path.read_bytes()
    manifest = read_json_bytes(data)
    require(isinstance(manifest, dict), 'candidate manifest must be an object')
    require(manifest.get('schemaVersion') == 'fox-candidate-rgb565-v1', 'candidate schema mismatch')
    require(manifest.get('resolution') == RESOLUTION, 'candidate resolution mismatch')
    require(manifest.get('rgb565Format') == 'RGB565_U16_LE_ROW_MAJOR', 'RGB565 format mismatch')
    require(manifest.get('depthFormat') == 'FLOAT32_LE_ROW_MAJOR_NEG_INF_BACKGROUND', 'depth format mismatch')
    reference = manifest.get('reference', {})
    require(reference.get('version') == 'new-reference-uncertainty-v3', 'reference version mismatch')
    require(reference.get('configSHA256') == REFERENCE_CONFIG_SHA, 'candidate reference config mismatch')
    candidate = manifest.get('candidate', {})
    for name in ('label', 'sourceLabel', 'head'):
        require(isinstance(candidate.get(name), str) and bool(candidate[name].strip()),
                'missing candidate label: ' + name)
    source_files = candidate.get('sourceFiles')
    require(isinstance(source_files, list) and len(source_files) > 0, 'candidate source files missing')
    used = {path}
    native_config = None
    physical_source = None
    physical_source_bytes = None
    source_hashes = {}
    for entry in source_files:
        checked_bytes = checked_file(path.parent, entry, used)
        source_hashes[entry['file']] = sha_bytes(checked_bytes)
        if entry['file'] == 'inputs/candidate-config.json':
            native_config = read_json_bytes(checked_bytes)
        if entry['file'] == 'inputs/physical-source.json':
            physical_source_bytes = checked_bytes
            physical_source = read_json_bytes(checked_bytes)
    if physical_source_bytes is not None:
        pins = read_json(HERE / 'physical-source-pins.json')
        require(pins.get('version') == 'physical-source-pin-v1', 'physical source pin version mismatch')
        require(pins['source']['sha256'] == config['sourceSHA256'] and
                pins['reference']['configSHA256'] == REFERENCE_CONFIG_SHA and
                pins['reference']['version'] == 'new-reference-uncertainty-v3', 'physical source pin provenance mismatch')
        require(len(physical_source_bytes) == pins['physicalSource']['bytes'] and
                sha_bytes(physical_source_bytes) == pins['physicalSource']['sha256'], 'fixed physical source hash mismatch')
        for name, digest in pins['extractorFiles'].items():
            require(source_hashes.get(name) == digest, 'fixed physical extractor hash mismatch: ' + name)
    require(isinstance(native_config, dict), 'hashed inputs/candidate-config.json missing')
    require(native_config.get('referenceConfigSHA256') == REFERENCE_CONFIG_SHA, 'native config reference hash mismatch')
    require(native_config.get('sourceSHA256') == config['sourceSHA256'], 'native config source hash mismatch')
    require(native_config.get('cameras') == config['cameras'], 'native config camera contract mismatch')
    linear_mode_declared = 'linearLightEnabled' in native_config
    if linear_mode_declared:
        require(type(native_config['linearLightEnabled']) is bool, 'native config linearLightEnabled must be boolean')
    physical_mode_declared = 'physicalDiskEnabled' in native_config
    if physical_mode_declared:
        require(type(native_config['physicalDiskEnabled']) is bool, 'native config physicalDiskEnabled must be boolean')
    physical_enabled = native_config.get('physicalDiskEnabled', False)
    require(not physical_enabled or physical_source is not None, 'hashed inputs/physical-source.json missing')
    physical_cases = validate_physical_source(physical_source, config) if physical_source is not None else {}
    native_cases = native_config.get('scenarios')
    require(isinstance(native_cases, list) and len(native_cases) == len(CASES), 'native config scenario count mismatch')
    native_scenarios = {}
    declared_scenarios = {c['name']: c for c in config['scenarios']}
    for scenario in native_cases:
        require(isinstance(scenario, dict) and scenario.get('name') in CASES, 'native config unexpected scenario')
        name = scenario['name']
        require(name not in native_scenarios, 'native config duplicate scenario')
        require(all(scenario.get(k) == v for k, v in declared_scenarios[name].items()), 'native config reference scenario mismatch')
        for field in ('nativeDirection', 'intensity'):
            values = np.asarray(scenario.get(field), dtype=np.float64)
            require(values.shape == (3,) and np.isfinite(values).all(), 'native config invalid ' + field)
        for field in ('ambient', 'diffuse'):
            value = scenario.get(field)
            require(isinstance(value, (int, float)) and not isinstance(value, bool) and math.isfinite(value), 'native config invalid ' + field)
        if physical_enabled:
            require(scenario.get('physical') == physical_cases[name], 'native config physical source case mismatch')
        else:
            require('physical' not in scenario, 'physical data present while mode disabled')
        native_scenarios[name] = scenario
    require(set(native_scenarios) == set(CASES), 'native config incomplete scenarios')
    frames = manifest.get('frames')
    require(isinstance(frames, list) and len(frames) == 10, 'candidate requires exactly ten frames')
    cameras = {c['name']: c for c in config['cameras']}
    scenarios = {c['name']: c for c in config['scenarios']}
    lookup = {}
    for row in frames:
        require(isinstance(row, dict), 'frame must be an object')
        key = (row.get('view'), row.get('case'))
        require(key[0] in VIEWS and key[1] in CASES, 'unexpected candidate view/case')
        require(key not in lookup, 'duplicate candidate view/case')
        meta = row.get('metadata', {})
        require(isinstance(meta, dict), 'frame metadata must be an object')
        require(meta.get('resolution') == RESOLUTION, 'frame metadata resolution mismatch')
        for name in ('sourceLabel', 'head'):
            require(meta.get(name) == candidate[name], 'frame metadata ' + name + ' mismatch')
        require(meta.get('scenario') == scenarios[key[1]], 'frame scenario metadata mismatch')
        camera = np.asarray(meta.get('nativeCamera'), dtype=np.float64)
        expected_camera = np.asarray(cameras[key[0]]['nativeCamera'], dtype=np.float64)
        require(camera.shape == (9,) and np.isfinite(camera).all() and
                np.array_equal(camera, expected_camera), 'frame camera metadata mismatch')
        native_input = native_scenarios[key[1]]
        require(meta.get('nativeInput') == native_input, 'frame nativeInput metadata mismatch')
        actual = meta.get('actual')
        require(isinstance(actual, dict), 'frame actual metadata missing')
        if linear_mode_declared:
            require(type(actual.get('linearLightEnabled')) is bool and
                    actual['linearLightEnabled'] is native_config['linearLightEnabled'],
                    'frame actual linearLightEnabled mismatch')
        else:
            require('linearLightEnabled' not in actual, 'frame linearLightEnabled lacks config declaration')
        if physical_mode_declared:
            require(type(actual.get('physicalDiskEnabled')) is bool and
                    actual['physicalDiskEnabled'] is native_config['physicalDiskEnabled'],
                    'frame actual physicalDiskEnabled mismatch')
        else:
            require('physicalDiskEnabled' not in actual, 'frame physicalDiskEnabled lacks config declaration')
        actual_camera = np.asarray(actual.get('camera'), dtype=np.float64)
        actual_light = np.asarray(actual.get('light'), dtype=np.float64)
        expected_light = np.asarray(native_input['nativeDirection'] + native_input['intensity'], dtype=np.float64)
        require(actual_camera.shape == (9,) and np.isfinite(actual_camera).all() and
                np.allclose(actual_camera, expected_camera, rtol=0, atol=1e-5), 'frame actual camera mismatch')
        require(actual_light.shape == (6,) and np.isfinite(actual_light).all() and
                np.allclose(actual_light, expected_light, rtol=0, atol=1e-6), 'frame actual light mismatch')
        rgb_data = checked_file(path.parent, row.get('rgb565'), used, '.u16le', 240 * 135 * 2)
        depth_data = checked_file(path.parent, row.get('depth'), used, '.f32le', 240 * 135 * 4)
        lookup[key] = {'rgb': decode_rgb565(rgb_data), 'depth': decode_depth(depth_data), 'row': row}
    require(set(lookup) == {(v, c) for v in VIEWS for c in CASES}, 'incomplete candidate frame grid')
    return {'manifest': manifest, 'manifestSHA256': sha_bytes(data), 'path': path, 'frames': lookup}


def read_png_bytes(data, resolution, require_alpha=False):
    require(data[:8] == b'\x89PNG\r\n\x1a\n' and data[12:16] == b'IHDR', 'reference is not PNG')
    width, height, depth, kind = struct.unpack('>IIBB', data[16:26])
    require(depth == 8 and kind in ([6] if require_alpha else [2, 6]), 'PNG depth/color type mismatch')
    require([width, height] == resolution, 'reference PNG resolution mismatch')
    with Image.open(io.BytesIO(data)) as im:
        result = np.asarray(im, dtype=np.uint8)
    require(result.shape == (height, width, 4 if kind == 6 else 3), 'reference PNG shape mismatch')
    return result


def verify_reference_files(root):
    pins = read_json(HERE / 'reference-pins.json')
    for name, expected in pins['files'].items():
        require(sha(contained_file(root, name)) == expected, 'frozen reference pin mismatch: ' + name)
    artifacts = read_json(root / 'artifact-manifest.json')
    for name, entry in artifacts['files'].items():
        data = contained_file(root, name).read_bytes()
        require(len(data) == entry['bytes'] and sha_bytes(data) == entry['sha256'],
                'frozen reference artifact mismatch: ' + name)
    return pins, artifacts


def load_reference(root):
    """Port the frozen pack validator's reads; never run its write-on-import CLI."""
    root = Path(root).resolve()
    pins, artifacts = verify_reference_files(root)
    config = read_json(root / 'input/config.json')
    manifest = read_json(root / 'render-manifest.json')
    freeze = read_json(root / 'execution-freeze.json')
    require(config['resolution'] == RESOLUTION, 'reference resolution mismatch')
    require(manifest['configSHA256'] == sha(root / 'input/config.json') == freeze['configSHA256'],
            'reference config hash mismatch')
    require(sha(Path(config['source'])) == config['sourceSHA256'] == manifest['sourceSHA256'],
            'reference source hash mismatch')
    require(freeze['files'] == config['frozenCode'], 'execution freeze mismatch')
    for name, expected in config['frozenCode'].items():
        require(sha(contained_file(root, name)) == expected, 'frozen reference code mismatch: ' + name)
    # compile/exec avoids Python writing __pycache__ into the frozen pack.
    evaluator_path = root / 'code/evaluator.py'
    E = types.ModuleType('frozen_v3_evaluator')
    E.__file__ = str(evaluator_path)
    exec(compile(evaluator_path.read_bytes(), str(evaluator_path), 'exec'), E.__dict__)
    require(config['seeds'] == E.PLAN['seeds'], 'reference seed contract mismatch')
    require(tuple(E.PLAN['views']) == VIEWS and tuple(E.PLAN['cases']) == CASES, 'reference case/view contract mismatch')
    require(manifest['renderInvariantSettings'] == config['expectedRenderInvariantSettings'], 'reference invariants mismatch')
    lookup, metadata = {}, {}
    for row in manifest['images']:
        key = (row['seed'], row['view'], row['case'])
        require(key not in lookup, 'duplicate reference seed/view/case')
        require(key[0] in E.PLAN['seeds'] and key[1] in VIEWS and key[2] in CASES, 'unexpected reference seed/view/case')
        stem = f'images/seed-{key[0]}-{key[1]}-{key[2]}'
        require(row['file'] == stem + '.png' and row['metadata'] == stem + '.json', 'reference image identity mismatch')
        png = checked_file(root, {'file': row['file'], 'sha256': row['sha256']})
        meta = read_json_bytes(checked_file(root, {'file': row['metadata'], 'sha256': row['metadataSHA256']}))
        require(meta['pngSHA256'] == sha_bytes(png), 'reference metadata PNG hash mismatch')
        require((meta['seed'], meta['view'], meta['case']) == key, 'reference metadata identity mismatch')
        require(meta['samplesMaximum'] == 2048 and meta['threads'] == 8 and meta['configSHA256'] == manifest['configSHA256'],
                'reference render settings mismatch')
        require(meta['invariantSettings'] == manifest['renderInvariantSettings'], 'reference render invariant mismatch')
        for field, value in config['expectedCaseMetadata'][key[2]].items():
            if field == 'albedoTargetMaterials':
                require(meta[field] == value, 'reference material scope mismatch')
            else:
                require(np.allclose(meta[field], value, rtol=0, atol=config['metadataFloatTolerance']),
                        'reference case metadata mismatch: ' + field)
        lookup[key] = read_png_bytes(png, RESOLUTION)[..., :3]
        metadata[key] = meta
    require(set(lookup) == {(s, v, c) for s in E.PLAN['seeds'] for v in VIEWS for c in CASES},
            'incomplete reference pack')
    foreground, alphas = {}, {}
    require(set(manifest['foreground']) == set(VIEWS), 'reference foreground views mismatch')
    for view in VIEWS:
        row = manifest['foreground'][view]
        require(row['file'] == f'images/foreground-{view}.png', 'reference mask identity mismatch')
        alpha = read_png_bytes(checked_file(root, row), RESOLUTION, True)[..., 3]
        fg = alpha > 0
        require(fg.any(), 'empty fixed source foreground')
        color_meta = metadata[(E.PLAN['seeds'][0], view, 'baseline')]
        for key, meta in metadata.items():
            if key[1] == view:
                require(meta['geometry'] == color_meta['geometry'], 'reference per-case geometry drift')
        for name in ('cameraMatrix', 'clip', 'orthoScale', 'resolution'):
            require(color_meta['geometry'][name] == row['geometry'][name], 'reference mask/color geometry mismatch: ' + name)
        def objects(geometry):
            return {o['name']: o['hideRender'] for o in geometry['objects'] if o['name'] != 'Studio ground'}
        require(objects(color_meta['geometry']) == objects(row['geometry']), 'reference mask/color visibility mismatch')
        foreground[view], alphas[view] = fg, alpha
    arrays = {(v, c): np.stack([lookup[(s, v, c)] for s in E.PLAN['seeds']]) for v in VIEWS for c in CASES}
    return {'root': root, 'config': config, 'manifest': manifest, 'pins': pins, 'artifacts': artifacts,
            'evaluator': E, 'arrays': arrays, 'foreground': foreground, 'alphas': alphas}


def shape_metrics(source, candidate):
    """Full-frame set comparison, including native pixels outside the source."""
    require(source.dtype == np.bool_ and candidate.dtype == np.bool_ and source.shape == candidate.shape,
            'shape masks must be matching boolean arrays')
    intersection, union = source & candidate, source | candidate
    extra, missing = candidate & ~source, source & ~candidate
    union_count = int(union.sum())
    return {
        'scope': 'FULL_FRAME_FIXED_SOURCE_MASK_VS_FINITE_CANDIDATE_DEPTH',
        'status': 'DESCRIPTIVE_ONLY_NOT_ACCEPTANCE' if union_count else 'N/A_NOT_PASS',
        'framePixels': int(source.size), 'sourcePixels': int(source.sum()), 'candidatePixels': int(candidate.sum()),
        'intersectionPixels': int(intersection.sum()), 'unionPixels': union_count,
        'IoU': None if not union_count else float(intersection.sum() / union_count),
        'extraPixels': int(extra.sum()), 'missingPixels': int(missing.sum()),
        'extraFractionOfFrame': float(extra.mean()), 'missingFractionOfFrame': float(missing.mean()),
        'missingFractionOfSource': None if not source.any() else float(missing.sum() / source.sum()),
        'extraFractionOfCandidate': None if not candidate.any() else float(extra.sum() / candidate.sum()),
        'sourceRecall': None if not source.any() else float(intersection.sum() / source.sum()),
        'candidatePrecision': None if not candidate.any() else float(intersection.sum() / candidate.sum()),
    }


def verify_saved_stability(reference, view, case, kind, computed):
    path = reference['root'] / f'evaluation-masks/{view}-{case}-{kind}.npz'
    with np.load(path, allow_pickle=False) as saved:
        require(set(saved.files) == set(computed) | {'foreground'}, 'frozen stability keys differ')
        require(np.array_equal(saved['foreground'], reference['foreground'][view]), 'frozen source foreground differs')
        for name, values in computed.items():
            require(np.array_equal(values, saved[name]), 'frozen stability replay differs: ' + f'{view}/{case}/{kind}/{name}')


def score(reference, candidate):
    E, arrays = reference['evaluator'], reference['arrays']
    result = {
        'version': 'new-candidate-v3-rebuilt-against-frozen-reference-v3',
        'candidateAvailable': True,
        'sixtyPercentGoal': 'NOT_ESTABLISHED_CONDITIONAL_METRICS_ONLY',
        'globalAcceptance': 'NOT_ESTABLISHED',
        'candidate': candidate['manifest']['candidate'],
        'candidateManifestSHA256': candidate['manifestSHA256'],
        'candidateManifest': candidate['manifest'],
        'reference': {'version': 'new-reference-uncertainty-v3', 'pins': reference['pins']['files'],
                      'sourceSHA256': reference['config']['sourceSHA256'],
                      'sourceCameraProvenance': reference['config']['cameraProvenance'],
                      'artifactHashes': reference['artifacts']['files']},
        'numericContract': {
            'reference': 'Exact frozen PNG8 integer luma numerator / 2550000; strict threshold numerator 20000; paired 8-seed all-class consensus plus fixed 95% Student-t mean CI.',
            'candidate': 'RGB565 little-endian decoded directly to float64 R5/31, G6/63, B5/31; luma [0.2126,0.7152,0.0722], threshold 2/255; no PNG8 requantization.',
            'scoringDomain': 'Fixed source alpha8 > 0. Reference-only stable masks include inactive pixels; candidate depth does not restrict color or response.',
            'shapeDomain': 'Entire 240x135 frame. Candidate foreground is finite f32le depth; negative infinity is background.',
        },
        'notes': [
            'Conditional subset statuses are preserved from the frozen evaluator, not promoted to global acceptance.',
            'Uncertain scores and pooled/per-seed full-source scores remain descriptive, never acceptance.',
            'Empty unions and undefined metrics are null/N/A, never PASS or zero-imputed.',
            'Candidate metadata labels identify declared provenance, while file hashes identify supplied bytes; hashes do not prove renderer fidelity.',
            'Source alpha masks include partial-alpha boundary pixels. Ground remains in rich reference color but not in source foreground.',
            'Reference mean intervals are pointwise and model-dependent, not simultaneous or future-render intervals.',
        ],
        'conditions': {}, 'foreground': {},
    }
    masks = {}
    for view in VIEWS:
        fg, alpha = reference['foreground'][view], reference['alphas'][view]
        result['foreground'][view] = {'sourcePixels': int(fg.sum()),
            'partialAlphaBoundaryPixels': int(((alpha > 0) & (alpha < 255)).sum()),
            'sourceMaskSHA256': reference['manifest']['foreground'][view]['sha256']}
        for case in CASES:
            frame = candidate['frames'][(view, case)]
            color, cs = E.evaluate_color_png8(arrays[(view, case)], fg, frame['rgb'])
            verify_saved_stability(reference, view, case, 'color', cs)
            native_fg = np.isfinite(frame['depth'])
            item = {'colorMeanPrecision': color, 'shapeFullFrame': shape_metrics(fg, native_fg),
                    'candidateMetadata': frame['row']['metadata']}
            mask_data = {'sourceForeground': fg, 'sourcePartialAlphaBoundary': (alpha > 0) & (alpha < 255),
                         'candidateForeground': native_fg, 'shapeExtra': native_fg & ~fg,
                         'shapeMissing': fg & ~native_fg, 'colorStable': fg & cs['stable'],
                         'colorUncertain': fg & cs['uncertain']}
            if case != 'baseline':
                response, rs = E.evaluate_response_png8(arrays[(view, 'baseline')], arrays[(view, case)], fg,
                    candidate['frames'][(view, 'baseline')]['rgb'], frame['rgb'])
                verify_saved_stability(reference, view, case, 'response', rs)
                unknown = fg & rs['uncertain']
                nums = rs['numerator']
                consensus = np.all(nums > E.PNG_THRESHOLD, axis=0) | np.all(nums < -E.PNG_THRESHOLD, axis=0) | np.all(abs(nums) <= E.PNG_THRESHOLD, axis=0)
                response['uncertaintyDiagnostics'] = {
                    'uncertainOnPartialAlphaBoundary': int((unknown & (alpha > 0) & (alpha < 255)).sum()),
                    'uncertainInsideFullAlpha': int((unknown & (alpha == 255)).sum()),
                    'allEightSameClassButMeanCIRejected': int((unknown & consensus).sum()),
                    'seedClassDisagreement': int((unknown & ~consensus).sum()),
                    'causes': 'Classification diagnostics only; Monte Carlo/adaptive/display quantization contributions not causally separated.'}
                item['response'] = response
                for name in ('bright', 'dark', 'inactive', 'stable', 'uncertain'):
                    mask_data['response' + name.capitalize()] = fg & rs[name]
            result['conditions'][view + '-' + case] = item
            masks[view + '-' + case] = mask_data
    return result, masks


def write_output(output, result, masks):
    output = Path(output)
    output.mkdir(exist_ok=False)  # Strictly new. Never overwrite/reuse a prior run.
    (output / 'STARTED.json').write_text('{"status":"WRITING_STARTED_CHECK_COMPLETED_MARKER"}\n')
    files = []
    path = output / 'evaluation.json'
    path.write_text(json.dumps(result, indent=2, allow_nan=False) + '\n')
    files.append(path)
    for condition, arrays in masks.items():
        path = output / (condition + '-masks.npz')
        np.savez_compressed(path, **arrays)
        files.append(path)
    records = {p.name: {'bytes': p.stat().st_size, 'sha256': sha(p)} for p in files}
    (output / 'COMPLETED.json').write_text(json.dumps({'status': 'SCORING_COMPLETE_NOT_GLOBAL_ACCEPTANCE',
        'candidateManifestSHA256': result['candidateManifestSHA256'], 'files': records}, indent=2) + '\n')
    # Retain the start marker as an audit fact; COMPLETED.json is authoritative.
    return output / 'evaluation.json'


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('candidate_manifest', type=Path)
    parser.add_argument('--reference', type=Path, default=HERE.parents[1] / 'fox-reference-uncertainty-v3')
    parser.add_argument('--output', type=Path, required=True, help='A directory which does not yet exist')
    args = parser.parse_args(argv)
    output, root = args.output.resolve(), args.reference.resolve()
    require(not args.output.exists() and not args.output.is_symlink(), 'output must not already exist')
    require(not output.is_relative_to(root), 'output must not be inside frozen reference')
    reference = load_reference(root)
    candidate = load_candidate(args.candidate_manifest, reference['config'])
    result, masks = score(reference, candidate)
    # Detect changes while computation was underway before any result is saved.
    verify_reference_files(root)
    require(sha(Path(reference['config']['source'])) == reference['config']['sourceSHA256'], 'reference source changed during scoring')
    checked_again = load_candidate(args.candidate_manifest, reference['config'])
    require(checked_again['manifestSHA256'] == candidate['manifestSHA256'], 'candidate changed during scoring')
    result['scoringImplementation'] = {name: sha(HERE / name) for name in
        ('score_candidate.py', 'manifest.schema.json', 'reference-pins.json', 'physical-source-pins.json')}
    result_path = write_output(output, result, masks)
    print(json.dumps({'status': 'SCORING_COMPLETE_NOT_GLOBAL_ACCEPTANCE', 'evaluation': str(result_path),
                      'conditions': len(result['conditions']), 'sixtyPercentGoal': result['sixtyPercentGoal']}))
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (ValueError, KeyError, TypeError, OSError, struct.error) as error:
        print('SCORING_REJECTED: ' + str(error), file=sys.stderr)
        sys.exit(2)
