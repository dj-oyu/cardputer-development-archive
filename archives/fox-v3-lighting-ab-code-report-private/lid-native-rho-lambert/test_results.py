from pathlib import Path
import json,hashlib
R=Path(__file__).resolve().parent;load=lambda p:json.loads((R/p).read_text());checks=0
f=load('SOURCE_FREEZE.json')
for p,h in f['files'].items():assert hashlib.sha256((R/p).read_bytes()).hexdigest()==h;checks+=1
rho=load('rho-proof.json');assert len(rho['parts'])==54 and sum(x['rawVertices'] for x in rho['parts'])==1163 and sum(x['triangles'] for x in rho['parts'])==1564;checks+=1
for p in rho['parts']:assert p['A565']==p['B565'] and p['AEqualsBForAllVerticesAndBothPhysicalSides'];checks+=1
for case in ['baseline','direction']:
 a=load(f'run-001/lambert-seed11-oblique-{case}-audit.json');assert a['ablation']['worldGraphUnchanged'] and a['ablation']['originalMaterialDatablocksUnchanged'];checks+=1
 for p in a['ablation']['parts']:assert p['colorActualCFloat']==rho['parts'][p['node']-1]['rhoActualCFloat'] and p['originalEmissionZero'];checks+=1
c=load('analysis-001/contract.json');assert c['primaryWorldDirectionBitExact'] and c['primaryGroundDirectionBitExact'] and c['directPlusPrimaryDeltaVersusDirectMaxAbsRGB']<1e-14;checks+=1
for file in ['component-comparison.json','absolute-direct-comparison.json']:
 data=load('analysis-001/'+file);cases=[data] if file.startswith('component-') else list(data.values())
 for data in cases:
  for domain,arms in data.items():
   for arm,terms in arms.items():
    for term,z in terms.items():
     for key in ['rawSign','existing2over255LinearDiagnostic']:assert sum(z[key].values())==c['domains'][domain];checks+=1
co=load('analysis-001/census.json')
for arm,domains in co.items():
 for name,z in domains.items():
  assert z['n']==sum(z[k] for k in ['stableSourceCorrect','oppositeStableSourceSign','stableSourceActiveBecomesInactive','stableSourceInactiveBecomesActive','sourceUncertain','outsideOriginalForeground']);checks+=1
assert co['richOriginalRho']['oldReverse113']['stableSourceCorrect']==41 and co['richOriginalRho']['priorRichCorrect41']['stableSourceCorrect']==41;checks+=1
assert co['lambertNativeRho']['originalForeground']['oppositeStableSourceSign']==127 and co['lambertNativeRho']['oldReverse113']['oppositeStableSourceSign']==54;checks+=1
print(json.dumps({'status':'PASS','checks':checks,'fixedCohorts':True,'unknownNotAccepted':True,'originalForegroundBoundedReferenceClasses':True,'nativeRhoStorageExact':True,'sourceFreezeExact':True},indent=2))
