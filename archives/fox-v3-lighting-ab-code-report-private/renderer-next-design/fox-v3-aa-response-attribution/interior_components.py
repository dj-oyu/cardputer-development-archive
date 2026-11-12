from pathlib import Path
import json,numpy as np,hashlib
from PIL import Image
R=Path(__file__).resolve().parent.parent;D=Path(__file__).resolve().parent;A=R/'fox-v3-boundary-aa-evaluation/actual-001';out={};pins={}
for v in ['front','oblique']:
 paths=[R/'fox-v3-lid-transport-point-audit/verified-winners-v2'/f'{v}-{c}.json' for c in ['baseline','direction']];ww=[json.loads(p.read_text()) for p in paths]
 for p in paths:pins[str(p.relative_to(R))]=hashlib.sha256(p.read_bytes()).hexdigest()
 maps=[{(p['x'],p['y']):p for p in w['points']} for w in ww];m=np.load(R/'fox-reference-uncertainty-v3/evaluation-masks'/f'{v}-direction-response.npz');alpha=np.asarray(Image.open(R/'fox-reference-uncertainty-v3/images'/f'foreground-{v}.png'))[...,3];target=np.fromfile(A/'on/private-partial'/f'native-{v}-baseline.targets.u8','u1').reshape(135,240)
 b,c=[np.fromfile(A/'on/private-partial'/f'native-{v}-{case}.u16le','<u2').reshape(135,240) for case in ['baseline','direction']]
 def rgb(a):return np.stack([((a>>11)&31)/31,((a>>5)&63)/63,(a&31)/31],-1)
 dy=(rgb(c)-rgb(b))@np.array([.2126,.7152,.0722]);selected=m['foreground']&(m['bright']|m['dark'])&(abs(dy)<=2/255)&(~target.astype(bool));rows=[]
 for xy,p in maps[0].items():
  x,y=xy
  if not selected[y,x]:continue
  q=maps[1][xy];assert all(p[k]==q[k] for k in ['P','Ns','rho','node','face','physicalSide','sourceObjectId']);rows.append({'opaque':alpha[y,x]==255,'object':p['sourceObjectName'],'directDeltaZero':p['direct']==q['direct'],'bounceDeltaZero':p['bounce']==q['bounce'],'worldDeltaZero':p['world']==q['world'],'groundDeltaZero':p['ground']==q['ground'],'combinedDeltaZero':p['rgb']==q['rgb'],'bothFrameAnyChannelAbove1':max(p['rgb'])>1 and max(q['rgb'])>1,'bothFrameAllChannelsAbove1':min(p['rgb'])>1 and min(q['rgb'])>1,'same565':b[y,x]==c[y,x]})
 def count(rs):return {'n':len(rs),**{k:sum(bool(r[k]) for r in rs) for k in ['directDeltaZero','bounceDeltaZero','worldDeltaZero','groundDeltaZero','combinedDeltaZero','bothFrameAnyChannelAbove1','bothFrameAllChannelsAbove1','same565']}}
 out[v]={'allInteriorInactive':count(rows),'opaqueInteriorInactive':count([r for r in rows if r['opaque']]),'byObject':{n:count([r for r in rows if r['object']==n]) for n in sorted(set(r['object'] for r in rows))}}
(D/'interior-components.json').write_text(json.dumps({'scope':'exact equality and fixed physical/display endpoint counts only; no new bin/threshold; target pixels excluded from this diagnostic because center components do not represent AA mix, but retained in main census','views':out,'pins':pins},indent=2));print(json.dumps({v:{k:z for k,z in d.items() if k!='byObject'} for v,d in out.items()},indent=2))
