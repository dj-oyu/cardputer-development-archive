from pathlib import Path
import json,hashlib,zipfile
R=Path(__file__).resolve().parent; W=R.parent; sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
old=W/'fox-v3-renderer-next-design-save/fox-v3-lighting-ab-code-report-private.zip'
assert sha(old)=='0f597ef120cf20802a7b190099dc63c491f94dae85fa950979a048c93fade621'
E=R
files={n:W/n for n in (E/'BUNDLE_ALLOWLIST.txt').read_text().splitlines() if n.strip()}
files['BUNDLE_ALLOWLIST.txt']=R/'BUNDLE_ALLOWLIST.txt'
files['package.py']=R/'package.py'
assert all(p.is_file() for p in files.values())
assert all(p.suffix not in ['.png','.npy','.npz','.glb','.blend','.exr','.bin','.u16le','.f32le'] for p in files.values())
out=R/'fox-v3-lighting-ab-code-report-private.zip'
with zipfile.ZipFile(old) as z, zipfile.ZipFile(out,'w',zipfile.ZIP_DEFLATED,compresslevel=6) as w:
 for n in z.namelist():w.writestr(n,z.read(n))
 for n,p in files.items():w.write(p,'floor-direct-reflection/'+n)
 w.writestr('floor-direct-reflection/bundle-manifest.json',json.dumps({n:{'sha256':sha(p),'bytes':p.stat().st_size} for n,p in files.items()},indent=2))
with zipfile.ZipFile(old) as z,zipfile.ZipFile(out) as w:
 assert all(z.read(n)==w.read(n) for n in z.namelist());assert len(w.namelist())==len(set(w.namelist()))
 j=dict(priorEntries=len(z.namelist()),totalEntries=len(w.namelist()),sha256=sha(out),bytes=out.stat().st_size,priorEntriesByteExact=True,noModelsImagesRawBuffersAdded=True)
(R/'package-result.json').write_text(json.dumps(j,indent=2));print(json.dumps(j))
