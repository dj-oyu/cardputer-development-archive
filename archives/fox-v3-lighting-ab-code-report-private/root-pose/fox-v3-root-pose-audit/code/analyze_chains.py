"""Strict completion/lifecycle/geometry/counter audit; rotated poses have no formal reference score."""
from pathlib import Path
import sys,json,hashlib,struct,math,numpy as np
R=Path(__file__).resolve().parents[1];O=Path(sys.argv[1]).resolve();OUT=Path(sys.argv[2]);assert not OUT.exists();sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();j=json.load(open(O/'COMPLETED.json'));assert j['status']=='ALL4_CHAINS_COMPLETE' and j['mode']=='render' and j['renderedFrameCount']==20;assert {(r['view'],r['reverse']) for r in j['rows']}=={(v,r) for v in ['front','oblique'] for r in [False,True]} and len(j['rows'])==4
labels=['identity','yaw-plus','yaw-minus','return-identity','old-replay'];expected={'initCount':1,'disposeCount':1,'validTargetCallCount':7,'evaluateCallCount':7,'renderedFrames':5,'peakOwnedSets':2,'ownedSetLimit':2,'staleEpochBeforeEvaluateChecks':6,'staleEpochAfterEvaluateChecks':6,'disposedViewRejections':1,'injectedCurrentBuildFailures':1,'invalidBatchAtomicityChecks':1,'ownedBuilds':7,'ownedReleases':8,'idempotentReleaseNoops':2,'provenanceMismatchRejections':6,'lowLevelDistinctSnapshotRejections':4,'lowLevelStaleGenerationRejections':6};rows=[];f32=lambda x:struct.unpack('<f',struct.pack('<f',x))[0]
for row in j['rows']:
 for name,h in row['files'].items():assert sha(O/name)==h
 p=O/row['prefix'];l=row['lifecycle'];assert json.load(open(str(p)+'.chain.json'))==l
 for k,v in expected.items():assert type(l[k]) is int and l[k]==v,(row['view'],k,l[k])
 for k in ['admissionComplete','chainComplete','singlePersistentInstance','preflightUsesSameInstance','noStaleBorrowReads','initialRetainedAcrossDisposal','initialReplayExact','identityReturnArraysExact','identityReturnPixelsExact']:assert l[k] is True
 seq=l['evaluationSequence'];assert [s['pose'] for s in seq]==labels[:4]+labels[1:4] and [s['phase'] for s in seq]==['admission']*4+['render']*3
 assert [s['epochAfterEvaluate'] for s in seq]==list(range(2,9));assert [s['evalCalls'] for s in seq]==list(range(1,8));assert [s['targetChanged'] for s in seq]==list(range(7))
 assert l['peakOwnedUsedBytes']==1209632<=l['peakOwnedReservedBytes']==l['ownedReservedLimitBytes']==1703936
 metas={label:json.load(open(str(p)+'.'+label+'.json')) for label in labels};initial=np.fromfile(str(p)+'.identity.u16le','<u2');summaries=[]
 for label,m in metas.items():
  assert m['rendered'] is True and m['aaEnabled'] is False and m['sourceMaterialConstantsUnchanged'] is True
  assert m['camera']==metas['identity']['camera'] and m['light']==metas['identity']['light'] and m['groundLe']==metas['identity']['groundLe'] and m['groundInputFingerprint']==metas['identity']['groundInputFingerprint']
  assert Path(str(p)+'.'+label+'.snapshot').read_bytes()[:416]==Path(str(p)+'.identity.snapshot').read_bytes()[:416]
  assert m['yawRadiansFloat']==(f32(math.pi/12) if label=='yaw-plus' else f32(-math.pi/12) if label=='yaw-minus' else 0)
  assert m['snapshotBytes']==64208 and m['snapshotCapacity']==65536 and m['normalPairMode5Records']==54 and m['normalPairMode4Records']==0 and m['allWorldNormalPairVertices']==1163 and m['allWorldNonPairVertices']==0
  for group,caps in [('visibility',(1000000,100000000,50000000)),('transport',(20000000,800000000,300000000))]:
   for (used,limit),cap in zip([('Rays','RayLimit'),('NodeVisits','NodeLimit'),('TriangleTests','TriangleLimit')],caps):assert type(m[group+used]) is int and type(m[group+limit]) is int and 0<=m[group+used]<=m[group+limit]==cap
  assert type(m['work'])is int and 0<=m['work']<=m['workLimit']==8000000
  assert m['disposedBeforeRender'] is (label=='old-replay')
  color=np.fromfile(str(p)+'.'+label+'.u16le','<u2');depth=np.fromfile(str(p)+'.'+label+'.f32le','<f4');assert len(color)==len(depth)==32400 and not np.isnan(depth).any() and not np.isposinf(depth).any()
  summaries.append({'pose':label,'colorChangedVsIdentityPixels':int((color!=initial).sum()),'finiteDepthPixels':int(np.isfinite(depth).sum()),'metadata':m})
 for group,prefix in [('visibility','totalVisibility'),('transport','totalTransport')]:
  for key in ['Rays','NodeVisits','TriangleTests']:assert sum(m[group+key] for m in metas.values())==l[prefix+key]
 assert sum(m['hostRenderNsFirstFrame'] for m in metas.values())==l['totalRenderNs']
 rows.append({'view':row['view'],'reverse':row['reverse'],'lifecycle':{k:v for k,v in l.items() if k!='poses'},'frames':summaries})
OUT.write_text(json.dumps({'status':'ALL4_LIFECYCLE_AND20_FRAME_AUDITS_PASS','scope':'New-pose render diagnostic only. No reference-image fitting or fixed-pose formal score applied; timing is instrumented functional execution, not isolated FPS benchmark.','completionSHA256':sha(O/'COMPLETED.json'),'rows':rows},indent=2)+'\n');print('ALL4_LIFECYCLE_AND20_FRAME_AUDITS_PASS')
