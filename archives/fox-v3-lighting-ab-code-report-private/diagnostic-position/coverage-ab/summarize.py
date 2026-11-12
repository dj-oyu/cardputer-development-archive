from pathlib import Path
import numpy as np,json,hashlib
D=Path(__file__).resolve().parent;R=D.parent;S=R.parent/'fox-v3-lighting-ab/score-four-both-002'
def rgb(path):
 u=np.fromfile(path,'<u2').reshape(135,240);return np.stack([(u>>11)/31,((u>>5)&63)/63,(u&31)/31],-1)
def stats(mask,count,center):
 return {'pixels':int(mask.sum()),'centerHit':int((mask&center).sum()),'finiteGridCovered':int((mask&(count==625)).sum()),'finiteGridPartial':int((mask&(count>0)&(count<625)).sum()),'finiteGridOutsideNotGeometryProof':int((mask&(count==0)).sum()),'newHitWithoutCenter':int((mask&~center&(count>0)).sum()),'meanUnweightedSampleFraction':float(count[mask].mean()/625) if mask.any() else None}
result={}
for view in ['front','oblique']:
 a=np.load(D/f'{view}-coverage.npz');count=a['counts'];center=a['center']>0;m=np.load(S/f'{view}-direction-masks.npz');fg=m['sourceForeground'];partial=m['sourcePartialAlphaBoundary'];stable=m['responseStable'];rb=m['responseBright'];rd=m['responseDark'];delta=(rgb(R/'visibility'/f'visible-{view}-direction.u16le')-rgb(R/'visibility'/f'visible-{view}-baseline.u16le'))@np.array([.2126,.7152,.0722]);nb=delta>2/255;nd=delta<-2/255
 strata={'wholeImage':np.ones_like(fg),'sourceForeground':fg,'sourcePartialAlpha':fg&partial,'sourceFullAlpha':fg&~partial,'sourceOutside':~fg,'stableBright':fg&rb,'stableDark':fg&rd,'stableInactive':fg&m['responseInactive'],'uncertain':fg&m['responseUncertain'],'brightFN':fg&stable&rb&~nb,'brightFP':fg&stable&~rb&nb,'darkFN':fg&stable&rd&~nd,'darkFP':fg&stable&~rd&nd,'missingBrightFN':fg&stable&rb&~nb&~center,'missingBrightFNPartialAlpha':fg&stable&rb&~nb&~center&partial,'missingBrightFNFullAlpha':fg&stable&rb&~nb&~center&~partial}
 result[view]={k:stats(v,count,center) for k,v in strata.items()};result[view]['newHitCoordinates']=[list(map(int,z)) for z in np.argwhere(fg&~center&(count>0))];result[view]['remainingMissingCoordinates']=[list(map(int,z)) for z in np.argwhere(fg&(count==0))]
(D/'summary.json').write_text(json.dumps(result,indent=2));print(json.dumps({v:{k:d[k] for k in ['sourceForeground','brightFN','missingBrightFN','uncertain']} for v,d in result.items()},indent=2))
