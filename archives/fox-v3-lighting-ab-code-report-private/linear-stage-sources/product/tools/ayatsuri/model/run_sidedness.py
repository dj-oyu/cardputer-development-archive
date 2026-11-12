"""Local synthetic and paired legacy compatibility checks; no downloads/device.
Baseline ref may be a426f7a (public) or its equal-tree local f7d7fe6c.
"""
from pathlib import Path
import argparse,os,subprocess,tempfile,hashlib,sys
ROOT=Path(__file__).resolve().parents[3]
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--baseline-ref',default='f7d7fe6c5c7588ac7e1a8a4afa0fec6e8525ed85');p.add_argument('--legacy-input',action='append',default=[]);p.add_argument('--opt',choices=['0','2'],default='2');args=p.parse_args()
env=dict(os.environ,ASAN_OPTIONS='detect_leaks=1:abort_on_error=1',UBSAN_OPTIONS='halt_on_error=1:print_stacktrace=1')
cache=ROOT/'.cache/sidedness';cache.mkdir(parents=True,exist_ok=True)
def run(cmd):
 print('+', ' '.join(map(str,cmd)),flush=True);subprocess.run(list(map(str,cmd)),cwd=ROOT,env=env,check=True)
flags=['-I',str(ROOT/'main/ayatsuri'),'-std=gnu11','-O'+args.opt,'-ffp-contract=off','-fsanitize=address,undefined','-fno-omit-frame-pointer','-DQUICKJS_NG_BUILD','-D_GNU_SOURCE','-DKSN_PROC_HOST_TEST']
with tempfile.TemporaryDirectory(prefix='sidedness-baseline-') as tmp:
 base=Path(tmp);old=base/'main';(old/'ayatsuri').mkdir(parents=True);(old/'pocket').mkdir()
 for name in ['main/ayatsuri/ayatsuri_model.c','main/ayatsuri/ayatsuri_model.h','main/pocket/pocket_shape.c','main/pocket/pocket_ayatsuri_model.inc','tools/ayatsuri/model/pack_model.cjs','main/ayatsuri/compact_opaque.c']:
  data=subprocess.check_output(['git','show',args.baseline_ref+':'+name],cwd=ROOT)
  expected={'main/ayatsuri/ayatsuri_model.c':'58813122b061a7ae5c63d198675fa80d192ed9ff','main/ayatsuri/ayatsuri_model.h':'bbeeb2e1ef6313aee185e2b6817d228c85f6a741','main/pocket/pocket_shape.c':'26137d955defb0a38ec012626d5c3120fd1a445e','main/pocket/pocket_ayatsuri_model.inc':'56fce9f5b6380628900eb907b6895ba7c67c196a','tools/ayatsuri/model/pack_model.cjs':'3ad150cfa8e08772c2a631a7b94dfcbcbe56fefa','main/ayatsuri/compact_opaque.c':'e1c37f77f1dffa3ecdea094897b53169def4a840'}
  blob=hashlib.sha1(b'blob '+str(len(data)).encode()+b'\0'+data).hexdigest()
  assert blob==expected[name], 'baseline source does not match published a426f7a: '+name
  target=base/name;target.parent.mkdir(parents=True,exist_ok=True);target.write_bytes(data)
 (old/'ui').symlink_to(ROOT/'main/ui',target_is_directory=True)
 run(['node','tools/ayatsuri/asset/test_import.cjs']);run(['node','tools/ayatsuri/asset/compact_opaque/test_batch.cjs'])
 run(['node','tools/ayatsuri/model/test_sidedness.cjs',base/'tools/ayatsuri/model/pack_model.cjs'])
 current=cache/'core';run(['cc',*flags,'-Wall','-Wextra','-Werror','-I',ROOT/'main',ROOT/'main/ayatsuri/ayatsuri_model.c',ROOT/'main/ayatsuri/ayatsuri_visibility.c',ROOT/'tools/ayatsuri/model/test_sidedness.c',ROOT/'main/ui/kasane/ksn_mesh_depth.c',ROOT/'main/ui/kasane/ksn_procedural.c',ROOT/'main/ayatsuri/compact_opaque.c','-lm','-o',current]);run([current])
 driver=base/'old-loader.c';driver.write_text('#include "ayatsuri/ayatsuri_model.h"\n#include <assert.h>\n#include <stdio.h>\n#include <stdlib.h>\nint main(int n,char**v){assert(n==3);for(int j=1;j<3;j++){FILE*f=fopen(v[j],"rb");assert(f);fseek(f,0,2);long z=ftell(f);rewind(f);char*b=malloc(z);assert(b&&fread(b,1,z,f)==(size_t)z);fclose(f);ayatsuri_model m;assert(ayatsuri_model_open(b,z,&m)==(j==1?AYATSURI_MODEL_OK:AYATSURI_MODEL_INVALID));free(b);}puts("SIDED_OLD_LOADER_PASS legacy_accept required13_reject");}\n')
 binary=cache/'old-loader';run(['cc',*flags,'-I',old,'-I',ROOT/'main',old/'ayatsuri/ayatsuri_model.c',ROOT/'main/ayatsuri/ayatsuri_visibility.c',driver,'-lm','-o',binary]);run([binary,'.cache/ayatsuri-native/sided-legacy64.aynm','.cache/ayatsuri-native/sided-sided64.aynm'])
 # Actual previous codec comparison, including rejection of the new mode by
 # the old reader. Renamed symbols avoid a second interpretation of old bytes.
 old_codec=cache/'old-codec.o'
 renames=['-D'+name+'=legacy_'+name for name in ['co_append','co_read','co_vertex_at','co_triangle_at']]
 run(['cc',*flags,*renames,'-I',ROOT/'main/ayatsuri','-c',old/'ayatsuri/compact_opaque.c','-o',old_codec])
 side_test=cache/'side-record'
 run(['cc',*flags,'-Wall','-Wextra','-Werror','-I',ROOT/'main',ROOT/'main/ayatsuri/compact_opaque.c',ROOT/'main/ui/kasane/ksn_mesh_depth.c',ROOT/'main/ui/kasane/ksn_procedural.c',ROOT/'tools/kasane_contract/test_mesh_side_record.c',old_codec,'-lm','-o',side_test]);run([side_test])
 # Reuse unchanged QuickJS objects from the registry test cache when present;
 # otherwise compile a local cache once. Both compared paths use identical VM.
 qjs=ROOT/'components/quickjs-ng/quickjs-ng';qcache=cache/'qjs';qcache.mkdir(exist_ok=True);objects=[]
 key=hashlib.sha256((' '.join(flags)+subprocess.check_output(['cc','--version'],text=True)+''.join(hashlib.sha256(f.read_bytes()).hexdigest() for f in sorted(qjs.glob('*')) if f.suffix in ('.c','.h'))).encode()).hexdigest()
 for name in ['dtoa','libregexp','libunicode','quickjs','quickjs-vm']:
  obj=qcache/(key+'-'+name+'.o');objects.append(obj)
  if not obj.exists():run(['cc',*flags,'-w','-I',qjs,'-c',qjs/(name+'.c'),'-o',obj])
 sys.path.insert(0,str(ROOT/'tools/kasane_contract'));from megademo_chunks import rom_table
 rom=rom_table(cache/'rom.c')
 shared=['ksn_procedural.c','ksn_proc_analysis.c','ksn_proc_plan.c','ksn_proc_plan_points.c','ksn_proc_points.c','ksn_proc_points_pie.c','ksn_proc_points_dispatch.c','ksn_core.c','ksn_render.c','ksn_blend_pie.c','ksn_shiki.c','ksn_mesh_depth.c']
 shared=[ROOT/'main/ui/kasane'/n for n in shared]+[ROOT/'main/ayatsuri/compact_opaque.c',ROOT/'main/ayatsuri/ayatsuri_visibility.c',ROOT/'main/pocket/pocket_proc.c',ROOT/'main/pocket/shiki_heap.c',ROOT/'tools/kasane_contract/proc_native_weak.c',ROOT/'tools/kasane_contract/test_sided_legacy_compat.c',rom]
 inputs=[ROOT/'.cache/ayatsuri-native/sided-legacy64.aynm',ROOT/'.cache/ayatsuri-native/sided-single32.aynm',ROOT/'.cache/ayatsuri-native/mesh.aynm']+[Path(n).resolve() for n in args.legacy_input]
 run(['node','tools/ayatsuri/model/test_pack_mesh.cjs'])
 for label,source in [('baseline',old),('current',ROOT/'main')]:
  binary=cache/('compat-'+label);run(['cc',*flags,'-I',source,'-I',qjs,'-I',ROOT/'main','-I',ROOT/'main/pocket','-I',ROOT/'main/ui/kasane','-I',ROOT/'tools/kasane_contract','-I',ROOT/'tools/hostshim',source/'ayatsuri/ayatsuri_model.c',source/'pocket/pocket_shape.c',*shared,*objects,'-lm','-o',binary]);run([binary,cache/(label+'.rgb565'),*inputs])
 assert (cache/'baseline.rgb565').read_bytes()==(cache/'current.rgb565').read_bytes()
 print('SIDED_LEGACY_PIXEL_PASS inputs='+str(len(inputs))+' views=4 both_submit byte_equal=1',flush=True)
 # Use the same VM objects/flags for the full managed test, avoiding a second
 # compilation of unchanged QuickJS. No alternate product implementation.
 run(['node','tools/kasane_contract/mesh_depth_fixture.cjs'])
 binary=cache/'managed-suite'
 suite=[n for n in shared if n.name!='test_sided_legacy_compat.c']+[ROOT/'tools/kasane_contract/test_mesh_depth_qjs.c']
 run(['cc',*flags,'-I',ROOT/'main','-I',qjs,'-I',ROOT/'main/pocket','-I',ROOT/'main/ui/kasane','-I',ROOT/'tools/kasane_contract','-I',ROOT/'tools/hostshim',ROOT/'main/ayatsuri/ayatsuri_model.c',ROOT/'main/pocket/pocket_shape.c',*suite,*objects,'-lm','-o',binary]);run([binary])
print('SIDEDNESS_SYNTHETIC_PASS actual_fox_blender_comparison=NOT_RUN device=NOT_RUN')
