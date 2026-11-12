"""Synthetic admission positives first; not physical completion evidence."""
from pathlib import Path
import json,sys,copy,hashlib
from background_contract import validate,FEES,CORE_KEYS
D=Path(sys.argv[1]);root=D.parent;W=root.parent;inputs=json.load(open(D/'private/BACKGROUND_INPUTS.json'));core=json.load(open(D/'CORE-WORK-DESIGN.json'));sha=hashlib.sha256((D/'private/BACKGROUND_INPUTS.json').read_bytes()).hexdigest();positives=negatives=0
for fixed in inputs['rows']:
 m=json.load(open(W/'fox-v3-boundary-rho-affine-evaluation/actual-A2/on/private-partial'/f"{fixed['name']}.json"))
 for arm in ['on','background']:
  Q=fixed['runtimeSlots'];F=Q if arm=='background' else fixed['combinedEmptySlots']+fixed['expectedFinalFloorOverrides'];T=2385 if fixed['view']=='front' else 2391;queries=fixed['backgroundOnlyPositiveQueries'] if arm=='background' else fixed['combinedEmptyPositiveQueries']+fixed['extraFinalQueries']
  f=dict(version='host-camera-floor-composition-v1',complete=True,arm=arm,caseIndex=fixed['caseIndex'],viewIndex=fixed['viewIndex'],reverse=fixed['reverse'],snapshotFingerprint=fixed['snapshotFNV'],inputJSONSHA256=sha,oldWork8MCompatible=False,oldDirect1MCompatible=False,sourceGeometryUnchanged=True,characterDepthRetained=arm=='on',wholeFrameBufferAtomic=False,backgroundBuildNs=1,observerEvents=Q,backgroundQueries=queries,backgroundNodeVisits=0,backgroundTriangleTests=0)
  f.update(dict(backgroundRayLimit=2000000,backgroundNodeLimit=200000000,backgroundTriangleLimit=100000000,backgroundOwnedLimit=16384,backgroundAdditionalNamedStackLimit=4096,backgroundSceneBytes=976,backgroundContextBytes=376,backgroundWorkBytes=296,privateResultBytes=208,coreResultBytes=40,coreQueryBytes=24,coreReportBytes=400,maskConstructionBytesReserved=4050,inputConstructionBytesReserved=752,backgroundOwnedBytes=1712,backgroundNewOwnedConservativePeakBytes=7178))
  f['generation']=dict(zip(['geometry','pose','visibilityLight'],m['visibilityGeneration']))|dict(camera=fixed['viewIndex']+1,material=2 if fixed['caseIndex']==4 else 1,emission=1,illumination=fixed['caseIndex']+1)
  cats={}
  for k,fee in FEES.items():
   if k=='construct':limit=used=8192
   elif k=='frameAdmission':limit=593920;used=4096+8*(m['snapshotBytes']+7930)
   elif k=='worldMiss':limit=64*F;used=0
   elif k in ['slotAdmission','cameraRay','floorTriangles','clipDepthOrder','resultCounterCommit']:limit=used=fee*Q
   else:limit=used=fee*F
   cats[k]=dict(limit=limit,used=used)
  f['resolver']=dict(slotLimit=Q,shadeLimit=F,slots=Q,floorEvaluations=F,worldMisses=0,limit=8192+593920+2048*Q+36736*F,used=sum(c['used'] for c in cats.values()),categories=cats)
  f['classification']=dict(slots=Q,keep=Q-F,floor=F,world=0,parallel=0,negativeT=0,outside=0,clip=0,positiveQueries=queries,blockedQueries=0)
  decl=core['views'][fixed['view']]['combinedCoreReservedLedger' if arm=='on' else 'backgroundOnlyCoreReservedLedger'];cats={k:dict(reserved=v,observed=0 if k=='descriptorFingerprintBytes' else v-1 if k=='coreGuardDispatches' else v) for k,v in decl.items()}
  f['core']=dict(complete=True,descriptorFingerprintExecuted=False,hardLimit=1680000,queries=Q,centers=32400-T,quarters=4*T,kept=Q-F,floor=F,world=0,occludedCharacter=fixed['expectedFinalFloorOverrides'] if arm=='on' else 0,failedCategory=20,categories=cats,reservedTotal=sum(c['reserved'] for c in cats.values()),observedTotal=sum(c['observed'] for c in cats.values()))
  validate(f,m,fixed,arm,core,sha);positives+=1
  def leaves(o,path=()):
   for k,v in o.items():
    if isinstance(v,dict):yield from leaves(v,path+(k,))
    else:yield path+(k,),v
  for path,value in leaves(f):
   bad=[None]
   if type(value)is int:bad += [False,float(value),-1]
   elif type(value)is bool:bad += [not value,0 if not value else 1]
   elif type(value)is str:bad += [value+'tampered']
   for replacement in bad:
    g=copy.deepcopy(f);p=g
    for k in path[:-1]:p=p[k]
    p[path[-1]]=replacement
    try:validate(g,m,fixed,arm,core,sha)
    except (AssertionError,KeyError,TypeError,ValueError):negatives+=1
    else:raise AssertionError(('accepted mutation',path,replacement))
print(json.dumps(dict(syntheticPositiveTemplates=positives,mutationsRejected=negatives,physicalEvidence=False)))
