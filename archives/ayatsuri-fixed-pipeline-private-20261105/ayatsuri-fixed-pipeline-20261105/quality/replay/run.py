import pathlib,json,struct,ctypes,hashlib,sys,importlib.util,numpy as np
R=pathlib.Path('/workspace/scratch/6d8dcdbcdc54');O=pathlib.Path(__file__).resolve().parent;F=R/'ayatsuri-fixed-pipeline-20261105';B=R/'fox-v3-indexed-bvh-bounds';src=F/'source-adapter/private-fixed-source.json';source=json.loads(src.read_text())
# Load pure AYFQ validator without writing importer caches outside our directory.
spec=importlib.util.spec_from_file_location('fixed',F/'converter/compile_fixed.py');mod=importlib.util.module_from_spec(spec);sys.dont_write_bytecode=True;spec.loader.exec_module(mod)
ay=mod.decode((F/'converter/results/private/from-glb-q16.ayfq').read_bytes());ay20=mod.decode((F/'converter/results/private/from-glb-q20.ayfq').read_bytes());assert ay['materials']==ay20['materials'];assert all(a['normals']==b['normals'] for a,b in zip(ay['parts'],ay20['parts']))
model=(R/'fox-v3-floor-direct-reflection-evaluation/actual-002/compiled/model-baseline/model.aynm').read_bytes();sec={}
for i in range(struct.unpack_from('<I',model,12)[0]):
 t,flags,off,l,n,s=struct.unpack_from('<HHIIII',model,32+i*20);sec[t]=(off,n,s)
def row(t,i):
 off,n,s=sec[t];assert i<n;return model[off+i*s:off+(i+1)*s]
nodepart={};mapping=[]
for node in range(sec[1][1]):
 nd=row(1,node)
 if nd[2]!=3:continue
 pi=struct.unpack_from('<H',nd,4)[0];p=source['parts'][pi];a=ay['parts'][pi];d=row(9,pi);first,n,ft,nt=struct.unpack_from('<4H',d);assert n==len(p['positions'])==len(a['positions']);assert nt==len(p['triangles']);assert a['triangles']==p['triangles']
 for j in range(n):
  cold=row(10,first+j);assert cold[:12]==struct.pack('<3f',*(v*38 for v in p['positions'][j])),('position mapping',node,j)
  assert cold[12:24]==struct.pack('<3f',*p['normals'][j]),('normal mapping',node,j)
 for j in range(nt):assert list(struct.unpack('<3H',row(11,ft+j)))==p['triangles'][j]
 assert a['double_sided']==(p['materialSidedness']=='double');assert source['materialTrace'][a['material_index']]['id']==p['materialId'];assert struct.unpack('<9f',row(2,node))==(0.,0.,0.,0.,0.,0.,1.,1.,1.),('nonidentity pose',node)
 nodepart[node]=pi;mapping.append({'node':node,'part':pi,'materialId':p['materialId'],'vertices':n,'triangles':nt})
assert len(mapping)==54
# Whole-snapshot coordinate and normal identity validates the source corner association.
ss=(B/'actual-on-001/native-front-baseline.snapshot').read_bytes();at=416;normal_code_changes=0;records_checked=0
while at<len(ss):
 nv,nt,mode=struct.unpack_from('<3B',ss,at);node=struct.unpack_from('<H',ss,at+4)[0];size=struct.unpack_from('<H',ss,at+10)[0];pi=nodepart[node];p=source['parts'][pi];a=ay['parts'][pi];stride=50 if mode==5 else 56;assert nv==len(p['positions']) and nt==len(p['triangles'])
 for v in range(nv):
  pos=struct.unpack_from('<3d',ss,at+12+stride*v+20);expected=struct.unpack('<3f',struct.pack('<3f',*(x*38 for x in p['positions'][v])));assert pos==expected
  n=struct.unpack_from('<3h',ss,at+12+stride*v+44);normal_code_changes+=sum(x!=y for x,y in zip(n,a['normals'][v]))
 at+=size;records_checked+=1
assert records_checked==54 and at==len(ss)
snapshot=B/'actual-on-001/native-front-baseline.snapshot';cap=R/'fox-v3-floor-world-reflection/capture/on/native-front-baseline.samples.jsonl';data=snapshot.read_bytes();assert data==(cap.parent/'native-front-baseline.snapshot').read_bytes();buf=ctypes.create_string_buffer(data)
lib=ctypes.CDLL(str(O/'replay.so'));fun=lib.replay;fun.argtypes=[ctypes.c_void_p,ctypes.c_size_t,*([ctypes.c_uint]*5),ctypes.POINTER(ctypes.c_int16),ctypes.POINTER(ctypes.c_double)];fun.restype=ctypes.c_int
rows=[];orig=[];calc=[];statuses=[];mismatch=[];metadata=[]
for line in cap.open():
 r=json.loads(line)
 if not r['hit']:continue
 pi=nodepart[r['node']];p=source['parts'][pi];a=ay['parts'][pi];ix=p['triangles'][r['face']];v=(ctypes.c_int16*9)(*(k for j in ix for k in a['normals'][j]));out=(ctypes.c_double*21)();status=fun(buf,len(data),r['recordOffset'],r['face'],r['sample'],r['x'],r['y'],v,out);assert status in (1,2),status
 # Establish snapshot record node and topology identity, including compact used-vertex remapping.
 at=416+r['recordOffset'];nv,nt,mode=struct.unpack_from('<3B',data,at);node=struct.unpack_from('<H',data,at+4)[0];assert node==r['node'];assert nv==len(p['positions']);stride=50 if mode==5 else 56
 si=list(data[at+12+stride*nv+3*r['face']:at+12+stride*nv+3*r['face']+3]);assert set(si)==set(ix), (r["node"],r["face"],si,ix)
 # The renderer may reverse triangle winding; source normals follow serialized corner order.
 v=(ctypes.c_int16*9)(*(k for j in si for k in a["normals"][j]));status=fun(buf,len(data),r["recordOffset"],r["face"],r["sample"],r["x"],r["y"],v,out);assert status in (1,2)
 expected=r['P']+r['Ns']+r['rho'];actual=list(out)[3:12]
 for k,(e,c) in enumerate(zip(expected,actual)):
  if struct.pack('<d',e)!=struct.pack('<d',c):mismatch.append({'row':len(orig),'component':k,'expected':e,'actual':c,'abs':abs(e-c)})
 orig.append(expected);calc.append(list(out));statuses.append(status);metadata.append((pi,a['material_index']));rows.append(r)
report={'snapshot_records_mapping_checked':records_checked,'source_ayfq_front_normal_code_differences':normal_code_changes,'sample_rows':9540,'hit_samples':len(orig),'baseline_bitwise_mismatch_components':len(mismatch),'first_mismatches':mismatch[:10],'mapping':mapping,'weight_fallbacks':statuses.count(2)}
(O/'parity.json').write_text(json.dumps(report,indent=2)+'\n')
if mismatch:print(json.dumps(report,indent=2));sys.exit(2)
a=np.array(orig);b=np.array(calc);good=np.array(statuses)==1

def err(x,y):
 d=np.abs(np.asarray(x)-np.asarray(y));return {'components':int(d.size),'changed_components':int((d!=0).sum()),'max_abs':float(d.max()),'mean_abs':float(d.mean()),'rms':float(np.sqrt(np.mean(d*d)))}
def angles(x,y):
 nx=np.linalg.norm(x,axis=1);ny=np.linalg.norm(y,axis=1);valid=(nx>1e-12)&(ny>1e-12);xx=x[valid]/nx[valid,None];yy=y[valid]/ny[valid,None];theta=np.degrees(np.arctan2(np.linalg.norm(np.cross(xx,yy),axis=1),np.sum(xx*yy,axis=1)));return {'original_nearzero_le_1e_12':int((nx<=1e-12).sum()),'candidate_nearzero_le_1e_12':int((ny<=1e-12).sum()),'valid_samples':int(valid.sum()),'max_degrees':float(theta.max()),'rms_degrees':float(np.sqrt(np.mean(theta*theta))),'min_original_length':float(nx.min())}
report['baseline_reconstruction']={k:err(a[:,i:i+3],b[:,3+i:6+i]) for k,i in [('P_metres',0),('Ns',3),('rho',6)]}
report['A_existing_palette']={'normal':err(a[good,3:6],b[good,12:15]),'normal_angle':angles(a[good,3:6],b[good,12:15]),'rho':err(a[good,6:9],b[good,15:18]),'P_metres':err(a[good,:3],b[good,3:6])}
sourcefun=lib.source_rho;sourcefun.argtypes=[ctypes.POINTER(ctypes.c_double),ctypes.POINTER(ctypes.c_int16),ctypes.POINTER(ctypes.c_double)];sourcefun.restype=ctypes.c_int
new=[]
for values,(pi,mi) in zip(b,metadata):
 w=(ctypes.c_double*3)(*values[:3]);m=(ctypes.c_int16*3)(*ay['materials'][mi]);out=(ctypes.c_double*3)();assert sourcefun(w,m,out)==1;new.append(list(out))
new=np.array(new);assert np.array_equal(new,np.array([np.array(ay['materials'][mi])/32767 for pi,mi in metadata]));newref=np.array([source['materialTrace'][mi]['scaledLinear'] for pi,mi in metadata])
report['B_source_linear']={'rho_quantization_vs_source':err(newref,new),'rho_total_change_vs_legacy':err(a[:,6:9],new),'normal_source_ayfq_vs_legacy':err(a[good,3:6],b[good,18:21]),'normal_angle':angles(a[good,3:6],b[good,18:21]),'P_metres':err(a[good,:3],b[good,3:6]),'constant_part_material':True,'material_identity_proven':True}
report['provenance']={str(p.relative_to(R)):hashlib.sha256(p.read_bytes()).hexdigest() for p in [snapshot,cap,src,F/'converter/results/private/from-glb-q16.ayfq',F/'converter/results/private/from-glb-q20.ayfq',F/'kernel/fixed_kernel.h',O/'run.py',B/'private-build/product/main/ayatsuri/compact_opaque.c',B/'private-build/product/main/ayatsuri/ayatsuri_shade.h',B/'private-build/product/main/ui/kasane/ksn_aa_rho_affine.h',B/'private-build/product/main/ui/kasane/ksn_mesh_depth.c',B/'private-build/product/main/ui/kasane/ksn_boundary_aa_impl.inc',O/'replay.c',O/'edge_extract.h',O/'replay.so']}
(O/'results.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:v for k,v in report.items() if k not in ('mapping','provenance')},indent=2))
