"""Fixed seed11 actual-lid8 rich proxy; descriptive only, no fitted parameters."""
from pathlib import Path
import sys,json,hashlib,importlib.util
import numpy as np
from PIL import Image
sys.dont_write_bytecode=True
R=Path(__file__).resolve().parent;W=R.parent;RUN=R/'run-001';REF=W/'fox-reference-uncertainty-v3';N=W/'fox-v3-lid-evaluation/actual-lid8-v2'
sys.path[:0]=[str(REF/'code'),str(W/'fox-v3-position-diagnostic/rich-oracle'),str(R/'code')]
import evaluator as E,oracle_response as OR,exr_io as X
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
save=lambda p,v:p.write_text(json.dumps(v,indent=2,allow_nan=False)+'\n')
D=Path(sys.argv[1]).resolve();assert D.parent==R and not D.exists();D.mkdir()
pins={}
def pin(p,h=None):
 p=Path(p);v=sha(p);assert h is None or h==v; pins[str(p)]=v;return p
def load(p):return json.loads(pin(p).read_text())
def png(p,h=None):
 im=Image.open(pin(p,h));assert im.mode=='RGBA' and im.size==(240,135);return np.array(im)[...,:3]
def native(view,case):
 a=np.fromfile(pin(N/f'native-{view}-{case}.u16le'),dtype='<u2').reshape(135,240)
 return np.stack([(a>>11)/31,((a>>5)&63)/63,(a&31)/31],-1)
def stats(a,m):
 v=a[m];y=v@E.LUMA
 return {'pixels':int(m.sum()),'meanRGB':v.mean(0).tolist(),'meanY':float(y.mean()),'meanAbsY':float(abs(y).mean()),'RMSRGB':float(np.sqrt(np.mean(v*v))),'minRGB':v.min(0).tolist(),'maxRGB':v.max(0).tolist(),'negativeChannelPixels':int((v<0).any(1).sum())} if len(v) else {'pixels':0}
def extract(ch):
 rgb=lambda n:np.stack([ch['ViewLayer.'+n+'.'+c] for c in 'RGB'],-1).astype(np.float64)
 d={'Combined':rgb('Combined'),'DirectDiffuse':rgb('DiffDir')*rgb('DiffCol'),'IndirectDiffuse':rgb('DiffInd')*rgb('DiffCol'),'DirectGloss':rgb('GlossDir')*rgb('GlossCol'),'IndirectGloss':rgb('GlossInd')*rgb('GlossCol'),'Emission':rgb('Emit'),'Environment':rgb('Env'),'Transmission':(rgb('TransDir')+rgb('TransInd'))*rgb('TransCol'),'Volume':rgb('VolumeDir')+rgb('VolumeInd')}
 d['R']=d['Combined']-sum(a for k,a in d.items() if k!='Combined');assert all(np.isfinite(a).all() for a in d.values());return d
for p in [Path(__file__),Path(E.__file__),Path(OR.__file__),Path(X.__file__)]:pin(p)
manifest=load(RUN/'COMPLETED.json');control=load(RUN/'ORIGINAL_CONTROL_PASS.json');assert manifest['inputsUnchanged'] and manifest['allOriginalControlsPassed'] and len(manifest['images'])==4
rows={(r['view'],r['case']):r for r in manifest['images']};controls={(r['view'],r['case']):r for r in control['controls']}
ref=load(REF/'render-manifest.json');cfg=load(REF/'input/config.json');refs={(r['seed'],r['view'],r['case']):r for r in ref['images']}
evaluation={};passes={};brief={};mixing={}
for view in ['front','oblique']:
 f=ref['foreground'][view];fg=np.array(Image.open(pin(REF/f['file'],f['sha256'])))[...,3]>0
 rr={c:np.stack([png(REF/refs[(s,view,c)]['file'],refs[(s,view,c)]['sha256']) for s in cfg['seeds']]) for c in ['baseline','direction']}
 ims={};pp={};depths=[]
 for c in rr:
  row=rows[(view,c)];im=png(RUN/row['PNG'],row['PNGSHA256']);old=controls[(view,c)]
  ims[c]={'proxy':im,'sourceSeed11':png(RUN/old['PNG'],old['PNGSHA256']),'nativeLegacy':native(view,c)}
  pp[c]=extract(X.read(pin(RUN/row['EXR'],row['EXRSHA256'])));pin(RUN/row['audit'],row['auditSHA256'])
  dep=np.fromfile(pin(N/f'native-{view}-{c}.f32le'),dtype='<f4').reshape(135,240);assert np.all(np.isfinite(dep)|np.isneginf(dep));depths.append(np.isfinite(dep))
 assert np.array_equal(*depths)
 domains={'fullFrame':np.ones_like(fg),'originalForeground':fg,'commonNativeForeground':fg&depths[0],'originalForegroundMissingNative':fg&~depths[0],'outsideOriginalForeground':~fg}
 evaluation[view]={};brief[view]={};passes[view]={}
 for arm in ['proxy','sourceSeed11','nativeLegacy']:
  a,b=ims['baseline'][arm],ims['direction'][arm]
  response,st=E.evaluate_response_png8(rr['baseline'],rr['direction'],fg,a,b) if arm=='nativeLegacy' else OR.evaluate(rr['baseline'],rr['direction'],fg,a,b)
  color={c:E.evaluate_color_png8(rr[c],fg,ims[c][arm] if arm=='nativeLegacy' else ims[c][arm]/255)[0] for c in rr}
  evaluation[view][arm]={'response':response,'color':color}
  s=response['candidateScores']['stableSubset'];brief[view][arm]={'brightIoU':s['brightening']['IoU'],'darkIoU':s['darkening']['IoU'],'brightFP':s['brightening']['candidatePixels']-s['brightening']['intersection'],'brightFN':s['brightening']['referencePixels']-s['brightening']['intersection'],'deltaRGBRMSE':s['deltaRGBRMSE'],'colorStable':{c:color[c]['candidateScores']['stableSubset']['rgbAgreementPercent'] for c in rr},'uncertainForeground':int((fg&st['uncertain']).sum())}
  # Explicit inactive/unknown census; same exact PNG numerator or native float contract.
  delta=(b-a)@E.LUMA if arm=='nativeLegacy' else ((b.astype(np.int64)-a.astype(np.int64))@OR.W)/OR.DEN
  cls=np.where(delta>E.T,1,np.where(delta<-E.T,-1,0))
  evaluation[view][arm]['classCensus']={name:{'pixels':int(mask.sum()),'bright':int((mask&(cls==1)).sum()),'inactive':int((mask&(cls==0)).sum()),'dark':int((mask&(cls==-1)).sum())} for name,mask in {'stableBright':fg&st['bright'],'stableDark':fg&st['dark'],'stableInactive':fg&st['inactive'],'uncertain':fg&st['uncertain'],'fullForeground':fg,'missingNativeForeground':fg&~depths[0]}.items()}
 for c in rr:
  passes[view][c]={domain:{k:stats(a,m) for k,a in pp[c].items()} for domain,m in domains.items()}
  residual=abs(pp[c]['R']);bound=2e-5+5e-6*abs(pp[c]['Combined'])
  passes[view][c]['residualCheck']={'maxAbsRGB':float(residual.max()),'pixelsExceedingHistoricDiagnosticBound':int((residual>bound).any(2).sum()),'notForcedToZero':True,'boundIsNotAcceptance':True}
 passes[view]['directionMinusBaseline']={domain:{k:stats(pp['direction'][k]-pp['baseline'][k],m) for k in pp['baseline']} for domain,m in domains.items()}
 mixing[view]={'domains':{k:int(m.sum()) for k,m in domains.items()},'proxyCombinedAlpha':{'min':1,'max':1,'opaqueFilmNotGeometryCoverage':True},'filter':'Original BH1.5 pixel filter; filtered pass products are not filtered products; native center sample and nohit black are different','nativeMissingForegroundRetained':True}
assert all(sha(Path(p))==h for p,h in pins.items())
save(D/'evaluation.json',E.descriptive_only(evaluation));save(D/'pass-statistics.json',passes);save(D/'mixing.json',mixing);save(D/'brief.json',brief);save(D/'input-hashes.json',pins)
save(D/'COMPLETED.json',{'status':'DESCRIPTIVE_SINGLE_SEED_ONLY','all4ProxyCases':True,'source4ControlsExact':True,'noNewStabilityMasks':True,'noGlobal60Claim':True,'sourceMaterialsNotNative565':True,'noReferenceInputToNative':True,'inputsUnchanged':True})
print(json.dumps(brief,indent=2))
