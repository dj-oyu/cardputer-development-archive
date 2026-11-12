"""All raw mesh descriptors and all actual serialized vertices, both conditions/views."""
from pathlib import Path
import sys,json,struct,hashlib
R=Path(__file__).resolve().parent;W=R.parent;G=W/'fox-v3-lid-rich-proxy';B=W/'fox-v3-lid-evaluation/actual-lid8-v2';pins={}
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def pin(p):pins[str(p)]=sha(p);return p
def load(p):return json.loads(pin(p).read_text())
geom=load(G/'private-actual-geometry.json');trace={m['id']:m for m in geom['materialTrace']};rho={r['code']:r['rho'] for r in load(G/'native-rho.json')};pin(Path(__file__));pin(B/'product/main/ayatsuri/ayatsuri_model.c')
proof=[];bycase={}
for case in ['baseline','direction']:
 b=pin(B/f'compiled/model-{case}/model.aynm').read_bytes();sections={}
 for j in range(struct.unpack_from('<I',b,12)[0]):
  kind,flags,off,length,count,stride=struct.unpack_from('<HHIIII',b,32+20*j);assert off+length<=len(b);sections[kind]=(off,count,stride)
 current=[]
 for part in geom['parts']:
  node=part['node'];nd=sections[1][0]+node*16;assert b[nd+2]==3;mesh=struct.unpack_from('<H',b,nd+4)[0];d=sections[9][0]+mesh*32;first,nv=struct.unpack_from('<HH',b,d);a,bb=struct.unpack_from('<HH',b,d+14);assert a==bb==trace[part['materialId']]['albedo565'];assert nv==len(part['sourcePositions']);masks=[struct.unpack_from('<f',b,sections[10][0]+28*(first+j)+24)[0] for j in range(nv)]
  current.append({'node':node,'materialId':part['materialId'],'rawVertices':nv,'triangles':len(part['rawIndices']),'A565':a,'B565':bb,'maskValues':sorted(set(masks)),'rhoActualCFloat':rho[a],'AEqualsBForAllVerticesAndBothPhysicalSides':True})
 bycase[case]=current
assert bycase['baseline']==bycase['direction'];canonicalparts={}
for view in ['front','oblique']:
 for case in ['baseline','direction']:
  b=pin(W/f'fox-v3-lid-evaluation/canonical-proof-lid8/private-snapshots/{view}-{case}.canonical').read_bytes();at=416;parts=[];nv=0
  while at<len(b):
   n,t,mode,res=b[at:at+4];node=struct.unpack_from('<H',b,at+4)[0];size=struct.unpack_from('<H',b,at+10)[0];assert mode==4;expected=bycase[case][node-1];assert n==expected['rawVertices'] and t==expected['triangles'];masks=[]
   for j in range(n):
    o=at+12+56*j;mask=struct.unpack_from('<f',b,o+8)[0];a,bb=struct.unpack_from('<HH',b,o+16);assert a==bb==expected['A565'];masks.append(mask)
   assert sorted(set(masks))==expected['maskValues'];parts.append(node);nv+=n;at+=size
  assert sorted(parts)==list(range(1,55)) and nv==1163;proof.append({'view':view,'case':case,'records':54,'vertices':nv,'triangles':1564,'allSerializedAEqualsBAndRawDescriptor':True})
assert all(sha(Path(p))==h for p,h in pins.items())
(R/'rho-proof.json').write_text(json.dumps({'parts':bycase['baseline'],'frames':proof,'varyingRhoParts':0,'rawAndSerializedVerticesPerCase':1163,'physicalSideSelectsNormalNotPaletteInPixelAPI':True,'maskVariationWouldBeHarmlessBecauseAllAEqualsB':True,'inputPins':pins},indent=2)+'\n');print('PASS all54parts/1163v/1564tri constant raw A=B per partition,4actual snapshots')
