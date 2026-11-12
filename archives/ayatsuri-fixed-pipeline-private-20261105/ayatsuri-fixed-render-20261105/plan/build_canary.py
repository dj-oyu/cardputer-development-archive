from pathlib import Path
import json,hashlib,subprocess
R=Path('/workspace/scratch/6d8dcdbcdc54');D=Path(__file__).resolve().parent;OLD=R/'fox-v3-indexed-bvh-bounds/build-adapter';NEW=D/'build-canary';NEW.mkdir();G=D/'generated-v2'
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()
def write(p,j):
 with p.open('x') as f:json.dump(j,f,indent=2);f.write('\n')
b=json.loads((OLD/'BUILD.json').read_text());assert sha(OLD/'native-render')==b['binarySHA256'];assert all(sha(R/k)==v for k,v in b['files'].items())
commands=[];deps=set();objects=[]
for cmd0 in b['commands']:
 cmd=cmd0.copy()
 if '-c' in cmd:
  cmd[1:1]=['-I',str(G)]
  for flag in ['-MF','-o']:
   i=cmd.index(flag)+1;cmd[i]=str(NEW/Path(cmd[i]).name)
  objects.append(Path(cmd[cmd.index('-o')+1]));commands.append(cmd)
  p=subprocess.run(cmd,capture_output=True,text=True);(NEW/(objects[-1].stem+'.build.log')).write_text(p.stdout+p.stderr);assert p.returncode==0,cmd
  dp=Path(cmd[cmd.index('-MF')+1]);deps.update(Path(x) for x in dp.read_text().replace('\\\n',' ').split(':',1)[1].split())
 else:
  cmd=[str(NEW/Path(x).name) if x.startswith(str(OLD)+'/') else x for x in cmd];commands.append(cmd);p=subprocess.run(cmd,capture_output=True,text=True);(NEW/'link.log').write_text(p.stdout+p.stderr);assert p.returncode==0
for name in ['preflight.h','floor_input.h','background_input.h','scene_core_input.h']:
 matches=[p for p in deps if p.name==name];assert matches==[G/name],(name,matches)
# Every compilation dependency is old-frozen source or one of four explicit generated headers.
allowed={G/n for n in ['preflight.h','floor_input.h','background_input.h','scene_core_input.h']};assert all(p in allowed or str(p.relative_to(R)) in b['files'] for p in deps)
stack={};growth=[]
for p in NEW.glob('*.su'):
 old=OLD/p.name;assert old.exists()
 def parse(q):
  result={}
  for line in q.read_text().splitlines():
   location,size,kind=line.split('\t');name=location.rsplit(':',1)[-1];result[name]={'bytes':int(size),'kind':kind}
  return result
 a,c=parse(old),parse(p);stack[p.name]={'old':a,'new':c,'exact':a==c};growth.extend((p.name,k,a.get(k),v) for k,v in c.items() if k not in a or v['bytes']>a[k]['bytes'] or v['kind']!=a[k]['kind'])
write(NEW/'STACK_DELTA.json',{'status':'EXACT_OR_REVIEW_REQUIRED','functionsGrowingOrNew':growth,'files':stack})
write(NEW/'BUILD.json',{'status':'BUILT_NOT_RENDERED','fullFrames':0,'originalBuildSHA256':sha(OLD/'BUILD.json'),'originalBinarySHA256':sha(OLD/'native-render'),'binarySHA256':sha(NEW/'native-render'),'commands':commands,'files':{str(p.relative_to(R)):sha(p) for p in sorted(deps)},'stackFiles':{p.name:sha(p) for p in NEW.glob('*.su')},'stackDeltaSHA256':sha(NEW/'STACK_DELTA.json'),'generatedHeadersOnlyDataChange':True,'shaderAndCoreSourcesUnchanged':True})
print(json.dumps({'binarySHA256':sha(NEW/'native-render'),'growingOrNewFunctions':growth,'dependencyCount':len(deps)},indent=2))
