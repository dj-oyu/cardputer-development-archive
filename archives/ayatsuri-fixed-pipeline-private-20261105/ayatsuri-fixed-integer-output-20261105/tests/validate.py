from pathlib import Path
import ctypes as C,numpy as np,json,math
R=Path(__file__).resolve().parents[1];W=R.parent
lib=C.CDLL(str(R/'private/test.so'));assert lib.setup()
lib.batch.argtypes=[C.c_void_p,C.c_uint]+[C.c_void_p]*5
lib.shape_code.argtypes=[C.c_uint32];lib.shape_code.restype=C.c_uint32
pins=json.loads((R/'private/PINS.json').read_text()); hi=pins['constants']['AGX_HI'];lo=pins['constants']['AGX_LO'];lr=pins['constants']['AGX_LOG_RANGE']
def compare(x,name,recorded=None):
 x=np.ascontiguousarray(x,np.float64).reshape(-1,3);n=len(x)
 old=np.zeros(n,np.uint16);neo=old.copy();same=old.copy();codes=np.zeros((n,3),np.uint32);status=np.zeros(n,np.int32)
 lib.batch(x.ctypes.data,n,old.ctypes.data,neo.ctypes.data,same.ctypes.data,codes.ctypes.data,status.ctypes.data)
 def diff(a,b):
  d=np.stack([abs(((a>>s)&m).astype(int)-((b>>s)&m).astype(int)) for s,m in [(11,31),(5,63),(0,31)]],axis=1)
  return {'changed_pixels':int(np.count_nonzero(a!=b)),'max_channel_code_delta':d.max(axis=0).tolist(),'sum_absolute_channel_code_delta':d.sum(axis=0).tolist()}
 return {'baseline_vs_saved_changed_pixels':None if recorded is None else int(np.count_nonzero(old!=recorded)), 'name':name,'pixels':n,'hdr_max':float(x.max()),'integer_vs_original':diff(neo,old),'integer_vs_original_at_quantized_input':diff(neo,same),'input_quantization_only':diff(same,old),'status_counts':{str(k):int(v) for k,v in zip(*np.unique(status,return_counts=True))}}
files=sorted((W/'fox-v3-indexed-bvh-bounds/actual-on-001').glob('*.hdr.f64le'))+sorted((W/'fox-v3-indexed-bvh-bounds/actual-off-001').glob('*.hdr.f64le'))
rows=[]
for p in files:
 rows.append(compare(np.fromfile(p,dtype='<f8'),str(p.relative_to(W)),np.fromfile(str(p).replace('.hdr.f64le','.u16le'),dtype='<u2')));print(rows[-1]['name'],rows[-1]['integer_vs_original'],flush=True)
# Boundary inputs include all tetrahedral axis permutations/ties, code steps,
# all source LUT knots and adjacent double values, zero, profile clamp, UQ max.
vals=[0,2**-20,2**-19,hi-2**-19,hi,hi+2**-19,(2**32-1)/2**19]
vals += [lo*math.expm1(k*lr/64) for k in range(65)]
vals=np.asarray(vals);vals=np.unique(np.clip(np.concatenate([vals,np.nextafter(vals,0),np.nextafter(vals,np.inf)]),0,(2**32-1)/2**19))
triples=[]
for v in vals:
 for t in [(v,v,v),(v,0,0),(0,v,0),(0,0,v),(v,v,0),(v,0,v),(0,v,v)]:triples.append(t)
rng=np.random.default_rng(20261105)
triples.extend(np.exp(rng.uniform(math.log(2**-20),math.log(8191.99),(30000,3))))
rows.append(compare(triples,'synthetic_boundaries_and_log_random'))
# Scalar shaper: sample each integer code in first262144 and endpoints/midpoints
# of every segment; analytically bounded interpolation error elsewhere.
check=set(range(262145))
for e in range(8,32):
 for k in range(256,512):
  a=k*2**(e-8);b=(k+1)*2**(e-8)
  for x in [a,a+1,(a+b)//2,b-1,b]:
   if x<=2**32-1:check.add(x)
check=np.array(sorted(check),np.uint32);got=np.array([lib.shape_code(int(x)) for x in check],np.uint32)
expected=np.log1p(np.minimum(check.astype(float)/524288,hi)/lo)/lr*64
err=np.abs(got/65536-expected)
res={'format':'UQ13.19','rounding_input':'ties-to-even','shaper_checked_codes':len(check),'shaper_monotone_on_sorted_checked_codes':bool(np.all(got[1:]>=got[:-1])),'max_sampled_coordinate_error_excluding_input_quantization':float(err.max()),'all_rows':rows,'actual_images':len(files),'actual_pixels':sum(r['pixels'] for r in rows[:-1]),'actual_changed_pixels':sum(r['integer_vs_original']['changed_pixels'] for r in rows[:-1]),'actual_max_channel_code_delta':np.max([r['integer_vs_original']['max_channel_code_delta'] for r in rows[:-1]],axis=0).tolist()}
(R/'private/RESULTS.json').write_text(json.dumps(res,indent=2));print(json.dumps({k:v for k,v in res.items() if k!='all_rows'},indent=2))
