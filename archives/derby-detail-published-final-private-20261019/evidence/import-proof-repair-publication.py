from pathlib import Path
import subprocess,json,datetime,hashlib
p=Path('/workspace/derby-evidence/PROOF-REPAIR-PUBLISHED.json');d=json.loads(p.read_text())
for v,x in d.items():
 root=x['root'];c=x['remote_git_commit'];want=x['remote_commit']
 def git(*args,input=None):return subprocess.check_output(['git','-C',root,*args],input=input)
 assert c['sha']==want and c['tree']['sha']==x['tree'] and [q['sha'] for q in c['parents']]==[x['previous_remote_commit']]
 assert git('rev-parse','HEAD').decode().strip()==x['local_head'] and not git('status','--porcelain').strip()
 def ident(k,z):
  a=c[k];t=int(datetime.datetime.fromisoformat(a['date'].replace('Z','+00:00')).timestamp());return f"{k} {a['name']} <{a['email']}> {t} {z}\n"
 found=None
 zones=['+0000']+[f'{"+" if m>=0 else "-"}{abs(m)//60:02}{abs(m)%60:02}' for m in range(-720,841,15) if m]
 for suffix in ('','\n','\n\n'):
  for az in zones:
   for cz in zones:
    raw=(f"tree {x['tree']}\nparent {x['previous_remote_commit']}\n"+ident('author',az)+ident('committer',cz)+'\n'+c['message']+suffix).encode()
    if hashlib.sha1(b'commit '+str(len(raw)).encode()+b'\0'+raw).hexdigest()==want:found=raw;break
   if found:break
  if found:break
 assert found,'Could not independently reconstruct exact unsigned Git commit'
 assert git('hash-object','-w','-t','commit','--stdin',input=found).decode().strip()==want
 rawpath=p.parent/('published-proof-repair-'+v+'.commit');rawpath.write_bytes(found)
 backup='checkpoint/derby-detail-'+v+'-local-proof-repair-20261019';git('branch',backup,x['local_head'])
 git('update-ref','refs/heads/'+x['branch'],want,x['local_head'])
 assert git('rev-parse','HEAD^{tree}').decode().strip()==x['tree'] and not git('status','--porcelain').strip()
 x['published_local_head']=want;x['published_local_branch']=x['branch'];x['local_candidate_checkpoint']=backup;x['remote_commit_raw_sha256']=hashlib.sha256(found).hexdigest()
 print(json.dumps({'variant':v,'exact_local_remote_head':want,'tree':x['tree'],'clean':True,'candidate_preserved':backup}))
p.write_text(json.dumps(d,indent=2)+'\n')
