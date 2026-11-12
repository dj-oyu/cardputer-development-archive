"""Admission-only host fixtures. No physical frames are rendered by this test.

Uses private pinned dependency inputs but reports aggregate facts/hashes only.
LeakSanitizer is disabled because this execution harness uses ptrace; address and
undefined-behavior sanitizers remain enabled. This is not a leak-sanitizer claim.
"""
from pathlib import Path
import hashlib, json, os, subprocess, sys
R=Path(__file__).resolve().parents[1];D=R/'deps';B=R.parent/'fox-v3-lid-evaluation/actual-lid8-v2'
assert len(sys.argv)==2,'usage: test_root_pose.py NEW_OUTPUT_DIRECTORY'
O=Path(sys.argv[1]).resolve();O.mkdir(exist_ok=False)
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
cfg=json.loads((D/'inputs/candidate-config.json').read_text());scenario=next(x for x in cfg['scenarios'] if x['name']=='baseline')
rows=[]
for binary in ['root-pose','root-pose-asan']:
 for camera in cfg['cameras']:
  for reverse in [0,1]:
   prefix=O/f'{binary}-{camera["name"]}-{reverse}'
   env={**os.environ,'HONE_ROOT_ADMISSION_ONLY':'1','HONE_ROOT_DUMP_GEOMETRY':'0','HONE_DISK_FILE':str(D/'inputs/physical-baseline.txt'),'HONE_GROUND_FILE':str(D/'inputs/ground-baseline.txt'),'ASAN_OPTIONS':'detect_leaks=0:halt_on_error=1','UBSAN_OPTIONS':'halt_on_error=1'}
   args=[str(R/binary),str(D/'compiled/model-baseline/model.aynm'),str(prefix),str(reverse),*map(str,camera['nativeCamera']),*map(str,scenario['nativeDirection']+scenario['intensity'])]
   p=subprocess.run(args,env=env,capture_output=True,text=True)
   Path(str(prefix)+'.stdout.json').write_text(p.stdout);Path(str(prefix)+'.stderr').write_text(p.stderr)
   assert p.returncode==0,(binary,camera['name'],reverse,p.stderr)
   m=json.loads(p.stdout);assert m['admissionComplete'] and not m['chainComplete'] and m['renderedFrames']==0 and not m['identityReturnPixelsExact']
   assert m['initCount']==m['disposeCount']==1 and m['evaluateCallCount']==4 and m['validTargetCallCount']==4
   assert m['peakOwnedSets']==2 and m['ownedReservedLimitBytes']==m['peakOwnedReservedBytes']==1703936
   assert m['invalidBatchAtomicityChecks']==1 and m['injectedCurrentBuildFailures']==1 and m['idempotentReleaseNoops']==2
   assert m['staleEpochBeforeEvaluateChecks']==m['staleEpochAfterEvaluateChecks']==3 and m['disposedViewRejections']==1
   assert m['provenanceMismatchRejections']==3 and m['lowLevelDistinctSnapshotRejections']==2 and m['lowLevelStaleGenerationRejections']==3
   assert [x['epochAfterEvaluate'] for x in m['evaluationSequence']]==[2,3,4,5]
   old=json.loads((B/f'native-{camera["name"]}-baseline{("-reverse" if reverse else "")}.json').read_text())
   for key in ['visibilityGeometryFingerprint','materialFingerprint','visibilitySnapshotFingerprint','snapshotBytes','work','normalPairMode4Records','normalPairMode5Records']:
    assert m['poses'][0][key]==old[key],(camera['name'],reverse,key)
   for pose in m['poses']:
    assert pose['maxSourceHeightDelta']==0 and pose['snapshotBytes']<=65536 and pose['work']<=8000000
    assert pose['normalPairMode4Records']==pose['normalPairIneligiblePackets'] and pose['normalPairMode5Records']==pose['normalPairEligiblePackets']
    assert pose['pairDistancesChecked']==1163*1162//2
   assert all(m['poses'][i]['identityGeometryExact'] and m['poses'][i]['identityAttributesExact'] and m['poses'][i]['identityNormalsExact'] for i in [0,3])
   rows.append({'binary':binary,'camera':camera['name'],'reverse':reverse,'admissionSHA256':sha(Path(str(prefix)+'.admission.json')),'peakTrackedHeapBytes':m['peakTrackedHeapBytes']})
   # These are rejected before model construction/rendering, with no pixel outputs.
   if binary=='root-pose' and camera['name']=='front' and not reverse:
    for name,patch,gate in [('aa-reject',{'HONE_BOUNDARY_AA':'1'},'aa-off-required'),('control-required',{'HONE_ROOT_ADMISSION_ONLY':'0','HONE_ROOT_CONTROL_PREFIX':''},'render-control-prefix-required')]:
     badprefix=O/name;badargs=args.copy();badargs[2]=str(badprefix);q=subprocess.run(badargs,env={**env,**patch},capture_output=True,text=True)
     assert q.returncode==2 and f'NATIVE_GATE:{gate}' in q.stderr,(name,q.returncode,q.stderr)
     assert not list(O.glob(name+'*.u16le')) and not list(O.glob(name+'*.f32le'))
     failure=json.loads(Path(str(badprefix)+'.failure.json').read_text());assert not failure['admissionComplete'] and not failure['chainComplete']
   print(binary,camera['name'],reverse,'PASS',flush=True)
result={'status':'ALL8_ADMISSION_FIXTURES_PASS','physicalFramesRendered':0,'addressUndefinedSanitizers':'PASS','leakSanitizer':'UNAVAILABLE under ptrace; detect_leaks=0','sourceSHA256':sha(R/'code/root_pose.c'),'buildScriptSHA256':sha(R/'code/build_root_pose.sh'),'testScriptSHA256':sha(Path(__file__)),'dependencyFreezeSHA256':sha(R/'DEPENDENCY_FREEZE.json'),'rows':rows}
(O/'FIXTURE_REPORT.json').write_text(json.dumps(result,indent=2)+'\n');print('ALL8_ADMISSION_FIXTURES_PASS')
