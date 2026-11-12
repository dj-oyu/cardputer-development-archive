"""Host-only actual one-bounce raster HDR capture; ten fresh processes, no display edits."""
from pathlib import Path
import hashlib,json,os,struct,subprocess,sys,time,math
R=Path(__file__).resolve().parent
W=R.parent
BASE=W/'fox-v3-lid-evaluation/actual-lid8-v2'
REF=W/'fox-reference-uncertainty-v3'
sys.path.insert(0,str(R/'code'))
from geometry_certificate import verify,runtime
from codec_audit import audit
PIN='a18011982c6e2338368a9e5bafacec6af5a5bad1c1206d05640cb075fcdb62c3'
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def tree(root): return sorted(p for p in root.rglob('*') if p.is_file() and '__pycache__' not in p.parts)
def main():
 if len(sys.argv)!=3 or sys.argv[2]!='--reviewer-contract-closed':
  raise SystemExit('Usage: observe.py FRESH_OUTPUT --reviewer-contract-closed (only after explicit reviewer closure)')
 out=Path(sys.argv[1]).resolve();out.mkdir(exist_ok=False,parents=True)
 cert=verify(BASE,PIN);contract=json.loads((BASE/'inputs/codec-contract.json').read_text());cfg=json.loads((BASE/'inputs/candidate-config.json').read_text())
 rc=json.loads((REF/'input/config.json').read_text())
 source=Path(rc['source'])
 assert sha(source)==cfg['sourceSHA256']
 assert sha(REF/'input/config.json')==cfg['referenceConfigSHA256']
 assert cfg['transportMode']==2 and cfg['outerSamples']==16
 assert len(cfg['cameras'])==2
 # Freeze all copied sources and all frozen baseline/model/reference input artifacts.
 paths=set([R/'observe.py',R/'copy-origin-hashes.json',R/'PLAN.md',source])
 for d in ['code','product','physical','visibility','transport']: paths.update(tree(R/d))
 paths.update(tree(BASE));paths.update(tree(REF)) # Reference artifacts are hashed only, never fed to renderer.
 paths=sorted(paths)
 before={str(p):sha(p) for p in paths}
 (out/'input-hashes-before.json').write_text(json.dumps(before,indent=2)+'\n')
 main_dir=R/'product/main';binary=out/'native-render'
 cmd=['cc','-std=c11','-O2','-Wall','-Wextra','-Werror','-Wno-misleading-indentation','-ffp-contract=off','-fexcess-precision=standard',
      '-I',str(R/'code'),'-I',str(main_dir),'-I',str(R/'physical'),'-I',str(R/'visibility'),'-I',str(R/'transport'),
      str(R/'code/native_render.c'),str(R/'code/point_observer.c'),str(R/'transport/bounce.c'),str(R/'transport/pixel_transport.c'),
      str(R/'physical/fox_disk_lighting.c'),str(R/'visibility/visibility.c'),str(R/'visibility/pixel_binding.c'),
      *[str(main_dir/p) for p in ['ayatsuri/ayatsuri_model.c','ayatsuri/ayatsuri_visibility.c','ayatsuri/compact_opaque.c','ui/kasane/ksn_mesh_depth.c','ui/kasane/ksn_procedural.c']],'-lm','-o',str(binary)]
 (out/'compile-command.json').write_text(json.dumps(cmd,indent=2)+'\n')
 with (out/'build.log').open('w') as log: subprocess.run(cmd,stdout=log,stderr=subprocess.STDOUT,check=True)
 (out/'build.json').write_text(json.dumps({'command':cmd,'binarySHA256':sha(binary)},indent=2)+'\n')
 frames=[];start=time.monotonic()
 for camera in cfg['cameras']:
  for name in ['baseline','direction']:
   case=next(s for s in cfg['scenarios'] if s['name']==name)
   prefix=out/f"native-{camera['name']}-{name}"
   env=dict(os.environ,HONE_LINEAR_LIGHT='1',HONE_PHYSICAL_LIGHT='1',HONE_PIXEL_LIGHT='1',HONE_PIXEL_VISIBILITY='1',HONE_TRANSPORT_MODE='2',HONE_OUTER_SAMPLES='16',HONE_DISK_FILE=str(BASE/f'physical-{name}.txt'),HONE_NORMAL_PAIR_CODEC='1',HONE_GROUND_MODE='2',HONE_GROUND_FILE=str(BASE/case['ground']['inputFile']))
   args=[str(binary),str(BASE/f'compiled/model-{name}/model.aynm'),str(prefix),'0',*map(str,camera['nativeCamera']),*map(str,case['nativeDirection']+case['intensity'])]
   proc=subprocess.run(args,check=True,capture_output=True,text=True,env=env)
   Path(str(prefix)+'.json').write_text(proc.stdout);Path(str(prefix)+'.stderr').write_text(proc.stderr)
   meta=json.loads(proc.stdout);runtime(meta,cert);audit(Path(str(prefix)+'.snapshot').read_bytes(),contract,1,camera['name'],name,False,meta)
   old=json.loads((BASE/(prefix.name+'.json')).read_text())
   for k,v in old.items():
    if k.endswith('Ns') or k=='hostRenderNsFirstFrame':continue
    assert meta[k]==v,(prefix.name,k)
   assert Path(str(prefix)+'.snapshot').read_bytes()==(BASE/(prefix.name+'.snapshot')).read_bytes()
   assert meta['transportMode']==2 and meta['transportComplete'] and meta['outerSamples']==16 and meta['innerSamples']==16
   assert meta['visibilityEnabled'] and meta['visibilityComplete'] and meta['pixelLightEnabled'] and not meta['agxProfileEnabled']
   for ext in ['.u16le','.f32le']:
    assert Path(str(prefix)+ext).read_bytes()==(BASE/(prefix.name+ext)).read_bytes(),prefix.name+ext+' differs from actual-lid8-v2'
   hdr=Path(str(prefix)+'-combined.f64le');assert hdr.read_bytes()==(W/'fox-v3-lid-display-combination/run-001'/hdr.name).read_bytes(),'HDR control differs';assert hdr.stat().st_size==135*240*3*8
   values=struct.unpack('<97200d',hdr.read_bytes());assert all(math.isfinite(v) and v>=0 for v in values)
   depth=struct.unpack('<32400f',Path(str(prefix)+'.f32le').read_bytes())
   assert all(all(values[3*i+k]==0 for k in range(3)) for i,d in enumerate(depth) if d==float('-inf'))
   files=[Path(str(prefix)+ext) for ext in ['.u16le','.f32le','-combined.f64le','-winners.json','-mapping.json','.json','.stderr']]
   frames.append({'view':camera['name'],'case':name,'command':args,'files':{p.name:sha(p) for p in files},'maximumHDR':max(values),'metadata':meta})
 assert len(frames)==4;verify(BASE,PIN)
 after={str(p):sha(p) for p in paths}
 (out/'input-hashes-after.json').write_text(json.dumps(after,indent=2)+'\n')
 assert before==after,'Input/source/model/reference mutation'
 result={'frames':frames,'rgbDepthAllExactBaseline':True,'allFourSnapshotsExact':True,'allNonTimingMetadataExact':True,'baselineGeometryCertificateSHA256':PIN,'inputsUnchanged':True,'finiteNonnegativeHDR':True,'zeroBackground':True,'observerStaticBytes':json.loads(Path(str(prefix)+'-winners.json').read_text())['observerStaticBytes'],'oneProcessOneFrame':True,'wallSecondsFourProcesses':time.monotonic()-start,'scope':'Actual preclamp current bounce shader result at raster depth winners; no recomputation, AgX, filtering, image inputs, upload, or product feature changes'}
 (out/'COMPLETED.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result))
if __name__=='__main__':main()
