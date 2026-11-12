from pathlib import Path
import hashlib,json,math,struct
D=Path(__file__).resolve().parent;R=D.parent;T=R/'fox-v3-lid-transport-point-audit';sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();plan=json.loads((D/'PLAN.json').read_text());ph=sha(D/'PLAN.json');assert ph=='d51dcef666d8c44d583909c3b2499e16d513d83b334f66b85f18a0e0d6c6d8bc'
assert sha(R/plan['sourceGeometry'])==plan['sourceGeometrySHA256'];proof=json.loads((T/'mapping-proof.json').read_text());ctl=T/'capture-002/COMPLETED.json';c=json.loads(ctl.read_text());assert all(c[k] for k in ['rgbDepthAllExactBaseline','allFourSnapshotsExact','allNonTimingMetadataExact','inputsUnchanged']);assert proof['selectionPlanSHA256']==ph and proof['noReferencePixelsRead'];groupmap={r['name']:r['group'] for r in plan['sourceObjectMapping']};idmap={r['sourceNode']:r['name'] for r in plan['sourceObjectMapping']};captures={};inputs={str(ctl.relative_to(R)):sha(ctl),str((T/'mapping-proof.json').relative_to(R)):sha(T/'mapping-proof.json')}
for frame in proof['frames']:
 p=Path(frame['path']);assert frame['allChecksPassed'] and sha(p)==frame['sha256'];d=json.loads(p.read_text());view,case=d['view'],d['case'];assert d['selectionPlanSHA256']==ph and d['sourceGeometrySHA256']==plan['sourceGeometrySHA256'];assert (d['width'],d['height'],d['nohitImplicitCoverageFalse'])==(240,135,True)
 assert all(d[k] for k in ['allSourceWorldAndTriangleIndicesExact','allCompactVertexRemapsExact','allCapturedWinnerVerticesSidesAndSourceOriginsVerified']);assert {int(k):v for k,v in d['sourceObjectNames'].items()}==idmap
 stem=f'native-{view}-{case}';cap=T/'capture-002';old=R/'fox-v3-lid-evaluation/actual-lid8-v2';hdr=R/'fox-v3-lid-display-combination/run-001'
 for suffix,ref in [('.u16le',old),('.f32le',old),('-combined.f64le',hdr)]:
  a=cap/(stem+suffix);b=ref/(stem+suffix);assert a.read_bytes()==b.read_bytes();inputs[str(a.relative_to(R))]=sha(a);inputs[str(b.relative_to(R))]=sha(b)
 depth=struct.unpack('<32400f',(cap/(stem+'.f32le')).read_bytes());pts={}
 for z in d['points']:
  x,y=z['x'],z['y'];assert type(x)==type(y)==int and 0<=x<240 and 0<=y<135 and (x,y) not in pts and z['coverage'];assert z['sourceObjectName'] in groupmap and idmap[z['sourceObjectId']]==z['sourceObjectName'];assert z['depth']==depth[y*240+x]
  for k in ['P','Ns','rho']:assert len(z[k])==3 and all(math.isfinite(v) for v in z[k])
  assert sum(v*v for v in z['Ns'])>0 and all(0<=v<=1 for v in z['rho']);pts[x,y]=z
 assert len(pts)==sum(math.isfinite(z) for z in depth);captures[view,case]=pts;inputs[str(p.relative_to(R))]=sha(p)
assert set(captures)=={(v,c) for v in plan['views'] for c in plan['pairedCases']}
selected=[];strata=[];coverage=[];pairfields=['node','face','physicalSide','sourceObjectId','sourceObjectName','depth','P','Ns','rho']
for view in plan['views']:
 pts=captures[view,'baseline'];paired=captures[view,'direction'];buckets={(g,s):[] for g in plan['groupOrder'] for s in ['interior','boundary']};silhouette=0
 for (x,y),p in pts.items():
  neighbours=[pts.get((x+dx,y+dy)) for dx,dy in [(1,0),(-1,0),(0,1),(0,-1)]];isSil=any(n is None for n in neighbours);silhouette+=isSil;boundary=any(n is None or n['sourceObjectName']!=p['sourceObjectName'] for n in neighbours);s='boundary' if boundary else 'interior';g=groupmap[p['sourceObjectName']];key=f'lid8-transport-points-v1|{view}|{g}|{s}|{x}|{y}';rank=hashlib.sha256(key.encode('utf8')).hexdigest();buckets[g,s].append((rank,y,x))
 for g in plan['groupOrder']:
  for s in ['interior','boundary']:
   choices=sorted(buckets[g,s]);strata.append({'view':view,'group':g,'stratum':s,'available':len(choices),'selected':min(4,len(choices)),'shortfall':max(0,4-len(choices))})
   for rank,y,x in choices[:4]:
    p=pts[x,y];q=paired.get((x,y));bad=[k for k in pairfields if q is None or p[k]!=q[k]];selected.append({'view':view,'x':x,'y':y,'group':g,'stratum':s,'rankSHA256':rank,'sourceObjectId':p['sourceObjectId'],'sourceObjectName':p['sourceObjectName'],'node':p['node'],'face':p['face'],'physicalSide':p['physicalSide'],'pairStatus':'EXACT' if not bad else 'BLOCKED_NO_RESELECTION','pairedMismatches':bad})
 nohitBoundary=sum(any((x+dx,y+dy) in pts for dx,dy in [(1,0),(-1,0),(0,1),(0,-1)]) for y in range(135) for x in range(240) if (x,y) not in pts);coverage.append({'view':view,'nativeCovered':len(pts),'nativeNoHit':32400-len(pts),'nativeCoveredSilhouetteBoundary':silhouette,'nativeNoHitAdjacentToCoverage':nohitBoundary})
out={'version':plan['version'],'planSHA256':ph,'status':'SELECTION_FROZEN_BEFORE_REFERENCE_LABELS_AND_TRANSPORT_AUDIT','inputs':inputs,'selectedCount':len(selected),'pairedCaseQueries':2*len(selected),'points':selected,'strata':strata,'nativeCoverage':coverage,'sourceImagesOrReferenceMasksRead':False,'notPopulationWeighted':True,'incompletePairs':sum(p['pairStatus']!='EXACT' for p in selected)}
assert not (D/'selection.json').exists();(D/'selection.json').write_text(json.dumps(out,indent=2,ensure_ascii=False));(D/'selection-frozen.sha256').write_text(sha(D/'selection.json')+'  selection.json\n');print('selected',len(selected),'pairedBlocked',out['incompletePairs']);print('shortfalls',[x for x in strata if x['shortfall']])
