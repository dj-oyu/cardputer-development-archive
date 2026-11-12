import pathlib,subprocess,json,os
W=pathlib.Path('/workspace/scratch/6d8dcdbcdc54/fox-v3-pixel-visibility');R=W/'on-004';O=pathlib.Path('/tmp/pixel-visibility-independent');M=R/'product/main';exe=O/'render';cmd=['cc','-std=c11','-O2','-g','-fsanitize=address,undefined','-fno-omit-frame-pointer','-ffp-contract=off','-fexcess-precision=standard','-I',str(M),'-I',str(R/'physical'),'-I',str(R/'visibility'),str(R/'visibility/visibility.c'),str(R/'visibility/pixel_binding.c'),str(R/'code/native_render.c'),str(R/'physical/fox_disk_lighting.c'),*[str(M/x) for x in ['ayatsuri/ayatsuri_model.c','ayatsuri/ayatsuri_visibility.c','ayatsuri/compact_opaque.c','ui/kasane/ksn_mesh_depth.c','ui/kasane/ksn_procedural.c']],'-lm','-o',str(exe)];subprocess.run(cmd,check=True)
env=os.environ.copy();env.update(ASAN_OPTIONS='detect_leaks=0:abort_on_error=1',UBSAN_OPTIONS='halt_on_error=1',HONE_LINEAR_LIGHT='1',HONE_PHYSICAL_LIGHT='1');count=0
for arm,mode in [('off','0'),('on','1')]:
 r=W/(arm+'-004');cfg=json.loads((r/'inputs/candidate-config.json').read_text());env['HONE_PIXEL_LIGHT']='1';env['HONE_PIXEL_VISIBILITY']=mode
 for s in cfg['scenarios']:
  env['HONE_DISK_FILE']=str(r/('physical-'+s['name']+'.txt'))
  for cam in cfg['cameras']:
   for rev in [0,1]:
    name='native-'+cam['name']+'-'+s['name']+('-reverse' if rev else '');out=O/(arm+'-'+name)
    c=[str(exe),str(r/('model-'+s['name'])/'model.aynm'),str(out),str(rev),*map(str,cam['nativeCamera']),*map(str,s['nativeDirection']+s['intensity'])]
    p=subprocess.run(c,env=env,capture_output=True,text=True);assert p.returncode==0,(p.returncode,p.stderr);(O/(arm+'-'+name+'.json')).write_text(p.stdout+p.stderr)
    for ext in ['.u16le','.f32le']:assert pathlib.Path(str(out)+ext).read_bytes()==(r/(name+ext)).read_bytes();count+=1
(O/'results.json').write_text(json.dumps({'actualCFrames':40,'buffersExact':count,'O2_ASan_UBSan':'PASS','leakSanitizer':'unavailable; disabled','oldProductOrReferenceChanged':False},indent=2));print('PASS',count)
