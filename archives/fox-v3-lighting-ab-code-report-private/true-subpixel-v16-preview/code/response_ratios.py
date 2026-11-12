import pathlib,json,numpy as np
from PIL import Image
R=pathlib.Path(__file__).resolve().parents[1];REF=R.parent/'fox-reference-uncertainty-v3';cfg=json.loads((REF/'input/config.json').read_text());w=np.array([2126,7152,722],dtype='int64');out={'scope':'supplementary signed response amplitude diagnostic on unchanged reference-stable domains; no new thresholds or acceptance','arms':{}}
def rgb(p):
 q=np.fromfile(p,dtype='<u2').reshape(135,240);return np.stack([((q>>11)&31)/31,((q>>5)&63)/63,(q&31)/31],axis=-1)
for arm in ['legacy','linear','area','both']:
 out['arms'][arm]={};run=R/f'four-{arm}-002';score=R/f'score-four-{arm}-002'
 for view in ['front','oblique']:
  base=np.stack([np.asarray(Image.open(REF/f'images/seed-{seed}-{view}-baseline.png'))[:,:,:3].astype('int64') for seed in cfg['seeds']]);nb=rgb(run/f'native-{view}-baseline.u16le')
  for case in ['direction','intensity','ambient','albedo']:
   target=np.stack([np.asarray(Image.open(REF/f'images/seed-{seed}-{view}-{case}.png'))[:,:,:3].astype('int64') for seed in cfg['seeds']]);dr=np.mean((target-base)@w,axis=0)/(255*10000);dn=(rgb(run/f'native-{view}-{case}.u16le')-nb)@(w/10000);z=np.load(score/f'{view}-{case}-masks.npz');mask=z['responseStable']&z['sourceForeground'];a=dr[mask];b=dn[mask];na=np.linalg.norm(a);nn=np.linalg.norm(b);out['arms'][arm][view+'-'+case]={'pixels':int(mask.sum()),'referenceDeltaLumaNorm':float(na),'nativeDeltaLumaNorm':float(nn),'nativeOverReference':float(nn/na) if na>0 else None,'referenceSignedMean':float(a.mean()),'nativeSignedMean':float(b.mean()),'signedCorrelation':float(np.corrcoef(a,b)[0,1]) if np.std(a)>0 and np.std(b)>0 else None}
(R/'response-ratios.json').write_text(json.dumps(out,indent=2,allow_nan=False));print(json.dumps(out['arms']['both'],indent=2))
