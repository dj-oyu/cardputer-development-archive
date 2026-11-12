"""Create a pinned camera-independent ordered triangle/source-ID table, private payload."""
from pathlib import Path
import json,struct,hashlib
R=Path(__file__).resolve().parents[1];W=R.parent;B=W/'fox-v3-lid-evaluation/actual-lid8-v2';CAN=W/'fox-v3-lid-evaluation/canonical-proof-lid8/private-snapshots';pins={};sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def pin(p):pins[str(p)]=sha(p);return p
def load(p):return json.loads(pin(p).read_text())
comp=load(B/'compiled/model-baseline/compile.json');parts=comp['parts'];assert len(parts)==54;offsets=[0];data=bytearray();original=[]
for p in parts:
 faces=[];seen=set()
 for ix,origin in zip(p['triangles'],p['origins']):
  assert len(ix)==3 and len(set(ix))==3 and all(type(x) is int and 0<=x<32 for x in ix);key=tuple(sorted(ix));assert key not in seen,'ambiguous duplicate unordered triangle';seen.add(key);source=int(origin['surface'].split('/')[1]);assert 0<=source<92
  data.extend(struct.pack('<BBBH',*ix,source));faces.append((ix,source))
 original.append(faces);offsets.append(offsets[-1]+len(faces))
assert offsets[-1]==1564;blob=struct.pack('<55H',*offsets)+data;assert len(blob)==7930
proof=[]
for view in ['front','oblique']:
 for case in ['baseline','direction','intensity','albedo','ambient']:
  c=load(B/f'compiled/model-{case}/compile.json');assert all(p['triangles']==q['triangles'] and p['origins']==q['origins'] for p,q in zip(parts,c['parts']))
  for order in ['', '-reverse']:
   raw=pin(CAN/f'{view}-{case}{order}.canonical').read_bytes();at=416;nodes=set();faces=0;sidecounts=[0,0]
   while at<len(raw):
    n,t,mode,res=raw[at:at+4];node=struct.unpack_from('<H',raw,at+4)[0];size=struct.unpack_from('<H',raw,at+10)[0];assert mode==4 and 1<=node<=54 and node not in nodes;nodes.add(node);assert t==len(original[node-1]);ix=at+12+56*n;bits=raw[ix+3*t:ix+3*t+(t+7)//8]
    lookup={tuple(sorted(tri)):(tri,source) for tri,source in original[node-1]}
    for j in range(t):
     actual=list(raw[ix+3*j:ix+3*j+3]);tri,source=lookup[tuple(sorted(actual))];perm=[tri.index(a) for a in actual];parity=sum(perm[a]>perm[b] for a in range(3) for b in range(a+1,3))&1;back=(bits[j//8]>>(j%8))&1;assert parity==back;sidecounts[back]+=1;faces+=1
    at+=size
   assert at==len(raw) and len(nodes)==54 and faces==1564;meta=load(B/f'native-{view}-{case}{order}.json');proof.append({'view':view,'case':case,'reverse':bool(order),'allTrianglesAndSourceIdentitiesExact':True,'physicalFrontBackCounts':sidecounts,'snapshotFingerprint':meta['visibilitySnapshotFingerprint'],'geometryFingerprint':meta['visibilityGeometryFingerprint'],'work':meta['work'],'centerDirect':[meta[k] for k in ['visibilityRays','visibilityNodeVisits','visibilityTriangleTests']],'centerTransport':[meta[k] for k in ['transportRays','transportNodeVisits','transportTriangleTests']]})
(R/'private/identity.bin').write_bytes(blob);h=14695981039346656037
for b in blob:h=((h^b)*1099511628211)&0xffffffffffffffff
(R/'private/identity.h').write_text('/* Private geometry provenance payload; never bundle. */\nstatic const unsigned char boundary_identity_bytes[7930]={'+','.join(map(str,blob))+'};\n')
assert all(sha(Path(p))==s for p,s in pins.items());(R/'identity-proof.json').write_text(json.dumps({'format':'55 LE16 part offsets followed by1564 packed ordered local vertex triple +LE16 sourceobject ID; physicalback equals permutation parity','bytes':7930,'nodeRange':[1,54],'sourceObjectRange':[0,91],'faceLimit':64,'vertexIndexLimit':32,'duplicateUnorderedTriangleKeys':0,'identitySHA256':sha(R/'private/identity.bin'),'identityFNV64':f'{h:016x}','all20SnapshotsVerified':proof,'inputPins':pins},indent=2)+'\n');print('PASS 20 snapshots;7930B;SHA',sha(R/'private/identity.bin'),'FNV',f'{h:016x}')
