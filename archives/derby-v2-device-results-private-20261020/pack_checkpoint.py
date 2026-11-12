#!/usr/bin/env python3
"""Private source checkpoint for the correction; no hardware or network calls."""
from pathlib import Path
import hashlib,json,subprocess,zipfile,shutil
b=Path(__file__).resolve().parent
parents={'baseline':'37af4225ad329aac4c5e79c880d7d69760b770be','native':'92e70b7fbb2c15d99734a518096dffdf046d2ae3','batch':'ea64b0ec9c176f852c853cb10142581ee527d7fc'}
bases={'baseline':'0c52600fc34deafbadc53bc48e4fc98931e404e4','native':'44f9c56121b5aab4fb2eca0fcf9fbe54d833a276','batch':'3a641d4d996938339b44fe735aba876ad031b3a2'}
ledger={}
for v,parent in parents.items():
 root=Path('/workspace/derby-controller-'+v);d=b/v;d.mkdir(exist_ok=True)
 def git(*a):return subprocess.check_output(['git','-C',str(root),*a])
 tree=git('write-tree').decode().strip()
 files=git('diff','--cached','--name-only',parent).decode().splitlines()
 # After publication the index equals HEAD, so diff the tree against the old parent.
 if not files:files=git('diff','--name-only',parent,tree).decode().splitlines()
 for name in files:
  p=d/'source'/name;p.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(root/name,p)
 (d/'correction.patch').write_bytes(git('diff','--binary',parent,tree))
 (d/'complete.patch').write_bytes(git('diff','--binary',bases[v],tree))
 ledger[v]={'root':str(root),'branch':git('branch','--show-current').decode().strip(),'head':git('rev-parse','HEAD').decode().strip(),'tree':tree,'parent':parent,'comparison_base':bases[v],'files':{name:hashlib.sha256((root/name).read_bytes()).hexdigest() for name in files},'correction_patch_sha256':hashlib.sha256((d/'correction.patch').read_bytes()).hexdigest(),'complete_patch_sha256':hashlib.sha256((d/'complete.patch').read_bytes()).hexdigest(),'head_is_correction':git('rev-parse','HEAD').decode().strip()!=parent}
(b/'SOURCE-CHECKPOINT.json').write_text(json.dumps(ledger,indent=2)+'\n')
def keep(p):
 rel=p.relative_to(b)
 return p.is_file() and p.name!='SHA256SUMS' and '__pycache__' not in rel.parts and not any(x.startswith('build') for x in rel.parts) and p.name not in ('test-derby',)
files=sorted(p for p in b.rglob('*') if keep(p))
(b/'SHA256SUMS').write_text(''.join(hashlib.sha256(p.read_bytes()).hexdigest()+'  '+str(p.relative_to(b))+'\n' for p in files))
archive=b.parent/'derby-v2-device-results-private-20261020.zip'
with zipfile.ZipFile(archive,'w',zipfile.ZIP_DEFLATED,compresslevel=6) as z:
 for p in files+[b/'SHA256SUMS']:
  z.write(p,str(p.relative_to(b)),compress_type=zipfile.ZIP_STORED if p.suffix=='.zip' else zipfile.ZIP_DEFLATED)
with zipfile.ZipFile(archive) as z:
 assert z.testzip() is None
 for line in z.read('SHA256SUMS').decode().splitlines():
  want,name=line.split('  ',1);assert hashlib.sha256(z.read(name)).hexdigest()==want,name
info={'path':str(archive),'bytes':archive.stat().st_size,'sha256':hashlib.sha256(archive.read_bytes()).hexdigest(),'manifest_files':len(files),'prior_v4_sha256':'6094ba0e158c7b7eb69c9a6c7779e0b4993b0e4c7d5c93a52d4bdad6dc223a68','phase':'controller split correction; see STATUS.json and published/CI receipts for exact current completion'}
(b.parent/'CONTROLLER-ARCHIVE.json').write_text(json.dumps(info,indent=2)+'\n');print(json.dumps(info))
