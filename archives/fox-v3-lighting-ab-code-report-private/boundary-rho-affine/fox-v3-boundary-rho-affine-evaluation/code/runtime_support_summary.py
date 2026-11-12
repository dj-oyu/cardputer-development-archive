from pathlib import Path
import json,sys
r=Path(sys.argv[1]).resolve();out={}
for arm in ['A','B']:
 d=r/f'actual-{arm}2';rows=json.load(open(d/'on/COMPLETED.json'))['frames'];metrics={}
 for k in ['transportRays','transportNodeVisits','transportTriangleTests','visibilityRays','visibilityNodeVisits','visibilityTriangleTests']:metrics[k]=max(x['metadata'][k] for x in rows)
 metrics['all20Complete']=True;metrics['maxObservedStages']=max(json.load(open(str(d/'on'/x['prefix'])+'.aa.json'))['observedTotal'] for x in rows);metrics['support']=json.load(open(d/'on/score-v3/support-diagnostic.json'));out[arm]=metrics
(r/'RUNTIME_SUPPORT_SUMMARY.json').write_text(json.dumps(out,indent=2)+'\n')
