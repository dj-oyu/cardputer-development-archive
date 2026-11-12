"""Geometry-only selection and bbox work estimate. No RGB/reference/error input."""
from pathlib import Path
import json,hashlib,struct,math,numpy as np
R=Path(__file__).resolve().parent;W=R.parent;B=W/'fox-v3-lid-evaluation/actual-lid8-v2';V=W/'fox-v3-lid-transport-point-audit/verified-winners-v2';pins={}
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def pin(p):pins[str(p)]=sha(p);return p
out={}
for view in ['front','oblique']:
 w=json.loads(pin(V/f'{view}-baseline.json').read_text());ids=np.full((135,240),-1,np.int16)
 # Read only geometric source identities at actual center winners, never RGB/rho/Ps for selection.
 for p in w['points']:ids[p['y'],p['x']]=int(p['sourceObjectId'])
 padded=np.pad(ids,1,constant_values=-1);target=np.zeros_like(ids,bool)
 for dy,dx in [(-1,0),(0,-1),(0,1),(1,0)]:target|=ids!=padded[1+dy:136+dy,1+dx:241+dx]
 raw=pin(W/f'fox-v3-lid-evaluation/canonical-proof-lid8/private-snapshots/{view}-baseline.canonical').read_bytes();tri=[];at=416
 while at<len(raw):
  n,t,mode,res=raw[at:at+4];assert mode==4;size=struct.unpack_from('<H',raw,at+10)[0];v=[struct.unpack_from('<ff',raw,at+12+56*j) for j in range(n)];ix=at+12+56*n
  for j in range(t):tri.append([v[k] for k in raw[ix+3*j:ix+3*j+3]])
  at+=size
 assert len(tri)==1564
 def box(t,dx,dy):
  l=max(0,math.ceil(min(v[0] for v in t)-dx));r=min(239,math.floor(max(v[0] for v in t)-dx));a=max(0,math.ceil(min(v[1] for v in t)-dy));b=min(134,math.floor(max(v[1] for v in t)-dy));return l,r,a,b
 center=0;arms=[]
 for t in tri:
  l,r,a,b=box(t,0,0);center+=max(0,r-l+1)*max(0,b-a+1)
 for dx,dy in [(-0.28820947825813636, -0.28820947825813636), (0.28820947825813636, -0.28820947825813636), (-0.28820947825813636, 0.28820947825813636), (0.28820947825813636, 0.28820947825813636)]:
  bbox=selected=bands=0
  for t in tri:
   l,r,a,b=box(t,dx,dy);bbox+=max(0,r-l+1)*max(0,b-a+1)
   if l<=r and a<=b:bands+=b//8-a//8+1
   if l<=r and a<=b:selected+=int(target[a:b+1,l:r+1].sum())
  arms.append({'dx':dx,'dy':dy,'bboxVisits':bbox,'nonemptyBandBoxes':bands,'targetBBoxVisits':selected,'conservativeWork':bbox+49*selected+1564})
 meta=json.loads(pin(B/f'native-{view}-baseline.json').read_text());assert center*49==meta['work']
 total=meta['work']+4*32400+sum(x['conservativeWork'] for x in arms)
 out[view]={'targets':int(target.sum()),'coveredTargets':int((target&(ids>=0)).sum()),'nohitTargets':int((target&(ids<0)).sum()),'centerBboxVisits':center,'centerReservedWork':meta['work'],'neighborComparisonWork':129600,'arms':arms,'cumulativeReservedWork':total,'workLimit':8000000,'workFits':total<=8000000,'upperExtraShadeCalls':4*int(target.sum()),'upperExtraDirectRays':48*4*int(target.sum()),'upperExtraTransportRays':1040*4*int(target.sum()),'centerActualDirect':[meta[k] for k in ['visibilityRays','visibilityNodeVisits','visibilityTriangleTests']],'centerActualTransport':[meta[k] for k in ['transportRays','transportNodeVisits','transportTriangleTests']],'centerShadeUpdates':meta['shadeUpdates']}
assert all(sha(Path(p))==h for p,h in pins.items())
(R/'estimate.json').write_text(json.dumps({'geometryOnly':True,'views':out,'inputPins':pins},indent=2)+'\n');print(json.dumps(out,indent=2))
