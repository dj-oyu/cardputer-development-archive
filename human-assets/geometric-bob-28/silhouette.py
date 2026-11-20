"""Rasterize the bob-only projection; measure hem width and adjacent side tangents."""
from PIL import Image,ImageDraw,ImageFont
import numpy as np
from pathlib import Path
import json, math
d=Path(__file__).resolve().parent
db=json.loads((d/'projection.json').read_text())
f=ImageFont.truetype('/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc',20)
can=Image.new("RGB",(1670,850),(224,220,213));q=ImageDraw.Draw(can)
q.text((24,10),'後ろ髪だけの輪郭：色・照明・襟なし',fill='#273237',font=f)
proof={}
for j,label in enumerate(('180','145','-145')):
 q.text((24+j*546,46),{'180':'真後ろ','145':'後ろ斜め＋35°','-145':'後ろ斜め−35°'}[label],fill='#273237',font=f)
 for i,(tag,maps) in enumerate(db.items()):
  obj=maps[label];m=Image.new('L',tuple(obj['size']));draw=ImageDraw.Draw(m)
  for v in obj['triangles']:draw.polygon([tuple(obj['projected'][k]) for k in v],fill=255)
  a=np.array(m)
  yy,xx=np.where(a>0);y=int(yy.max());lim=np.max(np.where(a>0,np.arange(a.shape[0])[:,None],-1),axis=0)
  near=np.where(lim>=y-1)[0]
  spans=np.split(near,np.flatnonzero(np.diff(near)>1)+1); run=max(spans,key=len);xl,xr=map(int,(run[0],run[-1]))
  def angle(side):
   # Adjacent outer silhouette tangent at 0.08 BU above the low edge; no light/shadow threshold.
   edge=np.where(a[y-32]>0)[0]
   if not len(edge):return None
   xhigh=int(edge[0 if side=='left' else -1])
   dx=(xhigh-xl) if side=='left' else (xr-xhigh)
   return round(math.degrees(math.atan2(32,dx)),1)
  proof[tag+'-'+label]={'span_px_within_1px_of_lowest_row':len(run),'span_percent_of_bob_width':round(100*len(run)/(xx.max()-xx.min()+1),1),'left_corner_angle_deg':angle('left'),'right_corner_angle_deg':angle('right')}
  out=Image.new('RGB',m.size,'#e0dcd5');out.paste('#23323a',mask=m)
  ImageDraw.Draw(out).line([(xl,y),(xr,y)],fill='#e48847',width=6)
  out=out.crop((40,150,860,750)).resize((520,380),Image.Resampling.LANCZOS)
  can.paste(out,(20+j*546,70+i*388));q.text((25+j*546,78+i*388),tag,fill='#273237',font=f)
can.save(d/'silhouette-private.png')
(d/'silhouette-metrics.json').write_text(json.dumps(proof,indent=2)+'\n')
