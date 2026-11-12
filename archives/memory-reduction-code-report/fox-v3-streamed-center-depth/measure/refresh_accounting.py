"""Named host phases, including both depth/HDR diagnostic storage and stack."""
from pathlib import Path
import copy,json,hashlib,subprocess
R=Path(__file__).resolve().parents[1];B=R.parent/'fox-v3-cached-profile-renderer'
load=lambda p:json.loads(p.read_text());sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
b=load(B/'MEMORY_LEDGER.json');x=copy.deepcopy(b);s=load(R/'PRODUCT_NAMED_STACK.json');o=load(R/'NAMED_STACK.json');delta=s['mainStack']-b['stack']['main']
x.update(status='STREAMED_DEPTH_PREACTUAL_NAMED_HOST_LEDGER',actualFrames=0,baseLedgerSHA256=sha(B/'MEMORY_LEDGER.json'),baselineNamedPeak=b['namedPeak'])
for k,p in x['phases'].items():
 p['mainStack']+=delta;p['sumExcludingRO']+=delta
 if k=='render':
  assert p['heap'].pop('privateDepth')==129600;p['heap']['centerDepthStrip']=7680;p['heap']['pendingCenterDepth']=960
  p['sumExcludingRO']+=8640-129600+s['rendererPeak']-p['namedChildStack'];p['namedChildStack']=s['rendererPeak']
x['namedPeak']=max(p['sumExcludingRO'] for p in x['phases'].values());x['namedPeakDelta']=x['namedPeak']-x['baselineNamedPeak']
x['stack'].update(main=s['mainStack'],baselineMain=b['stack']['main'],mainDelta=delta,rendererPeak=s['rendererPeak'],backgroundPeak=s['backgroundPeak'],backgroundMargin=4096-s['backgroundPeak'])
x['diagnosticStack']=o['mainStack'];x['namedPeakIncludingNamedRO']=x['namedPeak']+x['profileRO']['newNamedROSum']
x['priorLargestNamedAllocation']=b['largestNamedAllocation']
x['centerDepth']={'baselineBytes':129600,'productStripBytes':7680,'productPendingBytes':960,'productTotal':8640,'grossRenderSaving':120960,'descriptorBytes':48,'reportBytes':24,'descriptorAndReportIncludedInMainStack':True,'productAllocationRequests':[7680,960],'diagnosticAdditionalRequests':[129600],'pendingCopyFloats':3840,'pendingCopyBytes':15360,'diagnosticCopyFloats':32400,'diagnosticCopyBytes':129600,'quarterWinnerDepthIndependent':True,'legacyFullDepthAPIsUnchanged':True,'allocationPhase':'after model cold/owner dispose, immediately before renderer; same lifetime as privateRGB/AA','lastPendingRead':'center pass before quarter winner initialization','productionFullDepthRetained':False}
x['diagnosticPhases']={}
for mode,cap in [('withDepthCapture',129600),('withoutDepthCapture',0)]:
 phases={}
 for k,p in x['phases'].items():
  main_delta=o['mainStack']-s['mainStack'];child_delta=(o['rendererPeak']-s['rendererPeak']) if k=='render' else 0
  phases[k]={'productPhase':p['sumExcludingRO'],'mainStackDelta':main_delta,'childStackDelta':child_delta,'HDRGlobalControl':24,'HDRHeap':777600 if k=='render' else 0,'captureHeap':cap if k=='render' else 0}
  phases[k]['sumExcludingRO']=sum(phases[k].values())
 x['diagnosticPhases'][mode]=phases
x['diagnosticMaximumNamedExcludingRO']={m:max(p['sumExcludingRO'] for p in ps.values()) for m,ps in x['diagnosticPhases'].items()}
x['accountingLimits']='Requested payload plus conservative compiler named frames. All stream descriptor/report locals included in measured caller frames, not double charged. Product main includes unchanged65536-byte snapshot; cache3224 allocated late remains charged once. Diagnostic full depth129600, HDR777600 and control24 separately charged. No allocator overhead, fragmentation, libc/libm, file-export stacks, unrelated callers or target placement proof; no whole-process/device-fit claim.'
x['productVsDiagnosticNote']='Fixed40 uses HDR+full-depth diagnostics; two no-depth-capture canaries retain HDR diagnostics. Neither diagnostic RSS represents product memory. Product no-HDR binary separately compiled. Sidecar export4192-byte named helper occurs after render/cache release, below named render child peak; libc/stdio internals remain excluded.'
(R/'MEMORY_LEDGER.json').write_text(json.dumps(x,indent=2)+'\n')
g=copy.deepcopy(load(B/'GUARD_ACCOUNTING.json'));g['rendererBudgets']={'coreAdmissionProduct':170,'coreAdmissionDiagnostic':189,'adapterProductOff':351,'adapterProductOn':378,'adapterDiagnosticOff':378,'adapterDiagnosticOn':406,'totalAdmissionProductOff':521,'totalAdmissionProductOn':548,'totalAdmissionDiagnosticOff':567,'totalAdmissionDiagnosticOn':595,'admissionCap':1024,'guardCap':100000,'adapterGuardCharge':1024,'producerCapIncludingDepthCopy':637599}
g['spanAccounting']={'baselineAdapterLive':29,'streamProductLive':27,'streamDiagnosticLive':28,'coreSlots':14,'coreProductLive':13,'coreDiagnosticLive':14,'optionalCaptureIsNULLAndZeroTogether':True,'originalDescriptorFrozenBeforeCallbacks':True,'cacheAndStaticBlobAdmission':'adapter only, existing private-core trust boundary','HDRObserverStorage':'existing unforgeable private malloc allocation, no setter; independently live mallocs cannot overlap','worldPairsPerSpan':True}
g['streamCopy']={'units':'float elements; each is4bytes on this validated host','pendingCopyCap':3840,'captureCopyCap':32400,'pendingCopies':16,'captureCopies':17,'extraRHGuardsProduct':16,'extraRHGuardsDiagnostic':33,'oldRHCopyUnchanged':True,'combinedTotal':'sum(RH used)+pending_copy_floats+capture_copy_floats <=637599 including adapter charges','capsRaised':False}
(R/'GUARD_ACCOUNTING.json').write_text(json.dumps(g,indent=2)+'\n')
sizes={d:{'sizeOutput':subprocess.check_output(['size',str(R/d/'native-render')],text=True),'baselineSizeOutput':subprocess.check_output(['size',str(B/d/'native-render')],text=True),'binarySHA256':sha(R/d/'native-render')} for d in ['build-product','build-adapter']};(R/'HOST_BINARY_SIZE.json').write_text(json.dumps(sizes,indent=2)+'\n')
print(json.dumps({'namedPeak':x['namedPeak'],'render':x['phases']['render']['sumExcludingRO'],'delta':x['namedPeakDelta'],'diagnostics':x['diagnosticMaximumNamedExcludingRO']}))
