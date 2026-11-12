import pathlib,json,ctypes,numpy as np
R=pathlib.Path(__file__).resolve().parents[1];S=R.parent/'fox-v3-lighting-ab/four-both-002';O=R/'observer';lib=ctypes.CDLL(str(R/'shader_probe.so'));D=ctypes.POINTER(ctypes.c_double);lib.init.argtypes=[ctypes.c_char_p];lib.shade.argtypes=[D,D,ctypes.c_uint,ctypes.POINTER(ctypes.c_ushort),D]
comp=json.loads((S/'model-baseline/compile.json').read_text());albedo={m['id']:m['albedo565'] for m in comp['materialTrace']};report={};controls=[]
def transform(p,position):
 a=p.copy()
 if position:a/=38
 return np.array([a[0],-a[2],-a[1]],dtype=np.float64)
def shade(p,n,c):
 raw=np.empty(3,np.float64);out=ctypes.c_ushort();assert lib.shade(p.ctypes.data_as(D),n.ctypes.data_as(D),c,ctypes.byref(out),raw.ctypes.data_as(D))==1
 return out.value,raw
for view in ['front','oblique']:
 for case in ['baseline','direction']:
  assert lib.init(str(S/f'physical-{case}.txt').encode())==1
  a=np.fromfile(O/f'native-{view}-{case}.observer.f32',np.float32).reshape(135,240,16);verts=np.fromfile(O/f'native-{view}-{case}.vertices.f64',np.float64).reshape(3,256,32,3);sides=np.fromfile(O/f'native-{view}-{case}.sides.u8',np.uint8).reshape(256,64)
  remap=np.fromfile(O/f'native-{view}-{case}.map.u8',np.uint8).reshape(256,32)
  out=np.zeros((135,240),np.uint16);rawout=np.zeros((135,240,3));positions=np.full((135,240,3),np.nan);normals=positions.copy();cache={};bad=[]
  for y,x in np.argwhere(a[...,15]>0):
   row=a[y,x];node=int(row[0]);face=int(row[1]);side=int(sides[node,face]);compact_ids=row[3:6].astype(int);ids=remap[node,compact_ids].astype(int);assert np.array_equal(ids,compact_ids),'nonidentity remap in current fixture';w=row[6:9].astype(float);rho=albedo[comp['parts'][node-1]['materialId']]
   pp=np.array([transform(verts[0,node,i],True) for i in ids]);nn=np.array([transform(verts[1+side,node,i],False) for i in ids])
   for j,vid in enumerate(ids):
    key=(node,int(vid),side)
    if key not in cache:cache[key]=shade(pp[j],nn[j],rho)[0]
    if cache[key]!=int(row[9+j]):bad.append([int(y),int(x),*key,cache[key],int(row[9+j])])
   p=np.sum(pp*w[:,None],axis=0);n=np.sum(nn*w[:,None],axis=0);out[y,x],rawout[y,x]=shade(p,n,rho);positions[y,x]=p;normals[y,x]=n
  controls.append({'view':view,'case':case,'uniqueVertexQueries':len(cache),'controlMismatches':len(bad),'examples':bad[:4]})
  if bad:raise ValueError(controls[-1])
  out.astype('<u2').tofile(R/f'pixel-{view}-{case}.u16le');np.savez_compressed(R/f'pixel-{view}-{case}.npz',position=positions,normal=normals,raw=rawout,coverage=a[...,15]>0)
(R/'pixel-control.json').write_text(json.dumps(controls,indent=2));print(controls)
