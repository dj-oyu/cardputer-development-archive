from pathlib import Path
from shutil import copyfile
from PIL import Image, ImageChops
import numpy as np, json,hashlib
P=Path(__file__).resolve().parent;old=P.parent/'chair-engine-v8-54'
load=lambda p:Image.open(p).convert('RGBA')
def q(im):
 a=np.asarray(im)[:,:,:3].astype(np.uint16);return (a[:,:,0]>>3)*2048+(a[:,:,1]>>2)*32+(a[:,:,2]>>3)
receipt={}
for fam,name in [('assets','engine-native'),('detail','engine-detail')]:
 for raw in sorted((P/name).glob('rear_*')):
  s=old/fam/raw.name;d=P/fam/raw.name;d.mkdir(parents=True,exist_ok=True)
  for n in ('base.png','mask.png',*[f'layer_{i:02}.png' for i in (1,2,3,5,6,7,8,9)]):copyfile(s/n,d/n)
  mask=load(d/'mask.png').getchannel('A')
  parts={}; full={}
  for f in sorted(raw.glob('*.png')):
   idx=int(f.stem);engine=load(f);engine.putalpha(ImageChops.multiply(engine.getchannel('A'),mask));parts[idx]=engine
   engine.save(d/f'engine-proxy-{idx}.png')
   ready=load(d/'base.png')
   for j in range(1,10):ready=Image.alpha_composite(ready,engine if j==4 else load(d/f'layer_{j:02}.png'))
   full[idx]=ready;ready.save(d/f'full-{idx}.png')
  cut=(min(im.getchannel('A').getbbox()[0] for im in parts.values()),min(im.getchannel('A').getbbox()[1] for im in parts.values()),max(im.getchannel('A').getbbox()[2] for im in parts.values()),max(im.getchannel('A').getbbox()[3] for im in parts.values()))
  parts[0].save(d/'layer_04.png');full[0].save(d/'full.png')
  if fam=='assets':
   ds=P/'engine-phase-assets'/raw.name;ds.mkdir(parents=True,exist_ok=True)
   nmet={};baseline=q(full[0])
   for i,e in parts.items():
    path=ds/f'{i}.png';e.crop(cut).save(path)
    eq=(q(full[i])!=baseline)
    static=np.asarray(Image.open(s/'full.png').convert('RGBA'))
    assert np.array_equal(np.asarray(full[i])[np.array(mask)==0],static[np.array(mask)==0])
    nmet[str(i)]={'sha256':hashlib.sha256(path.read_bytes()).hexdigest(),'changed_rgb565_vs_phase0':int(eq.sum())}
   receipt[raw.name]={'originXY':list(cut[:2]),'sizeWH':[cut[2]-cut[0],cut[3]-cut[1]],'phases':nmet}
(P/'engine-phase-assets'/'manifest.json').write_text(json.dumps({'order':4,'phase_degrees':[0,60,120,180,240,300],'resolution':[240,135],'views':receipt},indent=2)+'\n')
print(json.dumps(receipt,indent=2))
