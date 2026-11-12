from pathlib import Path
import zipfile,hashlib,json
R=Path(__file__).resolve().parent;old=R.parent/'fox-v3-pixel-visibility/fox-v3-lighting-ab-code-report-private.zip';out=R/'fox-v3-lighting-ab-code-report-private.zip'
assert hashlib.sha256(old.read_bytes()).hexdigest()=='45f5db87d148e2e6b6319b2a3ac1d503986958825063c87e525a01df236ac439'
files=[R/p for p in ['PLAN.md','REPORT.md','write_report.py','observe.py','analyze.py','package.py','code/native_render.c','run-001/input-hashes.json','run-001/build.json','run-001/COMPLETED.json','analysis-003/input-hashes.json','analysis-003/metrics.json','analysis-003/components.json','analysis-003/regions.json','analysis-003/COMPLETED.json']]
for d in ['product','physical','visibility','independent-review']:
 files += [p for p in (R/d).rglob('*') if p.is_file() and '.cache' not in p.parts and p.suffix in ['.c','.h','.json','.txt','.log']]
files=sorted(set(files));assert all(p.exists() for p in files);prefix='hdr-observer-v3/'
with zipfile.ZipFile(old) as z,zipfile.ZipFile(out,'w',zipfile.ZIP_DEFLATED,compresslevel=9) as w:
 for n in z.namelist():w.writestr(n,z.read(n))
 for p in files:w.write(p,prefix+str(p.relative_to(R)))
 w.writestr(prefix+'bundle-manifest.json',json.dumps({str(p.relative_to(R)):{'bytes':p.stat().st_size,'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in files},indent=2))
with zipfile.ZipFile(old) as z,zipfile.ZipFile(out) as w:
 assert all(z.read(n)==w.read(n) for n in z.namelist());assert len(w.namelist())==len(set(w.namelist()));assert not any(Path(n).suffix.lower() in ['.blend','.glb','.gltf','.aynm','.png','.exr','.npy','.npz','.u16le','.f32le','.f64le','.o','.so'] for n in w.namelist());j={'priorEntries':len(z.namelist()),'addedEntries':len(files)+1,'totalEntries':len(w.namelist()),'bytes':out.stat().st_size,'sha256':hashlib.sha256(out.read_bytes()).hexdigest(),'priorEntriesByteExact':True,'noOriginalGeometryImagesOrRawBuffers':True}
(R/'package-result.json').write_text(json.dumps(j,indent=2));print(json.dumps(j))
