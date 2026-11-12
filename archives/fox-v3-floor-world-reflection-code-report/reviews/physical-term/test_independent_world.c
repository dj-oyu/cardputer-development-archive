#define main old_fixture_main
#include "../capture/floor-tests/test_floor.c"
#undef main

static vis_scene *planes(double floorz,double blockerz,double blocker_xmin,int blocked,int reverse,double scale){
 double xyz[24]={-100*scale,-100*scale,floorz,100*scale,-100*scale,floorz,100*scale,100*scale,floorz,-100*scale,100*scale,floorz,
 blocker_xmin,-100*scale,blockerz,100*scale,-100*scale,blockerz,100*scale,100*scale,blockerz,blocker_xmin,100*scale,blockerz};
 uint32_t ix[]={0,1,2,0,2,3,4,5,6,4,6,7};if(reverse)for(unsigned k=0;k<4;k++){uint32_t x=ix[3*k];ix[3*k]=ix[3*k+1];ix[3*k+1]=x;}
 vis_scene *v=NULL;assert(vis_scene_build(&v,xyz,blocked?8:4,ix,blocked?4:2,gen().visibility,(vis_limits){2048,4095,524288})==VIS_OK);return v;
}
static void funds(bounce_floor_work *fw,bounce_floor_world_work *ww,vis_budget *db,vis_budget *tb){fresh(fw,db,tb);db->limit=(vis_counters){1000000,100000000,50000000};assert(bounce_floor_world_work_init(ww,1,16)==BOUNCE_OK);}
static bounce_status evaluated(bounce_scene*s,int side,const double rho[3],bounce_floor_work*fw,bounce_floor_world_work*ww,vis_budget*db,vis_budget*tb,bounce_result*out,bounce_floor_world_result*wr){
 bounce_binding b={0};assert(bounce_binding_set(&b,s,gen())==BOUNCE_OK);double p[3]={0},n[3]={0,0,side};bounce_status st=bounce_eval_floor_world_experimental(&b,gen(),p,n,rho,BOUNCE_ONE,16,16,db,tb,fw,ww,out,wr);bounce_binding_clear(&b);return st;
}
/* Independent Cartesian oracle for the fixed two radial rings and eight azimuths.
 * A half-plane at z=-side cannot affect the receiver's +side outer hemisphere.
 * Its x boundary is deliberately not on a quadrature point. */
static unsigned oracle_misses(void){unsigned misses=0;for(unsigned i=0;i<16;i++)for(unsigned j=0;j<16;j++){
 double ri=sqrt(((i/8)+.5)/2),rj=sqrt(((j/8)+.5)/2),zi=sqrt(1-ri*ri),zj=sqrt(1-rj*rj);
 double pi=2*acos(-1)*((i%8)+.5*((i/8)%2))/8,pj=2*acos(-1)*((j%8)+.5*((j/8)%2))/8;
 double x=ri*sin(pi)/zi+2*rj*sin(pj)/zj;if(x<.123456)misses++;
 }return misses;}
int main(void){unsigned scenarios=0;unsigned misses=oracle_misses();assert(misses>0&&misses<256);
 for(int side=-1;side<=1;side+=2)for(int reverse=0;reverse<2;reverse++)for(int blocked_as_floor=0;blocked_as_floor<2;blocked_as_floor++)for(int scale=0;scale<4;scale++){
  vis_scene*v=planes(side,-side,.123456,1,reverse,1);bounce_ground ground=gr(3);if(blocked_as_floor)ground.triangle_count=4;FoxDiskScene l=lamps(side,10);double rho[3]={.2,.4,.6};
  if(scale==1)for(unsigned k=0;k<3;k++)ground.rho[k]*=.5;
  if(scale==2)for(unsigned k=0;k<3;k++)rho[k]*=.5;
  if(scale==3)for(unsigned k=0;k<3;k++)l.world_radiance[k]*=2;
  bounce_scene*s=scene(v,&l,gen(),&ground);bounce_floor_work fw,oldfw;bounce_floor_world_work ww;vis_budget db,tb,olddb,oldtb;bounce_result result,old;bounce_floor_world_result wr;
  funds(&fw,&ww,&db,&tb);assert(evaluated(s,side,rho,&fw,&ww,&db,&tb,&result,&wr)==BOUNCE_OK);
  bounce_binding b={0};assert(bounce_binding_set(&b,s,gen())==BOUNCE_OK);double p[3]={0},n[3]={0,0,side};fresh(&oldfw,&olddb,&oldtb);olddb.limit=(vis_counters){1000000,100000000,50000000};assert(bounce_eval_floor_experimental(&b,gen(),p,n,rho,BOUNCE_ONE,16,16,&olddb,&oldtb,&oldfw,&old)==BOUNCE_OK);bounce_binding_clear(&b);
  for(unsigned k=0;k<3;k++){double expected=rho[k]*ground.rho[k]*l.world_radiance[k]*(double)misses/256;assert(fabs(wr.reflected_world[k]-expected)<1e-12);assert(result.combined[k]==old.combined[k]+wr.reflected_world[k]);}
  assert(ww.misses==misses&&ww.queries==256&&ww.visibility_used.rays==256);assert((blocked_as_floor?ww.blocked_floor:ww.blocked_character)==256-misses);assert((blocked_as_floor?ww.blocked_character:ww.blocked_floor)==0);
  assert(!memcmp(&result.counters,&old.counters,sizeof old.counters));assert(!memcmp(&fw,&oldfw,sizeof fw));assert(!memcmp(result.direct,old.direct,sizeof old.direct)&&!memcmp(result.world,old.world,sizeof old.world)&&!memcmp(result.bounce,old.bounce,sizeof old.bounce)&&!memcmp(result.ground,old.ground,sizeof old.ground)&&!memcmp(result.ground_reflected,old.ground_reflected,sizeof old.ground_reflected));assert(tb.used.rays==oldtb.used.rays+256);
  assert(ww.work_used==64+16*6272);bounce_scene_release(s);vis_scene_release(v);scenarios++;
 }
 /* Epsilon uses world-distance. Ring z={sqrt(.75),.5} => .25eps is inside
  * the exclusion for every ray, 1.01eps is outside for every ray. Distant
  * occluders remain visible because inherited far bound encloses geometry. */
 for(unsigned which=0;which<3;which++)for(int reverse=0;reverse<2;reverse++){
  double z=which==0?.25*VIS_SEGMENT_EPSILON:which==1?1.01*VIS_SEGMENT_EPSILON:1e8;
  double scale=which==2?1e8:1;vis_scene*v=planes(-1,z,-100*scale,1,reverse,scale);FoxDiskScene l=lamps(1,10);bounce_ground ground=gr(3);bounce_scene*s=scene(v,&l,gen(),&ground);bounce_floor_world_work ww;assert(bounce_floor_world_work_init(&ww,1,16)==BOUNCE_OK);assert(fww_pay(&ww,0)==BOUNCE_OK);vis_budget tb=qb();double p[3]={0},n[3]={0,0,1},out[3]={-1,-2,-3};assert(floor_world_visible(s,p,n,&tb,&ww,out)==BOUNCE_OK);for(unsigned k=0;k<3;k++)assert(out[k]==(which==0?l.world_radiance[k]:0));assert(ww.queries==16&&ww.misses==(which==0?16:0));bounce_scene_release(s);vis_scene_release(v);scenarios++;
 }
 /* Exhaust one quota after a successful world query. Partial traversal stays
  * charged, while both public radiance outputs retain their sentinels. */
 for(unsigned quota=0;quota<3;quota++){
  vis_scene*v=planes(1,-1,-100,0,0,1);FoxDiskScene l=lamps(1,10);bounce_ground ground=gr(3);bounce_scene*s=scene(v,&l,gen(),&ground);bounce_floor_work fw;bounce_floor_world_work ww;vis_budget db,tb;bounce_result out,saved;bounce_floor_world_result wr,savedwr;memset(&out,0x5a,sizeof out);saved=out;memset(&wr,0x5a,sizeof wr);savedwr=wr;funds(&fw,&ww,&db,&tb);
  if(quota==0)tb.limit.rays=50;else if(quota==1)tb.limit.node_visits=50;else tb.limit.triangle_tests=2;
  assert(evaluated(s,1,(double[3]){.2,.4,.6},&fw,&ww,&db,&tb,&out,&wr)==BOUNCE_BUDGET);assert(!memcmp(&out,&saved,sizeof out)&&!memcmp(&wr,&savedwr,sizeof wr));assert(ww.evaluations==1&&ww.queries>=1&&fww_valid(&ww));assert(tb.used.rays<=tb.limit.rays&&tb.used.node_visits<=tb.limit.node_visits&&tb.used.triangle_tests<=tb.limit.triangle_tests);bounce_scene_release(s);vis_scene_release(v);scenarios++;
 }
 printf("INDEPENDENT_FLOOR_WORLD_PASS scenarios=%u partial_misses=%u/256 work_cap=%llu\n",scenarios,misses,(unsigned long long)BOUNCE_FLOOR_WORLD_WORK_CAP);return 0;
}
