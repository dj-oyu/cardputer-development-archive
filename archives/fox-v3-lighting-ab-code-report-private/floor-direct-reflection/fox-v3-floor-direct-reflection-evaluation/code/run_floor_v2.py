from pathlib import Path
import json,hashlib,sys,subprocess,os
from aa_contract import validate as validate_aa
from floor_contract_v2 import validate as validate_floor
R=Path(__file__).resolve().parents[1];W=R.parent;B=W/'fox-v3-boundary-rho-affine-evaluation/actual-A2/on';sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert len(sys.argv)==3;D=Path(sys.argv[1]).resolve();arm=sys.argv[2];assert arm in ['off','zero','on'];O=D/arm;assert not O.exists();O.mkdir();stage=O/'private-partial';stage.mkdir()
pins=json.load(open(D/'input-hashes.json'));prepared=json.load(open(D/'PREPARED.json'));assert sha(D/'native-render')==prepared['binarySHA256'];assert all(sha(D/k)==v for k,v in pins.items())
if arm=='on':assert json.load(open(D/'off/COMPLETED.json'))['oldA2BuffersExact']
if arm=='on':assert json.load(open(D/'zero/COMPLETED.json'))['oldA2BuffersExact']
cfg=json.load(open(D/'inputs/candidate-config.json'));bounds=json.load(open(D/'WORKLOAD_BOUNDS.json'))['rows'];source=json.load(open(D/'SOURCE_RHO.json'));pf=json.load(open(D/'PREFLIGHT_CONTRACT.json'))['arms']['A']['rows'];identity=json.load(open(D/'identity-proof.json'));rows=[]
for ci,scenario in enumerate(cfg['scenarios']):
 case=scenario['name'];assert source['scenarios'][ci]['name']==case;pc=scenario['physical'];values=[]
 for light in pc['lights']:values.extend(light['position']+light['eulerXYZ']+light['color']+[light['power'],light['diameter']])
 values.extend(pc['worldRGB']+[pc['worldStrength']]);physical=O/f'physical-{case}.txt';physical.write_text('FOXDISK1\n'+' '.join(format(x,'.17g') for x in values)+'\n')
 for camera in cfg['cameras']:
  view=camera['name']
  for rev in [False,True]:
   name=f'native-{view}-{case}'+('-reverse' if rev else '');prefix=stage/name;oldp=B/'private-partial'/name
   env={**os.environ,'HONE_NORMAL_PAIR_CODEC':'1','HONE_LINEAR_LIGHT':'1','HONE_PHYSICAL_LIGHT':'1','HONE_PIXEL_LIGHT':'1','HONE_PIXEL_VISIBILITY':'1','HONE_TRANSPORT_MODE':'2','HONE_OUTER_SAMPLES':'16','HONE_GROUND_MODE':'2','HONE_GROUND_FILE':str(D/'inputs'/f'ground-{case}.txt'),'HONE_DISK_FILE':str(physical),'HONE_BOUNDARY_AA':'1','HONE_AA_LEDGER':str(D/f'ledger-{view}.txt'),'HONE_FLOOR_REFLECTION':arm,'HONE_FLOOR_CASE':str(ci)}
   args=[str(D/'native-render'),str(D/'compiled'/f'model-{case}/model.aynm'),str(prefix),str(int(rev)),*map(str,camera['nativeCamera']),*map(str,scenario['nativeDirection']+scenario['intensity'])]
   with Path(str(prefix)+'.json').open('w') as out,Path(str(prefix)+'.stderr').open('w') as err:p=subprocess.run(args,env=env,stdout=out,stderr=err)
   if p.returncode:
    (O/'FAILED.json').write_text(json.dumps({'view':view,'case':case,'reverse':rev,'completedFrames':len(rows),'returncode':p.returncode,'qualityManifestPublished':False,'partialOutputsPrivate':True,'stderr':Path(str(prefix)+'.stderr').read_text()},indent=2)+'\n');raise SystemExit(f'FAILED {arm} {name}')
   m=json.load(open(str(prefix)+'.json'));old=json.load(open(str(oldp)+'.json'));aa=json.load(open(str(prefix)+'.aa.json'));fl=json.load(open(str(prefix)+'.floor.json'));bound=next(x for x in bounds if (x['view'],x['case'],x['reverse'])==(view,case,rev));rho=source['scenarios'][ci]['actualGroundBaseColor'][:3] if arm=='on' else [0.,0.,0.]
   validate_floor(fl,m,bound,rho,arm)
   validate_aa(aa,list(map(int,(D/f'ledger-{view}.txt').read_text().split())),2385 if view=='front' else 2391,identity['identityFNV64'],next(x['sampleHits'] for x in pf if (x['view'],x['case'],x['reverse'])==(view,case,rev)),m['visibilitySnapshotFingerprint'])
   for k in ['snapshotBytes','records','work','camera','light','coldBytes','arenaBytes64bit','visibilityGeometryFingerprint','visibilitySnapshotFingerprint','materialFingerprint','groundInputFingerprint','groundLe','primary_ground_hits','primary_ground_emission_hits','primary_rays','primary_hits','primary_misses','secondary_world_rays','secondary_direct_queries','primary_direct_queries','shadeUpdates','diskSamples']:assert m[k]==old[k],k
   for ext in ['.f32le','.snapshot','.targets.u8']:assert Path(str(prefix)+ext).read_bytes()==Path(str(oldp)+ext).read_bytes(),ext
   if arm!='on':
    assert Path(str(prefix)+'.u16le').read_bytes()==Path(str(oldp)+'.u16le').read_bytes()
    for k in ['transportRays','transportNodeVisits','transportTriangleTests']:assert m[k]==old[k]
   row={'view':view,'case':case,'reverse':rev,'prefix':str(prefix.relative_to(O)),'metadata':m,'files':{e:sha(Path(str(prefix)+e)) for e in ['.u16le','.f32le','.snapshot','.targets.u8','.json','.aa.json','.floor.json','.samples.jsonl']}};rows.append(row)
   (O/'progress.json').write_text(json.dumps({'completedFrames':len(rows),'last':name})+'\n');print(arm,name,'PASS',flush=True)
assert len(rows)==20 and all(sha(D/k)==v for k,v in pins.items())
for view in ['front','oblique']:
 for s in cfg['scenarios']:
  a=stage/f'native-{view}-{s["name"]}';b=stage/(a.name+'-reverse')
  for ext in ['.u16le','.f32le']:assert Path(str(a)+ext).read_bytes()==Path(str(b)+ext).read_bytes()
manifest={'status':'ALL20_ACTUAL_COMPLETE','arm':arm,'frames':rows,'oldA2BuffersExact':arm!='on','allForwardReverseRGBDepthExact':True,'sourceInputsUnchanged':True,'inputHashesSHA256':sha(D/'input-hashes.json'),'binarySHA256':sha(D/'native-render'),'contract':'separate-host-floor-work; not old8M total admission; unchanged transport caps'}
(O/'COMPLETED.json').write_text(json.dumps(manifest,indent=2)+'\n');print(arm,'ALL20_COMPLETE')
