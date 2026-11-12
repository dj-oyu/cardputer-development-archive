import pathlib,json,collections,struct,hashlib,copy
import numpy as np
P=pathlib.Path(__file__).resolve().parent;R=P.parent;BASE=R/'fox-v3-ground-transport/le-001/inputs/geometry-source-sided.glb';SRC=R/'fox-v3-occlusion-reduction/source-four-four.glb'
def read(path):
 b=path.read_bytes();n=struct.unpack_from('<I',b,12)[0];d=json.loads(b[20:20+n]);return d,b[28+n:]
def accessor(d,b,i):
 a=d['accessors'][i];w=d['bufferViews'][a['bufferView']];n={'VEC3':3,'SCALAR':1}[a['type']];dt={5126:'<f4',5123:'<u2',5125:'<u4'}[a['componentType']];return np.frombuffer(b,dtype=dt,count=n*a['count'],offset=w.get('byteOffset',0)+a.get('byteOffset',0)).reshape(-1,n).copy()
bd,bb=read(BASE);sd,sb=read(SRC);out=copy.deepcopy(bd);buf=bytearray(bb);reports=[]
def append(array,typ,component,target):
 while len(buf)%4:buf.extend(b'\0')
 raw=array.tobytes();vi=len(out['bufferViews']);out['bufferViews'].append({'buffer':0,'byteOffset':len(buf),'byteLength':len(raw),'target':target});buf.extend(raw);ai=len(out['accessors']);a={'bufferView':vi,'componentType':component,'count':len(array),'type':typ}
 if typ=='VEC3':a.update(min=array.min(0).astype(float).tolist(),max=array.max(0).astype(float).tolist())
 out['accessors'].append(a);return ai
for item in json.loads((P/'protection.json').read_text()):
 name=item['name'];x=np.load(P/(name.replace(' ','_')+'.npz'));v=x['v'];original=x['t'];t=original.copy();alive=np.ones(len(t),bool);protected=set(x['protected'].tolist());locked=set(x['locked'].tolist());target=256 if name.startswith('Muzzle') else 160;collapses=[];touchlocked=set();reject=collections.Counter()
 while int(alive.sum())>target:
  edges=collections.defaultdict(list);neighbors=collections.defaultdict(set);vf=collections.defaultdict(set)
  for fi in np.where(alive)[0]:
   tri=t[fi]
   for a in tri:vf[int(a)].add(int(fi))
   for a,b in zip(tri,np.roll(tri,-1)):
    a,b=int(a),int(b);edges[tuple(sorted((a,b)))].append(int(fi));neighbors[a].add(b);neighbors[b].add(a)
  choices=sorted((float(np.dot(v[b]-v[a],v[b]-v[a])),a,b) for a,b in edges if a not in locked and b not in locked);accepted=False
  for length,a,b in choices:
   edgefaces=edges[a,b]
   if len(edgefaces)!=2:reject['nonmanifoldEdge']+=1;continue
   opposite={int(k) for fi in edgefaces for k in t[fi] if k not in (a,b)}
   if neighbors[a].intersection(neighbors[b])!=opposite:reject['linkCondition']+=1;continue
   touched=vf[b]-set(edgefaces);bad=False
   for fi in touched:
    old=t[fi];new=np.where(old==b,a,old)
    oldn=np.cross(v[old[1]]-v[old[0]],v[old[2]]-v[old[0]]);newn=np.cross(v[new[1]]-v[new[0]],v[new[2]]-v[new[0]])
    if len(set(new))<3 or np.dot(oldn,newn)<=0:bad=True;break
   if bad:reject['degenerateOrNormalReversal']+=1;continue
   # Duplicate surviving triangles are forbidden.
   proposed=t[alive].copy();proposed[proposed==b]=a;valid=np.array([len(set(q))==3 for q in proposed]);keys=[tuple(sorted(q)) for q in proposed[valid]]
   if len(keys)!=len(set(keys)):reject['duplicateTriangle']+=1;continue
   assert not protected.intersection(edgefaces)
   for fi in touched:
    if any(int(k) in locked for k in t[fi]):touchlocked.add(int(fi))
    t[fi][t[fi]==b]=a
   alive[edgefaces]=False;collapses.append({'keep':a,'remove':b,'sourceEdgeLength':length**.5,'removedSourceTriangleIDs':edgefaces});accepted=True;break
  if not accepted:break
 # Coordinates unchanged globally; protected identity/order verified independently of exported reindex.
 assert all(alive[i] and np.array_equal(t[i],original[i]) for i in protected)
 sn=next(n for n in sd['nodes'] if n.get('name')=='EXPORT '+name);sp=sd['meshes'][sn['mesh']]['primitives'][0];sourceNormals=accessor(sd,sb,sp['attributes']['NORMAL']);sourcePositions=accessor(sd,sb,sp['attributes']['POSITION']);sourceTriangles=accessor(sd,sb,sp['indices']).reshape(-1,3)
 # Smooth normals for unprotected final vertices, protected corners retain exact source normals.
 normal=np.zeros_like(v)
 for tri in t[alive]:
  n=np.cross(v[tri[1]]-v[tri[0]],v[tri[2]]-v[tri[0]])
  for k in tri:normal[k]+=n
 lens=np.linalg.norm(normal,axis=1);normal=np.divide(normal,lens[:,None],out=np.zeros_like(normal),where=lens[:,None]!=0)
 glpos=v[:,[0,2,1]].copy();glpos[:,2]*=-1;glnorm=normal[:,[0,2,1]].copy();glnorm[:,2]*=-1
 vertices=[];normals=[];indices=[];lookup={};protectedExport=[]
 for fi in np.where(alive)[0]:
  inds=[]
  for corner,vi in enumerate(t[fi]):
   pos=glpos[vi].astype('<f4');no=(sourceNormals[sourceTriangles[fi,corner]] if fi in protected else glnorm[vi]).astype('<f4');key=(pos.tobytes(),no.tobytes())
   if key not in lookup:lookup[key]=len(vertices);vertices.append(pos);normals.append(no)
   inds.append(lookup[key])
  indices.append(inds)
  if fi in protected:protectedExport.append({'sourceTriangleID':int(fi),'exportTriangleIndex':len(indices)-1})
 positions=np.array(vertices,dtype='<f4');normals=np.array(normals,dtype='<f4');indices=np.array(indices,dtype='<u2')
 for row in protectedExport:
  fi=row['sourceTriangleID'];inds=indices[row['exportTriangleIndex']];assert np.array_equal(positions[inds],sourcePositions[sourceTriangles[fi]]);assert np.array_equal(normals[inds],sourceNormals[sourceTriangles[fi]])
 bn=next(n for n in out['nodes'] if n.get('name')=='EXPORT '+name);old=out['meshes'][bn['mesh']]['primitives'][0];primitive={'attributes':{'POSITION':append(positions,'VEC3',5126,34962),'NORMAL':append(normals,'VEC3',5126,34962)},'indices':append(indices.reshape(-1,1),'SCALAR',5123,34963),'material':old['material']};out['meshes'][bn['mesh']]['primitives']=[primitive]
 report={k:value for k,value in item.items() if not k.endswith('IDs')};report.update(targetTriangles=target,actualTriangles=int(alive.sum()),targetReached=int(alive.sum())<=target,collapseCount=len(collapses),remainingUnprotectedFaces=int(alive.sum())-len(protected),modifiedUnprotectedFacesIncidentToLockedVertices=sorted(touchlocked),exportedVertices=len(vertices),uniquePositions=len({tuple(p) for p in positions}),normalSplitDuplicates=len(vertices)-len({tuple(p) for p in positions}),protectedFacePositionOrderAndCornerNormalExact=True,rejectedEdgeAttemptCounts=dict(reject));reports.append(report);(P/(name.replace(' ','_')+'-collapse-log.json')).write_text(json.dumps({'collapses':collapses,'protectedExportMapping':protectedExport},indent=2));print(report,flush=True)
while len(buf)%4:buf.extend(b'\0')
out['buffers'][0]['byteLength']=len(buf);j=json.dumps(out,separators=(',',':')).encode();j+=b' '*((-len(j))%4);dest=P/'protected-contact.glb';dest.write_bytes(struct.pack('<III',0x46546c67,2,28+len(j)+len(buf))+struct.pack('<II',len(j),0x4e4f534a)+j+struct.pack('<II',len(buf),0x004e4942)+buf)
d,db=read(dest);assert db[:len(bb)]==bb
changed={n['mesh'] for n in d['nodes'] if n.get('name') in ['EXPORT '+r['name'] for r in reports]}
for k in ['asset','scene','scenes','nodes','materials']:assert d[k]==bd[k]
for i,m in enumerate(bd['meshes']):
 if i not in changed:assert d['meshes'][i]==m
assert d['accessors'][:len(bd['accessors'])]==bd['accessors'];assert d['bufferViews'][:len(bd['bufferViews'])]==bd['bufferViews']
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();assert sha(BASE)=='9c6ea7e1f6ee83101a3249de6c482cb8bca1e3943d9448c7701eafb173f6c78c';assert sha(R/'fox-reference-sculpt-private/fox-reference-standing-editable.blend')=='9254eaebdfa61143dfdb9480330bc677ae47acfa710715bbfa31ab2943a16806';total=1110+sum(r['actualTriangles'] for r in reports)
(P/'build-report.json').write_text(json.dumps({'path':str(dest),'sha256':sha(dest),'actualTriangles':total,'deltaVsBaseline':total-1166,'baselineBinaryPrefixByteIdentical':True,'otherMeshAccessorNormalMaterialNodeValuesUnchanged':True,'sourceUnchanged':True,'objects':reports},indent=2))
