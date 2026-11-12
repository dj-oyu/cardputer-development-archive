#!/usr/bin/env python3
"""Read-only v3 loader negatives; never import/execute the scorer or render.

Parser-level mocks isolate semantic guards while original bytes retain their
verified hashes. Separate byte-level mocks test support pins and coordinated
rehashing against the caller's fixed external freeze SHA256. SHA256 results for
unchanged cached bytes are calculated once and reused to avoid expensive scans.
"""
from pathlib import Path
import builtins
import copy
import hashlib
import importlib.util
import json
import runpy
import subprocess
import sys
import traceback
from unittest.mock import patch
sys.dont_write_bytecode=True
ROOT=Path(__file__).resolve().parents[2]
D=ROOT/'actual-001';SOURCE=ROOT/'code/score_actual.py';O=D/'on'
EXPECTED_SHA='b7bf9126d854008ca413233287ce3d1460b5fa50ca8eeaafd7741b77afa96df2'
REAL_READ_BYTES=Path.read_bytes;REAL_READ_TEXT=Path.read_text;REAL_EXISTS=Path.exists
REAL_JSON_LOAD=json.load;REAL_OPEN=builtins.open;REAL_SHA=hashlib.sha256
REAL_SPEC=importlib.util.spec_from_file_location
BYTE_CACHE={};HASH_CACHE={}
class AdmissionReached(Exception):pass
class ForbiddenSideEffect(Exception):pass
class HashResult:
 def __init__(self,hexdigest):self.value=hexdigest
 def hexdigest(self):return self.value

def cache_bytes(path):
 path=path.resolve()
 if path not in BYTE_CACHE:BYTE_CACHE[path]=REAL_READ_BYTES(path)
 return BYTE_CACHE[path]
def cached_sha(data=b'',**kwargs):
 # Strong reference prevents object-ID reuse, preserving exact byte identity.
 key=id(data)
 if key not in HASH_CACHE:HASH_CACHE[key]=(data,REAL_SHA(data,**kwargs).hexdigest())
 assert HASH_CACHE[key][0] is data
 return HashResult(HASH_CACHE[key][1])

def cases(done):
 yield {'name':'positive-real-all20-admission'}
 changed=copy.deepcopy(done);changed['frames'][0]['metadata']['shadeUpdates']+=1
 yield {'name':'row-metadata-differs-from-actual-json','done':changed}
 changed=copy.deepcopy(done);changed['frames'][1]=copy.deepcopy(changed['frames'][0])
 yield {'name':'duplicate-key-and-missing-distinct-key-with-length20','done':changed}
 changed=copy.deepcopy(done);changed['frames'].pop()
 yield {'name':'missing-key-length19','done':changed}
 for value in [0,1,'false',None]:
  changed=copy.deepcopy(done);index=1 if value==1 else 0;changed['frames'][index]['reverse']=value
  yield {'name':f'reverse-not-exact-bool/{value!r}','done':changed}
 groups=[('visibility',(1000000,100000000,50000000)),('transport',(20000000,800000000,300000000))]
 for group,caps in groups:
  for (used,limit),cap in zip([('Rays','RayLimit'),('NodeVisits','NodeLimit'),('TriangleTests','TriangleLimit')],caps):
   for suffix,values in [(used,[('bool',True),('float',float(done['frames'][0]['metadata'][group+used])),('negative',-1),('None',None),('over-limit',cap+1)]),
                         (limit,[('bool',True),('float',float(cap)),('negative',-1),('None',None),('lower',cap-1),('higher',cap+1)])]:
    for label,value in values:
     changed=copy.deepcopy(done);changed['frames'][0]['metadata'][group+suffix]=value
     yield {'name':f'{group}{suffix}/{label}','done':changed,'actual':changed['frames'][0]['metadata']}
 yield {'name':'support-byte-mismatch','support_bytes':True}
 yield {'name':'support-plus-freeze-coordinated-rehash-external-sha-retained','support_bytes':True,'rehash_freeze':True}
 yield {'name':'wrong-caller-external-sha','external_sha':'0'*64}
 yield {'name':'missing-caller-external-sha','missing_arg':True}

def exercise(case,done,output_freeze):
 events={'scorerImport':0,'nativeCalls':0,'writeAttempts':0};actual_path=Path(str(O/done['frames'][0]['prefix'])+'.json').resolve()
 support_key=next(k for k in output_freeze['files'] if k.endswith('.support.npz'))
 support_path=(D/support_key).resolve();freeze_path=(D/'ACTUAL_OUTPUT_FREEZE.json').resolve()
 mutation=None;freeze_mutation=None
 if case.get('support_bytes'):
  raw=cache_bytes(support_path);mutation=bytes([raw[0]^1])+raw[1:]
 if case.get('rehash_freeze'):
  altered=copy.deepcopy(output_freeze);altered['files'][support_key]=REAL_SHA(mutation).hexdigest()
  freeze_mutation=(json.dumps(altered,indent=2)+'\n').encode()
  assert REAL_SHA(freeze_mutation).hexdigest()!=EXPECTED_SHA
 def read_bytes(path):
  resolved=path.resolve()
  if mutation is not None and resolved==support_path:return mutation
  if freeze_mutation is not None and resolved==freeze_path:return freeze_mutation
  return cache_bytes(path)
 def read_text(path,*args,**kwargs):
  if path.resolve()==(O/'COMPLETED.json').resolve() and 'done' in case:return json.dumps(case['done'])
  return REAL_READ_TEXT(path,*args,**kwargs)
 def load(handle,*args,**kwargs):
  value=REAL_JSON_LOAD(handle,*args,**kwargs)
  if Path(handle.name).resolve()==actual_path and 'actual' in case:return copy.deepcopy(case['actual'])
  if Path(handle.name).resolve()==freeze_path and freeze_mutation is not None:return json.loads(freeze_mutation)
  return value
 def exists(path):
  if path.resolve()==(O/'score-v3').resolve():return False
  return REAL_EXISTS(path)
 def stop_score(name,path,*args,**kwargs):
  if name=='frozen_formal_v3':events['scorerImport']+=1;raise AdmissionReached('all admission guards passed; scorer import deliberately blocked')
  return REAL_SPEC(name,path,*args,**kwargs)
 def forbid_native(*args,**kwargs):events['nativeCalls']+=1;raise ForbiddenSideEffect('native call forbidden')
 def forbid_write(*args,**kwargs):events['writeAttempts']+=1;raise ForbiddenSideEffect('write forbidden')
 def safe_open(file,mode='r',*args,**kwargs):
  if any(c in mode for c in 'wax+'):return forbid_write()
  return REAL_OPEN(file,mode,*args,**kwargs)
 argv=[str(SOURCE),str(D),'on']
 if not case.get('missing_arg'):argv.append(case.get('external_sha',EXPECTED_SHA))
 before=sys.path[:];line=None
 try:
  sys.path.insert(0,str(ROOT/'code'))
  with patch.object(Path,'read_bytes',read_bytes),patch.object(Path,'read_text',read_text),patch.object(Path,'exists',exists),patch.object(Path,'write_text',forbid_write),patch.object(Path,'write_bytes',forbid_write),patch.object(Path,'mkdir',forbid_write),patch.object(builtins,'open',safe_open),patch.object(json,'load',load),patch.object(hashlib,'sha256',cached_sha),patch.object(importlib.util,'spec_from_file_location',stop_score),patch.object(subprocess,'run',forbid_native),patch.object(sys,'argv',argv):
   try:runpy.run_path(str(SOURCE),run_name='__main__')
   except AdmissionReached:outcome='admitted; stopped before scorer import'
   except (AssertionError,IndexError,KeyError,TypeError) as exc:
    outcome='rejected before scorer import'
    frames=traceback.extract_tb(exc.__traceback__)
    line=next((f.lineno for f in reversed(frames) if Path(f.filename).resolve()==SOURCE.resolve()),None)
   except ForbiddenSideEffect:outcome='forbidden side effect attempted'
   else:outcome='unexpected normal completion'
 finally:sys.path[:]=before
 positive=case['name']=='positive-real-all20-admission'
 passed=outcome==('admitted; stopped before scorer import' if positive else 'rejected before scorer import')
 passed &= events['nativeCalls']==0 and events['writeAttempts']==0 and events['scorerImport']==int(positive)
 return {'case':case['name'],'passed':passed,'outcome':outcome,'guardLine':line,**events,
         'mockLayer':'real bytes and fixed external pin' if positive else 'byte-level hash mutation' if case.get('support_bytes') else 'caller argument' if case.get('missing_arg') or case.get('external_sha') else 'parsed-data semantic isolation'}

def main():
 freeze_raw=cache_bytes(D/'ACTUAL_OUTPUT_FREEZE.json');assert REAL_SHA(freeze_raw).hexdigest()==EXPECTED_SHA
 freeze=json.loads(freeze_raw);support_pins=[p for p in freeze['files'] if p.endswith('.support.npz')];assert len(support_pins)==20
 done=json.loads(REAL_READ_TEXT(O/'COMPLETED.json'));assert len(done['frames'])==20
 results=[exercise(case,done,freeze) for case in cases(done)]
 report={'status':'PASS' if all(r['passed'] for r in results) else 'FAIL','loaderSHA256':REAL_SHA(REAL_READ_BYTES(SOURCE)).hexdigest(),
         'externalOutputFreezeSHA256':EXPECTED_SHA,'supportFilesPinned':len(support_pins),'cases':results,
         'nativeRenderingExecuted':False,'formalScorerExecuted':False,'frozenDataModified':False,
         'hashCache':'real SHA256 of each unchanged byte buffer calculated once, then reused','semanticMockScope':'Parsed report mutations isolate inner semantic guards; separate actual changed-byte mocks test cryptographic pins.'}
 Path(__file__).with_name('loader-regression.json').write_text(json.dumps(report,indent=2)+'\n')
 print(json.dumps({'status':report['status'],'cases':len(results),'failed':[r for r in results if not r['passed']],
                   'supportFilesPinned':len(support_pins),'nativeCalls':sum(x['nativeCalls'] for x in results),
                   'formalScorerExecuted':False,'frozenDataModified':False},indent=2))
 return 0 if report['status']=='PASS' else 1
if __name__=='__main__':raise SystemExit(main())
