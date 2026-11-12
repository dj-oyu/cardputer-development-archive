import pathlib,json,struct,copy,hashlib,collections,numpy as np
P=pathlib.Path(__file__).resolve().parent;R=P.parent;BASE=R/'fox-v3-eye-local-lod/eye-B.glb';SRC=R/'fox-reference-sculpt-private/fox-reference-standing-editable.blend';sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();assert sha(SRC)=='9254eaebdfa61143dfdb9480330bc677ae47acfa710715bbfa31ab2943a16806';assert sha(BASE)=='a0ba7e5b536aa292437e589ee44362d686c02ed2769aacb284d5e580cfdcab2b';assert sha(P/'PLAN.md')=='12235a151a5fac9ce97ea365abec6b807b2fe0ee9e7954b4856dcfda2cbc1e4c'
def read(path):
 b=path.read_bytes();n=struct.unpack_from('<I',b,12)[0];return json.loads(b[20:20+n]),b[28+n:]
def accessor(d,b,i):
 a=d['accessors'][i];v=d['bufferViews'][a['bufferView']];num={'VEC3':3,'SCALAR':1}[a['type']];dt={5126:'<f4',5123:'<u2',5125:'<u4'}[a['componentType']];return np.frombuffer(b,dtype=dt,count=a['count']*num,offset=v.get('byteOffset',0)+a.get('byteOffset',0)).reshape(-1,num).copy()
base,bb=read(BASE);planned=json.loads((P/'plan-measurements.json').read_text())+json.loads((P/'nine-full-measurements.json').read_text());reports=[]
for budget in [8,9]:
 tag=f'lid-{budget}';out=copy.deepcopy(base);buf=bytearray(bb);changed=set();objects=[];expected={};mappings={}
 def append(array,typ,component,target):
  while len(buf)%4:buf.extend(b'\0')
  raw=array.tobytes();vi=len(out['bufferViews']);out['bufferViews'].append({'buffer':0,'byteOffset':len(buf),'byteLength':len(raw),'target':target});buf.extend(raw);ai=len(out['accessors']);a={'bufferView':vi,'componentType':component,'count':len(array),'type':typ}
  if typ=='VEC3':a.update(min=array.min(0).astype(float).tolist(),max=array.max(0).astype(float).tolist())
  out['accessors'].append(a);return ai
 for side in [-1,1]:
  name=f'Upper eyelid {side}';data=np.load(P/f'source-{side}-private.npz');rings=data['v'].reshape(-1,12,3);centers=rings.mean(1);chosen=[0,96];selection=[]
  while len(chosen)<budget:
   candidates=[]
   for a,b in zip(chosen,chosen[1:]):
    edge=centers[b]-centers[a]
    for k in range(a+1,b):
     u=np.clip(np.dot(centers[k]-centers[a],edge)/np.dot(edge,edge),0,1);dist=float(np.linalg.norm(centers[k]-centers[a]-u*edge));candidates.append((-dist,k))
   neg,k=min(candidates);chosen.append(k);chosen.sort();selection.append({'ring':k,'priorMaxChordDistance':-neg})
  assert chosen==next(x['sourceRingIDs'] for x in planned if x['side']==side and x['stations']==budget)
  ids=np.array([ring*12+k for ring in chosen for k in [0,2,4,6,8,10]]);v=data['v'][ids];n=data['n'][ids];tri=[]
  for j in range(budget-1):
   for k in range(6):prev=(k-1)%6;tri.extend([[j*6+k,(j+1)*6+k,(j+1)*6+prev],[j*6+k,(j+1)*6+prev,j*6+prev]])
  t=np.array(tri,dtype='<u2');edges=collections.Counter();oriented=collections.Counter();graph=collections.defaultdict(set)
  for face in t:
   for a,b in zip(face,np.roll(face,-1)):a,b=int(a),int(b);edges[tuple(sorted((a,b)))]+=1;oriented[a,b]+=1;graph[a].add(b);graph[b].add(a)
  assert all(x<=2 for x in edges.values());assert all(oriented[a,b]==oriented[b,a] for (a,b),nv in edges.items() if nv==2);boundary=[e for e,nv in edges.items() if nv==1];expectedEnds={tuple(sorted((j*6+k,j*6+(k+1)%6))) for j in [0,budget-1] for k in range(6)};assert set(boundary)==expectedEnds;assert len(v)-len(edges)+len(t)==0
  seen={0};stack=[0]
  while stack:
   x=stack.pop()
   for y in graph[x]-seen:seen.add(y);stack.append(y)
  assert len(seen)==len(v)
  gn=np.cross(v[t[:,1]]-v[t[:,0]],v[t[:,2]]-v[t[:,0]]);areas=np.linalg.norm(gn,axis=1);assert np.all(areas>0);gn/=areas[:,None];dots=np.einsum('ij,ikj->ik',gn,n[t]);assert dots.min()>0;assert np.isfinite(v).all() and np.isfinite(n).all() and np.max(abs(np.linalg.norm(n,axis=1)-1))<1e-6
  pos=v[:,[0,2,1]].copy();pos[:,2]*=-1;norm=n[:,[0,2,1]].copy();norm[:,2]*=-1;pos=pos.astype('<f4');norm=norm.astype('<f4');node=next(x for x in out['nodes'] if x.get('name')=='EXPORT '+name);mi=node['mesh'];changed.add(mi);old=out['meshes'][mi]['primitives'][0];out['meshes'][mi]['primitives']=[{'attributes':{'POSITION':append(pos,'VEC3',5126,34962),'NORMAL':append(norm,'VEC3',5126,34962)},'indices':append(t.reshape(-1,1),'SCALAR',5123,34963),'material':old['material']}];expected[mi]=(pos,norm,t);mappings[name]={'sourceVertexIDs':ids.tolist(),'sourceRingIDs':chosen,'sourceSectionIDs':[0,2,4,6,8,10],'selectionLog':selection,'sourceArraySha256':sha(P/f'source-{side}-private.npz')};objects.append({'name':name,'vertices':len(v),'triangles':len(t),'normalSplits':0,'sourcePositionsAndUniqueCornerNormalsExact':True,'greedySelectionMatchesPlan':True,'boundaryLoops':[6,6],'connectedCylinder':True,'consistentWinding':True,'minimumNgDotSourceNs':float(dots.min()),'minimumDoubleArea':float(areas.min())})
 while len(buf)%4:buf.extend(b'\0')
 out['buffers'][0]['byteLength']=len(buf);j=json.dumps(out,separators=(',',':')).encode();j+=b' '*((-len(j))%4);dest=P/(tag+'.glb');dest.write_bytes(struct.pack('<III',0x46546c67,2,28+len(j)+len(buf))+struct.pack('<II',len(j),0x4e4f534a)+j+struct.pack('<II',len(buf),0x004e4942)+buf)
 dd,db=read(dest);assert db[:len(bb)]==bb
 for key in ['asset','scene','scenes','nodes','materials']:assert dd[key]==base[key]
 for i,mesh in enumerate(base['meshes']):
  if i not in changed:assert dd['meshes'][i]==mesh
 assert dd['accessors'][:len(base['accessors'])]==base['accessors'];assert dd['bufferViews'][:len(base['bufferViews'])]==base['bufferViews']
 for mi,(pos,norm,t) in expected.items():
  p=dd['meshes'][mi]['primitives'][0];assert accessor(dd,db,p['attributes']['POSITION']).tobytes()==pos.tobytes();assert accessor(dd,db,p['attributes']['NORMAL']).tobytes()==norm.tobytes();assert accessor(dd,db,p['indices']).reshape(-1,3).tobytes()==t.tobytes()
 total=sum(dd['accessors'][p['indices']]['count']//3 for m in dd['meshes'] for p in m['primitives']);row={'stage':tag,'path':str(dest),'sha256':sha(dest),'actualTriangles':total,'deltaTrianglesVsEyeB':total-1414,'changedVertices':sum(x['vertices'] for x in objects),'deltaSourceVerticesVsEyeB':sum(x['vertices'] for x in objects)-15,'baselineBinaryPrefixByteIdentical':True,'unrelatedMeshAccessorNormalMaterialNodeValuesUnchanged':True,'sourceVertexAndNormalExportByteExactAfterAxisTransform':True,'objects':objects,'actualCompileAndSnapshot':'Not run by geometry builder; parent evaluation owns admission'};reports.append(row);(P/(tag+'-source-correspondence-private.json')).write_text(json.dumps(mappings,indent=2));print(row,flush=True)
assert sha(SRC)=='9254eaebdfa61143dfdb9480330bc677ae47acfa710715bbfa31ab2943a16806';assert sha(BASE)=='a0ba7e5b536aa292437e589ee44362d686c02ed2769aacb284d5e580cfdcab2b';(P/'build-report.json').write_text(json.dumps({'sourceUnchanged':True,'sourceSha256':sha(SRC),'baselineSha256':sha(BASE),'planSha256':sha(P/'PLAN.md'),'stages':reports},indent=2))
