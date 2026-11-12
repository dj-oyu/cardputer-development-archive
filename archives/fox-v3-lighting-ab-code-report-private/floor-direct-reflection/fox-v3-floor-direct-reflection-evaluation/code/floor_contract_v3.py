"""Strict independent adapter admission; formal score mathematics untouched."""
import math
COSTS=[64,64,128,768,288,6144,4608,128,64,64]
NAMES=['shaderDescriptor','shaderResultMerge','floorEligibilityNormal','diskAdmission','diskReceiverSetup','diskSampleKernels','diskSampleControlCallback','diskReductionOutput','floorAccumulationCounters','floorLedgerGuards']
def uint(x):assert type(x) is int and 0<=x<2**64
def validate(f,m,bound,rho,arm):
 assert f['version']=='host-floor-direct-v1' and f['complete'] is True
 enabled=arm!='off';assert f['enabled'] is enabled and f['zeroRhoControl'] is (arm=='zero')
 assert f['separateHostWorkContract'] is True and f['old8MCombinedAdmission'] is False
 for k in ['limitTotal','usedTotal','shaderLimit','floorHitLimit','shaderCalls','floorHits','evaluations','zeroRhoHits','tangentHits','kernelReservations','floorQueries','caseIndex','workBytes','contextBytes','resultBytes','groundDescriptorBytes']:uint(f[k])
 assert (f['workBytes'],f['contextBytes'],f['resultBytes'],f['groundDescriptorBytes'])==(232,576,256,72)
 for values in [f['rho'],m['floorRho']]:
  assert type(values) is list and len(values)==3 and all(type(x) in (int,float) and math.isfinite(x) and 0<=x<=1 for x in values)
 assert m['materialGeneration']==((3 if bound['case']=='albedo' else 2) if enabled else 1)
 assert m['emissionGeneration']==(2 if enabled else 1)
 assert f['rho']==rho and m['floorRho']==rho and all(type(x) in (int,float) and math.isfinite(x) and 0<=x<=1 for x in rho)
 for k in ['shadeUpdates','primary_ground_hits','primary_ground_emission_hits','primary_ground_reflection_hits','primary_ground_direct_queries','primary_rays','secondary_world_rays','secondary_direct_queries','groundMode','floorCase','snapshotBytes','snapshotCapacity','transportSceneBytes','transportSceneLimit','materialGeneration','emissionGeneration']:uint(m[k])
 assert m['floorReflectionEnabled'] is enabled and m['floorZeroControl'] is (arm=='zero')
 assert m['shadeUpdates']==bound['shadeUpdates'] and m['primary_ground_hits']==bound['primary_ground_hits']
 assert f['caseIndex']==m['floorCase']==['baseline','direction','intensity','ambient','albedo'].index(bound['case'])
 assert m['visibilitySnapshotFingerprint']==bound['visibilitySnapshotFingerprint']
 assert m['groundMode']==(3 if enabled else 2)
 assert m['transportRays']==m['primary_rays']+m['secondary_world_rays']+m['secondary_direct_queries']+m['primary_ground_direct_queries']
 assert m['primary_ground_direct_queries']==f['floorQueries']<=48*f['evaluations']
 assert m['primary_ground_reflection_hits']==f['evaluations'] and f['kernelReservations']==48*f['evaluations']
 assert m['primary_ground_emission_hits']==m['primary_ground_hits']
 if enabled:
  assert f['shaderLimit']==f['shaderCalls']==bound['shadeUpdates']
  assert f['floorHitLimit']==f['floorHits']==bound['primary_ground_hits']
  assert f['evaluations']+f['zeroRhoHits']+f['tangentHits']==f['floorHits']
  assert f['limitTotal']==128*f['shaderLimit']+12192*f['floorHitLimit']<=875970912
 else:assert all(f[k]==0 for k in ['limitTotal','usedTotal','shaderLimit','floorHitLimit','shaderCalls','floorHits','evaluations','zeroRhoHits','tangentHits','kernelReservations','floorQueries'])
 if arm=='zero':assert f['zeroRhoHits']==f['floorHits'] and f['evaluations']==f['floorQueries']==0
 factors=[f['shaderCalls'],f['shaderCalls'],f['floorHits'],f['evaluations'],f['evaluations'],f['evaluations'],f['evaluations'],f['evaluations'],f['evaluations'],f['floorHits']]
 upper=[f['shaderLimit'],f['shaderLimit'],f['floorHitLimit'],f['floorHitLimit'],f['floorHitLimit'],f['floorHitLimit'],f['floorHitLimit'],f['floorHitLimit'],f['floorHitLimit'],f['floorHitLimit']]
 assert set(f['categories'])==set(NAMES)
 for n,c,x,u in zip(NAMES,COSTS,factors,upper):
  v=f['categories'][n];assert set(v)=={'limit','used'};uint(v['used']);uint(v['limit']);assert v['used']==c*x and v['limit']==c*u
 assert f['usedTotal']==sum(x['used'] for x in f['categories'].values())<=f['limitTotal']==sum(x['limit'] for x in f['categories'].values())
 for prefix,caps in [('visibility',(1000000,100000000,50000000)),('transport',(20000000,800000000,300000000))]:
  for used,limit,cap in zip(['Rays','NodeVisits','TriangleTests'],['RayLimit','NodeLimit','TriangleLimit'],caps):uint(m[prefix+used]);uint(m[prefix+limit]);assert m[prefix+used]<=m[prefix+limit]==cap
 assert m['snapshotBytes']==64208 and m['snapshotCapacity']==65536 and m['transportSceneBytes']==100808 and m['transportSceneLimit']==262144
