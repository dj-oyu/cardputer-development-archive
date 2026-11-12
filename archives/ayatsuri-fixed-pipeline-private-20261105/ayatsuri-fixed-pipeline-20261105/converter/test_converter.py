#!/usr/bin/env python3
"""Synthetic-only acceptance/rejection tests; no private assets in fixtures."""
import copy
import json
import random
import struct
import tempfile
import unittest
from pathlib import Path
import zlib
from compile_fixed import compile_report, decode, quantize, write_pair_new


def source():
    return {"schema": "ayatsuri-fixed-static-input-v1",
            "coordinate_system": "ayatsuri-native-metres", "source_units": "metres",
            "geometry_scale": 1, "source_mode": "baked-static",
            "parts": [{"positions": [[0., 0., 0.], [1., 0., 0.], [0., 1., 0.]],
                       "normals": [[0., 0., 1.]]*3,
                       "triangles": [[0, 1, 2]], "materialId": "material/0",
                       "materialSidedness": "double"}],
            "materialTrace": [{"id": "material/0", "scaledLinear": [0., .5, 1.]}]}


def recheck(blob):
    blob[60:64] = b"\0"*4
    struct.pack_into("<I", blob, 60, zlib.crc32(blob))
    return blob


class ConverterTests(unittest.TestCase):
    def test_rounding_and_bounds(self):
        for x, y in [(0.5, 0), (1.5, 2), (2.5, 2), (-.5, 0), (-1.5, -2), (-2.5, -2)]:
            self.assertEqual(quantize(x, 1, -32767, 32767), y)
        self.assertEqual(quantize(-1, 32767, -32767, 32767), -32767)
        self.assertEqual(quantize(1, 32767, -32767, 32767), 32767)
        for value in [float("inf"), float("nan"), 32768., -32768.]:
            with self.assertRaises(ValueError):
                quantize(value, 1, -32767, 32767)

    def test_roundtrip(self):
        for frac in [0, 8, 16, 20, 24]:
            blob, stats = compile_report(source(), frac)
            self.assertEqual(blob, compile_report(source(), frac)[0])
            out = decode(blob)
            self.assertEqual(out["fraction_bits"], frac)
            self.assertEqual(out["parts"][0]["positions"], [[0,0,0], [1 << frac,0,0], [0,1 << frac,0]])
            self.assertEqual(out["parts"][0]["normals"], [[0,0,32767]]*3)
            self.assertEqual(out["materials"], [[0,16384,32767]])
            self.assertEqual(out["parts"][0]["triangles"], [[0,1,2]])
            self.assertTrue(out["parts"][0]["double_sided"])
            self.assertEqual(stats["vertices"], 3)

    def test_partial_blocks_and_multiple_parts(self):
        for n in range(3, 33):
            s = source()
            s["parts"][0]["positions"] = [[float(i), float(i*i), 0.] for i in range(n)]
            s["parts"][0]["normals"] = [[0.,0.,1.]]*n
            s["parts"][0]["triangles"] = [[i,i+1,i+2] for i in range(n-2)]
            s["parts"].append(copy.deepcopy(s["parts"][0]))
            s["parts"][1]["materialSidedness"] = "single"
            blob, stats = compile_report(s, 16)
            out = decode(blob)
            self.assertEqual(len(out["parts"]), 2)
            self.assertEqual(stats["blocks"], 2*((n+7)//8))
            self.assertEqual(out["parts"][0]["triangles"], s["parts"][0]["triangles"])
            self.assertFalse(out["parts"][1]["double_sided"])

    def test_reject_invalid_source(self):
        invalid = []
        for key in ["schema", "coordinate_system", "source_units", "geometry_scale", "source_mode"]:
            s = source(); del s[key]; invalid.append(s)
        s = source(); s["geometry_scale"] = 38; invalid.append(s)
        s = source(); s["geometry_scale"] = True; invalid.append(s)
        for val in [float("inf"), float("nan"), 40000., 10**1000]:
            s = source(); s["parts"][0]["positions"][0][0] = val; invalid.append(s)
        for val in [-1., 1.1, float("nan")]:
            s = source(); s["materialTrace"][0]["scaledLinear"][0] = val; invalid.append(s)
        for val in [[0,0,0], [0,0,2], [float("nan"),0,1]]:
            s = source(); s["parts"][0]["normals"][0] = val; invalid.append(s)
        for val in [[0,0,1], [0,1,3], [0,1,-1], [0,1,True]]:
            s = source(); s["parts"][0]["triangles"] = [val]; invalid.append(s)
        s = source(); s["parts"][0]["positions"][1] = [1e-10,0,0]; invalid.append(s)
        s = source(); s["parts"][0]["materialSidedness"] = None; invalid.append(s)
        s = source(); s["parts"][0]["materialId"] = "missing"; invalid.append(s)
        s = source(); s["parts"][0]["materialId"] = []; invalid.append(s)
        s = source(); s["materialTrace"] *= 2; invalid.append(s)
        for s in invalid:
            with self.assertRaises(ValueError): compile_report(s)

    def test_single_bit_damage_and_truncation(self):
        blob = compile_report(source())[0]
        for i in range(len(blob)):
            bad = bytearray(blob); bad[i] ^= 1
            with self.assertRaises(ValueError): decode(bad)
        for n in range(len(blob)):
            with self.assertRaises(ValueError): decode(blob[:n])
        with self.assertRaises(ValueError): decode(blob + b"\0")

    def test_structural_damage_with_valid_crc(self):
        blob = compile_report(source())[0]
        # Header offsets: counts and directory positions. Every change is re-CRC'd.
        for offset, value in [(8,2), (12,0), (16,25), (20,0), (24,0), (28,4),
                              (32,0), (36,2), (40,80), (44,0), (48,0), (52,0), (56,1),
                              (64,1), (68,2), (72,4), (76,1), (80,0), (84,1), (88,2), (92,1)]:
            bad = bytearray(blob); struct.pack_into("<I", bad, offset, value)
            with self.assertRaises(ValueError): decode(recheck(bad))
        _, *f = struct.unpack_from("<8s14I", blob)
        mo, bo, to = f[9], f[10], f[11]
        for offset, data in [(mo,struct.pack("<h",-1)), (mo+6,b"\1"),
                             (mo+8,b"\1"), (bo+3*4,b"\1"),
                             (bo+96,struct.pack("<h",-32768)),
                             (to,b"\3"), (to+1,b"\0"), (to+3,b"\1"), (to+4,b"\1")]:
            bad = bytearray(blob); bad[offset:offset+len(data)] = data
            with self.assertRaises(ValueError): decode(recheck(bad))

    def test_random_roundtrip(self):
        rng = random.Random(20261105)
        for _ in range(500):
            s = source()
            dx,dy,dz = [rng.uniform(-50,50) for _ in range(3)]
            scale = rng.uniform(.01,5)
            s["parts"][0]["positions"] = [[dx,dy,dz], [dx+scale,dy,dz], [dx,dy+scale,dz]]
            s["materialTrace"][0]["scaledLinear"] = [rng.random() for _ in range(3)]
            blob, stats = compile_report(s, 20)
            self.assertLessEqual(stats["position_abs_max_m"], 2**-21)
            self.assertLessEqual(stats["linear_albedo_abs_max"], .5/32767)
            self.assertEqual(len(decode(blob)["parts"][0]["positions"]),3)

    def test_invalid_unit_normal_and_output_conflict(self):
        blob, stats = compile_report(source())
        _, *f = struct.unpack_from("<8s14I", blob)
        bo = f[10]
        bad = bytearray(blob)
        for k in range(3): struct.pack_into("<h", bad, bo+96+16*k, 32767)
        with self.assertRaisesRegex(ValueError, "normal length"): decode(recheck(bad))
        with tempfile.TemporaryDirectory() as td:
            p = Path(td)/"model.ayfq"
            side = p.with_suffix(".ayfq.json")
            side.write_text("existing")
            with self.assertRaises(FileExistsError): write_pair_new(p,blob,stats)
            self.assertFalse(p.exists())
            self.assertEqual(side.read_text(),"existing")
            side.unlink()
            write_pair_new(p,blob,stats)
            self.assertEqual(p.read_bytes(),blob)
            with self.assertRaises(FileExistsError): write_pair_new(p,blob,stats)
            self.assertEqual(p.read_bytes(),blob)


if __name__ == "__main__": unittest.main(verbosity=2)
