from pathlib import Path
import json,hashlib,subprocess,os,shutil
r=Path(__file__).resolve().parent;s=r/'source';tree=json.loads((r/'public-base-tree.json').read_text());m=json.loads((r/'SOURCE_MANIFEST.json').read_text());blobs=[x for x in tree['tree'] if x['type']=='blob'];git=lambda *a,**kw:subprocess.check_output(['git','-C',str(s),*a],text=True,**kw).strip()
for x in blobs:
 p=s/x['path'];data=p.read_bytes();assert hashlib.sha1(b'blob '+str(len(data)).encode()+b'\0'+data).hexdigest()==x['sha'],x['path'];os.chmod(p,0o755 if x['mode']=='100755' else 0o644)
assert tree['sha']==m['base_tree_sha1']=='a4322fb9455d449fbe1eab8d8a6ef983761c14b8'
for f in m['files']:
 if f['base_blob_sha1'] is not None:assert next(x['sha'] for x in blobs if x['path']==f['path'])==f['base_blob_sha1'],f['path']
subprocess.run(['git','init','-q',str(s)],check=True)
subprocess.run(['git','-C',str(s),'add','--pathspec-from-file=-','--pathspec-file-nul'],input=b''.join(x['path'].encode()+b'\0' for x in blobs),check=True)
for x in tree['tree']:
 if x['type']=='commit':subprocess.run(['git','-C',str(s),'update-index','--add','--cacheinfo',x['mode'],x['sha'],x['path']],check=True)
base=git('write-tree');assert base==m['base_tree_sha1'],base
subprocess.run(['git','-C',str(s),'apply','--check',str(r/'source.patch')],check=True);subprocess.run(['git','-C',str(s),'apply',str(r/'source.patch')],check=True)
for f in m['files']:
 b=(s/f['path']).read_bytes();assert len(b)==f['bytes'] and hashlib.sha256(b).hexdigest()==f['candidate_sha256'] and hashlib.sha1(b'blob '+str(len(b)).encode()+b'\0'+b).hexdigest()==f['candidate_blob_sha1'],f['path']
subprocess.run(['git','-C',str(s),'add','--',*[f['path'] for f in m['files']]],check=True);candidate=git('write-tree');assert candidate==m['candidate_tree_sha1']=='e488ab1ed190111a7bacd380c89841c47e756cb8',candidate
# Retain only existing pinned, verified generic vendor caches for ordinary full builds.
template=Path('/workspace/mesh-edge4-benchmark-c14c7889-s3-20261106/source')
for x in tree['tree']:
 if x['type']=='commit':
  p=template/x['path'];assert p.is_dir(),p;shutil.copytree(p,s/x['path'],symlinks=True)
rec={'source_route':'official Library text-read patch plus authorized public equal-tree reconstruction','unavailable_local_base_commit':m['base_commit_sha1'],'public_equal_tree_commit':'724d97ade710c90ffbf219bf4589210f039ec1e3','public_commit_verified_tree':base,'base_blob_count':len(blobs),'candidate_tree':candidate,'manifest_files_verified':len(m['files']),'git_provenance':'Fresh private Git index; no claim to have fetched either unavailable commit object; exact tree content independently reproduced','gitlinks':[{k:x[k] for k in ['path','sha']} for x in tree['tree'] if x['type']=='commit']};(r/'SOURCE_VERIFICATION.json').write_text(json.dumps(rec,indent=2)+'\n');print(json.dumps(rec,indent=2))
