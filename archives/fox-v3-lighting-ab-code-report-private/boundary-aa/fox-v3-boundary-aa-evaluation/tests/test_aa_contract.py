#!/usr/bin/env python3
"""Independent code/report-only regression checks. No native render is executed.

The positive fixture is a completed real ON metadata report, not invented values.
Runner pin checks use mocked read_bytes and a hard stop at mkdir; the pinned
ledger and frozen actual directory are never modified.
"""
from pathlib import Path
import argparse
import copy
import hashlib
import types
import json
import runpy
import subprocess
import sys
from unittest.mock import patch

sys.dont_write_bytecode = True

ROOT = Path(__file__).resolve().parents[1]
TESTS = Path(__file__).resolve().parent
ACTUAL = ROOT / 'actual-001'
FIELDS = ['reservedTotal','observedTotal','targets','coveredTargets','nohitTargets',
          'centerShades','sampleShades','workspaceBytes','newStackReserve',
          'retainedOutputBytes','identityBytes','observerSamples','observerHits','failedCategory']

def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def load_validator(path):
    module = types.SimpleNamespace()
    exec(compile(path.read_text(), str(path), 'exec'), module.__dict__)
    return module

def cases(valid, keys):
    """Mutations deliberately include understatements, not only cap overruns."""
    for key in FIELDS:
        for label, value in [('bool', True), ('float', float(valid[key])), ('negative', -1)]:
            item = copy.deepcopy(valid); item[key] = value
            yield f'{key}/{label}', item, None
        item = copy.deepcopy(valid); del item[key]
        yield f'{key}/missing', item, None
    changes = [
        ('version/wrong','version','old-api'),('complete/integer','complete',1),
        ('complete/false','complete',False),('reservedTotal/wrong','reservedTotal',valid['reservedTotal']+1),
        ('observedTotal/wrong','observedTotal',valid['observedTotal']+1),
        ('targets/wrong','targets',valid['targets']-1),
        ('observerSamples/wrong','observerSamples',valid['observerSamples']-1),
        ('observerHits/wrong','observerHits',valid['observerHits']-1),
        ('workspaceBytes/over-cap','workspaceBytes',147456),
        ('workspaceBytes/zero-understatement','workspaceBytes',0),
        ('newStackReserve/zero-understatement','newStackReserve',0),
        ('failedCategory/not-success-sentinel','failedCategory',0),
        ('retainedOutputBytes/wrong','retainedOutputBytes',194399),
        ('identityBytes/wrong','identityBytes',7929),
        ('identityFNV/wrong','identityFNV','0000000000000000'),
        ('identityFNV/non-string','identityFNV',912),
    ]
    for label,key,value in changes:
        item=copy.deepcopy(valid);item[key]=value;yield label,item,None
    for key in keys:
        for member in ['reserved','observed']:
            for label,value in [('bool',True),('float',float(valid['categories'][key][member])),('negative',-1)]:
                item=copy.deepcopy(valid);item['categories'][key][member]=value
                yield f'category/{key}/{member}/{label}',item,None
            item=copy.deepcopy(valid);del item['categories'][key][member]
            yield f'category/{key}/{member}/missing',item,None
        item=copy.deepcopy(valid);item['categories'][key]['reserved']+=1;item['reservedTotal']+=1
        yield f'category/{key}/wrong-reserve-with-consistent-total',item,None
        item=copy.deepcopy(valid);item['categories'][key]['observed']=item['categories'][key]['reserved']+1
        item['observedTotal']=sum(x['observed'] for x in item['categories'].values())
        yield f'category/{key}/over-reserve',item,None
    for label, action in [
        ('missing',lambda c:c.pop(keys[-1])),
        ('unknown',lambda c:c.update(unrecognized={'reserved':0,'observed':0})),
        ('malformed-value',lambda c:c.update({keys[0]:['reserved','observed']})),
        ('extra-member',lambda c:c[keys[0]].update(unrecognized=0)),
    ]:
        item=copy.deepcopy(valid);action(item['categories']);yield f'categories/{label}',item,None
    for key in ['sampleHits','sampleNohits']:
        for label,value in [('bool',True),('float',float(valid[key][0])),('negative',-1)]:
            item=copy.deepcopy(valid);item[key][0]=value;yield f'{key}/{label}',item,None
        for count in [0,3,5]:
            item=copy.deepcopy(valid);item[key]=(item[key]+[0])[:count];yield f'{key}/count-{count}',item,None
        item=copy.deepcopy(valid);item[key][0]+=1;yield f'{key}/wrong-count-total',item,None
        item=copy.deepcopy(valid);del item[key];yield f'{key}/missing',item,None
    # Admission arguments are separate from pinned runner data. This checks
    # validate's advertised strictness rather than claiming a runner exploit.
    for label, value in [('bool',True),('float',float(valid['categories'][keys[0]]['reserved'])),('negative',-1)]:
        yield f'expected-reserve/{label}',copy.deepcopy(valid),(0,value)

def exercise_validator(path,valid,reserved,identity):
    module=load_validator(path);results=[]
    assert module.validate(copy.deepcopy(valid),reserved[:],valid['targets'],identity) is True
    results.append({'case':'positive-completed-actual-ON-report','passed':True})
    for name,item,arg in cases(valid,module.KEYS):
        bounds=reserved[:]
        if arg:bounds[arg[0]]=arg[1]
        try:
            module.validate(item,bounds,valid['targets'],identity)
        except (AssertionError,KeyError,TypeError,ValueError) as exc:
            results.append({'case':name,'passed':True,'rejection':type(exc).__name__})
        else:
            results.append({'case':name,'passed':False,'result':'invalid mutation accepted'})
    return {'validator':str(path.relative_to(ROOT)),'sha256':digest(path),
            'passed':all(x['passed'] for x in results),'cases':results}

class OutputBoundaryReached(Exception): pass
class NativeExecutionForbidden(Exception): pass

def exercise_runner():
    original_read=Path.read_bytes
    source=ROOT/'code/run_actual.py'
    results=[]
    # Positive first: the unmodified read-only inputs pass pins and reach output
    # creation; mkdir is mocked to stop before ANY write or native execution.
    for target in [None,'ledger-front.txt','ledger-oblique.txt','ledger-contract.json']:
        native=[];mkdir=[];mutations=[]
        def read_bytes(path):
            value=original_read(path)
            if target and path.resolve()==(ACTUAL/target).resolve():
                mutations.append(str(path));return value+b'\nCORRUPTED_IN_READ_ONLY_MOCK\n'
            return value
        def forbidden_native(*args,**kwargs):
            native.append(True);raise NativeExecutionForbidden('native execution is forbidden in regression checks')
        def stop_mkdir(*args,**kwargs):
            mkdir.append(True);raise OutputBoundaryReached('stop before filesystem mutation')
        before_sys_path=sys.path[:]
        try:
            sys.path.insert(0,str(ROOT/'code'))
            with patch.object(Path,'read_bytes',read_bytes),patch.object(Path,'mkdir',stop_mkdir),patch.object(subprocess,'run',forbidden_native),patch.object(sys,'argv',[str(source),str(ACTUAL),'on']):
                try:runpy.run_path(str(source),run_name='__main__')
                except OutputBoundaryReached:outcome='passed pins; stopped before output creation'
                except AssertionError:outcome='rejected before output creation'
                except NativeExecutionForbidden:outcome='native unexpectedly reached'
                else:outcome='unexpected normal completion'
        finally:sys.path[:]=before_sys_path
        passed=(not native and (len(mkdir)==1 if target is None else not mkdir and bool(mutations)))
        passed &= outcome==('passed pins; stopped before output creation' if target is None else 'rejected before output creation')
        results.append({'case':'positive-pins' if target is None else f'mutated-pin/{target}',
                        'passed':passed,'outcome':outcome,'nativeCalls':len(native),'filesystemMutations':0})
    return {'runner':str(source.relative_to(ROOT)),'sha256':digest(source),'passed':all(x['passed'] for x in results),'cases':results}

def main():
    parser=argparse.ArgumentParser();parser.add_argument('--validator',type=Path,action='append');args=parser.parse_args()
    fixture=TESTS/'fixtures/valid-aa-report.json';valid=json.loads(fixture.read_text())
    reserved=list(map(int,(ACTUAL/'ledger-front.txt').read_text().split()))
    identity=json.loads((ROOT/'identity-proof.json').read_text())['identityFNV64']
    paths=args.validator or [ROOT/'code/aa_contract.py',ACTUAL/'code/aa_contract.py']
    report={'fixtureSHA256':digest(fixture),'fixtureSource':'completed native-front-baseline.aa.json metadata only',
            'nativeRenderingExecuted':False,'frozenInputsModified':False,
            'validators':[exercise_validator(p.resolve(),valid,reserved,identity) for p in paths],
            'runner':exercise_runner()}
    report['passed']=report['runner']['passed'] and all(x['passed'] for x in report['validators'])
    (TESTS/'aa-contract-regression.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps({'passed':report['passed'],'validatorCases':{x['validator']:len(x['cases']) for x in report['validators']},
                     'acceptedInvalidMutations':{x['validator']:[v['case'] for v in x['cases'] if not v['passed']] for x in report['validators']},
                     'runnerPinnedMutationRejection':report['runner']['passed'],'nativeRenderingExecuted':False},indent=2))
    return 0 if report['passed'] else 1
if __name__=='__main__':raise SystemExit(main())
