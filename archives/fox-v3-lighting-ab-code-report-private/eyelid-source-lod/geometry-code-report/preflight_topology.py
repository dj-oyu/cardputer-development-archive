import pathlib,json,numpy as np,collections
P=pathlib.Path(__file__).resolve().parent;old=json.loads((P/'plan-measurements.json').read_text());nine=json.loads((P/'nine-station-light-measurements.json').read_text());rows=[]
for side in [-1,1]:
 source=np.load(P/f'source-{side}-private.npz')
 for n in [8,9]:
  chosen=next(x['sourceRingIDs'] for x in (old if n==8 else nine) if x['side']==side and x['stations']==n);ids=np.array([ring*12+k for ring in chosen for k in [0,2,4,6,8,10]]);v=source['v'][ids];ns=source['n'][ids];faces=[]
  for j in range(n-1):
   for k in range(6):p=(k-1)%6;faces.extend([[j*6+k,(j+1)*6+k,(j+1)*6+p],[j*6+k,(j+1)*6+p,j*6+p]])
  t=np.array(faces);edges=collections.Counter();oriented=collections.Counter();graph=collections.defaultdict(set)
  for tri in t:
   for a,b in zip(tri,np.roll(tri,-1)):a,b=int(a),int(b);edges[tuple(sorted((a,b)))]+=1;oriented[a,b]+=1;graph[a].add(b);graph[b].add(a)
  boundary=[e for e,nv in edges.items() if nv==1];bg=collections.defaultdict(set)
  for a,b in boundary:bg[a].add(b);bg[b].add(a)
  seen=set();loops=[]
  for start in bg:
   if start in seen:continue
   todo=[start];component=set()
   while todo:
    x=todo.pop()
    if x in component:continue
    component.add(x);seen.add(x);todo.extend(bg[x]-component)
   loops.append(sorted(component))
  con={0};todo=[0]
  while todo:
   a=todo.pop()
   for b in graph[a]-con:con.add(b);todo.append(b)
  normals=np.cross(v[t[:,1]]-v[t[:,0]],v[t[:,2]]-v[t[:,0]]);area=np.linalg.norm(normals,axis=1);gn=normals/area[:,None];dots=np.einsum('ij,ikj->ik',gn,ns[t]);row={'side':side,'stations':n,'vertices':len(v),'triangles':len(t),'edges':len(edges),'EulerCharacteristic':len(v)-len(edges)+len(t),'connectedComponents':1 if len(con)==len(v) else 'FAIL','boundaryLoopLengths':sorted(map(len,loops)),'boundaryDegreesAllTwo':all(len(x)==2 for x in bg.values()),'nonmanifoldEdges':sum(nv>2 for nv in edges.values()),'interiorWindingMismatches':sum(oriented[a,b]!=oriented[b,a] for (a,b),nv in edges.items() if nv==2),'minimumDoubleArea':float(area.min()),'minimumGeometricDotSourceNormal':float(dots.min()),'maxSourceNormalLengthError':float(abs(np.linalg.norm(ns,axis=1)-1).max()),'sourceVertexAndNormalExact':bool(np.array_equal(v,source['v'][ids]) and np.array_equal(ns,source['n'][ids])),'selectedEndpointSourceIDsExact':bool(np.array_equal(ids[:6],np.array([0,2,4,6,8,10])) and np.array_equal(ids[-6:],96*12+np.array([0,2,4,6,8,10]))),'noGLBOrSceneObjectCreated':True};row['pass']=row['EulerCharacteristic']==0 and row['connectedComponents']==1 and row['boundaryLoopLengths']==[6,6] and row['boundaryDegreesAllTwo'] and row['nonmanifoldEdges']==0 and row['interiorWindingMismatches']==0 and row['minimumDoubleArea']>0 and row['minimumGeometricDotSourceNormal']>0 and row['sourceVertexAndNormalExact'] and row['selectedEndpointSourceIDsExact'];rows.append(row)
(P/'preflight-topology.json').write_text(json.dumps(rows,indent=2));print(json.dumps(rows,indent=2))
