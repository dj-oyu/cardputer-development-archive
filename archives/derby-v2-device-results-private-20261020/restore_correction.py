#!/usr/bin/env python3
"""Restore a correction commit into a new empty directory, entirely offline."""
import argparse,hashlib,json,subprocess,sys,tempfile,zipfile
from pathlib import Path
p=argparse.ArgumentParser();p.add_argument('--variant',required=True,choices=('baseline','native','batch'));p.add_argument('--destination',required=True,type=Path);a=p.parse_args()
b=Path(__file__).resolve().parent;x=json.loads((b/'PUBLICATION.json').read_text())[a.variant];dest=a.destination.resolve()
if dest.exists() and any(dest.iterdir()):raise SystemExit('Destination must be empty; existing changes are protected')
src=b/'prior-device-v4.zip'
assert hashlib.sha256(src.read_bytes()).hexdigest()=='6094ba0e158c7b7eb69c9a6c7779e0b4993b0e4c7d5c93a52d4bdad6dc223a68'
with tempfile.TemporaryDirectory(prefix='derby-controller-restore-') as td:
 with zipfile.ZipFile(src) as z:
  assert z.testzip() is None
  for n in z.namelist():assert not Path(n).is_absolute() and '..' not in Path(n).parts
  z.extractall(td)
 subprocess.run([sys.executable,str(Path(td)/'restore_code.py'),'--variant',a.variant,'--destination',str(dest)],check=True)
def git(*q):return subprocess.check_output(['git','-C',str(dest),*q])
assert git('rev-parse','HEAD').decode().strip()==x['parent']
bundle=b/a.variant/'correction.bundle'
subprocess.run(['git','-C',str(dest),'bundle','verify',str(bundle)],check=True)
git('fetch',str(bundle),'refs/heads/'+x['branch'])
git('checkout','-b',x['branch'],x['remote_commit'])
assert git('rev-parse','HEAD').decode().strip()==x['remote_commit']
assert git('rev-parse','HEAD^{tree}').decode().strip()==x['tree']
assert not git('status','--porcelain').strip()
checkpoint=json.loads((b/'SOURCE-CHECKPOINT.json').read_text())[a.variant]
for name,want in checkpoint['files'].items():assert hashlib.sha256((dest/name).read_bytes()).hexdigest()==want,name
for name,old in [('correction',x['parent']),('complete',checkpoint['comparison_base'])]:
 data=git('diff','--binary',old,'HEAD')
 assert hashlib.sha256(data).hexdigest()==checkpoint[name+'_patch_sha256']
print(json.dumps({'restored':True,'variant':a.variant,'exact_commit':x['remote_commit'],'exact_tree':x['tree'],'changed_files':len(checkpoint['files']),'hardware_tested':False,'scope':'offline code restoration only; does not rerun CI or prove target OOM fix'}))
