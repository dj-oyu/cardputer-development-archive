from pathlib import Path
exec((Path('/workspace/scratch/6d8dcdbcdc54/fox-v3-occlusion-reduction/audit.py')).read_text().split('reports=[]')[0])
def parity(shape,p):
 d=np.array([1,.371,.173]);d/=np.linalg.norm(d);tri=shape.v[shape.t];e1=tri[:,1]-tri[:,0];e2=tri[:,2]-tri[:,0];h=np.cross(np.broadcast_to(d,e2.shape),e2);det=np.einsum('ij,ij->i',e1,h);ok=abs(det)>1e-14;f=np.zeros_like(det);f[ok]=1/det[ok];s=np.asarray(p)-tri[:,0];u=f*np.einsum('ij,ij->i',s,h);q=np.cross(s,e1);v=f*np.einsum('j,ij->i',d,q);t=f*np.einsum('ij,ij->i',e2,q);ts=np.sort(t[ok&(u>=0)&(v>=0)&(u+v<=1)&(t>0)]);unique=[]
 for x in ts:
  if not unique or x-unique[-1]>D*1e-10:unique.append(float(x))
 return 'inside' if len(unique)%2 else 'outside'
v=np.array([[-1,-1,-1],[1,-1,-1],[1,1,-1],[-1,1,-1],[-1,-1,1],[1,-1,1],[1,1,1],[-1,1,1]],float)
quads=[[0,3,2,1],[4,5,6,7],[0,1,5,4],[3,7,6,2],[0,4,7,3],[1,2,6,5]];tri=np.array([[q[0],q[i],q[i+1]] for q in quads for i in [1,2]]);box=Shape((v,tri));fixtures=[]
for p,expected in [([0,0,0],'inside'),([.9,.9,.9],'inside'),([2,0,0],'outside'),([-2,-2,-2],'outside'),([1,0,0],'band'),([1,1,1],'band'),([1+2*DELTA,0,0],'outside'),([1-2*DELTA,0,0],'inside'),([1+1.001*DELTA,0,0],'outside'),([1-1.001*DELTA,0,0],'inside'),([1+.999*DELTA,0,0],'band'),([1-.999*DELTA,0,0],'band')]:
 actual=box.classify(p)[0];fixtures.append({'point':p,'expected':expected,'actual':actual,'pass':actual==expected})
checks=[]
for stage in ['source','baseline','stage-1','stage-2','stage-3','stage-4']:
 shapes=S if stage=='source' else {k:Shape(x) for k,x in load(R/'fox-v3-ground-transport/le-001/inputs/geometry-source-sided.glb' if stage=='baseline' else O/(stage+'.glb')).items()}
 for side in [-1,1]:
  pad=shapes[f'Muzzle pad {side}'];pts=S[f'Smile {side}'].samples;idx=np.linspace(0,len(pts)-1,200,dtype=int);counts=collections.Counter()
  for i in idx:
   w=pad.classify(pts[i])[0];r=parity(pad,pts[i]);counts[w+'->'+r]+=1
   if w in ('inside','outside') and w!=r:counts['mismatch']+=1
  checks.append({'stage':stage,'side':side,'counts':dict(counts)})
result={'boxTopology':box.topology(),'fixtures':fixtures,'independentDoubleRayChecks':checks,'pass':all(f['pass'] for f in fixtures) and all(not c['counts'].get('mismatch',0) for c in checks)}
(O/'oracle-validation.json').write_text(json.dumps(result,indent=2));print(json.dumps(result,indent=2))
