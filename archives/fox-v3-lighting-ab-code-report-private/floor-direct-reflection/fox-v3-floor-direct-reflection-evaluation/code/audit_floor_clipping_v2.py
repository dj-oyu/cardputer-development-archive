from pathlib import Path
import json,sys,numpy as np
from target_samples import load_target_means
D=Path(sys.argv[1]);arrays={};result={}
for arm in ['off','on']:
 rows=json.load(open(D/arm/'COMPLETED.json'))['frames']
 for row in rows:
  if row['reverse']:continue
  a=load_target_means(D/arm/row['prefix'],['linearRGB'])['linearRGB'];key=row['view']+'-'+row['case'];arrays[(arm,key)]=a;result[arm+'-'+key]={'AAOnlyTargetPixels':len(a),'aboveOnePixels':int((a>1).any(axis=1).sum()),'aboveOneChannels':int((a>1).sum()),'maxMeanHDR':float(a.max())}
ambient={}
for view in ['front','oblique']:
 old=arrays['off',view+'-ambient']-arrays['off',view+'-baseline'];new=arrays['on',view+'-ambient']-arrays['on',view+'-baseline'];ambient[view]={'maxAbsDeltaDifference':float(abs(new-old).max()),'scope':'Fixed AA target averaged HDR; unchanged new-floor ambient component plus unchanged old linear response up to rounding. Display remains nonlinear; no claim about unobserved non-target HDR.'}
(D/'FLOOR_CLIPPING_SUMMARY_V2.json').write_text(json.dumps({'version':'xy-sample-keyed-v2','supersedes':'v1 adjacent-four-row grouping invalid for sample-major logs','scope':'Only AA target four-HDR mean. >1 denotes legacy sRGB clamp, not AgX domain or whole-frame clipping. No response mask selection or fitting.','frames':result,'ambientRawResponse':ambient},indent=2)+'\n');print('CLIPPING_SUMMARY_COMPLETE')
