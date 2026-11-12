"""Strict new-arm admission; character shape provenance stays original A2."""
import math
CORE_KEYS=['bindingValidation','targetMaskCopyBytes','targetMaskFingerprintBytes','nonTargetCharacterStateRead','bandHDRClear','sampleEnumerationAndMaskTest','finalOutputScanAndMaskTest','queryPreparation','localCompositionResultZeroWords','compositionCallbackDispatch','returnedRGBValidation','decisionPrecedenceValidation','compositionEventCounters','selectedReplacementCopy','selectedOriginalMissHDRAccumulation','selectedSampleHDRAccumulation','nonTargetReplacementEncodeWrite','allOutputEncodeWrite','coreGuardDispatches','descriptorFingerprintBytes']
FEES={'construct':8192,'frameAdmission':0,'slotAdmission':512,'cameraRay':256,'floorTriangles':768,'clipDepthOrder':256,'resultCounterCommit':256,'diskAdmission':768,'diskReceiver':384,'diskKernel':7680,'diskSampleControl':3072,'shadowBridgeAdmission':24576,'diskReduction':128,'floorComposition':128,'worldMiss':64}
def u(x): assert type(x)is int and 0<=x<2**64;return x
def eq_u(a,b):assert u(a)==b

def validate(report,metadata,fixed,arm,core_design,input_sha):
 assert arm in ['on','background'];f=report;assert f['version']=='host-camera-floor-composition-v1' and f['complete'] is True and f['arm']==arm
 for k,x in [('caseIndex',fixed['caseIndex']),('viewIndex',fixed['viewIndex'])]:eq_u(f[k],x)
 assert type(f['reverse'])is bool and f['reverse']==fixed['reverse']
 assert f['snapshotFingerprint']==fixed['snapshotFNV'] and f['inputJSONSHA256']==input_sha
 assert f['oldWork8MCompatible'] is False and f['oldDirect1MCompatible'] is False and f['sourceGeometryUnchanged'] is True and f['characterDepthRetained'] is (arm=='on') and f['wholeFrameBufferAtomic'] is False
 u(f['backgroundBuildNs'])
 Q=fixed['runtimeSlots'];F=Q if arm=='background' else fixed['combinedEmptySlots']+fixed['expectedFinalFloorOverrides'];T=2385 if fixed['view']=='front' else 2391
 eq_u(f['observerEvents'],Q)
 for k,v in [('backgroundRayLimit',2000000),('backgroundNodeLimit',200000000),('backgroundTriangleLimit',100000000),('backgroundOwnedLimit',16384),('backgroundAdditionalNamedStackLimit',4096),('backgroundSceneBytes',976),('backgroundContextBytes',376),('backgroundWorkBytes',296),('privateResultBytes',208),('coreResultBytes',40),('coreQueryBytes',24),('coreReportBytes',400),('maskConstructionBytesReserved',4050),('inputConstructionBytesReserved',752),('backgroundOwnedBytes',1712),('backgroundNewOwnedConservativePeakBytes',7178)]:eq_u(f[k],v)
 assert 0<u(f['backgroundOwnedBytes'])<=u(f['backgroundNewOwnedConservativePeakBytes'])<=16384
 for used,cap in [('backgroundQueries','backgroundRayLimit'),('backgroundNodeVisits','backgroundNodeLimit'),('backgroundTriangleTests','backgroundTriangleLimit')]:assert u(f[used])<=u(f[cap])
 # Queries are independent of shadow outcome. Source/camera/count pins bind the expected frame.
 if arm=='background':expected_queries=fixed['backgroundOnlyPositiveQueries']
 else:
  assert fixed['extraFinalQueriesAllCasesVerified'] is True
  expected_queries=fixed['combinedEmptyPositiveQueries']+fixed['extraFinalQueries']
 eq_u(f['backgroundQueries'],expected_queries)
 g=f['generation'];assert set(g)=={'geometry','pose','visibilityLight','camera','material','emission','illumination'}
 for k,v in [('geometry',metadata['visibilityGeneration'][0]),('pose',metadata['visibilityGeneration'][1]),('visibilityLight',metadata['visibilityGeneration'][2]),('camera',fixed['viewIndex']+1),('material',2 if fixed['caseIndex']==4 else 1),('emission',1),('illumination',fixed['caseIndex']+1)]:eq_u(g[k],v)
 r=f['resolver'];eq_u(r['slotLimit'],Q);eq_u(r['shadeLimit'],F);eq_u(r['slots'],Q);eq_u(r['floorEvaluations'],F);eq_u(r['worldMisses'],0);eq_u(r['limit'],8192+593920+2048*Q+36736*F);assert u(r['limit'])<=1540298112
 assert set(r['categories'])==set(FEES)
 for k,fee in FEES.items():
  z=r['categories'][k];assert set(z)=={'limit','used'}
  if k=='construct':limit=used=8192
  elif k=='frameAdmission':limit=593920;used=4096+8*(metadata['snapshotBytes']+7930)
  elif k=='worldMiss':limit=64*F;used=0
  elif k in ['slotAdmission','cameraRay','floorTriangles','clipDepthOrder','resultCounterCommit']:limit=used=fee*Q
  else:limit=used=fee*F
  eq_u(z['limit'],limit);eq_u(z['used'],used)
 eq_u(r['used'],sum(z['used'] for z in r['categories'].values()));assert r['used']<=r['limit']
 c=f['classification'];assert set(c)=={'slots','keep','floor','world','parallel','negativeT','outside','clip','positiveQueries','blockedQueries'}
 for k,v in [('slots',Q),('keep',Q-F),('floor',F),('world',0),('parallel',0),('negativeT',0),('outside',0),('clip',0),('positiveQueries',expected_queries)]:eq_u(c[k],v)
 assert u(c['blockedQueries'])<=expected_queries
 core=f['core'];assert core['complete'] is True and core['descriptorFingerprintExecuted'] is False
 for k,v in [('hardLimit',1680000),('queries',Q),('centers',32400-T),('quarters',4*T),('kept',Q-F),('floor',F),('world',0),('occludedCharacter',fixed['expectedFinalFloorOverrides'] if arm=='on' else 0),('failedCategory',20)]:eq_u(core[k],v)
 declared=core_design['views'][fixed['view']]['combinedCoreReservedLedger' if arm=='on' else 'backgroundOnlyCoreReservedLedger'];assert set(core['categories'])==set(CORE_KEYS)==set(declared)
 for k in CORE_KEYS:
  z=core['categories'][k];assert set(z)=={'reserved','observed'};eq_u(z['reserved'],declared[k]);eq_u(z['observed'],0 if k=='descriptorFingerprintBytes' else declared[k]-1 if k=='coreGuardDispatches' else declared[k])
 eq_u(core['categories']['descriptorFingerprintBytes']['observed'],0)
 eq_u(core['reservedTotal'],sum(z['reserved'] for z in core['categories'].values()));eq_u(core['observedTotal'],sum(z['observed'] for z in core['categories'].values()));assert core['observedTotal']<=core['reservedTotal']<=1680000
 # Never migrate extra camera work into old character budgets.
 for used,limit,expected in [('visibilityRays','visibilityRayLimit',1000000),('visibilityNodeVisits','visibilityNodeLimit',100000000),('visibilityTriangleTests','visibilityTriangleLimit',50000000),('transportRays','transportRayLimit',20000000),('transportNodeVisits','transportNodeLimit',800000000),('transportTriangleTests','transportTriangleLimit',300000000)]:eq_u(metadata[limit],expected);assert u(metadata[used])<=expected
