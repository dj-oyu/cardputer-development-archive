"""Complete one frozen arm, retain private partial failures, publish only all20."""
from pathlib import Path
import json,hashlib,sys,subprocess,os
from aa_contract import validate as validate_aa
from background_contract import validate as validate_background
R=Path(__file__).resolve().parents[1];W=R.parent;B=W/'fox-v3-boundary-rho-affine-evaluation/actual-A2/on';sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert len(sys.argv)==3;D=Path(sys.argv[1]).resolve();arm=sys.argv[2];assert arm in ['off','on','background'];O=D/arm;assert not O.exists();O.mkdir();stage=O/'private-partial';stage.mkdir()
pins=json.load(open(D/'input-hashes.json'));prepared=json.load(open(D/'PREPARED.json'));assert sha(D/'native-render')==prepared['binarySHA256'] and all(sha(D/k)==h for k,h in pins.items())
if arm!='off':assert json.load(open(D/'off/COMPLETED.json'))['oldA2BuffersExact'] is True
cfg=json.load(open(D/'inputs/candidate-config.json'));inputs_path=D/'private/BACKGROUND_INPUTS.json';inputs=json.load(open(inputs_path));pf=json.load(open(D/'PREFLIGHT_CONTRACT.json'))['arms']['A']['rows'];core=json.load(open(D/'CORE-WORK-DESIGN.json'));rows=[]
old_fields=['snapshotBytes','records','work','camera','light','coldBytes','arenaBytes64bit','visibilityGeometryFingerprint','visibilitySnapshotFingerprint','materialFingerprint','groundInputFingerprint','groundLe','visibilityGeneration','materialGeneration','emissionGeneration']
old_work=['visibilityRays','visibilityNodeVisits','visibilityTriangleTests','transportRays','transportNodeVisits','transportTriangleTests','primary_ground_hits','primary_ground_emission_hits','secondary_ground_hits','primary_rays','primary_hits','primary_misses','secondary_world_rays','secondary_direct_queries','primary_direct_queries','zero_reflection_ns_v','back_single_discard','grazing_ng_v','shadeUpdates','diskSamples']
for ci,s in enumerate(cfg['scenarios']):
 case=s['name'];values=[]
 for l in s['physical']['lights']:values.extend(l['position']+l['eulerXYZ']+l['color']+[l['power'],l['diameter']])
 values.extend(s['physical']['worldRGB']+[s['physical']['worldStrength']]);physical=O/f'physical-{case}.txt';physical.write_text('FOXDISK1\n'+' '.join(format(x,'.17g') for x in values)+'\n')
 for c in cfg['cameras']:
  view=c['name']
  for rev in [False,True]:
   name=f'native-{view}-{case}'+('-reverse' if rev else '');prefix=stage/name;oldp=B/'private-partial'/name;fixed=next(v for v in inputs['rows'] if v['name']==name)
   env={**os.environ,'HONE_NORMAL_PAIR_CODEC':'1','HONE_LINEAR_LIGHT':'1','HONE_PHYSICAL_LIGHT':'1','HONE_PIXEL_LIGHT':'1','HONE_PIXEL_VISIBILITY':'1','HONE_TRANSPORT_MODE':'2','HONE_OUTER_SAMPLES':'16','HONE_GROUND_MODE':'2','HONE_GROUND_FILE':str(D/'inputs'/f'ground-{case}.txt'),'HONE_DISK_FILE':str(physical),'HONE_BOUNDARY_AA':'1','HONE_AA_LEDGER':str(D/f'ledger-{view}.txt'),'HONE_CAMERA_COMPOSITION':arm,'HONE_BACKGROUND_CASE':str(ci),'HONE_BACKGROUND_MASK':str(D/'private'/f'target-{view}.bits'),'HONE_FLOOR_REFLECTION':'off'}
   args=[str(D/'native-render'),str(D/'compiled'/f'model-{case}/model.aynm'),str(prefix),str(int(rev)),*map(str,c['nativeCamera']),*map(str,s['nativeDirection']+s['intensity'])]
   with Path(str(prefix)+'.json').open('w') as out,Path(str(prefix)+'.stderr').open('w') as err:p=subprocess.run(args,env=env,stdout=out,stderr=err)
   if p.returncode:
    (O/'FAILED.json').write_text(json.dumps({'view':view,'case':case,'reverse':rev,'completedFrames':len(rows),'returncode':p.returncode,'qualityManifestPublished':False,'partialOutputsPrivate':True,'stderr':Path(str(prefix)+'.stderr').read_text()},indent=2)+'\n');raise SystemExit(f'FAILED {arm} {name}')
   try:
    m=json.load(open(str(prefix)+'.json'));old=json.load(open(str(oldp)+'.json'));aa=json.load(open(str(prefix)+'.aa.json'))
    for k in old_fields:assert m[k]==old[k],k
    for ext in ['.snapshot','.targets.u8']:assert Path(str(prefix)+ext).read_bytes()==Path(str(oldp)+ext).read_bytes(),ext
    if arm!='background':
     for k in old_work:assert m[k]==old[k],k
     assert Path(str(prefix)+'.f32le').read_bytes()==Path(str(oldp)+'.f32le').read_bytes()
     validate_aa(aa,list(map(int,(D/f'ledger-{view}.txt').read_text().split())),2385 if view=='front' else 2391,'912ba9aa3cfbfb2c',next(x['sampleHits'] for x in pf if (x['view'],x['case'],x['reverse'])==(view,case,rev)),m['visibilitySnapshotFingerprint'])
     # The original diagnostic observer is deliberately before composition.
     assert Path(str(prefix)+'.samples.jsonl').read_bytes()==Path(str(oldp)+'.samples.jsonl').read_bytes()
    else:
     for k in old_work:assert m[k]==0,k
    if arm=='off':assert Path(str(prefix)+'.u16le').read_bytes()==Path(str(oldp)+'.u16le').read_bytes()
    else:validate_background(json.load(open(str(prefix)+'.background.json')),m,fixed,arm,core,sha(inputs_path))
   except Exception as e:
    (O/'REJECTED.json').write_text(json.dumps({'view':view,'case':case,'reverse':rev,'completedFrames':len(rows),'nativeReturnCode':0,'admissionError':repr(e),'qualityManifestPublished':False,'outputsPrivate':True},indent=2)+'\n');raise
   ext=['.u16le','.f32le','.snapshot','.targets.u8','.json','.aa.json','.samples.jsonl']+([] if arm=='off' else ['.background.json','.background.jsonl'])
   rows.append({'view':view,'case':case,'reverse':rev,'prefix':str(prefix.relative_to(O)),'metadata':m,'files':{e:sha(Path(str(prefix)+e)) for e in ext}});(O/'progress.json').write_text(json.dumps({'completedFrames':len(rows),'last':name})+'\n');print(arm,name,'PASS',flush=True)
assert len(rows)==20 and all(sha(D/k)==h for k,h in pins.items())
for view in ['front','oblique']:
 for s in cfg['scenarios']:
  a=stage/f'native-{view}-{s["name"]}';b=stage/(a.name+'-reverse')
  for ext in ['.u16le','.f32le']:assert Path(str(a)+ext).read_bytes()==Path(str(b)+ext).read_bytes()
(O/'COMPLETED.json').write_text(json.dumps({'status':'ALL20_ACTUAL_COMPLETE','arm':arm,'frames':rows,'oldA2BuffersExact':arm=='off','characterDepthAndRawHDRExact':arm!='background','allForwardReverseRGBDepthExact':True,'sourceInputsUnchanged':True,'inputHashesSHA256':sha(D/'input-hashes.json'),'binarySHA256':sha(D/'native-render'),'contract':'independent-camera-floor-scene-composition; old1M-and8M-FAIL; separate-host-background-budgets'},indent=2)+'\n');print(arm,'ALL20_COMPLETE')
