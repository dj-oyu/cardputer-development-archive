import bpy,json,pathlib,struct,hashlib,collections,copy,math,numpy as np
R=pathlib.Path('/workspace/scratch/6d8dcdbcdc54');P=R/'fox-v3-eye-local-lod';SRC=R/'fox-reference-sculpt-private/fox-reference-standing-editable.blend';BASE=R/'fox-v3-occlusion-reduction/stage-2.glb';sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(SRC)=='9254eaebdfa61143dfdb9480330bc677ae47acfa710715bbfa31ab2943a16806';assert sha(BASE)=='794b4d5bc8e0c470170a41bdff0bd3775624e4bb8807972ebd7d1b527b78794f'
def read(p):
 b=p.read_bytes();n=struct.unpack_from('<I',b,12)[0];return json.loads(b[20:20+n]),b[28+n:]
bpy.ops.wm.open_mainfile(filepath=str(SRC));roles={'Eye white':np.array([.207,.045,.227]),'Amber iris':np.array([.123,.037,.168]),'Pupil':np.array([.077,.018,.127])};params={}
for side in [-1,1]:
 for role,radii in roles.items():
  name=f'{role} {side}';o=bpy.data.objects[name];assert o.type=='MESH' and len(o.modifiers)==0 and len(o.data.vertices)==922;v=np.array([x.co[:] for x in o.data.vertices]);err=float(abs(np.linalg.norm(v/radii,axis=1)-1).max());assert err<1e-5;mat=np.array(o.matrix_world);assert np.allclose(mat[:3,:3],np.eye(3),rtol=0,atol=1e-12);params[name]={'radii':radii.tolist(),'matrixWorld':mat.tolist(),'sourceNominalEllipsoidMaxNormalizedRadiusResidual':err,'sourceMaterialNames':[m.name for m in o.data.materials]}
(P/'source-parameters.json').write_text(json.dumps({'sourceSha256':sha(SRC),'sourceBuilderSha256':sha(R/'fox-reference-sculpt-private/build_fox.py'),'parameters':params},indent=2))
base,bb=read(BASE);reports=[]
for stage in ['eye-A','eye-B']:
 out=copy.deepcopy(base);buf=bytearray(bb);objects=[];changed=set()
 def append(array,typ,component,target):
  while len(buf)%4:buf.extend(b'\0')
  raw=array.tobytes();vi=len(out['bufferViews']);out['bufferViews'].append({'buffer':0,'byteOffset':len(buf),'byteLength':len(raw),'target':target});buf.extend(raw);ai=len(out['accessors']);a={'bufferView':vi,'componentType':component,'count':len(array),'type':typ}
  if typ=='VEC3':a.update(min=array.min(0).astype(float).tolist(),max=array.max(0).astype(float).tolist())
  out['accessors'].append(a);return ai
 for name,par in params.items():
  iswhite=name.startswith('Eye white');count=8 if stage=='eye-A' or iswhite else 12;angles=[math.pi/4,math.pi/2] if stage=='eye-B' and iswhite else [math.pi/2];r=np.array(par['radii']);m=np.array(par['matrixWorld']);points=[np.array([0.,-r[1],0.])]
  for theta in angles:
   for k in range(count):
    phi=2*math.pi*k/count;points.append(r*np.array([math.sin(theta)*math.cos(phi),-math.cos(theta),math.sin(theta)*math.sin(phi)]))
  back=len(points);points.append(np.array([0.,r[1],0.]));v=np.array(points);tri=[]
  for k in range(count):tri.append([0,1+k,1+(k+1)%count])
  for j in range(len(angles)-1):
   lo=1+j*count;hi=lo+count
   for k in range(count):
    kn=(k+1)%count;tri.extend([[lo+k,hi+k,hi+kn],[lo+k,hi+kn,lo+kn]])
  last=1+(len(angles)-1)*count
  for k in range(count):tri.append([last+k,back,last+(k+1)%count])
  tri=np.array(tri,dtype=np.int64)
  for i,t in enumerate(tri):
   no=np.cross(v[t[1]]-v[t[0]],v[t[2]]-v[t[0]]);grad=(v[t].mean(0)/r**2)
   if np.dot(no,grad)<0:tri[i]=t[[0,2,1]]
  edges=collections.Counter();orient=collections.Counter()
  for t in tri:
   for aa,bb0 in zip(t,np.roll(t,-1)):edges[tuple(sorted((int(aa),int(bb0))))]+=1;orient[int(aa),int(bb0)]+=1
  assert all(c==2 for c in edges.values());assert all(orient[a,b]==orient[b,a] for a,b in edges)
  normals=v/r**2;normals/=np.linalg.norm(normals,axis=1)[:,None];world=v@m[:3,:3].T+m[:3,3];wn=normals@np.linalg.inv(m[:3,:3]);wn/=np.linalg.norm(wn,axis=1)[:,None];positions=world[:,[0,2,1]].copy();positions[:,2]*=-1;norms=wn[:,[0,2,1]].copy();norms[:,2]*=-1;positions=positions.astype('<f4');norms=norms.astype('<f4');indices=tri.astype('<u2');assert np.isfinite(positions).all() and np.isfinite(norms).all() and np.all(abs(np.linalg.norm(norms,axis=1)-1)<1e-6)
  vol=float(np.einsum('ij,ij->i',v[tri[:,0]],np.cross(v[tri[:,1]],v[tri[:,2]])).sum()/6);assert vol>0;assert np.all(np.linalg.norm(np.cross(positions[tri[:,1]]-positions[tri[:,0]],positions[tri[:,2]]-positions[tri[:,0]]),axis=1)>0)
  node=next(n for n in out['nodes'] if n.get('name')=='EXPORT '+name);mesh=node['mesh'];changed.add(mesh);old=out['meshes'][mesh]['primitives'][0];out['meshes'][mesh]['primitives']=[{'attributes':{'POSITION':append(positions,'VEC3',5126,34962),'NORMAL':append(norms,'VEC3',5126,34962)},'indices':append(indices.reshape(-1,1),'SCALAR',5123,34963),'material':old['material']}]
  objects.append({'name':name,'azimuthSamples':count,'polarRingsDegrees':[math.degrees(a) for a in angles],'vertices':len(v),'triangles':len(tri),'closedAndWindingValid':True,'positiveSignedVolume':vol,'preExportMaxEllipsoidResidual':float(abs(np.linalg.norm(v/r,axis=1)-1).max()),'normalMethod':'Analytic authored ellipsoid gradient; changed source-curve normals, not baseline-byte invariant','normalSplits':0})
 while len(buf)%4:buf.extend(b'\0')
 out['buffers'][0]['byteLength']=len(buf);j=json.dumps(out,separators=(',',':')).encode();j+=b' '*((-len(j))%4);dest=P/(stage+'.glb');dest.write_bytes(struct.pack('<III',0x46546c67,2,28+len(j)+len(buf))+struct.pack('<II',len(j),0x4e4f534a)+j+struct.pack('<II',len(buf),0x004e4942)+buf)
 dd,db=read(dest);assert db[:len(bb)]==bb
 for key in ['asset','scene','scenes','nodes','materials']:assert dd[key]==base[key]
 for i,mesh in enumerate(base['meshes']):
  if i not in changed:assert dd['meshes'][i]==mesh
 assert dd['accessors'][:len(base['accessors'])]==base['accessors'];assert dd['bufferViews'][:len(base['bufferViews'])]==base['bufferViews']
 rows={'stage':stage,'path':str(dest),'sha256':sha(dest),'actualTriangles':1314-60+sum(x['triangles'] for x in objects),'changedExportedVertices':sum(x['vertices'] for x in objects),'noPartitionSnapshotForecastOnly':63232 if stage=='eye-A' else 65216,'baselineBinaryPrefixByteIdentical':True,'allOtherMeshNormalMaterialNodeValuesUnchanged':True,'objects':objects};reports.append(rows);print(rows,flush=True)
assert sha(SRC)=='9254eaebdfa61143dfdb9480330bc677ae47acfa710715bbfa31ab2943a16806';assert sha(BASE)=='794b4d5bc8e0c470170a41bdff0bd3775624e4bb8807972ebd7d1b527b78794f'
(P/'build-report.json').write_text(json.dumps({'sourceUnchanged':True,'stage2BaselineSha256':sha(BASE),'stages':reports},indent=2))
