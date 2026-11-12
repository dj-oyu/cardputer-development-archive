import pathlib,json,struct,hashlib,copy
r=pathlib.Path(__file__).resolve().parents[1];w=r.parent
old=(w/'fox-native-private/fox-auto1200.glb').read_bytes();new=(r/'inputs/geometry-source-sided.glb').read_bytes()
def read(b):
 n=struct.unpack_from('<I',b,12)[0];return json.loads(b[20:20+n]),b[20+n:]
a,ab=read(old);b,bb=read(new);assert ab==bb
for m in b['materials']:del m['doubleSided']
assert a==b
c=json.loads((r/'inputs/candidate-config.json').read_text());v=json.loads((w/'fox-reference-uncertainty-v3/input/config.json').read_text());s=json.loads((w/'fox-reference-uncertainty-v3/input/source-settings.json').read_text())
assert c['cameras']==v['cameras'];assert abs(s['worldStrength']-.35)<1e-7
assert c['referenceConfigSHA256']==hashlib.sha256((w/'fox-reference-uncertainty-v3/input/config.json').read_bytes()).hexdigest()
assert c['sourceSHA256']==hashlib.sha256(pathlib.Path(v['source']).read_bytes()).hexdigest()
assert [x['name'] for x in c['scenarios']]==[x['name'] for x in v['scenarios']]
for x,y in zip(c['scenarios'],v['scenarios']):
 for k,val in y.items():assert x[k]==val
print('PASS geometry BIN and all non-sided JSON unchanged; source/ref/cameras/five scenarios/ambient contracts')
