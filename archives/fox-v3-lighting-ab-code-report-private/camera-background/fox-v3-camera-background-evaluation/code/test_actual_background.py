from pathlib import Path
import sys,json,hashlib,copy
from background_contract import validate
D=Path(sys.argv[1]);arm=sys.argv[2];O=D/('background-control' if arm=='background' else arm);done=json.load(open(O/'COMPLETED.json'));inp=json.load(open(D/'private/BACKGROUND_INPUTS.json'));cs=json.load(open(D/'CORE-WORK-DESIGN.json'));sha=hashlib.sha256((D/'private/BACKGROUND_INPUTS.json').read_bytes()).hexdigest();positive=negative=0
for row in done['frames']:
 p=O/row['prefix'];f=json.load(open(str(p)+'.background.json'));m=json.load(open(str(p)+'.json'));fixed=next(x for x in inp['rows'] if x['name']==p.name);validate(f,m,fixed,arm,cs,sha);positive+=1
 def leaves(v,path=()):
  for k,x in v.items():
   if isinstance(x,dict):yield from leaves(x,path+(k,))
   else:yield path+(k,),x
 for path,v in leaves(f):
  if type(v)is int:reps=[False,float(v),-1,None]
  elif type(v)is bool:reps=[not v,int(v),None]
  elif type(v)is str:reps=[v+'!',None]
  else:continue
  for bad in reps:
   z=copy.deepcopy(f);q=z
   for k in path[:-1]:q=q[k]
   q[path[-1]]=bad
   try:validate(z,m,fixed,arm,cs,sha)
   except (AssertionError,TypeError,KeyError,ValueError):negative+=1
   else:raise AssertionError(('accepted',path,bad))
print(json.dumps(dict(actualPositive=positive,mutationsRejected=negative,arm=arm)))
