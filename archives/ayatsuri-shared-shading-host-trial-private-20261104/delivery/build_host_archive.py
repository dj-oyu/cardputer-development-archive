"""Append verified isolated experiment artifacts; exclude raster outputs/executables."""
from pathlib import Path
import json,zipfile,hashlib
root=Path(__file__).resolve().parent.parent
arc=root/'delivery/ayatsuri-shared-shading-host-trial-private-20261104.zip'
with zipfile.ZipFile(arc) as z:names=set(z.namelist())-{'MANIFEST.json'}
ident=json.loads((root/'CURRENT_SOURCE_IDENTITIES.json').read_text())
for v in ['baseline','candidate','candidate-bounded','candidate-early-snorm','candidate-typed-stores']:
 ident[v]={str(p.relative_to(root/v)):hashlib.sha256(p.read_bytes()).hexdigest() for p in sorted((root/v).rglob('*')) if p.is_file()}
(root/'CURRENT_SOURCE_IDENTITIES.json').write_text(json.dumps(ident,indent=2)+'\n')
for n in ['TYPED_STORE_RESULTS.md','delivery/typed-stores.patch','delivery/build_host_archive.py','review/typed-stores-review.md','delivery/TYPED_S3_EVIDENCE_VERIFIED.json']:names.add(n)
for d in ['candidate-typed-stores','analysis/typed-stores','tests/typed-stores','results/typed-stores','results/typed-stores-alias','review/typed-stores']:
 for p in (root/d).rglob('*'):
  if not p.is_file() or p.is_symlink() or '__pycache__' in str(p):continue
  if p.suffix in ['.o','.bin','.elf','.text','.zip','.pyc']:continue
  if p.read_bytes()[:4]==b'\x7fELF':continue
  names.add(str(p.relative_to(root)))
for n in ['REPORT.txt','analyze.py','compile_compare.py','MANIFEST.json']:
 names.add('typed-target-evidence/'+n)
for p in (root/'typed-target-evidence/results').iterdir():
 if p.is_file() and p.suffix in ('.json','.txt','.log'):names.add(str(p.relative_to(root)))
for v in ['control','candidate-typed-stores']:
 for p in (root/'typed-target-evidence/results'/v).iterdir():
  if p.is_file() and (p.suffix=='.su' or p.name.endswith(('.size.txt','.totals.txt','.sections.txt','.symbols.txt','.asm.txt'))):names.add(str(p.relative_to(root)))
assert all((root/n).is_file() and not (root/n).is_symlink() for n in names)
assert not any(Path(n).suffix in ('.zip','.bin','.blend','.png','.jpg','.jpeg','.webp','.o','.elf','.text') for n in names)
files=[]
for n in sorted(names):
 b=(root/n).read_bytes();files.append({'path':n,'bytes':len(b),'sha256':hashlib.sha256(b).hexdigest()})
m={'kind':'private shared-shading source, host verification and independently checked S3 summary','original_assets':False,'images':False,'character_geometry':False,'executables':False,'target_codegen_status':'first three variants and typed-store S3 comparison complete; target runtime/cycles unmeasured','full_target_evidence_library_ids':['libfile_9f16ea3093748191bde8d831225b5255','libfile_e6d2fd16c8648191a2bc3a55b9bfd090'],'files':files}
tmp=arc.with_suffix('.tmp.zip')
with zipfile.ZipFile(tmp,'w',zipfile.ZIP_DEFLATED,compresslevel=9) as z:
 for f in files:z.write(root/f['path'],f['path'])
 z.writestr('MANIFEST.json',json.dumps(m,indent=2)+'\n')
tmp.replace(arc)
b=arc.read_bytes();identity={'file_name':arc.name,'bytes':len(b),'entries':len(files)+1,'sha256':hashlib.sha256(b).hexdigest()}
(root/'delivery/HOST_ARCHIVE_IDENTITY.json').write_text(json.dumps(identity,indent=2)+'\n');print(json.dumps(identity))
