from pathlib import Path
import json,hashlib,numpy as np
from PIL import Image
R=Path(__file__).resolve().parent.parent;D=Path(__file__).resolve().parent;REF=R/'fox-reference-uncertainty-v3';A=R/'fox-v3-boundary-aa-evaluation/actual-001';rows=[]
for p in sorted((REF/'images').glob('seed-*.png')):
 im=Image.open(p);a=np.asarray(im);assert im.mode=='RGBA' and a.shape==(135,240,4);assert np.all(a[...,3]==255);meta=json.loads(p.with_suffix('.json').read_text());assert meta['filmTransparent'] is False;assert meta['invariantSettings']['filmTransparent'] is False;assert next(o for o in meta['geometry']['objects'] if o['name']=='Studio ground')['hideRender'] is False;rows.append({'file':str(p.relative_to(R)),'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'alphaMin':255,'alphaMax':255,'metadataSHA256':hashlib.sha256(p.with_suffix('.json').read_bytes()).hexdigest(),'filmTransparent':False,'groundVisible':True})
assert len(rows)==80
out={'colorPNGAlpha':'All80 rich original PNGs are opaque RGBA alpha255. Partial alpha labels come from separately rendered ground-hidden transparent source foreground mask; not these color PNGs. Straight/premult distinction cannot change RGB at alpha1. No unpremultiply or new scoring.','referenceRenderCodeSHA256':hashlib.sha256((REF/'code/render_reference.py').read_bytes()).hexdigest(),'nativeAA':'Four actual linear HDR sample colors average with nohit black and fixed denominator4, then sRGB565. Not RGBA color over matching source floor/background.','colors':rows,'directionQuantizationEndpointDiagnostics':{}}
for v in ['front','oblique']:
 m=np.load(REF/'evaluation-masks'/f'{v}-direction-response.npz');fg=m['foreground'];tar=np.fromfile(A/'on/private-partial'/f'native-{v}-baseline.targets.u8','u1').reshape(135,240).astype(bool);ww=json.load(open(R/'fox-v3-lid-transport-point-audit/verified-winners-v2'/f'{v}-baseline.json'));cov=np.zeros(fg.shape,bool)
 for q in ww['points']:cov[q['y'],q['x']]=True
 alpha=np.asarray(Image.open(REF/'images'/f'foreground-{v}.png'))[...,3]
 ds={}
 for arm in ['off','on']:
  b,c=[np.fromfile(A/arm/'private-partial'/f'native-{v}-{case}.u16le','<u2').reshape(135,240) for case in ['baseline','direction']]
  def decode(a):return np.stack([((a>>11)&31)/31,((a>>5)&63)/63,(a&31)/31],-1)
  delta=(decode(c)-decode(b))@np.array([.2126,.7152,.0722]);inactive=(abs(delta)<=2/255)&fg&(m['bright']|m['dark']);ds[arm]={}
  for key,domain in {'all':fg,'coveredInterior':cov&~tar&fg,'opaqueCoveredInterior':cov&~tar&(alpha==255),'coveredBoundary':cov&tar&fg,'missing':~cov&fg}.items():
   use=inactive&domain;ds[arm][key]={'activeToInactive':int(use.sum()),'bothWhite565':int((use&(b==65535)&(c==65535)).sum()),'bothBlack565':int((use&(b==0)&(c==0)).sum()),'identical565':int((use&(b==c)).sum())}
 out['directionQuantizationEndpointDiagnostics'][v]=ds
(D/'background-contract.json').write_text(json.dumps(out,indent=2));print(json.dumps(out['directionQuantizationEndpointDiagnostics'],indent=2))
