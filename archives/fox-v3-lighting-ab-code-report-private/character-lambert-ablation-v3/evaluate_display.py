"""Fixed reference domains, two-seed rich/Lambert PNG8 diagnostics only."""
from pathlib import Path
import sys,json,hashlib,numpy as np
from PIL import Image
R=Path(__file__).resolve().parent;W=R.parent;REF=W/'fox-reference-uncertainty-v3';ON=W/'fox-v3-position-diagnostic/pass-decomposition';OFF=R/'run-001'
sys.dont_write_bytecode=True;sys.path.insert(0,str(REF/'code'));import evaluator as E
sys.path.insert(0,str(W/'fox-v3-position-diagnostic/rich-oracle'));import oracle_response as OR
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def save(p,v):p.write_text(json.dumps(v,indent=2,allow_nan=False)+'\n')
D=Path(sys.argv[1]).resolve();assert D.parent==R and not D.exists();D.mkdir()
cfg=json.loads((REF/'input/config.json').read_text());ref=json.loads((REF/'render-manifest.json').read_text());refs={(x['seed'],x['view'],x['case']):x for x in ref['images']}
lookup={a:{(x['seed'],x['view'],x['case']):x for x in json.loads((root/'COMPLETED.json').read_text())['images']} for a,root in [('rich',ON),('lambert',OFF)]}
assert len(lookup['rich'])==len(lookup['lambert'])==8
assert json.loads((OFF/'COMPLETED.json').read_text())['onControlPassed']
pins={}
def pin(p):pins[str(p)]=sha(p)
def image(p,h):
 assert sha(p)==h;pin(p);im=Image.open(p);assert im.size==(240,135) and im.mode=='RGBA';return np.array(im)[...,:3]
for p in [Path(__file__),REF/'code/evaluator.py',W/'fox-v3-position-diagnostic/rich-oracle/oracle_response.py',REF/'input/config.json',REF/'render-manifest.json',ON/'COMPLETED.json',OFF/'COMPLETED.json']:pin(p)
result={};summary={};masks={}
for view in ['front','oblique']:
 rr={c:np.stack([image(REF/refs[(seed,view,c)]['file'],refs[(seed,view,c)]['sha256']) for seed in cfg['seeds']]) for c in ['baseline','direction']}
 f=ref['foreground'][view];assert sha(REF/f['file'])==f['sha256'];pin(REF/f['file']);fg=np.array(Image.open(REF/f['file']))[...,3]>0
 result[view]={};summary[view]={}
 for seed in [11,29]:
  result[view][str(seed)]={};summary[view][str(seed)]={}
  for arm,root in [('rich',ON),('lambert',OFF)]:
   ims={c:image(root/lookup[arm][(seed,view,c)]['combinedPNG'],lookup[arm][(seed,view,c)]['combinedPNGSHA256']) for c in rr}
   response,st=OR.evaluate(rr['baseline'],rr['direction'],fg,ims['baseline'],ims['direction']);color={c:E.evaluate_color_png8(rr[c],fg,ims[c]/255)[0] for c in rr}
   result[view][str(seed)][arm]={'response':response,'color':color,'status':'AUXILIARY_BLENDER_NOT_NATIVE_ACCEPTANCE'}
   m=response['candidateScores']['stableSubset'];summary[view][str(seed)][arm]={'brightIoU':m['brightening']['IoU'],'darkIoU':m['darkening']['IoU'],'brightFP':m['brightening']['candidatePixels']-m['brightening']['intersection'],'brightFN':m['brightening']['referencePixels']-m['brightening']['intersection'],'deltaRGBRMSE':m['deltaRGBRMSE'],'responseMagnitudeAgreementPercent':m['responseMagnitudeAgreementPercent'],'directionAgreementPercent':m['directionAgreementPercent'],'signedCorrelation':m['signedCorrelation'],'RGB':{c:color[c]['candidateScores']['stableSubset']['rgbAgreementPercent'] for c in rr},'uncertainPixels':int((fg&st['uncertain']).sum())}
   if view not in masks:masks[view]=st
   else:assert all(np.array_equal(masks[view][k],st[k]) for k in ['stable','uncertain','bright','dark'])
assert all(sha(Path(p))==h for p,h in pins.items())
save(D/'input-hashes.json',pins);save(D/'evaluation.json',E.descriptive_only(result));save(D/'summary.json',summary);save(D/'scope.json',{'twoSeedsDescriptiveOnly':True,'noNewStabilityMasks':True,'formalV3ReferenceUnchanged':True,'thresholdIntegerPNG8Numerator':20000,'thresholdDenominator':2550000,'nativeAcceptance':False,'candidateRawNeverReceivesReferencePixels':True});print(json.dumps(summary))
