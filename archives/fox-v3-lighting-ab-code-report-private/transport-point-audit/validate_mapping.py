from pathlib import Path
import json,struct,hashlib,numpy as np,sys
R=Path(__file__).resolve().parent;B=R.parent/'fox-v3-lid-evaluation/actual-lid8-v2';C=R/'capture-002';sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();plan=R.parent/'fox-v3-transport-point-selection/PLAN.json';assert sha(plan)=='d51dcef666d8c44d583909c3b2499e16d513d83b334f66b85f18a0e0d6c6d8bc';names={x['sourceNode']:x['name'] for x in json.loads(plan.read_text())['sourceObjectMapping']};groups={x['sourceNode']:x['group'] for x in json.loads(plan.read_text())['sourceObjectMapping']}
assert (C/'COMPLETED.json').exists();O=R/'verified-winners-v2';O.mkdir(exist_ok=False);summary=[]
for view in ['front','oblique']:
 for case in ['baseline','direction']:
  key='native-'+view+'-'+case;prefix=C/key;raw=Path(str(prefix)+'.snapshot').read_bytes();records={};at=416
  while at<len(raw):
   nv,nt,mode,res=raw[at:at+4];node=struct.unpack_from('<H',raw,at+4)[0];size=struct.unpack_from('<H',raw,at+10)[0];assert mode in [4,5] and res==0;stride=50 if mode==5 else 56;v=[]
   for j in range(nv):
    off=at+12+stride*j;front=list(struct.unpack_from('<3h',raw,off+44));back=[-x for x in front] if mode==5 else list(struct.unpack_from('<3h',raw,off+50));v.append({'world':list(struct.unpack_from('<3d',raw,off+20)),'mask':struct.unpack_from('<f',raw,off+8)[0],'colors':list(struct.unpack_from('<2H',raw,off+16)),'front':front,'back':back})
   off=at+12+stride*nv;tri=[list(raw[off+3*t:off+3*t+3]) for t in range(nt)];bits=raw[off+3*nt:off+3*nt+(nt+7)//8];assert node not in records;records[node]={'vertices':v,'triangles':tri,'sides':[(bits[t//8]>>(t%8))&1 for t in range(nt)]};at+=size
  assert at==len(raw)
  comp=json.loads((B/f'compiled/model-{case}/compile.json').read_text());maps=json.loads(Path(str(prefix)+'-mapping.json').read_text());assert len(maps)==len(records)==len(comp['parts']);mapped={}
  for m in maps:
   node=m['node'];part=comp['parts'][node-1];n=m['vertices'];assert n==len(part['positions']);source=[m['sourceIndices'][j:j+3] for j in range(0,len(m['sourceIndices']),3)];assert source==part['triangles'] and len(source)==m['sourceTriangles'];expected=np.asarray(part['positions'])*38;assert np.array_equal(expected.astype(np.float32).astype(np.float64).reshape(-1),m['sourceWorld']);world=np.array(m['sourceWorld']).reshape(n,3).tolist();patch=[m['patchIndices'][j:j+3] for j in range(0,len(m['patchIndices']),3)];used=sorted(set(m['patchIndices']));r=records[node];assert len(used)==len(r['vertices']);remap={old:new for new,old in enumerate(used)};assert [[remap[x] for x in t] for t in patch]==r['triangles'];assert all(r['vertices'][j]['world']==world[old] for j,old in enumerate(used))
   face_map=[]
   for t in patch:
    matches=[i for i,s in enumerate(source) if sorted(s)==sorted(t)];assert len(matches)==1,'ambiguous source face';face_map.append(matches[0])
   mapped[node]=(part,face_map)
  capture=json.loads(Path(str(prefix)+'-winners.json').read_text());depth=np.fromfile(str(prefix)+'.f32le','<f4').reshape(135,240);hdr=np.fromfile(str(prefix)+'-combined.f64le','<f8').reshape(135,240,3);assert len(capture['points'])==int(np.isfinite(depth).sum());seen=set()
  for q in capture['points']:
   x,y=q['x'],q['y'];assert (x,y) not in seen;seen.add((x,y));r=records[q['node']];assert q['indices']==r['triangles'][q['face']] and q['back']==r['sides'][q['face']];assert q['rgb']==hdr[y,x].tolist()
   for j,index in enumerate(q['indices']):
    a=q['vertices'][j];b=r['vertices'][index];assert a['world']==b['world'] and a['colors']==b['colors'] and a['front']==b['front'] and a['back']==b['back'];assert np.float32(a['mask'])==b['mask']
   world=[0.,0.,0.]
   for j in range(3):
    for k in range(3):world[k]+=q['weights'][j]*q['vertices'][j]['world'][k]
   p=[world[0]/38,-world[2]/38,-world[1]/38];assert p==q['position'];assert all(np.isfinite(q[k]).all() for k in ['position','normal','rho']);assert any(q['normal']);part,face_map=mapped[q['node']];canonical_face=face_map[q['face']];origin=part['origins'][canonical_face];source_node=int(origin['surface'].split('/')[1]);assert source_node in names
   q.update(coverage=True,depth=float(depth[y,x]),physicalSide='back' if q['back'] else 'front',sourceObjectId=source_node,sourceObjectName=names[source_node],sourceGroup=groups[source_node],sourceSurface=origin['surface'],sourceTriangle=origin['triangle'],compiledPart=q['node']-1,compiledSourceFace=canonical_face,P=q['position'],Ns=q['normal'])
  out={'version':'verified-actual-winners-v1','view':view,'case':case,'width':240,'height':135,'nohitImplicitCoverageFalse':True,'points':capture['points'],'sourceObjectNames':names,'selectionPlanSHA256':sha(plan),'sourceGeometrySHA256':'833ac7683872375f9e63f819618e0e25ed40e0ac761a35f7604cd45501207a8e','compileSHA256':sha(B/f'compiled/model-{case}/compile.json'),'snapshotSHA256':sha(Path(str(prefix)+'.snapshot')),'mappingSHA256':sha(Path(str(prefix)+'-mapping.json')),'winnerCaptureSHA256':sha(Path(str(prefix)+'-winners.json')),'controlSHA256':sha(C/'COMPLETED.json'),'allSourceWorldAndTriangleIndicesExact':True,'allCompactVertexRemapsExact':True,'allCapturedWinnerVerticesSidesAndSourceOriginsVerified':True};file=O/(view+'-'+case+'.json');file.write_text(json.dumps(out,separators=(',',':')));summary.append({'view':view,'case':case,'path':str(file),'sha256':sha(file),'coveredPixels':len(seen),'mappedRecords':len(mapped),'allChecksPassed':True})
(R/'mapping-proof.json').write_text(json.dumps({'selectionPlanSHA256':sha(plan),'frames':summary,'noReferencePixelsRead':True},indent=2));print(json.dumps(summary,indent=2))
