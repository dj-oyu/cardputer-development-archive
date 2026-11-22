"""Same-frame rear-rest color overlay proof + native clean output."""
from pathlib import Path
from PIL import Image,ImageDraw,ImageFont,ImageChops
import numpy as np,json
P=Path(__file__).resolve().parent
N=144
m=json.loads((P/'rear-eligibility.json').read_text());out=P/'final';out.mkdir(exist_ok=True)
meta=[];seq=[]
for i in range(1,N+1):
 a=Image.open(P/'frames'/f'frame-{i:04d}.png').convert('RGBA')
 if m[str(i)]['overlay']:
  p=Image.open(P/'rearlayer'/f'back-{i:04d}.png').convert('RGBA')
  polished=ImageChops.multiply(p.getchannel('A'),Image.open(P/'actor-matte'/f'visible-{i:04d}.png').getchannel('A'))
  p.putalpha(polished);q=np.asarray(polished)>0
  b=Image.alpha_composite(a,p)
 else:
  b=a.copy();q=np.zeros((135,240),bool)
 diff=np.abs(np.asarray(a,dtype=int)-np.asarray(b,dtype=int)).max(2)
 assert not np.any(diff[~q])
 meta.append({**m[str(i)],'frame':i,'mask_pixels':int(q.sum()),'rgb_changed_inside_gt_4':int((diff>4).sum()),'outside_changed':int((diff[~q]>0).sum())})
 b=b.convert('RGB');seq.append(b);b.save(out/f'frame-{i:04d}.png')
(P/'rear-overlay-proof.json').write_text(json.dumps(meta,indent=2)+'\n')
seq[0].save(P/'chair-spin-v72-native.gif',save_all=True,append_images=seq[1:],loop=0,duration=[80,80,90]*48,disposal=2,optimize=False)
# Objective approval sheet: same-time composite before and after, controlled front.
want=sorted(meta,key=lambda r:r['rgb_changed_inside_gt_4'],reverse=True)
used=[]
for x in want:
 if x['overlay'] and all(abs(x['frame']-i)>10 for i in used):used.append(x['frame'])
 if len(used)==3:break
used.append(1)
cv=Image.new('RGB',(1018,373),(25,27,31));dr=ImageDraw.Draw(cv)
fonts=lambda p:ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf',p)
def TXT(x,y,t,p=16):dr.text((x,y),t,font=fonts(p),fill=(222,231,235))
TXT(18,12,'Actual rearrest mask | same-frame off/on at native 240×135',25)
TXT(18,47,'Upper: ordinary depth. Lower: rear-facing rest priority only at overlapping body pixels.',16)
for j,i in enumerate(used):
 x=18+j*248
 a=Image.open(P/'frames'/f'frame-{i:04d}.png').convert('RGB')
 b=seq[i-1]
 TXT(x,74,f'Frame {i}'+(' · front control' if i==1 else ' · rear priority'))
 cv.paste(a,(x,99));cv.paste(b,(x,237))
cv.save(P/'rear-order-v72-private-review.png')
print('rear frames',sum(q['overlay'] for q in meta),'changed>4 on',sum(q['rgb_changed_inside_gt_4']>0 for q in meta),'peak',max(q['rgb_changed_inside_gt_4'] for q in meta),'selected',used)
