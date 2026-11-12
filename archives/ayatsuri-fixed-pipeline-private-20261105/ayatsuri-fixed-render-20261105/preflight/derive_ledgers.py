from pathlib import Path
import json,hashlib,struct
D=Path(__file__).parent;W=D.resolve().parents[1];B=W/'fox-v3-indexed-bvh-bounds/actual-on-001'
N=32400;R=54;F=1564;bands=17
names=['legacyCenterReservation','centerIDInitialization','centerIDUpdateUpper','maskBytesClear','maskNeighborComparisons','bandHDRClear','sampleDepthWinnerClear','recordVisits','faceSetupAndVertexDecodeStages','bboxVisitAndMaskTest','targetEdgeDepthWinnerStages','finalSampleScan','finalHitShadingAndInterpolationUpper','finalPixelAverageEncodeWrite','sourceIdentityBindingValidationUpper','identityKeyClearBytes','identityFingerprintBytes','snapshotBindingFingerprintBytes','admissionAndPhaseControl','counterGuardDispatches','finalOutputPixelScan']
def fnv(b):
 h=14695981039346656037
 for x in b:h=((h^x)*1099511628211)&((1<<64)-1)
 return f'{h:016x}'
rows=[]
for kind in ['baseline','q16','q20']:
 for view in ['front','oblique']:
  prefix=D/f'{kind}-{view}';g=json.loads(Path(str(prefix)+'.geometry.json').read_text());H=sum(g['hits'][1:]);T=g['targets'];cb=g['bboxVisits'][0];cu=g['centerUpdates']
  guards=1+4+2*R+2*F+3+bands+cu+135+bands+bands+4*bands+4*bands+4*bands*R+4*bands*F+sum(g['nonemptyBandBoxes'][1:])+sum(g['testedPoints'][1:])+4*bands+H+bands+T
  observed=[g['legacyCenterReservation'],N,cu,4050,4*N,3*N,8*N,4*bands*R,16*4*bands*F,2*sum(g['bboxVisits'][1:]),12*sum(g['testedPoints'][1:]),4*N,76*H,8*T,55*64+55+R*16+F*16,9920,7930,g['snapshotBytes'],128+R+bands+bands+4*bands,guards,N]
  reserve=observed.copy();reserve[2]=cb;reserve[14]=32768;reserve[16]=8192;reserve[17]=65536;reserve[18]=4160
  # Each center bbox visit bounds a possible accepted winner update. Additional
  # control allowance bounds dispatches too. Round the independently derived
  # dispatch bound up to 10k, rather than copying the old 310000 reservation.
  guard_bound=guards-cu+cb+(reserve[18]-observed[18]);reserve[19]=((guard_bound+9999)//10000)*10000
  assert all(a<=b for a,b in zip(observed,reserve));assert sum(reserve)<=8000000
  mask=Path(str(prefix)+'.targets.u8').read_bytes();assert len(mask)==N and max(mask)<=1
  packed=bytearray(4050)
  for i,x in enumerate(mask):packed[i//8]|=x<<(i%8)
  with Path(str(prefix)+'.targets.packed').open('xb') as f:f.write(packed)
  geom=Path(str(prefix)+'.world-vertices.f64le').read_bytes()+Path(str(prefix)+'.world-triangles.u32le').read_bytes()
  row={'kind':kind,'view':view,'status':'DERIVED_NOT_RENDERED','snapshotFNV':g['snapshotFNV'],'targetPackedFNV':fnv(packed),'targetU8FNV':fnv(mask),'geometryFNV':fnv(geom),'geometrySHA256':hashlib.sha256(geom).hexdigest(),'targets':T,'sampleHits':g['hits'][1:],'centerUpdates':cu,'predictedObservedTotal':sum(observed),'reservedTotal':sum(reserve),'counterDispatchConservativeBound':guard_bound,'categories':{n:{'predictedObserved':a,'reserved':b} for n,a,b in zip(names,observed,reserve)}}
  if kind=='baseline':
   old=json.loads((B/f'native-{view}-baseline.aa.json').read_text())
   assert all(observed[i]==old['categories'][n]['observed'] for i,n in enumerate(names))
   row['all21PredictedObservedEqualSavedActual']=True
   row['reservationDifferencesFromOld']={n:[old['categories'][n]['reserved'],reserve[i]] for i,n in enumerate(names) if old['categories'][n]['reserved']!=reserve[i]}
  with Path(str(prefix)+'.aa-ledger.txt').open('x') as f:f.write(' '.join(map(str,reserve))+'\n')
  with Path(str(prefix)+'.aa-ledger.json').open('x') as f:json.dump(row,f,indent=2);f.write('\n')
  rows.append(row)
with (D/'LEDGERS.json').open('x') as f:json.dump({'status':'SIX_CANDIDATE_SPECIFIC_AA_LEDGERS_DERIVED','scope':'Geometry and charge prediction only; independent floor/background admission still required','rows':rows},f,indent=2);f.write('\n')
print([(r['kind'],r['view'],r['reservedTotal'],r['targetPackedFNV'],r.get('reservationDifferencesFromOld')) for r in rows])
