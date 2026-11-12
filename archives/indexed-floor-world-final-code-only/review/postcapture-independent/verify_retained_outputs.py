#!/usr/bin/env python3
"""Read-only retained-output verifier. Never invokes a renderer or mutates inputs."""
from pathlib import Path
import json,hashlib,collections,sys,subprocess,datetime
W=Path('/workspace/scratch/6d8dcdbcdc54');R=W/'fox-v3-indexed-floor-world';I=W/'fox-v3-indexed-bvh';F=W/'fox-v3-floor-world-reflection'
J=lambda p:json.loads(Path(p).read_text())
counts=collections.Counter();seen=set()
def H(p):
 p=Path(p);assert p.is_relative_to(W) and not any(x in str(p) for x in ['owned-ray-context','paged']),str(p)
 h=hashlib.sha256()
 with p.open('rb') as f:
  for x in iter(lambda:f.read(1048576),b''):h.update(x)
 seen.add(str(p));counts['hashChecks']+=1
 return h.hexdigest()
def pin(p,h):assert H(p)==h,str(p)
def pins(base,d):
 for p,h in d.items():pin(base/p,h)
def eq(a,b):
 a=Path(a);b=Path(b);assert a.read_bytes()==b.read_bytes(),(str(a),str(b));counts['byteComparisons']+=1
FIXED={'SOURCE_FREEZE.json':'92f0e104b106c746adf33212f9f619acb12b3bd3d7a9ede8651ed76b0f1a6412','PREREQUISITE_SUMMARY.json':'2d2fa8993b5e8cba94838482354adf99690b4476e2777500a0cbf3a5a1f482de','review/independent/REVIEW.json':'0d68e5f6d8af547396337dd2f1893a4d0344aee792fd775ced9f713be8f18daa'}
pins(R,FIXED);freeze=J(R/'SOURCE_FREEZE.json');pins(R,freeze['files']);pins(W,J(R/'BASELINE_PINS.json')['pins']);pins(W,J(R/'PREREQUISITE_SUMMARY.json')['pins'])
gate=J(R/'review/PHYSICAL_EXECUTION_GATE.json');assert gate['status']=='INDEXED_FLOOR_WORLD_ACTUAL40_CLEARED';pins(W,gate['pins']);gatehash=H(R/'review/PHYSICAL_EXECUTION_GATE.json')
builds={}
for folder in ['build-adapter','build-product']:
 b=J(R/folder/'BUILD.json');pin(R/folder/'native-render',b['binarySHA256']);pins(W,b['files']);builds[folder]=b
pin(I/'actual-001/COMPLETED.json','3771843dbc66bdfcf90ae89d5461065172178e1e5f697688b6c7b5775f08c7e5');ib=J(I/'actual-001/COMPLETED.json');assert len(ib['frames'])==20
ifiles={f['name']:f for f in ib['frames']};assert len(ifiles)==20
for n,f in ifiles.items():pins(I/'actual-001',{n+e:h for e,h in f['files'].items()})
pin(F/'COMPLETION_PINS.json','253d36637f16c2acc674aced651cc8dfd144f2fb71fed19613446e283bc3cbf5');pins(W,J(F/'COMPLETION_PINS.json')['files'])
pin(F/'capture/SOURCE_FREEZE.json','fb98fdcd29ca3a2dcb7a040db2fd08a952a4ffa6eba882ba3cc7cbb369e9a64f')
# The former review established transport and indexed isolation; verify current source hashes again.
for n in ['bounce.c','bounce.h','pixel_transport.c','pixel_transport.h']:eq(R/'private-build/transport'/n,F/'capture/transport'/n)
for n in ['visibility.c','visibility.h']:eq(R/'private-build/visibility'/n,I/'private-build/visibility'/n)
ARTIFACTS={'.u16le','.f32le','.snapshot','.targets.u8','.hdr.f64le','.json','.aa.json','.floor.json','.background.json','.row.json','.floor-world.json','.hdr-observer.json'}
TIMES={'.json':{'transportBuildNs','visibilityBuildNs','appendNs','evaluateNs','hostRenderNsFirstFrame'},'.background.json':{'backgroundBuildNs'},'.row.json':{'backgroundBuildNs'}}
TRAV={'transportRays':'visibilityRays','transportNodeVisits':'visibilityNodeVisits','transportTriangleTests':'visibilityTriangleTests'}
OB={'enabled':True,'complete':True,'diagnosticOnly':True,'bufferBytes':777600,'controlBytes':24,'initializationWriteBytes':259200,'sampleWrites':32400,'captureWriteBytes':777600,'dumpBytes':777600,'shadingFeedback':False}
rows=[];manifestpins={};arm_details={};arms=sys.argv[1:] or ['off','on']
for arm in arms:
 out=R/('actual-'+arm+'-001');mp=out/'COMPLETED.json';m=J(mp);manifestpins[str(mp.relative_to(W))]=H(mp)
 assert m['status']=='ALL20_EXACT_COMPLETE' and m['arm']==arm and len(m['frames'])==20 and m['storageContract']==3
 assert m['frames']==J(out/'completed-cases.json');assert {f['name'] for f in m['frames']}==set(ifiles)
 assert not (out/'FAILED.json').exists();assert not list(out.glob('*.stdout-pending'))
 cm=J(F/('composed-'+arm)/'COMPLETED.json');cp={(f['view'],f['case']):f for f in cm['frames']};wm=J(F/'capture'/arm/'COMPLETED.json');wp={(f['view'],f['case']):f for f in wm['frames']}
 assert len(cp)==len(wp)==10
 for (v,c),f in cp.items():
  base=F/('composed-'+arm);pin(base/f['hdr'],f['hdrSHA256']);pin(base/f['floorWorld'],f['floorWorldSHA256'])
  for q in f['outputs'].values():pin(base/q['path'],q['sha256'])
 for f in wp.values():pins(F/'capture'/arm,{f['prefix']+e:h for e,h in f['files'].items()})
 for f in m['frames']:
  n=f['name'];v=f['view'];c=f['case'];rev=f['reverse'];assert n=='native-'+v+'-'+c+('-reverse' if rev else '') and f['arm']==arm and f['status']=='PASS'
  assert set(f['files'])==ARTIFACTS;pins(out,{n+e:h for e,h in f['files'].items()})
  p=lambda e:out/(n+e);old=lambda e:I/'actual-001'/(n+e);cf=cp[v,c];wf=wp[v,c]
  for e in ['.f32le','.snapshot','.targets.u8']:eq(p(e),old(e))
  eq(p('.hdr.f64le'),F/('composed-'+arm)/cf['hdr']);eq(p('.u16le'),F/('composed-'+arm)/cf['outputs']['agx']['path'])
  assert p('.hdr.f64le').stat().st_size==777600 and p('.u16le').stat().st_size==64800 and p('.f32le').stat().st_size==129600 and p('.targets.u8').stat().st_size==32400
  if arm=='off':eq(p('.u16le'),old('.u16le'))
  reports={e:J(p(e)) for e in ['.json','.aa.json','.floor.json','.background.json','.row.json']};a=reports['.json'];aa=reports['.aa.json'];fl=reports['.floor.json'];rw=reports['.row.json'];fw=J(p('.floor-world.json'));base=J(old('.json'))
  assert a['transportComplete'] and a['visibilityComplete'] and aa['complete'] and fl['complete'] and reports['.background.json']['complete'] and rw['complete']
  assert a['reverse']==rev
  for e,current in reports.items():
   previous=J(old(e));assert current.keys()==previous.keys()
   for k,x in current.items():
    y=previous[k]
    if k in TIMES.get(e,set()):assert f['timingExclusions'][e][k]=={'baseline':y,'candidate':x};continue
    if (e,k) in [('.json','transportContextBytes'),('.floor.json','contextBytes')]:assert x==608 and y==576
    elif e=='.json' and k in TRAV:assert x-y==fw[TRAV[k]]
    elif e=='.row.json' and k=='adapterSpanPairs':assert x==y+(24 if arm=='on' else 0) and x==(300 if arm=='on' else 276)
    elif e=='.row.json' and k=='producerUsed':assert len(x)==len(y)==11 and x[:-1]==y[:-1] and x[-1]-y[-1]==(24 if arm=='on' else 0)
    elif e=='.row.json' and k=='clamped':assert x==cf['clampedPixels']
    else:assert x==y,(arm,n,e,k)
   counts['reportComparisons']+=1
  assert fw['enabled']==(arm=='on') and fw['complete'] and fw['sameTransportBudget'] and not fw['old8MCombinedAdmission']
  assert fw['version']=='floor-world-v1' and (fw['workBytes'],fw['componentBytes'],fw['innerSamples'])==(104,24,16)
  if arm=='on':
   assert fw['shaderCalls']==fw['shaderLimit']==a['shadeUpdates']==base['shadeUpdates']
   assert fw['evaluations']==fw['hitLimit']==a['primary_ground_reflection_hits']==fl['evaluations']==base['primary_ground_reflection_hits']
   assert fw['workUsed']==fw['workLimit']==64*fw['shaderCalls']+6272*fw['evaluations']<=450598848
   assert fw['queries']==fw['visibilityRays']==16*fw['evaluations']
   assert fw['misses']+fw['blockedCharacter']+fw['blockedFloor']==fw['queries'] and fw['blockedFloor']==0
  else:
   assert all(fw[k]==0 for k in ['shaderLimit','hitLimit','workLimit','workUsed','shaderCalls','evaluations','queries','misses','blockedFloor','blockedCharacter','visibilityRays','visibilityNodeVisits','visibilityTriangleTests'])
  if not rev or arm=='off':assert fw==J(F/'capture'/arm/(wf['prefix']+'.floor-world.json'))
  assert J(p('.hdr-observer.json'))==OB
  assert (a['transportRayLimit'],a['transportNodeLimit'],a['transportTriangleLimit'])==(20000000,800000000,300000000)
  assert (a['visibilityRayLimit'],a['visibilityNodeLimit'],a['visibilityTriangleLimit'])==(1000000,100000000,50000000)
  for num,cap in [('transportRays','transportRayLimit'),('transportNodeVisits','transportNodeLimit'),('transportTriangleTests','transportTriangleLimit'),('visibilityRays','visibilityRayLimit'),('visibilityNodeVisits','visibilityNodeLimit'),('visibilityTriangleTests','visibilityTriangleLimit')]:assert 0<=a[num]<=a[cap]
  assert aa['observedTotal']==sum(x['observed'] for x in aa['categories'].values())<=aa['reservedTotal']==sum(x['reserved'] for x in aa['categories'].values())<=8000000
  assert fl['usedTotal']==sum(x['used'] for x in fl['categories'].values())<=fl['limitTotal']==sum(x['limit'] for x in fl['categories'].values())
  assert sum(rw['producerUsed'])<=637599 and rw['adapterGuardUpper']==1024 and rw['hostFinishHashBytes']==72138 and rw['hostFinishHashLimit']==73728
  assert rw['backgroundWorkTotal']==sum(rw['backgroundWorkUsed'])
  command=J(p('.command.json'));assert command['arm']==arm and command['case']==n and command['binarySHA256']==builds['build-adapter']['binarySHA256'] and command['gateSHA256']==gatehash
  assert command['environment']['HONE_FLOOR_WORLD']==arm and command['command'][0]==str(R/'build-adapter/native-render') and command['command'][2]==str(out/n) and command['command'][3]==str(int(rev))
  baseline_command=J(old('.command.json'))
  assert command['command'][1]==baseline_command['command'][1] and command['command'][3:]==baseline_command['command'][3:]
  assert {k:v for k,v in command['environment'].items() if k!='HONE_FLOOR_WORLD'}==baseline_command['environment']
  assert command['startedUTC']>gate['UTC'];pins(W,command['runtimeInputs']);assert p('.stderr').read_bytes()==b''
  rows.append({'arm':arm,'name':n,'reverse':rev,**{k:a[k] for k in ['shadeUpdates','primary_ground_reflection_hits','transportRays','transportNodeVisits','transportTriangleTests']},**{'world'+k:fw[k] for k in ['queries','misses','blockedCharacter','visibilityNodeVisits','visibilityTriangleTests','workUsed']},'producerUsedTotal':sum(rw['producerUsed']),'aaUsed':aa['observedTotal'],'aaReserved':aa['reservedTotal']})
 for (v,c) in cp:
  for e in ['.u16le','.f32le','.targets.u8','.hdr.f64le']:eq(out/('native-'+v+'-'+c+e),out/('native-'+v+'-'+c+'-reverse'+e))
 arm_details[arm]={'frames':len(m['frames']),'retainedManifestFiles':sum(len(f['files']) for f in m['frames']),'completionSHA256':H(mp)}
# Recompute named memory sums; immutable prerequisite source review establishes liveness/exclusions.
mem=J(R/'ADAPTER_MEMORY.json')
for name,p in mem['phases'].items():
 total=sum(p['heap'].values())+p['mainStack']+p['namedChildStack'] if name=='render' else sum(v for k,v in p.items() if k!='sumExcludingRO')
 assert total==p['sumExcludingRO']
for name,p in mem['diagnosticPhases'].items():assert p['sumExcludingRO']==p['productPhaseExcludingRO']+p['observerHeap']+p['observerGlobalControl']
assert mem['namedROSum']==sum(mem['namedReadOnlyArrays'].values())==1662416
assert max(p['sumExcludingRO'] for p in mem['phases'].values())+mem['namedROSum']==mem['maximumNamedPeakIncludingRO']==2290608
assert max(p['sumExcludingRO'] for p in mem['diagnosticPhases'].values())+mem['namedROSum']==mem['diagnosticMaximumNamedIncludingRO']==3068232
assert mem['phases']['render']['sumExcludingRO']==628192 and mem['diagnosticPhases']['render']['sumExcludingRO']==1405816
for folder,file in [('build-adapter','NAMED_STACK.json'),('build-product','PRODUCT_NAMED_STACK.json')]:
 s=J(R/file);pins(R/folder,s['stackFiles'])
 for chain in s['chains'].values():assert sum(f['bytes'] for f in chain['frames'])==chain['bytes']
 assert s['backgroundPeak']==4048<=s['backgroundCap']==4096 and s['rendererPeak']==4976<=s['rendererCap']==8192 and s['mainStack']==83616
nm=subprocess.run(['nm',str(R/'build-product/native-render')],check=True,capture_output=True,text=True).stdout
assert 'row_hdr_' not in nm
# Same deterministic image bytes and original formal input/reference pins allow score reuse without rescore.
A=F/'analysis-code/analysis-001';pin(A/'COMPLETED.json','d0f74a1e16b756d8494f4a801da10d42e689c55b5a9828e454e3e338a7820f03')
for k,v in J(A/'COMPLETED.json')['files'].items():pin(A/k,v['sha256']);assert (A/k).stat().st_size==v['bytes']
formal=J(A/'READ_INPUT_PINS.json')['files'];pins(W,formal)
# Check the implementer's final output index and cost aggregation from individual retained reports.
if len(arms)==2:
 pin(R/'OUTPUT_FREEZE.json','822b2cde3d5e186c591de772282bdc168af9b78e9062661fbc5bd6f8356dbdfd')
 of=J(R/'OUTPUT_FREEZE.json');assert of['status']=='ALL40_EXACT_COMPLETE' and of['frames']==40 and of['fileCount']==len(of['files'])==480
 assert of['sourceFreezeSHA256']==FIXED['SOURCE_FREEZE.json'] and of['binarySHA256']==builds['build-adapter']['binarySHA256'];pins(R,of['files'])
 expected_files={}
 for arm in arms:
  for frame in J(R/('actual-'+arm+'-001')/'COMPLETED.json')['frames']:
   expected_files.update({f"actual-{arm}-001/{frame['name']}{e}":h for e,h in frame['files'].items()})
 assert of['files']==expected_files
 cost=J(R/'ACTUAL_OPERATION_MEMORY_COST.json');assert cost['originalTransportCaps']==[20000000,800000000,300000000] and cost['worldSemanticWorkSeparate'] and not cost['admissionToLegacy8MCombinedContract']
 pin(R/'ADAPTER_MEMORY.json',cost['memoryLedgerSHA256'])
 for arm,cc in cost['arms'].items():
  out=R/('actual-'+arm+'-001');m=J(out/'COMPLETED.json');assert cc['frames']==20 and len(cc['rows'])==20
  mrows={f['name']:f for f in m['frames']};assert {q['case'] for q in cc['rows']}==set(mrows)
  for q in cc['rows']:
   name=q['case'];a=J(out/(name+'.json'));fw=J(out/(name+'.floor-world.json'));rw=J(out/(name+'.row.json'))
   expect={'case':name,'hostRenderNsDescriptive':a['hostRenderNsFirstFrame'],'runnerElapsedSeconds':mrows[name]['elapsedSecondsDescriptiveOnly'],'transportRays':a['transportRays'],'transportNodes':a['transportNodeVisits'],'transportTriangles':a['transportTriangleTests'],'worldRays':fw['visibilityRays'],'worldNodes':fw['visibilityNodeVisits'],'worldTriangles':fw['visibilityTriangleTests'],'worldQueries':fw['queries'],'worldMisses':fw['misses'],'worldBlockedCharacter':fw['blockedCharacter'],'worldWork':fw['workUsed'],'worldShaders':fw['shaderCalls'],'worldHits':fw['evaluations'],'producerSemanticUnits':sum(rw['producerUsed'])}
   assert q==expect
  assert cc['hostRenderNsSumDescriptive']==sum(q['hostRenderNsDescriptive'] for q in cc['rows'])
  assert cc['runnerElapsedSecondsSumDescriptive']==sum(q['runnerElapsedSeconds'] for q in cc['rows'])
  assert cc['maxima']=={k:max(q[k] for q in cc['rows']) for k in cc['rows'][0] if k not in ['case','hostRenderNsDescriptive','runnerElapsedSeconds']}
# Rehash immutable files again at end rather than relying on the initial checks.
pins(R,FIXED);pins(R,freeze['files']);pins(W,manifestpins)
summary={'status':'PASS_RETAINED_ACTUAL40' if len(arms)==2 else 'PASS_RETAINED_OFF20_ONLY','completedUTC':datetime.datetime.now(datetime.timezone.utc).isoformat(),'scope':'Read-only independently authored validation; no renderer/compiler/scorer invoked. Aggregate-only output. New indexed floor-world integration only.','arms':arm_details,'sourceFreezeSHA256':FIXED['SOURCE_FREEZE.json'],'sourceFiles':len(freeze['files']),'baselinePins':len(J(R/'BASELINE_PINS.json')['pins']),'formalReadInputPins':len(formal),'formalCompletionSHA256':H(A/'COMPLETED.json'),'gateSHA256':gatehash,'checks':dict(counts),'uniqueFilesHashed':len(seen),'allRetainedManifestHashes':True,'allHDRAndAgxExactlyCompletedFloorWorld':True,'allOwnOrderIndexedDepthMaskSnapshotExact':True,'offIndexed565Exact':True,'allForwardReverseHDRAgxDepthMaskExact':True,'oldReportValuesExactWithDocumentedDeltas':True,'ownOrderAdditiveTraversalIdentitiesExact':True,'worldBudgetQueriesPartitionsExact':True,'newSpanPairs':24,'unchangedTransportCaps':[20000000,800000000,300000000],'memory':{'productRenderExcludingRO':628192,'diagnosticRenderExcludingRO':1405816,'productMaximumIncludingNamedRO':2290608,'diagnosticMaximumIncludingNamedRO':3068232,'observerHeap':777600,'observerControl':24,'backgroundStack':4048,'rendererStack':4976,'mainStack':83616,'productBinaryContainsNoObserverSymbols':True},'metricReuse':'Exact image bytes and 952 unchanged formal input pins. Existing formal and independently verified limited scores remain applicable; no fresh scorer run.','limitations':['Forty actual runs use the diagnostic binary. Product observer-free parity is synthetic evidence from pre-render review, not forty separately rerendered product frames.','Snapshots are compared with the corresponding indexed order; no forward/reverse snapshot identity claim.','Named memory excludes allocator/runtime/libc/libm/executable/unnamed read-only costs and unrelated caller state. No device fit, CPU instruction bound, speedup, or legacy combined8M claim.','No comprehensive security/ownership review; stopped context/paged operations were not read, tested or resumed.'],'rows':rows}
if len(arms)==2:
 summary['outputFreezeSHA256']=H(R/'OUTPUT_FREEZE.json');summary['operationCostSHA256']=H(R/'ACTUAL_OPERATION_MEMORY_COST.json');summary['finalOutputIndexAndCostAggregationExact']=True
if rows:
 summary['maxima']={k:max(r[k] for r in rows) for k in rows[0] if k not in ['arm','name','reverse']}
summary['checks']=dict(counts);summary['uniqueFilesHashed']=len(seen)
print(json.dumps(summary,indent=2))
