from pathlib import Path
import zipfile,hashlib,json
R=Path(__file__).resolve().parent;W=R.parent;old=W/'fox-v3-agx-profile/fox-v3-lighting-ab-code-report-private.zip';out=R/'fox-v3-lighting-ab-code-report-private.zip';assert hashlib.sha256(old.read_bytes()).hexdigest()=='16f62faef3b483de91aee8820858d39af74e05368bfd846464dad04f059e8f53'
files=[R/n for n in ['PLAN.md','REPORT.md','write_report.py','analyze.py','package.py','independent-review.json','native/shader.c','native/run.py','native/test_direct.c','native/test.log','native/build-command.txt','native/run-001/COMPLETED.json','native/run-001/input-hashes.json','blender/run.py','blender/PLAN.md','blender/freeze.json','blender/COMPLETED.json','analysis-002/metrics.json','analysis-002/rich-context.json','analysis-002/input-hashes.json','analysis-002/regions.json']];assert all(p.exists() for p in files);prefix='direct-lambert-v3/'
with zipfile.ZipFile(old) as z,zipfile.ZipFile(out,'w',zipfile.ZIP_DEFLATED,compresslevel=9) as w:
 for n in z.namelist():w.writestr(n,z.read(n))
 for p in files:w.write(p,prefix+str(p.relative_to(R)))
 w.writestr(prefix+'bundle-manifest.json',json.dumps({str(p.relative_to(R)):{'bytes':p.stat().st_size,'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in files},indent=2))
with zipfile.ZipFile(old) as z,zipfile.ZipFile(out) as w:
 assert all(z.read(n)==w.read(n) for n in z.namelist());assert not any(Path(n).suffix.lower() in ['.blend','.glb','.gltf','.aynm','.png','.exr','.npy','.npz','.u16le','.f32le','.f64'] for n in w.namelist());assert len(w.namelist())==len(set(w.namelist()));j={'priorEntries':len(z.namelist()),'addedEntries':len(files)+1,'totalEntries':len(w.namelist()),'bytes':out.stat().st_size,'sha256':hashlib.sha256(out.read_bytes()).hexdigest(),'priorEntriesByteExact':True,'noOriginalGeometryImagesOrRawBuffers':True}
(R/'package-result.json').write_text(json.dumps(j,indent=2));print(json.dumps(j))
