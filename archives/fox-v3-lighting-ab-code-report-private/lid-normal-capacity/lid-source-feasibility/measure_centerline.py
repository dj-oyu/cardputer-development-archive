import json,pathlib,numpy as np
P=pathlib.Path(__file__).resolve().parent;data=json.loads((P/'source-and-current.json').read_text());rows=[]
for o in data['objects']:
 if o['type']!='CURVE':continue
 ps=o['splines'][0]['points'];samples=[]
 for i in range(len(ps)-1):
  a,b=np.array(ps[i]['co']),np.array(ps[i]['right']);c,d=np.array(ps[i+1]['left']),np.array(ps[i+1]['co'])
  for t in np.linspace(0,1,257)[:-1]:samples.append((1-t)**3*a+3*(1-t)**2*t*b+3*(1-t)*t*t*c+t**3*d)
 samples.append(np.array(ps[-1]['co']));samples=np.array(samples);arc=np.r_[0,np.cumsum(np.linalg.norm(np.diff(samples,axis=0),axis=1))];results=[]
 for n in [3,4,5,6]:
  target=np.linspace(0,arc[-1],n);points=np.column_stack([np.interp(target,arc,samples[:,i]) for i in range(3)]);dist=np.full(len(samples),np.inf)
  for a,b in zip(points,points[1:]):
   ab=b-a;t=np.clip((samples-a)@ab/np.dot(ab,ab),0,1);d=np.linalg.norm(samples-a-t[:,None]*ab,axis=1);dist=np.minimum(dist,d)
  reverse=np.array([a+(b-a)*tt for a,b in zip(points,points[1:]) for tt in np.linspace(0,1,257)]); rd=np.full(len(reverse),np.inf)
  for aa,bb in zip(samples,samples[1:]):
   edge=bb-aa;u=np.clip((reverse-aa)@edge/np.dot(edge,edge),0,1);rd=np.minimum(rd,np.linalg.norm(reverse-aa-u[:,None]*edge,axis=1))
  weights=np.r_[np.diff(arc)[0]/2,(np.diff(arc)[:-1]+np.diff(arc)[1:])/2,np.diff(arc)[-1]/2]
  results.append({'stations':n,'sourceToChordArcWeightedMean':float(np.dot(dist,weights)/weights.sum()),'chordToSourceMax':float(rd.max()),'chordToSourceSampleMean':float(rd.mean()),'symmetricSampledHausdorff':float(max(dist.max(),rd.max())),'maxCenterlineChordDeviation':float(dist.max()),'rmsDeviation':float(np.sqrt((dist**2).mean())),'radiusMultipleMax':float(dist.max()/o['bevelDepth']),'closedCrossSection3Vertices':3*n,'uncappedTubeTriangles':6*(n-1),'points':points.tolist()})
 # Also retain authored five control centers, without choosing based on rendered outcomes.
 points=np.array([p['co'] for p in ps]);dist=np.full(len(samples),np.inf)
 for a,b in zip(points,points[1:]):
  ab=b-a;t=np.clip((samples-a)@ab/np.dot(ab,ab),0,1);dist=np.minimum(dist,np.linalg.norm(samples-a-t[:,None]*ab,axis=1))
 rows.append({'name':o['name'],'centerlineLength':float(arc[-1]),'sourceTubeRadius':o['bevelDepth'],'denseOracleSamples':len(samples),'equalArcStationMeasurements':results,'authoredFiveControlCentersChordMax':float(dist.max())})
(P/'centerline-feasibility.json').write_text(json.dumps(rows,indent=2));print(json.dumps(rows,indent=2))
