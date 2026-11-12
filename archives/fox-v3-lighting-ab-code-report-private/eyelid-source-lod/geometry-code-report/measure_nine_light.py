import pathlib,json,numpy as np,collections
P=pathlib.Path(__file__).resolve().parent;old=json.loads((P/'plan-measurements.json').read_text());rows=[]
for side in [-1,1]:
 data=np.load(P/f'source-{side}-private.npz');rings=data['v'].reshape(-1,12,3);norms=data['n'].reshape(-1,12,3);centers=rings.mean(1);log=next(x['selectionLog'] for x in old if x['side']==side and x['stations']==10);selected=sorted([0,96]+[x['ring'] for x in log[:7]]);dist=np.zeros(97)
 for a,b in zip(selected,selected[1:]):
  ab=centers[b]-centers[a];t=np.clip((centers[a:b+1]-centers[a])@ab/np.dot(ab,ab),0,1);dist[a:b+1]=np.linalg.norm(centers[a:b+1]-centers[a]-t[:,None]*ab,axis=1)
 vv=rings[selected][:,[0,2,4,6,8,10]].reshape(-1,3);nn=norms[selected][:,[0,2,4,6,8,10]].reshape(-1,3);tt=[]
 for j in range(8):
  for k in range(6):prev=(k-1)%6;tt.extend([[j*6+k,(j+1)*6+k,(j+1)*6+prev],[j*6+k,(j+1)*6+prev,j*6+prev]])
 tt=np.array(tt);parts=[];ids=set();faces=[]
 for tri in tt:
  if len(faces)==64 or len(ids.union(tri))>32:parts.append({'vertices':len(ids),'triangles':len(faces)});ids=set();faces=[]
  ids.update(tri);faces.append(tri)
 if faces:parts.append({'vertices':len(ids),'triangles':len(faces)})
 gn=np.cross(vv[tt[:,1]]-vv[tt[:,0]],vv[tt[:,2]]-vv[tt[:,0]]);gn/=np.linalg.norm(gn,axis=1)[:,None];dots=np.einsum('ij,ikj->ik',gn,nn[tt]);arc=np.r_[0,np.cumsum(np.linalg.norm(np.diff(centers,axis=0),axis=1))];weights=np.r_[np.diff(arc)[0]/2,(np.diff(arc)[:-1]+np.diff(arc)[1:])/2,np.diff(arc)[-1]/2];rows.append({'side':side,'stations':9,'sourceRingIDs':selected,'vertices':len(vv),'triangles':len(tt),'centerlineMaxChordError':float(dist.max()),'centerlineArcWeightedMeanError':float(dist@weights/weights.sum()),'minimumFaceNormalDotSourceCornerNormal':float(dots.min()),'standalonePartition':parts,'standalonePartitionVertexTotal':sum(x['vertices'] for x in parts),'standaloneCompactBytesAssumingAntipodal':sum((12+50*x['vertices']+3*x['triangles']+(x['triangles']+7)//8+3)&~3 for x in parts),'standaloneFallbackBytes':sum((12+56*x['vertices']+3*x['triangles']+(x['triangles']+7)//8+3)&~3 for x in parts),'surfaceAudit':'Deferred to avoid interference with parent CPU benchmark; no candidate artifact generated'})
(P/'nine-station-light-measurements.json').write_text(json.dumps(rows,indent=2));print(json.dumps(rows,indent=2))
