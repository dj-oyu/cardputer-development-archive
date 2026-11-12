from pathlib import Path
import json, hashlib
W=Path(__file__).resolve().parent.parent
rows=[];pins={}
for p in sorted((W/'fox-v3-boundary-aa-evaluation/actual-001/on/private-partial').glob('*.json')):
 x=json.loads(p.read_text())
 if 'primary_ground_hits' not in x or x.get('reverse'): continue
 rows.append(dict(case=p.stem,primaryGroundHits=x['primary_ground_hits'],maximumAdditionalDiskSegments=48*x['primary_ground_hits'],existingTransportRays=x['transportRays'],existingTransportNodes=x['transportNodeVisits'],existingTransportTriangles=x['transportTriangleTests'],rayUpperAfter=x['transportRays']+48*x['primary_ground_hits'],rayCap=x['transportRayLimit'],nodeCap=x['transportNodeLimit'],triangleCap=x['transportTriangleLimit']))
 pins[str(p.relative_to(W))]=hashlib.sha256(p.read_bytes()).hexdigest()
assert len(rows)==10
j=dict(scope='Existing v32 counters plus 48 potential disk segments per first ground hit; no new run, no node/triangle fit guarantee, no unchanged-stage-ledger claim',rows=rows,pins=pins)
(Path(__file__).parent/'cost-envelope.json').write_text(json.dumps(j,indent=2))
