"""Generate local-private profile fixtures; no renderer or external writes."""
from pathlib import Path
import hashlib,json,numpy as np
R=Path(__file__).resolve().parent; W=R.parents[1]; B=R/'private';B.mkdir(exist_ok=True)
S=W/'fox-v3-profile-integration-feasibility/build-private';pins={}
def pin(p):pins[str(p.relative_to(W))]=hashlib.sha256(p.read_bytes()).hexdigest()
for name in ('agx_profile.c','agx_profile.h','agx_lut.inc'):pin(S/name)
src=(S/'agx_profile.c').read_text(); hdr=(S/'agx_profile.h').read_text()
(R/'agx_profile.h').write_text(hdr)
# Original constants are copied verbatim, without retaining the original node array.
constants='\n'.join((S/'agx_lut.inc').read_text().splitlines()[:4])+'\n'
blob=W/'fox-v3-lossless-profile-lut/research/private/agx_cube4_rice.bin';pin(blob)
raw=blob.read_bytes()
(B/'profile_data.h').write_text(constants+'#include <stdint.h>\nstatic const uint8_t agx_encoded[]={\n'+''.join(','.join(map(str,raw[i:i+32]))+',\n' for i in range(0,len(raw),32))+'};\n')
src=src.replace('#include "agx_lut.inc"','#include "profile_data.h"\n#include <stddef.h>\nint lossless_fetch(const uint8_t*,size_t,uint32_t,uint16_t[3]);\n#define AGX_PROFILE_DECODE_ERROR 3')
needle=' float result[3];for(int c=0;c<3;c++)result[c]=((float)agx_lut[ix*3+c]/65535.0f);'
replacement=' uint16_t vertex[4][3]; int fetch_ix=ix;\n for(int k=0;k<4;k++){if(!lossless_fetch(agx_encoded,sizeof agx_encoded,(uint32_t)fetch_ix,vertex[k]))return AGX_PROFILE_DECODE_ERROR;if(k<3)fetch_ix+=stride[order[k]];}\n float result[3];for(int c=0;c<3;c++)result[c]=((float)vertex[0][c]/65535.0f);'
assert needle in src;src=src.replace(needle,replacement)
src=src.replace('agx_lut[nx*3+c]','vertex[k+1][c]').replace('agx_lut[ix*3+c]','vertex[k][c]')
assert 'agx_lut' not in src
(R/'candidate_profile.c').write_text(src)
# Every published holdout input, unchanged. No original image or geometry input.
p=W/'fox-v3-agx-profile/profile/samples.npy';pin(p);groups={'retained_synthetic':np.load(p).astype(np.float32)}
lo=0.00017578139478918766; hi=5898.2400001325132; lr=17.328678720134185
axis=(lo*np.expm1(np.arange(65,dtype=np.float64)*lr/64)).astype(np.float32)
groups['all_grid_nodes']=np.stack(np.meshgrid(axis,axis,axis,indexing='ij'),axis=-1).reshape(-1,3)
rows=[]
for x in axis:
 for v in (np.nextafter(x,np.float32(-np.inf)),x,np.nextafter(x,np.float32(np.inf))):
  for c in range(3):
   z=[x,x,x];z[c]=v;rows.append(z)
for x in (np.float32(0),np.float32(-0.),np.float32(hi),np.nextafter(np.float32(hi),np.float32(0)),np.nextafter(np.float32(hi),np.float32(np.inf)),np.finfo(np.float32).max):
 for c in range(3):
  z=[0.,0.,0.];z[c]=x;rows.append(z)
groups['nextafter_endpoints_ties']=np.asarray(rows,np.float32)
rng=np.random.default_rng(20261104)
groups['seeded_log_hdr']=(lo*np.expm1(rng.random((50000,3))*lr*1.2)).astype(np.float32)
groups['seeded_all_positive_float_bits']=rng.integers(0,0x7f800000,(50000,3),dtype=np.uint32).view(np.float32)
rows=[]
for v in (-1.,-1e-30,np.nan,np.inf,-np.inf):
 for c in range(3):
  z=[0.,0.,0.];z[c]=v;rows.append(z)
groups['invalid_atomic']=np.asarray(rows,np.float32)
np.savez(B/'synthetic.npz',**groups)
frames=[]
for arm in ('off','on'):
 d=W/f'fox-v3-aa-phase-overlay/actual-{arm}-001';manifest=d/'COMPLETED.json';pin(manifest)
 records=json.loads(manifest.read_text())['frames'];assert len(records)==20
 for row in records:
  h=d/(row['name']+'.hdr.f64le');q=d/(row['name']+'.u16le');pin(h);pin(q)
  assert pins[str(h.relative_to(W))]==row['files']['.hdr.f64le']
  assert pins[str(q.relative_to(W))]==row['files']['.u16le']
  a=np.fromfile(h,'<f8').reshape(-1,3);assert a.shape==(32400,3) and np.isfinite(a).all() and (a>=0).all() and (a<=np.finfo(np.float32).max).all()
  frames.append({'name':arm+'/'+row['name'],'hdr':str(h),'expected565':str(q),'pixels':len(a)})
with (B/'all_inputs.f32le').open('wb') as f:
 for a in groups.values():f.write(a.tobytes())
 for row in frames:f.write(np.fromfile(row['hdr'],'<f8').astype('<f4').tobytes())
(R/'INPUTS.json').write_text(json.dumps({'pins':pins,'groups':{k:len(v) for k,v in groups.items()},'frames':frames,'encodedBlobBytes':len(raw),'syntheticSeed':20261104},indent=2)+'\n')
print('Prepared',sum(map(len,groups.values())),'synthetic +',len(frames)*32400,'retained HDR pixels')
