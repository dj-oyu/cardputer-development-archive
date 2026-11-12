from pathlib import Path
import json,hashlib,zipfile
R=Path(__file__).resolve().parent; W=R.parent; sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
old=W/'fox-v3-boundary-aa-save/fox-v3-lighting-ab-code-report-private.zip'
assert sha(old)=='bd1cdc9a4562f74387eac6374159b9cecda9cf4ab68464990df60d528aad225a'
E=W/'fox-v3-root-pose-audit'
files={n:W/n for n in (E/'BUNDLE_ALLOWLIST.txt').read_text().splitlines() if n.strip()}
for n in ['BUNDLE_ALLOWLIST.txt','CODE_REPORT_FREEZE.json']:files['fox-v3-root-pose-audit/'+n]=E/n
files['package.py']=R/'package.py'
assert all(p.is_file() for p in files.values())
assert all(p.suffix not in ['.png','.npy','.npz','.glb','.blend','.exr','.bin','.u16le','.f32le'] for p in files.values())
out=R/'fox-v3-lighting-ab-code-report-private.zip'
with zipfile.ZipFile(old) as z, zipfile.ZipFile(out,'w',zipfile.ZIP_DEFLATED,compresslevel=6) as w:
 for n in z.namelist():w.writestr(n,z.read(n))
 for n,p in files.items():w.write(p,'root-pose/'+n)
 w.writestr('root-pose/bundle-manifest.json',json.dumps({n:{'sha256':sha(p),'bytes':p.stat().st_size} for n,p in files.items()},indent=2))
with zipfile.ZipFile(old) as z,zipfile.ZipFile(out) as w:
 assert all(z.read(n)==w.read(n) for n in z.namelist());assert len(w.namelist())==len(set(w.namelist()))
 j=dict(priorEntries=len(z.namelist()),totalEntries=len(w.namelist()),sha256=sha(out),bytes=out.stat().st_size,priorEntriesByteExact=True,noModelsImagesRawBuffersAdded=True)
(R/'package-result.json').write_text(json.dumps(j,indent=2));print(json.dumps(j))
