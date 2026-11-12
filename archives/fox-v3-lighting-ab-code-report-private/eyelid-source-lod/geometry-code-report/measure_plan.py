import numpy as np,json,pathlib,ast,collections
P=pathlib.Path(__file__).resolve().parent;R=P.parent;code=(R/'fox-v3-occlusion-reduction/audit.py').read_text();tree=ast.parse(code);c=next(x for x in tree.body if isinstance(x,ast.ClassDef) and x.name=='Shape');method=ast.get_source_segment(code,next(x for x in c.body if isinstance(x,ast.FunctionDef) and x.name=='nearest'));exec('class NumericShape:\n'+''.join(' '+l+'\n' for l in method.splitlines()));DELTA=1e-5;EPS=1e-7
rows=[]
def partition(t):
 parts=[];ids=set();faces=[]
 for tri in t:
  if len(faces)==64 or len(ids.union(tri))>32:parts.append({'vertices':len(ids),'triangles':len(faces)});ids=set();faces=[]
  ids.update(tri);faces.append(tri)
 if faces:parts.append({'vertices':len(ids),'triangles':len(faces)})
 return parts
for side in [-1,1]:
 d=np.load(R/f'fox-v3-lid-design/source-lid-{side}-readonly.npz');v,t=d['v'],d['t'];rings=v.reshape(-1,12,3);centers=rings.mean(1);chosen=[0,96];selection=[];arc=np.r_[0,np.cumsum(np.linalg.norm(np.diff(centers,axis=0),axis=1))]
 for budget in [8,10]:
  while len(chosen)<budget:
   candidates=[]
   for a,b in zip(chosen,chosen[1:]):
    edge=centers[b]-centers[a]
    for k in range(a+1,b):
     u=np.clip(np.dot(centers[k]-centers[a],edge)/np.dot(edge,edge),0,1);dist=float(np.linalg.norm(centers[k]-centers[a]-u*edge));candidates.append((-dist,k))
   neg,k=min(candidates);chosen.append(k);chosen.sort();selection.append({'ring':k,'priorMaxChordDistance':-neg})
  vv=rings[chosen][:,[0,2,4,6,8,10]].reshape(-1,3);tt=[]
  for j in range(budget-1):
   for k in range(6):prev=(k-1)%6;tt.extend([[j*6+k,(j+1)*6+k,(j+1)*6+prev],[j*6+k,(j+1)*6+prev,j*6+prev]])
  tt=np.array(tt);source=NumericShape();source.v=v;source.t=t;hyp=NumericShape();hyp.v=vv;hyp.t=tt;forward=np.array([hyp.nearest(p)[1] for p in np.concatenate([v,v[t].mean(1)])]);reversePts=[]
  for a,b,c in vv[tt]:
   for i in range(5):
    for j in range(5-i):reversePts.append(a*(1-(i+j)/4)+b*i/4+c*j/4)
  reverse=np.array([source.nearest(p)[1] for p in reversePts]);cd=np.zeros(97)
  for a,b in zip(chosen,chosen[1:]):
   edge=centers[b]-centers[a];u=np.clip((centers[a:b+1]-centers[a])@edge/np.dot(edge,edge),0,1);cd[a:b+1]=np.linalg.norm(centers[a:b+1]-centers[a]-u[:,None]*edge,axis=1)
  minwidth=1.;minradius=1.
  for ring in rings[chosen][:,[0,2,4,6,8,10]]:
   center=ring.mean(0);plane=np.cross(ring[1]-ring[0],ring[2]-ring[1]);plane/=np.linalg.norm(plane)
   for a,b in zip(ring,np.roll(ring,-1,axis=0)):
    n=np.cross(b-a,plane);n/=np.linalg.norm(n);proj=ring@n;minwidth=min(minwidth,float(proj.max()-proj.min()));minradius=min(minradius,abs(float(np.dot(center-a,n))))
  weights=np.r_[np.diff(arc)[0]/2,(np.diff(arc)[:-1]+np.diff(arc)[1:])/2,np.diff(arc)[-1]/2];parts=partition(tt);row={'side':side,'stations':budget,'sourceRingIDs':chosen.copy(),'selectedSourceCrossSectionIDs':[0,2,4,6,8,10],'selectionLog':selection.copy(),'vertices':len(vv),'triangles':len(tt),'centerlineMaxChordError':float(cd.max()),'centerlineArcWeightedMeanError':float(cd@weights/weights.sum()),'sourceSurfaceSampleCount':len(forward),'sourceToTemplateMax':float(forward.max()),'sourceToTemplateSampleMean':float(forward.mean()),'templateSurfaceSampleCount':len(reverse),'templateToSourceMax':float(reverse.max()),'templateToSourceSampleMean':float(reverse.mean()),'sampledSymmetricSurfaceHausdorff':float(max(forward.max(),reverse.max())),'minimumCrossSectionWidth':minwidth,'minimumCrossSectionSupportRadius':minradius,'standalonePartition':parts,'standalonePartitionVertexTotal':sum(p['vertices'] for p in parts),'standaloneCompactBytesAssumingAntipodal':sum((12+50*p['vertices']+3*p['triangles']+(p['triangles']+7)//8+3)&~3 for p in parts),'standaloneFallbackBytes':sum((12+56*p['vertices']+3*p['triangles']+(p['triangles']+7)//8+3)&~3 for p in parts)};rows.append(row);print(row,flush=True)
(P/'plan-measurements.json').write_text(json.dumps(rows,indent=2))
