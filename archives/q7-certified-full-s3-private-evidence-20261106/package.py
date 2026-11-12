from pathlib import Path
import json,zipfile,hashlib
r=Path(__file__).resolve().parent
files=[]
for p in r.iterdir():
 if p.is_file() and p.suffix in ['.json','.txt','.log','.py','.sh','.patch','.md']:files.append(p)
files+=list(p for p in (r/'evidence').rglob('*') if p.is_file())
m=json.loads((r/'SOURCE_MANIFEST.json').read_text())
files += [r/'source'/x['path'] for x in m['files']]
files += [r/'source'/n for n in ['sdkconfig.defaults','partitions.csv','main/ui/kasane/ksn_mesh_prepared.c','main/ui/kasane/ksn_mesh_prepared.h','main/ui/kasane/ksn_mesh_depth.c','main/ui/kasane/ksn_mesh_depth.h','main/ui/kasane/ksn_shiki_frame.h','main/ayatsuri/compact_opaque.h']]
manifest={str(p.relative_to(r)):{'bytes':p.stat().st_size,'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in sorted(set(files))}
(r/'EVIDENCE_MANIFEST.json').write_text(json.dumps(manifest,indent=2)+'\n');files.append(r/'EVIDENCE_MANIFEST.json')
z=r/'q7-certified-full-s3-private-evidence-20261106.zip'
with zipfile.ZipFile(z,'w',zipfile.ZIP_DEFLATED,compresslevel=6) as f:
 for p in sorted(set(files)):f.write(p,str(p.relative_to(r)))
with zipfile.ZipFile(z) as f:assert f.testzip() is None
print(json.dumps({'path':str(z),'bytes':z.stat().st_size,'sha256':hashlib.sha256(z.read_bytes()).hexdigest(),'entries':len(set(files))}))
