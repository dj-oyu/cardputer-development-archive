"""Actual C OFF control then ON all-case evaluation; failure never publishes quality manifest."""
from pathlib import Path
import sys,json,hashlib,subprocess,os,math
from aa_contract import validate as validate_aa
R=Path(__file__).resolve().parents[1];W=next(p for p in Path(__file__).resolve().parents if (p/'fox-v3-lid-evaluation/actual-lid8-v2').is_dir());B=W/'fox-v3-lid-evaluation/actual-lid8-v2'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert len(sys.argv)==3;D=Path(sys.argv[1]).resolve();arm=sys.argv[2];assert arm in ['off','on'];prepared=json.loads((D/'PREPARED.json').read_text());assert sha(D/'native-render')==prepared['binarySHA256'];pins=json.loads((D/'input-hashes.json').read_text());assert all(sha(D/p)==h for p,h in pins.items())
if arm=='on':assert json.loads((D/'off/COMPLETED.json').read_text())['allOldRGBDepthSnapshotExact']
pf=json.load(open(D/'PREFLIGHT_CONTRACT.json'))['arms']['A' if D.name.endswith('A2') else 'B']['rows']
O=D/arm;O.mkdir();stage=O/'private-partial';stage.mkdir();cfg=json.loads((D/'inputs/candidate-config.json').read_text());identity=json.loads((D/'identity-proof.json').read_text());frames=[]
for scenario in cfg['scenarios']:
 case=scenario['name'];pc=scenario['physical'];values=[]
 for light in pc['lights']:values.extend(light['position']+light['eulerXYZ']+light['color']+[light['power'],light['diameter']])
 values.extend(pc['worldRGB']+[pc['worldStrength']]);physical=O/f'physical-{case}.txt';physical.write_text('FOXDISK1\n'+' '.join(format(x,'.17g') for x in values)+'\n');assert physical.read_bytes()==(B/f'physical-{case}.txt').read_bytes()
 for camera in cfg['cameras']:
  view=camera['name']
  for reverse in [False,True]:
   name=f'native-{view}-{case}'+('-reverse' if reverse else '');prefix=stage/name;env={**os.environ,'HONE_NORMAL_PAIR_CODEC':'1','HONE_LINEAR_LIGHT':'1','HONE_PHYSICAL_LIGHT':'1','HONE_PIXEL_LIGHT':'1','HONE_PIXEL_VISIBILITY':'1','HONE_TRANSPORT_MODE':'2','HONE_OUTER_SAMPLES':'16','HONE_GROUND_MODE':'2','HONE_GROUND_FILE':str(D/'inputs'/f'ground-{case}.txt'),'HONE_DISK_FILE':str(physical),'HONE_BOUNDARY_AA':'1' if arm=='on' else '0','HONE_AA_LEDGER':str(D/f'ledger-{view}.txt')}
   args=[str(D/'native-render'),str(D/'compiled'/f'model-{case}/model.aynm'),str(prefix),str(int(reverse)),*map(str,camera['nativeCamera']),*map(str,scenario['nativeDirection']+scenario['intensity'])]
   with Path(str(prefix)+'.json').open('w') as stdout,Path(str(prefix)+'.stderr').open('w') as stderr:p=subprocess.run(args,env=env,stdout=stdout,stderr=stderr)
   if p.returncode:
    (O/'FAILED.json').write_text(json.dumps({'case':case,'view':view,'reverse':reverse,'returncode':p.returncode,'completedFrames':len(frames),'qualityManifestPublished':False,'partialOutputsPrivate':True,'stderr':Path(str(prefix)+'.stderr').read_text()},indent=2)+'\n');raise SystemExit(f'{arm} FAILED {name}; no quality manifest')
   meta=json.loads(Path(str(prefix)+'.json').read_text());old=json.loads((B/(name+'.json')).read_text());assert all(meta[k]==old[k] for k in ['normalPairCodecEnabled','normalPairMode4Records','normalPairMode5Records','normalPairSavedBytes','snapshotBytes','snapshotCapacity','work','records','coldBytes','arenaBytes64bit','camera','light','visibilityGeneration','visibilityGeometryFingerprint','visibilitySnapshotFingerprint','materialFingerprint','groundInputFingerprint','groundLe','groundFirstTriangle','groundTriangleCount','outerSamples','innerSamples','transportMode','disposedBeforeRender','reverse'])
   assert meta['transportComplete'] and meta['visibilityComplete'] and meta['snapshotBytes']==64208
   for group in ['visibility','transport']:
    for used,limit in [('Rays','RayLimit'),('NodeVisits','NodeLimit'),('TriangleTests','TriangleLimit')]:assert type(meta[group+used]) is int and 0<=meta[group+used]<=meta[group+limit]==old[group+limit]
   assert Path(str(prefix)+'.snapshot').read_bytes()==(B/(name+'.snapshot')).read_bytes()
   assert Path(str(prefix)+'.f32le').read_bytes()==(B/(name+'.f32le')).read_bytes()
   if arm=='off':
    assert Path(str(prefix)+'.u16le').read_bytes()==(B/(name+'.u16le')).read_bytes();assert {k:v for k,v in meta.items() if 'Ns' not in k and not k.endswith('NsFirstFrame')}=={k:v for k,v in old.items() if 'Ns' not in k and not k.endswith('NsFirstFrame')}
   else:
    aa=json.loads(Path(str(prefix)+'.aa.json').read_text());validate_aa(aa,list(map(int,(D/f'ledger-{view}.txt').read_text().split())),2385 if view=='front' else 2391,identity['identityFNV64'],next(z['sampleHits'] for z in pf if z['view']==view and z['case']==case and z['reverse']==reverse),meta['visibilitySnapshotFingerprint']);assert aa['preflightSnapshotFNV']==meta['visibilitySnapshotFingerprint'];assert aa['complete'] and aa['reservedTotal']<=8000000 and aa['observedTotal']<=aa['reservedTotal'];assert aa['workspaceBytes']+aa['newStackReserve']<=147456 and aa['retainedOutputBytes']==194400 and aa['identityBytes']==7930;assert aa['identityFNV']==identity['identityFNV64'];assert aa['observerSamples']==4*aa['targets'] and aa['observerHits']==aa['sampleShades'];assert sum(aa['sampleHits'])==aa['sampleShades'];assert meta['shadeUpdates']==aa['centerShades']+aa['sampleShades'] and meta['diskSamples']==48*meta['shadeUpdates'];assert all(z['observed']<=z['reserved'] for z in aa['categories'].values());assert sum(z['reserved'] for z in aa['categories'].values())==aa['reservedTotal'] and sum(z['observed'] for z in aa['categories'].values())==aa['observedTotal']
   if arm=='on' and D.name.endswith('A2'):
    control=W/'fox-v3-boundary-aa-evaluation/actual-001/on/private-partial'/name
    for ext in ['.u16le','.f32le','.snapshot','.targets.u8']:
     if Path(str(prefix)+ext).read_bytes()!=Path(str(control)+ext).read_bytes():
      (O/'CONTROL_FAILED.json').write_text(json.dumps({'view':view,'case':case,'reverse':reverse,'extension':ext,'status':'OLD_QUARTER_BYTE_CONTROL_FAILED','qualityManifestPublished':False},indent=2)+'\n');raise SystemExit('A2_OLD_QUARTER_CONTROL_FAILED')
   row={'view':view,'case':case,'reverse':reverse,'prefix':str(prefix.relative_to(O)),'metadata':meta,'files':{ext:sha(Path(str(prefix)+ext)) for ext in ['.u16le','.f32le','.snapshot','.json']}};frames.append(row);(O/'progress.json').write_text(json.dumps({'completedFrames':len(frames),'last':name},indent=2)+'\n');print(arm,name,'PASS',flush=True)
assert len(frames)==20 and all(sha(D/p)==h for p,h in pins.items())
for view in ['front','oblique']:
 for case in [s['name'] for s in cfg['scenarios']]:
  a=stage/f'native-{view}-{case}';b=stage/f'native-{view}-{case}-reverse'
  for ext in ['.u16le','.f32le']:assert Path(str(a)+ext).read_bytes()==Path(str(b)+ext).read_bytes(),('ORDER_DIFFERENCE',view,case,ext)
manifest={'status':'ALL20_ACTUAL_COMPLETE','arm':arm,'frames':frames,'allOldRGBDepthSnapshotExact':arm=='off','centerDepthAndSnapshotOldExact':True,'allForwardReverseRGBDepthExact':True,'inputHashesSHA256':sha(D/'input-hashes.json'),'binarySHA256':sha(D/'native-render'),'newWorkAndErrorContract':'host-final-visible-only; not old API success or old49-equivalent work','sourceInputsUnchanged':True};(O/'COMPLETED.json').write_text(json.dumps(manifest,indent=2)+'\n');print(arm,'ALL20_COMPLETE')
