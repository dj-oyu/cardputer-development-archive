from pathlib import Path
import json,os,subprocess,hashlib,time,sys
R=Path(__file__).resolve().parent;W=R.parent;BASE=W/'fox-v3-pixel-visibility/on-004';out=Path(sys.argv[1]).resolve();out.mkdir(exist_ok=False,parents=True)
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
cfg=json.loads((BASE/'inputs/candidate-config.json').read_text());paths=[p for d in ['code','product','physical','visibility'] for p in (R/d).rglob('*') if p.is_file() and p.suffix in ['.c','.h']]+[R/'observe.py',R/'PLAN.md',BASE/'candidate-manifest.json',BASE/'inputs/candidate-config.json',W/'fox-reference-uncertainty-v3/input/config.json']
for c in ['baseline','direction']:paths += [BASE/f'model-{c}/model.aynm',BASE/f'physical-{c}.txt']
paths+=[Path(json.loads((W/'fox-reference-uncertainty-v3/input/config.json').read_text())['source'])]
hashes={str(p):sha(p) for p in paths};(out/'input-hashes.json').write_text(json.dumps(hashes,indent=2))
main=R/'product/main';binary=out/'native-render';cmd=['cc','-std=c11','-O2','-Wall','-Wextra','-Werror','-Wno-misleading-indentation','-ffp-contract=off','-fexcess-precision=standard','-I',str(main),'-I',str(R/'physical'),'-I',str(R/'visibility'),str(R/'code/native_render.c'),str(R/'physical/fox_disk_lighting.c'),str(R/'visibility/visibility.c'),str(R/'visibility/pixel_binding.c'),*[str(main/p) for p in ['ayatsuri/ayatsuri_model.c','ayatsuri/ayatsuri_visibility.c','ayatsuri/compact_opaque.c','ui/kasane/ksn_mesh_depth.c','ui/kasane/ksn_procedural.c']],'-lm','-o',str(binary)]
subprocess.run(cmd,check=True);(out/'build.json').write_text(json.dumps({'command':cmd,'binarySHA256':sha(binary)},indent=2));frames=[];start=time.time()
for cam in cfg['cameras']:
 for c in ['baseline','direction']:
  case=next(s for s in cfg['scenarios'] if s['name']==c);prefix=out/f"native-{cam['name']}-{c}";env=dict(os.environ,HONE_LINEAR_LIGHT='1',HONE_PIXEL_LIGHT='1',HONE_PIXEL_VISIBILITY='1',HONE_DISK_FILE=str(BASE/f'physical-{c}.txt'))
  p=subprocess.run([str(binary),str(BASE/f'model-{c}/model.aynm'),str(prefix),'0',*map(str,cam['nativeCamera']),*map(str,case['nativeDirection']+case['intensity'])],check=True,capture_output=True,text=True,env=env);meta=json.loads(p.stdout);(Path(str(prefix)+'.json')).write_text(p.stdout);assert meta['visibilityComplete'] and meta['visibilityEnabled']
  for ext in ['.u16le','.f32le']:assert Path(str(prefix)+ext).read_bytes()==(BASE/(prefix.name+ext)).read_bytes()
  files=[Path(str(prefix)+e) for e in ['.u16le','.f32le','-combined.f64le','-world.f64le','-area.f64le']];assert all(p.stat().st_size==777600 for p in files[2:]);frames.append({'view':cam['name'],'case':c,'files':{p.name:sha(p) for p in files},'metadata':meta})
assert all(sha(Path(p))==h for p,h in hashes.items());j={'frames':frames,'rgbDepthAllExact004':True,'inputsUnchanged':True,'observerGlobalBytes':2332800,'wallSecondsFourProcess':time.time()-start,'scope':'diagnostic actual shader HDR only; no feature change or product fit'};(out/'COMPLETED.json').write_text(json.dumps(j,indent=2));print(json.dumps(j))
