from pathlib import Path
import json,hashlib,numpy as np
from PIL import Image
R=Path(__file__).resolve().parent.parent;D=Path(__file__).resolve().parent;rays=json.loads((D/'source-rays-private.json').read_text());out={}
def stats(a):
 return None if not a else {'n':len(a),'min':float(np.min(a)),'median':float(np.median(a)),'max':float(np.max(a))}
def decode(p):
 a=np.fromfile(p,'<u2').reshape(135,240);return np.stack([((a>>11)&31)/31,((a>>5)&63)/63,(a&31)/31],-1)
for view in ['front','oblique']:
 rr=[r for r in rays['rows'] if r['view']==view];m=np.load(R/'fox-reference-uncertainty-v3/evaluation-masks'/f'{view}-direction-response.npz');alpha=np.asarray(Image.open(R/'fox-reference-uncertainty-v3/images'/f'foreground-{view}.png'))[...,3];labels=np.full((135,240),'outside',object)
 for k in ['bright','dark','inactive','uncertain']:labels[(alpha>0)&m[k]]=k
 byxy={(r['x'],r['y']):r for r in rr}
 for r in rr:r['boundary']=any((r['x']+dx,r['y']+dy) not in byxy or byxy[r['x']+dx,r['y']+dy]['nativeObject']!=r['nativeObject'] for dx,dy in [(1,0),(-1,0),(0,1),(0,-1)])
 arms={}
 for arm in ['point-off','point-on','filter3-off','filter3-on']:
  pp=R/'fox-v3-lid-display-combination/postprocess-002';b,c=[decode(pp/f'{arm}-{view}-{case}.u16le') for case in ['baseline','direction']];dy=(c-b)@np.array([.2126,.7152,.0722]);cl=np.where(dy>2/255,'bright',np.where(dy< -2/255,'dark','inactive'))
  groups={}
  for r in rr:
   x,y=r['x'],r['y'];ref=labels[y,x];nat=cl[y,x];reverse=(ref,nat) in [('bright','dark'),('dark','bright')];typ='noSourceHit' if not r['sourceHit'] else 'sameObject' if r['sameObject'] else 'differentObject';keys=['allCovered',typ]
   if reverse:keys+=['reverse',f'reverse/{typ}',f"reverse/nativeObject/{r['nativeObject']}"]
   if r['boundary']:keys+=['objectBoundary']
   if 0<alpha[y,x]<255:keys+=['partialAlpha']
   if r['sourceHit'] and abs(r['sourceAheadOfNative'])<=1e-5:keys+=['numericDiagnostic/depthAbsLe1e-5']
   if r['sourceHit'] and min(r['barycentric'])<=1e-5:keys+=['numericDiagnostic/barycentricMinLe1e-5']
   if reverse and r['sourceHit'] and abs(r['sourceAheadOfNative'])<=1e-5:keys+=['reverse/numericDiagnosticDepthAbsLe1e-5']
   if reverse and r['sourceHit'] and min(r['barycentric'])<=1e-5:keys+=['reverse/numericDiagnosticBarycentricMinLe1e-5']
   if reverse and r['boundary']:keys+=['reverse/objectBoundary']
   if reverse and 0<alpha[y,x]<255:keys+=['reverse/partialAlpha']
   for k in keys:
    g=groups.setdefault(k,{'count':0,'confusion':{a:{b:0 for b in ['bright','dark','inactive']} for a in ['bright','dark','inactive','uncertain','outside']},'depth':[],'normalDot':[],'sourceObjectTransitions':{}});g['count']+=1;g['confusion'][ref][nat]+=1
    if r['sourceHit']:
     g['depth'].append(r['sourceAheadOfNative']);g['normalDot'].append(r['sourceNsDotNativeNs']);tr=r['nativeObject']+' -> '+r['sourceObject'];g['sourceObjectTransitions'][tr]=g['sourceObjectTransitions'].get(tr,0)+1
  for g in groups.values():g['sourceAheadOfNative']=stats(g.pop('depth'));g['sourceNsDotNativeNs']=stats(g.pop('normalDot'))
  arms[arm]=groups
 out[view]=arms
(D/'correspondence-summary.json').write_text(json.dumps({'rawSHA256':hashlib.sha256((D/'source-rays-private.json').read_bytes()).hexdigest(),'maxProjectionErrorPixels':rays['maxProjectionErrorPixels'],'scope':'same object does not mean same surface; source evaluated normals not Cycles safe normals; center ray not filtered receiver','views':out},indent=2))
for v,arms in out.items():
 print(v,{k:g['count'] for k,g in arms['point-off'].items() if '/' not in k or k.startswith('reverse/') and not k.startswith('reverse/nativeObject/')})
