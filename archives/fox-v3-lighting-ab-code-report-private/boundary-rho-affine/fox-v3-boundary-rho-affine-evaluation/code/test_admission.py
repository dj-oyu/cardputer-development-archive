from pathlib import Path
import sys,json,copy
from aa_contract import validate
D=Path(sys.argv[1]).resolve();p=D/'on/private-partial/native-front-baseline.aa.json';a=json.load(open(p));reserved=list(map(int,(D/'ledger-front.txt').read_text().split()));arm='A' if D.name.endswith('A2') else 'B';expected=next(r['sampleHits'] for r in json.load(open(D/'PREFLIGHT_CONTRACT.json'))['arms'][arm]['rows'] if r['view']=='front' and r['case']=='baseline' and r['reverse'] is False)
def admit(x):return validate(x,reserved,2385,'912ba9aa3cfbfb2c',expected,json.load(open(D/'on/private-partial/native-front-baseline.json'))['visibilitySnapshotFingerprint'])
assert admit(a);n=0
for key,value in a.items():
 if type(value) is int:
  for wrong in [True,float(value),-1,None]:
   b=copy.deepcopy(a);b[key]=wrong
   try:admit(b)
   except (AssertionError,TypeError,KeyError):n+=1
   else:raise AssertionError((key,wrong))
for key in ['preflightExpectedHits','sampleHits']:
 for j in range(4):
  for wrong in [True,float(a[key][j]),a[key][j]+1,a[key][j]-1,None]:
   b=copy.deepcopy(a);b[key][j]=wrong
   try:admit(b)
   except (AssertionError,TypeError,KeyError):n+=1
   else:raise AssertionError((key,j,wrong))
for wrong in [False,1,1.,None]:
 b=copy.deepcopy(a);b['preflightMatch']=wrong
 try:admit(b)
 except AssertionError:n+=1
 else:raise AssertionError(wrong)
for wrong in [None,0,'0000000000000000','x'*16]:
 b=copy.deepcopy(a);b['preflightSnapshotFNV']=wrong
 try:admit(b)
 except AssertionError:n+=1
 else:raise AssertionError(wrong)
for key in ['preflightMatch','preflightExpectedHits','preflightROBytes','preflightSnapshotFNV']:
 b=copy.deepcopy(a);del b[key]
 try:admit(b)
 except (AssertionError,TypeError,KeyError):n+=1
 else:raise AssertionError(key)
for key in a['categories']:
 b=copy.deepcopy(a);b['categories'][key]['reserved']+=1
 try:admit(b)
 except AssertionError:n+=1
 else:raise AssertionError(key)
O=D.parent/'tests';O.mkdir(exist_ok=True);(O/(D.name+'-admission.json')).write_text(json.dumps({'positiveAdmittedFirst':True,'mutantsRejected':n,'newPreflightCountsTypesAndBindingFieldsChecked':True},indent=2)+'\n');print(n)
