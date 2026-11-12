from pathlib import Path
import numpy as np,json,hashlib,sys
from PIL import Image
R=Path(__file__).resolve().parent;W=R.parent;D=R/'analysis-002';D.mkdir(exist_ok=False);REF=W/'fox-reference-uncertainty-v3';P=W/'fox-v3-position-diagnostic';sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();hashes={};L=np.array([.2126,.7152,.0722])
def take(p):hashes[str(p)]=sha(p);return p
take(Path(__file__));take(P/'pass-decomposition/exr_io.py');take(R/'native/run-001/COMPLETED.json');take(R/'blender/COMPLETED.json')
a={c:np.load(take(R/f'native/run-001/{c}.npz')) for c in ['baseline','direction']};coverage=a['baseline']['coverage'];assert np.array_equal(coverage,a['direction']['coverage'])
# Fixed Chebyshev radius2 erosion: outside image is background.
padded=np.pad(coverage,2);interior=np.ones_like(coverage)
for dy in range(5):
 for dx in range(5):interior &= padded[dy:dy+135,dx:dx+240]
m=json.load(open(take(REF/'render-manifest.json')));row=m['foreground']['oblique'];assert sha(REF/row['file'])==row['sha256'];fg=np.array(Image.open(take(REF/row['file'])))[...,3]>0
masks={'nativeCoverage':coverage,'interiorChebyshev2':interior,'boundary':coverage&~interior,'originalForeground':fg,'missingOriginal':fg&~coverage};ref={(c,s):np.load(take(R/f'blender/seed11-oblique-{c}-shadow{s}-direct.npy')) for c in a for s in ['off','on']}
def filt(x):
 t=2*np.pi*(np.array([-1.,0.,1.])/3+.5);w=.35875-.48829*np.cos(t)+.14128*np.cos(2*t)-.01168*np.cos(3*t);w/=w.sum();p=np.pad(x,((1,1),(1,1),(0,0)));y=np.zeros_like(x)
 for j in range(3):
  for i in range(3):y+=w[j]*w[i]*p[j:j+135,i:i+240]
 return y

def metric(b,c,mask):
 x=b[mask];y=c[mask];assert np.isfinite(x).all() and np.isfinite(y).all();den=float(np.linalg.norm(x));xx=x@L;yy=y@L
 return {'pixels':len(x),'RGBMAE':float(abs(x-y).mean()) if len(x) else None,'RGBRMSE':float(np.sqrt(np.mean((x-y)**2))) if len(x) else None,'relativeL2':float(np.linalg.norm(x-y)/den) if den else None,'referenceMeanY':float(xx.mean()) if len(x) else None,'candidateMeanY':float(yy.mean()) if len(x) else None,'candidateReferenceMeanYRatio':float(yy.mean()/xx.mean()) if len(x) and xx.mean()!=0 else None,'signedYCorrelation':float(np.corrcoef(xx,yy)[0,1]) if len(x) and xx.std()>0 and yy.std()>0 else None}
results={};responses={}
for shadow in ['off','on']:
 for rate in ['pixel','vertex']:
  for rho in ['source','565']:
   for filtermode in ['center','BH_integer9']:
    key=f'{rate}_{rho}_{shadow}_{filtermode}';images={c:(filt(a[c][f'{rate}_{rho}_{shadow}']) if filtermode!='center' else a[c][f'{rate}_{rho}_{shadow}']) for c in a};results[key]={c:{n:metric(ref[(c,shadow)],images[c],mask) for n,mask in masks.items()} for c in a};responses[key]={n:metric(ref[('direction',shadow)]-ref[('baseline',shadow)],images['direction']-images['baseline'],mask) for n,mask in masks.items()}
# Same Blender lighting contribution, independent context only: includes world/ground/PBR.
sys.path.insert(0,str(P/'pass-decomposition'));import exr_io
rich={};context={}
for c in a:
 p=take(P/f'pass-decomposition/images/seed-11-oblique-{c}.exr');ch=exr_io.read(p)
 def x(n):return np.stack([ch['ViewLayer.'+n+'.'+k] for k in 'RGB'],-1).astype(float)
 rich[c]={'directDiffuse':x('DiffDir')*x('DiffCol'),'indirectDiffuse':x('DiffInd')*x('DiffCol'),'directGloss':x('GlossDir')*x('GlossCol'),'indirectGloss':x('GlossInd')*x('GlossCol'),'combined':x('Combined')}
 context[c]={k:{n:{'meanY':float((v[mask]@L).mean()),'RGBL2':float(np.linalg.norm(v[mask]))} for n,mask in masks.items() if mask.any()} for k,v in rich[c].items()}
context['response']={k:{n:{'meanDeltaY':float(((rich['direction'][k]-rich['baseline'][k])[mask]@L).mean()),'RGBDeltaL2':float(np.linalg.norm((rich['direction'][k]-rich['baseline'][k])[mask]))} for n,mask in masks.items() if mask.any()} for k in rich['baseline']}
assert all(sha(Path(p))==h for p,h in hashes.items());(D/'metrics.json').write_text(json.dumps({'static':results,'response':responses},indent=2));(D/'rich-context.json').write_text(json.dumps(context,indent=2));(D/'input-hashes.json').write_text(json.dumps(hashes,indent=2));(D/'regions.json').write_text(json.dumps({'counts':{n:int(mask.sum()) for n,mask in masks.items()},'erosion':'5x5 square, Chebyshev radius2, image exterior background','BHinteger9IsNotContinuousCyclesIntegration':True,'notPrimaryQualityScoring':True},indent=2));print(json.dumps({k:responses[k]['interiorChebyshev2'] for k in responses if 'source' in k},indent=2))
