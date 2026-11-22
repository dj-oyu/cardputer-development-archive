import json,hashlib
from pathlib import Path
from PIL import Image,ImageDraw
import numpy as np
P=Path(__file__).resolve().parent
m=P/'chair-knee-over-knee-v77-motion.blend'
read=lambda x:json.loads((P/x).read_text())
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
r=read('reopened-motion.json')
assert r['candidate_sha256']==sha(m)=='337deaaedae9354ada5e90993327f34d485b5a7ecf3c8bd9e9242a763654f4d5'
assert len(r['rows'])==193
re=r['rows']; a=next(q['f'] for q in re if q['top_knee_world'][0]<0);b=next(q['f'] for q in re if q['top_ankle_world'][0]<0)
assert a<b
root=P/'native'/'final-motion'
out={}
def open1(v,i):return Image.open(root/f'{v}-{i:03}.png').convert('RGB')
for v in ('front','quarter'):
 images=[open1(v,i) for i in range(1,50)]
 assert all(im.size==(240,135) for im in images)
 gif=P/f'knee-over-knee-{v}-240x135.gif'
 png=P/f'knee-over-knee-{v}-240x135.apng.png'
 images[0].save(gif,save_all=True,append_images=images[1:],duration=100,loop=0,disposal=2,optimize=False)
 track=[(images[0],100)]
 for im in images[1:]:
  last,du=track[-1]
  if np.array_equal(np.array(im),np.array(last)):track[-1]=(last,du+100)
  else:track.append((im,100))
 track[0][0].save(png,save_all=True,append_images=[im for im,_ in track[1:]],duration=[du for _,du in track],loop=0,disposal=0,blend=0,optimize=False)
 with Image.open(png) as ob:
  assert ob.n_frames==len(track)
  for i,(im,du) in enumerate(track):
   ob.seek(i);assert ob.info['duration']==du
   assert np.array_equal(np.array(ob.convert('RGB')),np.array(im))
 with Image.open(gif) as ob:
  dur=0
  for i in range(ob.n_frames):ob.seek(i);dur+=ob.info['duration']
  assert dur==4900
 out[v]={'gif':sha(gif),'lossless_apng':sha(png),'duration_ms':4900,'frames':[sha(root/f'{v}-{i:03}.png') for i in range(1,50)]}
im=Image.new('RGB',(1200,456),'#263039')
d=ImageDraw.Draw(im)
for j,v in enumerate(('front','quarter','side')):
 for k,(f,label) in enumerate([(1,'neutral'),(9,'lift'),(15,'cross'),(25,'hold'),(49,'return')]):
  z=open1(v,f)
  im.paste(z,(k*240,j*152+17)); d.text((k*240+7,j*152+2),f'{v} / {label}',fill='white')
im.save(P/'knee-over-knee-native-contact-sheet.png')
small=Image.new('RGB',(480,152),'#263039');dd=ImageDraw.Draw(small)
for k,(f,label) in enumerate([(1,'neutral'),(25,'knee over knee')]):
 small.paste(open1('front',f),(k*240,17));dd.text((k*240+7,2),label,fill='white')
small.save(P/'knee-over-knee-front-comparison.png')
summary={'source_sha256':r['source_sha256'],'model_sha256':r['candidate_sha256'],'quarter_frame_reopen_samples':len(re),'static_hold':r['hold'],'cross_frame':{'knee':a,'ankle':b},'native_preview':out}
(P/'final-v77-receipt.json').write_text(json.dumps(summary,indent=2)+'\n')
