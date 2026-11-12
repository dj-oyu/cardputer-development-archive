#!/usr/bin/env python3
"""Experimental versioned static source -> integer AYFQ v1, never legacy AYNM.

Only pre-scale parts.positions and materialTrace.scaledLinear are consumed.
No source asset data or file names are embedded in this generic source.
"""
import argparse
import hashlib
import json
import math
import os
from pathlib import Path
import struct
import zlib

MAGIC = b"AYFQ\x00\x00\x00\x01"
HEADER = struct.Struct("<8s14I")
PART = struct.Struct("<8I")
MATERIAL = struct.Struct("<3hH")
BLOCK = struct.Struct("<24i24h")
MAX_PARTS, MAX_MATERIALS = 256, 4096


def require(condition, message):
    if not condition:
        raise ValueError(message)


def finite(x):
    if type(x) not in (int, float):
        return False
    try:
        return math.isfinite(x)
    except OverflowError:
        return False


def vec3(v):
    return isinstance(v, list) and len(v) == 3 and all(finite(x) for x in v)


def quantize(x, scale, low, high):
    require(finite(x), "nonfinite component")
    # Python round is nearest, ties to even. It is part of this NEW contract.
    scaled = x * scale
    require(math.isfinite(scaled), "scaled overflow")
    q = round(scaled)
    require(low <= q <= high, "fixed-point overflow; no saturation")
    return q


def cross(a, b, c):
    u, v = [b[k] - a[k] for k in range(3)], [c[k] - a[k] for k in range(3)]
    return [u[1]*v[2]-u[2]*v[1], u[2]*v[0]-u[0]*v[2], u[0]*v[1]-u[1]*v[0]]


def align16(n):
    return (n + 15) & ~15


def compile_report(source, fraction_bits=16):
    require(type(fraction_bits) is int and 0 <= fraction_bits <= 24, "fraction bits")
    require(isinstance(source, dict), "source object")
    required = {"schema": "ayatsuri-fixed-static-input-v1",
                "coordinate_system": "ayatsuri-native-metres", "source_units": "metres",
                "geometry_scale": 1, "source_mode": "baked-static"}
    require(all(source.get(k) == v for k, v in required.items()), "explicit static source/unit contract required")
    require(type(source["geometry_scale"]) in (int, float), "geometry scale type")
    parts, trace = source.get("parts"), source.get("materialTrace")
    require(isinstance(parts, list) and 0 < len(parts) <= MAX_PARTS, "part count")
    require(isinstance(trace, list) and 0 < len(trace) <= MAX_MATERIALS, "material count")
    materials, material_ids = [], {}
    color_errors, position_errors, normal_errors = [], [], []
    for m in trace:
        require(isinstance(m, dict) and isinstance(m.get("id"), str) and m["id"], "material id")
        require(m["id"] not in material_ids, "duplicate material id")
        rgb = m.get("scaledLinear")
        require(vec3(rgb) and all(0 <= c <= 1 for c in rgb), "linear albedo range")
        q = [quantize(c, 32767, 0, 32767) for c in rgb]
        color_errors.extend(abs(q[k]/32767-rgb[k]) for k in range(3))
        material_ids[m["id"]] = len(materials)
        materials.append(tuple(q))
    encoded_parts, blocks, triangles, vertices = [], [], [], 0
    for p in parts:
        require(isinstance(p, dict), "part object")
        pos, normals, tri = p.get("positions"), p.get("normals"), p.get("triangles")
        require(isinstance(pos, list) and 0 < len(pos) <= 32, "vertex count")
        require(isinstance(normals, list) and len(normals) == len(pos), "normal count")
        require(isinstance(tri, list) and 0 < len(tri) <= 64, "triangle count")
        require(isinstance(p.get("materialId"), str) and p["materialId"] in material_ids, "unknown material")
        require(p.get("materialSidedness") in ("single", "double"), "sidedness")
        qp, qn = [], []
        for v, n in zip(pos, normals):
            require(vec3(v) and vec3(n), "vertex shape")
            require(abs(math.hypot(*n)-1) <= 1e-4, "unit source normal required")
            a = [quantize(x, 1 << fraction_bits, -(1 << 31), (1 << 31)-1) for x in v]
            b = [quantize(x, 32767, -32767, 32767) for x in n]
            require(any(b), "zero encoded normal")
            qp.append(a)
            qn.append(b)
            position_errors.extend(abs(a[k]/(1 << fraction_bits)-v[k]) for k in range(3))
            normal_errors.extend(abs(b[k]/32767-n[k]) for k in range(3))
        first_tri, first_block = len(triangles), len(blocks)
        for t in tri:
            require(isinstance(t, list) and len(t) == 3 and all(type(i) is int and 0 <= i < len(pos) for i in t), "triangle index")
            require(len(set(t)) == 3, "repeated triangle vertex")
            old = cross(*(pos[i] for i in t))
            new = cross(*(qp[i] for i in t))
            require(any(new), "triangle collapses after quantization")
            require(all(math.isfinite(x) for x in old) and sum(old[k]*new[k] for k in range(3)) > 0, "triangle changes orientation")
            triangles.append((*t, 0))
        for start in range(0, len(pos), 8):
            pp, nn = qp[start:start+8], qn[start:start+8]
            pp += [[0, 0, 0] for _ in range(8-len(pp))]
            nn += [[0, 0, 0] for _ in range(8-len(nn))]
            blocks.append([pp[i][k] for k in range(3) for i in range(8)] + [nn[i][k] for k in range(3) for i in range(8)])
        encoded_parts.append((first_block, len(blocks)-first_block, len(pos), first_tri, len(tri), material_ids[p["materialId"]], int(p["materialSidedness"] == "double"), 0))
        vertices += len(pos)
    po = HEADER.size
    mo = align16(po + len(encoded_parts)*PART.size)
    bo = align16(mo + len(materials)*MATERIAL.size)
    to = align16(bo + len(blocks)*BLOCK.size)
    size = align16(to + len(triangles)*4)
    out = bytearray(size)
    fields = [1, 1, fraction_bits, len(parts), len(materials), vertices, len(triangles), len(blocks), po, mo, bo, to, size, 0]
    HEADER.pack_into(out, 0, MAGIC, *fields)
    for i, p in enumerate(encoded_parts):
        PART.pack_into(out, po+i*PART.size, *p)
    for i, m in enumerate(materials):
        MATERIAL.pack_into(out, mo+i*MATERIAL.size, *m, 0)
    for i, b in enumerate(blocks):
        BLOCK.pack_into(out, bo+i*BLOCK.size, *b)
    for i, t in enumerate(triangles):
        struct.pack_into("<4B", out, to+4*i, *t)
    struct.pack_into("<I", out, 60, zlib.crc32(out))
    decoded = decode(out)
    require(len(decoded["parts"]) == len(parts), "self-check")
    stats = {"format": "AYFQ experimental v1", "fraction_bits": fraction_bits,
             "units": "metres, current imported native basis, BEFORE legacy scale 38",
             "parts": len(parts), "vertices": vertices, "triangles": len(triangles),
             "materials": len(materials), "blocks": len(blocks), "bytes": size,
             "position_abs_max_m": max(position_errors), "normal_component_abs_max": max(normal_errors),
             "linear_albedo_abs_max": max(color_errors), "collapsed_or_flipped_triangles": 0,
             "baseline_replaced": False, "renderer_integrated": False}
    return bytes(out), stats


def decode(blob):
    require(isinstance(blob, (bytes, bytearray)) and HEADER.size <= len(blob) <= 2*1024*1024, "file size")
    magic, *f = HEADER.unpack_from(blob)
    version, flags, frac, np, nm, nv, nt, nb, po, mo, bo, to, size, crc = f
    require(magic == MAGIC and version == 1 and flags == 1 and 0 <= frac <= 24, "format header")
    require(0 < np <= MAX_PARTS and 0 < nm <= MAX_MATERIALS and 0 < nv <= np*32 and 0 < nt <= np*64 and 0 < nb <= np*4, "header counts")
    require(po == 64 and mo == align16(po+np*32) and bo == align16(mo+nm*8) and to == align16(bo+nb*144) and size == align16(to+nt*4) and size == len(blob), "section layout")
    check = bytearray(blob)
    check[60:64] = b"\0"*4
    require(zlib.crc32(check) == crc, "CRC")
    require(not any(blob[mo+nm*8:bo]) and not any(blob[to+nt*4:size]), "section padding")
    mats = []
    for i in range(nm):
        r, g, b, pad = MATERIAL.unpack_from(blob, mo+i*8)
        require(min(r, g, b) >= 0 and pad == 0, "material encoding")
        mats.append([r, g, b])
    parts, next_block, next_tri, sum_vertices = [], 0, 0, 0
    for i in range(np):
        first, count, n, tri, count_tri, mat, sided, reserved = PART.unpack_from(blob, po+i*32)
        require(1 <= n <= 32 and count == (n+7)//8 and first == next_block and first+count <= nb and tri == next_tri and 1 <= count_tri <= 64 and tri+count_tri <= nt and mat < nm and sided <= 1 and reserved == 0, "part encoding")
        positions, normals = [], []
        for j in range(count):
            q = BLOCK.unpack_from(blob, bo+(first+j)*144)
            for lane in range(8):
                p = [q[k*8+lane] for k in range(3)]
                normal = [q[24+k*8+lane] for k in range(3)]
                if j*8+lane >= n:
                    require(not any(p+normal), "padded lane")
                else:
                    require(-32768 not in normal and any(normal), "normal encoding")
                    # Input unit tolerance plus worst three-component rounding
                    # is less than five integer codes in vector length.
                    norm2 = sum(x*x for x in normal)
                    require(32762**2 <= norm2 <= 32772**2, "encoded normal length")
                    positions.append(p)
                    normals.append(normal)
        ts = []
        for j in range(count_tri):
            a, b, c, pad = struct.unpack_from("<4B", blob, to+(tri+j)*4)
            require(max(a,b,c) < n and len({a,b,c}) == 3 and pad == 0, "triangle encoding")
            require(any(cross(positions[a], positions[b], positions[c])), "degenerate encoded triangle")
            ts.append([a,b,c])
        parts.append({"positions": positions, "normals": normals, "triangles": ts, "material_index": mat, "double_sided": bool(sided)})
        next_block += count
        next_tri += count_tri
        sum_vertices += n
    require(next_block == nb and next_tri == nt and sum_vertices == nv, "section totals")
    return {"fraction_bits": frac, "materials": mats, "parts": parts}


def write_pair_new(output, blob, stats):
    """Never replace existing files; clean up this call's files on failure.

    This is not crash-atomic across two files. Consumers validate binary CRC;
    a completed evidence handoff additionally requires the metadata file.
    """
    paths = [output, output.with_suffix(output.suffix+".json")]
    payloads = [blob, (json.dumps(stats, indent=2)+"\n").encode()]
    opened = []
    try:
        for path in paths:
            fd = os.open(path, os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o600)
            opened.append((path, fd, os.fstat(fd)))
        for (_, fd, _), data in zip(opened, payloads):
            view = memoryview(data)
            while view:
                count = os.write(fd, view)
                require(count > 0, "short output write")
                view = view[count:]
            os.fsync(fd)
    except BaseException:
        for path, fd, identity in opened:
            try:
                now = path.stat(follow_symlinks=False)
                if (now.st_dev, now.st_ino) == (identity.st_dev, identity.st_ino):
                    path.unlink()
            except FileNotFoundError:
                pass
        raise
    finally:
        for _, fd, _ in opened:
            os.close(fd)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("compile_report", type=Path)
    parser.add_argument("output", type=Path)
    parser.add_argument("--fraction-bits", type=int, default=16)
    args = parser.parse_args()
    require(not args.output.exists() and not args.output.with_suffix(args.output.suffix+".json").exists(), "output or metadata already exists; do not overwrite")
    limit = 32*1024*1024
    require(args.compile_report.stat().st_size <= limit, "source size")
    with args.compile_report.open("rb") as src:
        raw = src.read(limit+1)
    require(len(raw) <= limit, "source size")
    blob, stats = compile_report(json.loads(raw), args.fraction_bits)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    stats.update(source_sha256=hashlib.sha256(raw).hexdigest(), output_sha256=hashlib.sha256(blob).hexdigest())
    write_pair_new(args.output, blob, stats)
    print(json.dumps(stats, indent=2))


if __name__ == "__main__":
    main()
