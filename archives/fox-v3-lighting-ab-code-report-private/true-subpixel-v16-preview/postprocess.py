from pathlib import Path
import json,hashlib,ctypes as C,subprocess,numpy as np
from PIL import Image
R=Path(__file__).resolve().parent;D=R/'run-001';O=R/'preview-001';O.mkdir(exist_ok=False);sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();done=json.loads((D/'COMPLETED.json').read_text());assert done['centerOldRGBDepthExact'];files=[D/'COMPLETED.json',R/'postprocess.py',R/'encode.c',R/'product/main/ayatsuri/ayatsuri_shade.h']
for f in done['frames']:
 for n,h in f['files'].items():assert sha(D/n)==h;files.append(D/n)
pins={str(p):sha(p) for p in files};so=O/'encode.so';cmd=['cc','-std=c11','-O2','-shared','-fPIC','-ffp-contract=off','-fexcess-precision=standard','-I',str(R/'product/main'),str(R/'encode.c'),'-lm','-o',str(so)];subprocess.run(cmd,check=True);lib=C.CDLL(str(so));lib.encode.argtypes=[C.POINTER(C.c_double),C.POINTER(C.c_uint16),C.c_size_t];lib.encode.restype=C.c_int
raws={f['name']:np.fromfile(D/(f['name']+'-combined.f64le'),'<f8').reshape(135,240,3) for f in done['frames']};average=sum(raws[n] for n in ['m_m','p_m','m_p','p_p'])/4;coverage=sum(np.isfinite(np.fromfile(D/(n+'.f32le'),'<f4').reshape(135,240)).astype(np.float64) for n in ['m_m','p_m','m_p','p_p'])/4;np.save(O/'coverage.npy',coverage)
outputs={}
for name,raw in [('point',raws['center']),('subpixel4',average)]:
 raw=np.ascontiguousarray(raw,dtype=np.float64);out=np.empty((135,240),dtype=np.uint16);assert lib.encode(raw.ctypes.data_as(C.POINTER(C.c_double)),out.ctypes.data_as(C.POINTER(C.c_uint16)),32400)==1
 if name=='point':assert out.tobytes()==(D/'center.u16le').read_bytes()
 out.tofile(O/(name+'.u16le'));rgb=np.stack([((out>>11)&31)/31,((out>>5)&63)/63,(out&31)/31],axis=-1);png=O/(name+'.png');Image.fromarray(np.floor(rgb*255+.5).astype(np.uint8)).save(png);outputs[name]={'png':str(png),'sha256':sha(png),'rgb565SHA256':sha(O/(name+'.u16le'))}
assert all(sha(Path(p))==h for p,h in pins.items());(O/'manifest.json').write_text(json.dumps({'outputs':outputs,'inputHashes':pins,'compileCommand':cmd,'encoderSHA256':sha(so),'centerEncodingExact':True,'sumHostRenderNsSubpixel4':sum(f['metadata']['hostRenderNsFirstFrame'] for f in done['frames'] if f['name']!='center'),'coveragePixels':{str(v):int((coverage==v).sum()) for v in [0,.25,.5,.75,1]},'scope':'four genuine subpixel evaluations; mean linear HDR including black/nohit before sRGB565; no new reference score; not product AA integration'},indent=2));print(json.dumps(outputs))
