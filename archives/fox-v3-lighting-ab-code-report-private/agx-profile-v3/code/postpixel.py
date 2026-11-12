from pathlib import Path
import sys,json,hashlib,ctypes,time,numpy as np
from PIL import Image
R=Path(__file__).resolve().parents[1];W=R.parent;D=Path(sys.argv[1]).resolve();D.mkdir(parents=True,exist_ok=False)
REF=W/'fox-reference-uncertainty-v3';INPUT=W/'fox-v3-position-diagnostic/weighted-aa';sys.path.insert(0,str(REF/'code'));import evaluator as E
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
lib=ctypes.CDLL(str(R/'profile-buffer.so'));lib.profile_buffer.argtypes=[ctypes.c_void_p,ctypes.c_void_p,ctypes.c_size_t,ctypes.c_uint,ctypes.POINTER(ctypes.c_ulong)]
cfg=json.loads((REF/'input/config.json').read_text());m=json.loads((REF/'render-manifest.json').read_text());lookup={(x['seed'],x['view'],x['case']):x for x in m['images']};hashes={str(p):sha(p) for p in [Path(__file__),R/'code/profile_buffer.c',R/'profile/agx_profile.c',R/'profile/agx_profile.h',R/'profile/agx_lut.inc',R/'profile-buffer.so',R/'product/main/ayatsuri/ayatsuri_shade.h',REF/'code/evaluator.py',REF/'input/config.json',REF/'render-manifest.json']};result={};cost=[]
def rgb(u):return np.stack([(u>>11)/31,((u>>5)&63)/63,(u&31)/31],-1)
for view in ['front','oblique']:
 refs={};images={0:{},1:{}}
 for case in ['baseline','direction']:
  old=INPUT/f'grid3-{view}-{case}.u16le';hashes[str(old)]=sha(old);p=INPUT/f'grid3-{view}-{case}.npz';hashes[str(p)]=sha(p);a=np.load(p);raw=np.ascontiguousarray(a['raw'],np.float64);assert raw.shape==(135,240,3);mask=a['coverage'];assert raw[~mask].max(initial=0)==0
  refs[case]=[]
  for seed in cfg['seeds']:
   row=lookup[(seed,view,case)];p=REF/row['file'];assert sha(p)==row['sha256'];hashes[str(p)]=sha(p);refs[case].append(np.array(Image.open(p))[...,:3])
  refs[case]=np.stack(refs[case])
  for enabled in [0,1]:
   u=np.zeros((135,240),np.uint16);cl=ctypes.c_ulong();t=time.perf_counter_ns();assert lib.profile_buffer(raw.ctypes.data,u.ctypes.data,u.size,enabled,ctypes.byref(cl))==1;elapsed=time.perf_counter_ns()-t
   # Source diagnostic encodes only covered pixels. Preserve that background rule.
   u[~mask]=0
   if not enabled:assert np.array_equal(u,np.fromfile(INPUT/f'grid3-{view}-{case}.u16le','<u2').reshape(135,240)),'OLD_POSTPIXEL_OFF_NOT_EXACT'
   u.astype('<u2').tofile(D/f'{view}-{case}-profile{enabled}.u16le');images[enabled][case]=rgb(u);cost.append({'view':view,'case':case,'profile':enabled,'clampedPixels':cl.value,'firstCallNs':elapsed,'HDRBytes':raw.nbytes,'colorBytes':u.nbytes})
 fgrow=m['foreground'][view];p=REF/fgrow['file'];assert sha(p)==fgrow['sha256'];hashes[str(p)]=sha(p);fg=np.array(Image.open(p))[...,3]>0;result[view]={}
 for enabled in [0,1]:
  response,masks=E.evaluate_response_png8(refs['baseline'],refs['direction'],fg,images[enabled]['baseline'],images[enabled]['direction']);result[view][str(enabled)]={'response':response,'color':{c:E.evaluate_color_png8(refs[c],fg,images[enabled][c])[0] for c in refs}}
assert all(sha(Path(p))==h for p,h in hashes.items())
(D/'evaluation.json').write_text(json.dumps(result,indent=2,allow_nan=False));(D/'cost.json').write_text(json.dumps(cost,indent=2));(D/'input-hashes.json').write_text(json.dumps(hashes,indent=2));(D/'scope.json').write_text(json.dumps({'scope':'Host grid3 per-pixel physical + direct visibility + BH filter, transform after HDR average; distinct from vertex product AB','fourCasesOnly':True,'offBytesExact':True,'originalReferenceUnchanged':True,'productHDRStorageImplemented':False},indent=2))

(D/'build-command.txt').write_text('cc -std=c11 -O2 -shared -fPIC -ffp-contract=off -fexcess-precision=standard -I fox-v3-agx-profile/profile -I fox-v3-agx-profile/product/main fox-v3-agx-profile/code/profile_buffer.c fox-v3-agx-profile/profile/agx_profile.c -lm -o fox-v3-agx-profile/profile-buffer.so\n')
