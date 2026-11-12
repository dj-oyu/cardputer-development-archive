"""Synthetic input/metric checks. Does not render or modify reference artifacts."""
import copy
import hashlib
import json
from pathlib import Path
import tempfile
import unittest

import numpy as np
import score_candidate as S


HERE = Path(__file__).resolve().parent
REFERENCE = HERE.parents[1] / 'fox-reference-uncertainty-v3'


class DecodeTests(unittest.TestCase):
    def test_decode_exact_channel_values_not_png8(self):
        words = np.array([0, 0xffff, 0xf800, 0x07e0, 0x001f, (1 << 11) | (1 << 5) | 1], dtype='<u2')
        rgb = S.decode_rgb565(words.tobytes(), [6, 1])[0]
        np.testing.assert_array_equal(rgb[:5], [[0, 0, 0], [1, 1, 1], [1, 0, 0], [0, 1, 0], [0, 0, 1]])
        np.testing.assert_array_equal(rgb[5], [1 / 31, 1 / 63, 1 / 31])
        self.assertNotEqual(rgb[5, 0], round(255 / 31) / 255)
        self.assertEqual(rgb.dtype, np.float64)
        # Explicit bytes prove little-endian, independent of host-endian dtype.
        np.testing.assert_array_equal(S.decode_rgb565(bytes([0, 248]), [1, 1]), [[[1, 0, 0]]])

    def test_depth_rejects_nonfinite_except_negative_infinity(self):
        data = np.array([-np.inf, 2], dtype='<f4').tobytes()
        self.assertEqual(np.isfinite(S.decode_depth(data, [2, 1])).sum(), 1)
        for values in ([np.nan, 2], [np.inf, 2], [-np.inf, -np.inf]):
            with self.subTest(values=values), self.assertRaises(ValueError):
                S.decode_depth(np.array(values, dtype='<f4').tobytes(), [2, 1])

    def test_shape_includes_extra_and_missing_across_frame(self):
        source = np.array([[True, False], [True, False]])
        native = np.array([[True, True], [False, False]])
        metrics = S.shape_metrics(source, native)
        self.assertEqual(metrics['IoU'], 1 / 3)
        self.assertEqual(metrics['extraPixels'], 1)
        self.assertEqual(metrics['missingPixels'], 1)
        empty = S.shape_metrics(np.zeros((2, 2), bool), np.zeros((2, 2), bool))
        self.assertIsNone(empty['IoU'])
        self.assertEqual(empty['status'], 'N/A_NOT_PASS')

    def test_duplicate_json_and_nonfinite_numbers_rejected(self):
        for data in (b'{"x":1,"x":2}', b'{"x":NaN}', b'{"x":1e999}'):
            with self.subTest(data=data), self.assertRaises(ValueError):
                S.read_json_bytes(data)


class CandidateTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.reference = S.load_reference(REFERENCE)
        cls.config = cls.reference['config']

    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='.test-candidate-', dir=HERE)
        self.root = Path(self.temp.name)
        self.manifest_path = self.root / 'manifest.json'
        source = self.root / 'synthetic.c'
        source.write_text('/* Synthetic data validation only, not renderer-fidelity evidence. */\n')
        self.manifest = {
            'schemaVersion': 'fox-candidate-rgb565-v1',
            'candidate': {'label': 'SYNTHETIC_TEST_ONLY', 'sourceLabel': 'synthetic.c', 'head': 'synthetic-no-commit',
                          'sourceFiles': [{'file': source.name, 'sha256': S.sha(source)}]},
            'reference': {'version': 'new-reference-uncertainty-v3', 'configSHA256': S.REFERENCE_CONFIG_SHA},
            'resolution': [240, 135], 'rgb565Format': 'RGB565_U16_LE_ROW_MAJOR',
            'depthFormat': 'FLOAT32_LE_ROW_MAJOR_NEG_INF_BACKGROUND', 'frames': []}
        cameras = {c['name']: c for c in self.config['cameras']}
        cases = {c['name']: c for c in self.config['scenarios']}
        native_cases = {}
        for name, case in cases.items():
            light = case.get('blenderLight')
            native_cases[name] = {**case, 'ambient': 0.35 * case.get('richWorldScale', 1), 'diffuse': 0.65,
                'intensity': [x * case.get('richEnergyScale', 1) for x in [1, 0.83, 0.65]],
                'nativeDirection': [light[0], -light[2], -light[1]] if light else [-3, -4.3, 4]}
        (self.root / 'inputs').mkdir()
        native_path = self.root / 'inputs/candidate-config.json'
        native_path.write_text(json.dumps({'referenceConfigSHA256': S.REFERENCE_CONFIG_SHA,
            'sourceSHA256': self.config['sourceSHA256'], 'cameras': self.config['cameras'],
            'scenarios': list(native_cases.values())}))
        self.manifest['candidate']['sourceFiles'].append({'file': 'inputs/candidate-config.json', 'sha256': S.sha(native_path)})
        for view in S.VIEWS:
            for case in S.CASES:
                rgb = self.root / f'{view}-{case}.u16le'
                depth = self.root / f'{view}-{case}.f32le'
                rgb.write_bytes(np.full((135, 240), 0x8410, dtype='<u2').tobytes())
                d = np.full((135, 240), -np.inf, dtype='<f4')
                d[20:40, 60:80] = 2
                depth.write_bytes(d.tobytes())
                self.manifest['frames'].append({
                    'view': view, 'case': case,
                    'rgb565': {'file': rgb.name, 'sha256': S.sha(rgb)},
                    'depth': {'file': depth.name, 'sha256': S.sha(depth)},
                    'metadata': {'resolution': [240, 135], 'nativeCamera': cameras[view]['nativeCamera'],
                                 'scenario': cases[case], 'sourceLabel': 'synthetic.c', 'head': 'synthetic-no-commit',
                                 'nativeInput': native_cases[case], 'actual': {'camera': cameras[view]['nativeCamera'],
                                 'light': native_cases[case]['nativeDirection'] + native_cases[case]['intensity']}}})
        for frame in self.manifest['frames']:
            frame['metadata']['actual'].update({'visibilityEnabled': False, 'visibilityComplete': True,
                'visibilityGeneration': [0, 0, 0], 'visibilityGeometryFingerprint': '0' * 16,
                'visibilitySnapshotFingerprint': '0' * 16, 'visibilityBindingBytes': 48, 'visibilityBudgetBytes': 48,
                **S.VISIBILITY_LIMITS, **dict.fromkeys(S.VISIBILITY_COUNTS, 0)})
        for frame in self.manifest['frames']:
            frame['metadata']['actual'].update({'transportMode': 0, 'outerSamples': 16, 'innerSamples': 16,
                'transportComplete': True, 'materialGeneration': 0, 'materialFingerprint': '0'*16,
                'transportContextBytes': 184, 'transportBudgetBytes': 48,
                **S.TRANSPORT_LIMITS, **dict.fromkeys(S.TRANSPORT_COUNTS, 0)})
        self.save()

    def tearDown(self):
        self.temp.cleanup()

    def save(self, manifest=None):
        self.manifest_path.write_text(json.dumps(self.manifest if manifest is None else manifest))

    def load(self):
        return S.load_candidate(self.manifest_path, self.config)

    def test_valid_synthetic_input_and_direct_decode(self):
        candidate = self.load()
        self.assertEqual(len(candidate['frames']), 10)
        np.testing.assert_array_equal(candidate['frames'][('front', 'baseline')]['rgb'][0, 0], [16 / 31, 32 / 63, 16 / 31])

    def test_manifest_corruption_rejected(self):
        for variant in ('missing', 'duplicate', 'unexpected', 'hash', 'camera', 'scenario', 'head', 'format', 'resolution', 'source_hash', 'path_reuse', 'actual_camera', 'actual_light', 'native_input', 'actual_missing', 'native_config_missing'):
            manifest = copy.deepcopy(self.manifest)
            frame = manifest['frames'][0]
            if variant == 'missing': manifest['frames'].pop()
            if variant == 'duplicate': manifest['frames'][-1] = copy.deepcopy(frame)
            if variant == 'unexpected': frame['view'] = 'rear'
            if variant == 'hash': frame['rgb565']['sha256'] = '0' * 64
            if variant == 'camera': frame['metadata']['nativeCamera'][0] += 0.1
            if variant == 'scenario': frame['metadata']['scenario']['albedoScale'] = 0.2
            if variant == 'head': frame['metadata']['head'] = 'other'
            if variant == 'format': manifest['rgb565Format'] = 'RGB565_U16_BE'
            if variant == 'resolution': manifest['resolution'] = [135, 240]
            if variant == 'source_hash': manifest['candidate']['sourceFiles'][0]['sha256'] = '0' * 64
            if variant == 'actual_camera': frame['metadata']['actual']['camera'][0] += 0.1
            if variant == 'actual_light': frame['metadata']['actual']['light'][0] += 0.1
            if variant == 'native_input': frame['metadata']['nativeInput']['diffuse'] = 0.1
            if variant == 'actual_missing': del frame['metadata']['actual']
            if variant == 'native_config_missing': manifest['candidate']['sourceFiles'].pop()
            if variant == 'path_reuse': manifest['frames'][1]['rgb565'] = copy.deepcopy(frame['rgb565'])
            self.save(manifest)
            with self.subTest(variant=variant), self.assertRaises(ValueError):
                self.load()

    def set_physical_mode(self, value):
        entry = next(x for x in self.manifest['candidate']['sourceFiles'] if x['file'] == 'inputs/candidate-config.json')
        path = self.root / entry['file']
        native = json.loads(path.read_text())
        native['physicalDiskEnabled'] = value
        source_bytes = (HERE / 'fixtures/physical-source.json').read_bytes()
        physical = json.loads(source_bytes)
        cases = physical['cases']
        source_path = self.root / 'inputs/physical-source.json'
        source_path.write_bytes(source_bytes)
        self.manifest['candidate']['sourceFiles'] = [x for x in self.manifest['candidate']['sourceFiles'] if x['file'] != 'inputs/physical-source.json']
        self.manifest['candidate']['sourceFiles'].append({'file': 'inputs/physical-source.json', 'sha256': S.sha(source_path)})
        (self.root / 'code').mkdir(exist_ok=True)
        for name in ('read_lights.py', 'read_source.py'):
            target = self.root / 'code' / name
            target.write_bytes((HERE / 'fixtures' / name).read_bytes())
            relative = 'code/' + name
            self.manifest['candidate']['sourceFiles'] = [x for x in self.manifest['candidate']['sourceFiles'] if x['file'] != relative]
            self.manifest['candidate']['sourceFiles'].append({'file': relative, 'sha256': S.sha(target)})
        lookup = {x['name']: x for x in cases}
        for scenario in native['scenarios']:
            if value is True: scenario['physical'] = lookup[scenario['name']]
            else: scenario.pop('physical', None)
        path.write_text(json.dumps(native))
        entry['sha256'] = S.sha(path)
        scenarios = {x['name']: x for x in native['scenarios']}
        for frame in self.manifest['frames']:
            frame['metadata']['actual']['physicalDiskEnabled'] = value
            frame['metadata']['nativeInput'] = copy.deepcopy(scenarios[frame['case']])
        self.save()

    def edit_native_config(self, changes, remove=()):
        entry = next(x for x in self.manifest['candidate']['sourceFiles'] if x['file'] == 'inputs/candidate-config.json')
        path = self.root / entry['file']
        native = json.loads(path.read_text())
        native.update(changes)
        for key in remove:
            native.pop(key, None)
        path.write_text(json.dumps(native))
        entry['sha256'] = S.sha(path)
        self.save()

    def set_pixel_mode(self, value):
        self.set_linear_mode(True)
        self.set_physical_mode(True)
        self.edit_native_config({'pixelLightEnabled': value, 'agxProfileEnabled': False})
        for frame in self.manifest['frames']:
            frame['metadata']['actual'].update({
                'pixelLightEnabled': value, 'agxProfileEnabled': False,
                'shadeUpdates': 1 if value else 0, 'diskSamples': 48 if value else 0,
                'snapshotBytes': 65536, 'snapshotCapacity': 65536, 'work': 8_000_000,
                'snapshotControlBytes': 64 if value else 48, 'rawFieldScratchBytes': 2080})
        self.save()

    def test_pixel_valid_off_on_and_budget_boundaries(self):
        for mode in (False, True):
            self.set_pixel_mode(mode)
            self.assertEqual(len(self.load()['frames']), 10)

    def test_pixel_config_types_rejected_after_rehash(self):
        for value in (0, 1, None, 'true', [], {}):
            self.set_pixel_mode(False)
            self.edit_native_config({'pixelLightEnabled': value})
            with self.subTest(value=value), self.assertRaisesRegex(ValueError, 'config pixelLightEnabled must be boolean'):
                self.load()

    def test_pixel_wrong_missing_or_orphan_echo_rejected(self):
        for mode in (False, True):
            for value in (not mode, int(mode), None, 'true', 'MISSING'):
                self.set_pixel_mode(mode)
                actual = self.manifest['frames'][0]['metadata']['actual']
                actual['pixelLightEnabled'] = value
                if value == 'MISSING': del actual['pixelLightEnabled']
                self.save()
                with self.subTest(mode=mode, value=value), self.assertRaisesRegex(ValueError, 'actual pixelLightEnabled mismatch'):
                    self.load()
        self.set_pixel_mode(False)
        self.edit_native_config({}, remove=('pixelLightEnabled',))
        with self.assertRaisesRegex(ValueError, 'lacks config declaration'):
            self.load()

    def test_pixel_dependencies_coordinated_rehash_rejected(self):
        for field in ('linearLightEnabled', 'physicalDiskEnabled'):
            for value in (False, None):
                self.set_pixel_mode(True)
                self.edit_native_config({field: value} if value is not None else {},
                                        remove=(field,) if value is None else ())
                for frame in self.manifest['frames']:
                    frame['metadata']['actual'][field] = value
                self.save()
                with self.subTest(field=field, value=value), self.assertRaisesRegex(ValueError, 'pixel lighting requires'):
                    self.load()

    def test_pixel_agx_config_and_actual_false_strict(self):
        for mode in (False, True):
            for value in (True, 0, 1, None, 'false'):
                self.set_pixel_mode(mode)
                self.edit_native_config({'agxProfileEnabled': value})
                for frame in self.manifest['frames']:
                    frame['metadata']['actual']['agxProfileEnabled'] = value
                self.save()
                with self.subTest(mode=mode, value=value), self.assertRaisesRegex(ValueError, 'config agxProfileEnabled'):
                    self.load()
                self.edit_native_config({'agxProfileEnabled': False})
                with self.assertRaisesRegex(ValueError, 'actual agxProfileEnabled'):
                    self.load()
        self.set_pixel_mode(False)
        self.edit_native_config({}, remove=('agxProfileEnabled',))
        with self.assertRaisesRegex(ValueError, 'config agxProfileEnabled'):
            self.load()
        self.set_pixel_mode(False)
        del self.manifest['frames'][0]['metadata']['actual']['agxProfileEnabled']
        self.save()
        with self.assertRaisesRegex(ValueError, 'actual agxProfileEnabled'):
            self.load()

    def test_pixel_runtime_fields_strict_nonnegative_integers(self):
        for field in ('shadeUpdates', 'diskSamples', 'snapshotBytes', 'snapshotCapacity',
                      'work', 'snapshotControlBytes', 'rawFieldScratchBytes'):
            for value in (-1, True, False, 1.0, None, '0', 'MISSING'):
                self.set_pixel_mode(True)
                actual = self.manifest['frames'][0]['metadata']['actual']
                actual[field] = value
                if value == 'MISSING': del actual[field]
                self.save()
                with self.subTest(field=field, value=value), self.assertRaisesRegex(ValueError, 'must be a nonnegative integer'):
                    self.load()

    def test_pixel_runtime_invalid_counters_and_budgets(self):
        variants = [({'diskSamples': 47}, 'diskSamples'),
                    ({'shadeUpdates': 0, 'diskSamples': 0}, 'shadeUpdates'),
                    ({'snapshotBytes': 65537}, 'snapshotBytes'),
                    ({'snapshotBytes': 415}, 'snapshotBytes'),
                    ({'snapshotCapacity': 65535}, 'snapshotCapacity'),
                    ({'work': 8_000_001}, 'work'),
                    ({'snapshotControlBytes': 48}, 'snapshotControlBytes'),
                    ({'rawFieldScratchBytes': 2079}, 'rawFieldScratchBytes')]
        for changes, error in variants:
            self.set_pixel_mode(True)
            self.manifest['frames'][0]['metadata']['actual'].update(changes)
            self.save()
            with self.subTest(changes=changes), self.assertRaisesRegex(ValueError, error):
                self.load()
        for changes, error in (({'shadeUpdates': 1, 'diskSamples': 48}, 'shadeUpdates'),
                               ({'snapshotControlBytes': 64}, 'snapshotControlBytes')):
            self.set_pixel_mode(False)
            self.manifest['frames'][0]['metadata']['actual'].update(changes)
            self.save()
            with self.assertRaisesRegex(ValueError, error):
                self.load()

    def set_visibility_mode(self, mode):
        self.set_pixel_mode(True)
        self.edit_native_config({'visibilityEnabled': mode})
        for frame in self.manifest['frames']:
            frame['metadata']['actual'].update({'visibilityEnabled': mode, 'visibilityComplete': True,
                'visibilityGeneration': [1, 1, 1] if mode else [0, 0, 0],
                'visibilityGeometryFingerprint': 'a' * 16 if mode else '0' * 16,
                'visibilitySnapshotFingerprint': 'b' * 16 if mode else '0' * 16,
                'visibilityBindingBytes': 48, 'visibilityBudgetBytes': 48,
                **S.VISIBILITY_LIMITS, **dict.fromkeys(S.VISIBILITY_COUNTS, 0)})
            if mode is True:
                frame['metadata']['actual'].update({'visibilitySceneBytes': 326496,
                    'visibilitySceneNodes': 795, 'visibilityTriangles': 1166, 'visibilityVertices': 849,
                    'visibilityBuildNs': 1, 'visibilityTemporaryBytes': 34368,
                    'shadeUpdates': 25000, 'diskSamples': 1200000,
                    'visibilityRays': 1000000, 'visibilityNodeVisits': 100000000,
                    'visibilityTriangleTests': 50000000})
        self.save()

    def test_visibility_valid_off_on_default_false(self):
        self.load()
        for mode in (False, True):
            self.set_visibility_mode(mode)
            self.assertEqual(len(self.load()['frames']), 10)
        self.set_visibility_mode(False)
        self.edit_native_config({}, remove=('visibilityEnabled',))
        self.load()

    def test_visibility_config_type_and_echo_rejected(self):
        for value in (None, 0, 1, 'false', [], {}):
            self.set_visibility_mode(False)
            self.edit_native_config({'visibilityEnabled': value})
            with self.subTest(value=value), self.assertRaisesRegex(ValueError, 'config visibilityEnabled'):
                self.load()
        for mode in (False, True):
            for value in (not mode, int(mode), None, 'MISSING'):
                self.set_visibility_mode(mode)
                actual = self.manifest['frames'][0]['metadata']['actual']
                actual['visibilityEnabled'] = value
                if value == 'MISSING': del actual['visibilityEnabled']
                self.save()
                with self.subTest(mode=mode, value=value), self.assertRaisesRegex(ValueError, 'actual visibilityEnabled'):
                    self.load()

    def test_visibility_dependencies_coordinated_config_echo_rehash(self):
        for field in ('pixelLightEnabled', 'linearLightEnabled', 'physicalDiskEnabled', 'agxProfileEnabled'):
            self.set_visibility_mode(True)
            value = field == 'agxProfileEnabled'
            self.edit_native_config({field: value})
            for frame in self.manifest['frames']:
                frame['metadata']['actual'][field] = value
            self.save()
            with self.subTest(field=field), self.assertRaisesRegex(ValueError, 'visibility requires'):
                self.load()

    def test_visibility_completion_mandatory_true(self):
        for mode in (False, True):
            for value in (False, 1, None, 'true', 'MISSING'):
                self.set_visibility_mode(mode)
                actual = self.manifest['frames'][0]['metadata']['actual']
                actual['visibilityComplete'] = value
                if value == 'MISSING': del actual['visibilityComplete']
                self.save()
                with self.subTest(mode=mode, value=value), self.assertRaisesRegex(ValueError, 'visibilityComplete'):
                    self.load()

    def test_visibility_counts_limits_strict_types_and_missing(self):
        for field in (*S.VISIBILITY_LIMITS, *S.VISIBILITY_COUNTS):
            for value in (None, -1, True, 0.0, '0', 'MISSING'):
                self.set_visibility_mode(True)
                actual = self.manifest['frames'][0]['metadata']['actual']
                actual[field] = value
                if value == 'MISSING': del actual[field]
                self.save()
                with self.subTest(field=field, value=value), self.assertRaisesRegex(ValueError, 'nonnegative integer'):
                    self.load()

    def test_visibility_generation_fingerprints_sizes_strict(self):
        for mode in (False, True):
            mutations = {
                'visibilityGeneration': [None, [], [1, 1], [1, 1, 2], [True, True, True],
                                         [1.0, 1.0, 1.0], [0, 0, 0] if mode else [1, 1, 1]],
                'visibilityGeometryFingerprint': [None, 0, 'A'*16, 'g'*16, 'a'*15, 'a'*17,
                                                  '0'*16 if mode else 'a'*16],
                'visibilitySnapshotFingerprint': [None, 0, 'A'*16, 'g'*16, 'a'*15, 'a'*17,
                                                  '0'*16 if mode else 'a'*16],
                'visibilityBindingBytes': [None, True, 48.0, 0, 47, 49],
                'visibilityBudgetBytes': [None, True, 48.0, 0, 47, 49]}
            for field, values in mutations.items():
                for value in [*values, 'MISSING']:
                    self.set_visibility_mode(mode)
                    actual = self.manifest['frames'][0]['metadata']['actual']
                    actual[field] = value
                    if value == 'MISSING': del actual[field]
                    self.save()
                    with self.subTest(mode=mode, field=field, value=value), self.assertRaisesRegex(ValueError, field):
                        self.load()

    def test_visibility_fixed_fixture_inconsistent_runtime_rejected(self):
        mutations = [
            {'visibilitySceneNodes': 4096}, {'visibilitySceneNodes': 2332},
            {'visibilityTemporaryBytes': 10**12}, {'visibilitySceneBytes': 1},
            {'visibilityRays': 0, 'visibilityNodeVisits': 0, 'visibilityTriangleTests': 0},
            {'visibilityRays': 100, 'visibilityNodeVisits': 1},
            {'visibilityRays': 49, 'shadeUpdates': 1, 'diskSamples': 48},
            {'visibilityTriangleTests': 0}]
        for changes in mutations:
            self.set_visibility_mode(True)
            self.manifest['frames'][0]['metadata']['actual'].update(changes)
            self.save()
            with self.subTest(changes=changes), self.assertRaisesRegex(ValueError, 'visibility'):
                self.load()

    def test_visibility_fixed_limits_and_overflow(self):
        for field, value in S.VISIBILITY_LIMITS.items():
            self.set_visibility_mode(True)
            self.manifest['frames'][0]['metadata']['actual'][field] = value + 1
            self.save()
            with self.subTest(field=field), self.assertRaisesRegex(ValueError, 'fixed .* mismatch'):
                self.load()
        for field, value in {'visibilityRays':1000001, 'visibilityNodeVisits':100000001,
                            'visibilityTriangleTests':50000001, 'visibilitySceneBytes':524289}.items():
            self.set_visibility_mode(True)
            self.manifest['frames'][0]['metadata']['actual'][field] = value
            self.save()
            with self.subTest(field=field), self.assertRaisesRegex(ValueError, 'exceeds fixed budget'):
                self.load()

    def test_visibility_scene_positive_geometry_and_off_zero(self):
        for field in ('visibilitySceneBytes', 'visibilitySceneNodes', 'visibilityBuildNs', 'visibilityTemporaryBytes',
                      'visibilityTriangles', 'visibilityVertices'):
            self.set_visibility_mode(True)
            self.manifest['frames'][0]['metadata']['actual'][field] = 0
            self.save()
            with self.subTest(field=field), self.assertRaises(ValueError):
                self.load()
        for field in S.VISIBILITY_COUNTS:
            self.set_visibility_mode(False)
            self.manifest['frames'][0]['metadata']['actual'][field] = 1
            self.save()
            with self.subTest(field=field), self.assertRaisesRegex(ValueError, 'OFF counters and timing'):
                self.load()

    def set_transport_mode(self, mode, outer=16):
        self.set_visibility_mode(True)
        self.edit_native_config({'transportMode': mode, 'outerSamples': outer, 'innerSamples': 16})
        for frame in self.manifest['frames']:
            actual = frame['metadata']['actual']
            actual.update({'transportMode': mode, 'outerSamples': outer, 'innerSamples': 16,
                'transportComplete': True, 'materialGeneration': 1 if mode else 0,
                'materialFingerprint': 'a'*16 if mode else '0'*16,
                'transportContextBytes': 184, 'transportBudgetBytes': 48,
                **S.TRANSPORT_LIMITS, **dict.fromkeys(S.TRANSPORT_COUNTS, 0)})
            if mode:
                rays = actual['shadeUpdates'] * outer
                actual.update({'transportSceneBytes': 75128, 'transportTemporaryBytes': 74624,
                    'transportBuildNs': 1, 'primary_rays': rays, 'primary_hits': rays//2,
                    'primary_misses': rays-rays//2, 'primary_direct_queries': actual['visibilityRays'],
                    'transportRays': rays, 'transportNodeVisits': rays, 'transportTriangleTests': 1})
                if mode == 2:
                    secondary = actual['primary_hits'] * 16
                    actual.update({'secondary_world_rays': secondary, 'transportRays': rays + secondary,
                                   'transportNodeVisits': rays + secondary})
        self.save()

    def test_transport_valid_modes_and_samples(self):
        self.load()
        for mode in (0, 1, 2):
            for outer in (16, 64):
                self.set_transport_mode(mode, outer)
                self.load()

    def test_transport_config_and_echo_strict(self):
        for field, values in {'transportMode': [True, None, -1, 3, 1.0],
                              'outerSamples': [True, None, 0, 32, 16.0],
                              'innerSamples': [True, None, 0, 64, 16.0]}.items():
            for value in values:
                self.set_transport_mode(1)
                self.edit_native_config({field: value})
                with self.subTest(field=field, value=value), self.assertRaisesRegex(ValueError, 'config '+field): self.load()
        for field in ('transportMode', 'outerSamples', 'innerSamples', 'transportComplete'):
            for value in (None, False, 'MISSING'):
                self.set_transport_mode(1)
                actual = self.manifest['frames'][0]['metadata']['actual'];actual[field] = value
                if value == 'MISSING': del actual[field]
                self.save()
                with self.subTest(field=field, value=value), self.assertRaisesRegex(ValueError, field): self.load()

    def test_transport_dependencies_coordinated_rehash(self):
        for field in ('visibilityEnabled', 'pixelLightEnabled', 'linearLightEnabled', 'physicalDiskEnabled', 'agxProfileEnabled'):
            self.set_transport_mode(1)
            value = field == 'agxProfileEnabled'
            self.edit_native_config({field: value})
            for frame in self.manifest['frames']: frame['metadata']['actual'][field] = value
            self.save()
            with self.subTest(field=field), self.assertRaisesRegex(ValueError, 'transport requires'): self.load()

    def test_transport_integer_fields_and_fingerprint(self):
        fields = (*S.TRANSPORT_LIMITS, *S.TRANSPORT_COUNTS, 'materialGeneration', 'transportContextBytes', 'transportBudgetBytes')
        for field in fields:
            for value in (None, True, -1, 1.0, 'MISSING'):
                self.set_transport_mode(2)
                actual = self.manifest['frames'][0]['metadata']['actual']; actual[field] = value
                if value == 'MISSING': del actual[field]
                self.save()
                with self.subTest(field=field, value=value), self.assertRaisesRegex(ValueError, field): self.load()
        for value in (None, 0, 'A'*16, 'g'*16, 'a'*15, '0'*16):
            self.set_transport_mode(2)
            self.manifest['frames'][0]['metadata']['actual']['materialFingerprint'] = value; self.save()
            with self.subTest(value=value), self.assertRaisesRegex(ValueError, 'materialFingerprint'): self.load()

    def test_transport_limits_scene_and_accounting_mutations(self):
        mutations = [{field: limit+1} for field,limit in S.TRANSPORT_LIMITS.items()] + [
            {'transportRays':20000001}, {'transportNodeVisits':800000001}, {'transportTriangleTests':300000001},
            {'transportSceneBytes':262145}, {'transportSceneBytes':1}, {'transportTemporaryBytes':1},
            {'transportContextBytes':1}, {'transportBudgetBytes':1}, {'transportBuildNs':0}, {'materialGeneration':2},
            {'primary_rays':1}, {'primary_hits':1}, {'primary_misses':1}, {'primary_direct_queries':1},
            {'transportRays':1}, {'transportNodeVisits':1}, {'secondary_world_rays':10**8},
            {'secondary_direct_queries':10**8}, {'zero_reflection_ns_v':10**8},
            {'back_single_discard':10**8}, {'grazing_ng_v':10**8}]
        for changes in mutations:
            self.set_transport_mode(2); self.manifest['frames'][0]['metadata']['actual'].update(changes); self.save()
            with self.subTest(changes=changes), self.assertRaises(ValueError): self.load()

    def test_transport_modes_zero_and_secondary_constraints(self):
        for field in S.TRANSPORT_COUNTS:
            self.set_transport_mode(0);self.manifest['frames'][0]['metadata']['actual'][field]=1;self.save()
            with self.subTest(field=field), self.assertRaisesRegex(ValueError, 'mode0'): self.load()
        for field in ('secondary_world_rays','secondary_direct_queries','zero_reflection_ns_v','back_single_discard','grazing_ng_v'):
            self.set_transport_mode(1);a=self.manifest['frames'][0]['metadata']['actual'];a[field]=1
            if field.startswith('secondary_'): a['transportRays']+=1;a['transportNodeVisits']+=1
            self.save()
            with self.subTest(field=field), self.assertRaisesRegex(ValueError, 'mode1'): self.load()
        self.set_transport_mode(2)
        a=self.manifest['frames'][0]['metadata']['actual'];hits=a['primary_hits']
        a.update({'secondary_world_rays':hits*16,'secondary_direct_queries':hits*48,
                  'zero_reflection_ns_v':0,'back_single_discard':0,'grazing_ng_v':hits})
        a['transportRays']=a['primary_rays']+hits*64;a['transportNodeVisits']=a['transportRays'];self.save();self.load()

    def test_transport_exact_reflectable_hit_accounting(self):
        for variant in ('zero_secondary', 'both_discards_all_hits', 'direct_over_reflectable', 'zero_triangles', 'subtract_grazing'):
            self.set_transport_mode(2)
            a=self.manifest['frames'][0]['metadata']['actual'];hits=a['primary_hits']
            if variant == 'zero_secondary': a['secondary_world_rays']=0
            if variant == 'both_discards_all_hits':
                a.update({'back_single_discard':hits, 'zero_reflection_ns_v':hits, 'secondary_world_rays':0})
            if variant == 'direct_over_reflectable':
                a.update({'back_single_discard':hits-1, 'secondary_world_rays':16, 'secondary_direct_queries':49})
            if variant == 'zero_triangles': a['transportTriangleTests']=0
            if variant == 'subtract_grazing':
                a.update({'grazing_ng_v':1, 'secondary_world_rays':(hits-1)*16})
            a['transportRays']=a['primary_rays']+a['secondary_world_rays']+a['secondary_direct_queries']
            a['transportNodeVisits']=a['transportRays'];self.save()
            with self.subTest(variant=variant), self.assertRaises(ValueError): self.load()
        # Complete physical discard is valid; grazing does not reduce reflectable hits.
        self.set_transport_mode(2)
        a=self.manifest['frames'][0]['metadata']['actual'];hits=a['primary_hits']
        a.update({'back_single_discard':hits,'secondary_world_rays':0,'secondary_direct_queries':0,
                  'transportRays':a['primary_rays'],'transportNodeVisits':a['primary_rays']})
        self.save();self.load()
        self.set_transport_mode(1)
        self.manifest['frames'][0]['metadata']['actual']['transportTriangleTests']=0;self.save()
        with self.assertRaisesRegex(ValueError, 'triangle tests must be positive'): self.load()

    def test_coordinated_physical_source_config_echo_rehash_rejected(self):
        for mutation in ('fill_power', 'world_rgb', 'rim_position'):
            self.set_physical_mode(True)
            source_entry = next(x for x in self.manifest['candidate']['sourceFiles'] if x['file'] == 'inputs/physical-source.json')
            source_path = self.root / source_entry['file']
            physical = json.loads(source_path.read_text())
            for case in physical['cases']:
                if mutation == 'fill_power': case['lights'][1]['power'] += 1
                if mutation == 'world_rgb': case['worldRGB'][0] = 0.9
                if mutation == 'rim_position': case['lights'][2]['position'][0] += 0.1
            source_path.write_text(json.dumps(physical))
            source_entry['sha256'] = S.sha(source_path)
            config_entry = next(x for x in self.manifest['candidate']['sourceFiles'] if x['file'] == 'inputs/candidate-config.json')
            config_path = self.root / config_entry['file']
            native = json.loads(config_path.read_text())
            cases = {x['name']: x for x in physical['cases']}
            for scenario in native['scenarios']: scenario['physical'] = cases[scenario['name']]
            config_path.write_text(json.dumps(native))
            config_entry['sha256'] = S.sha(config_path)
            scenarios = {x['name']: x for x in native['scenarios']}
            for frame in self.manifest['frames']:
                frame['metadata']['nativeInput'] = copy.deepcopy(scenarios[frame['case']])
            self.save()
            with self.subTest(mutation=mutation), self.assertRaisesRegex(ValueError, 'fixed physical source hash mismatch'):
                self.load()

    def test_rehashed_physical_extractor_corruption_rejected(self):
        self.set_physical_mode(True)
        entry = next(x for x in self.manifest['candidate']['sourceFiles'] if x['file'] == 'code/read_lights.py')
        path = self.root / entry['file']
        path.write_bytes(path.read_bytes() + b'\n# altered extractor\n')
        entry['sha256'] = S.sha(path)
        self.save()
        with self.assertRaisesRegex(ValueError, 'fixed physical extractor hash mismatch'):
            self.load()

    def test_physical_mode_off_on_and_legacy(self):
        self.load()
        for mode in (False, True):
            self.set_physical_mode(mode)
            self.load()

    def test_physical_mode_echo_mutation_rejected(self):
        for mode in (False, True):
            self.set_physical_mode(mode)
            for corruption in ('opposite', 'integer', 'missing'):
                manifest = copy.deepcopy(self.manifest)
                actual = manifest['frames'][0]['metadata']['actual']
                if corruption == 'opposite': actual['physicalDiskEnabled'] = not mode
                if corruption == 'integer': actual['physicalDiskEnabled'] = int(mode)
                if corruption == 'missing': del actual['physicalDiskEnabled']
                self.save(manifest)
                with self.subTest(mode=mode, corruption=corruption), self.assertRaisesRegex(ValueError, 'actual physicalDiskEnabled mismatch'):
                    self.load()

    def test_physical_non_boolean_config_and_orphan_echo_rejected(self):
        self.manifest['frames'][0]['metadata']['actual']['physicalDiskEnabled'] = False
        self.save()
        with self.assertRaisesRegex(ValueError, 'lacks config declaration'):
            self.load()
        for value in (0, 1, 'true', None):
            self.set_physical_mode(value)
            with self.subTest(value=value), self.assertRaisesRegex(ValueError, 'config physicalDiskEnabled must be boolean'):
                self.load()

    def test_physical_missing_hashed_source_rejected(self):
        self.set_physical_mode(True)
        self.manifest['candidate']['sourceFiles'] = [x for x in self.manifest['candidate']['sourceFiles'] if x['file'] != 'inputs/physical-source.json']
        self.save()
        with self.assertRaisesRegex(ValueError, 'physical-source.json missing'):
            self.load()

    def test_physical_source_mutations_rejected_after_rehash(self):
        for corruption in ('source_hash', 'reference_hash', 'missing_case', 'duplicate_case', 'missing_light', 'shape', 'key_power', 'world_strength'):
            self.set_physical_mode(True)
            entry = next(x for x in self.manifest['candidate']['sourceFiles'] if x['file'] == 'inputs/physical-source.json')
            path = self.root / entry['file']
            physical = json.loads(path.read_text())
            if corruption == 'source_hash': physical['sourceSHA256'] = '0' * 64
            if corruption == 'reference_hash': physical['refConfigSHA256'] = '0' * 64
            if corruption == 'missing_case': physical['cases'].pop()
            if corruption == 'duplicate_case': physical['cases'][-1] = copy.deepcopy(physical['cases'][0])
            if corruption == 'missing_light': physical['cases'][0]['lights'].pop()
            if corruption == 'shape': physical['cases'][0]['lights'][0]['shape'] = 'POINT'
            if corruption == 'key_power': physical['cases'][0]['lights'][0]['power'] += 1
            if corruption == 'world_strength': physical['cases'][0]['worldStrength'] += 1
            path.write_text(json.dumps(physical))
            entry['sha256'] = S.sha(path)
            self.save()
            with self.subTest(corruption=corruption), self.assertRaises(ValueError):
                self.load()

    def test_physical_config_case_mutation_rejected(self):
        self.set_physical_mode(True)
        entry = next(x for x in self.manifest['candidate']['sourceFiles'] if x['file'] == 'inputs/candidate-config.json')
        path = self.root / entry['file']
        native = json.loads(path.read_text())
        native['scenarios'][0]['physical']['lights'][1]['power'] += 1
        path.write_text(json.dumps(native))
        entry['sha256'] = S.sha(path)
        self.save()
        with self.assertRaisesRegex(ValueError, 'physical source case mismatch'):
            self.load()

    def test_physical_native_input_mutation_rejected(self):
        self.set_physical_mode(True)
        self.manifest['frames'][0]['metadata']['nativeInput']['physical']['worldRGB'][0] = 0.5
        self.save()
        with self.assertRaisesRegex(ValueError, 'nativeInput metadata mismatch'):
            self.load()

    def test_physical_field_when_disabled_rejected(self):
        self.set_physical_mode(False)
        entry = next(x for x in self.manifest['candidate']['sourceFiles'] if x['file'] == 'inputs/candidate-config.json')
        path = self.root / entry['file']
        native = json.loads(path.read_text())
        native['scenarios'][0]['physical'] = {}
        path.write_text(json.dumps(native))
        entry['sha256'] = S.sha(path)
        self.save()
        with self.assertRaisesRegex(ValueError, 'physical data present while mode disabled'):
            self.load()

    def set_linear_mode(self, value, echo=True):
        entry = next(x for x in self.manifest['candidate']['sourceFiles'] if x['file'] == 'inputs/candidate-config.json')
        path = self.root / entry['file']
        native = json.loads(path.read_text())
        native['linearLightEnabled'] = value
        path.write_text(json.dumps(native))
        entry['sha256'] = S.sha(path)
        if echo:
            for frame in self.manifest['frames']:
                frame['metadata']['actual']['linearLightEnabled'] = value
        self.save()

    def test_linear_mode_boolean_matching_and_optional_legacy(self):
        self.load()  # Legacy manifests may omit mode in both places.
        for mode in (False, True):
            self.set_linear_mode(mode)
            candidate = self.load()
            self.assertIs(candidate['manifest']['frames'][0]['metadata']['actual']['linearLightEnabled'], mode)

    def test_linear_mode_echo_mutation_rejected(self):
        for mode in (False, True):
            self.set_linear_mode(mode)
            for corruption in ('opposite', 'integer', 'missing'):
                manifest = copy.deepcopy(self.manifest)
                actual = manifest['frames'][0]['metadata']['actual']
                if corruption == 'opposite': actual['linearLightEnabled'] = not mode
                if corruption == 'integer': actual['linearLightEnabled'] = int(mode)
                if corruption == 'missing': del actual['linearLightEnabled']
                self.save(manifest)
                with self.subTest(mode=mode, corruption=corruption), self.assertRaisesRegex(ValueError, 'actual linearLightEnabled mismatch'):
                    self.load()

    def test_linear_mode_non_boolean_config_rejected_after_rehash(self):
        for value in (0, 1, 'true', None):
            self.set_linear_mode(value)
            with self.subTest(value=value), self.assertRaisesRegex(ValueError, 'config linearLightEnabled must be boolean'):
                self.load()

    def test_orphan_linear_echo_rejected(self):
        self.manifest['frames'][0]['metadata']['actual']['linearLightEnabled'] = False
        self.save()
        with self.assertRaisesRegex(ValueError, 'lacks config declaration'):
            self.load()

    def test_actual_echo_and_native_input_rejected_independently(self):
        for field in ('camera', 'light', 'nativeInput'):
            manifest = copy.deepcopy(self.manifest)
            meta = manifest['frames'][0]['metadata']
            if field == 'nativeInput':
                meta['nativeInput'] = {**meta['nativeInput'], 'ambient': 0.1}
                expected = 'nativeInput metadata mismatch'
            else:
                meta['actual'][field] = list(meta['actual'][field])
                meta['actual'][field][0] += 0.01
                expected = 'actual ' + field + ' mismatch'
            self.save(manifest)
            with self.subTest(field=field), self.assertRaisesRegex(ValueError, expected):
                self.load()

    def test_rehashed_native_config_camera_corruption_rejected(self):
        entry = self.manifest['candidate']['sourceFiles'][-1]
        path = self.root / entry['file']
        native = json.loads(path.read_text())
        native['cameras'][0]['nativeCamera'][0] += 0.1
        path.write_text(json.dumps(native))
        entry['sha256'] = S.sha(path)
        self.save()
        with self.assertRaisesRegex(ValueError, 'native config camera contract mismatch'):
            self.load()

    def test_missing_binary_rejected(self):
        (self.root / self.manifest['frames'][0]['rgb565']['file']).unlink()
        with self.assertRaisesRegex(ValueError, 'missing file'):
            self.load()

    def test_size_corruption_rejected_even_with_rehashed_metadata(self):
        entry = self.manifest['frames'][0]['rgb565']
        path = self.root / entry['file']
        path.write_bytes(path.read_bytes()[:-2])
        entry['sha256'] = S.sha(path)
        self.save()
        with self.assertRaisesRegex(ValueError, 'wrong file size'):
            self.load()

    def test_bad_depth_rejected_after_hash_verifies(self):
        entry = self.manifest['frames'][0]['depth']
        path = self.root / entry['file']
        for bad in ('nan', 'positive_inf', 'empty'):
            depth = np.full((135, 240), -np.inf, dtype='<f4')
            if bad != 'empty':
                depth[0, 0] = 1
                depth[0, 1] = np.nan if bad == 'nan' else np.inf
            path.write_bytes(depth.tobytes())
            entry['sha256'] = S.sha(path)
            self.save()
            with self.subTest(bad=bad), self.assertRaises(ValueError):
                self.load()

    def test_path_traversal_rejected(self):
        self.manifest['frames'][0]['rgb565']['file'] = '../other.u16le'
        self.save()
        with self.assertRaisesRegex(ValueError, 'normalized and relative'):
            self.load()

    def test_candidate_does_not_change_stability_and_false_positives_remain(self):
        E = self.reference['evaluator']
        a = np.full((8, 1, 2, 3), 100, dtype=np.uint8)
        b = a.copy()
        b[:, 0, 0] = 104
        fg = np.ones((1, 2), bool)
        c0 = np.zeros((1, 2, 3), dtype=np.float64)
        c1 = np.full((1, 2, 3), 1 / 31, dtype=np.float64)
        no_candidate, ref_st = E.evaluate_response_png8(a, b, fg)
        with_candidate, scored_st = E.evaluate_response_png8(a, b, fg, c0, c1)
        for name in ref_st:
            np.testing.assert_array_equal(ref_st[name], scored_st[name])
        stable = with_candidate['candidateScores']['stableSubset']
        self.assertEqual(stable['pixels'], 2)
        self.assertEqual(stable['brightening']['referencePixels'], 1)
        self.assertEqual(stable['brightening']['candidatePixels'], 2)
        self.assertEqual(stable['brightening']['IoU'], 0.5)
        self.assertEqual(stable['darkening']['valueStatus'], 'N/A_NOT_PASS')

    def test_full_synthetic_score_matches_all_frozen_reference_masks(self):
        candidate = self.load()
        result, masks = S.score(self.reference, candidate)
        self.assertEqual(len(result['conditions']), 10)
        self.assertEqual(len(masks), 10)
        self.assertEqual(result['sixtyPercentGoal'], 'NOT_ESTABLISHED_CONDITIONAL_METRICS_ONLY')
        for view in S.VIEWS:
            for case in S.CASES:
                item = result['conditions'][f'{view}-{case}']
                fg = self.reference['foreground'][view]
                self.assertEqual(item['colorMeanPrecision']['candidateScores']['pooledFullForegroundDescriptive']['pixels'], int(fg.sum()))
                if case != 'baseline':
                    response = item['response']
                    self.assertEqual(response['conditionScope'], 'UNRESOLVED_UNCERTAIN_REMAINDER')
                    scores = response['candidateScores']
                    self.assertEqual(scores['pooledFullForegroundDescriptive']['pixels'], int(fg.sum()))
                    self.assertEqual(scores['uncertainSubsetDescriptiveNotAcceptance']['brightening']['valueStatus'], 'DESCRIPTIVE_ONLY_NOT_ACCEPTANCE')
        # Validates all frozen source/code/image/mask/evaluation hashes again.
        S.verify_reference_files(REFERENCE)

    def test_output_must_be_fresh(self):
        output = self.root / 'already-there'
        output.mkdir()
        with self.assertRaises(FileExistsError):
            S.write_output(output, {}, {})
        with self.assertRaisesRegex(ValueError, 'output must not already exist'):
            S.main([str(self.manifest_path), '--reference', str(REFERENCE), '--output', str(output)])


if __name__ == '__main__':
    unittest.main(verbosity=2)
