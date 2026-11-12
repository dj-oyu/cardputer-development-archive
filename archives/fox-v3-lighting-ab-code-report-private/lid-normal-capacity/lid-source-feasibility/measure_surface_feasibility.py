import numpy as np,json,pathlib,ast
P=pathlib.Path(__file__).resolve().parent;R=P.parent;code=(R/'fox-v3-occlusion-reduction/audit.py').read_text();tree=ast.parse(code);c=next(x for x in tree.body if isinstance(x,ast.ClassDef) and x.name=='Shape');nearest=next(x for x in c.body if isinstance(x,ast.FunctionDef) and x.name=='nearest');method=ast.get_source_segment(code,nearest);exec('class NumericShape:\n'+''.join(' '+line+'\n' for line in method.splitlines()))
DELTA=1e-5;EPS=1e-7;feas=json.loads((P/'centerline-feasibility.json').read_text());rows=[]
for side in [-1,1]:
 d=np.load(P/f'source-lid-{side}-readonly.npz');v,t=d['v'],d['t'];rings=v.reshape(-1,12,3);centers=rings.mean(1);arc=np.r_[0,np.cumsum(np.linalg.norm(np.diff(centers,axis=0),axis=1))];cp=np.array(next(x for x in feas if x['name']==f'Upper eyelid {side}')['equalArcStationMeasurements'][0]['points']);verts=[]
 for k,q in enumerate([0,arc[-1]/2,arc[-1]]):
  idx=min(np.searchsorted(arc,q,side='right')-1,len(arc)-2);idx=max(0,idx);alpha=(q-arc[idx])/(arc[idx+1]-arc[idx]);radial=(1-alpha)*(rings[idx]-centers[idx])+alpha*(rings[idx+1]-centers[idx+1]);radial/=np.linalg.norm(radial,axis=1)[:,None]
  for section in [0,4,8]:verts.append(cp[k]+.013000000268220901*radial[section])
 vertices=np.array(verts);faces=[]
 for j in range(2):
  for k in range(3):kn=(k+1)%3;faces.extend([[3*j+k,3*(j+1)+k,3*(j+1)+kn],[3*j+k,3*(j+1)+kn,3*j+kn]])
 faces=np.array(faces);source=NumericShape();source.v=v;source.t=t;hyp=NumericShape();hyp.v=vertices;hyp.t=faces
 sourceSamples=np.concatenate([v,v[t].mean(1)]);candidateSamples=[]
 for a,b,c in vertices[faces]:
  for i in range(9):
   for j in range(9-i):candidateSamples.append(a*(1-(i+j)/8)+b*i/8+c*j/8)
 forward=np.array([hyp.nearest(p)[1] for p in sourceSamples]);reverse=np.array([source.nearest(p)[1] for p in candidateSamples]);widths=[]
 for i in range(3):
  rr=vertices[i*3:i*3+3];area2=np.linalg.norm(np.cross(rr[1]-rr[0],rr[2]-rr[0]));widths.append(min(area2/np.linalg.norm(rr[(k+1)%3]-rr[k]) for k in range(3)))
 rows.append({'side':side,'scope':'Read-only hypothetical triangle calculations; no candidate mesh/GLB or scene object created','sourceEvaluatedVertices':len(v),'sourceEvaluatedTriangles':len(t),'hypotheticalVertices':9,'hypotheticalTriangles':12,'stationRule':'endpoints plus original Bezier equal-arc midpoint','frameRule':'fixed source evaluated MINIMUM-twist cross-section ring radial directions 0,4,8; interpolate adjacent source radial directions at arc midpoint, normalize; no phase search','sourceToHypotheticalSamples':len(forward),'sourceToHypotheticalMax':float(forward.max()),'sourceToHypotheticalSampleMean':float(forward.mean()),'hypotheticalToSourceSamples':len(reverse),'hypotheticalToSourceMax':float(reverse.max()),'hypotheticalToSourceSampleMean':float(reverse.mean()),'sampledSymmetricSurfaceHausdorff':float(max(forward.max(),reverse.max())),'crossSectionMinimumWidth':min(widths),'analyticCircularDiameter':.026,'analyticTriangularInradius':.0065,'analyticEquilateralMinimumWidth':.0195})
(P/'surface-feasibility.json').write_text(json.dumps(rows,indent=2));print(json.dumps(rows,indent=2))
