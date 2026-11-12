#define main author_main
#include "transport/test_ground.c"
#undef main
#include <float.h>
int main(void){
 bounce_generation g={.visibility={1,1,1},.material=1,.emission=1};
 double xyz[]={-.8,-.8,1,.8,-.8,1,.8,.8,1,-.8,.8,1};uint32_t idx[]={0,1,2,0,2,3};vis_limits lim={2048,4095,524288};vis_scene *v=0;
 assert(vis_scene_build(&v,xyz,4,idx,2,g.visibility,lim)==VIS_OK);
 FoxDiskScene l=lights(0);bounce_triangle a[2]={attribute(),attribute()};
 bounce_ground gr={.mode=BOUNCE_GROUND_PRIMARY_LE,.object_id=77,.first_triangle=0,.triangle_count=2,.le={.21,.195,.1625}};
 bounce_scene *s=0;assert(bounce_scene_build_ground(&s,v,a,2,&l,1,g,262144,&gr)==BOUNCE_OK);
 double p[]={0,0,0},n[]={0,0,1},rho[]={.2,.4,.6};
 bounce_result orig[2];for(int j=0;j<2;j++){unsigned samples=j?64:16;orig[j]=eval(s,g,p,n,rho,samples);bounce_result *r=&orig[j];assert(r->counters.primary_hits&&r->counters.primary_misses);assert(r->counters.primary_hits+r->counters.primary_misses==samples);assert(r->counters.primary_ground_hits==r->counters.primary_hits);for(int k=0;k<3;k++){double expected=rho[k]*(gr.le[k]*r->counters.primary_hits+l.world_radiance[k]*r->counters.primary_misses)/samples;assert(fabs(r->combined[k]-expected)<1e-14);}assert(!r->counters.secondary_world_rays&&!r->counters.secondary_direct_queries);}
 // Ground ignores arbitrary valid palettes, normals and one-sided flags.
 for(int t=0;t<2;t++){a[t].double_sided=0;for(int j=0;j<3;j++){a[t].v[j].a565=0;a[t].v[j].b565=0xf800;a[t].v[j].mask=123;memset(a[t].v[j].front,0,6);memset(a[t].v[j].back,0,6);a[t].v[j].front[0]=32767;a[t].v[j].back[1]=32767;}}
 g.material++;assert(bounce_scene_build_ground(&s,v,a,2,&l,-1,g,262144,&gr)==BOUNCE_OK);for(int j=0;j<2;j++){bounce_result r=eval(s,g,p,n,rho,j?64:16);assert(!memcmp(&r,&orig[j],sizeof(r)));}
 // Generation/descriptor mismatch is atomic. Invalid canonical OFF is rejected.
 bounce_scene *old=s;bounce_ground bad=gr;bad.mode=BOUNCE_GROUND_OFF;bounce_generation future=g;future.emission++;assert(bounce_scene_build_ground(&s,v,a,2,&l,-1,future,262144,&bad)==BOUNCE_INVALID);assert(s==old);
 bad=gr;bad.le[1]=INFINITY;assert(bounce_scene_build_ground(&s,v,a,2,&l,-1,future,262144,&bad)==BOUNCE_INVALID);assert(s==old);
 // BOUNCE_OFF deliberately ignores ground hemisphere and keeps unoccluded world.
 bounce_binding b={0};assert(bounce_binding_set(&b,s,g)==BOUNCE_OK);vis_budget db=budget(),tb=budget();bounce_result r;assert(bounce_eval(&b,g,p,n,rho,BOUNCE_OFF,16,16,&db,&tb,&r)==BOUNCE_OK);for(int k=0;k<3;k++)assert(r.combined[k]==rho[k]*l.world_radiance[k]);assert(!r.counters.primary_rays&&!tb.used.rays);
 // Release all owner refs and poison source arrays; retained binding remains valid.
 bounce_scene_release(s);vis_scene_release(v);memset(a,0,sizeof(a));memset(&l,0,sizeof(l));memset(&gr,0,sizeof(gr));db=budget();tb=budget();assert(bounce_eval(&b,g,p,n,rho,BOUNCE_ONE,16,16,&db,&tb,&r)==BOUNCE_OK);assert(!memcmp(&r,&orig[0],sizeof(r)));
 // Exhaustion retains consumed work, leaves every output byte intact.
 db=budget();tb=budget();tb.limit.rays=1;memset(&r,0x5a,sizeof(r));bounce_result before=r;assert(bounce_eval(&b,g,p,n,rho,BOUNCE_ONE,16,16,&db,&tb,&r)==BOUNCE_BUDGET);assert(!memcmp(&r,&before,sizeof(r))&&tb.used.rays==1);bounce_binding_clear(&b);
 puts("independent partial-floor mixture, material isolation, OFF, generation, owned lifetime and atomic failure PASS");return 0;
}
