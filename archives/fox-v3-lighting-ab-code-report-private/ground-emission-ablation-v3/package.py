from pathlib import Path
import zipfile,hashlib,json
R=Path(__file__).resolve().parent;old=R.parent/'fox-v3-bounce-combination/fox-v3-lighting-ab-code-report-private.zip';out=R/'fox-v3-lighting-ab-code-report-private.zip';sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(old)=='dbff6125ebb3f524730ad6a4a3f3fc11d72a92b79e0d88d760c3ade336de4ba6'
files=[p for p in R.iterdir() if p.is_file() and p.suffix in ['.py','.md','.json'] and p.name not in ['package-result.json','upload-result.json']]
for d in ['code','independent-review']:
 files +=[p for p in (R/d).rglob('*') if p.is_file() and '__pycache__' not in p.parts and p.suffix in ['.py','.json','.txt','.md']]
for n in ['input-hashes-before.json','input-hashes-after.json','COMPLETED.json','ON_CONTROL_PASS.json','on-png-control.json','audit-summary.json']:files.append(R/'run-001'/n)
files +=[p for p in (R/'analysis-001').iterdir() if p.is_file() and p.suffix in ['.json','.md']]
files=sorted(set(files));assert all(p.exists() for p in files);assert not any(p.name.endswith('-audit.json') or p.name=='source-audit.json' for p in files);prefix='ground-emission-ablation-v3/'
with zipfile.ZipFile(old) as z,zipfile.ZipFile(out,'w',zipfile.ZIP_DEFLATED,compresslevel=9) as w:
 for n in z.namelist():w.writestr(n,z.read(n))
 for p in files:w.write(p,prefix+str(p.relative_to(R)))
 w.writestr(prefix+'bundle-manifest.json',json.dumps({str(p.relative_to(R)):{'bytes':p.stat().st_size,'sha256':sha(p)} for p in files},indent=2))
with zipfile.ZipFile(old) as z,zipfile.ZipFile(out) as w:
 assert all(z.read(n)==w.read(n) for n in z.namelist());assert len(w.namelist())==len(set(w.namelist()));assert not any(Path(n).suffix.lower() in ['.blend','.glb','.gltf','.aynm','.png','.exr','.npy','.npz','.u16le','.f32le','.f64le','.o','.so'] for n in w.namelist());j={'priorEntries':len(z.namelist()),'addedEntries':len(files)+1,'totalEntries':len(w.namelist()),'bytes':out.stat().st_size,'sha256':sha(out),'priorEntriesByteExact':True,'noOriginalGeometryImagesOrRawBuffers':True,'fullSceneAuditsExcluded':True}
(R/'package-result.json').write_text(json.dumps(j,indent=2));print(json.dumps(j))
