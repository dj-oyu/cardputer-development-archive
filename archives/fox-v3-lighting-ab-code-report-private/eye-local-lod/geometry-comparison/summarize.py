from pathlib import Path
import json,hashlib
D=Path(__file__).resolve().parent;out={};roles=['Eye socket','Eye white','Amber iris','Pupil','Eye glint','Eye glint small','Upper eyelid']
for arm in ['stage2','eyeA','eyeB']:
 d=json.loads((D/(arm+'-geometry.json')).read_text());result=[]
 for v in d['views']:
  rr={}
  for role in roles:
   name=f"{role} {v['side']}";ss=[s for s in v['samples'] if s['source']['object']==name];loss=[s for s in ss if s['coarse']['object']!=name];absent=sum(s['source']['sameObjectCoarseIntersection']['distance'] is None for s in loss);extra=sum(s['source']['object']!=name and s['coarse']['object']==name for s in v['samples']);same=len(ss)-len(loss);den=len(ss)+extra
   rr[role]={'sourceVisible':len(ss),'sameWinner':same,'lost':len(loss),'coarseRayMiss':absent,'coarseRayPresentButOtherNearer':len(loss)-absent,'extraWinner':extra,'diagnosticIoU':same/den if den else None}
  result.append({'view':v['view'],'side':v['side'],'roles':rr,'allObjectWinnerMismatches':sum(s['source']['object']!=s['coarse']['object'] for s in v['samples']),'transitions':v['transitionCounts']})
 out[arm]=result
old=json.loads((D.parent/'geometry.json').read_text());new=json.loads((D/'stage2-geometry.json').read_text());assert old['views']==new['views'][:4];out['stage2OriginalFourViewsExact']=True
(D/'summary.json').write_text(json.dumps(out,indent=2))
for i,v in enumerate(out['stage2']):
 print(v['view'],v['side'])
 for role in ['Eye white','Amber iris','Pupil','Upper eyelid']:
  print(role, [(a, out[a][i]['roles'][role]['sameWinner'],out[a][i]['roles'][role]['lost'],out[a][i]['roles'][role]['extraWinner'],round(out[a][i]['roles'][role]['diagnosticIoU'],3)) for a in ['stage2','eyeA','eyeB']])
