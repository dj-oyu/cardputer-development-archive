#!/usr/bin/env python3
"""Private geometry-only diagnostic bridge. Never invokes a renderer.

Checks old source->AYNM XYZ bytes exactly, then changes XYZ only using AYFQ.
All normal, material, topology, pose and identity bytes stay untouched.
"""
import argparse
import hashlib
import importlib.util
import json
import math
from pathlib import Path
import struct
import sys

sys.dont_write_bytecode = True
ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location("fixed_converter", ROOT/"converter/compile_fixed.py")
codec = importlib.util.module_from_spec(spec)
spec.loader.exec_module(codec)


def check(ok, message):
    if not ok: raise ValueError(message)


def sections(data):
    check(32 <= len(data) <= 512*1024 and data[:4] == b"AYNM", "model length/magic")
    version, header = struct.unpack_from("<HH", data, 4)
    size, count, offset, stride = struct.unpack_from("<4I", data, 8)
    check(version == 1 and header == 32 and size == len(data) and offset == 32 and stride == 20 and 1 <= count <= 13 and 32+20*count <= len(data), "model directory")
    out = {}
    spans = []
    for i in range(count):
        kind, required, at, n, items, step = struct.unpack_from("<HH4I", data, 32+i*20)
        check(kind not in out and required == 1 and at >= 32+20*count and at%8 == 0 and n == items*step and at+n <= len(data), "model section")
        for a,b in spans: check(n == 0 or b == a or not (at < b and a < at+n), "model section overlap")
        spans.append((at,at+n))
        out[kind] = (at,n,items,step)
    check(all(k in out for k in (9,10,11)), "mesh sections missing")
    check(out[9][3] == 32 and out[10][3] == 28 and out[11][3] == 6, "mesh strides")
    return out


def bridge(source, baseline, candidate):
    check(source.get("schema") == "ayatsuri-fixed-static-input-v1" and source.get("source_units") == "metres" and source.get("geometry_scale") == 1 and source.get("coordinate_system") == "ayatsuri-native-metres" and source.get("source_mode") == "baked-static", "source contract")
    fixed = codec.decode(candidate)
    ss = sections(baseline)
    parts = source["parts"]
    check(len(parts) == ss[9][2] == len(fixed["parts"]), "part count")
    out = bytearray(baseline)
    touched, normal_components, max_error, sum_error2, nchanged, nv = set(), 0, 0., 0., 0, 0
    old_vertex_key = {}
    for pi,(part,fp) in enumerate(zip(parts,fixed["parts"])):
        va,n,ta,nt = struct.unpack_from("<4H", baseline,ss[9][0]+32*pi)
        check(va == nv and n == len(part["positions"]) == len(fp["positions"]) and nt == len(part["triangles"]) and ta+nt <= ss[11][2], "part ranges")
        check(fp["triangles"] == part["triangles"] and fp["double_sided"] == (part["materialSidedness"] == "double"), "topology/side identity")
        oldpos,newpos = [],[]
        for j in range(n):
            at=ss[10][0]+28*(va+j)
            expected=struct.pack("<3f", *(x*38 for x in part["positions"][j]))
            check(baseline[at:at+12] == expected, "unquantized bridge control mismatch")
            check(baseline[at+12:at+24] == struct.pack("<3f",*part["normals"][j]), "source normal mapping mismatch")
            normal_components += 3
            positions=[q/(1 << fixed["fraction_bits"])*38 for q in fp["positions"][j]]
            check(all(math.isfinite(x) and abs(x) <= 4096 for x in positions), "legacy coordinate bounds")
            encoded=struct.pack("<3f",*positions)
            if expected in old_vertex_key: check(old_vertex_key[expected] == encoded, "partition seam divergence")
            old_vertex_key[expected]=encoded
            out[at:at+12]=encoded
            touched.update(range(at,at+12))
            oldp,newp=struct.unpack("<3f",expected),struct.unpack("<3f",encoded)
            oldpos.append(oldp);newpos.append(newp)
            for a,b in zip(oldp,newp):
                error=abs(a-b)/38
                max_error=max(max_error,error);sum_error2+=error*error
                nchanged+= a != b
        for ti,t in enumerate(part["triangles"]):
            check(tuple(t) == struct.unpack_from("<3H",baseline,ss[11][0]+6*(ta+ti)), "triangle source mapping")
            before=codec.cross(*(oldpos[i] for i in t));after=codec.cross(*(newpos[i] for i in t))
            check(any(after) and sum(a*b for a,b in zip(before,after)) > 0,"float bridge triangle collapse/orientation")
        nv+=n
    check(nv == ss[10][2],"vertex total")
    check(all(a == b for i,(a,b) in enumerate(zip(baseline,out)) if i not in touched),"nonposition byte changed")
    return bytes(out),{"mode":"geometry-only diagnostic bridge, not fixed runtime", "unquantized_bridge_control":"exact original XYZ and normal bytes", "fraction_bits":fixed["fraction_bits"],"vertices":nv,"normal_components_verified":normal_components,"changed_xyz_components":nchanged,"total_xyz_components":3*nv,"max_position_change_vs_legacy_m":max_error,"rms_position_change_vs_legacy_m":math.sqrt(sum_error2/(3*nv)),"nonposition_byte_changes":0,"triangle_collapses_or_orientation_changes":0,"partition_seam_divergences":0,"rendered":False}


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    for name in ("source","baseline","candidate","output"):ap.add_argument(name,type=Path)
    a=ap.parse_args()
    check(not a.output.exists() and not a.output.with_suffix(a.output.suffix+".json").exists(),"output exists")
    s,b,q=a.source.read_bytes(),a.baseline.read_bytes(),a.candidate.read_bytes()
    output,stats=bridge(json.loads(s),b,q)
    stats["hashes"]={k:hashlib.sha256(v).hexdigest() for k,v in [("source",s),("baseline",b),("ayfq",q),("output",output),("bridge",Path(__file__).read_bytes())]}
    a.output.parent.mkdir(parents=True,exist_ok=True)
    codec.write_pair_new(a.output,output,stats)
    print(json.dumps(stats,indent=2))


if __name__ == "__main__":main()
