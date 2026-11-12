from pathlib import Path
import json,hashlib,zipfile
R=Path(__file__).resolve().parent;W=R.parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
old=W/'fox-v3-lid-normal-save/fox-v3-lighting-ab-code-report-private.zip'
assert sha(old)=='9a6af1fa766f49951c51af2795249f5469b828ab96bb245f5fb044ed277055b8'
core=W/'fox-v3-normal-pair-codec/normal-pair-codec-code-report.zip'
assert sha(core)=='0c5df0599ab03b371f6cf907e9fca7e6f052ae84991acfe6167f7bc8de60a58a'
files={'package.py':R/'package.py'}
C=W/'fox-v3-normal-pair-codec'
files['codec/ABI_OBJECT_ADDENDUM.md']=C/'ABI_OBJECT_ADDENDUM.md'
for p in (C/'abi-object-report').rglob('*'):
 if p.is_file() and p.suffix in {'.c','.txt','.su','.sh','.py','.json'}:files['codec/'+str(p.relative_to(C))]=p
E=W/'fox-v3-normal-pair-evaluation'
a=json.loads((E/'BUNDLE_ALLOWLIST.json').read_text())
for n,h in a['files'].items():
 assert sha(E/n)==h,n
 files['integration/'+n]=E/n
files['integration/CODE_REPORT_FREEZE.json']=E/'CODE_REPORT_FREEZE.json'
files['integration/BUNDLE_ALLOWLIST.json']=E/'BUNDLE_ALLOWLIST.json'
for p in files.values():assert p.is_file(),p
out=R/'fox-v3-lighting-ab-code-report-private.zip'
with zipfile.ZipFile(old) as z,zipfile.ZipFile(core) as c,zipfile.ZipFile(out,'w',zipfile.ZIP_DEFLATED,compresslevel=6) as w:
 for n in z.namelist():w.writestr(n,z.read(n))
 for n in c.namelist():w.writestr('normal-pair-product/codec/'+n,c.read(n))
 for n,p in files.items():w.write(p,'normal-pair-product/'+n)
 w.writestr('normal-pair-product/bundle-manifest.json',json.dumps({n:{'sha256':sha(p),'bytes':p.stat().st_size} for n,p in files.items()},indent=2))
with zipfile.ZipFile(old) as z,zipfile.ZipFile(out) as w:
 assert all(z.read(n)==w.read(n) for n in z.namelist());assert len(w.namelist())==len(set(w.namelist()))
 j=dict(priorEntries=len(z.namelist()),totalEntries=len(w.namelist()),sha256=sha(out),bytes=out.stat().st_size,priorEntriesByteExact=True,noModelsImagesRawBuffersAdded=True)
(R/'package-result.json').write_text(json.dumps(j,indent=2));print(json.dumps(j))
