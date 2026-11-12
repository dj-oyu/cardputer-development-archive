from pathlib import Path
import json,hashlib,subprocess
r=Path(__file__).resolve().parent;s=r/'source';m=json.loads((r/'SOURCE_MANIFEST.json').read_text());base=json.loads((r/'public-base-tree.json').read_text());changed={f['path']:f for f in m['files']}
for x in base['tree']:
 if x['type']!='blob' or x['path'] in changed:continue
 b=(s/x['path']).read_bytes();assert hashlib.sha1(b'blob '+str(len(b)).encode()+b'\0'+b).hexdigest()==x['sha'],x['path']
for name,f in changed.items():
 b=(s/name).read_bytes();assert len(b)==f['bytes'] and hashlib.sha256(b).hexdigest()==f['candidate_sha256'],name
assert not subprocess.check_output(['git','-C',str(s),'diff','--name-only'])
tree=subprocess.check_output(['git','-C',str(s),'write-tree'],text=True).strip();assert tree==m['candidate_tree_sha1']
(r/'SOURCE_AFTER_BUILD.json').write_text(json.dumps({'all_base_nonoverlay_blobs_unchanged':True,'all_12_candidate_files_unchanged':True,'tree':tree},indent=2))
print(tree)
