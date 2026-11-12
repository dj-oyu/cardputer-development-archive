"""Validate complete frozen-seed reference pack and evaluate reference uncertainty only."""
import json,hashlib,sys,pathlib,struct
import numpy as np
from PIL import Image
import evaluator as E
root=pathlib.Path(sys.argv[1]); manifest=json.loads((root/'render-manifest.json').read_text())
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def read_png(p,require_alpha=False):
 data=p.read_bytes()
 if data[:8]!=b'\x89PNG\r\n\x1a\n' or data[12:16]!=b'IHDR':raise ValueError('not PNG')
 w,h,depth,kind=struct.unpack('>IIBB',data[16:26])
 if depth!=8 or kind not in ([6] if require_alpha else [2,6]):raise ValueError('PNG depth/color type mismatch')
 if [w,h]!=config['resolution']:raise ValueError('PNG resolution mismatch')
 return np.array(Image.open(p),dtype=np.uint8)
config=json.loads((root/'input/config.json').read_text())
if manifest['configSHA256']!=sha(root/'input/config.json'):raise ValueError('config hash mismatch')
if config['seeds']!=E.PLAN['seeds']:raise ValueError('seed contract mismatch')
if sha(pathlib.Path(config['source']))!=config['sourceSHA256'] or manifest['sourceSHA256']!=config['sourceSHA256']:raise ValueError('source hash mismatch')
required={'code/evaluator.py','code/evaluate_pack.py','code/render_reference.py','code/test_evaluator.py','code/test_pack_validation.py','code/inspect_source.py','PLAN.md','plan.json','plan-freeze.json','NUMERIC_ADDENDUM.md','numeric-freeze.json'}
if not required.issubset(config['frozenCode']):raise ValueError('missing frozen code/plan entries')
for name,h in config['frozenCode'].items():
 if sha(root/name)!=h:raise ValueError('frozen code mismatch')
if manifest['renderInvariantSettings']!=config['expectedRenderInvariantSettings']:raise ValueError('source render invariant mismatch')
rows=manifest['images'];lookup={};metadata={}
for row in rows:
 key=(row['seed'],row['view'],row['case'])
 if key in lookup:raise ValueError('duplicate seed/view/case')
 if row['seed'] not in E.PLAN['seeds'] or row['view'] not in E.PLAN['views'] or row['case'] not in E.PLAN['cases']:raise ValueError('unexpected seed/view/case')
 stem=f"images/seed-{row['seed']}-{row['view']}-{row['case']}"
 if row['file']!=stem+'.png' or row['metadata']!=stem+'.json':raise ValueError('noncanonical image/metadata identity')
 p=root/row['file']
 if not p.resolve().is_relative_to(root.resolve()) or not (root/row['metadata']).resolve().is_relative_to(root.resolve()):raise ValueError('path outside pack')
 if sha(p)!=row['sha256']:raise ValueError('image hash mismatch')
 if sha(root/row['metadata'])!=row['metadataSHA256']:raise ValueError('metadata hash mismatch')
 meta=json.loads((root/row['metadata']).read_text())
 if meta['pngSHA256']!=sha(p):raise ValueError('metadata PNG hash mismatch')
 expected_case=config['expectedCaseMetadata'][row['case']]
 for field,value in expected_case.items():
  actual=meta[field]
  if field=='albedoTargetMaterials':
   if actual!=value:raise ValueError('material scope mismatch')
  elif not np.allclose(actual,value,rtol=0,atol=config['metadataFloatTolerance']):raise ValueError('case metadata mismatch: '+field)
 if meta['invariantSettings']!=manifest['renderInvariantSettings']:raise ValueError('render invariant mismatch')
 if (meta['seed'],meta['view'],meta['case'])!=key:raise ValueError('render metadata mismatch')
 if meta['samplesMaximum']!=2048 or meta['threads']!=8 or meta['configSHA256']!=manifest['configSHA256']:raise ValueError('render settings mismatch')
 metadata[key]=meta
 lookup[key]=read_png(p)[...,:3]
if len(lookup)!=80:raise ValueError('incomplete reference pack')
out={'version':'new-reference-v3-not-recovered-v2','candidateAvailable':False,'sixtyPercentGoal':'NOT_EVALUATED_NO_CANDIDATE','conditions':{},'notes':['Observed reference stability only; pointwise model-based mean intervals do not guarantee future seed or simultaneous coverage.','Uncertain pixels never count as agreement or zero error.']}
maskdir=root/'evaluation-masks';maskdir.mkdir(exist_ok=True)
for view in E.PLAN['views']:
 row=manifest['foreground'][view];p=root/row['file']
 if row['file']!=f'images/foreground-{view}.png' or not p.resolve().is_relative_to(root.resolve()):raise ValueError('invalid mask path')
 if sha(p)!=row['sha256']:raise ValueError('foreground hash mismatch')
 alpha=read_png(p,require_alpha=True)[...,3];fg=alpha>0
 color_meta=metadata[(E.PLAN['seeds'][0],view,'baseline')]
 for key,meta in metadata.items():
  if key[1]==view and meta['geometry']!=color_meta['geometry']:raise ValueError('per-case/view geometry drift')
 for key in ['cameraMatrix','clip','orthoScale','resolution']:
  if color_meta['geometry'][key]!=row['geometry'][key]:raise ValueError('mask/color geometry mismatch: '+key)
 color_objs={o['name']:o['hideRender'] for o in color_meta['geometry']['objects'] if o['name']!='Studio ground'}
 mask_objs={o['name']:o['hideRender'] for o in row['geometry']['objects'] if o['name']!='Studio ground'}
 if color_objs!=mask_objs:raise ValueError('mask/color object visibility mismatch')
 out.setdefault('foreground',{})[view]={'pixels':int(fg.sum()),'partialAlphaBoundaryPixels':int(((alpha>0)&(alpha<255)).sum()),'contract':row['contract']}
 arrays={case:np.stack([lookup[(seed,view,case)] for seed in E.PLAN['seeds']]) for case in E.PLAN['cases']}
 for case,a in arrays.items():
  color,cs=E.evaluate_color_png8(a,fg);item={'colorMeanPrecision':color}
  if case!='baseline':
   response,rs=E.evaluate_response_png8(arrays['baseline'],a,fg);item['response']=response
   unknown=fg&rs['uncertain'];partial=(alpha>0)&(alpha<255)
   nums=rs['numerator'];allbright=np.all(nums>E.PNG_THRESHOLD,axis=0);alldark=np.all(nums<-E.PNG_THRESHOLD,axis=0);allinactive=np.all(abs(nums)<=E.PNG_THRESHOLD,axis=0)
   response['uncertaintyDiagnostics']={'uncertainOnPartialAlphaBoundary':int((unknown&partial).sum()),'uncertainInsideFullAlpha':int((unknown&(alpha==255)).sum()),'allEightSameClassButMeanCIRejected':int((unknown&(allbright|alldark|allinactive)).sum()),'seedClassDisagreement':int((unknown&~(allbright|alldark|allinactive)).sum()),'causes':'Classification diagnostics only; Monte Carlo/adaptive/display quantization contributions not causally separated.'}
   np.savez_compressed(maskdir/f'{view}-{case}-response.npz',**rs,foreground=fg)
  np.savez_compressed(maskdir/f'{view}-{case}-color.npz',**cs,foreground=fg)
  out['conditions'][view+'-'+case]=item
(root/'evaluation.json').write_text(json.dumps(out,indent=2,allow_nan=False))
print(json.dumps({'status':out['sixtyPercentGoal'],'conditions':len(out['conditions'])}))
