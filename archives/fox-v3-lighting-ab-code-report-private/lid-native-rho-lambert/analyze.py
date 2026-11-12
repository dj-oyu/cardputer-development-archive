"""Fixed domains/cohorts and original-lighting Lambert/rho diagnostic; no fitting."""
from pathlib import Path
import sys,json,hashlib,ast,numpy as np
from PIL import Image
sys.dont_write_bytecode=True
R=Path(__file__).resolve().parent;W=R.parent;G=W/'fox-v3-lid-rich-proxy';RUN=R/'run-001';REF=W/'fox-reference-uncertainty-v3';C=W/'fox-v3-lid-transport-point-audit/capture-002';PP=W/'fox-v3-lid-display-combination/postprocess-002'
sys.path[:0]=[str(R/'code'),str(REF/'code'),str(W/'fox-v3-position-diagnostic/rich-oracle')];import exr_io as X,evaluator as E,oracle_response as OR
D=Path(sys.argv[1]).resolve();assert D.parent==R and not D.exists();D.mkdir();pins={};Y=np.array([.2126,.7152,.0722]);IW=np.array([2126,7152,722]);sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def pin(p,h=None):
 p=Path(p);s=sha(p);assert h is None or s==h;pins[str(p)]=s;return p
def load(p):return json.loads(pin(p).read_text())
def save(p,v):p.write_text(json.dumps(v,indent=2,allow_nan=False,default=lambda x:x.item())+'\n')
def image(p,h=None):
 a=np.array(Image.open(pin(p,h)));assert a.shape==(135,240,4);return a[...,:3]
def dec(p):
 a=np.fromfile(pin(p),'<u2').reshape(135,240);return np.stack([(a>>11)/31,((a>>5)&63)/63,(a&31)/31],-1)
def extract(ch):
 rgb=lambda n:np.stack([ch['ViewLayer.'+n+'.'+c] for c in 'RGB'],-1).astype(np.float64)
 d={'Combined':rgb('Combined'),'DirectDiffuse':rgb('DiffDir')*rgb('DiffCol'),'IndirectDiffuse':rgb('DiffInd')*rgb('DiffCol'),'DirectGloss':rgb('GlossDir')*rgb('GlossCol'),'IndirectGloss':rgb('GlossInd')*rgb('GlossCol'),'Emit':rgb('Emit'),'Env':rgb('Env'),'Transmission':(rgb('TransDir')+rgb('TransInd'))*rgb('TransCol'),'Volume':rgb('VolumeDir')+rgb('VolumeInd')};d['R']=d['Combined']-sum(v for k,v in d.items() if k!='Combined');return d

def stats(a,m):
 v=a[m];y=v@Y
 return {'n':len(v),'meanRGB':v.mean(0).tolist(),'meanY':float(y.mean()),'meanAbsY':float(abs(y).mean()),'minY':float(y.min()),'maxY':float(y.max()),'RMSRGB':float(np.sqrt(np.mean(v*v)))} if len(v) else {'n':0}
def classify(a,t):return np.where(a>t,1,np.where(a<-t,-1,0))
def compare(a,b,m):
 out={'a':stats(a,m),'b':stats(b,m),'aMinusB':stats(a-b,m)}
 for label,t in [('rawSign',0.),('existing2over255LinearDiagnostic',2/255)]:
  x=classify(a@Y,t);y=classify(b@Y,t);out[label]={'sameNonzero':int((m&(x*y==1)).sum()),'opposite':int((m&(x*y==-1)).sum()),'eitherZeroOrSmall':int((m&((x==0)|(y==0))).sum())}
 return out
for p in [Path(__file__),Path(E.__file__),Path(OR.__file__),Path(X.__file__),REF/'plan.json',REF/'numeric-freeze.json']:pin(p)
manifest=load(RUN/'COMPLETED.json');assert manifest['status']=='TWO_CASE_LAMBERT_COMPLETE' and manifest['inputsUnchanged'] and len(manifest['images'])==2 and manifest['reusedOriginalControls']['fourOriginalControlsStillExact'];rich=load(G/'run-001/COMPLETED.json');rows={r['case']:r for r in manifest['images']};richrows={r['case']:r for r in rich['images'] if r['view']=='oblique'}
ref=load(REF/'render-manifest.json');cfg=load(REF/'input/config.json');refs={(r['seed'],r['case']):r for r in ref['images'] if r['view']=='oblique'};fgrow=ref['foreground']['oblique'];alpha=np.array(Image.open(pin(REF/fgrow['file'],fgrow['sha256'])))[...,3];fg=alpha>0
references={c:np.stack([image(REF/refs[s,c]['file'],refs[s,c]['sha256']) for s in cfg['seeds']]) for c in ['baseline','direction']};_,st=E.evaluate_response_png8(references['baseline'],references['direction'],fg)
label=np.where(st['bright'],1,np.where(st['dark'],-1,0));original_stable=fg&st['stable'];coverage=None;native={};passes={};images={};worldsame=True;groundsame=True
for case in ['baseline','direction']:
 images[case]={};passes[case]={}
 for arm,root,rr in [('lambertNativeRho',RUN,rows),('richOriginalRho',G/'run-001',richrows)]:
  r=rr[case];images[case][arm]=image(root/r['PNG'],r['PNGSHA256']);passes[case][arm]=extract(X.read(pin(root/r['EXR'],r['EXRSHA256'])));pin(root/r['audit'],r['auditSHA256'])
 images[case]['sourceSeed11']=references[case][cfg['seeds'].index(11)]
 for arm in ['point-off','point-on','filter3-off','filter3-on']:images[case][arm]=dec(PP/f'{arm}-oblique-{case}.u16le')
 native[case]={k:np.zeros((135,240,3),np.float64) for k in ['rgb','direct','world','bounce','ground']};cov=np.zeros((135,240),bool)
 for p in load(C/f'native-oblique-{case}-winners.json')['points']:
  x,y=p['x'],p['y'];cov[y,x]=True
  for k in native[case]:native[case][k][y,x]=p[k]
 if coverage is None:coverage=cov
 else:assert np.array_equal(coverage,cov)
 native[case]['directPlusPrimaryWorldGround']=(native[case]['direct']+native[case]['world'])+native[case]['ground']
assert np.array_equal(native['baseline']['world'],native['direction']['world']) and np.array_equal(native['baseline']['ground'],native['direction']['ground'])
filterpath=W/'fox-v3-lid-display-combination/postprocess_v2.py';tree=ast.parse(pin(filterpath).read_text());ns={'np':np};fn=next(x for x in tree.body if isinstance(x,ast.FunctionDef) and x.name=='filter3');exec(compile(ast.Module(body=[fn],type_ignores=[]),str(filterpath),'exec'),ns);fc=load(PP/'filter.json');off=np.array(fc['offsets']);weights=np.array(fc['weights1D'])
for case in native:
 for k in ['direct','directPlusPrimaryWorldGround']:native[case][k+'BH3']=ns['filter3'](native[case][k],coverage,off,weights)[0]
nd={k:native['direction'][k]-native['baseline'][k] for k in native['baseline']};pd={arm:{k:passes['direction'][arm][k]-passes['baseline'][arm][k] for k in passes['baseline'][arm]} for arm in passes['baseline']}
prior=load(G/'reverse-join-002/private-point-join.json');cohorts={k:np.zeros((135,240),bool) for k in ['oldReverse113','oldReverseSameObject83','oldReverseDifferentObject30','priorRichCorrect41','priorRichCorrectSame32']}
for r in prior:
 if r['view']!='oblique':continue
 x,y=r['x'],r['y'];cohorts['oldReverse113'][y,x]=True
 cohorts['oldReverseSameObject83' if r['correspondence']=='sameObject' else 'oldReverseDifferentObject30'][y,x]=True
 if r['displayClasses']['proxyOriginalAgXBH']==r['reference']:
  cohorts['priorRichCorrect41'][y,x]=True
  if r['correspondence']=='sameObject':cohorts['priorRichCorrectSame32'][y,x]=True
assert [int(m.sum()) for m in cohorts.values()]==[113,83,30,41,32]
domains={'originalForeground':fg,'originalStableForeground':original_stable,'originalUncertainForeground':fg&st['uncertain'],'nativeCovered':coverage,'commonForeground':fg&coverage,'missingNativeForeground':fg&~coverage,**cohorts}
evaluation={};census={};classes={}
for arm in images['baseline']:
 a,b=images['baseline'][arm],images['direction'][arm];png=a.dtype==np.uint8
 resp,_=OR.evaluate(references['baseline'],references['direction'],fg,a,b) if png else E.evaluate_response_png8(references['baseline'],references['direction'],fg,a,b)
 color={c:E.evaluate_color_png8(references[c],fg,images[c][arm]/255 if png else images[c][arm])[0] for c in images};evaluation[arm]={'response':resp,'color':color}
 dy=((b.astype(np.int64)-a.astype(np.int64))@IW)/2550000 if png else (b-a)@Y;cl=classify(dy,2/255);classes[arm]=cl
 census[arm]={name:{'n':int(m.sum()),'stableSourceCorrect':int((m&fg&st['stable']&(cl==label)).sum()),'oppositeStableSourceSign':int((m&fg&st['stable']&(label*cl==-1)).sum()),'stableSourceActiveBecomesInactive':int((m&fg&st['stable']&(label!=0)&(cl==0)).sum()),'stableSourceInactiveBecomesActive':int((m&fg&st['inactive']&(cl!=0)).sum()),'sourceUncertain':int((m&fg&st['uncertain']).sum()),'outsideOriginalForeground':int((m&~fg).sum())} for name,m in domains.items()}
comparisons={name:{arm:{k:compare(nd[k],pd[arm]['DirectDiffuse'],m) for k in ['direct','directPlusPrimaryWorldGround','directBH3','directPlusPrimaryWorldGroundBH3']} for arm in pd} for name,m in domains.items()}
component={name:{arm:{k:stats(a,m) for k,a in values.items()} for arm,values in pd.items()} for name,m in domains.items()}
absolute={case:{name:{arm:{k:stats(a,m) for k,a in passes[case][arm].items()} for arm in passes[case]} for name,m in domains.items()} for case in passes}
absolute_comparisons={case:{name:{arm:{k:compare(native[case][k],passes[case][arm]['DirectDiffuse'],m) for k in ['direct','directPlusPrimaryWorldGround','directBH3','directPlusPrimaryWorldGroundBH3']} for arm in passes[case]} for name,m in domains.items()} for case in passes}
residual={case:{arm:{'maxAbsRGB':float(abs(passes[case][arm]['R']).max()),'pixelsExceedingHistoricDiagnosticBound':int((abs(passes[case][arm]['R'])>2e-5+5e-6*abs(passes[case][arm]['Combined'])).any(2).sum())} for arm in passes[case]} for case in passes}
assert all(sha(Path(p))==h for p,h in pins.items())
save(D/'evaluation.json',E.descriptive_only(evaluation));save(D/'census.json',census);save(D/'component-comparison.json',comparisons);save(D/'component-direction.json',component);save(D/'component-absolute.json',absolute);save(D/'absolute-direct-comparison.json',absolute_comparisons);save(D/'residual.json',residual);save(D/'input-hashes.json',pins)
save(D/'contract.json',{'domains':{k:int(v.sum()) for k,v in domains.items()},'primaryWorldDirectionBitExact':True,'primaryGroundDirectionBitExact':True,'directPlusPrimaryDeltaVersusDirectMaxAbsRGB':float(abs(nd['directPlusPrimaryWorldGround']-nd['direct']).max()),'componentwiseAddedDeltaWorldGroundExactlyZero':True,'filter':fc,'originalWorldFloorGIClampsRetained':True,'BRDFAndRhoJointIntervention':True,'DiffDirNotThreeDiskEquivalent':True,'priorCohortsNotReselected':True,'oneSeedNoStabilityOrGlobalAcceptance':True})
print(json.dumps({a:{k:census[a][k] for k in ['originalForeground','oldReverse113','oldReverseSameObject83','priorRichCorrect41','priorRichCorrectSame32']} for a in ['lambertNativeRho','richOriginalRho']},indent=2))
