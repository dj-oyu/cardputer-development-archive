#!/usr/bin/env python3
"""Offline host-only replay. Fresh output required; source never saved. No network."""
import argparse,pathlib,json,hashlib,subprocess,os,sys
ROOT=pathlib.Path(__file__).resolve().parents[1]
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def run(args,log,env=None):
 with open(log,'w') as f:subprocess.run(list(map(str,args)),stdout=f,stderr=subprocess.STDOUT,check=True,env=env)
def input_hashes():
 return {str(p.relative_to(ROOT)):sha(p) for d in ['code','product','importer'] for p in (ROOT/d).rglob('*') if p.is_file() and '__pycache__' not in p.parts}
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--config',type=pathlib.Path,required=True);ap.add_argument('--out',type=pathlib.Path,required=True);a=ap.parse_args();out=a.out.resolve();out.mkdir(parents=True,exist_ok=False)
 inputs_before=input_hashes();(out/'input-hashes-start.json').write_text(json.dumps(inputs_before,indent=2));cfg=json.loads(a.config.read_text());source=pathlib.Path(cfg['source']);assert sha(source)==cfg['sourceSha256'],'SOURCE_HASH';cfg['output']=str(out)
 prov=json.loads((ROOT/'product-provenance.json').read_text())
 for r in prov['files']:
  b=(ROOT/'product'/r['path']).read_bytes();assert hashlib.sha1(b'blob '+str(len(b)).encode()+b'\0'+b).hexdigest()==r['gitBlob'],r['path']
 manifest=out/'manifest.json';manifest.write_text(json.dumps(cfg,indent=2));run(['/usr/bin/blender','-b','-t','8','--python',ROOT/'code/blender_render.py','--',manifest],out/'blender.log')
 assert sha(source)==cfg['sourceSha256'],'SOURCE_CHANGED'
 main=ROOT/'product/main';native=out/'native-render'
 run(['cc','-std=c11','-O2','-Wall','-Wextra','-Werror','-Wno-misleading-indentation','-ffp-contract=off','-fexcess-precision=standard','-I',main,ROOT/'code/native_render.c',*[main/p for p in ['ayatsuri/ayatsuri_model.c','ayatsuri/ayatsuri_visibility.c','ayatsuri/compact_opaque.c','ui/kasane/ksn_mesh_depth.c','ui/kasane/ksn_procedural.c']],'-lm','-o',native],out/'build.log')
 env=dict(os.environ,ASSET_IMPORTER=str(ROOT/'importer/import_glb.cjs'),ASSET_REDUCER=str(ROOT/'importer/reduce.cjs'),MODEL_COMPILER=str(ROOT/'product/tools/ayatsuri/model/pack_model.cjs'))
 for s in cfg['scenarios']:
  param=out/(s['name']+'.json');param.write_text(json.dumps(s));modeldir=out/('model-'+s['name'])
  run(['node',ROOT/'code/compile.cjs',out/'fox-auto1200.glb',modeldir,param],out/('compile-'+s['name']+'.log'),env)
  # Import basis Blender(x,y,z) -> model(x,-z,-y), scale only affects positions.
  x,y,z=s['blenderLight'];light=[x,-z,-y]+s['intensity']
  for c in cfg['cameras']:
   for reverse in [0,1]:
    prefix=out/('native-'+c['name']+'-'+s['name']+('-reverse' if reverse else ''))
    run([native,modeldir/'model.aynm',prefix,reverse,*c['nativeCamera'],*light],str(prefix)+'.json')
    m=json.loads(pathlib.Path(str(prefix)+'.json').read_text())
    assert all(abs(x-y)<=1e-5 for x,y in zip(m['camera'],c['nativeCamera'])),'CAMERA_ECHO'
    assert all(abs(x-y)<=1e-6 for x,y in zip(m['light'],light)),'LIGHT_ECHO'
 # Runtime rejects malformed camera; not an image quality check.
 c=cfg['cameras'][0];s=cfg['scenarios'][0];bad=subprocess.run([str(native),str(out/'model-unlit/model.aynm'),str(out/'invalid'), '0','nan',*map(str,c['nativeCamera'][1:]),'1','0','0','1','1','1'],capture_output=True,text=True)
 assert bad.returncode!=0 and 'NATIVE_GATE:evaluate' in bad.stderr,'NAN_REJECTION'
 assert inputs_before==input_hashes(),'INPUT_CHANGED_DURING_RUN'
 (out/'provenance.json').write_text(json.dumps({'product':prov,'sourceHashAfter':sha(source),'code':{p.name:sha(p) for p in (ROOT/'code').iterdir() if p.is_file()},'importerPin':'76796a5c5ae53505de7de4f79b8e205ea1dc9c19','importer':{p.name:sha(p) for p in (ROOT/'importer').iterdir() if p.is_file()},'scope':'actual a426 production C model evaluator and depth raster, HOST adapter; no Pocket JS lifecycle or device'},indent=2))
 run(['cc','-std=c11','-O2','-Wall','-Wextra','-Werror','-ffp-contract=off','-I',main,ROOT/'code/test_boundary.c',main/'ui/kasane/ksn_mesh_depth.c',main/'ui/kasane/ksn_procedural.c',main/'ayatsuri/compact_opaque.c','-lm','-o',out/'boundary-test'],out/'boundary-build.log')
 run([out/'boundary-test'],out/'boundary.log')
 run([sys.executable,ROOT/'code/test_detector.py',out/'negative-fixtures',native],out/'negative.log')
 run([sys.executable,ROOT/'code/analyze.py',out],out/'analysis.log')
 assert inputs_before==input_hashes(),'INPUT_CHANGED_DURING_RUN'
 assert sha(source)==cfg['sourceSha256'],'SOURCE_CHANGED'
 report=json.loads((out/'report.json').read_text());print(json.dumps({'report':str(out/'report.json'),'functionalPass':report['functionalPass'],'artQuality':report['artQuality']}));sys.exit(3 if report['functionalPass'] else 2)
if __name__=='__main__':main()
