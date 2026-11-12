from pathlib import Path
import json,hashlib,subprocess,datetime
p=Path('/workspace/derby-evidence/controller-split-20261020/PUBLICATION.json');j=json.loads(p.read_text())
for v,x in j.items():
 c=x['remote_git_commit'];root=x['root']
 def git(*a,input=None):return subprocess.check_output(['git','-C',root,*a],input=input)
 assert git('rev-parse','HEAD').decode().strip()==x['parent']
 assert git('write-tree').decode().strip()==x['tree']
 assert not git('diff','--name-only').strip()
 def ident(k,z):
  a=c[k];t=int(datetime.datetime.fromisoformat(a['date'].replace('Z','+00:00')).timestamp())
  return f"{k} {a['name']} <{a['email']}> {t} {z}\n"
 found=None
 zones=['+0000']+[f'{"+" if m>=0 else "-"}{abs(m)//60:02}{abs(m)%60:02}' for m in range(-720,841,15) if m]
 for suffix in ('','\n','\n\n'):
  for az in zones:
   for cz in zones:
    raw=(f"tree {x['tree']}\nparent {x['parent']}\n"+ident('author',az)+ident('committer',cz)+'\n'+c['message']+suffix).encode()
    if hashlib.sha1(b'commit '+str(len(raw)).encode()+b'\0'+raw).hexdigest()==c['sha']:found=raw;break
   if found:break
  if found:break
 assert found,'unsigned public commit did not reconstruct exactly'
 assert git('hash-object','-w','-t','commit','--stdin',input=found).decode().strip()==c['sha']
 (p.parent/v/'published.commit').write_bytes(found)
 git('update-ref','refs/heads/'+x['branch'],c['sha'],x['parent'])
 assert git('rev-parse','HEAD^{tree}').decode().strip()==x['tree'] and not git('status','--porcelain').strip()
 git('bundle','create',str(p.parent/v/'correction.bundle'),'refs/heads/'+x['branch'],'^'+x['parent'])
 x['local_published_head']=c['sha'];x['commit_raw_sha256']=hashlib.sha256(found).hexdigest()
 print(json.dumps({'variant':v,'head':c['sha'],'tree':x['tree'],'clean':True}))
p.write_text(json.dumps(j,indent=2)+'\n')
