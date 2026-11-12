from pathlib import Path
R=Path(__file__).resolve().parents[1]; D=R/'capture';p=D/'transport/bounce.h';s=p.read_text();s=s.replace('const char *bounce_status_string(bounce_status status);',r'''
/* Isolated floor -> uniform world terminal path, fixed 16/16. Existing result
 * and counter ABIs are unchanged. OFF uses the previous entrypoint verbatim.
 * Work reservations are independent host semantic units, not CPU instructions.
 * Every visibility query charges the SAME cumulative transport vis_budget.
 * No heap, geometry copy, ray ownership/context or increased ray/node/tri cap. */
#define BOUNCE_FLOOR_WORLD_SAMPLES 16u
#define BOUNCE_FLOOR_WORLD_SHADER_WORK UINT64_C(64)
#define BOUNCE_FLOOR_WORLD_HIT_WORK UINT64_C(6272)
#define BOUNCE_FLOOR_WORLD_WORK_CAP (BOUNCE_FLOOR_MAX_SHADERS*BOUNCE_FLOOR_WORLD_SHADER_WORK+BOUNCE_FLOOR_MAX_HITS*BOUNCE_FLOOR_WORLD_HIT_WORK)
typedef struct {
 uint64_t shader_limit,hit_limit,work_limit,work_used,shader_calls,evaluations;
 uint64_t queries,misses,blocked_floor,blocked_character;
 vis_counters visibility_used;
} bounce_floor_world_work;
typedef struct { double reflected_world[3]; } bounce_floor_world_result;
bounce_status bounce_floor_world_work_init(bounce_floor_world_work *,uint64_t shaders,uint64_t hits);
/* 64 units per shader setup/merge; each eligible floor hit reserves:
 * 16*256 direction construction, 16*128 query control, 128 reduction/accumulation.
 * Traversal is separately charged by existing exact ray/node/triangle quotas.
 * All inputs/outputs and ledgers must be disjoint; outputs commit atomically.
 * Failed queries retain both prepaid semantic work and exact consumed traversal.
 * Fixed transport caps 20M/800M/300M, direct caps 1M/100M/50M. */
bounce_status bounce_eval_floor_world_experimental(const bounce_binding *,bounce_generation,
 const double position[3],const double normal[3],const double rho[3],
 bounce_mode,unsigned outer_samples,unsigned inner_samples,
 vis_budget *direct_budget,vis_budget *transport_budget,bounce_floor_work *,
 bounce_floor_world_work *,bounce_result *,bounce_floor_world_result *);
const char *bounce_status_string(bounce_status status);''');p.write_text(s)
p=D/'transport/bounce.c';s=p.read_text();needle='static bounce_status bounce_eval_impl(';at=s.index(needle);s=s[:at]+r'''
/* Conservative source-level reservations include math calls as opaque kernels;
 * they do not assert a machine-instruction or old 8M renderer-work admission. */
bounce_status bounce_floor_world_work_init(bounce_floor_world_work *w,uint64_t shaders,uint64_t hits){
 if(!w||!shaders||shaders>BOUNCE_FLOOR_MAX_SHADERS||hits>BOUNCE_FLOOR_MAX_HITS)return BOUNCE_INVALID;
 bounce_floor_world_work v={0};v.shader_limit=shaders;v.hit_limit=hits;
 v.work_limit=shaders*BOUNCE_FLOOR_WORLD_SHADER_WORK+hits*BOUNCE_FLOOR_WORLD_HIT_WORK;*w=v;return BOUNCE_OK;
}
static int fww_valid(const bounce_floor_world_work *w){
 if(!w||!w->shader_limit||w->shader_limit>BOUNCE_FLOOR_MAX_SHADERS||w->hit_limit>BOUNCE_FLOOR_MAX_HITS||w->shader_calls>w->shader_limit||w->evaluations>w->hit_limit)return 0;
 uint64_t cap=w->shader_limit*BOUNCE_FLOOR_WORLD_SHADER_WORK+w->hit_limit*BOUNCE_FLOOR_WORLD_HIT_WORK;
 if(w->work_limit>cap||w->work_used>w->work_limit||w->work_used!=w->shader_calls*BOUNCE_FLOOR_WORLD_SHADER_WORK+w->evaluations*BOUNCE_FLOOR_WORLD_HIT_WORK)return 0;
 if(w->queries>w->evaluations*16||w->visibility_used.rays>w->queries||w->misses>w->visibility_used.rays||w->blocked_floor>w->visibility_used.rays-w->misses||w->blocked_character>w->visibility_used.rays-w->misses-w->blocked_floor)return 0;
 return w->visibility_used.node_visits<=UINT64_C(800000000)&&w->visibility_used.triangle_tests<=UINT64_C(300000000);
}
static bounce_status fww_pay(bounce_floor_world_work *w,int hit){
 uint64_t cost=hit?BOUNCE_FLOOR_WORLD_HIT_WORK:BOUNCE_FLOOR_WORLD_SHADER_WORK;
 if(cost>w->work_limit-w->work_used||(hit?w->evaluations==w->hit_limit:w->shader_calls==w->shader_limit))return BOUNCE_BUDGET;
 w->work_used+=cost;if(hit)w->evaluations++;else w->shader_calls++;return BOUNCE_OK;
}
static int fww_budget_valid(const vis_budget *b,vis_counters cap){
 return b->limit.rays<=cap.rays&&b->limit.node_visits<=cap.node_visits&&b->limit.triangle_tests<=cap.triangle_tests&&b->used.rays<=b->limit.rays&&b->used.node_visits<=b->limit.node_visits&&b->used.triangle_tests<=b->limit.triangle_tests;
}
static bounce_status floor_world_visible(const bounce_scene *s,const double p[3],const double n[3],vis_budget *budget,bounce_floor_world_work *w,double out[3]){
 bounce_status st=fww_pay(w,1);if(st)return st;
 unsigned misses=0;
 for(unsigned j=0;j<BOUNCE_FLOOR_WORLD_SAMPLES;j++){
  double d[3];direction(n,BOUNCE_FLOOR_WORLD_SAMPLES,j,d);vis_hit h;
  vis_counters before=budget->used;w->queries++;
  vis_status v=vis_ray_nearest(&s->geometry,s->generation.visibility,p,d,budget,&h);
  w->visibility_used.rays+=budget->used.rays-before.rays;
  w->visibility_used.node_visits+=budget->used.node_visits-before.node_visits;
  w->visibility_used.triangle_tests+=budget->used.triangle_tests-before.triangle_tests;
  if(v!=VIS_OK)return vst(v);
  if(!h.found){misses++;w->misses++;}else if(isground(s,h.triangle_ordinal))w->blocked_floor++;else w->blocked_character++;
 }
 for(int k=0;k<3;k++)out[k]=s->lights.world_radiance[k]*((double)misses/BOUNCE_FLOOR_WORLD_SAMPLES);
 return BOUNCE_OK;
}
''' +s[at:]
s=s.replace('bounce_floor_work *work,int experimental,bounce_result *out){','bounce_floor_work *work,int experimental,bounce_floor_world_work *ww,bounce_floor_world_result *wo,bounce_result *out){')
needle=' if(experimental){\n';assert s.count(needle)==1;s=s.replace(needle,r''' if(ww||wo){
  if(!ww||!wo||!experimental||!work||s->ground.mode!=BOUNCE_GROUND_PRIMARY_LE_DIRECT||mode!=BOUNCE_ONE||outer!=16||inner!=16)return BOUNCE_INVALID;
  const void *ptrs[]={ww,wo,out,work,b,direct_budget,budget,p,normal,rho};
  const size_t sizes[]={sizeof*ww,sizeof*wo,sizeof*out,sizeof*work,sizeof*b,sizeof*direct_budget,sizeof*budget,3*sizeof(double),3*sizeof(double),3*sizeof(double)};
  for(unsigned i=0;i<2;i++){if(owned(s,ptrs[i],sizes[i]))return BOUNCE_INVALID;for(unsigned j=i+1;j<10;j++)if(overlap(ptrs[i],sizes[i],ptrs[j],sizes[j]))return BOUNCE_INVALID;}
  if(!fww_valid(ww)||!fww_budget_valid(direct_budget,(vis_counters){1000000,100000000,50000000})||!fww_budget_valid(budget,(vis_counters){20000000,800000000,300000000}))return BOUNCE_INVALID;
  bounce_status st=fww_pay(ww,0);if(st)return st;
 }
 if(experimental){
''')
s=s.replace(' bounce_result result={0};FoxDiskScene direct=', ' bounce_floor_world_result world_result={0};\n bounce_result result={0};FoxDiskScene direct=')
needle='    for(int k=0;k<3;k++)result.ground_reflected[k]+=rho[k]*floor_direct[k]/outer;';assert s.count(needle)==1;s=s.replace(needle,needle+r'''
    if(ww){
     double floor_world[3];st=floor_world_visible(s,h.position,ng,budget,ww,floor_world);if(st)return st;
     for(int k=0;k<3;k++)world_result.reflected_world[k]+=rho[k]*s->ground.rho[k]*floor_world[k]/outer;
    }''')
s=s.replace('if(!isfinite(result.combined[k])||result.combined[k]<0)', 'if(ww)result.combined[k]+=world_result.reflected_world[k];if(!isfinite(result.combined[k])||result.combined[k]<0)')
s=s.replace(' *out=result;return BOUNCE_OK;',' *out=result;if(wo)*wo=world_result;return BOUNCE_OK;')
s=s.replace('db,tb,NULL,0,out);','db,tb,NULL,0,NULL,NULL,out);').replace('db,tb,work,1,out);','db,tb,work,1,NULL,NULL,out);')
s+=r'''
bounce_status bounce_eval_floor_world_experimental(const bounce_binding *b,bounce_generation g,const double p[3],const double n[3],const double rho[3],bounce_mode mode,unsigned outer,unsigned inner,vis_budget *db,vis_budget *tb,bounce_floor_work *work,bounce_floor_world_work *ww,bounce_result *out,bounce_floor_world_result *wo){
 if(!ww||!wo)return BOUNCE_INVALID;
 return bounce_eval_impl(b,g,p,n,rho,mode,outer,inner,db,tb,work,1,ww,wo,out);
}
''';p.write_text(s)
p=D/'transport/pixel_transport.h';s=p.read_text().replace(' bounce_result last_result;',' bounce_floor_world_work *floor_world_work; /* NULL is byte-identical old shading. */\n bounce_floor_world_result last_floor_world; /* Separate immediate observer result. */\n bounce_result last_result;');p.write_text(s)
p=D/'transport/pixel_transport.c';s=p.read_text().replace('fox_transport_context *c=opaque;bounce_result r;','fox_transport_context *c=opaque;bounce_result r;bounce_floor_world_result wr={0};');s=s.replace(' if(c->floor_work){',r''' if(c->floor_world_work){
  if(bounce_eval_floor_world_experimental(&c->binding,c->expected,p,n,rho,c->mode,c->outer,c->inner,c->direct_budget,c->transport_budget,c->floor_work,c->floor_world_work,&r,&wr)!=BOUNCE_OK)return false;
  if(!bounce_scene_matches_lights(c->binding.scene,lights)||!bounce_scene_matches_ground(c->binding.scene,&c->ground))return false;
 }else if(c->floor_work){''');s=s.replace('c->last_result=r;','c->last_result=r;c->last_floor_world=wr;')
s=s.replace('stats,c->floor_work};','stats,c->floor_work,c->floor_world_work};').replace('limits,c->floor_work};','limits,c->floor_work,c->floor_world_work};');s=s.replace('c->floor_work?sizeof *c->floor_work:0};','c->floor_work?sizeof *c->floor_work:0,c->floor_world_work?sizeof *c->floor_world_work:0};');s=s.replace('i<10;i++','i<11;i++').replace('j<10;j++','j<11;j++').replace('i<13;i++','i<14;i++').replace('j<13;j++','j<14;j++');p.write_text(s)
