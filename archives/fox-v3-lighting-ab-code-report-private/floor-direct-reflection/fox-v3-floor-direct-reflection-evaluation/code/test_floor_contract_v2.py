from pathlib import Path
import json,sys,copy
from floor_contract_v2 import validate
D=Path(sys.argv[1]);arm=sys.argv[2];done=json.load(open(D/arm/'COMPLETED.json'));bounds=json.load(open(D/'WORKLOAD_BOUNDS.json'))['rows'];source=json.load(open(D/'SOURCE_RHO.json'));accepted=rejected=0
for row in done['frames']:
 p=D/arm/row['prefix'];f=json.load(open(str(p)+'.floor.json'));m=row['metadata'];b=next(x for x in bounds if all(x[k]==row[k] for k in ['view','case','reverse']));ci=['baseline','direction','intensity','ambient','albedo'].index(row['case']);rho=source['scenarios'][ci]['actualGroundBaseColor'][:3] if arm=='on' else [0.,0.,0.];validate(f,m,b,rho,arm);accepted+=1
 for key in ['limitTotal','usedTotal','shaderCalls','floorHits','evaluations','zeroRhoHits','tangentHits','floorQueries','caseIndex','workBytes','contextBytes','resultBytes','groundDescriptorBytes']:
  for val in [False,float(f[key]),-1,None,f[key]+1,0] if f[key]!=0 else [False,float(f[key]),-1,None,1]:
   bad=copy.deepcopy(f);bad[key]=val
   try:validate(bad,m,b,rho,arm)
   except (AssertionError,TypeError,KeyError):rejected+=1
   else:raise AssertionError(('ACCEPTED',key,val))
 for key in ['workBytes','contextBytes','resultBytes','groundDescriptorBytes']:
  bad=copy.deepcopy(f);del bad[key]
  try:validate(bad,m,b,rho,arm)
  except (AssertionError,TypeError,KeyError):rejected+=1
  else:raise AssertionError(('ACCEPTED_MISSING',key))
 for key in ['primary_ground_reflection_hits','primary_ground_direct_queries','groundMode','floorCase','transportRays','snapshotBytes']:
  for val in [False,float(m[key]),-1,None,m[key]+1]:
   bad=copy.deepcopy(m);bad[key]=val
   try:validate(f,bad,b,rho,arm)
   except (AssertionError,TypeError,KeyError):rejected+=1
   else:raise AssertionError(('ACCEPTED_METADATA',key,val))
 for badarm in set(['off','zero','on'])-{arm}:
  try:validate(f,m,b,rho,badarm)
  except (AssertionError,TypeError,KeyError):rejected+=1
  else:raise AssertionError('accepted mode swap')
result={'status':'POSITIVE_FIRST_STRICT_NEGATIVES_PASS','arm':arm,'accepted':accepted,'rejected':rejected};out=D/arm/'ADMISSION_TESTS.json';out.write_text(json.dumps(result,indent=2)+'\n');print(result)
