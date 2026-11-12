from pathlib import Path
import hashlib,json,zipfile
R=Path(__file__).resolve().parent;W=R.parent;old=W/'fox-v3-pass-decomposition-save/fox-v3-lighting-ab-code-report-private.zip';out=R/'fox-v3-lighting-ab-code-report-private.zip'
assert hashlib.sha256(old.read_bytes()).hexdigest()=='ef08899b19aa18ffdc8a1df13a215e091d3029c92b7413e484e968fd30b14777'
selected=[]
for d in ['code','product','physical','scoring','profile','tests']:
 for p in (R/d).rglob('*'):
  if not p.is_file() or '__pycache__' in p.parts:continue
  if d=='profile' and 'official-colormanagement' in p.parts: selected.append(p);continue
  if p.suffix in ['.c','.h','.inc','.py','.json','.md','.sh','.txt','.log'] and p.name not in ['groups.json','groups.replay.json']:selected.append(p)
for f in ['CONTRACT.md','REPORT.md','summary.json','metrics.json','parity.json','summarize.py','write_report.py','measure_ab.py','package.py','independent-review.json']:
 p=R/f
 if p.exists():selected.append(p)
for a in ['off-001','on-001']:
 for f in ['candidate-manifest.json','accounting.json','functional.json','input-hashes-start.json','build.log','inputs/candidate-config.json']:selected.append(R/a/f)
for a in ['score-off-001','score-on-001']:
 for f in ['evaluation.json','COMPLETED.json']:selected.append(R/a/f)
for a,files in [('postpixel-003',['evaluation.json','cost.json','input-hashes.json','scope.json','build-command.txt']),('timing-001',['results.json'])]:
 for f in files:selected.append(R/a/f)
for f in ['candidate-config.json','physical-source.json']:selected.append(R/'inputs'/f)
selected=sorted(set(selected));prefix='agx-profile-v3/'
with zipfile.ZipFile(old) as z,zipfile.ZipFile(out,'w',compression=zipfile.ZIP_DEFLATED,compresslevel=9) as w:
 for n in z.namelist():w.writestr(n,z.read(n))
 for p in selected:w.write(p,prefix+str(p.relative_to(R)))
 manifest={prefix+str(p.relative_to(R)):{'bytes':p.stat().st_size,'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in selected};w.writestr(prefix+'bundle-manifest.json',json.dumps(manifest,indent=2))
with zipfile.ZipFile(old) as z,zipfile.ZipFile(out) as w:
 assert all(z.read(n)==w.read(n) for n in z.namelist());assert not any(Path(n).suffix.lower() in ['.blend','.glb','.gltf','.aynm','.png','.exr','.npy','.npz','.u16le','.f32le','.f64'] for n in w.namelist());assert len(w.namelist())==len(set(w.namelist()))
 result={'priorEntries':len(z.namelist()),'addedEntries':len(selected)+1,'totalEntries':len(w.namelist()),'bytes':out.stat().st_size,'sha256':hashlib.sha256(out.read_bytes()).hexdigest(),'allPriorEntriesByteExact':True,'excludedOriginalModelImagesGeometryRawBuffers':True}
(R/'package-result.json').write_text(json.dumps(result,indent=2));print(json.dumps(result))
