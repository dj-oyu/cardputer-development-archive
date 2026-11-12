from pathlib import Path
import zipfile,hashlib,json
R=Path(__file__).resolve().parent;old=R.parent/'fox-v3-pixel-light/fox-v3-lighting-ab-code-report-private.zip';out=R/'fox-v3-lighting-ab-code-report-private.zip'
assert hashlib.sha256(old.read_bytes()).hexdigest()=='8dbbb7d28325143da547c4f9bc289a5c77d12270e8ea96acca835aab27f823da'
files=[]
for d in ['code','product','physical','visibility','scoring','tests-codec','tests-final-002','stack-audit','independent-review']:
 for p in (R/d).rglob('*'):
  if not p.is_file() or any(x in p.parts for x in ['.cache','__pycache__','.git']):continue
  if p.suffix in ['.c','.h','.py','.cjs','.js','.sh','.md','.json','.txt','.log','.su']:files.append(p)
for n in ['REPORT.md','REPORT-ADDENDUM.md','PLAN.md','REPRODUCE.md','final-source-hashes.json','write_report.py','package.py','test_all.sh','summary.json','metrics.json','summarize.py','measure_ab.py','parity.json','timing-001/results.json']:files.append(R/n)
for arm in ['off-004','on-004']:
 for n in ['candidate-manifest.json','input-hashes-start.json','accounting.json','functional.json']:files.append(R/arm/n)
for arm in ['score-off-004','score-on-004']:
 for n in ['evaluation.json','STARTED.json','COMPLETED.json']:files.append(R/arm/n)
# Only configuration/source metadata, never compile geometry or binary model.
for n in ['candidate-config.json','physical-source.json','source-metadata.json']:
 p=R/'inputs'/n
 if p.exists():files.append(p)
files=sorted(set(files));assert all(p.exists() for p in files)
prefix='pixel-visibility-v3/'
with zipfile.ZipFile(old) as z,zipfile.ZipFile(out,'w',zipfile.ZIP_DEFLATED,compresslevel=9) as w:
 for n in z.namelist():w.writestr(n,z.read(n))
 for p in files:w.write(p,prefix+str(p.relative_to(R)))
 w.writestr(prefix+'bundle-manifest.json',json.dumps({str(p.relative_to(R)):{'bytes':p.stat().st_size,'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in files},indent=2))
with zipfile.ZipFile(old) as z,zipfile.ZipFile(out) as w:
 assert all(z.read(n)==w.read(n) for n in z.namelist());assert len(w.namelist())==len(set(w.namelist()))
 assert not any(Path(n).suffix.lower() in ['.blend','.glb','.gltf','.aynm','.png','.exr','.npy','.npz','.u16le','.f32le','.f64','.o','.so'] for n in w.namelist())
 j={'priorEntries':len(z.namelist()),'addedEntries':len(files)+1,'totalEntries':len(w.namelist()),'bytes':out.stat().st_size,'sha256':hashlib.sha256(out.read_bytes()).hexdigest(),'priorEntriesByteExact':True,'noOriginalGeometryImagesOrRawBuffers':True}
(R/'package-result.json').write_text(json.dumps(j,indent=2));print(json.dumps(j))
