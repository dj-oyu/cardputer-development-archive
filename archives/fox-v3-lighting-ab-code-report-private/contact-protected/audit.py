import json,struct,pathlib,math,hashlib,collections,time
import numpy as np
from mathutils import Vector
from mathutils.bvhtree import BVHTree
R=pathlib.Path('/workspace/scratch/6d8dcdbcdc54');O=R/'fox-v3-contact-protected'
def load(p):
 b=p.read_bytes();l=struct.unpack_from('<I',b,12)[0];d=json.loads(b[20:20+l]);buf=b[28+l:]
 def acc(i):
  a=d['accessors'][i];v=d['bufferViews'][a['bufferView']];dt={5126:'<f4',5123:'<u2',5125:'<u4'}[a['componentType']];n={'VEC3':3,'SCALAR':1}[a['type']];return np.frombuffer(buf,dtype=dt,count=a['count']*n,offset=v.get('byteOffset',0)+a.get('byteOffset',0)).reshape(-1,n).copy()
 out={}
 for node in d['nodes']:
  if node.get('name','').removeprefix('EXPORT ') not in ['Muzzle pad -1','Muzzle pad 1','Smile -1','Smile 1']:continue
  p=d['meshes'][node['mesh']]['primitives'][0];v=acc(p['attributes']['POSITION']).astype(float);v=v[:,[0,2,1]];v[:,1]*=-1;t=acc(p['indices']).reshape(-1,3);out[node['name'].removeprefix('EXPORT ')]=(v,t)
 return out
source=load(R/'fox-v3-occlusion-reduction/source-four-four.glb');allv=np.concatenate([x[0] for x in source.values()]);D=float(np.linalg.norm(allv.max(0)-allv.min(0)));DELTA=D*1e-5;EPS=D*1e-7
class Shape:
 def __init__(self,pair):
  self.v,self.t=pair;self.tree=BVHTree.FromPolygons([Vector(x) for x in self.v],self.t.tolist(),all_triangles=True);self.samples=np.concatenate([self.v,self.v[self.t].mean(1)])
 def topology(self):
  ids={};ix=[]
  for v in self.v:ix.append(ids.setdefault(tuple(v),len(ids)))
  edges=collections.Counter();oriented=collections.Counter()
  for t in self.t:
   tt=[ix[i] for i in t]
   for a,b in zip(tt,tt[1:]+tt[:1]):edges[tuple(sorted((a,b)))]+=1;oriented[a,b]+=1
  bad=sum(n!=2 for n in edges.values());wbad=sum(oriented[a,b]!=oriented[b,a] for a,b in edges)
  vol=float(np.einsum('ij,ij->i',self.v[self.t[:,0]],np.cross(self.v[self.t[:,1]],self.v[self.t[:,2]])).sum()/6)
  return {'weldedVertices':len(ids),'nonTwoIncidentEdges':bad,'windingMismatches':wbad,'signedVolume':vol,'valid':bad==0 and wbad==0 and vol>0}
 def nearest(self,p,tie=False):
  # Exact float64 closest-point distance: face projection if inside, otherwise edge projections.
  tri=self.v[self.t];a,b,c=tri[:,0],tri[:,1],tri[:,2];ab=b-a;ac=c-a;ap=np.asarray(p)-a
  d00=np.einsum('ij,ij->i',ab,ab);d01=np.einsum('ij,ij->i',ab,ac);d11=np.einsum('ij,ij->i',ac,ac);d20=np.einsum('ij,ij->i',ap,ab);d21=np.einsum('ij,ij->i',ap,ac);den=d00*d11-d01*d01
  u=np.divide(d11*d20-d01*d21,den,out=np.zeros_like(den),where=den!=0);v=np.divide(d00*d21-d01*d20,den,out=np.zeros_like(den),where=den!=0);inside=(den>0)&(u>=0)&(v>=0)&(u+v<=1)
  face=a+u[:,None]*ab+v[:,None]*ac;points=[face];ds=[np.where(inside,np.einsum('ij,ij->i',face-p,face-p),np.inf)]
  for x,y in [(a,b),(b,c),(c,a)]:
   edge=y-x;length=np.einsum('ij,ij->i',edge,edge);t=np.clip(np.divide(np.einsum('ij,ij->i',np.asarray(p)-x,edge),length,out=np.zeros_like(length),where=length!=0),0,1);q=x+t[:,None]*edge;points.append(q);ds.append(np.einsum('ij,ij->i',q-p,q-p))
  distances=np.array(ds);flat=int(np.argmin(distances));which,index=np.unravel_index(flat,distances.shape);q=points[which][index];distance=float(np.sqrt(distances[which,index]));amb=False
  if tie:
   for w,i in zip(*np.where(np.abs(np.sqrt(distances)-distance)<=EPS)):
    if np.linalg.norm(points[w][i]-q)>DELTA:amb=True;break
  return q,distance,amb

 def classify(self,p):
  q,d,_=self.nearest(p)
  if d<=DELTA:return 'band',d
  tri=self.v[self.t].astype(np.longdouble)-np.asarray(p,dtype=np.longdouble);a,b,c=tri[:,0],tri[:,1],tri[:,2];la=np.linalg.norm(a,axis=1);lb=np.linalg.norm(b,axis=1);lc=np.linalg.norm(c,axis=1)
  num=np.einsum('ij,ij->i',a,np.cross(b,c));den=la*lb*lc+np.einsum('ij,ij->i',a,b)*lc+np.einsum('ij,ij->i',b,c)*la+np.einsum('ij,ij->i',c,a)*lb
  w=float(np.arctan2(num,den).sum()/(2*np.arccos(np.longdouble(-1))));tol=len(self.t)*np.finfo(float).eps*256
  if abs(w)<=tol:return 'outside',d
  if abs(abs(w)-1)<=tol:return 'inside',d
  return 'uncertain',d

S={k:Shape(v) for k,v in source.items()}
views={kind:[{'azimuth':a,'elevation':e,'direction':[math.cos(math.radians(e))*math.cos(math.radians(a)),math.cos(math.radians(e))*math.sin(math.radians(a)),math.sin(math.radians(e))]} for a in az for e in el] for kind,az,el in [('development',range(0,360,30),[-30,0,30]),('holdout',range(15,360,30),[-15,15])]}
views['newValidation']=json.loads((O/'new-validation-views.json').read_text())
(O/'audit-contract.json').write_text(json.dumps({'diagonal':D,'margin':DELTA,'rayStepAndProjectionTie':EPS,'views':views,'scope':'finite deterministic surface sample gate; not global guarantee'},indent=2))
def label(sm,pad,p,d):
 origin=Vector(p)+d*(4*D);sd=sm.tree.ray_cast(origin,-d,8*D)[3];pd=pad.tree.ray_cast(origin,-d,8*D)[3]
 if sd is None and pd is None:return 'miss'
 if sd is None:return 'pad'
 if pd is None:return 'Smile'
 if abs(sd-pd)<=DELTA:return 'band'
 return 'Smile' if sd<pd else 'pad'
reports=[]
for stage in ['protected-contact']:
 start=time.time();path=(O/'source-four-four.glb' if stage=='source-identity' else R/'fox-v3-ground-transport/le-001/inputs/geometry-source-sided.glb' if stage=='baseline' else O/(stage+'.glb'));C={k:Shape(v) for k,v in load(path).items()};report={'stage':stage,'path':str(path),'sha256':hashlib.sha256(path.read_bytes()).hexdigest(),'pairs':[]}
 for side in [-1,1]:
  sn=f'Smile {side}';pn=f'Muzzle pad {side}';ss,sp,cs,cp=S[sn],S[pn],C[sn],C[pn];stats=collections.Counter();issues=[];correspondences=[]
  for family,points in [('source',ss.samples),('candidate',cs.samples)]:
   for i,p in enumerate(points):
    q,dist,tie=(cs if family=='source' else ss).nearest(p,True);a,b=(p,q) if family=='source' else (q,p);sa,da=sp.classify(a);cb,db=cp.classify(b);stats[sa+'->'+cb]+=1
    outcome='pass'
    if tie or sa=='uncertain' or cb=='uncertain':outcome='unresolved'
    elif sa=='band':outcome='sourceBand'
    elif cb=='band':outcome='unresolved'
    elif sa!=cb:outcome='reversal'
    stats[outcome]+=1
    row={'family':family,'index':i,'source':a.tolist(),'candidate':b.tolist(),'projectionDistance':dist,'projectionTie':tie,'sourceClass':sa,'candidateClass':cb,'sourceClearance':da,'candidateClearance':db,'outcome':outcome};correspondences.append(row)
    if outcome!='pass':issues.append(row)
  rays={}
  targets=np.concatenate([ss.samples,cs.samples])
  for kind,vv in views.items():
   byview=[]
   for view in vv:
    d=Vector(view['direction']);cnt=collections.Counter()
    for p in targets:
     a=label(ss,sp,p,d);b=label(cs,cp,p,d);cnt[a+'->'+b]+=1
     if a in ('pad','Smile') and b!=a:cnt['failed']+=1
    byview.append(dict(view,counts=dict(cnt)))
   rays[kind]={'views':byview,'failed':sum(v['counts'].get('failed',0) for v in byview)}
  topo={'source':sp.topology(),'candidate':cp.topology()};development_pass=all(x['valid'] for x in topo.values()) and not stats['reversal'] and not stats['unresolved'] and not rays['development']['failed'];holdout_pass=not rays['holdout']['failed'];passed=development_pass and holdout_pass
  (O/f'{stage}-side{side}-samples.json').write_text(json.dumps(correspondences,separators=(',',':')))
  report['pairs'].append({'side':side,'topology':topo,'containment':dict(stats),'sampleArtifact':f'{stage}-side{side}-samples.json','rays':rays,'developmentPass':development_pass,'holdoutPass':holdout_pass,'newValidationPass':not rays['newValidation']['failed'],'pass':passed and not rays['newValidation']['failed']})
 report['developmentPass']=all(p['developmentPass'] for p in report['pairs']);report['holdoutPass']=all(p['holdoutPass'] for p in report['pairs']);report['newValidationPass']=all(p['newValidationPass'] for p in report['pairs']);report['pass']=report['developmentPass'] and report['holdoutPass'] and report['newValidationPass'];report['seconds']=time.time()-start;reports.append(report);(O/(stage+'-audit.json')).write_text(json.dumps(report,indent=2));print(stage,report['pass'],report['seconds'],flush=True)
(O/'audit-summary.json').write_text(json.dumps({'contract':'audit-contract.json','reports':[{'stage':r['stage'],'pass':r['pass'],'pairs':[{'side':p['side'],'topology':p['topology'],'containment':p['containment'],'developmentRayFailures':p['rays']['development']['failed'],'holdoutRayFailures':p['rays']['holdout']['failed']} for p in r['pairs']]} for r in reports],'selected':next((r['stage'] for r in reports if r['stage'] not in ('baseline','source-identity') and r['developmentPass']),None)},indent=2))
