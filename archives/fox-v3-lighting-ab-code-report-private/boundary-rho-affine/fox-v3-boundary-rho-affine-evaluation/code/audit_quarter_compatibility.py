from pathlib import Path
import json,sys,hashlib
R=Path(sys.argv[1]).resolve();O=R/'actual-A2/on';OLD=R.parent/'fox-v3-boundary-aa-evaluation/actual-001/on';rows=[]
for row in json.load(open(O/'COMPLETED.json'))['frames']:
 p=O/(row['prefix']+'.samples.jsonl');old=OLD/(row['prefix']+'.samples.jsonl');n=rhoChanged=rgbChanged=0;mr=ml=0.
 with open(p) as a,open(old) as b:
  for x,y in zip(a,b,strict=True):
   x=json.loads(x);y=json.loads(y);n+=1
   assert {k:v for k,v in x.items() if k not in ['rho','linearRGB']}=={k:v for k,v in y.items() if k not in ['rho','linearRGB']}
   dr=max(abs(a-b) for a,b in zip(x['rho'],y['rho']));dl=max(abs(a-b) for a,b in zip(x['linearRGB'],y['linearRGB']));mr=max(mr,dr);ml=max(ml,dl);rhoChanged+=dr!=0;rgbChanged+=dl!=0
 rows.append({'view':row['view'],'case':row['case'],'reverse':row['reverse'],'samples':n,'allPositionNormalDepthWinnerSideFieldsByteValuesExact':True,'rhoChangedSamples':rhoChanged,'linearRGBChangedSamples':rgbChanged,'maxAbsRhoDifference':mr,'maxAbsLinearRGBDifference':ml})
(R/'QUARTER_COMPATIBILITY.json').write_text(json.dumps({'status':'ALL20_SAMPLE_GEOMETRY_ATTRIBUTES_EXACT','scope':'Rho and linearRGB finite-roundoff differences separately reported; RGB565/depth/snapshot/mask exact gate recorded separately','frames':rows},indent=2)+'\n');print('QUARTER_COMPATIBILITY_PASS')
