#!/usr/bin/env python3
"""Small, synthetic, non-rendering admission tests. No prepared file is modified."""
import copy
import json
import tempfile
from pathlib import Path
import unittest
import numpy as np
import strict_scene_score as S


class StrictAdmissionTests(unittest.TestCase):
    def rows(self):
        return [{'view': v, 'case': c, 'reverse': r,
                 'prefix': 'private-partial/native-' + v + '-' + c + ('-reverse' if r else '')}
                for v in S.VIEWS for c in S.CASES for r in (False, True)]

    def test_complete_keyset(self):
        self.assertEqual(set(S.index_frames(self.rows())), S.KEYS)

    def test_partial_rejected(self):
        with self.assertRaises(ValueError): S.index_frames(self.rows()[:-1])

    def test_duplicate_rejected(self):
        rows = self.rows(); rows[-1] = rows[0]
        with self.assertRaises(ValueError): S.index_frames(rows)

    def test_reverse_integer_rejected(self):
        rows = self.rows(); rows[0]['reverse'] = 0
        with self.assertRaises(ValueError): S.index_frames(rows)

    def test_unexpected_case_rejected(self):
        rows = self.rows(); rows[0]['case'] = 'fitted'
        with self.assertRaises(ValueError): S.index_frames(rows)

    def test_wrong_prefix_rejected(self):
        rows = self.rows(); rows[0]['prefix'] = rows[1]['prefix']
        with self.assertRaises(ValueError): S.index_frames(rows)

    def test_metadata_runtime_equality(self):
        b = {'reverse': False, 'work': 123, 'transportBuildNs': 9}
        a = dict(b, transportBuildNs=10)
        S.compare_metadata(a, a, b, 'on')
        with self.assertRaises(ValueError): S.compare_metadata(a, dict(a, work=124), b, 'on')

    def test_metadata_bool_not_int(self):
        b = {'reverse': False, 'work': 123}
        with self.assertRaises(ValueError): S.compare_metadata(dict(b, reverse=0), dict(b, reverse=0), b, 'off')

    def test_metadata_keyset(self):
        b = {'work': 123}
        with self.assertRaises(ValueError): S.compare_metadata(dict(b, other=0), dict(b, other=0), b, 'off')

    def test_background_zero_work_only(self):
        b = {'work': 123, 'shadeUpdates': 22}
        a = {'work': 123, 'shadeUpdates': 0}
        S.compare_metadata(a, a, b, 'background')
        with self.assertRaises(ValueError): S.compare_metadata(b, b, b, 'background')

    def test_background_never_formal(self):
        with self.assertRaises(ValueError): S.formal_score(None, None, {'arm': 'background'}, None)

    def test_unknown_is_exhaustive_not_pass(self):
        st = {k: np.array([[k == t for t in ('bright', 'dark', 'inactive', 'uncertain')]])
              for k in ('bright', 'dark', 'inactive', 'uncertain')}
        st['stable'] = ~st['uncertain']; st['mean'] = np.zeros((1, 4))
        r = S.response_confusion(st, np.array([[-.1, .1, .1, .1]]), np.ones((1, 4), bool), 2 / 255)
        self.assertEqual((r['unknown'], r['reverse'], r['inactiveFP']), (1, 2, 1))
        self.assertFalse(r['unknownCountedAsPass'])

    def test_empty_domain_is_na(self):
        r = S.error_summary(np.zeros((1, 1, 3)), np.ones((1, 1, 3)), np.zeros((1, 1), bool))
        self.assertEqual(r['status'], 'N/A_NOT_PASS'); self.assertIsNone(r['rgbMAE'])

    def test_paths_json_and_depth(self):
        with tempfile.TemporaryDirectory(dir=S.HERE) as folder:
            root = Path(folder)
            p = root / 'data.json'
            for text in ('{"x":1,"x":2}', '{"x":NaN}', '{"x":1e999}'):
                p.write_text(text)
                with self.assertRaises(ValueError): S.read_json(p)
            p.write_text('{}')
            for name in ('../data.json', '/data.json', './data.json'):
                with self.assertRaises(ValueError): S.contained(root, name)
            (root / 'alias').symlink_to(p)
            with self.assertRaises(ValueError): S.contained(root, 'alias')
            with self.assertRaises(ValueError): S.verify(p, '0' * 64)
            d = root / 'depth.f32le'; np.full((135, 240), -np.inf, '<f4').tofile(d)
            S.read_depth(d, background=True)
            with self.assertRaises(ValueError): S.read_depth(d)
            a = np.full((135, 240), -np.inf, '<f4'); a[0, 0] = 1; a.tofile(d)
            S.read_depth(d)
            with self.assertRaises(ValueError): S.read_depth(d, background=True)
            a[0, 0] = np.nan; a.tofile(d)
            with self.assertRaises(ValueError): S.read_depth(d)


if __name__ == '__main__':
    unittest.main(verbosity=2)
