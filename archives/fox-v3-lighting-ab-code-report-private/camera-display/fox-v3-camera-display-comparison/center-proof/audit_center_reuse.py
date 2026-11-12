#!/usr/bin/env python3
"""Read-only reproducible center-HDR provenance audit; JSON goes to stdout only.

No renderer/compiler/generator is invoked. Existing f64 data and RGB/depth buffers
are read in memory; no HDR, geometry, image, or reconstructed buffer is saved.
The sole native call is the pinned existing profile_buffer(..., enabled=0).
Run with python -B; this module imports no project modules and writes no files.
"""
import ctypes
import hashlib
import json
from pathlib import Path
import re
import sys

sys.dont_write_bytecode = True
import numpy as np

W = Path(__file__).resolve().parents[2]
P = W / 'fox-v3-lid-display-combination'
C = W / 'fox-v3-camera-background-evaluation/actual-002'
B = W / 'fox-v3-lid-evaluation/actual-lid8-v2'
G = W / 'fox-v3-agx-profile/profile'
CASES = ('baseline', 'direction', 'intensity', 'ambient', 'albedo')
READ_HASHES = {}


def digest(data):
    return hashlib.sha256(data).hexdigest()


def relative(path):
    path = Path(path).resolve()
    return str(path.relative_to(W)) if path.is_relative_to(W) else str(path)


def read(path):
    path = Path(path).resolve()
    data = path.read_bytes()
    h = digest(data)
    key = relative(path)
    if key in READ_HASHES:
        assert READ_HASHES[key] == h, f'INPUT_CHANGED_DURING_AUDIT: {key}'
    READ_HASHES[key] = h
    return data


def sha(path):
    return digest(read(path))


def obj(path):
    return json.loads(read(path))


def record(path):
    return {'path': relative(path), 'sha256': sha(path)}


def same(a, b):
    assert read(a) == read(b), f'NOT_BYTE_EXACT: {a} / {b}'
    return {'prior': record(a), 'current': record(b), 'byteExact': True}


def canonical(value):
    return json.dumps(value, sort_keys=True, separators=(',', ':'), allow_nan=False)


def function_body(source, signature):
    """Extract one pinned function through its line-start closing brace."""
    start = source.index(signature)
    first = source.index('{', start)
    end = source.index('\n}', first)
    return source[first + 1:end]


def remove_once(text, exact):
    assert text.count(exact) == 1, 'REMOVAL_RULE_NOT_UNIQUE'
    return text.replace(exact, '', 1)


def lines(path, first, last, anchors):
    source = read(path).decode().splitlines()
    selected = '\n'.join(source[first - 1:last])
    for anchor in anchors:
        assert anchor in selected, f'SOURCE_LINE_ANCHOR_MISMATCH: {path}:{first}-{last}'
    return {**record(path), 'firstLine': first, 'lastLine': last,
            'anchors': anchors, 'lineRangeSHA256': digest(selected.encode())}


def main():
    assert sys.byteorder == 'little' and ctypes.sizeof(ctypes.c_double) == 8
    prior_done = obj(P / 'run-001/COMPLETED.json')
    assert sha(P / 'run-001/COMPLETED.json') == 'b8f22311dba6f863b276bed6ba3a594e7f4f04b0ff452db42147a9f4dcd31499'
    assert len(prior_done['frames']) == 10
    for field in ('rgbDepthAllExactBaseline', 'allTenSnapshotsExact',
                  'allNonTimingMetadataExact', 'inputsUnchanged',
                  'finiteNonnegativeHDR', 'zeroBackground', 'oneProcessOneFrame'):
        assert prior_done[field] is True
    for frame in prior_done['frames']:
        for name, h in frame['files'].items():
            assert sha(P / 'run-001' / name) == h

    before = obj(P / 'run-001/input-hashes-before.json')
    after = obj(P / 'run-001/input-hashes-after.json')
    assert before == after
    prior_relevant = {p: h for p, h in before.items()
                      if any('/' + part + '/' in p for part in ('product', 'physical', 'visibility', 'transport'))
                      or 'actual-lid8-v2/physical-' in p
                      or ('actual-lid8-v2/compiled/model-' in p and p.endswith('.aynm'))}
    for path, h in prior_relevant.items():
        assert sha(Path(path)) == h
    current_pins = obj(C / 'input-hashes.json')
    for path, h in current_pins.items():
        assert sha(C / path) == h
    old_build = obj(P / 'run-001/build.json')
    new_build = obj(C / 'PREPARED.json')
    assert sha(P / 'run-001/native-render') == old_build['binarySHA256']
    assert sha(C / 'native-render') == new_build['binarySHA256']
    assert new_build['flags'] == old_build['command'][1:9]

    old_mesh = P / 'product/main/ui/kasane/ksn_mesh_depth.c'
    center = C / 'product/main/ui/kasane/ksn_boundary_aa_center.inc'
    assert sha(old_mesh) == 'f2696178f3d2a4c72c54eeb22ca26a123f240cc1688bfeb023e4a2e16ddd3077'
    assert sha(center) == '0ab6cf6e904e074df2d7969109d2f2e1a1f6de7a147deeceba1205f665e607e6'
    # These exact text removals are intentionally narrow and count-checked.
    old_remove = '''                    /* Capture actual preclamp shader result; nearer winners overwrite. */
                    if(shader)for(unsigned k=0;k<3;k++)fox_combined_observer[((unsigned)yy*240+(unsigned)x)*3+k]=rgb[k];'''
    new_remove = '''                    /* Commit identity only AFTER the legacy shader/pixel/stats commit. */
                    if(view.node<1||view.node>aa->record_count||face>=64)return false;
                    if(!aa_charge(aa,AA_CENTER_ID_UPDATE,1))return false;
                    aa->center_id[(unsigned)yy*KSN_PROC_W+(unsigned)x]=aa->source[view.node][face];'''
    old_body = remove_once(function_body(read(old_mesh).decode(), 'static bool strip('), old_remove)
    new_body = remove_once(function_body(read(center).decode(), 'static bool aa_center_strip('), new_remove)
    norm = lambda x: re.sub(r'\s+', '', x)
    assert norm(old_body) == norm(new_body)
    normalized_hash = digest(norm(old_body).encode())
    assert normalized_hash == 'db073af6f819ee9f27de775a88709ec37859705cdd114980760eecac6030d7bd'

    shared = []
    for directory in ('product/main/ayatsuri', 'physical', 'visibility', 'transport'):
        for path in sorted((P / directory).iterdir()):
            if path.suffix in ('.c', '.h') and path.name not in ('pixel_transport.c', 'pixel_transport.h'):
                shared.append(same(path, C / path.relative_to(P)))
    transport_old = read(P / 'transport/pixel_transport.c')
    transport_new = read(C / 'transport/pixel_transport.c')
    assert transport_new.startswith(transport_old)
    old_native = read(P / 'code/native_render.c').decode()
    new_native = read(C / 'code/native_render.c').decode()
    old_setup = old_native[old_native.index(' const char *diskfile='):old_native.index(' size_t scene_bytes=')]
    new_setup = new_native[new_native.index(' const char *diskfile='):new_native.index(' const fox_bg_fixed_input')]
    assert old_setup == new_setup

    anchors = [
        lines(old_mesh, 133, 154, ['if(depth<=z[at])continue;', 'fox_combined_observer[', 'fmin(1,rgb[k])']),
        lines(center, 39, 54, ['rho[k]=fmax(0,fmin(1,rho[k]));', 'shader(shader_context,scene,position,nn,rho,rgb)', 'aa->center_id[']),
        lines(C / 'product/main/ui/kasane/ksn_boundary_aa_impl.inc', 138, 157,
              ['ksn_aa_rho_affine(decoded,bary,rho)', 'aa_center_strip(']),
        lines(C / 'product/main/ui/kasane/ksn_scene_composition_impl.inc', 119, 136,
              ['aa_center_strip(', 'sc_shade_final(', 'if(result.action!=KSN_SCENE_KEEP_CHARACTER)']),
        lines(C / 'product/main/ui/kasane/ksn_scene_composition_impl.inc', 42, 59,
              ['out->linear_rgb[0]!=0', 'KSN_SCENE_KEEP_CHARACTER', 'sc_encode']),
        lines(C / 'code/scene_transport_bridge.c', 1, 27,
              ['#include "../transport/pixel_transport.c"', 'ksn_mesh_pixel_render_scene_composition_experimental', 'shade,c']),
        lines(P / 'observe.py', 46, 70,
              ['HONE_TRANSPORT_MODE', "'.snapshot'", "'-combined.f64le'", 'before==after']),
    ]

    existing_lib = P / 'postprocess-002/profile-buffer.so'
    lib_sha = sha(existing_lib)
    assert lib_sha == '45eeaa678ff921be36bba77393a3f4d0e2715378789ca2e07d2b2cf2099ff8ce'
    assert obj(P / 'postprocess-002/output-hashes.json')['profile-buffer.so'] == lib_sha
    lib = ctypes.CDLL(str(existing_lib))
    lib.profile_buffer.argtypes = [ctypes.c_void_p, ctypes.c_void_p, ctypes.c_size_t,
                                  ctypes.c_uint, ctypes.POINTER(ctypes.c_ulong)]
    lib.profile_buffer.restype = ctypes.c_int
    fields = ['camera', 'light', 'materialGeneration', 'materialFingerprint',
              'groundInputFingerprint', 'groundLe', 'emissionGeneration',
              'visibilityGeneration', 'visibilityGeometryFingerprint',
              'visibilitySnapshotFingerprint', 'transportMode', 'outerSamples',
              'innerSamples', 'physicalDiskEnabled', 'linearLightEnabled',
              'normalPairCodecEnabled', 'agxProfileEnabled', 'disposedBeforeRender']
    frame_proofs = []
    for view in ('front', 'oblique'):
        for case in CASES:
            name = f'native-{view}-{case}'
            previous = P / 'run-001' / name
            current = C / 'on/private-partial' / name
            ext = lambda p, x: Path(str(p) + x)
            old_meta = obj(ext(previous, '.json'))
            new_meta = obj(ext(current, '.json'))
            assert all(old_meta[k] == new_meta[k] for k in fields)
            raw_path = ext(previous, '-combined.f64le')
            raw = np.frombuffer(read(raw_path), dtype='<f8')
            assert raw.size == 97200 and np.isfinite(raw).all() and (raw >= 0).all()
            depth = np.frombuffer(read(ext(previous, '.f32le')), dtype='<f4')
            assert depth.size == 32400 and np.all(np.isfinite(depth) | np.isneginf(depth))
            assert (raw.reshape(32400, 3)[~np.isfinite(depth)] == 0).all()
            encoded = np.zeros(32400, dtype=np.uint16)
            clamped = ctypes.c_ulong()
            assert lib.profile_buffer(raw.ctypes.data, encoded.ctypes.data, 32400, 0, ctypes.byref(clamped)) == 1
            old565 = np.frombuffer(read(ext(previous, '.u16le')), dtype='<u2')
            current565 = np.frombuffer(read(ext(current, '.u16le')), dtype='<u2')
            assert np.array_equal(encoded, old565)
            targets = np.frombuffer(read(ext(current, '.targets.u8')), dtype=np.uint8)
            assert targets.size == 32400 and np.isin(targets, [0, 1]).all()
            events = [json.loads(line) for line in read(ext(current, '.background.jsonl')).decode().splitlines()]
            centers = [event for event in events if event['sample'] == 4294967295]
            center_pixels = [event['y'] * 240 + event['x'] for event in centers]
            assert len(center_pixels) == len(set(center_pixels)) == int((targets == 0).sum())
            assert (targets[center_pixels] == 0).all()
            keep = [event['y'] * 240 + event['x'] for event in centers if event['action'] == 0]
            assert len(keep) == (2779 if view == 'front' else 3306)
            assert all(event['returnedRGB'] == [0, 0, 0] and event['characterHit']
                       for event in events if event['action'] == 0)
            assert np.array_equal(encoded[keep], current565[keep])
            assert np.isfinite(depth[keep]).all()
            frame_proofs.append({
                'view': view, 'case': case, 'reverse': False,
                'snapshot': same(ext(previous, '.snapshot'), ext(current, '.snapshot')),
                'rawDepth': same(ext(previous, '.f32le'), ext(current, '.f32le')),
                'model': same(B / f'compiled/model-{case}/model.aynm', C / f'compiled/model-{case}/model.aynm'),
                'serializedLights': same(B / f'physical-{case}.txt', C / f'on/physical-{case}.txt'),
                'serializedGround': same(B / f'inputs/ground-{case}.txt', C / f'inputs/ground-{case}.txt'),
                'priorMetadata': record(ext(previous, '.json')), 'currentMetadata': record(ext(current, '.json')),
                'equalMetadataFields': fields,
                'selectedMetadataCanonicalSHA256': digest(canonical({k: old_meta[k] for k in fields}).encode()),
                'materialFingerprint': old_meta['materialFingerprint'],
                'groundInputFingerprint': old_meta['groundInputFingerprint'],
                'materialGeneration': old_meta['materialGeneration'],
                'emissionGeneration': old_meta['emissionGeneration'],
                'visibilityGeneration': old_meta['visibilityGeneration'],
                'visibilityGeometryFingerprint': old_meta['visibilityGeometryFingerprint'],
                'visibilitySnapshotFingerprint': old_meta['visibilitySnapshotFingerprint'],
                'capturedCenterHDR': record(raw_path),
                'compositionEvents': record(ext(current, '.background.jsonl')),
                'targets': record(ext(current, '.targets.u8')),
                'currentRGB565': record(ext(current, '.u16le')),
                'priorRGB565': record(ext(previous, '.u16le')),
                'finiteNonnegativeHDR': True, 'backgroundHDRZero': True,
                'allPriorPixelsDisabledProfileEncodeExact': True,
                'currentNonTargetKeepPixels': len(keep),
                'currentNonTargetKeepDisabledProfileEncodeExact': True,
                'allKeepReturnedRGBZero': True,
            })

    profile_manifest = obj(G / 'sha256-manifest.json')
    for path, h in profile_manifest.items():
        assert sha(G / path) == h
    provenance = obj(G / 'provenance.json')
    assert len(provenance['all_dependency_sha256']) == 20
    for path, h in provenance['all_dependency_sha256'].items():
        assert sha(G / 'official-colormanagement' / path) == h
        assert sha(Path(provenance['installed_config']).parent / path) == h
    assert sha(W / 'fox-reference-uncertainty-v3/input/source-settings.json') == provenance['source_settings_sha256']
    frozen = obj(G / 'frozen.json')
    assert (frozen['size'], frozen['display'], frozen['view'], frozen['look'],
            frozen['exposure'], frozen['gamma'], frozen['dither']) == (
                65, 'sRGB', 'AgX', 'AgX - Medium High Contrast', 0, 1, 0)

    # Verify every input read above remained unchanged. Output is still stdout only.
    for path, h in list(READ_HASHES.items()):
        assert digest((W / path).read_bytes()) == h, f'INPUT_MUTATED: {path}'
    proof = {
        'status': 'PASS_SOURCE_INPUT_DERIVED_CENTER_HDR_EQUIVALENCE',
        'scope': 'Ten forward frames, matching non-target KEEP centers only; current quarter HDR and floor/world replacements must remain current.',
        'caveat': 'No independently recorded current center-f64 buffer exists. Equivalence is derived from exact source arithmetic, shader, inputs and bindings, not a direct current-versus-prior f64 comparison. RGB565 agreement alone is necessary but insufficient.',
        'operations': {'rendered': False, 'compiled': False, 'generatedProfile': False,
                       'enabledProfileCalls': 0, 'disabledProfileCalls': 10,
                       'savedRawHDRGeometryImages': False, 'scriptWritesFiles': False},
        'auditCode': record(Path(__file__)),
        'captureCompletion': record(P / 'run-001/COMPLETED.json'),
        'priorBeforeAfterManifest': same(P / 'run-001/input-hashes-before.json', P / 'run-001/input-hashes-after.json'),
        'priorRelevantInputPinsVerified': len(prior_relevant),
        'currentInputPins': record(C / 'input-hashes.json'), 'currentInputPinsVerified': len(current_pins),
        'builds': {'prior': record(P / 'run-001/build.json'), 'current': record(C / 'PREPARED.json'),
                   'binaryHashesVerified': True, 'floatingPointFlagsExact': True, 'flags': new_build['flags']},
        'normalization': {'functionSignaturesExcluded': ['static bool strip(', 'static bool aa_center_strip('],
                          'extraction': 'From first opening brace following exact signature to first line-start closing brace.',
                          'priorExactRemoval': old_remove, 'currentExactRemoval': new_remove,
                          'removalCountRequiredEach': 1, 'thenRemoveWhitespaceRegex': r'\s+',
                          'normalizedBodiesExact': True, 'normalizedBodySHA256': normalized_hash},
        'sourceLineChecks': anchors, 'sharedSources': shared,
        'transportOriginalBytePrefixExact': {'prior': record(P / 'transport/pixel_transport.c'),
                                            'current': record(C / 'transport/pixel_transport.c'), 'exact': True},
        'nativeSceneSetupBlock': {'startMarker': ' const char *diskfile=',
                                 'priorEndMarker': ' size_t scene_bytes=',
                                 'currentEndMarker': ' const fox_bg_fixed_input',
                                 'byteExact': True, 'sha256': digest(old_setup.encode())},
        'existingDisabledProfileLibrary': record(existing_lib),
        'frames': frame_proofs,
        'fixedProfile': {'frozen': record(G / 'frozen.json'), 'settings': frozen,
                         'manifest': record(G / 'sha256-manifest.json'), 'allManifestEntriesVerified': len(profile_manifest),
                         'provenance': record(G / 'provenance.json'), 'installedAndVendoredDependencyCount': 20,
                         'configSHA256': provenance['config_sha256'],
                         'sourceSettingsSHA256': provenance['source_settings_sha256'],
                         'privateOnly': provenance['private_only'],
                         'publicationStatus': provenance['license']['status']},
        'allReadInputsUnchanged': True,
        'readInputCount': len(READ_HASHES),
        'readInputPathHashMapSHA256': digest(canonical(READ_HASHES).encode()),
    }
    print(json.dumps(proof, indent=2, sort_keys=True, allow_nan=False))


if __name__ == '__main__':
    main()
