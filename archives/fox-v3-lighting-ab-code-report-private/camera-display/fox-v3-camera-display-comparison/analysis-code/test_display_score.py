#!/usr/bin/env python3
"""Fast synthetic tests only: no renderer, profile application or quality scoring."""
import copy
from pathlib import Path
import sys
import unittest
from unittest.mock import patch
from types import SimpleNamespace
import numpy as np

sys.dont_write_bytecode = True
import compare_metrics as M
import strict_display_score as D


class ScalarAuditTests(unittest.TestCase):
    def test_error_and_agreement_regressions(self):
        a = {'formal': {'front-direction': {'rgbMAE': .1, 'IoU': .9, 'brightFP': 4}}}
        b = {'formal': {'front-direction': {'rgbMAE': .2, 'IoU': .8, 'brightFP': 5}}}
        r = M.compare(a, b)
        self.assertEqual(r['scalarCounts']['regression'], 3)
        self.assertEqual(r['scalarCounts']['totalScalarLeaves'], 3)

    def test_all_seed_scalar_leaves_retained(self):
        a = {'formal': {'front-direction': {'eachReferenceSeedFullForeground': [{'rgbMAE': .1}] * 8}}}
        b = {'formal': {'front-direction': {'eachReferenceSeedFullForeground': [{'rgbMAE': .2}] * 8}}}
        r = M.compare(a, b)
        self.assertEqual(len(r['regressions']), 8)
        self.assertTrue(r['regressions'][-1]['path'].endswith('/7/rgbMAE'))

    def test_unknown_not_pass(self):
        a = {'descriptive': {'front-direction': {'fullForeground': {'confusion': {'uncertain': {'bright': 8}}}}}}
        b = copy.deepcopy(a)
        b['descriptive']['front-direction']['fullForeground']['confusion']['uncertain']['bright'] = 2
        r = M.compare(a, b)
        self.assertEqual(r['scalarCounts']['neutralChanged'], 1)
        self.assertEqual(r['regressions'], [])
        self.assertEqual(r['improvements'], [])

    def test_confusion_count_regressions(self):
        a = {'formal': {'front-direction': {'confusion': {'bright': {'dark': 3, 'bright': 4}}}}}
        b = {'formal': {'front-direction': {'confusion': {'bright': {'dark': 4, 'bright': 3}}}}}
        self.assertEqual(M.compare(a, b)['scalarCounts']['regression'], 2)

    def test_null_never_improvement_or_zero(self):
        r = M.compare({'IoU': None, 'rgbMAE': .2}, {'IoU': .3, 'rgbMAE': None})
        self.assertEqual(len(r['undefinedTransitions']), 2)
        self.assertEqual(r['regressions'], [])
        self.assertTrue(all(x['agxMinusLegacy'] is None for x in r['undefinedTransitions']))

    def test_signed_bias_uses_absolute_error(self):
        r = M.compare({'signedRGBMeanCandidateMinusReference': [-.3, .1, -.2]},
                      {'signedRGBMeanCandidateMinusReference': [-.2, -.2, .2]})
        self.assertEqual(r['scalarCounts']['regression'], 1)
        self.assertEqual(r['scalarCounts']['improvement'], 1)
        self.assertEqual(r['scalarCounts']['equalAbsoluteMagnitude'], 1)

    def test_reference_counts_are_neutral(self):
        r = M.compare({'candidatePixels': 1, 'significantPixels': 2, 'unknown': 3},
                      {'candidatePixels': 2, 'significantPixels': 3, 'unknown': 4})
        self.assertEqual(r['scalarCounts']['neutralChanged'], 3)

    def test_boolean_unresponsive_regression(self):
        self.assertEqual(M.compare({'oneSideUnresponsive': False}, {'oneSideUnresponsive': True})['scalarCounts']['regression'], 1)

    def test_schema_mismatch_rejected(self):
        with self.assertRaisesRegex(ValueError, 'schema changed'):
            M.compare({'rgbMAE': 1}, {'rgbRMSE': 1})

    def test_coordinate_arrays_not_counted_as_metrics(self):
        r = M.compare({'uncertainLocationsYX': [[1, 2]], 'unknown': 1},
                      {'uncertainLocationsYX': [[1, 2]], 'unknown': 1})
        self.assertEqual(r['scalarCounts']['totalScalarLeaves'], 1)


class AdmissionTests(unittest.TestCase):
    def rows(self):
        return [{'view': v, 'case': c} for v in D.O.VIEWS for c in D.O.CASES]

    def test_exact_ten_domain(self):
        self.assertEqual(len(D.ten_rows(self.rows())), 10)

    def test_incomplete_domain_rejected(self):
        with self.assertRaisesRegex(ValueError, 'all10'):
            D.ten_rows(self.rows()[:-1])

    def test_duplicate_domain_rejected(self):
        rows = self.rows()
        rows[-1] = rows[0]
        with self.assertRaisesRegex(ValueError, 'duplicate'):
            D.ten_rows(rows)

    def test_unknown_domain_rejected(self):
        rows = self.rows()
        rows[0]['case'] = 'new-exposure'
        with self.assertRaisesRegex(ValueError, 'unknown frame'):
            D.ten_rows(rows)

    def test_unpublished_gate_stops_before_any_rgb_decode(self):
        a = SimpleNamespace(input_pins=Path('inputs'), input_pins_sha256='i',
            output_pins=Path('outputs'), output_pins_sha256='o',
            legacy_gate=Path('gate'), completion=Path('done'))
        with patch.object(D, 'frozen_inventory', return_value=({}, {})), \
             patch.object(D, 'pinned', side_effect=lambda p, _: p), \
             patch.object(D, 'read_json', side_effect=[{'planSHA256': 'p', 'files': {}}, {'status': 'PENDING'}, {}]), \
             patch.object(D, 'verify', side_effect=lambda p, _: p), \
             patch.object(D.O, 'check_pins'), \
             patch.object(D.O, 'read_rgb') as rgb:
            with self.assertRaisesRegex(ValueError, 'legacy reconstruction gate not complete'):
                D.admit_display(a, {})
            rgb.assert_not_called()


class ClampTests(unittest.TestCase):
    def test_clipping_and_endpoints_are_different(self):
        raw = np.array([[[2., 0., .5], [6000., .5, .5]]])
        rgb = np.array([[[.5, 0., .5], [.5, 1., .5]]])
        f = D.recompute_clamp_flags(raw, rgb, rgb)
        np.testing.assert_array_equal(f['legacySaturation'], [[True, True]])
        np.testing.assert_array_equal(f['profileDomainClamp'], [[False, True]])
        np.testing.assert_array_equal(f['agxQuantizedAnyZero'], [[True, False]])
        np.testing.assert_array_equal(f['agxQuantizedAnyMax'], [[False, True]])

    def test_actual_float32_boundary_is_used(self):
        hi = 5898.240000132513
        raw = np.full((1, 1, 3), hi)
        rgb = np.full((1, 1, 3), .5)
        self.assertEqual(bool(D.recompute_clamp_flags(raw, rgb, rgb)['profileDomainClamp'][0, 0]),
                         float(np.float32(hi)) > hi)

    def test_negative_nonfinite_and_true_cast_overflow_rejected(self):
        rgb = np.full((1, 1, 3), .5)
        for value in (-1., float('nan'), float('inf'), float(np.finfo(np.float32).max) * 2):
            with self.assertRaises(ValueError):
                D.recompute_clamp_flags(np.full((1, 1, 3), value), rgb, rgb)

    def test_large_finite_cast_remains_scored(self):
        rgb = np.full((1, 1, 3), .5)
        raw = np.full((1, 1, 3), np.nextafter(float(np.finfo(np.float32).max), np.inf))
        self.assertTrue(D.recompute_clamp_flags(raw, rgb, rgb)['profileDomainClamp'][0, 0])


if __name__ == '__main__':
    unittest.main()
