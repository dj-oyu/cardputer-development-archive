"""Positive actual template first; each shade/floor bound +/-1 must fail."""
from pathlib import Path
import json,copy,sys
from floor_contract_v2 import validate
D=Path(sys.argv[1]);arm=sys.argv[2];rows=json.load(open(D/arm/'COMPLETED.json'))['frames'];bounds=json.load(open(D/'WORKLOAD_BOUNDS.json'))['rows'];src=json.load(open(D/'SOURCE_RHO.json'));n=0
for row in rows:
 f=json.load(open(str(D/arm/row['prefix'])+'.floor.json'));m=row['metadata'];b=next(x for x in bounds if all(x[k]==row[k] for k in ['view','case','reverse']));ci=['baseline','direction','intensity','ambient','albedo'].index(row['case']);rho=src['scenarios'][ci]['actualGroundBaseColor'][:3] if arm=='on' else [0.,0.,0.];validate(f,m,b,rho,arm)
 for key in ['shadeUpdates','primary_ground_hits']:
  for delta in [-1,1]:
   bad=copy.deepcopy(b);bad[key]+=delta
   try:validate(f,m,bad,rho,arm)
   except AssertionError:n+=1
   else:raise AssertionError('changed workload bound admitted')
(D/arm/'WORKLOAD_GATE_TESTS.json').write_text(json.dumps({'positiveFrames':len(rows),'rejectedPlusMinusOneBounds':n,'status':'PASS'},indent=2)+'\n');print('PASS',len(rows),n)
