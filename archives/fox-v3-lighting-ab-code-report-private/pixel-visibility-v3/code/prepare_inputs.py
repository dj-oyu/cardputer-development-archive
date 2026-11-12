import json,pathlib,struct,hashlib,math
R=pathlib.Path(__file__).resolve().parents[1]; W=R.parent
v=json.loads((W/'fox-reference-uncertainty-v3/input/config.json').read_text()); source=json.loads((R/'inputs/source-materials.json').read_text())
assert source['sourceSHA256']==v['sourceSHA256']
p=W/'fox-native-private/fox-auto1200.glb';b=p.read_bytes();assert hashlib.sha256(b).hexdigest()=='f5ac204a278706424ec76c7e2f68a1db65c47add9b7c1f3c093c2a902b8fffcc'
n=struct.unpack_from('<I',b,12)[0];g=json.loads(b[20:20+n]);old=json.loads(b[20:20+n]);audit=[]
for m in g['materials']:
 s=source['materials'][m['name']];assert max(abs(a-c) for a,c in zip(s['baseColor'],m['pbrMetallicRoughness']['baseColorFactor']))<1e-7
 m['doubleSided']=s['doubleSided'];audit.append({'name':m['name'],'oldDoubleSided':False,'newDoubleSided':m['doubleSided']})
j=json.dumps(g,separators=(',',':')).encode();j+=b' '*((-len(j))%4);rest=b[20+n:];nb=struct.pack('<III',0x46546c67,2,20+len(j)+len(rest))+struct.pack('<II',len(j),0x4e4f534a)+j+rest
assert nb[20+len(j):]==rest
(R/'inputs/geometry-source-sided.glb').write_bytes(nb)
scenarios=[]
for s in v['scenarios']:
 d=s.get('blenderLight',[-3,-4,6-1.7]);l=[d[0],-d[2],-d[1]]
 scenarios.append({**s,'ambient':.35*s.get('richWorldScale',1),'diffuse':.65,'intensity':[c*s.get('richEnergyScale',1) for c in (1,.83,.65)],'nativeDirection':l})
r={'version':'new-candidate-v3-rebuilt-4a4d','referenceConfigSHA256':hashlib.sha256((W/'fox-reference-uncertainty-v3/input/config.json').read_bytes()).hexdigest(),'sourceSHA256':v['sourceSHA256'],'geometrySourceSHA256':hashlib.sha256(b).hexdigest(),'geometrySHA256':hashlib.sha256(nb).hexdigest(),'geometryBinUnchanged':True,'geometryScope':'Preserved earlier 1200-budget reduced mesh. Not lost 2400/2048 candidate. Only authored material sidedness restored.','materialSidednessAudit':audit,'cameras':v['cameras'],'scenarios':scenarios,'mapping':'Single directional capacity projection: key center minus authoring target; key RGB times relative energy; scalar world strength; artist diffuse .65. No physical unit equivalence or fitted coefficients. Legacy encoded-space shading.','unsupported':['area size/position attenuation','fill and rim','world RGB and visibility','ground emission','GI','AgX display profile','PBR/GGX/specular','animation']}
(R/'inputs/candidate-config.json').write_text(json.dumps(r,indent=2))
