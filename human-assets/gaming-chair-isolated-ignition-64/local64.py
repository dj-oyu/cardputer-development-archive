"""Single-slot tiny ignition at existing near pin; all other animated tracks unchanged."""
from pathlib import Path
from PIL import Image
import numpy as np,json,hashlib
P=Path(__file__).resolve().parent
M=P.parent/'chair-engine-v8-56';A=P.parent/'chair-engine-v8-63'
out=P/'spark-crops';out.mkdir(exist_ok=True)
LOOK={'rear_-35':[(132.033,51.687),(121.8,52.398)],
      'rear_+00':[(127.240,52.180),(113.596,52.279)],
      'rear_+35':[(119.605,52.357),(107.928,51.804)]}
period=(1,.96,.64,.41,.21,0)
def load(p):return np.asarray(Image.open(p).convert('RGBA')).astype(float)
def img(m):return Image.fromarray(np.uint8(np.round(np.clip(m,0,255))))
def q(m):
 t=np.uint16(m);return ((t[:,:,0]>>3)<<11)+((t[:,:,1]>>2)<<5)+(t[:,:,2]>>3)
h=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
meta={'only_slot':4,'v63':h(A/'human-chair-engine-v8-63.blend'),
      'baseline_v56':h(M/'human-chair-engine-v8-56.blend'),'lighting':'Existing raster engine only. Same geometry, source, ignition event index/track clocks. No animated walls, tank, tube, cables or frame.','views':{}}
for v,points in LOOK.items():
 F=M/'assets'/v;R=A/'assets'/v;D=P/'assets'/v;D.mkdir(parents=True,exist_ok=True)
 C=out/v;C.mkdir(exist_ok=True)
 base=load(F/'base.png');mask=load(F/'mask.png')[:,:,3]>0
 fixed={j:load(F/f'layer_{j:02}.png') for j in (1,2,3,5,6,7,8,9)}
 for j,m in fixed.items():img(m).save(D/f'layer_{j:02}.png')
 img(base).save(D/'base.png');img(load(F/'mask.png')).save(D/'mask.png')
 yy,xx=np.mgrid[:135,:240];rec={}; coords=np.zeros_like(mask)
 for i in range(12):
  p=load(F/f'engine-proxy-{i%6}.png')
  old=load(R/f'engine-on-{i}.png');warm=np.maximum(old[:,:,:3]-p[:,:,:3],0)
  x,y=points[i//6]
  rad=np.sqrt(((xx+.5-x)/2.9)**2+((yy+.5-y)/2.15)**2)
  area=(rad<=1)&mask&(p[:,:,3]>72)
  pulse=period[i%6]
  direct=np.clip(1-rad,0,1)
  # Small crisp warm response, not a new spark mesh; nearby lattice specks remain unlit.
  delta=(warm*.79*direct[:,:,None] + (np.clip((.58-rad)*4,0,1)*pulse)[:,:,None]*[79,43,14])*area[:,:,None]
  post=p.copy();post[:,:,:3]=np.round(np.clip(post[:,:,:3]+delta,0,255))
  assert np.array_equal(post[:,:,3],p[:,:,3])
  change=np.any(post!=p,axis=2);coords|=change
  assert np.all(area[change])
  def comp(m):
   s=img(base)
   for j in range(1,10):s=Image.alpha_composite(s,img(m if j==4 else fixed[j]))
   return np.asarray(s).astype(float)
  a,b=comp(p),comp(post)
  assert np.array_equal(a[~mask],b[~mask])
  img(p).save(D/f'engine-off-{i}.png');img(post).save(D/f'engine-on-{i}.png')
  img(a).save(D/f'control-{i}.png');img(b).save(D/f'effect-{i}.png')
  img(np.uint8(area)*255).save(D/f'pin-mask-{i}.png')
  if i%6!=5:
   if np.any(change):
    iy,ix=np.where(change);bb=tuple(int(z) for z in (min(ix),min(iy),max(ix)+1,max(iy)+1))
    data=np.dstack((np.maximum(post[:,:,:3]-p[:,:,:3],0),255*change))
    dest=C/f'{i}.png';img(data).crop(bb).save(dest)
   else:bb=()
  else:bb=();assert np.array_equal(a,b)
  rec[i]={'visible_rgb565_changes':int(np.sum(q(a)!=q(b))),'crop_xyxy':bb}
 meta['views'][v]={'pinXY':points,'established_counts':rec}
(out/'manifest.json').write_text(json.dumps(meta,indent=2)+'\n')
