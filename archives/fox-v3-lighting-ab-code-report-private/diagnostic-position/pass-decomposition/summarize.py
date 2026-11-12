from pathlib import Path
import numpy as np,json,hashlib,sys
from PIL import Image
D=Path(__file__).resolve().parent;R=D.parent;REF=R.parent/'fox-reference-uncertainty-v3';sys.path[:0]=[str(R/'rich-oracle'),str(REF/'code')];import evaluator as E,oracle_response as OR
cfg=json.loads((REF/'input/config.json').read_text());refm=json.loads((REF/'render-manifest.json').read_text());ref={(r['seed'],r['view'],r['case']):r for r in refm['images']};done=json.loads((D/'COMPLETED.json').read_text());rows=done['images'];lookup={(r['seed'],r['view'],r['case']):r for r in rows};assert len(rows)==8 and set(lookup)=={(s,v,c) for s in [11,29] for v in ['front','oblique'] for c in ['baseline','direction']};sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def image(p,h):
 assert sha(p)==h;b=p.read_bytes();assert b[24:26]==bytes([8,6]);im=Image.open(p);assert im.mode=='RGBA' and im.size==(240,135);return np.array(im)[...,:3]
results={};components={};summary={};paired={}
for view in ['front','oblique']:
 refs={c:np.stack([image(REF/ref[(s,view,c)]['file'],ref[(s,view,c)]['sha256']) for s in cfg['seeds']]) for c in ['baseline','direction']};fgrow=refm['foreground'][view];assert sha(REF/fgrow['file'])==fgrow['sha256'];fg=np.array(Image.open(REF/fgrow['file']))[...,3]>0;results[view]={};summary[view]={};components[view]={};paired[view]={}
 for seed in [11,29]:
  results[view][str(seed)]={};summary[view][str(seed)]={};armimages={}
  for arm in ['original-oracle','redisplayed-control','profile-native-srgb','remove-direct-specular','remove-indirect-diffuse']:
   imgs={}
   for c in refs:
    row=lookup[(seed,view,c)];output=({'file':row['combinedPNG'],'sha256':row['combinedPNGSHA256']} if arm=='original-oracle' else {'file':row['redisplayedPNG'],'sha256':row['redisplayedPNGSHA256']} if arm=='redisplayed-control' else row['outputs'][arm]);imgs[c]=image(D/output['file'],output['sha256'])
   armimages[arm]=imgs
   response,masks=OR.evaluate(refs['baseline'],refs['direction'],fg,imgs['baseline'],imgs['direction']);color={c:E.evaluate_color_png8(refs[c],fg,imgs[c]/255)[0] for c in refs};frame={c:100*(1-float(abs(imgs[c]/255-refs[c].mean(0)/255).mean())) for c in refs};results[view][str(seed)][arm]={'response':response,'color':color,'fullFrameRGBDescriptive':frame};st=response['candidateScores']['stableSubset'];summary[view][str(seed)][arm]={'brightIoU':st['brightening']['IoU'],'darkIoU':st['darkening']['IoU'],'brightFP':st['brightening']['candidatePixels']-st['brightening']['intersection'],'brightFN':st['brightening']['referencePixels']-st['brightening']['intersection'],'uncertainPixels':response['candidateScores']['uncertainSubsetDescriptiveNotAcceptance']['pixels'],'foregroundRGB':{c:color[c]['candidateScores']['stableSubset']['rgbAgreementPercent'] for c in refs},'fullFrameRGBDescriptive':frame,'status':'PASS_COMPONENT_ANALYSIS_NOT_NATIVE_ACCEPTANCE'}
  control=armimages['redisplayed-control'];paired[view][str(seed)]={};domain=fg&masks['stable'];controlDelta=(control['direction'].astype(np.int64)-control['baseline'].astype(np.int64))@OR.W
  for arm,imgs in armimages.items():
   delta=(imgs['direction'].astype(np.int64)-imgs['baseline'].astype(np.int64))@OR.W;effect=(delta-controlDelta)/OR.DEN;paired[view][str(seed)][arm]={'foregroundRGBMAEvsRedisplay':{c:float(abs(imgs[c].astype(float)-control[c].astype(float))[fg].mean()/255) for c in refs},'stableResponseDeltaLumaRMSEvsRedisplay':float(np.sqrt(np.mean(effect[domain]**2))),'stableBrightClassificationFlipsVsRedisplay':int((((delta>OR.T)!=(controlDelta>OR.T))&domain).sum()),'stableDarkClassificationFlipsVsRedisplay':int((((delta<-OR.T)!=(controlDelta<-OR.T))&domain).sum()),'notCausalShareOrNativeImplementation':True}
  raw={c:np.load(D/'images'/f'seed-{seed}-{view}-{c}-components.npz') for c in refs};compstats={};domain=fg&masks['stable'];dc=(raw['direction']['combined']-raw['baseline']['combined'])@E.LUMA
  for name in ['directSpecular','indirectDiffuse']:
   d=(raw['direction'][name]-raw['baseline'][name])@E.LUMA;total=float(np.linalg.norm(dc[domain]));strength=float(np.linalg.norm(d[domain]));compstats[name]={'foregroundRadianceFractionByCase':{c:float((raw[c][name]@E.LUMA)[fg].sum()/(raw[c]['combined']@E.LUMA)[fg].sum()) for c in refs},'stableDeltaLumaL2RelativeToCombined':None if total==0 else strength/total,'notAdditiveExplainedVariance':True}
  components[view][str(seed)]=compstats
(D/'evaluation.json').write_text(json.dumps(E.descriptive_only(results),indent=2,allow_nan=False));(D/'summary.json').write_text(json.dumps(summary,indent=2));(D/'paired-effects.json').write_text(json.dumps(paired,indent=2));(D/'component-statistics.json').write_text(json.dumps(components,indent=2));print(json.dumps(summary,indent=2))
