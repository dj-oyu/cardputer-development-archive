from pathlib import Path
import json,sys,numpy as np
D=Path(sys.argv[1]);arrays={};result={}
for arm in ['off','on']:
 rows=json.load(open(D/arm/'COMPLETED.json'))['frames']
 for row in rows:
  if row['reverse']:continue
  values=[json.loads(x)['linearRGB'] for x in open(str(D/arm/row['prefix'])+'.samples.jsonl')];a=np.asarray(values).reshape(-1,4,3).mean(axis=1);key=row['view']+'-'+row['case'];arrays[(arm,key)]=a;result[arm+'-'+key]={'AAOnlyTargetPixels':len(a),'aboveOnePixels':int((a>1).any(axis=1).sum()),'aboveOneChannels':int((a>1).sum()),'maxMeanHDR':float(a.max())}
ambient={}
for view in ['front','oblique']:
 old=arrays['off',view+'-ambient']-arrays['off',view+'-baseline'];new=arrays['on',view+'-ambient']-arrays['on',view+'-baseline'];ambient[view]={'maxAbsDeltaDifference':float(abs(new-old).max()),'scope':'Fixed AA target averaged HDR; unchanged new-floor ambient component plus unchanged old linear response up to rounding. Display remains nonlinear; no claim about unobserved non-target HDR.'}
(D/'FLOOR_CLIPPING_SUMMARY.json').write_text(json.dumps({'scope':'Only AA target four-HDR mean. >1 denotes legacy sRGB clamp, not AgX domain or whole-frame clipping. No response mask selection or fitting.','frames':result,'ambientRawResponse':ambient},indent=2)+'\n');print('CLIPPING_SUMMARY_COMPLETE')
