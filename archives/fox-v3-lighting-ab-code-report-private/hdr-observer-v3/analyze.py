from pathlib import Path
import numpy as np,json,hashlib,sys
from PIL import Image
R=Path(__file__).resolve().parent;W=R.parent;D=R/'run-001';P=W/'fox-v3-position-diagnostic/pass-decomposition';REF=W/'fox-reference-uncertainty-v3';sys.path.insert(0,str(P));import exr_io
out=Path(sys.argv[1]).resolve();out.mkdir(exist_ok=False,parents=True);sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();L=np.array([.2126,.7152,.0722]);T=2/255
inputs=[Path(__file__),P/'exr_io.py',D/'COMPLETED.json',REF/'render-manifest.json',P/'COMPLETED.json'];manifest=json.loads((REF/'render-manifest.json').read_text());completed=json.loads((D/'COMPLETED.json').read_text());assert completed['rgbDepthAllExact004'];original=json.loads((P/'COMPLETED.json').read_text());richlookup={(x['seed'],x['view'],x['case']):x for x in original['images']}
for view in ['front','oblique']:
 inputs.append(REF/manifest['foreground'][view]['file'])
 for c in ['baseline','direction']:
  inputs += [D/f'native-{view}-{c}-{f}.f64le' for f in ['combined','world','area']]+[D/f'native-{view}-{c}.f32le']
  for seed in [11,29]:inputs.append(P/'images'/f'seed-{seed}-{view}-{c}.exr')
hashes={str(p):sha(p) for p in inputs};(out/'input-hashes.json').write_text(json.dumps(hashes,indent=2))
def corr(a,b):
 a=a.ravel();b=b.ravel();return None if len(a)<2 or np.std(a)==0 or np.std(b)==0 else float(np.corrcoef(a,b)[0,1])
def ratio(a,b):return None if b==0 else float(a/b)
def metric(n,r,m):
 x=n[m];y=r[m];ny=x@L;ry=y@L;return {'pixels':int(m.sum()),'meanNativeRGB':x.mean(0).tolist(),'meanReferenceRGB':y.mean(0).tolist(),'meanNativeY':float(ny.mean()),'meanReferenceY':float(ry.mean()),'nativeReferenceMeanYRatio':ratio(ny.sum(),ry.sum()),'signedMeanRGB':(x-y).mean(0).tolist(),'rgbMAE':float(np.abs(x-y).mean()),'rgbRMSE':float(np.sqrt(np.mean((x-y)**2))),'relativeRGBL2':ratio(np.linalg.norm(x-y),np.linalg.norm(y)),'signedYCorrelation':corr(ny,ry)}
def response(n,r,m):
 x=(n@L)[m];y=(r@L)[m];d={'pixels':int(m.sum()),'nativeReferenceDeltaL2Ratio':ratio(np.linalg.norm(x),np.linalg.norm(y)),'deltaLumaRMSE':float(np.sqrt(np.mean((x-y)**2))),'signedCorrelation':corr(x,y),'nativeSignedMeanDelta':float(x.mean()),'referenceSignedMeanDelta':float(y.mean())}
 for name,f in [('bright',lambda z:z>T),('dark',lambda z:z<-T)]:
  a=f(x);b=f(y);u=int((a|b).sum());d[name]={'nativePixels':int(a.sum()),'referencePixels':int(b.sum()),'intersection':int((a&b).sum()),'union':u,'IoU':None if not u else float((a&b).sum()/u),'falsePositive':int((a&~b).sum()),'falseNegative':int((~a&b).sum())}
 return d
results={};regions={};decomp={}
for view in ['front','oblique']:
 fgentry=manifest['foreground'][view];assert sha(REF/fgentry['file'])==fgentry['sha256'];fg=np.asarray(Image.open(REF/fgentry['file']))[...,3]>0
 native={};coverage=[]
 for c in ['baseline','direction']:
  native[c]={f:np.fromfile(D/f'native-{view}-{c}-{f}.f64le',dtype='<f8').reshape(135,240,3) for f in ['combined','world','area']};z=np.fromfile(D/f'native-{view}-{c}.f32le',dtype='<f4').reshape(135,240);assert not np.isnan(z).any() and not np.isposinf(z).any();coverage.append(np.isfinite(z));assert all(np.isfinite(v).all() for v in native[c].values());assert np.max(abs(native[c]['combined']-native[c]['area']-native[c]['world']))<1e-12
  row=next(x for x in completed['frames'] if x['view']==view and x['case']==c)
  for name,h in row['files'].items():assert sha(D/name)==h
 assert np.array_equal(*coverage);cov=coverage[0];common=fg&cov;padded=np.pad(common,2,constant_values=False);interior=np.ones_like(common)
 for dy in range(5):
  for dx in range(5):interior &= padded[dy:dy+135,dx:dx+240]
 domains={'originalForeground':fg,'commonConditional':common,'interior2Conditional':interior};regions[view]={'foreground':int(fg.sum()),'nativeCoverage':int(cov.sum()),'missing':int((fg&~cov).sum()),'extra':int((~fg&cov).sum()),'common':int(common.sum()),'interior2':int(interior.sum()),'erosion':'Chebyshev radius2; outside image false'};results[view]={};decomp[view]={}
 for seed in [11,29]:
  rich={}
  for c in ['baseline','direction']:
   path=P/'images'/f'seed-{seed}-{view}-{c}.exr';row=richlookup[(seed,view,c)];assert sha(path)==row['EXRSHA256'];a=exr_io.read(path)
   def rgb(name):return np.stack([a[f'ViewLayer.{name}.{k}'] for k in 'RGB'],axis=-1).astype(np.float64)
   rich[c]={'combined':rgb('Combined'),'directDiffuse':rgb('DiffDir')*rgb('DiffCol'),'indirectDiffuse':rgb('DiffInd')*rgb('DiffCol'),'directSpecular':rgb('GlossDir')*rgb('GlossCol'),'indirectSpecular':rgb('GlossInd')*rgb('GlossCol')};rich[c]['totalDiffuse']=rich[c]['directDiffuse']+rich[c]['indirectDiffuse']
  results[view][str(seed)]={};decomp[view][str(seed)]={}
  for domain,m in domains.items():
   data={'static':{},'response':{}};comp={}
   for c in ['baseline','direction']:
    data['static'][c]={f:metric(native[c]['combined'],rich[c][f],m) for f in ['directDiffuse','totalDiffuse','combined']}
    total=(rich[c]['combined']@L)[m].sum();comp[c]={'richRadianceFraction':{f:ratio((v@L)[m].sum(),total) for f,v in rich[c].items()},'nativeWorldFraction':ratio((native[c]['world']@L)[m].sum(),(native[c]['combined']@L)[m].sum()),'nativeAreaMeanY':float((native[c]['area']@L)[m].mean()),'nativeWorldMeanY':float((native[c]['world']@L)[m].mean()),'indirectVsSignedRadianceGapCorrelation':corr((rich[c]['indirectDiffuse']@L)[m],((rich[c]['combined']-native[c]['combined'])@L)[m])}
   deltaN=native['direction']['combined']-native['baseline']['combined']
   for f in ['directDiffuse','totalDiffuse','combined']:data['response'][f]=response(deltaN,rich['direction'][f]-rich['baseline'][f],m)
   data['componentResponseL2FractionsNotVariance']={f:ratio(np.linalg.norm(((rich['direction'][f]-rich['baseline'][f])@L)[m]),np.linalg.norm(((rich['direction']['combined']-rich['baseline']['combined'])@L)[m])) for f in ['directDiffuse','indirectDiffuse','directSpecular','indirectSpecular']}
   results[view][str(seed)][domain]=data;decomp[view][str(seed)][domain]=comp
assert all(sha(Path(p))==h for p,h in hashes.items());(out/'metrics.json').write_text(json.dumps(results,indent=2,allow_nan=False));(out/'components.json').write_text(json.dumps(decomp,indent=2,allow_nan=False));(out/'regions.json').write_text(json.dumps(regions,indent=2));(out/'COMPLETED.json').write_text(json.dumps({'inputsUnchanged':True,'linearResponseThreshold':T,'fourNativeCases':True,'richSeeds':[11,29],'formalGoalEvaluated':False},indent=2));print(json.dumps(regions))
