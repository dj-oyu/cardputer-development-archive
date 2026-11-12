/* Include the implementation only in this test to inspect private direction. */
#include "transport/bounce.c"
#include <assert.h>
#include <stdio.h>
static vis_budget tb(void){return (vis_budget){{20000000,800000000,300000000},{0,0,0}};}
static vis_budget db(void){return (vis_budget){{1000000,100000000,50000000},{0,0,0}};}
static bounce_triangle attr(void){bounce_triangle a={0};a.double_sided=1;for(int j=0;j<3;j++){a.v[j].front[2]=32767;a.v[j].back[2]=-32767;a.v[j].a565=0x8410;a.v[j].b565=0xbe72;a.v[j].mask=(float)(j-1);}return a;}
static void directions(void){
 const unsigned counts[]={16,64,256};const double phases[]={0,.38196601125,.61803398875};
 const double normals[][3]={{0,0,1},{0,0,-1},{1,0,0},{0,1,0},{.2,-.7,.9}};
 for(unsigned ni=0;ni<5;ni++){double n[3];assert(norm(normals[ni],n));
 for(unsigned ci=0;ci<3;ci++)for(unsigned pi=0;pi<3;pi++){unsigned count=counts[ci],m=count==16?2:count==64?4:8;
 for(unsigned i=0;i<count;i++){double d[3],old[3];direction_diag(n,count,i,phases[pi],d);assert(isfinite(d[0])&&isfinite(d[1])&&isfinite(d[2]));assert(fabs(dot(d,d)-1)<1e-12);double cosine=dot(d,n);assert(cosine>0&&cosine<=1);assert(fabs(cosine-sqrt(1-(i/(4*m)+.5)/m))<1e-12);
 if(pi==0&&count!=256){direction(n,count,i,old);assert(!memcmp(d,old,sizeof(d)));}
 }} }
}
int main(void){directions();
 bounce_generation g={.visibility={1,1,1},.material=1,.emission=1};
 /* Finite upper reflecting square and lower emitting square, no image inputs. */
 double xyz[]={-1,-1,1,1,-1,1,1,1,1,-1,1,1,-2,-2,-1,2,-2,-1,2,2,-1,-2,2,-1};
 uint32_t ix[]={0,1,2,0,2,3,4,5,6,4,6,7};
 bounce_triangle attrs[4];for(int i=0;i<4;i++)attrs[i]=attr();
 FoxDiskLightInput inputs[3]={0};for(int i=0;i<3;i++){inputs[i].shape=FOX_DISK_SHAPE_DISK;inputs[i].center[0]=3+i*.25;inputs[i].center[2]=i==2?-2:3;inputs[i].rotation_xyz[0]=i==2?3.14159265358979323846:0;inputs[i].power=10;inputs[i].diameter=.5;for(int k=0;k<3;k++)inputs[i].color[k]=.2+.3*k;}
 FoxDiskScene lights;double world[]={.25,.5,1};assert(fox_disk_scene_init(&lights,inputs,world,1)==FOX_DISK_OK);
 vis_scene *geometry=NULL;assert(vis_scene_build(&geometry,xyz,8,ix,4,g.visibility,(vis_limits){2048,4095,524288})==VIS_OK);
 bounce_ground ground={.mode=BOUNCE_GROUND_PRIMARY_LE,.object_id=1,.first_triangle=2,.triangle_count=2,.le={.18,2,4}};
 bounce_scene *scene=NULL;assert(bounce_scene_build_ground(&scene,geometry,attrs,4,&lights,1,g,262144,&ground)==BOUNCE_OK);
 bounce_binding b={0};assert(bounce_binding_set(&b,scene,g)==BOUNCE_OK);bounce_scene_release(scene);vis_scene_release(geometry);
 /* Poison caller arrays and release both original owners: retained binding owns fixture. */
 memset(xyz,0xa5,sizeof(xyz));memset(attrs,0xa5,sizeof(attrs));memset(&lights,0xa5,sizeof(lights));
 double p[]={.13,-.21,0},rho[]={.21,.43,.79};double normals[][3]={{0,0,2},{0,0,-3},{.7,.4,1}};
 unsigned equality_cases=0;int seen_direct=0,seen_world=0,seen_bounce=0,seen_ground=0;
 for(unsigned ni=0;ni<3;ni++)for(unsigned mode=0;mode<3;mode++)for(unsigned outer=16;outer<=64;outer*=4)for(unsigned inner=16;inner<=64;inner*=4){
  vis_budget a=db(),at=tb(),c=db(),ct=tb();bounce_result old,diag;
  assert(bounce_eval(&b,g,p,normals[ni],rho,(bounce_mode)mode,outer,inner,&a,&at,&old)==BOUNCE_OK);
  assert(bounce_eval_diagnostic(&b,g,p,normals[ni],rho,(bounce_mode)mode,outer,inner,0,0,&c,&ct,&diag)==BOUNCE_OK);
  assert(!memcmp(&old,&diag,sizeof(old)));assert(!memcmp(&a,&c,sizeof(a)));assert(!memcmp(&at,&ct,sizeof(at)));equality_cases++;
  seen_direct|=old.direct[0]>0;seen_world|=old.world[0]>0;seen_bounce|=old.bounce[0]>0;seen_ground|=old.ground[0]>0;
 }
 assert(seen_direct&&seen_world&&seen_bounce&&seen_ground);
 const unsigned counts[]={16,64,256};
 for(unsigned i=0;i<3;i++)for(unsigned inner=16;inner<=64;inner*=4)for(int phase=0;phase<2;phase++){
  vis_budget a=db(),t=tb();bounce_result r;assert(bounce_eval_diagnostic(&b,g,p,normals[0],rho,BOUNCE_ONE,counts[i],inner,phase?.38196601125:0,phase?.61803398875:0,&a,&t,&r)==BOUNCE_OK);assert(r.counters.primary_rays==counts[i]);
 }
 const unsigned badcounts[]={0,1,15,17,32,65,255,257,UINT32_MAX};
 bounce_result sentinel,before;memset(&sentinel,0x5a,sizeof(sentinel));before=sentinel;
 for(unsigned i=0;i<sizeof(badcounts)/sizeof(*badcounts);i++)for(int which=0;which<2;which++){
  vis_budget a=db(),t=tb(),a0=a,t0=t;assert(bounce_eval_diagnostic(&b,g,p,normals[0],rho,BOUNCE_ONE,which?16:badcounts[i],which?badcounts[i]:16,0,0,&a,&t,&sentinel)==BOUNCE_INVALID);assert(!memcmp(&before,&sentinel,sizeof(before)));assert(!memcmp(&a,&a0,sizeof(a))&&!memcmp(&t,&t0,sizeof(t)));
 }
 {vis_budget a=db(),t=tb();assert(bounce_eval_diagnostic(&b,g,p,normals[0],rho,BOUNCE_ONE,16,256,0,0,&a,&t,&sentinel)==BOUNCE_INVALID);}
 const double badphases[]={NAN,INFINITY,-INFINITY,-.1,1,2};
 for(unsigned i=0;i<6;i++)for(int which=0;which<2;which++){
  vis_budget a=db(),t=tb(),a0=a,t0=t;assert(bounce_eval_diagnostic(&b,g,p,normals[0],rho,BOUNCE_ONE,16,16,which?0:badphases[i],which?badphases[i]:0,&a,&t,&sentinel)==BOUNCE_INVALID);assert(!memcmp(&before,&sentinel,sizeof(before)));assert(!memcmp(&a,&a0,sizeof(a))&&!memcmp(&t,&t0,sizeof(t)));
 }
 /* Exhaust rays/nodes/triangles separately in each shared budget. */
 for(int transport=0;transport<2;transport++)for(int field=0;field<3;field++){
  vis_budget a=db(),t=tb();vis_budget *limited=transport?&t:&a;
  if(field==0)limited->limit.rays=2;else if(field==1)limited->limit.node_visits=2;else limited->limit.triangle_tests=2;
  assert(bounce_eval_diagnostic(&b,g,p,normals[0],rho,BOUNCE_ONE,256,64,.38196601125,.61803398875,&a,&t,&sentinel)==BOUNCE_BUDGET);
  assert(!memcmp(&before,&sentinel,sizeof(before)));assert(limited->used.rays>0);assert(limited->used.rays<=limited->limit.rays&&limited->used.node_visits<=limited->limit.node_visits&&limited->used.triangle_tests<=limited->limit.triangle_tests);
 }
 bounce_binding_clear(&b);printf("PASS: %u byte-exact original/diagnostic component+counter+budget comparisons; all direction patterns; valid arms; invalid counts/phases; six failure-atomic budget cases; owned fixture lifetime\n",equality_cases);return 0;
}
