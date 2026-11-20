#!/usr/bin/env python3
from array import array
from pathlib import Path
from PIL import Image, ImageDraw
import json
import sys

root=Path(sys.argv[1])
base=Path(sys.argv[2])
W,H=240,135
STAMPS=(0,1500,4000,7200,7500,7850,8050,8500,9000,9350,11999,12000)

def read(k,angle,t):
    buf=array("H")
    file=(base/str(angle) if k=="prior" else root/k/str(angle))/f"{t}.rgb565"
    buf.frombytes(file.read_bytes())
    assert len(buf)==W*H
    if sys.byteorder!="little":
        buf.byteswap()
    return buf

def rgb(p):
    r,g,b=p>>11,(p>>5)&63,p&31
    return (r<<3|r>>2,g<<2|g>>4,b<<3|b>>2)

def stat(x):
    return {"pixels":len(x), "bounds":[min(i%W for i in x),min(i//W for i in x),max(i%W for i in x),max(i//W for i in x)] if x else None}

report={}
for anchor in (-35,35):
    for t in STAMPS:
        baseline,a,b,both=[read(k,anchor,t) for k in ("prior","tail","forehead","tail-forehead")]
        assert all(bool(x)==bool(y) for x,y in zip(baseline,both)), "silhouette delta"
        diff_a={i for i,(x,y) in enumerate(zip(baseline,a)) if x!=y}
        diff_b={i for i,(x,y) in enumerate(zip(baseline,b)) if x!=y}
        diff={i for i,(x,y) in enumerate(zip(baseline,both)) if x!=y}
        assert not diff_a&diff_b
        assert diff==diff_a|diff_b
        assert all(both[i]==a[i] for i in diff_a) and all(both[i]==b[i] for i in diff_b)
        assert anchor>=0 or diff_a
        assert diff_b
        assert all(i//W<100 for i in diff)
        assert all(i//W<=42 for i in diff_b), "forehead changed eye-zone pixels"
        report[f"{anchor}/{t}"]={"tail":stat(diff_a),"forehead":stat(diff_b)}
(root/"pixel-differences.json").write_text(json.dumps(report,indent=2)+"\n")

P=12
col=W+8
rows=[(-35,0),(-35,7850),(35,0),(35,7850)]
sheet=Image.new("RGB",(P*2+2*col-8,40+len(rows)*(24+H)+30),(25,28,33))
draw=ImageDraw.Draw(sheet)
draw.text((P,8),"FOX 2K | TAIL AND FOREHEAD SHADOW | HOST RENDER",(232,236,241))
for j,s in enumerate(("PRIOR (CHEEK + CHEST)","WITH TAIL + FOREHEAD")):
    draw.text((P+j*col,24),s,(232,236,241))
for i,(anchor,ms) in enumerate(rows):
    y=40+i*(24+H)
    draw.text((P,y+7),f"{anchor:+} deg | {'neutral' if ms==0 else 'turn toward camera'}",(185,194,207))
    for j,k in enumerate(("prior","tail-forehead")):
        pix=read(k,anchor,ms)
        im=Image.frombytes("RGB",(W,H),bytes(c for v in pix for c in rgb(v)))
        sheet.paste(im,(P+j*col,y+24))
draw.text((P,sheet.height-20),"240 x 135 px per view. Identical geometry and lighting.",(185,194,207))
sheet.save(root/"compare.png")
