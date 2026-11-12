import pathlib,struct,json,hashlib,numpy as np
R=pathlib.Path('/workspace/scratch/6d8dcdbcdc54'); O=R/'ayatsuri-fixed-pipeline-20261105/quality'; B=R/'fox-v3-indexed-bvh-bounds'; I=R/'fox-v3-floor-direct-reflection-evaluation/actual-002'
def stats(a):
 a=np.asarray(a,dtype=np.float64);return dict(count=int(a.size),min=float(a.min()),max=float(a.max()),nonfinite=int((~np.isfinite(a)).sum()))
def quant(a,scale,lo,hi):
 a=np.asarray(a,dtype=np.float64);q=np.floor(a*scale+0.5);v=q/scale;err=np.abs(v-a);return dict(scale=scale,range=[lo/scale,hi/scale],overflow_count=int(((q<lo)|(q>hi)).sum()),changed_count=int((v!=a).sum()),max_abs=float(err.max()),rms=float(np.sqrt(np.mean(err*err))))
def qset(a):return {str(f):quant(a,2**f,-2**31,2**31-1) for f in [12,16,20,24]}
res={};p=I/'compiled/model-baseline/model.aynm';data=p.read_bytes();sections={}
for k in range(struct.unpack_from('<I',data,12)[0]):
 typ,flags,off,length,count,stride=struct.unpack_from('<HHIIII',data,32+20*k);sections[typ]=(off,count,stride)
o,n,s=sections[10];cold=np.array([struct.unpack_from('<7f',data,o+k*s) for k in range(n)])
res['model']={'sha256':hashlib.sha256(data).hexdigest(),'vertices':n,'sections':sections,'local_xyz':stats(cold[:,:3]),'normal_xyz':stats(cold[:,3:6]),'mask':stats(cold[:,6]),'local_quant':qset(cold[:,:3])}
# All current 20 scenarios per arm: 2 cameras x 5 light/material cases x forward/reverse.
world=[];screen=[];depth=[];norm=[];palettes=[];lights=[];hdr=[];files=[];records=tris=verts=0;modecounts={}
for arm in ['actual-on-001','actual-off-001']:
 for p in sorted((B/arm).glob('*.snapshot')):
  d=p.read_bytes();assert len(d)>=416;lights.append(np.frombuffer(d[8:416],dtype='<f8').reshape(-1).copy());at=416;nr=nvtotal=nttotal=0
  while at<len(d):
   nv,nt,mode,z,node,z2,col,size=struct.unpack_from('<BBBBHHHH',d,at);assert mode in [4,5];stride=56 if mode==4 else 50;assert size==(12+nv*stride+3*nt+(nt+7)//8+3)//4*4
   modecounts[mode]=modecounts.get(mode,0)+1
   for k in range(nv):
    v=at+12+k*stride;x,y,mask,dep,a,b=struct.unpack_from('<4fHH',d,v);screen.append([x,y]);depth.append(dep);palettes.extend([a,b]);world.append(struct.unpack_from('<3d',d,v+20));front=struct.unpack_from('<3h',d,v+44);back=struct.unpack_from('<3h',d,v+50) if mode==4 else tuple(-z for z in front);norm.extend([front,back])
   at+=size;nr+=1;nvtotal+=nv;nttotal+=nt
  assert at==len(d);records+=nr;verts+=nvtotal;tris+=nttotal
  h=p.with_suffix('.hdr.f64le');v=np.fromfile(h,dtype='<f8');assert v.size==97200;assert json.loads(p.with_suffix('.hdr-observer.json').read_text())['complete'];hdr.append(v);files.append({'snapshot':str(p.relative_to(R)),'sha256':hashlib.sha256(d).hexdigest(),'vertices':nvtotal,'triangles':nttotal,'records':nr,'hdr':str(h.relative_to(R))})
world=np.array(world);norm=np.array(norm);hdr=np.concatenate(hdr);lights=np.array(lights);lightfields={}
for name,start,end in [('center',0,3),('normal',3,6),('axis_u',6,9),('axis_v',9,12),('power_rgb_over_pi_squared',12,15),('radius',15,16)]:lightfields[name]=stats(lights[:,:48].reshape(-1,16)[:,start:end])
res['snapshot']={'files':len(files),'records_including_repeated_cases':records,'vertices_including_repeated_cases':verts,'triangles_including_repeated_cases':tris,'modes':modecounts,'world_native_xyz':stats(world),'screen_xy':stats(screen),'depth':stats(depth),'snorm16':stats(norm),'world_quant':qset(world),'screen_quant':qset(screen),'normal_requant_q15':quant(norm/32767,32768,-32768,32767),'normal_len':stats(np.linalg.norm(norm/32767,axis=1)),'lights':lightfields,'world_radiance':stats(lights[:,48:51])}
res['hdr']={'stats':stats(hdr),'quant':{str(f):quant(hdr,2**f,0,2**32-1) for f in [16,20,24]},'percentiles':{str(q):float(np.quantile(hdr,q)) for q in [.5,.95,.99,1]}}
mats=json.loads((I/'inputs/source-materials.json').read_text())['materials'];rho=np.array([m['baseColor'][:3] for m in mats.values()]);res['source_materials']={'materials':len(mats),'linear_base_rgb':stats(rho),'unorm16':quant(rho,65535,0,65535)}
# Decode RGB565 palette using float32 arithmetic/pow approximation; not a promise of C powf bit parity.
pal=np.unique(palettes);enc=np.array([[(c>>11)/31,((c>>5)&63)/63,(c&31)/31] for c in pal],dtype=np.float32);lin=np.where(enc<=np.float32(.04045),enc/np.float32(12.92),((enc+np.float32(.055))/np.float32(1.055))**np.float32(2.4))
res['palette']={'codes':len(pal),'linear_rgb':stats(lin),'unorm16':quant(lin,65535,0,65535)}
res['files']=files
(O/'measurements.json').write_text(json.dumps(res,indent=2)+'\n');print(json.dumps({k:v for k,v in res.items() if k!='files'},indent=2))
# GLB storage coordinates only (not asserted to be Blender world before node/basis transforms).
glb=(I/'inputs/geometry-source-sided.glb').read_bytes();jn,jt=struct.unpack_from('<II',glb,12);g=json.loads(glb[20:20+jn]);bn,bt=struct.unpack_from('<II',glb,20+jn);binary=glb[28+jn:28+jn+bn]; pos=[]; nr=[]
for mesh in g['meshes']:
 for prim in mesh['primitives']:
  for key,target in [('POSITION',pos),('NORMAL',nr)]:
   a=g['accessors'][prim['attributes'][key]];assert a['componentType']==5126 and a['type']=='VEC3' and 'sparse' not in a
   bv=g['bufferViews'][a['bufferView']];off=bv.get('byteOffset',0)+a.get('byteOffset',0);stride=bv.get('byteStride',12)
   target.extend(struct.unpack_from('<3f',binary,off+k*stride) for k in range(a['count']))
res['glb']={'sha256':hashlib.sha256(glb).hexdigest(),'positions':stats(pos),'normals':stats(nr),'source_xyz_quant':qset(pos),'mesh_count':len(g['meshes'])}
(O/'measurements.json').write_text(json.dumps(res,indent=2)+'\n');print('GLB',json.dumps(res['glb'],indent=2))
v=np.rint(rho*32767)/32767;e=np.abs(v-rho)
res['source_materials']['unorm15_ties_even']={'range':[0,1],'divisor':32767,'rounding':'ties-even','count':int(rho.size),'changed_count':int((v!=rho).sum()),'max_abs':float(e.max()),'rms':float(np.sqrt((e*e).mean()))}
(O/'measurements.json').write_text(json.dumps(res,indent=2)+'\n')
