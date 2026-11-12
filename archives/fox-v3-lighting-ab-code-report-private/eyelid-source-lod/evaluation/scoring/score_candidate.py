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
sys.path.insert(0,str(HERE.parent/'code'))
from geometry_certificate import verify as verify_geometry, runtime as geometry_runtime
from codec_audit import audit as audit_codec
GEOMETRY = None
CERTIFICATE_SHA = None
def geometry_count(key, default):
    if GEOMETRY is not None and key=='snapshotBytes':return GEOMETRY['codecSnapshotBytes']
    return GEOMETRY['counts'][key] if GEOMETRY is not None else default

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


def validate_pixel_runtime(actual, enabled):
    """Validate declared runtime audit for this host64 experiment, not cross-ABI sizes.

    snapshotBytes includes the 416-byte light prefix when enabled. These checks
    constrain metadata claims; renderer execution evidence remains a separate QA.
    """
    require(struct.calcsize('P') == 8, 'pixel runtime audit requires current 64-bit host')
    for field in ('shadeUpdates', 'diskSamples', 'snapshotBytes', 'snapshotCapacity',
                  'work', 'snapshotControlBytes', 'rawFieldScratchBytes'):
        require(type(actual.get(field)) is int and actual[field] >= 0,
                'frame actual ' + field + ' must be a nonnegative integer')
    require(actual['diskSamples'] == 48 * actual['shadeUpdates'], 'pixel diskSamples must equal 48 * shadeUpdates')
    require(actual['shadeUpdates'] > 0 if enabled else actual['shadeUpdates'] == 0,
            'pixel shadeUpdates must be positive ON and zero OFF')
    require(actual['snapshotCapacity'] == 65536, 'pixel snapshotCapacity must equal 65536')
    require((416 if enabled else 0) <= actual['snapshotBytes'] <= 65536,
            'pixel snapshotBytes must include light prefix and fit 65536-byte budget')
    require(actual['work'] <= 8_000_000, 'pixel work exceeds 8000000 budget')
    require(actual['snapshotControlBytes'] == (64 if enabled else 48),
            'pixel host64 snapshotControlBytes runtime audit mismatch')
    require(actual['rawFieldScratchBytes'] == 2080, 'pixel host64 rawFieldScratchBytes runtime audit mismatch')


VISIBILITY_LIMITS = {'visibilityRayLimit': 1_000_000, 'visibilityNodeLimit': 100_000_000,
                     'visibilityTriangleLimit': 50_000_000, 'visibilitySceneLimit': 524288}
VISIBILITY_COUNTS = ('visibilitySceneBytes', 'visibilitySceneNodes', 'visibilityTriangles',
                     'visibilityVertices', 'visibilityBuildNs', 'visibilityTemporaryBytes',
                     'visibilityRays', 'visibilityNodeVisits', 'visibilityTriangleTests')


def validate_visibility_runtime(actual, enabled, ground_mode=None):
    """Audit fixed-budget host experiment metadata, not independent execution proof."""
    require(type(actual.get('visibilityEnabled')) is bool and actual['visibilityEnabled'] is enabled,
            'frame actual visibilityEnabled mismatch')
    require(actual.get('visibilityComplete') is True, 'frame actual visibilityComplete must be boolean true')
    generation = actual.get('visibilityGeneration')
    require(type(generation) is list and len(generation) == 3 and
            all(type(value) is int for value in generation) and
            generation == ([2 if ground_mode else 1, 1, 1] if enabled else [0, 0, 0]),
            'visibilityGeneration runtime audit mismatch')
    for field in ('visibilityGeometryFingerprint', 'visibilitySnapshotFingerprint'):
        value = actual.get(field)
        require(type(value) is str and len(value) == 16 and
                all(c in '0123456789abcdef' for c in value), field + ' must be 16 lowercase hex characters')
        require((value != '0' * 16) if enabled else (value == '0' * 16), field + ' ON/OFF mismatch')
    require(struct.calcsize('P') == 8, 'visibility runtime audit requires current 64-bit host')
    for field in ('visibilityBindingBytes', 'visibilityBudgetBytes'):
        require(type(actual.get(field)) is int and actual[field] == 48, field + ' host64 sizeof audit mismatch')
    for field in (*VISIBILITY_LIMITS, *VISIBILITY_COUNTS):
        require(type(actual.get(field)) is int and actual[field] >= 0,
                'frame actual ' + field + ' must be a nonnegative integer')
    for field, limit in VISIBILITY_LIMITS.items():
        require(actual[field] == limit, 'fixed ' + field + ' mismatch')
    for count, limit in (('visibilityRays', 'visibilityRayLimit'),
                         ('visibilityNodeVisits', 'visibilityNodeLimit'),
                         ('visibilityTriangleTests', 'visibilityTriangleLimit'),
                         ('visibilitySceneBytes', 'visibilitySceneLimit')):
        require(actual[count] <= actual[limit], count + ' exceeds fixed budget')
    if enabled:
        for field in ('visibilitySceneBytes', 'visibilitySceneNodes', 'visibilityBuildNs', 'visibilityTemporaryBytes'):
            require(actual[field] > 0, field + ' must be positive ON')
        require(actual['visibilityTriangles'] == (geometry_count('triangles',1166)+2*bool(ground_mode)) and actual['visibilityVertices'] == (geometry_count('vertices',849)+4*bool(ground_mode)),
                'visibility full-v3 geometry count mismatch')
        require(actual['visibilitySceneBytes'] == (16+280*(geometry_count('triangles',1166)+2*bool(ground_mode))) and actual['visibilityTemporaryBytes'] == (24*(geometry_count('vertices',849)+4*bool(ground_mode))+12*(geometry_count('triangles',1166)+2*bool(ground_mode))),
                'visibility fixed-fixture allocation audit mismatch')
        require(actual['visibilitySceneNodes'] <= min(4095, 2 * (geometry_count('triangles',1166)+2*bool(ground_mode)) - 1),
                'visibility scene node count exceeds fixed-fixture bound')
        require(type(actual.get('diskSamples')) is int and
                0 < actual['visibilityRays'] <= actual['diskSamples'],
                'visibility rays must be positive and no greater than diskSamples')
        require(actual['visibilityNodeVisits'] >= actual['visibilityRays'],
                'visibility node visits must be at least rays')
        require(actual['visibilityTriangleTests'] > 0,
                'visibility fixed-fixture triangle tests must be positive')
    else:
        require(all(actual[field] == 0 for field in VISIBILITY_COUNTS), 'visibility OFF counters and timing must be zero')


TRANSPORT_LIMITS = {'transportRayLimit': 20_000_000, 'transportNodeLimit': 800_000_000,
                    'transportTriangleLimit': 300_000_000, 'transportSceneLimit': 262144}
TRANSPORT_COUNTS = ('transportSceneBytes', 'transportTemporaryBytes', 'transportBuildNs',
                    'transportRays', 'transportNodeVisits', 'transportTriangleTests',
                    'primary_rays', 'primary_hits', 'primary_misses', 'secondary_world_rays',
                    'primary_direct_queries', 'secondary_direct_queries', 'zero_reflection_ns_v',
                    'back_single_discard', 'grazing_ng_v')


def validate_transport_runtime(actual, mode, outer, inner, ground_mode=None):
    for field, value in (('transportMode', mode), ('outerSamples', outer), ('innerSamples', inner)):
        require(type(actual.get(field)) is int and actual[field] == value, 'frame actual ' + field + ' mismatch')
    require(actual.get('transportComplete') is True, 'transportComplete must be boolean true')
    for field in (*TRANSPORT_LIMITS, *TRANSPORT_COUNTS, 'materialGeneration',
                  'transportContextBytes', 'transportBudgetBytes'):
        require(type(actual.get(field)) is int and actual[field] >= 0,
                'frame actual ' + field + ' must be a nonnegative integer')
    for field, value in TRANSPORT_LIMITS.items():
        require(actual[field] == value, 'fixed ' + field + ' mismatch')
    require(actual['transportContextBytes'] == (272 if ground_mode is not None else 184) and actual['transportBudgetBytes'] == 48,
            'transport host64 context/budget size mismatch')
    for count, limit in (('transportRays', 'transportRayLimit'), ('transportNodeVisits', 'transportNodeLimit'),
                         ('transportTriangleTests', 'transportTriangleLimit'), ('transportSceneBytes', 'transportSceneLimit')):
        require(actual[count] <= actual[limit], count + ' exceeds transport budget')
    fingerprint = actual.get('materialFingerprint')
    require(type(fingerprint) is str and len(fingerprint) == 16 and
            all(c in '0123456789abcdef' for c in fingerprint), 'materialFingerprint must be 16 lowercase hex characters')
    require(actual['materialGeneration'] == (1 if mode else 0), 'materialGeneration mismatch')
    require((fingerprint != '0' * 16) if mode else (fingerprint == '0' * 16), 'materialFingerprint mode mismatch')
    if not mode:
        require(all(actual[field] == 0 for field in TRANSPORT_COUNTS), 'transport mode0 counters/scene/timing must be zero')
        return
    require(actual['transportSceneBytes'] == ((560+64*(geometry_count('triangles',1166)+2*bool(ground_mode))) if ground_mode is not None else 75128) and actual['transportTemporaryBytes'] == (64*(geometry_count('triangles',1166)+2*bool(ground_mode))) and
            actual['transportBuildNs'] > 0, 'transport fixed-fixture scene/temp/build audit mismatch')
    require(type(actual.get('shadeUpdates')) is int and actual['primary_rays'] == actual['shadeUpdates'] * outer,
            'transport primary_rays must equal shadeUpdates * outerSamples')
    require(actual['primary_hits'] + actual['primary_misses'] == actual['primary_rays'],
            'transport primary hits/misses mismatch')
    require(actual['primary_direct_queries'] == actual.get('visibilityRays'), 'transport primary_direct_queries mismatch')
    require(actual['transportRays'] == actual['primary_rays'] + actual['secondary_world_rays'] + actual['secondary_direct_queries'],
            'transport ray accounting mismatch')
    require(actual['transportNodeVisits'] >= actual['transportRays'], 'transport node visits must be at least rays')
    require(actual['transportTriangleTests'] > 0, 'transport fixed-fixture triangle tests must be positive')
    for field in ('zero_reflection_ns_v', 'back_single_discard', 'grazing_ng_v'):
        require(actual[field] <= actual['primary_hits'], 'transport ' + field + ' exceeds hits')
    require(actual['secondary_world_rays'] <= actual['primary_hits'] * inner and
            actual['secondary_direct_queries'] <= actual['primary_hits'] * 48, 'transport secondary query bound exceeded')
    if mode == 2:
        reflectable_hits = actual['primary_hits'] - actual['back_single_discard'] - actual['zero_reflection_ns_v'] - (actual['primary_ground_hits'] if ground_mode is not None else 0)
        require(reflectable_hits >= 0, 'transport reflectableHits must be nonnegative')
        require(actual['secondary_world_rays'] == reflectable_hits * inner,
                'transport secondary_world_rays must equal reflectableHits * innerSamples')
        require(actual['secondary_direct_queries'] <= reflectable_hits * 48,
                'transport secondary_direct_queries exceeds reflectableHits * 48')
    if mode == 1:
        require(all(actual[field] == 0 for field in ('secondary_world_rays', 'secondary_direct_queries',
                    'zero_reflection_ns_v', 'back_single_discard', 'grazing_ng_v')),
                'transport mode1 secondary/discard counters must be zero')


GROUND_SOURCE_SHA = '6320121022bc7ab8f23300b45181d58ed09e1bdffd7e2239fbd5194e9521be9b'
GROUND_EXTRACTOR_SHA = '539737f9eb4282d1ddc135e9d4f9ae8fb0878108b9c2773ee716af89e406ea4f'
GROUND_COUNTERS = ('primary_ground_hits', 'primary_ground_emission_hits', 'secondary_ground_hits')


def ground_input_bytes(source, case):
    lines = ['FOXGROUND1']
    lines.extend(' '.join(format(v, '.17g') for v in xyz) for xyz in source['worldVertices'])
    lines.extend(' '.join(str(v) for v in tri) for tri in source['triangles'])
    lines.append(' '.join(format(v, '.17g') for v in case['linearLe']))
    return ('\n'.join(lines) + '\n').encode('ascii')


def ground_fingerprint(data):
    value = 14695981039346656037
    for byte in data:
        value = ((value ^ byte) * 1099511628211) & ((1 << 64) - 1)
    return format(value, '016x')


def validate_ground_runtime(actual, mode, declared):
    for field, key in (('groundMode','mode'), ('groundObjectId','objectId'),
                       ('groundFirstTriangle','firstTriangle'), ('groundTriangleCount','triangleCount'),
                       ('emissionGeneration','emissionGeneration')):
        require(type(actual.get(field)) is int and actual[field] == declared[key], 'actual ' + field + ' mismatch')
    le = actual.get('groundLe')
    require(type(le) is list and len(le) == 3 and all(type(v) in (int,float) and math.isfinite(v) for v in le) and
            le == declared['linearLe'], 'actual groundLe mismatch')
    require(actual.get('groundInputFingerprint') == declared['inputFingerprint'], 'actual groundInputFingerprint mismatch')
    for field in GROUND_COUNTERS:
        require(type(actual.get(field)) is int and actual[field] >= 0, 'actual ' + field + ' must be a nonnegative integer')
    for field in ('primary_hits','secondary_world_rays'):
        require(type(actual.get(field)) is int and actual[field] >= 0, 'actual ' + field + ' must be a nonnegative integer')
    require(actual['primary_ground_hits'] <= actual['primary_hits'], 'ground primary hits exceed all hits')
    require(actual['secondary_ground_hits'] <= actual['secondary_world_rays'], 'ground secondary hits exceed world queries')
    require(actual['primary_ground_emission_hits'] == (actual['primary_ground_hits'] if mode == 2 else 0),
            'ground emission hit accounting mismatch')
    if mode == 0:
        require(all(actual[field] == 0 for field in GROUND_COUNTERS), 'ground OFF counters must be zero')
    require(type(actual.get('snapshotBytes')) is int and actual['snapshotBytes'] == geometry_count('snapshotBytes',52212) and
            type(actual.get('records')) is int and actual['records'] == geometry_count('records',45),
            'ground snapshot/record invariant mismatch')


def load_candidate(path, config):
    path = Path(path).resolve()
    global GEOMETRY
    if CERTIFICATE_SHA is not None:
        GEOMETRY=verify_geometry(path.parent,CERTIFICATE_SHA)
    data = path.read_bytes()
    manifest = read_json_bytes(data)
    require(isinstance(manifest, dict), 'candidate manifest must be an object')
    if CERTIFICATE_SHA is not None:require(manifest.get('geometryCertificateSHA256')==CERTIFICATE_SHA,'manifest geometry pin mismatch')
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
    ground_source = None
    source_contents = {}
    for entry in source_files:
        checked_bytes = checked_file(path.parent, entry, used)
        source_hashes[entry['file']] = sha_bytes(checked_bytes)
        source_contents[entry['file']] = checked_bytes
        if entry['file'] == 'inputs/ground-source.json':
            require(sha_bytes(checked_bytes) == GROUND_SOURCE_SHA, 'fixed ground source hash mismatch')
            ground_source = read_json_bytes(checked_bytes)
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
    codec_contract=read_json_bytes(source_contents['inputs/codec-contract.json']) if GEOMETRY is not None else None
    if GEOMETRY is not None:require(native_config.get('normalPairCodecEnabled') is bool(GEOMETRY['codecMode']),'codec mode config mismatch')
    ground_mode = native_config.get('groundMode') if 'groundMode' in native_config else None
    if 'groundMode' in native_config:
        require(type(ground_mode) is int and ground_mode in (0,1,2), 'config groundMode must be integer 0/1/2')
        require(native_config.get('transportMode') == 2 and type(native_config.get('transportMode')) is int and
                native_config.get('outerSamples') == 16 and type(native_config.get('outerSamples')) is int and
                native_config.get('innerSamples') == 16 and type(native_config.get('innerSamples')) is int,
                'ground requires transportMode2 outer16 inner16')
        require(native_config.get('groundSourceSHA256') == GROUND_SOURCE_SHA and ground_source is not None,
                'ground source pin/declaration missing')
        require(source_hashes.get('code/ground_source.py') == GROUND_EXTRACTOR_SHA, 'fixed ground extractor hash mismatch')
        require(ground_source['sourceSHA256'] == config['sourceSHA256'] and
                ground_source['referenceConfigSHA256'] == REFERENCE_CONFIG_SHA, 'ground source provenance mismatch')
        ground_cases = {case['name']:case for case in ground_source['scenarios']}
        require(set(ground_cases) == set(CASES), 'ground source cases mismatch')
    transport_mode = native_config.get('transportMode', 0)
    outer_samples = native_config.get('outerSamples', 16)
    inner_samples = native_config.get('innerSamples', 16)
    require(type(transport_mode) is int and transport_mode in (0, 1, 2), 'native config transportMode must be integer 0/1/2')
    require(type(outer_samples) is int and outer_samples in (16, 64), 'native config outerSamples must be integer 16/64')
    require(type(inner_samples) is int and inner_samples == 16, 'native config innerSamples must be integer 16')
    require(not transport_mode or (all(native_config.get(field) is True for field in
            ('visibilityEnabled', 'pixelLightEnabled', 'linearLightEnabled', 'physicalDiskEnabled')) and
            native_config.get('agxProfileEnabled') is False), 'transport requires visibility/pixel/linear/physical and AgX false')
    visibility_enabled = native_config.get('visibilityEnabled', False)
    require(type(visibility_enabled) is bool, 'native config visibilityEnabled must be boolean')
    require(not visibility_enabled or
            (native_config.get('pixelLightEnabled') is True and
             native_config.get('linearLightEnabled') is True and
             native_config.get('physicalDiskEnabled') is True and
             native_config.get('agxProfileEnabled') is False),
            'visibility requires pixel, linear, physical true and AgX false')
    linear_mode_declared = 'linearLightEnabled' in native_config
    if linear_mode_declared:
        require(type(native_config['linearLightEnabled']) is bool, 'native config linearLightEnabled must be boolean')
    physical_mode_declared = 'physicalDiskEnabled' in native_config
    if physical_mode_declared:
        require(type(native_config['physicalDiskEnabled']) is bool, 'native config physicalDiskEnabled must be boolean')
    pixel_mode_declared = 'pixelLightEnabled' in native_config
    if pixel_mode_declared:
        require(type(native_config['pixelLightEnabled']) is bool, 'native config pixelLightEnabled must be boolean')
        require(native_config.get('agxProfileEnabled') is False, 'native config agxProfileEnabled must be boolean false')
        require(not native_config['pixelLightEnabled'] or
                (native_config.get('linearLightEnabled') is True and
                 native_config.get('physicalDiskEnabled') is True),
                'pixel lighting requires linearLightEnabled and physicalDiskEnabled true')
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
        if ground_mode is not None:
            ground = scenario.get('ground')
            require(isinstance(ground,dict), 'scenario ground missing')
            expected_ints = {'mode':ground_mode,'objectId':1 if ground_mode else 0,
                            'firstTriangle':geometry_count('triangles',1166) if ground_mode else 0,'triangleCount':2 if ground_mode else 0,
                            'emissionGeneration':1 if ground_mode else 0}
            for field,value in expected_ints.items():
                require(type(ground.get(field)) is int and ground[field] == value, 'scenario ground ' + field + ' mismatch')
            expected_le = ground_cases[name]['linearLe'] if ground_mode else [0,0,0]
            le = ground.get('linearLe')
            require(type(le) is list and len(le) == 3 and all(type(v) in (int,float) and math.isfinite(v) for v in le) and
                    le == expected_le, 'scenario ground linearLe mismatch')
            file = 'inputs/ground-' + name + '.txt'
            require(ground.get('sourceSHA256') == GROUND_SOURCE_SHA and ground.get('inputFile') == file and
                    file in source_contents and ground.get('inputSHA256') == source_hashes[file],
                    'scenario ground input/source hash mismatch')
            require(source_contents[file] == ground_input_bytes(ground_source, ground_cases[name]),
                    'ground input bytes differ from pinned source')
            fingerprint = ground.get('inputFingerprint')
            require(type(fingerprint) is str and len(fingerprint)==16 and all(c in '0123456789abcdef' for c in fingerprint),
                    'scenario ground fingerprint format mismatch')
            require((fingerprint != '0'*16) if ground_mode else (fingerprint == '0'*16), 'scenario ground fingerprint mode mismatch')
            require(fingerprint == (ground_fingerprint(source_contents[file]) if ground_mode else '0'*16), 'ground input fingerprint mismatch')
        else:
            require('ground' not in scenario, 'scenario ground lacks mode declaration')
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
        if GEOMETRY is not None:
            geometry_runtime(actual,GEOMETRY)
            audit_codec(checked_file(path.parent,row['codecSnapshot'],used,suffix='.snapshot'),codec_contract,GEOMETRY['codecMode'],key[0],key[1],False,actual)
            audit_codec(checked_file(path.parent,row['codecReverseSnapshot'],used,suffix='.snapshot'),codec_contract,GEOMETRY['codecMode'],key[0],key[1],True)
        if ground_mode is not None:
            validate_ground_runtime(actual, ground_mode, native_input['ground'])
        else:
            require('groundMode' not in actual, 'actual groundMode lacks config declaration')
        validate_visibility_runtime(actual, visibility_enabled, ground_mode)
        validate_transport_runtime(actual, transport_mode, outer_samples, inner_samples, ground_mode)
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
        if pixel_mode_declared:
            require(type(actual.get('pixelLightEnabled')) is bool and
                    actual['pixelLightEnabled'] is native_config['pixelLightEnabled'],
                    'frame actual pixelLightEnabled mismatch')
            require(actual.get('agxProfileEnabled') is False, 'frame actual agxProfileEnabled must be boolean false')
            validate_pixel_runtime(actual, native_config['pixelLightEnabled'])
        else:
            require('pixelLightEnabled' not in actual, 'frame pixelLightEnabled lacks config declaration')
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
    parser.add_argument('--geometry-certificate-sha256', required=True)
    args = parser.parse_args(argv)
    global CERTIFICATE_SHA
    output, root = args.output.resolve(), args.reference.resolve()
    require(not args.output.exists() and not args.output.is_symlink(), 'output must not already exist')
    require(not output.is_relative_to(root), 'output must not be inside frozen reference')
    CERTIFICATE_SHA=args.geometry_certificate_sha256
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
    result['scoringImplementation']['codec_audit.py']=sha(HERE.parent/'code/codec_audit.py')
    result['scoringImplementation']['geometry_certificate.py']=sha(HERE.parent/'code/geometry_certificate.py')
    result['scoringImplementation']['codecValidationVersion']='geometry-normal-pair-validator-v3-strict-integers'
    result_path = write_output(output, result, masks)
    print(json.dumps({'status': 'SCORING_COMPLETE_NOT_GLOBAL_ACCEPTANCE', 'evaluation': str(result_path),
                      'conditions': len(result['conditions']), 'sixtyPercentGoal': result['sixtyPercentGoal']}))
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (AssertionError, ValueError, KeyError, TypeError, OSError, struct.error) as error:
        print('SCORING_REJECTED: ' + str(error), file=sys.stderr)
        sys.exit(2)
