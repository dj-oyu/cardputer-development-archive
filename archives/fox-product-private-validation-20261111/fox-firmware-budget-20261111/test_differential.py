from pathlib import Path
import subprocess,json
r=Path.cwd();p=r/'fox-firmware-budget-20261111';s=(r/'fox-eye-qemu-20261111/composite-final/frozen/composite.c').read_text().replace('fox_scene_composite','reference_composite');(p/'composite-reference.c').write_text(s)
s=(r/'fox-eye-raster-20261111/test_composite.c').read_text();s=s[:s.index('int main(void)')]+'''
bool reference_composite(const scene_frame*,uint16_t*,unsigned,unsigned,unsigned,scene_workspace*,const float(*)[3],fox_surface_fn,void*,unsigned,fox_composite_workspace*);
unsigned long budget_fragments,budget_passes,budget_triangles,budget_batches;
static unsigned rng=1234567;
static unsigned next(void){rng=rng*1664525u+1013904223u;return rng;}
int main(void){
 static scene_workspace ref_scene;static fox_composite_workspace ref_comp;
 uint16_t a[960],b[960],saved[960];
 const float alpha[]={0,1,.01f,.5f,-1,NAN,INFINITY};
 for(unsigned trial=0;trial<3000;trial++){
  setup();for(unsigned i=0;i<3;i++){
   opacity[i]=alpha[next()%7];float z=(float)(next()%4);
   for(unsigned k=0;k<3;k++)f.projected[source_triangles[ids[i]].v[k]][2]=z;
  }
  error_id=(next()%5==0)?ids[next()%3]:99999;
  for(unsigned i=0;i<960;i++)saved[i]=a[i]=b[i]=(uint16_t)next();
  unsigned layers=1+next()%3,limit=10*(1+next()%3);
  bool x=reference_composite(&f,a,0,4,limit,&ref_scene,NULL,shader,NULL,layers,&ref_comp);
  bool y=fox_scene_composite(&f,b,0,4,limit,&scene,NULL,shader,NULL,layers,&comp);
  assert(x==y);assert(!memcmp(a,b,sizeof a));if(!x)assert(!memcmp(a,saved,sizeof a));
 }
 puts("PASS 3000 deterministic differential cases: random binary/fractional/invalid alpha, errors, depth/ties, backgrounds, batch/layer limits, identical status/pixels and atomic failure");
}
''';(p/'test-differential.c').write_text(s)
cmd=json.loads((p/'fast-command.json').read_text());cmd=[v for v in cmd if not(v.endswith('.c') and any(x in v for x in ['entry-primary','bridge.c','quickjs-ng/','eye_runtime.c']))];cmd.insert(cmd.index('-o'),str(p/'test-differential.c'));cmd.insert(cmd.index('-o'),str(p/'composite-reference.c'));cmd[cmd.index('-o')+1]=str(p/'test-differential');subprocess.run(cmd,check=True);subprocess.run([str(p/'test-differential')],check=True,stdout=(p/'differential.log').open('w'));print((p/'differential.log').read_text())
