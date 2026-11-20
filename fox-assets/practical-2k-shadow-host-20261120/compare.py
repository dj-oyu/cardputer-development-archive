#!/usr/bin/env python3
"""Compare exact renderer buffers, then compose native-resolution review tiles."""
from array import array
from pathlib import Path
from PIL import Image, ImageDraw
import json
import sys
root = Path(sys.argv[1])
width,height=240,135
angles=(-35,35)
stamps=(0,1500,4000,7200,7500,7850,8050,8500,9000,9350,11999,12000)
profiles=("baseline","weak","strong")

def read(profile,angle,stamp):
    pixels = array("H")
    pixels.frombytes((root/profile/str(angle)/f"{stamp}.rgb565").read_bytes())
    if sys.byteorder != "little":
        pixels.byteswap()
    assert len(pixels) == width*height
    return pixels

def rgb(value):
    r,g,b=value>>11,(value>>5)&63,value&31
    return ((r<<3)|(r>>2),(g<<2)|(g>>4),(b<<3)|(b>>2))
    
evidence={}
for angle in angles:
    statistics={}
    for stamp in stamps:
        a,b,c=[read(k,angle,stamp) for k in profiles]
        assert all(bool(x)==bool(y)==bool(z) for x,y,z in zip(a,b,c))
        assert all(x==y==z for x,y,z in zip(a[100*width:],b[100*width:],c[100*width:]))
        changed=[i for i,(x,y,z) in enumerate(zip(a,b,c)) if x!=y or x!=z]
        assert changed
        statistics[stamp] = {"weak_changed":sum(x!=y for x,y in zip(a,b)),"strong_changed":sum(x!=z for x,z in zip(a,c)),
         "diff_bounds_xyxy":[min(i%width for i in changed),min(i//width for i in changed),max(i%width for i in changed),max(i//width for i in changed)]}
    evidence[angle]=statistics
(root/"pixel-differences.json").write_text(json.dumps(evidence,indent=2)+"\n")
rows=[(-35,0),(-35,7850),(35,0),(35,7850)]
pad=12; header=41; gap=24; foot=30; col=width+8
sheet=Image.new("RGB",(pad*2+3*col-8,header+len(rows)*(gap+height)+foot),(25,28,33))
draw=ImageDraw.Draw(sheet)
draw.text((pad,8),"FOX 2K | HOST RENDER | BAKED SHADOW A/B",(232,236,241))
for j,label in enumerate(("NO SHADOW","WEAK","STRONG")):
    draw.text((pad+j*col,25),label,(232,236,241))
for i,(angle,stamp) in enumerate(rows):
    y=header+i*(gap+height)
    draw.text((pad,y+6),f"{angle:+} deg | {'neutral' if stamp==0 else 'turn toward camera'}",(185,194,207))
    for j,k in enumerate(profiles):
        pix=read(k,angle,stamp)
        im=Image.frombytes("RGB",(width,height),bytes(c for p in pix for c in rgb(p)))
        sheet.paste(im,(pad+j*col,y+gap))
draw.text((pad,sheet.height-foot+8),"Native 240 x 135 per tile. Same geometry, camera and lighting.",(185,194,207))
sheet.save(root/"compare.png")
