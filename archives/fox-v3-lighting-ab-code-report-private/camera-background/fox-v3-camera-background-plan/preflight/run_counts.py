#!/usr/bin/env python3
"""Pinned geometry-only preparation. No RGB/image/reference pixels are opened.
The old samples stream is consumed only for geometry keys, never linearRGB/rho.
"""
import argparse,hashlib,json,math,pathlib,struct,subprocess,time
HERE=pathlib.Path(__file__).resolve().parent
ROOT=HERE.parents[1]
CORE=ROOT/'fox-v3-boundary-rho-affine-core-A'
A2=ROOT/'fox-v3-boundary-rho-affine-evaluation/actual-A2'
AUDIT=ROOT/'fox-v3-camera-source-audit/summary.json'
AUDIT_SHA='97ad99ed02297b3c8cc4b0fa0c425c74196cdcf5478a3e21c35323d6ba283d1b'
def sha(p):return hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest()
def dump(p,d):p.write_text(json.dumps(d,indent=2,allow_nan=False)+'\n')
def f32(x):return struct.unpack('<f',struct.pack('<f',x))[0]
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--output',required=True);ap.add_argument('--run',action='store_true');a=ap.parse_args();out=pathlib.Path(a.output).resolve();assert not out.exists(),'Choose fresh result root';out.mkdir(parents=True);private=out/'private-geometry-inputs';private.mkdir()
 assert sha(AUDIT)==AUDIT_SHA,'audited source camera changed'
 audit=json.loads(AUDIT.read_text());corefreeze=json.loads((CORE/'SOURCE_FREEZE.json').read_text())
 for name,h in corefreeze['productionFiles'].items():assert sha(CORE/name)==h,('core source changed',name)
 outputs=json.loads((A2/'ACTUAL_OUTPUT_FREEZE.json').read_text())['files'];groundpath=A2/'inputs/ground-source.json';ground=json.loads(groundpath.read_text());rho_by_case={c['name']:c['actualGroundBaseColor'][:3] for c in ground['scenarios']}
 input_pins={str(AUDIT.relative_to(ROOT)):AUDIT_SHA,str(groundpath.relative_to(ROOT)):sha(groundpath),str((CORE/'SOURCE_FREEZE.json').relative_to(ROOT)):sha(CORE/'SOURCE_FREEZE.json'),str((A2/'ACTUAL_OUTPUT_FREEZE.json').relative_to(ROOT)):sha(A2/'ACTUAL_OUTPUT_FREEZE.json')}
 identity=A2/'private/identity.bin';input_pins[str(identity.relative_to(ROOT))]=sha(identity);rows=[]
 for view in ['front','oblique']:
  sc=audit['configuredReferenceCameras'][view]['recordedCamera'];m=sc['cameraMatrix'];origin=[m[k][3] for k in range(3)];raw=[-m[k][2] for k in range(3)];length=math.hypot(*raw);forward=[v/length for v in raw];near,far=sc['clip'];assert 0<near<far
  ledger=A2/f'ledger-{view}.txt';input_pins[str(ledger.relative_to(ROOT))]=sha(ledger)
  for case in ['baseline','direction','intensity','ambient','albedo']:
   for reverse in [False,True]:
    stem=f'native-{view}-{case}'+('-reverse' if reverse else '');prefix=A2/'on/private-partial'/stem
    paths={suffix:pathlib.Path(str(prefix)+suffix) for suffix in ['.json','.aa.json','.snapshot','.f32le','.targets.u8','.samples.jsonl']}
    for p in paths.values():rel=str(p.relative_to(A2));h=sha(p);assert rel in outputs and h==outputs[rel],('frozen actual artifact mismatch',rel);input_pins[str(p.relative_to(ROOT))]=h
    actual=json.loads(paths['.json'].read_text());aa=json.loads(paths['.aa.json'].read_text());assert actual['groundMode']==2 and aa['complete'] is True
    camera=[f32(v) for v in actual['camera']];values=camera+origin+forward+[near,far]+[v for p in ground['worldVertices'] for v in p]
    text=['FOXCAMCOUNT1']+[format(v,'.17g') for v in values]+[str(v) for tri in ground['triangles'] for v in tri]+[format(v,'.17g') for v in rho_by_case[case]]+[str(actual[k]) for k in ['visibilityRays','visibilityNodeVisits','visibilityTriangleTests']]
    config=private/(stem+'.config');config.write_text('\n'.join(text)+'\n')
    # Only these geometry fields are admitted. HDR RGB and rho are never consumed.
    sanitized=private/(stem+'.geometry.txt');sample_count=0
    with paths['.samples.jsonl'].open() as source,sanitized.open('w') as dst:
     for line in source:
      e=json.loads(line);fields=[e['x'],e['y'],e['sample'],int(e['hit']),e['recordOffset'],e['node'],e['face'],int(e['back']),e['sourceId']]
      depth=float('-inf') if not e['hit'] else f32(e['depth']);nums=[depth]+e['P']+e['Ns'];dst.write(' '.join(map(str,fields))+' '+' '.join(format(v,'.17g') for v in nums)+'\n');sample_count+=1
    assert sample_count==4*aa['targets']
    rows.append({'name':stem,'view':view,'case':case,'reverse':reverse,'snapshotSHA256':sha(paths['.snapshot']),'cameraFloat32':camera,'sourceOrigin':origin,'sourceUnitView':forward,'clip':[near,far],'oldDirect':{k:actual[k] for k in ['visibilityRays','visibilityNodeVisits','visibilityTriangleTests']},'expectedTargets':aa['targets'],'expectedSampleChecks':sample_count,'configSHA256':sha(config),'geometryOnlyStreamSHA256':sha(sanitized),'argv':[str(HERE/'count-background'),str(paths['.snapshot']),str(identity),str(ledger),str(config),str(sanitized),str(paths['.f32le']),str(paths['.targets.u8']),str(int(view=='oblique'))]})
 manifest={'scope':'geometry and positive-kernel counts only; no shadow tracing, transport or image input/output','sourceCameraAuditSHA256':AUDIT_SHA,'inputPins':input_pins,'cases':rows,'privateInputDirectoryNotForBundle':str(private),'formula':'Q32/t32 from native mesh_packet identity-world exact float ops; invert Q32, camera plane d=projection32(nativeCamera); source clip axial=(P-sourceOrigin) dot sourceUnitView; exact float native depth comparison'};dump(out/'INPUT_FREEZE.json',manifest)
 if not a.run:print('PREPARED_ONLY',out);return
 assert (HERE/'count-background').is_file();t0=time.perf_counter();results=[]
 for row in rows:
  p=subprocess.run(row['argv'],capture_output=True,text=True);(out/(row['name']+'.stderr')).write_text(p.stderr)
  if p.returncode:dump(out/'FAILED.json',{'case':row['name'],'returncode':p.returncode,'stderr':p.stderr,'completedCases':len(results)});raise RuntimeError('geometry preflight failed: '+row['name'])
  r=json.loads(p.stdout);assert r['geometryControlExact'] is True and r['geometrySampleChecks']==row['expectedSampleChecks'];assert r['orderingSlots']==32400+row['expectedSampleChecks'];assert r['backgroundOnly']['slots']==32400+3*row['expectedTargets'];r['name']=row['name'];dump(out/(row['name']+'.json'),r);results.append(r);dump(out/'progress.json',{'completed':len(results),'last':r})
 for name,h in input_pins.items():assert sha(ROOT/name)==h,('input changed during preparation',name)
 dump(out/'COMPLETED.json',{'geometryOnly':True,'actualShadowTracing':False,'physicalRenderExecuted':False,'cases':results,'preparationWallSeconds':time.perf_counter()-t0,'all20Complete':len(results)==20,'allGeometryExact':all(r['geometryControlExact'] for r in results),'allFloorOrderFits':all(r['floorOrderingFits'] for r in results),'allCombinedDirectRayFits':all(r['combinedDirectRayFits'] for r in results),'allBackgroundOnlyDirectRayFits':all(r['backgroundOnlyDirectRayFits'] for r in results),'nodeTriangleAdmissionProved':False})
 print('COUNTS_COMPLETE',out)
if __name__=='__main__':main()
