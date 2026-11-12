"""Pin authored background inputs and geometry-only counts; never load image RGB."""
from pathlib import Path
import json,hashlib,struct
R=Path(__file__).resolve().parents[1];W=R.parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
A=W/'fox-v3-boundary-rho-affine-evaluation/actual-A2'
P=W/'fox-v3-camera-background-plan/preflight'
paths={'camera':W/'fox-v3-camera-source-audit/summary.json','rho':W/'fox-v3-floor-direct-reflection-plan/SOURCE_RHO.json','config':A/'inputs/candidate-config.json','ground':W/'fox-v3-ground-transport/inputs/ground-source.json','counts':P/'counts-001/COMPLETED.json','countInputs':P/'counts-001/INPUT_FREEZE.json','countCode':P/'SOURCE_FREEZE.json','identity':A/'identity-proof.json'}
assert sha(paths['camera'])=='97ad99ed02297b3c8cc4b0fa0c425c74196cdcf5478a3e21c35323d6ba283d1b'
paths['finalOverrides']=P/'final-overrides-001/SUMMARY.json'
assert sha(P/'final-overrides-001/SOURCE_FREEZE.json')=='e235b0af5fa08c2e81d5d01000970f2608a4cd27aba49af708e48bcc826d393f'
assert sha(paths['finalOverrides'])=='75996a95355cbd744c0c66cef7e43b0638312e916d7c4c97e7b30cfb5324ffd6'
assert sha(paths['counts'])=='82f6c16ed1fc2bc05aedc09292ab153632bd85b991de679f0ecaa83b2411b9aa'
cfg=json.load(open(paths['config']));rho=json.load(open(paths['rho']));cam=json.load(open(paths['camera']));counts=json.load(open(paths['counts']))['cases'];ground=json.load(open(paths['ground']))
f32=lambda v:struct.unpack('<f',struct.pack('<f',v))[0]
rows=[]
for ci,s in enumerate(cfg['scenarios']):
 assert s['name']==rho['scenarios'][ci]['name']
 for vi,c in enumerate(cfg['cameras']):
  for reverse in [False,True]:
   name=f'native-{c["name"]}-{s["name"]}'+('-reverse' if reverse else '')
   z=next(v for v in counts if v['name']==name)
   # Reuse audited preflight camera/floor inputs, preserving exact decimal doubles.
   cp=P/'counts-001/private-geometry-inputs'/f'{name}.config';lines=cp.read_text().split();assert lines[0]=='FOXCAMCOUNT1'
   vals=list(map(float,lines[1:]));native=vals[:9];origin=vals[9:12];view=vals[12:15];near,far=vals[15:17]
   assert native==[f32(x) for x in c['nativeCamera']]
   rows.append({'name':name,'case':s['name'],'caseIndex':ci,'view':c['name'],'viewIndex':vi,'reverse':reverse,'snapshotFNV':z['snapshotFNV'],'nativeCameraF32':native,'sourceOrigin':origin,'sourceUnitView':view,'near':near,'far':far,'rho':rho['scenarios'][ci]['actualGroundBaseColor'][:3],'floorWorld':ground['worldVertices'],'floorTriangles':ground['triangles'],'le':rho['scenarios'][ci]['linearLe'],'worldRGB':s['physical']['worldRGB'],'worldStrength':s['physical']['worldStrength'],'runtimeSlots':z['backgroundOnly']['slots'],'combinedEmptySlots':z['combinedEmpty']['slots'],'backgroundOnlyPositiveQueries':z['backgroundOnly']['positiveKernelQueries'],'combinedEmptyPositiveQueries':z['combinedEmpty']['positiveKernelQueries'],'expectedOrderingFailures':z['floorStrictlyInFront'],'expectedFinalFloorOverrides':2 if c['name']=='front' else 0,'extraFinalQueriesBaseline':96 if c['name']=='front' else 0,'preflightConfigSHA256':sha(cp),'extraFinalQueriesAllCasesVerified':True,'extraFinalQueries':96 if c['name']=='front' else 0})
out=R/'private/BACKGROUND_INPUTS.json';assert not out.exists();out.write_text(json.dumps({'version':'camera-composition-inputs-v1','pins':{str(p.relative_to(W)):sha(p) for p in paths.values()},'rows':rows,'note':'extra final positive queries verified across allfive frontconditions and bothorders by pinned final-overrides-001; oblique has no retained overrides'},indent=2)+'\n');print(out,sha(out))
