#!/usr/bin/env python3
"""Bake a deliberately small, bilateral shadow look into pinned Fox v5 AYNM."""
import argparse
import hashlib
import json
import struct
from pathlib import Path

BASE = "616033c06602ae3fe7ee8c14536ffba7654aa57bab257c67c19b25c63a584225"
PROFILES = {"weak": (0.91, 0.85, 0.75), "strong": (0.83, 0.73, 0.61)}


def signed_mask(group, xyz):
    # Quantize only the shadow field input so repeated corners at packet
    # boundaries agree. The stored positions are never touched.
    x, y, z = (round(v, 5) for v in xyz)
    if group == "cheek":
        radius_sq = ((abs(x)-0.44)/0.35)**2 + ((y-0.34)/0.16)**2 + ((z-0.29)/0.45)**2
    else:
        radius_sq = (x/0.87)**2 + ((y-0.15)/0.65)**2 + ((z-0.84)/0.67)**2
    return max(-1.0, min(1.0, 1.0 - radius_sq))


def shade565(color, factor):
    r, g, b = color >> 11, (color >> 5) & 63, color & 31
    return round(r*factor[0])*2048 + round(g*factor[1])*32 + round(b*factor[2])


def bake(model, factor):
    assert len(model) == 122024 and hashlib.sha256(model).hexdigest() == BASE
    unpack = struct.unpack_from
    sections = {t: (o, n, s) for t, _, o, _, n, s in
                (unpack("<HHIIII", model, 32+20*i) for i in range(unpack("<I", model, 12)[0]))}

    def offset(kind, index):
        off, total, stride = sections[kind]
        assert 0 <= index < total
        return off + index*stride

    out = bytearray(model)
    allowed = set()
    field = {}
    coverage = {}
    selected_offsets = {}
    changed_descriptors = set()
    for i in range(sections[1][1]):
        parent, kind, _, descriptor = unpack("<hBBH", model, offset(1, i))
        if kind != 3 or parent not in (23, 43):
            continue
        group = "chest" if parent == 23 else "cheek"
        d = offset(9, descriptor)
        start, size = unpack("<HH", model, d)
        a, b = unpack("<HH", model, d+14)
        assert a == b
        if a != 0xfe93:  # cream only; orange geometry and colors stay exactly unchanged
            continue
        assert unpack("<9f", model, offset(2, i)) == (0., 0., 0., 0., 0., 0., 1., 1., 1.)
        for j in range(size):
            off = offset(10, start+j)
            xyz = unpack("<3f", model, off)
            assert unpack("<f", model, off+24)[0] == -1.0
            selected_offsets[off+24] = (descriptor, group, xyz)
        entries = [selected_offsets[offset(10, start+j)+24] for j in range(size)]
        masks = [signed_mask(group, xyz) for _,group,xyz in entries]
        touched = any(score >= 0 for score in masks)
        # Store the same signed boundary across *every* packet in the object, so
        # vertices shared with a packet with no positive mask get the same value.
        for j, score in enumerate(masks):
            off = offset(10, start+j)+24
            xyz = entries[j][2]
            key = (group, *(round(x, 5) for x in xyz))
            assert field.setdefault(key, score) == score
            struct.pack_into("<f", out, off, score)
            allowed.update(range(off, off+4))
        if touched:
            struct.pack_into("<H", out, d+16, shade565(a, factor))
            changed_descriptors.add(descriptor)
            allowed.update(range(d+16, d+18))
        counts = coverage.setdefault(group, {"packets_with_shadow": 0, "nonnegative_mask_vertices": 0, "vertices_scanned": 0})
        counts["packets_with_shadow"] += int(touched)
        counts["nonnegative_mask_vertices"] += sum(v >= 0 for v in masks)
        counts["vertices_scanned"] += size

    differences = {i for i,(a,b) in enumerate(zip(model,out)) if a!=b}
    assert differences and differences <= allowed and len(out)==len(model)
    assert len(changed_descriptors) == sum(s["packets_with_shadow"] for s in coverage.values())
    assert all(s["nonnegative_mask_vertices"] > 0 for s in coverage.values())
    return out, {"bytes": len(out), "changed_bytes": len(differences), "coverage":coverage,
                 "sha256":hashlib.sha256(out).hexdigest()}


def main():
    args = argparse.ArgumentParser(description=__doc__)
    args.add_argument("source", type=Path)
    args.add_argument("output", type=Path)
    ns = args.parse_args()
    m = ns.source.read_bytes()
    ns.output.mkdir(parents=True, exist_ok=True)
    for name,factor in PROFILES.items():
        data,report = bake(m,factor)
        (ns.output/f"{name}.aynm").write_bytes(data)
        print(json.dumps({"name":name,"factor":factor,**report},ensure_ascii=False))


if __name__ == "__main__":
    main()
