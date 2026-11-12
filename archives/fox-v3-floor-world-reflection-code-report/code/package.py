from pathlib import Path
import hashlib,json,zipfile
R=Path(__file__).resolve().parents[1];sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()
root_names=['PLAN.md','REPORT.md','GATE_REPORT.md','GATE_TEST_FREEZE.json','SOURCE_DIFF.json','STACK_RESOURCES.json','RESOURCE_SUMMARY.json','BASELINE_PINS.json','BASELINE_OUTPUT_PINS.json','COMPLETION_PINS.json','BUNDLE_README.md']
allowed=set(root_names)
for folder in ['code','tests']:
 for p in (R/folder).iterdir():
  if p.is_file() and p.suffix in ['.c','.py','.sh','.log']:allowed.add(str(p.relative_to(R)))
for p in ['transport/bounce.c','transport/bounce.h','transport/pixel_transport.c','transport/pixel_transport.h','code/native_render_v2.c','code/aa_adapter.h','code/floor_world_adapter.h','product/main/ui/kasane/ksn_mesh_depth.c','product/main/ui/kasane/ksn_boundary_aa_center.inc','floor-tests/test_floor.c','floor-tests/test_pixel_floor.c','tests/test_boundary_aa.c','tests/test_hidden_failure.c','tests/test_rho_affine.c','SOURCE_FREEZE.json']:
 allowed.add('capture/'+p)
for directory in ['capture/off','capture/on','composed-off','composed-on']:
 for name in ['COMPLETED.json','INPUT_PINS.json']:
  allowed.add(directory+'/'+name)
 if directory.startswith('composed'):allowed.add(directory+'/COST.json')
for p in (R/'analysis-code').iterdir():
 if p.is_file() and p.suffix in ['.py','.md','.txt']:allowed.add(str(p.relative_to(R)))
a=R/'analysis-code/analysis-001';manifest=json.load(open(a/'COMPLETED.json'));assert manifest['codeAggregateOnly'] and manifest['status']=='WORLD_REFLECTION_METRICS_COMPLETE_NOT_GLOBAL_ACCEPTANCE'
for name,meta in manifest['files'].items():
 p=a/name;assert p.parent==a and sha(p)==meta['sha256'];allowed.add(str(p.relative_to(R)))
allowed.add('analysis-code/analysis-001/COMPLETED.json')
for p in (R/'reviews').rglob('*'):
 if p.is_file() and p.suffix in ['.c','.py','.json','.md','.log']:allowed.add(str(p.relative_to(R)))
for name in ['capture-off.log','capture-on.log','compose-off.log','compose-on.log']:allowed.add(name)
assert not any(x in p for p in allowed for x in ['.f64le','.f32le','.u16le','.u8','.snapshot','.jsonl','.blend','.aynm','.png','.jpg','.lut','/private/','/compiled/','/inputs/','__pycache__'])
for p in allowed:assert (R/p).is_file() and not (R/p).is_symlink()
# Recheck the completed sources and all four outputs before sealing.
freeze=json.load(open(R/'capture/SOURCE_FREEZE.json'));assert all(sha(R/'capture'/p)==h for p,h in freeze['files'].items());assert sha(R/'capture/native-render')==freeze['binarySHA256']
completion=json.load(open(R/'COMPLETION_PINS.json'));assert all(sha(p)==h for p,h in completion['files'].items())
(R/'BUNDLE_ALLOWLIST.txt').write_text('\n'.join(sorted(allowed|{'BUNDLE_ALLOWLIST.txt','BUNDLE_MANIFEST.json'}))+'\n');allowed.add('BUNDLE_ALLOWLIST.txt')
files={p:{'bytes':(R/p).stat().st_size,'sha256':sha(R/p)} for p in sorted(allowed)}
bundle_manifest={'status':'PRIVATE_CODE_AGGREGATE_ONLY','excludes':['source geometry','private model/inputs','snapshots','raw sample records','HDR/depth/RGB images','LUT data','executables'],'files':files,'sourceFreezeSHA256':sha(R/'capture/SOURCE_FREEZE.json'),'completionPinsSHA256':sha(R/'COMPLETION_PINS.json'),'formalCompletionSHA256':sha(a/'COMPLETED.json'),'noUpload':True}
(R/'BUNDLE_MANIFEST.json').write_text(json.dumps(bundle_manifest,indent=2)+'\n');allowed.add('BUNDLE_MANIFEST.json')
out=R.parent/'fox-v3-floor-world-reflection-code-report.zip';assert not out.exists()
with zipfile.ZipFile(out,'w',compression=zipfile.ZIP_DEFLATED,compresslevel=9) as z:
 for p in sorted(allowed):
  info=zipfile.ZipInfo(p,date_time=(2026,11,4,0,0,0));info.compress_type=zipfile.ZIP_DEFLATED;info.external_attr=0o600<<16;z.writestr(info,(R/p).read_bytes())
with zipfile.ZipFile(out) as z:
 assert z.testzip() is None and set(z.namelist())==allowed
 for p in allowed:assert hashlib.sha256(z.read(p)).hexdigest()==sha(R/p)
result={'path':str(out),'bytes':out.stat().st_size,'sha256':sha(out),'entries':len(allowed),'manifestSHA256':sha(R/'BUNDLE_MANIFEST.json'),'privateCodeAggregateOnly':True,'zipReadbackExact':True,'uploaded':False};(R/'BUNDLE_RESULT.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))
