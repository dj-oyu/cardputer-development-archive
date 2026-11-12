"""Descriptive fixed-AA-target component means; not full-frame attribution."""
from pathlib import Path
import json,sys,numpy as np
from target_samples import load_target_means
D=Path(sys.argv[1]);O=D/'on';rows=json.load(open(O/'COMPLETED.json'))['frames'];names=['directRGB','worldRGB','bounceRGB','groundLeRGB','floorReflectedRGB'];arrays={};summary={};weights=np.array([.2126,.7152,.0722])
for row in rows:
 if row['reverse']:continue
 x=load_target_means(O/row['prefix'],names);key=row['view']+'-'+row['case'];arrays[key]=x;summary[key]={n:{'meanRGB':v.mean(axis=0).tolist(),'meanY':float((v@weights).mean()),'maxY':float((v@weights).max()),'positiveYPixels':int(((v@weights)>0).sum()),'domainPixels':len(v)} for n,v in x.items()}
deltas={}
for view in ['front','oblique']:
 for case in ['direction','intensity','ambient','albedo']:
  key=view+'-'+case;deltas[key]={}
  for n in names:
   d=arrays[key][n]-arrays[view+'-baseline'][n];dy=d@weights;deltas[key][n]={'meanDeltaRGB':d.mean(axis=0).tolist(),'meanDeltaY':float(dy.mean()),'meanAbsDeltaY':float(abs(dy).mean()),'maxAbsDeltaY':float(abs(dy).max()),'rawPositive':int((dy>0).sum()),'rawNegative':int((dy<0).sum()),'exactZero':int((dy==0).sum())}
result={'version':'xy-sample-keyed-v2','supersedes':'v1 incorrectly grouped adjacent sample-major rows; means/maps recomputed from explicit keys','scope':'Fixed AA targets only, four true quarter samples averaged in linear HDR including black nohit. Descriptive, not whole-frame, reference correctness or source GI attribution. No linear use of display thresholds.','components':summary,'conditionDeltas':deltas};(D/'FLOOR_COMPONENT_SUMMARY_V2.json').write_text(json.dumps(result,indent=2)+'\n');print('FIXED_TARGET_COMPONENT_SUMMARY_COMPLETE')
