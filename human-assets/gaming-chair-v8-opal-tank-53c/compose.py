"""Compact native package: same view & nine static slots, only old white case phases as new crops."""
from pathlib import Path
from shutil import copyfile
from PIL import Image
import numpy as np,json,hashlib
P=Path(__file__).resolve().parent
S=P.parent/'chair-raytrace-52';E=P.parent/'chair-engine-v8-53b'
D=P/'phase-assets';D.mkdir(exist_ok=True)
load=lambda p:Image.open(p).convert('RGBA')
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def q(i):
 a=np.asarray(i)[:,:,:3].astype(np.uint16);return (a[:,:,0]>>3)*2048+(a[:,:,1]>>2)*32+(a[:,:,2]>>3)
report={'resolution':[240,135],'layers':9,'replaced':[4,5],
 'layers_note':'04 authored V8. 05 static old blue-tinted bottle then original valve housing edited milky & opal. Phase crops target the housing only. Layer 05 proxy contains both.',
 'phase':'Camera view selected separately from liquid phase. This package includes no runtime animation or device benchmark.','flipbook':{}}
for family in ('assets','detail'):
 for k in sorted((P/family).glob('rear_*')):
  src=S/family/k.name;source_v8=E/family/k.name
  f=D/k.name;f.mkdir(exist_ok=True)
  for n in ('base.png','mask.png',*[f'layer_{i:02}.png' for i in (1,2,3,6,7,8,9)]):
   copyfile(src/n,k/n);assert sha(k/n)==sha(src/n),n
  copyfile(source_v8/'layer_04.png',k/'layer_04.png')
  aperture=np.asarray(load(k/'mask.png').getchannel('A'))
  def exact_silhouette(image,r):
   v=np.array(image);a=np.array(r)
   edge=(v[:,:,3]==0)&(a[:,:,3]>0)
   v[edge,:3]=a[edge,:3]
   v[:,:,3]=a[:,:,3]
   v[aperture==0,3]=0
   return Image.fromarray(v)
  bottle=exact_silhouette(load(k/'legacy-bottle.png'),load(src/'layer_05.png'));bsz=bottle.getchannel('A').getbbox()
  bottle.save(k/'phase-proxy-off.png')
  modes=['settled','left','right'] if family=='assets' else ['settled']
  tank={n:exact_silhouette(load(k/f'legacy-{n}.png'),load(src/'layer_04.png')) for n in modes}
  AABB=tuple(h(g) for h,g in zip((min,min,max,max),list(zip(*(im.getchannel('A').getbbox() for im in tank.values())))))
  rr,allims={},{}
  for n,im in tank.items():
   if family=='assets':
    im.crop(AABB).save(f/(n+'.png'))
    rr[n]={'file':str((f/(n+'.png')).relative_to(D)),'sha256':sha(f/(n+'.png'))}
    z=np.array(load(k/f'legacy-matte-{n}.png').getchannel('A'));z[aperture==0]=0;w=Image.fromarray(z)
    w.crop(AABB).save(f/('matte-'+n+'.png'))
   Image.alpha_composite(bottle,im).save(k/('layer_05.png' if n=='settled' else f'phase-proxy-{n}.png'))
  for mode in [*modes,'off']:
   full=load(k/'base.png')
   for j in range(1,10):
    if j==5:lay=bottle if mode=='off' else Image.alpha_composite(bottle,tank[mode])
    else:lay=load(k/f'layer_{j:02}.png')
    full=Image.alpha_composite(full,lay)
   allims[mode]=full
   if mode=='off':full.save(k/'tank-off.png')
   elif mode=='settled':full.save(k/'full.png')
   else:full.save(k/f'full-{mode}.png')
  if family=='assets':
   ref=load(src/'full.png')
   a=np.asarray(ref);b=np.asarray(allims['settled']);m=np.asarray(load(k/'mask.png').getchannel('A'));assert np.array_equal(a[m==0],b[m==0])
   diff={n:int(np.count_nonzero(q(v)!=q(allims['settled']))) for n,v in allims.items() if n!='settled'}
   assert diff['off']>0
   vals=(AABB[2]-AABB[0],AABB[3]-AABB[1])
   report['flipbook'][k.name]={'originXY':list(AABB[:2]),'sizeWH':list(vals),'max_uncompressed_crop_pixels':vals[0]*vals[1],'blue_bottle_box':bsz,'same_origin_and_size_all_phases':True,'changed_rgb565_vs_settled':diff,'phase_meta':rr}
(D/'manifest.json').write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps(report,indent=2))
