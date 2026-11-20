"""Enlarge the neutral eye artwork without touching eyebrows, mouth, or nose."""
from pathlib import Path
from PIL import Image
import numpy as np,json,sys,hashlib
src,out=map(Path,sys.argv[-2:])
im=Image.open(src).convert('RGBA')
assert im.size==(1024,1024)
r=im.copy()
pairs=[((337,482,482,629),408),((543,482,692,629),618)]
stretch=1.16
allowed=np.zeros((1024,1024),dtype=bool)
for rect,ax in pairs:
 l,t,h,b=rect; p=im.crop(rect)
 x=ax-l;y=489-t
 enlarged=p.transform(p.size,Image.Transform.AFFINE,(1/stretch,0,x*(1-1/stretch),0,1/stretch,y*(1-1/stretch)),resample=Image.Resampling.BICUBIC,fillcolor=(0,0,0,0))
 r.paste(enlarged,(l,t));allowed[t:b,l:h]=True
orig=np.asarray(im);new=np.asarray(r);d=np.any(new!=orig,axis=2)
assert d.any() and not (d&~allowed).any()
assert np.array_equal(orig[:482],new[:482]) # neither graphic moves higher than the input area.
r.save(out)
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
(out.parent/'neutral-visibility.json').write_text(json.dumps({'scale':stretch,'extent_changed_pixels':int(d.sum()),'pixels_changed_outside_eye_slots':int((d&~allowed).sum()),'vertical_top_anchor_pixel':489,'raw_neutral_sha256':sha(src),'resized_neutral_sha256':sha(out)},indent=2)+'\n')
