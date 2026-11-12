from pathlib import Path
import json,subprocess
r=Path.cwd();p=r/'fox-product-review-20261111';b=r/'fox-firmware-budget-20261111'
s=(b/'test-fast.c').read_text().replace('int main(void){','int baseline_main(void){')
s+='''\nint main(void){unsigned seed=1234567;unsigned long long hash=0;for(unsigned run=0;run<400;run++){setup();for(unsigned i=0;i<3;i++){seed=1664525u*seed+1013904223u;opacity[i]=(float)(seed%5)/4;seed=1664525u*seed+1013904223u;for(unsigned k=0;k<3;k++)f.projected[source_triangles[ids[i]].v[k]][2]=(float)(seed%4);}error_id=run%7==0?ids[run%3]:99999;uint16_t out[960];for(unsigned i=0;i<960;i++)out[i]=(uint16_t)(i*23+run);bool ok=fox_scene_composite(&f,out,0,4,30,&scene,NULL,shader,NULL,1+run%3,&comp);hash=hash*131+ok;for(unsigned i=0;i<960;i++)hash=hash*131+out[i];}printf("%llu\\n",hash);}\n'''
(p/'differential.c').write_text(s)
base=json.loads((b/'fast-command.json').read_text());base=[v for v in base if not(v.endswith('.c') and any(x in v for x in ['entry-primary','bridge.c','quickjs-ng/','eye_runtime.c']))]
for name in ['fast','reference']:
 cmd=base.copy();cmd.insert(cmd.index('-o'),str(p/'differential.c'));cmd[cmd.index('-o')+1]=str(p/name)
 if name=='reference':cmd=[v.replace('/composite-fast.c','/composite.c') for v in cmd]
 subprocess.run(cmd,check=True);result=subprocess.check_output([str(p/name)],text=True);(p/(name+'.log')).write_text(result);print(name,result.strip())
assert (p/'fast.log').read_text()==(p/'reference.log').read_text()
