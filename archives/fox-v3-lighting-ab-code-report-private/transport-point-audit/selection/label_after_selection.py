from pathlib import Path
import hashlib,json,numpy as np
from PIL import Image
D=Path(__file__).resolve().parent;R=D.parent;REF=R/'fox-reference-uncertainty-v3';sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();selection=json.loads((D/'selection.json').read_text());frozen=(D/'selection-frozen.sha256').read_text().split()[0];assert sha(D/'selection.json')==frozen;labels=[];coverage=[];pins={}
for view in ['front','oblique']:
 p=REF/'images'/f'foreground-{view}.png';im=Image.open(p);assert im.mode=='RGBA' and im.size==(240,135);alpha=np.array(im)[...,3];fg=alpha>0;pins[str(p.relative_to(R))]=sha(p)
 rp=REF/'evaluation-masks'/f'{view}-direction-response.npz';rr=np.load(rp);pins[str(rp.relative_to(R))]=sha(rp);assert np.array_equal(rr['foreground'],fg);cc={}
 for case in ['baseline','direction']:
  cp=REF/'evaluation-masks'/f'{view}-{case}-color.npz';cc[case]=np.load(cp);pins[str(cp.relative_to(R))]=sha(cp);assert np.array_equal(cc[case]['foreground'],fg)
 w=R/'fox-v3-lid-transport-point-audit/verified-winners-v2'/f'{view}-baseline.json';assert sha(w)==selection['inputs'][str(w.relative_to(R))];ww=json.loads(w.read_text());covered=np.zeros((135,240),bool)
 for z in ww['points']:covered[z['y'],z['x']]=True
 for z in selection['points']:
  if z['view']!=view:continue
  x,y=z['x'],z['y'];boundary=any(not(0<=x+dx<240 and 0<=y+dy<135) or not covered[y+dy,x+dx] for dx,dy in [(1,0),(-1,0),(0,1),(0,-1)]);response='outside-source-foreground' if not fg[y,x] else 'uncertain' if rr['uncertain'][y,x] else next(k for k in ['bright','dark','inactive'] if rr[k][y,x]);color={c:'outside-source-foreground' if not fg[y,x] else 'stable' if cc[c]['stable'][y,x] else 'uncertain' for c in cc};labels.append({'view':view,'x':x,'y':y,'sourceAlpha8':int(alpha[y,x]),'sourceForeground':bool(fg[y,x]),'sourcePartialAlpha':bool(0<alpha[y,x]<255),'nativeSilhouetteBoundary':boundary,'directionResponseLabel':response,'colorPrecisionLabels':color})
 coverage.append({'view':view,'sourceForeground':int(fg.sum()),'nativeCovered':int(covered.sum()),'sourceNativeOverlap':int((fg&covered).sum()),'sourceForegroundNoNativeHit':int((fg&~covered).sum()),'nativeExtraOutsideSource':int((~fg&covered).sum()),'sourcePartialAlphaTotal':int(((alpha>0)&(alpha<255)).sum()),'sourcePartialAlphaNativeCovered':int(((alpha>0)&(alpha<255)&covered).sum()),'sourcePartialAlphaNoNativeHit':int(((alpha>0)&(alpha<255)&~covered).sum())})
assert sha(D/'selection.json')==frozen;out={'selectionSHA256':frozen,'status':'ANNOTATION_ONLY_NO_RESELECTION','referenceLabelInputHashes':pins,'points':labels,'wholeImageCoverage':coverage,'notPopulationWeighted':True};assert not (D/'post-selection-labels.json').exists();(D/'post-selection-labels.json').write_text(json.dumps(out,indent=2));print(coverage)
