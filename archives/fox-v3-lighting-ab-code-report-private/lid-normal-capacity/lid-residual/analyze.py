from pathlib import Path
import json,collections
D=Path(__file__).resolve().parent;A=D.parent/'ab';old=json.loads((A/'stage2-geometry.json').read_text());new=json.loads((A/'eyeB-geometry.json').read_text());rows=[]
for o,n in zip(old['views'],new['views']):
 side=n['side'];row={'view':n['view'],'side':side,'arms':{}}
 for key,v in [('stage2',o),('eyeB',n)]:
  result={}
  for role in ['Upper eyelid','Eye socket']:
   name=f'{role} {side}';ss=v['samples'];loss=[s for s in ss if s['source']['object']==name and s['coarse']['object']!=name];present=[s for s in loss if s['source']['sameObjectCoarseIntersection']['distance'] is not None];extra=[s for s in ss if s['source']['object']!=name and s['coarse']['object']==name];result[role]={'sourceVisible':sum(s['source']['object']==name for s in ss),'same':sum(s['source']['object']==name and s['coarse']['object']==name for s in ss),'lost':len(loss),'surfaceMiss':len(loss)-len(present),'presentButHiddenBy':dict(collections.Counter(str(s['coarse']['object']) for s in present)),'extra':len(extra),'extraOriginally':dict(collections.Counter(str(s['source']['object']) for s in extra))}
  row['arms'][key]=result
 sock=f'Eye socket {side}';row['newSocketWinnersFrom']=dict(collections.Counter(str(a['coarse']['object']) for a,b in zip(o['samples'],n['samples']) if a['coarse']['object']!=sock and b['coarse']['object']==sock));rows.append(row)
summary={'rows':rows,'BTotalLidLost':sum(r['arms']['eyeB']['Upper eyelid']['lost'] for r in rows),'BTotalLidSurfaceMiss':sum(r['arms']['eyeB']['Upper eyelid']['surfaceMiss'] for r in rows)}
summary['socketExtraBySide']={str(side):{a:sum(r['arms'][a]['Eye socket']['extra'] for r in rows if r['side']==side) for a in ['stage2','eyeB']} for side in [-1,1]};(D/'summary.json').write_text(json.dumps(summary,indent=2));print({k:v for k,v in summary.items() if k!='rows'})
