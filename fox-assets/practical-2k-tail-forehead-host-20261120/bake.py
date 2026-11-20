#!/usr/bin/env python3
"""Bake optional forehead and tail underside shadows onto the pinned weak v5."""
import argparse
from collections import Counter
import hashlib
import json
from pathlib import Path
import struct

BASE="27cbd094a019667a31ba77ed8ff438d63ba135e6235bf8f7a8dfa97a49d49981"
SHADING={"tail":(0.89,0.80,0.65),"forehead":(0.92,0.84,0.75)}
GROUPS={20:"tail",43:"forehead"}


def mask(group, xyz):
    x,y,z=(round(v,5) for v in xyz)
    if group=="tail":
        # Positive Y is down. Keep the top and cream tip in the original palette.
        # Angle the boundary along the lower curl so it tapers near the root.
        value=min((y-(0.13+0.11*max(0.,x+0.8)))/0.27,
                  (-x-0.28)/0.38, (z+1.38)/0.4)
    else:
        # Bilateral upper-side crescents. Leave the center and brow/eye zone clear.
        rr=((abs(x)-0.39)/0.18)**2+((y+0.48)/0.15)**2+((z-0.38)/0.29)**2
        value=1.0-rr
    return max(-1.,min(1.,value))


def shade565(color, strength):
    r,g,b=color>>11,(color>>5)&63,color&31
    a=SHADING[strength]
    return round(r*a[0])*2048 + round(g*a[1])*32 + round(b*a[2])


def bake(model, wanted):
    sha=lambda x: hashlib.sha256(x).hexdigest()
    if len(model)!=122024 or sha(model)!=BASE:
        raise ValueError("not the pinned weak v5 model")
    unpack=struct.unpack_from
    sections={t:(off,n,stride) for t,_,off,_,n,stride in
              (unpack("<HHIIII",model,32+i*20) for i in range(unpack("<I",model,12)[0]))}

    def row(section,i):
        start,count,stride=sections[section]
        assert 0<=i<count
        return start+i*stride

    out=bytearray(model)
    allowed=set()
    boundaries={}
    counters={k:Counter() for k in wanted}
    for node in range(sections[1][1]):
        parent,kind,_,descriptor=unpack("<hBBH",model,row(1,node))
        group=GROUPS.get(parent)
        if kind!=3 or group not in wanted:
            continue
        d=row(9,descriptor)
        color,b=unpack("<HH",model,d+14)
        if color!=0xe1c1:  # these additions only touch orange fur, not the old cream shadows
            continue
        assert color==b
        assert unpack("<9f",model,row(2,node))==(0.,0.,0.,0.,0.,0.,1.,1.,1.)
        first,n=unpack("<HH",model,d)
        verts=[]
        for i in range(first,first+n):
            off=row(10,i)
            xyz=unpack("<3f",model,off)
            assert unpack("<f",model,off+24)[0]==-1.
            m=mask(group,xyz)
            verts.append((off+24,m))
            key=(group,*(round(v,5) for v in xyz))
            assert boundaries.setdefault(key,m)==m
        c=counters[group]
        c["positions_scanned"]+=len(verts)
        c["positions_with_shadow"]+=sum(m>=0 for _,m in verts)
        hit=any(m>=0 for _,m in verts)
        if hit:
            struct.pack_into("<H",out,d+16,shade565(color,group))
            allowed.update(range(d+16,d+18))
            c["packets_with_shadow"]+=1
        # Values on adjoining packets are identical even if all their values are negative.
        for off,m in verts:
            struct.pack_into("<f",out,off,m)
            allowed.update(range(off,off+4))
    changed={i for i,(a,b) in enumerate(zip(model,out)) if a!=b}
    assert changed and changed<=allowed and len(out)==len(model)
    assert all(c["packets_with_shadow"]>0 and c["positions_with_shadow"]>0 for c in counters.values())
    return out,{"sha256":sha(out),"bytes":len(out),"changed_bytes":len(changed),"groups":counters}


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument("source",type=Path)
    p.add_argument("output",type=Path)
    p.add_argument("--diagnostic-isolates",action="store_true")
    args=p.parse_args()
    m=args.source.read_bytes()
    args.output.mkdir(parents=True,exist_ok=True)
    variants={"tail-forehead":{"tail","forehead"}}
    if args.diagnostic_isolates:
        variants.update(tail={"tail"},forehead={"forehead"})
    for name,groups in variants.items():
        result,report=bake(m,groups)
        (args.output/(name+".aynm")).write_bytes(result)
        print(json.dumps({"variant":name,**report},sort_keys=True))


if __name__=="__main__":
    main()
