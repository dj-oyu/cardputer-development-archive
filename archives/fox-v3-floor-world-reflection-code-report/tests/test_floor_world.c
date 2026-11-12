#define main legacy_floor_main
#include "../capture/floor-tests/test_floor.c"
#undef main
static bounce_status runworld(bounce_scene*s,bounce_generation g,int side,bounce_floor_work*fw,bounce_floor_world_work*ww,vis_budget*db,vis_budget*tb,bounce_result*out,bounce_floor_world_result*wr){
 bounce_binding b={0};assert(bounce_binding_set(&b,s,g)==BOUNCE_OK);double p[3]={0},n[3]={0,0,side},rho[3]={.2,.4,.6};bounce_status st=bounce_eval_floor_world_experimental(&b,g,p,n,rho,BOUNCE_ONE,16,16,db,tb,fw,ww,out,wr);bounce_binding_clear(&b);return st;
}
static void worldfresh(bounce_floor_work*fw,bounce_floor_world_work*ww,vis_budget*db,vis_budget*tb){fresh(fw,db,tb);db->limit=(vis_counters){1000000,100000000,50000000};assert(bounce_floor_world_work_init(ww,1,16)==BOUNCE_OK);}
int main(void){
 assert(legacy_floor_main()==0);unsigned cases=0;
 for(int side=-1;side<=1;side+=2)for(int reverse=0;reverse<2;reverse++)for(int blocked=0;blocked<2;blocked++)for(int zero=0;zero<3;zero++){
  bounce_generation g=gen();bounce_ground ground=gr(3);FoxDiskScene l=lamps(side,10);if(zero==1)memset(l.world_radiance,0,sizeof l.world_radiance);if(zero==2)memset(ground.rho,0,sizeof ground.rho);
  vis_scene*v=geometry(side,blocked,reverse);bounce_scene*s=scene(v,&l,g,&ground);bounce_floor_work fw,offw;bounce_floor_world_work ww;vis_budget db,tb,offdb,offtb;bounce_result a,b;bounce_floor_world_result w;
  fresh(&offw,&offdb,&offtb);offdb.limit=(vis_counters){1000000,100000000,50000000};assert(run(s,g,side,&offw,&offdb,&offtb,&a,0)==BOUNCE_OK);
  worldfresh(&fw,&ww,&db,&tb);assert(runworld(s,g,side,&fw,&ww,&db,&tb,&b,&w)==BOUNCE_OK);
  assert(!memcmp(&fw,&offw,sizeof fw));assert(!memcmp(&a.counters,&b.counters,sizeof a.counters));assert(!memcmp(&db,&offdb,sizeof db));
  assert(tb.used.rays==offtb.used.rays+ww.visibility_used.rays&&tb.used.node_visits==offtb.used.node_visits+ww.visibility_used.node_visits&&tb.used.triangle_tests==offtb.used.triangle_tests+ww.visibility_used.triangle_tests);
  assert(!memcmp(a.direct,b.direct,sizeof a.direct)&&!memcmp(a.world,b.world,sizeof a.world)&&!memcmp(a.bounce,b.bounce,sizeof a.bounce)&&!memcmp(a.ground,b.ground,sizeof a.ground)&&!memcmp(a.ground_reflected,b.ground_reflected,sizeof a.ground_reflected));
  double rho[3]={.2,.4,.6};for(unsigned k=0;k<3;k++){double want=blocked?0:rho[k]*ground.rho[k]*l.world_radiance[k];assert(fabs(w.reflected_world[k]-want)<1e-12);assert(b.combined[k]==a.combined[k]+w.reflected_world[k]);}
  if(zero==2)assert(!ww.evaluations&&!ww.queries&&!ww.visibility_used.rays);else{assert(ww.evaluations==16&&ww.queries==256&&ww.visibility_used.rays==256);assert(ww.misses==(blocked?0:256)&&ww.blocked_character==(blocked?256:0)&&!ww.blocked_floor);}
  assert(fww_valid(&ww));
  if(!zero){
   FoxDiskScene l2=l;for(unsigned k=0;k<3;k++)l2.world_radiance[k]*=2;bounce_scene*s2=scene(v,&l2,g,&ground);bounce_result b2;bounce_floor_world_result w2;worldfresh(&fw,&ww,&db,&tb);assert(runworld(s2,g,side,&fw,&ww,&db,&tb,&b2,&w2)==BOUNCE_OK);for(unsigned k=0;k<3;k++)assert(w2.reflected_world[k]==2*w.reflected_world[k]);bounce_scene_release(s2);
  }
  bounce_scene_release(s);vis_scene_release(v);cases++;
 }
 bounce_generation g=gen();bounce_ground ground=gr(3);FoxDiskScene l=lamps(1,10);vis_scene*v=geometry(1,0,0);bounce_scene*s=scene(v,&l,g,&ground);bounce_binding binding={0};assert(bounce_binding_set(&binding,s,g)==BOUNCE_OK);double p[3]={0},n[3]={0,0,1},rho[3]={.2,.4,.6};bounce_floor_work fw;bounce_floor_world_work ww;vis_budget db,tb;bounce_result b,save;bounce_floor_world_result w,wsave;memset(&b,0x5a,sizeof b);save=b;memset(&w,0x5a,sizeof w);wsave=w;
#define UNCHANGED() assert(!memcmp(&b,&save,sizeof b)&&!memcmp(&w,&wsave,sizeof w))
#define RUN() bounce_eval_floor_world_experimental(&binding,g,p,n,rho,BOUNCE_ONE,16,16,&db,&tb,&fw,&ww,&b,&w)
 worldfresh(&fw,&ww,&db,&tb);tb.limit.rays=49;assert(RUN()==BOUNCE_BUDGET);UNCHANGED();assert(ww.evaluations==1&&ww.queries==1&&!ww.visibility_used.rays&&tb.used.rays==49);
 worldfresh(&fw,&ww,&db,&tb);ww.work_limit=63;assert(RUN()==BOUNCE_BUDGET);UNCHANGED();assert(!ww.work_used&&!db.used.rays&&!tb.used.rays);
 worldfresh(&fw,&ww,&db,&tb);ww.work_limit=64+6271;assert(RUN()==BOUNCE_BUDGET);UNCHANGED();assert(ww.shader_calls==1&&!ww.evaluations&&tb.used.rays==49);
 worldfresh(&fw,&ww,&db,&tb);assert(bounce_floor_world_work_init(&ww,1,0)==BOUNCE_OK);assert(RUN()==BOUNCE_BUDGET);UNCHANGED();
 for(unsigned k=0;k<3;k++){
  worldfresh(&fw,&ww,&db,&tb);if(k==0)tb.limit.rays++;else if(k==1)tb.limit.node_visits++;else tb.limit.triangle_tests++;assert(RUN()==BOUNCE_INVALID);UNCHANGED();assert(!ww.work_used&&!tb.used.rays);
  worldfresh(&fw,&ww,&db,&tb);vis_budget small=tb;if(k==0)small.limit.rays=0;else if(k==1)small.limit.node_visits=0;else small.limit.triangle_tests=0;double point[3]={0,0,0},normal[3]={0,0,1},out[3]={-1,-2,-3};assert(fww_pay(&ww,0)==BOUNCE_OK);assert(floor_world_visible(s,point,normal,&small,&ww,out)==BOUNCE_BUDGET);assert(out[0]==-1&&out[1]==-2&&out[2]==-3);assert(ww.evaluations==1&&ww.queries==1);assert(ww.visibility_used.rays==small.used.rays&&ww.visibility_used.node_visits==small.used.node_visits&&ww.visibility_used.triangle_tests==small.used.triangle_tests);
 }
 worldfresh(&fw,&ww,&db,&tb);p[0]=NAN;assert(RUN()==BOUNCE_INVALID);UNCHANGED();p[0]=0;
 worldfresh(&fw,&ww,&db,&tb);rho[0]=INFINITY;assert(RUN()==BOUNCE_INVALID);UNCHANGED();rho[0]=.2;
 worldfresh(&fw,&ww,&db,&tb);assert(bounce_eval_floor_world_experimental(&binding,g,p,n,rho,BOUNCE_ONE,16,64,&db,&tb,&fw,&ww,&b,&w)==BOUNCE_INVALID);UNCHANGED();
 worldfresh(&fw,&ww,&db,&tb);bounce_generation bad=g;bad.visibility.pose++;assert(bounce_eval_floor_world_experimental(&binding,bad,p,n,rho,BOUNCE_ONE,16,16,&db,&tb,&fw,&ww,&b,&w)==BOUNCE_GENERATION);UNCHANGED();
 worldfresh(&fw,&ww,&db,&tb);union{bounce_floor_world_work work;bounce_floor_world_result result;}alias;alias.work=ww;bounce_floor_world_work alias_save=alias.work;assert(bounce_eval_floor_world_experimental(&binding,g,p,n,rho,BOUNCE_ONE,16,16,&db,&tb,&fw,&alias.work,&b,&alias.result)==BOUNCE_INVALID);assert(!memcmp(&alias.work,&alias_save,sizeof alias_save));
 worldfresh(&fw,&ww,&db,&tb);assert(RUN()==BOUNCE_OK);save=b;wsave=w;assert(RUN()==BOUNCE_BUDGET);UNCHANGED();
 bounce_binding_clear(&binding);bounce_scene_release(s);vis_scene_release(v);
 assert(bounce_floor_world_work_init(&ww,17242,0)==BOUNCE_INVALID);assert(bounce_floor_world_work_init(&ww,1,71668)==BOUNCE_INVALID);
 printf("FLOOR_WORLD_PASS cases=%u work=%zu component=%zu maxWork=%llu oldResultABI=%zu oldCountersABI=%zu\n",cases,sizeof ww,sizeof w,(unsigned long long)BOUNCE_FLOOR_WORLD_WORK_CAP,sizeof b,sizeof b.counters);
}
