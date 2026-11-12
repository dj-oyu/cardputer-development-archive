#!/usr/bin/env python3
"""V2 posthoc admission regression. Frozen V1 failures remain explicit evidence."""
from pathlib import Path
import copy
import json
import runpy
import sys
sys.dont_write_bytecode=True
TESTS=Path(__file__).resolve().parent
H=runpy.run_path(str(TESTS/'test_aa_contract.py'),run_name='regression_helpers')
ROOT=H['ROOT'];ACTUAL=H['ACTUAL']
KNOWN_V1_FAILURES={
 'workspaceBytes/zero-understatement','newStackReserve/zero-understatement',
 'failedCategory/not-success-sentinel','expected-reserve/float'}

def expanded_cases(valid,keys):
 yield from H['cases'](valid,keys)
 for key in H['FIELDS']:
  item=copy.deepcopy(valid);item[key]=None;yield f'{key}/None',item,None
 for key in keys:
  for member in ['reserved','observed']:
   item=copy.deepcopy(valid);item['categories'][key][member]=None
   yield f'category/{key}/{member}/None',item,None
 for key in ['sampleHits','sampleNohits']:
  for index in range(4):
   item=copy.deepcopy(valid);item[key][index]=None;yield f'{key}/None-at-{index}',item,None
   item=copy.deepcopy(valid);item[key][index]+=1;yield f'{key}/wrong-count-at-{index}',item,None
  # A swap can preserve sums but corrupt matching per-sample coverage.
  item=copy.deepcopy(valid);item[key][0],item[key][1]=item[key][1],item[key][0]
  assert item[key]!=valid[key];yield f'{key}/per-sample-pair-mismatch-with-equal-total',item,None
 for value in [None,True,-1,0.0]:
  yield f'expected-reserve/entry-20-{value!r}',copy.deepcopy(valid),(20,value)
 for label,key,value in [('workspaceBytes/nonzero-understatement','workspaceBytes',137311),
                          ('newStackReserve/nonzero-understatement','newStackReserve',8191),
                          ('failedCategory/out-of-range','failedCategory',22)]:
  item=copy.deepcopy(valid);item[key]=value;yield label,item,None

def exercise(path,valid,reserved,identity):
 module=H['load_validator'](path);results=[]
 assert module.validate(copy.deepcopy(valid),reserved[:],valid['targets'],identity) is True
 results.append({'case':'positive-completed-actual-ON-report','passed':True})
 for name,item,arg in expanded_cases(valid,module.KEYS):
  bounds=reserved[:]
  if arg:bounds[arg[0]]=arg[1]
  try:module.validate(item,bounds,valid['targets'],identity)
  except (AssertionError,KeyError,TypeError,ValueError) as e:results.append({'case':name,'passed':True,'rejection':type(e).__name__})
  else:results.append({'case':name,'passed':False,'result':'invalid mutation accepted'})
 return {'validator':str(path.relative_to(ROOT)),'sha256':H['digest'](path),
         'passed':all(x['passed'] for x in results),'cases':results}

def main():
 valid=json.loads((TESTS/'fixtures/valid-aa-report.json').read_text())
 reserved=list(map(int,(ACTUAL/'ledger-front.txt').read_text().split()))
 identity=json.loads((ROOT/'identity-proof.json').read_text())['identityFNV64']
 original=json.loads((TESTS/'aa-contract-regression.json').read_text())
 assert original['passed'] is False
 frozen_failures={x['case'] for v in original['validators'] if v['validator']=='actual-001/code/aa_contract.py' for x in v['cases'] if not x['passed']}
 assert frozen_failures==KNOWN_V1_FAILURES
 assert H['digest'](ACTUAL/'code/aa_contract.py')==next(v['sha256'] for v in original['validators'] if v['validator']=='actual-001/code/aa_contract.py')
 current=exercise(ROOT/'code/aa_contract.py',valid,reserved,identity)
 frozen=exercise(ACTUAL/'code/aa_contract.py',valid,reserved,identity)
 runner=H['exercise_runner']()
 report={'status':'V2_PASS_WITH_RETAINED_FROZEN_V1_FAILURES' if current['passed'] and runner['passed'] and not frozen['passed'] else 'REGRESSION_FAILURE',
         'mutableValidator':current,'frozenOriginalValidator':frozen,
         'frozenOriginalStatus':'FAIL retained; must not be used as strengthened posthoc admission',
         'frozenOriginalSourceUnchanged':True,'originalRegressionReportUnchangedSHA256':H['digest'](TESTS/'aa-contract-regression.json'),
         'runner':runner,'nativeRenderingExecuted':False,'rendererRebuilt':False}
 (TESTS/'v2/aa-contract-regression.json').write_text(json.dumps(report,indent=2)+'\n')
 print(json.dumps({'status':report['status'],'mutableCases':len(current['cases']),
                   'mutableInvalidAccepted':[x['case'] for x in current['cases'] if not x['passed']],
                   'frozenV1InvalidAccepted':[x['case'] for x in frozen['cases'] if not x['passed']],
                   'runnerPinTestsPass':runner['passed'],'frozenOriginalModified':False},indent=2))
 return 0 if report['status']=='V2_PASS_WITH_RETAINED_FROZEN_V1_FAILURES' else 1
if __name__=='__main__':raise SystemExit(main())
