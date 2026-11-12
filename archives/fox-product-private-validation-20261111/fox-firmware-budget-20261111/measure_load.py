from pathlib import Path
import json,subprocess,re
root=Path.cwd(); out=root/'fox-firmware-budget-20261111'; cmd=json.loads((root/'fox-eye-runtime-qemu-20261111/host-command-frozen.json').read_text())
for name in ['entry-primary-frozen.c','composite.c','scene_alpha.c']:
 old=next(x for x in cmd if x.endswith('/'+name)); s=Path(old).read_text()
 if name=='entry-primary-frozen.c':
  s='#include <time.h>\nunsigned long budget_fragments,budget_passes,budget_triangles,budget_batches;\n'+s
  s=s.replace('scene_times t;calls=fractional=max_layers=0;','scene_times t;calls=fractional=max_layers=0; budget_fragments=budget_passes=budget_triangles=budget_batches=0; clock_t budget_start=clock();')
  s=s.replace('printf("FOX_EYE_FRAME', 'printf("BUDGET sample=%u visit=%u passes=%lu fragments=%lu triangle_visits=%lu batches=%lu host_cpu_ms=%.3f\\n",sample,visit,budget_passes,budget_fragments,budget_triangles,budget_batches,1000.0*(clock()-budget_start)/CLOCKS_PER_SEC);\n printf("FOX_EYE_FRAME')
 elif name=='composite.c':
  s='extern unsigned long budget_fragments,budget_passes;\n'+s
  s=s.replace('peel_context*c=opaque;', 'budget_fragments++;peel_context*c=opaque;').replace('w->passes++;','budget_passes++;w->passes++;')
 else:
  s='extern unsigned long budget_triangles,budget_batches;\n'+s
  s=s.replace('ids[id_count++]=id;','budget_triangles++;ids[id_count++]=id;').replace('(*batch)++;','budget_batches++;(*batch)++;')
 new=out/name;new.write_text(s);cmd[cmd.index(old)]=str(new)
cmd[cmd.index('-o')+1]=str(out/'host-instrumented');(out/'host-command.json').write_text(json.dumps(cmd,indent=2))
subprocess.run(cmd,check=True,stdout=(out/'host-build.log').open('w'),stderr=subprocess.STDOUT)
with (out/'host-load.log').open('w') as f:subprocess.run([str(out/'host-instrumented')],stdout=f,check=True,timeout=120)
log=(out/'host-load.log').read_text(); ref=(root/'fox-eye-runtime-qemu-20261111/host.log').read_text()
records=lambda s:[l for l in s.splitlines() if l.startswith(('FOX_EYE_FRAME','FOX_EYE_ROW','FOX_BRIDGE'))]
a,b=records(log),records(ref)
measurements=[dict((k,float(v) if k=='host_cpu_ms' else int(v)) for k,v in re.findall(r'(\w+)=([\d.]+)',l)) for l in log.splitlines() if l.startswith('BUDGET ')]
result={'exact_original_records_match':a==b,'records':len(a),'original_records':len(b),'frames':len(measurements),'metrics':measurements}
(out/'load-results.json').write_text(json.dumps(result,indent=2));print({k:v for k,v in result.items() if k!='metrics'})
for k in ['passes','fragments','triangle_visits','batches','host_cpu_ms']: print(k,min(m[k] for m in measurements),max(m[k] for m in measurements))
