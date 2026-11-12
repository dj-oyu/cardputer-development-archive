from pathlib import Path
import json,hashlib,struct
R=Path(__file__).resolve().parent;W=R.parent;e=json.loads((R/'estimate.json').read_text());out={}
for v,z in e['views'].items():
 terms={'setupBind':4+2*54+2*1564+3,'centerBands':17,'mask':2,'sampleBands':34,'samplePhases':204,'finalScans':17,'encodes':z['targets'],'centerUpdates':z['centerBboxVisits'],'recordVisits':54*68,'faceVisits':1564*68,'bboxGuards':sum(a['nonemptyBandBoxes'] for a in z['arms']),'targetGeometry':sum(a['targetBBoxVisits'] for a in z['arms']),'sampleShades':4*z['targets']}
 out[v]={'terms':terms,'totalUpper':sum(terms.values()),'reserved':310000};assert out[v]['totalUpper']<=310000
proj={};pins={}
for p in (W/'fox-v3-lid-evaluation/canonical-proof-lid8/private-snapshots').glob('*.canonical'):
 b=p.read_bytes();pins[str(p)]=hashlib.sha256(b).hexdigest();at=416;tri=[]
 while at<len(b):
  n,t=b[at:at+2];size=struct.unpack_from('<H',b,at+10)[0];vs=[struct.unpack_from('<ff',b,at+12+56*j) for j in range(n)];ix=at+12+56*n
  for j in range(t):tri.append(sorted(vs[k] for k in b[ix+3*j:ix+3*j+3]))
  at+=size
 assert len(tri)==1564;proj[p.name]=hashlib.sha256(json.dumps(sorted(tri)).encode()).hexdigest()
assert len(proj)==20
for v in ['front','oblique']:assert len({h for k,h in proj.items() if k.startswith(v+'-')})==1
(R/'guard-and-projection-proof.json').write_text(json.dumps({'guardDispatch':out,'all20ProjectedTriangleMultisetHashes':proj,'inputPins':pins,'scope':'exact xy triangle multiset guarantees identical bbox visits; center target source IDs independently pinned v32 per-frame admission'},indent=2)+'\n');print(out)
