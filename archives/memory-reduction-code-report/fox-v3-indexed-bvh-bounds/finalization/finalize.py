"""Finalize only after independent retained42 audit; does not launch renders."""
from pathlib import Path
import json,hashlib
R=Path(__file__).resolve().parents[1];sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();read=lambda p:json.loads(p.read_text())
f=read(R/'SOURCE_FREEZE.json');assert all(sha(R/p)==h for p,h in f['files'].items())
a=read(R/'comparison/FIXED42_RESULT.json');v=read(R/'review/FINAL_RETAINED_REVIEW.json');m=read(R/'MEMORY_LEDGER.json')
assert a['status']=='PASS_RETAINED_FIXED42_COMPARISON' and v['status']=='PASS_INDEPENDENT_RETAINED_REVIEW'
assert a['counts']=={'diagnosticFrames':40,'noDepthCaptureHDRCanaries':2,'raw':208,'reports':378,'sidecars':0,'forwardReverse':80}
assert v['verifiedFrames']==42 and v['rawComparisons']==208 and v['reportComparisons']==378 and v['forwardReverseComparisons']==80
assert v['sourceFreezeSHA256']==sha(R/'SOURCE_FREEZE.json')
rows=v['frames'];maxwork=max(x['producerWorkIncludingDepth'] for x in rows)
x={'status':'COMPLETE_FIXED42_INDEPENDENT_PASS','actualFrames':42,'diagnosticFullDepthFrames':40,'noDepthCaptureHDRCanaries':2,'pureProductNoHDRActualFrames':0,'counts':a['counts'],'sourceFreezeSHA256':sha(R/'SOURCE_FREEZE.json'),'frozenFilesVerified':len(f['files']),'independentFinalReviewSHA256':sha(R/'review/FINAL_RETAINED_REVIEW.json'),'retainedComparisonSHA256':sha(R/'comparison/FIXED42_RESULT.json'),'executionGateSHA256':sha(R/'PHYSICAL_EXECUTION_GATE.json'),'exactOutputMismatches':0,'rayNodeTriangleAndWorkCounterChanges':0,'permittedNonTimingReportDifference':{'field':'visibilitySceneBytes','baseline':106104,'candidate':69276,'formula':'baseline minus36*node count'},'callerGeometryTemporaryBytesUnchanged':46800,'namedCompilerAccounting':{'baselineLifecyclePeak':373552,'candidateLifecyclePeak':336724,'saving':36828,'phaseSums':{k:p['sumExcludingRO'] for k,p in m['phases'].items()},'largestAllocation':72512,'largestAllocationOwner':'AA workspace; unchanged','constructorStack':2464,'constructorStackDelta':32,'mainStack':83760,'rendererStack':4944,'backgroundStack':4016,'backgroundCap':4096,'persistentVisibilityScene':69276,'constructionRequestedHeap':143688,'conversionRequestedHeap':134748,'internalBuilderPeakExtra':74412,'noWholeProcessOrDeviceFitClaim':True,'method':'Compiled sizeof/requested-allocation and named stack accounting. Not inferred from observed processRSS; allocator/runtime/fragmentation/target placement excluded.'},'work':{'maxProducerIncludingDepth':maxwork,'producerCap':637599,'allCapsUnchanged':True,'constructorAllocations':6,'newConversionWork':'Exact bound-witness scan plus compact record writes; see BOUND_COST.json. Physical counters do not include these instructions.','newTraversalWork':'Owned coordinate gathers through six bound witnesses, no per-query six-double cache.'},'observedDiagnosticProcesses':a['observations'],'predictedVsMeasured':'Named product figures are compiled/accounted; only40 depth+HDR and2 no-depth HDR diagnostics actually executed. No pure production-no-HDR execution, target measurement or speedup claim.','sourceAndQuality':'Original model/reference/coefficients unchanged. Accepted outputs are bit-identical to matching baseline; this does not assert a new perceptual-quality improvement.','publication':'Local generic export prepared/reviewed; no new publication or push performed by this task.','backupPolicy':'Differential code/tests and numeric reports only; raw pixels/depth/HDR, snapshots, geometry/model assets, binaries and command/input records excluded.'}
diag_wall=sum(a['observations'][k]['wallSeconds'] for k in ['diagnostic-off','diagnostic-on'])
x['descriptiveSame40WallComparison']={'candidateSeconds':diag_wall,'historicalBaselineSeconds':a['historicalLifetimeFixed40WallSecondsDescriptiveOnly'],'conditions':'Same40 diagnostic cases, different host runs/times; observational, not causal or a production speed claim.'}
(R/'FINAL_RESULT.json').write_text(json.dumps(x,indent=2)+'\n')
text=f'''# Exact indexed BVH bounds: completed validation

All42 accepted diagnostic executions pass independent retained-output verification:40 full-depth HDR conditions and2 no-depth-capture HDR canaries. All208 raw comparisons,378 strict numeric report comparisons and80 forward/reverse checks pass. Rendering outputs and all ray, node, triangle, shader and work counters remain exact. The only permitted non-timing report change is visibilitySceneBytes106104→69276. Caller geometry temporary reporting remains46800.

Original model, reference and coefficients are unchanged. There is no measured image-quality change and no new quality-improvement claim. Full-depth equality covers40 conditions; only2 no-depth canaries were executed. The pure production binary without HDR was compiled, not executed.

## Compiled and accounted storage

Named lifecycle peak373552→336724 bytes, saving36828. The largest named allocation remains the72512-byte AA workspace. Construction is312580, conversion301544 and render336724. The constructor named stack is2464, up32 from the baseline. Main83760, renderer4944 and background4016/4096 remain unchanged.

These numbers are requested storage and compiler named-stack accounting, not observed process RAM or target-device fit. Retained older scenes, allocator metadata, fragmentation, unnamed library/runtime stacks and target placement are additional or excluded as documented in MEMORY_LEDGER.json. Diagnostic storage remains separately charged.

## Implementation and cost

The original full-double BVH builder remains unchanged. After centroid release, a sixth allocation holds compact nodes; every final bound is matched to exact bits in the scene-owned coordinates before atomic publication. The original tree is freed before publication. Initial per-merge and local-accumulation variants failed signed-zero equivalence and were rejected; original-builder-first conversion resolves those same-flags test failures without normalizing zeros.

Final nodes contain six16-bit coordinate witnesses and four unchanged32-bit topology fields. The conversion scan and traversal indirection add work. Physical ray/work counters do not imply identical CPU instructions. Six allocation-failure sites and exact ownership/rollback are tested. The generic temporary formula covers both construction and conversion, including the one-triangle transition edge case.

## Actual observations and limits

Maximum observed combined producer work{maxwork} remains below unchanged637599. Diagnostic elapsed times and process RSS are recorded separately in FINAL_RESULT.json. The same40 diagnostic cases took{diag_wall:.2f}s versus historical{a['historicalLifetimeFixed40WallSecondsDescriptiveOnly']:.2f}s in separate host runs; this is descriptive and does not establish causation. They neither measure pure-product RAM nor justify a speedup claim. O0/O2, ASan/UBSan, exact canonical bounds, zero-sign permutations, ownership and allocation tests pass. LeakSanitizer was not available in this host's tracing environment; explicit tracked balances finish at zero.

All{len(f['files'])} frozen preactual files remain unchanged. Source freeze: {sha(R/'SOURCE_FREEZE.json')}. Independent final review: {sha(R/'review/FINAL_RETAINED_REVIEW.json')}.

## Delivery scope

The final private backup contains changed code/tests and numeric aggregate/frame reports only. Raw rendered arrays, snapshots, geometry/model assets, binaries, generated LUT data and per-frame command/input records are excluded. The generic10-file public candidate is local and separately reviewed; no new publication or push is claimed. No device, SDK or firmware integration occurred.
'''
(R/'FINAL_REPORT.md').write_text(text)
# Add only settled aggregate/code evidence and the nine explicit numeric report types.
base=read(R/'CHECKPOINT_ALLOWLIST.json');files=set(base['files'])
for p in ['FINAL_RESULT.json','FINAL_REPORT.md','PHYSICAL_EXECUTION_GATE.json','comparison/FIXED42_RESULT.json','review/FINAL_RETAINED_REVIEW.json','review/audit_retained_independent.py','finalization/finalize.py']:files.add(p)
exts=['.json','.aa.json','.floor.json','.background.json','.row.json','.floor-world.json','.hdr-observer.json','.cache.json','.depth-stream.json']
for folder in ['actual-off-001','actual-on-001','production-off-001','production-on-001']:
 manifest=read(R/folder/'COMPLETED.json');files.add(folder+'/COMPLETED.json')
 for entry in manifest['frames']:
  for ext in exts:files.add(folder+'/'+entry['name']+ext)
for p in ['review/LOCAL_PUBLIC_CANDIDATE_CONTENT_REVIEW.json','review/CANARY_OFF_RETAINED_REVIEW.json','review/CANARY_ON_RETAINED_REVIEW.json']:
 if (R/p).exists():files.add(p)
assert not any(p.endswith(('.command.json','.snapshot','.u16le','.f32le','.f64le','.u8','.o','.bin','.png')) for p in files)
y={'status':'FINAL_PRIVATE_CODE_TEST_NUMERIC_REPORTS_ONLY','actualFrames':42,'restoreBase':'Previously archived completed fox-v3-visibility-lifetime-reduction','sourceFreezeSHA256':sha(R/'SOURCE_FREEZE.json'),'finalResultSHA256':sha(R/'FINAL_RESULT.json'),'numericFrameReports':378,'excludes':['images','raw HDR/depth/RGB/target arrays','snapshots','geometry/model assets','generated LUT arrays','binaries','per-frame commands/runtime inputs','active logs','device/SDK files'],'files':{p:sha(R/p) for p in sorted(files)}}
(R/'FINAL_ALLOWLIST.json').write_text(json.dumps(y,indent=2)+'\n');assert all(sha(R/p)==h for p,h in y['files'].items());assert all(sha(R/p)==h for p,h in f['files'].items())
print(json.dumps({'status':x['status'],'finalAllowlistFiles':len(files),'finalResultSHA256':sha(R/'FINAL_RESULT.json'),'finalAllowlistSHA256':sha(R/'FINAL_ALLOWLIST.json'),'sourceFreezeUnchanged':True}))
