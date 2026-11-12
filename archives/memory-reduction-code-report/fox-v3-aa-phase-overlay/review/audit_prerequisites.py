from pathlib import Path
import json,hashlib,subprocess
R=Path(__file__).resolve().parents[1];B=R.parent/'fox-v3-segmented-model-arena';sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();read=lambda p:json.loads(p.read_text())
subprocess.run(['python',str(R/'review/audit_source.py')],check=True,stdout=subprocess.DEVNULL)
for d in ['build-product','build-adapter']:
 m=read(R/d/'BUILD.json');assert sha(R/d/'native-render')==m['binarySHA256'];assert all(sha(R.parent/p)==h for p,h in m['files'].items());assert all(sha(R/d/p)==h for p,h in m['stackFiles'].items())
for f,main in [('NAMED_STACK.json',83776),('PRODUCT_NAMED_STACK.json',83792)]:
 a=read(R/f);b=read(B/f);assert a['chains']==b['chains'];assert (a['mainStack'],a['rendererPeak'],a['backgroundPeak'])==(main,5008,4080)
L=read(R/'MEMORY_LEDGER.json');assert L['baseLedgerSHA256']==sha(B/'MEMORY_LEDGER.json')
for p in L['phases'].values():assert sum(sum(v.values()) if isinstance(v,dict) else v for k,v in p.items() if k!='sumExcludingRO')==p['sumExcludingRO']
assert max(p['sumExcludingRO'] for p in L['phases'].values())==L['namedPeak']==491384
assert L['namedPeakDelta']==-4800 and L['largestNamedAllocation']==72512
assert L['phases']['render']['heap']['aaWorkspace']==72512
G=read(R/'GUARD_ACCOUNTING.json');assert G['rendererBudgetsUnchanged']['guardCapUnchanged']==1024 and G['rendererBudgetsUnchanged']['producerCapUnchanged']==637599
for variant in ['build-synthetic','build-synthetic-sanitized','review']:
 for test,nkey,num in [('test_ring_exact','syntheticExactCases',80),('test_ring_exact_depth','syntheticExactCases',80),('test_ring_negative','negativeCases',72),('test_ring_negative_depth','negativeCases',72)]:
  a=read(R/variant/(test+'.log'));assert a['status']=='PASS' and a[nkey]==num
for f in ['adapter-tests-final.log','adapter-tests-sanitized-final.log']:
 s=(R/f).read_text();assert '"negativeCases":94' in s and '"prefixPreservation":"PASS"' in s
assert read(R/'INTEGRATION_TESTS.json')['status']=='PASS';assert all(x['returncode']==0 for x in read(R/'INTEGRATION_TESTS.json')['records'])
assert read(R/'test-results/RESULTS.json')['status']=='ALL_PASS'
assert len(read(R/'test-independent/RESULTS.json')['results'])==6
pins=['review/CODE_REVIEW.md','review/SOURCE_REVIEW.json','review/RUNNER_REVIEW.json','review/LAYOUT.json','review/audit_source.py','review/audit_retained.py','review/audit_prerequisites.py','MEMORY_LEDGER.json','GUARD_ACCOUNTING.json','NAMED_STACK.json','PRODUCT_NAMED_STACK.json','HOST_BINARY_SIZE.json','SYNTHETIC_RESULTS.json','PREREQUISITE_REPORT.md','INTEGRATION_TESTS.json','test-results/RESULTS.json','test-independent/RESULTS.json','build-product/BUILD.json','build-adapter/BUILD.json']
o={'status':'PASS','reviewKind':'INDEPENDENT_PREACTUAL_REVIEW','actualFrames':0,'sourceContractBuildStackGuardRunnerPass':True,'independentSyntheticExactCases':160,'independentNegativeCases':144,'normalAndSanitizedCoverageReviewed':True,'legacyAndIntegrationPass':True,'overlaySize':72512,'savedBytes':4800,'namedPeak':491384,'largestNamedAllocation':72512,'productMainStack':83792,'observerMainStack':83776,'rendererStack':5008,'backgroundStack':4080,'backgroundCap':4096,'globalWritableDataAndBssUnchanged':True,'publicationProtection':'Unchanged source ordering plus bands-finish rejection and prefix tests; no end-to-end late-render injection. Core scratch may mutate on failure.','evidencePins':{p:sha(R/p) for p in pins},'openImplementationBlockers':[],'remainingGateConditions':['Final source freeze matches all reviewed source/test/build/evidence hashes','Parent explicitly issues physical execution gate','Only pinned fixed40 runner, no additional actual frames'],'qualifications':['C11 pinned 64-bit ABI; all consumers rebuilt; no binary compatibility guarantee','Allocator overhead and runtime library stacks excluded','No speedup, whole-process or device-fit claim','No actual renders or device/public/PR actions by reviewer']}
(R/'review/REVIEW.json').write_text(json.dumps(o,indent=2)+'\n');print('PASS',len(pins),'evidence pins')
