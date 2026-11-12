"""Exact native-boundary extraction; synthetic input and real visibility builder.
This is not a native caller integration test or a snapshot-codec ownership test.
Pre-release process-exit leaks are fixture-cleaned, not changed in production.
"""
from pathlib import Path
import hashlib,json,os,subprocess
R=Path(__file__).resolve().parents[1]
D=R/'tests/lifetime-results';D.mkdir(exist_ok=True)
s=(R/'harness/native_render_row.c').read_text()
owner=(R/'harness/model_arena_owner.h').read_text()
start=s.index('  if(ayatsuri_model_instance_dispose',s.index('Snapshot serialization and original-order'))
end=s.index('\n  if(transportmode)',start)
early=s[start:end]
late=next(x for x in s.splitlines() if x.startswith(' if(arena){'))
late=late[:late.index('memset(&disks')]
guard=next(x for x in s.splitlines() if 'if(nv!=occluder_vertices||nt!=occluder_triangles)' in x)
a=owner.index('static void model_arena_owner_release(');b=owner.index('\n/*',a)
release=owner[a:b]
def check_source(text):
 boundary=text.index('  if(ayatsuri_model_instance_dispose',text.index('Snapshot serialization and original-order'))
 builder=text.index('vis_status status=vis_scene_build')
 assert text.index('for(unsigned at=0;at<count;at++)')<boundary
 assert text.index('canonical_snapshot_bytes=416')<boundary
 assert text.index('geometry_digest=digest_bytes')<boundary
 assert boundary<builder<text.index('if(pixel){char dump_path')
 assert 'ayatsuri_model_instance_' not in text[builder:text.index(' if(arena){')]
 assert text.count('model_arena_owner_release(&arena,free)')==2
 assert text.count('ayatsuri_model_instance_dispose(&ins,&owner,1)')==2
check_source(s)
# Reject regressions that move disposal after build or add a borrowed read.
mutants=[s[:start]+s[end:]+s[start:end],s[:end]+'\n ayatsuri_model_instance_pixel_mesh_view();'+s[end:]]
for mutant in mutants:
 try:check_source(mutant)
 except (AssertionError,ValueError):pass
 else:raise AssertionError('source-order negative control was accepted')
src=(R/'tests/lifetime_failure_template.c').read_text().replace('VIS_SOURCE',str(R/'private-build/visibility/visibility.c')).replace('/* OWNER_RELEASE */',release).replace('/* COUNT_GUARD */',guard).replace('/* EARLY_BOUNDARY */',early).replace('/* LATE_BOUNDARY */',late)
p=D/'boundary.generated.c';p.write_text(src)
results=[]
for opt in ['-O0','-O2']:
 for san in [False,True]:
  mode=opt[1:]+('-asan-ubsan' if san else '')
  cmd=['cc','-std=c11',opt,'-g','-Wall','-Wextra','-Werror','-Wno-misleading-indentation',str(p),'-lm','-o',str(D/mode)]
  if san:cmd+=['-fsanitize=address,undefined','-fno-omit-frame-pointer']
  subprocess.run(cmd,check=True)
  run=subprocess.run([str(D/mode)],capture_output=True,text=True,env={**os.environ,'ASAN_OPTIONS':'detect_leaks=0:halt_on_error=1','UBSAN_OPTIONS':'halt_on_error=1'})
  (D/(mode+'.log')).write_text(run.stdout+run.stderr);run.check_returncode()
  results.append({'mode':mode,'command':cmd,'result':run.stdout.strip()});print(mode,run.stdout.strip(),flush=True)
(D/'results.json').write_text(json.dumps({'status':'PASS','source_sha256':hashlib.sha256(s.encode()).hexdigest(),'scope':'exact extracted caller boundary + real builder + exact owner release; synthetic snapshot copy, not production codec or complete native integration','cases_per_mode':9,'source_order_negative_controls':2,'results':results},indent=2)+'\n')
