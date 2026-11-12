"""Synthetic and prior-aggregate checks only; never render or score new output."""
import sys
sys.dont_write_bytecode = True
import gzip
import json
from pathlib import Path
import tempfile
from types import SimpleNamespace
import unittest
from unittest.mock import patch
import numpy as np
import score_world as S


class WorldScoringPreparationTests(unittest.TestCase):
    def test_missing_completion_inventory_fails_without_output(self):
        with tempfile.TemporaryDirectory(dir=S.HERE) as name:
            p = Path(name)
            args = SimpleNamespace(completion_pins=p/'missing.json', completion_pins_sha256='0'*64)
            with self.assertRaises((FileNotFoundError, ValueError)):
                S.manifest_inventory(args, S.Pins())
            self.assertEqual(list(p.iterdir()), [])

    def test_missing_manifest_is_not_complete(self):
        with tempfile.TemporaryDirectory(dir=S.HERE) as name:
            p = Path(name)/'partial.json'
            p.write_text(json.dumps({'files': {str(S.ROOT/'PLAN.md'): S.sha(S.ROOT/'PLAN.md')}}))
            args = SimpleNamespace(completion_pins=p, completion_pins_sha256=S.sha(p))
            with self.assertRaisesRegex(ValueError, 'all four completed'):
                S.manifest_inventory(args, S.Pins())

    def test_hash_mismatch_rejected(self):
        with tempfile.TemporaryDirectory(dir=S.HERE) as name:
            p = Path(name)/'x';p.write_bytes(b'original')
            with self.assertRaises(ValueError):
                S.Pins().check(p, '0'*64)

    def test_pin_change_recheck_rejected(self):
        with tempfile.TemporaryDirectory(dir=S.HERE) as name:
            p = Path(name)/'x';p.write_bytes(b'original');pins=S.Pins();pins.check(p,S.sha(p));p.write_bytes(b'changed')
            with self.assertRaises(ValueError):
                pins.recheck()

    def test_path_traversal_rejected(self):
        with self.assertRaises(ValueError):
            S.Pins().check(S.HERE/'..'/'PLAN.md', '0'*64)

    def test_failed_or_rejected_run_rejected(self):
        with tempfile.TemporaryDirectory(dir=S.HERE) as name:
            p=Path(name)
            for marker in ('FAILED.json','REJECTED.json'):
                (p/marker).write_text('{}')
                with self.assertRaisesRegex(ValueError, 'failed/rejected'):
                    S.fail_markers(p)
                (p/marker).unlink()

    def test_exact_ten_unique_rows_required(self):
        rows=[{'view':v,'case':c} for v in S.O.VIEWS for c in S.O.CASES]
        self.assertEqual(len(S.D.ten_rows(rows)),10)
        with self.assertRaises(ValueError):S.D.ten_rows(rows[:-1])
        with self.assertRaises(ValueError):S.D.ten_rows(rows[:-1]+[rows[0]])

    def test_off_bytes_gate_cannot_be_skipped(self):
        old={'view':'front','case':'baseline','hdr':'a','hdrSHA256':'x'}
        new={**old,'hdr':'different'}
        with patch.object(S,'read_json',return_value={'frames':[old]}),patch.object(S.D,'ten_rows',return_value={('front','baseline'):old}):
            with self.assertRaisesRegex(ValueError,'OFF HDR name differs'):
                S.off_byte_gate({('front','baseline'):new}, S.Pins())

    def test_normalize_prior_and_live_uncertainty_equally(self):
        live={'conditions':{'a':{'uncertainLocationsYX':[[1,2],[3,4]],'rgbMAE':.2}}}
        saved=S.H.without_pixel_lists(live)
        self.assertEqual(S.numeric(live),S.numeric(saved))
        self.assertEqual(S.numeric(saved),S.numeric(saved))

    def test_compact_regressions_and_undefined_retained(self):
        a=S.M.compare({'rgbMAE':.1,'brightFN':2,'IoU':None},{'rgbMAE':.2,'brightFN':3,'IoU':.5})
        b=S.H.compact_audit(a,'worldOFF')
        self.assertEqual(len(b['regressions']),2)
        self.assertEqual(len(b['undefinedTransitions']),1)

    def test_deterministic_compression_exact(self):
        raw=S.O.canonical({'unknown':9,'IoU':None,'count':0})+b'\n'
        a=gzip.compress(raw,compresslevel=9,mtime=0)
        self.assertEqual(gzip.decompress(a),raw)
        self.assertEqual(a,gzip.compress(raw,compresslevel=9,mtime=0))

    def test_invalid_hdr_rejected_without_mask_exclusion(self):
        x=np.zeros((135,240,3));bad=x.copy();bad[0,0,0]=float('nan')
        with self.assertRaises(ValueError):S.D.recompute_clamp_flags(bad,x,x)

    def test_fixed_profile_aliases_pin_exactly(self):
        self.assertEqual(len(S.admit_profile(S.Pins())),81)

    def test_raw_component_invariants_and_source_albedo(self):
        rows={'on':{(v,c):{'floorWorld':'floor-world-'+v+'-'+c+'.f64le','floorWorldSHA256':'0'*64}
                    for v in S.O.VIEWS for c in S.O.CASES}}
        arrays=[np.ones((135,240,3))*scale for v in S.O.VIEWS for scale in (1,1,1,2,.36)]
        fake=SimpleNamespace(check=lambda p,h:p)
        with patch.object(S.np,'fromfile',side_effect=arrays), patch.object(S.O,'contained',side_effect=lambda root,name:root/name):
            result=S.raw_component_invariants(rows,fake)
        self.assertTrue(result['views']['front']['ambientBitExact2xBaseline'])
        self.assertEqual(result['views']['front']['albedoObservedRatioByChannel'][0]['median'],.36)
        self.assertNotEqual(result['albedoFloorRhoRatioToBaseline'][0],.6)

    def test_raw_ambient_invariant_failure_stops(self):
        rows={'on':{(v,c):{'floorWorld':'floor-world-'+v+'-'+c+'.f64le','floorWorldSHA256':'0'*64}
                    for v in S.O.VIEWS for c in S.O.CASES}}
        arrays=[np.ones((135,240,3))*scale for scale in (1,1,1,1.99,.36)]
        fake=SimpleNamespace(check=lambda p,h:p)
        with patch.object(S.np,'fromfile',side_effect=arrays), patch.object(S.O,'contained',side_effect=lambda root,name:root/name):
            with self.assertRaisesRegex(ValueError,'ambient component not bit-exact'):
                S.raw_component_invariants(rows,fake)

    def test_known_prior_complete_aggregate_pins(self):
        pins=S.Pins();p=S.prior_admission(pins)
        self.assertEqual(len(p['FORMAL_ON.json']['conditions']),10)
        self.assertEqual(p['FORMAL_ON.json']['globalAcceptance'],'NOT_ESTABLISHED')
        pins.recheck()


if __name__=='__main__':unittest.main()
