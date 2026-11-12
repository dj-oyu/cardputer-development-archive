from pathlib import Path
import json,hashlib,numpy as np
from PIL import Image
R=Path(__file__).resolve().parent.parent;D=Path(__file__).resolve().parent;A=R/'fox-v3-boundary-aa-evaluation/actual-001';REF=R/'fox-reference-uncertainty-v3';pins={}
def pin(p):
 pins[str(p.relative_to(R))]=hashlib.sha256(p.read_bytes()).hexdigest();return p
freeze=pin(A/'ACTUAL_OUTPUT_FREEZE.json');assert pins[str(freeze.relative_to(R))]==(R/'fox-v3-boundary-aa-evaluation/OUTPUT_PIN.txt').read_text().strip();f=json.loads(freeze.read_text())['files']
def admitted(p):
 pin(p)
 if str(p.relative_to(A)) in f:assert pins[str(p.relative_to(R))]==f[str(p.relative_to(A))]
 else:
  assert p.relative_to(A).parts[0]=='off'
  original=pin(R/'fox-v3-lid-evaluation/actual-lid8-v2'/p.name);assert p.read_bytes()==original.read_bytes()
 return p
comp=json.loads(pin(R/'fox-v3-lid-evaluation/actual-lid8-v2/compiled/model-baseline/compile.json').read_text());materials={m['id']:m for m in comp['materialTrace']}
def rgb(arm,view,case):
 a=np.fromfile(admitted(A/arm/'private-partial'/f'native-{view}-{case}.u16le'),'<u2');assert a.size==32400;a=a.reshape(135,240);return np.stack([((a>>11)&31)/31,((a>>5)&63)/63,(a&31)/31],-1)
results={}
for view in ['front','oblique']:
 w=json.loads(pin(R/'fox-v3-lid-transport-point-audit/verified-winners-v2'/f'{view}-baseline.json').read_text());obj=np.full((135,240),'NO_CENTER_NATIVE',object);mat=obj.copy();sid=np.full((135,240),-1,int)
 for p in w['points']:
  x,y=p['x'],p['y'];obj[y,x]=p['sourceObjectName'];mat[y,x]=comp['parts'][p['node']-1]['materialId'];sid[y,x]=p['sourceObjectId']
 pad=np.pad(sid,1,constant_values=-1);target=np.logical_or.reduce([sid!=pad[1+dy:136+dy,1+dx:241+dx] for dx,dy in [(1,0),(-1,0),(0,1),(0,-1)]]);actual=np.fromfile(admitted(A/'on/private-partial'/f'native-{view}-baseline.targets.u8'),'u1').reshape(135,240);assert np.array_equal(target,actual)
 alpha=np.asarray(Image.open(pin(REF/'images'/f'foreground-{view}.png')))[...,3];fg=alpha>0;covered=sid>=0
 domains={'fullForeground':fg,'opaqueAlpha':alpha==255,'partialAlpha':(alpha>0)&(alpha<255),'centerCovered':fg&covered,'centerMissing':fg&~covered,'coveredBoundary':fg&covered&target,'coveredInterior':fg&covered&~target,'missingBoundary':fg&~covered&target,'missingNonTarget':fg&~covered&~target,'outsideSource':~fg}
 for tag,a in [('opaque',alpha==255),('partial',(alpha>0)&(alpha<255))]:
  for t,m in [('coveredBoundary',covered&target),('coveredInterior',covered&~target),('centerMissing',~covered)]:domains[tag+'/'+t]=a&m
 for name in sorted(set(obj.flat)):domains['object/'+name]=fg&(obj==name)
 for name in sorted(set(mat.flat)):
  domains['material/'+name]=fg&(mat==name)
  for t,m in [('partial',alpha<255),('opaqueInterior',(alpha==255)&covered&~target),('opaqueBoundary',(alpha==255)&covered&target)]:domains['material/'+name+'/'+t]=fg&(mat==name)&m
 percase={}
 for case in ['direction','intensity','ambient','albedo']:
  ref=np.load(pin(REF/'evaluation-masks'/f'{view}-{case}-response.npz'));assert np.array_equal(ref['foreground'],fg);labels=np.full(fg.shape,'outside',object)
  for k in ['bright','dark','inactive','uncertain']:labels[fg&ref[k]]=k
  arms={}
  for arm in ['off','on']:
   delta=(rgb(arm,view,case)-rgb(arm,view,'baseline'))@np.array([.2126,.7152,.0722]);cl=np.where(delta>2/255,'bright',np.where(delta< -2/255,'dark','inactive'));data={}
   for name,m in domains.items():
    conf={a:{b:int((m&(labels==a)&(cl==b)).sum()) for b in ['bright','dark','inactive']} for a in ['bright','dark','inactive','uncertain','outside']};active=m&(ref['bright']|ref['dark'])&fg;inactive=conf['bright']['inactive']+conf['dark']['inactive'];reverse=conf['bright']['dark']+conf['dark']['bright'];stable=m&ref['stable']&fg
    data[name]={'pixels':int(m.sum()),'confusion':conf,'activeToInactive':inactive,'reverse':reverse,'brightFN':conf['bright']['dark']+conf['bright']['inactive'],'darkFN':conf['dark']['bright']+conf['dark']['inactive'],'brightFP':conf['dark']['bright']+conf['inactive']['bright'],'darkFP':conf['bright']['dark']+conf['inactive']['dark'],'inactiveFP':conf['inactive']['bright']+conf['inactive']['dark'],'stableActive':int(active.sum()),'stableLumaAbsErrorSum':float(np.abs(delta[stable]-ref['mean'][stable]).sum()),'activeReferenceAbsResponseSum':float(np.abs(ref['mean'][active]).sum()),'activeNativeAbsResponseSum':float(np.abs(delta[active]).sum())}
   assert data['fullForeground']['pixels']==sum(d['pixels'] for k,d in data.items() if k.startswith('object/'));arms[arm]=data
  percase[case]=arms
 results[view]=percase
out={'contract':'v32 fixed reference threshold, all eight responses. Native center winner material/object attribution only, not AA filtered receiver. NO_CENTER_NATIVE never imputed. Alpha partial=1..254 opaque=255. No image-dependent bins. Error sums descriptive not new acceptance metrics.','materials':materials,'views':results,'pins':pins};(D/'analysis.json').write_text(json.dumps(out,indent=2));print('DONE',len(pins))
for v in results:
 for tag in ['fullForeground','coveredBoundary','coveredInterior','centerMissing','opaqueAlpha','partialAlpha']:
  a,b=[results[v]['direction'][arm][tag] for arm in ['off','on']];print(v,tag,'inactive',a['activeToInactive'],b['activeToInactive'],'reverse',a['reverse'],b['reverse'],'inactiveFP',a['inactiveFP'],b['inactiveFP'])
