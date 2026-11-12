"""Strict independent report admission, never relaxed numeric-type equality."""
KEYS=['legacyCenterReservation','centerIDInitialization','centerIDUpdateUpper','maskBytesClear','maskNeighborComparisons','bandHDRClear','sampleDepthWinnerClear','recordVisits','faceSetupAndVertexDecodeStages','bboxVisitAndMaskTest','targetEdgeDepthWinnerStages','finalSampleScan','finalHitShadingAndInterpolationUpper','finalPixelAverageEncodeWrite','sourceIdentityBindingValidationUpper','identityKeyClearBytes','identityFingerprintBytes','snapshotBindingFingerprintBytes','admissionAndPhaseControl','counterGuardDispatches','finalOutputPixelScan']
def validate(a,reserved,targets,identity):
 assert a['version']=='host-final-visible-boundary-aa-v2' and a['complete'] is True
 fields=['reservedTotal','observedTotal','targets','coveredTargets','nohitTargets','centerShades','sampleShades','workspaceBytes','newStackReserve','retainedOutputBytes','identityBytes','observerSamples','observerHits','failedCategory']
 for k in fields:assert type(a[k]) is int and a[k]>=0,k
 assert len(reserved)==len(KEYS) and all(type(v) is int and v>=0 for v in reserved), 'expected reservations'
 assert set(a['categories'])==set(KEYS)
 assert a['failedCategory']==len(KEYS), 'success failure-category sentinel'
 for k,expected in zip(KEYS,reserved):
  z=a['categories'][k];assert set(z)=={'reserved','observed'}
  assert type(z['reserved']) is int and type(z['observed']) is int and 0<=z['observed']<=z['reserved']==expected
 assert a['reservedTotal']==sum(reserved)<=8000000 and a['observedTotal']==sum(z['observed'] for z in a['categories'].values())<=a['reservedTotal']
 assert a['targets']==targets and a['coveredTargets']+a['nohitTargets']==targets
 assert a['workspaceBytes']==137312 and a['newStackReserve']==8192, 'frozen workspace and stack accounting'
 assert a['workspaceBytes']+a['newStackReserve']<=147456 and a['retainedOutputBytes']==194400 and a['identityBytes']==7930 and a['identityFNV']==identity
 assert a['observerSamples']==4*targets and a['observerHits']==a['sampleShades']
 for k in ['sampleHits','sampleNohits']:assert len(a[k])==4 and all(type(v)is int and v>=0 for v in a[k])
 assert sum(a['sampleHits'])==a['sampleShades'] and all(h+n==targets for h,n in zip(a['sampleHits'],a['sampleNohits']))
 exact_reserved=['legacyCenterReservation','centerIDInitialization','maskBytesClear','maskNeighborComparisons','bandHDRClear','sampleDepthWinnerClear','recordVisits','faceSetupAndVertexDecodeStages','bboxVisitAndMaskTest','targetEdgeDepthWinnerStages','finalSampleScan','finalOutputPixelScan']
 for k in exact_reserved:assert a['categories'][k]['observed']==a['categories'][k]['reserved'],k
 for k,n in [('centerIDUpdateUpper',a['centerShades']),('finalHitShadingAndInterpolationUpper',64*a['sampleShades']),('finalPixelAverageEncodeWrite',8*targets),('identityKeyClearBytes',9920),('identityFingerprintBytes',7930),('snapshotBindingFingerprintBytes',64208),('sourceIdentityBindingValidationUpper',29463)]:assert a['categories'][k]['observed']==n,k
 assert a['categories']['counterGuardDispatches']['observed']>0
 return True
