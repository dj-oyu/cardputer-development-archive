from pathlib import Path
import json,struct,hashlib,sys,numpy as np
R=Path(__file__).resolve().parent;W=R.parent;B=W/'fox-v3-lid-evaluation/actual-lid8-v2';C=W/'fox-v3-lid-transport-point-audit/capture-002';sys.path.insert(0,str(B/'code'));from codec_audit import decode_snapshot
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();cfg=json.loads((B/'inputs/candidate-config.json').read_text());comp=json.loads((B/'compiled/model-baseline/compile.json').read_text());parts=[];proof=[];pins={}
for view in ['front','oblique']:
 for case in ['baseline','direction']:
  name='native-'+view+'-'+case;wire=C/(name+'.snapshot');mapping=C/(name+'-mapping.json');canonical=W/f'fox-v3-lid-evaluation/canonical-proof-lid8/private-snapshots/{view}-{case}.canonical';raw=canonical.read_bytes();old,counts,nv,nt=decode_snapshot(wire.read_bytes());assert raw==old and nv==1163 and nt==1564;records={};at=416
  while at<len(raw):
   n,t,mode,res=raw[at:at+4];node=struct.unpack_from('<H',raw,at+4)[0];size=struct.unpack_from('<H',raw,at+10)[0];assert mode==4 and res==0;v=[]
   for j in range(n):
    o=at+12+56*j;v.append({'world':list(struct.unpack_from('<3d',raw,o+20)),'frontSNORM16':list(struct.unpack_from('<3h',raw,o+44)),'backSNORM16':list(struct.unpack_from('<3h',raw,o+50))})
   o=at+12+56*n;tri=[list(raw[o+3*j:o+3*j+3]) for j in range(t)];bits=raw[o+3*t:o+3*t+(t+7)//8];records[node]=(v,tri,[(bits[j//8]>>(j%8))&1 for j in range(t)]);at+=size
  maps=json.loads(mapping.read_text());current=[];checked=0;sidechecked=0;rawvertices=0
  cam=next(x for x in json.loads((W/'fox-reference-uncertainty-v3/input/config.json').read_text())['cameras'] if x['name']==view);V=np.array(cam['blenderLocation'])-cam['blenderTarget'];V/=np.linalg.norm(V)
  for m in maps:
   node=m['node'];p=comp['parts'][node-1];n=m['vertices'];indices=np.array(m['sourceIndices']).reshape(-1,3);patch=np.array(m['patchIndices']).reshape(-1,3);used=sorted(set(m['patchIndices']));assert used==list(range(n));assert m['triangles']==m['sourceTriangles']==len(p['triangles']);assert indices.tolist()==p['triangles'];v,tri,sides=records[node];assert n==len(v)==len(p['positions']);assert patch.tolist()==tri;world=np.array(m['sourceWorld']).reshape(n,3)
   assert np.array_equal(world,(np.array(p['positions'])*38).astype(np.float32).astype(np.float64));assert np.array_equal(world,np.array([x['world'] for x in v]));front=np.array([x['frontSNORM16'] for x in v]);back=np.array([x['backSNORM16'] for x in v]);assert np.array_equal(back,-front) and (np.linalg.norm(front,axis=1)>0).all();positions=world[:,[0,2,1]]*[1,-1,-1]/38;normals=front[:,[0,2,1]]*[1,-1,-1];normals=normals/np.linalg.norm(normals,axis=1)[:,None];permutation=[]
   for j,t in enumerate(patch):
    match=np.where(np.all(np.sort(indices,axis=1)==np.sort(t),axis=1))[0];assert len(match)==1;f=int(match[0]);permutation.append(f);winding=indices[f,[0,2,1]];a,b,c=positions[winding];dot=float(np.cross(b-a,c-a)@V);assert abs(dot)>1e-12 and (dot>0)==(sides[j]==0);sidechecked+=1
   assert sorted(permutation)==list(range(len(indices)));checked+=len(indices);rawvertices+=n
   current.append({'node':node,'materialId':p['materialId'],'positionsNative':world.tolist(),'frontSNORM16':front.tolist(),'backSNORM16':back.tolist(),'rawIndices':indices.tolist(),'sourcePositions':positions.tolist(),'sourceFrontNormals':normals.tolist(),'sourceIndices':indices[:,[0,2,1]].tolist(),'origins':p['origins']})
  assert checked==1564 and rawvertices==1163 and len(current)==54
  if not parts:parts=current
  else:assert parts==current
  pins.update({str(p):sha(p) for p in [wire,mapping,canonical]});proof.append({'view':view,'case':case,'allRawVerticesCovered':rawvertices,'allRawTrianglesCovered':checked,'allRawFrontBackExactOpposite':True,'allPhysicalSideFlagsChecked':sidechecked,'canonicalIndependentOldWriterExact':True})
negfaces=0;negcorners=0;meannegfaces=0;minDot=1
for p in parts:
 xyz=np.array(p['sourcePositions']);ns=np.array(p['sourceFrontNormals']);ix=np.array(p['sourceIndices']);tri=xyz[ix];ng=np.cross(tri[:,1]-tri[:,0],tri[:,2]-tri[:,0]);ng/=np.linalg.norm(ng,axis=1)[:,None];dots=np.sum(ng[:,None,:]*ns[ix],axis=2);negfaces+=int((dots<0).any(1).sum());negcorners+=int((dots<0).sum());meannegfaces+=int((dots.mean(1)<0).sum());minDot=min(minDot,float(dots.min()))
(R/'private-actual-geometry.json').write_text(json.dumps({'parts':parts,'materialTrace':comp['materialTrace']},separators=(',',':')));(R/'geometry-proof.json').write_text(json.dumps({'version':'current-lid8-full-actual-geometry-v1','inputPins':pins,'compiledSHA256':sha(B/'compiled/model-baseline/compile.json'),'sourceGeometrySHA256':'833ac7683872375f9e63f819618e0e25ed40e0ac761a35f7604cd45501207a8e','privateGeometrySHA256':sha(R/'private-actual-geometry.json'),'parts':54,'vertices':1163,'triangles':1564,'frames':proof,'ngNsAnyNegativeFaces':negfaces,'ngNsNegativeCorners':negcorners,'ngNsFaceMeanNegativeFaces':meannegfaces,'minimumNgDotNs':minDot,'geometryIsNotOriginalRichMesh':True},indent=2));print('PASS',negfaces,negcorners,minDot)
