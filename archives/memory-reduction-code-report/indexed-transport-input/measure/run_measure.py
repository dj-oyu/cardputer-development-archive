"""Build-only read of completed frozen inputs. No model evaluation or rendering."""
from pathlib import Path
import hashlib,json,subprocess,datetime
R=Path(__file__).resolve().parents[1]; W=R.parent; D=R/'measure'; B=W/'fox-v3-compact-transport'
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()
sources=[D/'measure_attributes.c',R/'private-build/visibility/visibility.c',R/'private-build/physical/fox_disk_lighting.c',R/'private-build/product/main/ayatsuri/compact_opaque.c']
cmd=['cc','-std=c11','-O2','-g','-Wall','-Wextra','-Werror','-Wno-misleading-indentation','-ffp-contract=off','-fexcess-precision=standard',*map(str,sources),'-lm','-o',str(D/'measure_attributes')]
subprocess.run(cmd,check=True)
source_start={str(p):sha(p) for p in [*sources,R/'private-build/transport/bounce.c',R/'private-build/transport/bounce.h']};rows=[];pins={}; pin=lambda p:pins.setdefault(str(Path(p).relative_to(W)),sha(p))
for arm in ('off','on'):
 folder=B/f'actual-{arm}-001';completed=json.loads((folder/'COMPLETED.json').read_text());assert completed['status']=='ALL20_EXACT_COMPLETE' and len(completed['frames'])==20;pin(folder/'COMPLETED.json')
 for frame in completed['frames']:
  name=frame['name'];snapshot=folder/(name+'.snapshot');report=folder/(name+'.json');command=folder/(name+'.command.json')
  for ext in ('.snapshot','.json'):assert sha(folder/(name+ext))==frame['files'][ext]
  c=json.loads(command.read_text());model=Path(c['command'][1]);assert sha(model)==c['runtimeInputs'][str(model)]
  ground=Path(c['environment']['HONE_GROUND_FILE']);assert sha(ground)==c['runtimeInputs'][str(ground)]
  assert list(map(int,ground.read_text().split()[13:19]))==[0,1,3,0,3,2]
  for p in (snapshot,report,command,model,ground):pin(p)
  result=subprocess.run([str(D/'measure_attributes'),str(snapshot),str(model),c['command'][3]],check=True,capture_output=True,text=True);x=json.loads(result.stdout);old=json.loads(report.read_text());assert x['materialFingerprint']==old['materialFingerprint'];assert old['transportSceneBytes']==x['sceneBytes']==28592 and old['transportTemporaryBytes']==100224
  x.update(arm=arm,case=name,baselineMaterialFingerprintExact=True,snapshotSHA256=sha(snapshot),compiledMetadataSHA256=sha(model));rows.append(x)
assert all(sha(p)==h for p,h in source_start.items())
assert all(sha(W/p)==h for p,h in pins.items())
headers=[R/'private-build/transport/bounce.c',R/'private-build/transport/bounce.h',R/'private-build/visibility/visibility.h',R/'private-build/physical/fox_disk_lighting.h',R/'private-build/product/main/ayatsuri/compact_opaque.h',D/'run_measure.py',B/'private-build/product/main/ayatsuri/ayatsuri_model.c',B/'harness/native_render_row.c']
report={'status':'ALL40_BUILD_ONLY_EXACT','actualFrames':0,'attributeSnapshotCases':40,'allUniqueVertices':774,'allBuiltBytes':28592,'allCallerVertices':1167,'allCallerTriangles':1566,'allCallerInputBytes':35868,'allBaselineMaterialFingerprintsExact':True,'allRawVerticesReferenced':True,'queryMsRange':[min(r['queryMs'] for r in rows),max(r['queryMs'] for r in rows)],'buildMsRange':[min(r['buildMs'] for r in rows),max(r['buildMs'] for r in rows)],'scope':'Actual completed snapshot attributes decoded with frozen codec; compiled model metadata read only for node order, counts, triangle IDs, sidedness. No model evaluation or render. All original vertices referenced, so codec ascending remap is identity. Snapshot triangle ID sets verified, reversing snapshot face order when baseline command specifies reverse; canonical raw corner order restored from metadata. Direct per-corner decoded legacy64 stream equals indexed stream and owned stream after poison/free, and all40 historical material fingerprints. Synthetic repeated visibility geometry and synthetic lights isolate attribute builder; ground attributes canonical, ground mode off for this ownership-only build. Timings are descriptive host query/build only, no speed or device fit claim. No expanded100224 array or raw output arrays.','command':cmd,'inputPins':pins,'sourceHashes':{str(p.relative_to(W)):sha(p) for p in [*sources,*headers]},'binarySHA256':sha(D/'measure_attributes'),'observedUTC':datetime.datetime.now(datetime.timezone.utc).isoformat(),'cases':rows}
(D/'MEASUREMENT.json').write_text(json.dumps(report,indent=2)+'\n');(D/'ATTRIBUTES.txt').write_text('ALL40_BUILD_ONLY_EXACT\n40 completed baseline snapshot cases; no render or model evaluation.\n1167 vertices *20 +1566 triangles *8 =35868 caller bytes.\n774 referenced unique complete vertices;28592 owned bytes.\nAll40 streamed legacy64 material fingerprints match baseline.\nFull vertex/corner bytes and side flags exact, including after caller poison/free.\nSee MEASUREMENT.json for caveats, pins, source/binary hashes, and descriptive query/build times.\n');print(report['status'],report['queryMsRange'],report['buildMsRange'])
