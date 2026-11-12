import pathlib,json,hashlib,sys,numpy as np
from PIL import Image
R=pathlib.Path(__file__).resolve().parents[1];P=R.parent;D=R/'normal-ab';REF=P/'fox-reference-uncertainty-v3';sys.path.insert(0,str(REF/'code'));import evaluator as E
cfg=json.loads((REF/'input/config.json').read_text());manifest=json.loads((REF/'render-manifest.json').read_text());lookup={(r['seed'],r['view'],r['case']):r for r in manifest['images']};sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(REF/'input/config.json')==manifest['configSHA256'];assert (D/'NS_CONTROL_PASS.json').exists()
def rgb(p):
 u=np.fromfile(p,'<u2');assert u.size==240*135;u=u.reshape(135,240);return np.stack([(u>>11)/31,((u>>5)&63)/63,(u&31)/31],-1)
object_results={};names=json.loads((R/'source-object-map.json').read_text())['objects']
result={'scope':'Four-case normal-only host diagnostic, no default adoption or overall goal claim','referenceConfigSHA256':manifest['configSHA256'],'views':{}}
for view in ['front','oblique']:
 refs={}
 for case in ['baseline','direction']:
  samples=[]
  for seed in cfg['seeds']:
   row=lookup[(seed,view,case)];p=REF/row['file'];assert sha(p)==row['sha256'];samples.append(np.array(Image.open(p))[...,:3])
  refs[case]=np.stack(samples)
 row=manifest['foreground'][view];p=REF/row['file'];assert sha(p)==row['sha256'];fg=np.array(Image.open(p))[...,3]>0
 result['views'][view]={}
 for arm in ['Ns','Ng']:
  images={case:rgb(D/f'{arm}-{view}-{case}.u16le') for case in ['baseline','direction']};response,masks=E.evaluate_response_png8(refs['baseline'],refs['direction'],fg,images['baseline'],images['direction']);color={case:E.evaluate_color_png8(refs[case],fg,images[case])[0] for case in refs}
  result['views'][view][arm]={'response':response,'color':color}
  oid=np.load(R/f'{view}-source-map.npz')['object'];domain=fg&masks['stable'];delta=(images['direction']-images['baseline'])@E.LUMA;nb=delta>E.T;nd=delta<-E.T;rb=masks['bright'];rd=masks['dark'];rows=[]
  for i,name in [(-1,'UNASSIGNED_CENTER_RAY')]+list(enumerate(names)):
   d=domain&(oid==i)
   if d.any():rows.append({'object':name,'stablePixels':int(d.sum()),'brightFP':int((d&~rb&nb).sum()),'brightFN':int((d&rb&~nb).sum()),'referenceDarkNativeBright':int((d&rd&nb).sum()),'referenceBrightNativeDark':int((d&rb&nd).sum())})
  object_results[view+'-'+arm]=rows
if (D/'object-sign-errors.json').exists():assert json.loads((D/'object-sign-errors.json').read_text())==object_results,'object report mismatch'
(D/'object-sign-errors.json').write_text(json.dumps(object_results,indent=2))
(D/'evaluation.json').write_text(json.dumps(result,indent=2,allow_nan=False))
summary={}
for view,arms in result['views'].items():
 summary[view]={}
 for arm,x in arms.items():
  r=x['response']['candidateScores'];stable=r['stableSubset'];unc=r['uncertainSubsetDescriptiveNotAcceptance'];whole=r['pooledFullForegroundDescriptive']
  summary[view][arm]={'brightIoU':stable['brightening']['IoU'],'darkIoU':stable['darkening']['IoU'],'brightFP':stable['brightening']['candidatePixels']-stable['brightening']['intersection'],'brightFN':stable['brightening']['referencePixels']-stable['brightening']['intersection'],'fullForegroundBrightIoU':whole['brightening']['IoU'],'fullForegroundDarkIoU':whole['darkening']['IoU'],'uncertainPixels':unc['pixels'],'uncertainBrightIoUDescriptive':unc['brightening']['IoU'],'uncertainDarkIoUDescriptive':unc['darkening']['IoU'],'baselineStableRGB':x['color']['baseline']['candidateScores']['stableSubset']['rgbAgreementPercent'],'directionStableRGB':x['color']['direction']['candidateScores']['stableSubset']['rgbAgreementPercent']}
(D/'summary.json').write_text(json.dumps(summary,indent=2));print(json.dumps(summary,indent=2))
