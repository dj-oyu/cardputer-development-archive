from pathlib import Path
exec((Path('/workspace/scratch/6d8dcdbcdc54/fox-v3-occlusion-reduction/audit.py')).read_text().split('reports=[]')[0])
P=R/'fox-v3-contact-protected';rows=[]
for name,(verts,tris) in source.items():
 ids={};remap=[];unique=[]
 for v in verts:
  key=tuple(v)
  if key not in ids:ids[key]=len(unique);unique.append(v)
  remap.append(ids[key])
 v=np.array(unique);t=np.array(remap)[tris];side=name.split()[-1];other=S[('Smile ' if name.startswith('Muzzle') else 'Muzzle pad ')+side];vd=np.array([other.nearest(p)[1] for p in v]);cd=np.array([other.nearest(p)[1] for p in v[t].mean(1)]);length=np.linalg.norm(v[t]-np.roll(v[t],-1,axis=1),axis=2).max(1);mind=np.minimum(vd[t].min(1),cd);initial=set(np.where(mind<=length)[0].tolist());edges=collections.defaultdict(list)
 for i,tri in enumerate(t):
  for a,b in zip(tri,np.roll(tri,-1)):edges[tuple(sorted((int(a),int(b))))].append(i)
 protected=set(initial)
 for faces in edges.values():
  if any(i in initial for i in faces):protected.update(faces)
 locked=set(t[list(protected)].flatten().tolist());np.savez(P/(name.replace(' ','_')+'.npz'),v=v,t=t,originalGLTFIndices=tris,protected=np.array(sorted(protected)),locked=np.array(sorted(locked)))
 row={'name':name,'sourceVertices':len(v),'sourceTriangles':len(t),'initialContactFaces':len(initial),'protectedFaces':len(protected),'protectedFaceFraction':len(protected)/len(t),'lockedVertices':len(locked),'lockedVertexFraction':len(locked)/len(v),'unprotectedFaces':len(t)-len(protected),'maxEdgeRange':[float(length.min()),float(length.max())],'protectedTriangleIDs':sorted(protected),'lockedVertexIDs':sorted(locked)};rows.append(row);print({k:x for k,x in row.items() if not k.endswith('IDs')},flush=True)
(P/'protection.json').write_text(json.dumps(rows,indent=2))
