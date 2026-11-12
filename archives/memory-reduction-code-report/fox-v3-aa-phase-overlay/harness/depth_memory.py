from pathlib import Path
import json,copy,hashlib
R=Path(__file__).resolve().parents[1];B=R.parent/'fox-v3-compact-bvh-build';base=json.load(open(B/'MEMORY_LEDGER.json'));stack=json.load(open(R/'PRODUCT_NAMED_STACK.json'));x=copy.deepcopy(base)
x['status']='DEPTH_BANDS_PREREQUISITE_NAMED_HOST_LEDGER';x['actualFrames']=0
oldmain=base['stack']['main'];main=stack['mainStack'];oldpeak=base['stack']['newRendererPeak'];peak=stack['rendererPeak']
x['stack']={'baselineRendererPeak':oldpeak,'rendererPeak':peak,'backgroundPeak':stack['backgroundPeak'],'backgroundCap':4096,'rendererCap':8192,'baselineMain':oldmain,'main':main,'mainDelta':main-oldmain,'namedRendererDelta':peak-oldpeak}
for name,p in x['phases'].items():
 p['mainStack']=main
 if name=='render':p['namedChildStack']=peak;p['sumExcludingRO']=sum(p['heap'].values())+main+peak
 else:
  p.pop('sumExcludingRO');p.pop('liveModelArena');p['modelArenaActual1566']=81356;p['coldModelBytes']=47708;p['sumExcludingRO']=sum(p.values())
x['oldNamedPeakExcludingRO']=max(p['sumExcludingRO'] for p in base['phases'].values());x['newNamedPeakExcludingRO']=max(p['sumExcludingRO'] for p in x['phases'].values());x['trueNamedPeakSaved']=x['oldNamedPeakExcludingRO']-x['newNamedPeakExcludingRO'];x['renderPhaseSaved']=base['phases']['render']['sumExcludingRO']-x['phases']['render']['sumExcludingRO']
x['depthAllocation']={'baselineRequests':[129600],'requests':[30720,30720,30720,30720,6720],'payloadBytes':129600,'largestDepthBlockBefore':129600,'largestDepthBlockAfter':30720,'pointerLengthDescriptorBytes64bit':80,'nativeDescriptorCopies':2,'privateCoreSnapshotBytes':80,'privateBridgeSnapshotBytes':80,'snapshotCountedInMeasuredRendererStack':True,'baselineDepthPointers':2,'sourceControlDelta':144,'controlCountedInMeasuredMainNotAddedTwice':True,'mallocMetadataExcluded':True,'globalLargestNamedAllocationAfter':100808,'globalLargestOwner':'transport scene','ordinaryMallocOwnership':True,'oldVisibleOutputPreservedOnAllocationFailure':True,'candidateScratchRollback':False,'publication':'Private attempt; successful completion marker commits validated artifacts. Multiple file writes are not atomic.'}
x['constructionProof']='BVH builder, model evaluator and all model allocations unchanged from compact baseline. Actual model arena81356 + cold47708 =129064; combined prior ledger label corrected.'
x['fragmentationGoal']='Reduce depth allocation request; no aggregate payload reduction, pooling, target fit, speedup, or cross-compiler stack claim. Host stack reduction is incidental measured same-compiler code generation.'
x['rowAdmission']={'core':210,'adapterOff':378,'adapterOn':406,'totalOff':588,'totalOn':616,'guardCapUnchanged':1024,'producerCapUnchanged':637599}
x['baselineLedgerSHA256']=hashlib.sha256((B/'MEMORY_LEDGER.json').read_bytes()).hexdigest();(R/'MEMORY_LEDGER.json').write_text(json.dumps(x,indent=2)+'\n');print(x['newNamedPeakExcludingRO'],x['trueNamedPeakSaved'])
