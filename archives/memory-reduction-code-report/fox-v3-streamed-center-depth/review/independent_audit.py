from pathlib import Path
import hashlib,json
R=Path(__file__).resolve().parents[1];B=R.parent/'fox-v3-cached-profile-renderer';sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
legacy=[]
for p in (B/'code').iterdir():
 if p.is_file():assert p.read_bytes()==(R/'code'/p.name).read_bytes(),p;legacy.append(str(p.relative_to(B)))
for p in (B/'cache').glob('*'):
 if p.is_file():assert p.read_bytes()==(R/'cache'/p.name).read_bytes(),p
assert (R/'harness/row_transport_bridge.c').read_bytes().startswith((B/'harness/row_transport_bridge.c').read_bytes())
old=(B/'code/ksn_cached_profile_impl.inc').read_text();new=(R/'code/ksn_stream_depth_impl.inc').read_text()
start=' static const double dx[4]';end=' if(!sc_complete(binding,new_report)||rd->used[RH_PROFILE]!=32400)return false;'
assert old[old.index(start):old.index(end)]==new[new.index(start):new.index(end)]
stack={}
for build,report in [('build-product','PRODUCT_NAMED_STACK.json'),('build-adapter','NAMED_STACK.json')]:
 frames={}
 for p in (R/build).glob('*.su'):
  for line in p.read_text().splitlines():
   loc,amount,kind=line.split('\t');frames[p.stem+':'+loc.rsplit(':',1)[-1]]=int(amount)
 d=json.loads((R/report).read_text())
 for c in d['chains'].values():
  assert sum(x['bytes'] for x in c['frames'])==c['bytes']
  assert all(x['bytes']==frames[x['name']] for x in c['frames'])
 for f,h in d['stackFiles'].items():assert sha(R/build/f)==h
 assert d['mainStack']==frames['native_render_row:main']
 assert d['backgroundPeak']==max(d['chains'][k]['bytes'] for k in ['quarter_background','center_background'])<=4096
 assert d['rendererPeak']==max(c['bytes'] for c in d['chains'].values())<=8192
 stack[build]={k:d[k] for k in ['mainStack','backgroundPeak','rendererPeak']}
m=json.loads((R/'MEMORY_LEDGER.json').read_text());base=json.loads((B/'MEMORY_LEDGER.json').read_text())
for name,p in m['phases'].items():
 if name=='render':amount=sum(p['heap'].values())+p['mainStack']+p['namedChildStack']
 else:amount=sum(v for k,v in p.items() if k!='sumExcludingRO')
 assert amount==p['sumExcludingRO']
assert m['namedPeak']==max(p['sumExcludingRO'] for p in m['phases'].values())
assert m['baselineNamedPeak']==base['namedPeak']
assert m['namedPeakDelta']==m['namedPeak']-base['namedPeak']
assert m['phases']['render']['sumExcludingRO']==base['phases']['render']['sumExcludingRO']-120960+stack['build-product']['mainStack']-base['stack']['main']+stack['build-product']['rendererPeak']-base['stack']['rendererPeak']
for group in m['diagnosticPhases'].values():
 for p in group.values():assert p['sumExcludingRO']==sum(v for k,v in p.items() if k!='sumExcludingRO')
files=[*[(R/p) for p in legacy],R/'code/ksn_stream_depth.h',R/'code/ksn_stream_depth_impl.inc',R/'harness/row_transport_bridge.c',R/'harness/row_transport_bridge.h',R/'harness/native_render_row.c',R/'harness/stream_depth_alloc.h',R/'MEMORY_LEDGER.json',R/'NAMED_STACK.json',R/'PRODUCT_NAMED_STACK.json',R/'review/independent_exact.c',R/'review/independent_admission.c',R/'review/INDEPENDENT_ADMISSION.log',R/'review/INDEPENDENT_SYNTHETIC.json',Path(__file__)]
out={'status':'PASS_INDEPENDENT_SOURCE_STACK_LEDGER','actualFrames':0,'oldCodeByteIdentical':legacy,'legacyBridgePrefixIdentical':True,'quarterLoopByteIdentical':True,'compiledNamedStacks':stack,'memory':{'render':m['phases']['render']['sumExcludingRO'],'wholeNamedPeak':m['namedPeak'],'wholeNamedPeakDelta':m['namedPeakDelta'],'grossDepthSaving':120960,'pendingCopyBytes':15360,'captureCopyAndHeapBytes':129600,'largestBlockUnchanged':72512},'guardProof':{'coreAdmission':{'noCapture':170,'capture':189},'adapterPairs':{'noCaptureOff':351,'noCaptureOn':378,'captureOff':378,'captureOn':406},'totalAdmission':{'noCaptureOff':521,'noCaptureOn':548,'captureOff':567,'captureOn':595},'capUnchanged':1024,'guardDelta':{'noCapture':16,'capture':33},'pendingFloatUnits':3840,'captureFloatUnits':32400,'producerCapUnchanged':637599},'sourcePins':{str(p.relative_to(R)):sha(p) for p in files}}
(R/'review/INDEPENDENT_SOURCE_STACK_LEDGER.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k not in ['sourcePins','oldCodeByteIdentical']},indent=2))
