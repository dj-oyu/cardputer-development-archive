"""Pinned geometry audit only. Does not change lighting or image metrics."""
import json,hashlib,pathlib

def sha(p):return hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest()
def derived(c):
 p=c['parts'];nv=sum(len(x['positions']) for x in p);nt=sum(len(x['triangles']) for x in p)
 assert nt==c['sourceTriangles']
 snap=416
 for x in p:
  used={v for t in x['triangles'] for v in t};n=len(x['triangles']);assert used==set(range(len(x['positions'])))
  snap+=(12+56*len(used)+3*n+(n+7)//8+3)&~3
 return dict(vertices=nv,triangles=nt,records=len(p),snapshotBytes=snap,coldBytes=c['coldBytes'])
def verify(root,digest):
 root=pathlib.Path(root);path=root/'inputs/geometry-certificate.json';assert sha(path)==digest,'external geometry certificate SHA mismatch'
 c=json.loads(path.read_text());assert c['version']=='geometry-compile-pin-v1'
 for name,h in c['files'].items():
  p=(root/name).resolve();assert p.is_relative_to(root.resolve());assert sha(p)==h, 'certificate file mismatch: '+name
 assert c['glbSHA256']==sha(root/'inputs/geometry-source-sided.glb')
 for case in ['baseline','direction','intensity','ambient','albedo']:
  v=json.loads((root/f'compiled/model-{case}/compile.json').read_text());assert derived(v)==c['counts']
 assert c['counts']['snapshotBytes']<=65536 and c['counts']['triangles']+2<=2048
 return c

def runtime(actual,c):
 n=c['counts'];on=bool(actual['groundMode']);nt=n['triangles']+2*on;nv=n['vertices']+4*on
 expected={'visibilityTriangles':nt,'visibilityVertices':nv,'visibilitySceneBytes':16+280*nt,'visibilityTemporaryBytes':24*nv+12*nt,'transportSceneBytes':560+64*nt,'transportTemporaryBytes':64*nt,'snapshotBytes':n['snapshotBytes'],'records':n['records'],'logicalMeshes':n['records'],'coldBytes':n['coldBytes'],'arenaBytes64bit':c['arenaBytes64bit'],'groundFirstTriangle':n['triangles'] if on else 0}
 for k,v in expected.items():assert type(actual.get(k)) is int and actual[k]==v,'geometry runtime '+k
 return expected
