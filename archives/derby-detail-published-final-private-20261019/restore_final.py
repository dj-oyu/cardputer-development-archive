#!/usr/bin/env python3
"""Restore exact published source and verify full patch offline; no device use."""
from pathlib import Path
import argparse,json,hashlib,subprocess,sys,tempfile,zipfile
p=argparse.ArgumentParser();p.add_argument('--variant',choices=('baseline','native','batch'),required=True);p.add_argument('--destination',type=Path,required=True);a=p.parse_args();b=Path(__file__).resolve().parent;m=json.loads((b/'CHECKPOINT.json').read_text());i=m['variants'][a.variant];dest=a.destination.resolve()
if dest.exists() and any(dest.iterdir()):raise SystemExit('Destination must be empty; existing changes are protected')
archive=b/'prior-clean-exit-final.zip';assert hashlib.sha256(archive.read_bytes()).hexdigest()==m['prior_archive_sha256']
with tempfile.TemporaryDirectory(prefix='derby-final-base-') as td:
 with zipfile.ZipFile(archive) as z:
  for n in z.namelist():assert not Path(n).is_absolute() and '..' not in Path(n).parts
  z.extractall(td)
 helper=next(Path(td).rglob('restore_clean_exit.py'));subprocess.run([sys.executable,str(helper),'--variant',a.variant,'--destination',str(dest)],check=True)
def git(*args,input=None):return subprocess.check_output(['git','-C',str(dest),*args],input=input)
assert git('rev-parse','HEAD').decode().strip()==i['prior_candidate_commit']
bundle=b/'increments'/(a.variant+'.bundle');assert hashlib.sha256(bundle.read_bytes()).hexdigest()==i['bundle_sha256']
git('bundle','unbundle',str(bundle));git('branch','checkpoint/local-clean-exit-candidate',i['prior_candidate_commit']);git('checkout','-B',i['branch'],i['published_commit'])
assert git('rev-parse','HEAD^{tree}').decode().strip()==i['tree'] and not git('status','--porcelain').strip()
patch=b/'patches'/(a.variant+'.patch');assert hashlib.sha256(patch.read_bytes()).hexdigest()==i['patch_sha256'];assert git('diff','--binary','--full-index',i['base_commit'],'HEAD')==patch.read_bytes()
for name,want in i['modified_files'].items():assert hashlib.sha256((dest/name).read_bytes()).hexdigest()==want,name
print(json.dumps({'restored':True,'variant':a.variant,'published_commit':i['published_commit'],'tree':i['tree'],'modified_files_verified':len(i['modified_files']),'hardware_accepted':False,'note':'Restoring code does not rerun CI or qualify hardware; inspect separate CI receipt.'}))
