from pathlib import Path
import json,subprocess,re
root=Path.cwd();p=root/'fox-firmware-budget-20261111';s=(p/'composite.c').read_text()
s=s.replace('static float linear(','''/* Pure immutable callbacks only: a fractional candidate may cause replay in the
 * unchanged general compositor. Output remains untouched until either path wins. */
typedef struct { peel_context peel; bool fractional; } cutout_context;
static double collect_cutout(void *opaque,const fox_fragment *f){
 cutout_context *c=opaque;
 double result=collect(&c->peel,f);
 if(!isfinite(result))return result;
 unsigned at=((unsigned)f->y-c->peel.y)*240+(unsigned)f->x;
 if(c->peel.w->next_id[at]==f->triangle && c->peel.w->next_alpha[at]>0 && c->peel.w->next_alpha[at]<1){c->fractional=true;return NAN;}
 return result;
}
static float linear(''')
needle=' for(unsigned pass=0;pass<=max_layers;pass++){'
insert='''
 /* Optional generic binary-alpha fast path. Same source-order/tie selection as
  * peel pass zero; zero-alpha never claims depth. No coverage is approximated. */
 for(unsigned i=0;i<n;i++){w->next_depth[i]=-INFINITY;w->next_id[i]=UINT_MAX;}
 cutout_context cut={ctx,false};
 bool fast_ok=fox_scene_band_local(f,w->scratch,y,rows,limit,scene,-1,collect_cutout,&cut,local);
 budget_passes++;
 if(fast_ok){
  w->passes=1;
  for(unsigned i=0;i<n;i++)if(w->next_id[i]!=UINT_MAX){
   memcpy(w->accumulated[i],w->next_rgb[i],sizeof w->accumulated[i]);
   w->transmittance[i]=0;w->max_observed_layers=1;
  }
  goto convert;
 }
 if(!cut.fractional)return false;
 /* Fractional opacity is not a failure and must not become a threshold. */
 for(unsigned i=0;i<n;i++){w->previous_depth[i]=INFINITY;w->previous_id[i]=0;w->transmittance[i]=1;memset(w->accumulated[i],0,sizeof w->accumulated[i]);w->scratch[i]=0;}
'''
s=s.replace(needle,insert+needle).replace(' /* All possible failures','convert:\n /* All possible failures');(p/'composite-fast.c').write_text(s)
cmd=json.loads((p/'host-command.json').read_text());cmd[cmd.index(str(p/'composite.c'))]=str(p/'composite-fast.c');cmd[cmd.index('-o')+1]=str(p/'host-fast');(p/'fast-command.json').write_text(json.dumps(cmd,indent=2));subprocess.run(cmd,check=True,stdout=(p/'fast-build.log').open('w'),stderr=subprocess.STDOUT)
with (p/'fast.log').open('w') as f:subprocess.run([str(p/'host-fast')],check=True,stdout=f,timeout=120)
a=(p/'host-load.log').read_text();b=(p/'fast.log').read_text()
rows=lambda s:[l for l in s.splitlines() if l.startswith('FOX_EYE_ROW')]
frames=lambda s:[l.split(' calls=')[0] for l in s.splitlines() if l.startswith('FOX_EYE_FRAME')]
measure=lambda s:[dict((k,float(v) if k=='host_cpu_ms' else int(v)) for k,v in re.findall(r'(\w+)=([\d.]+)',l)) for l in s.splitlines() if l.startswith('BUDGET ')]
r={'rows_match':rows(a)==rows(b),'row_count':len(rows(b)),'frame_hashes_match':frames(a)==frames(b),'frame_count':len(frames(b)),'metrics':measure(b)}
(p/'fast-results.json').write_text(json.dumps(r,indent=2));print({k:v for k,v in r.items() if k!='metrics'})
for k in ['passes','fragments','triangle_visits','batches','host_cpu_ms']:print(k,min(x[k] for x in r['metrics']),max(x[k] for x in r['metrics']))
