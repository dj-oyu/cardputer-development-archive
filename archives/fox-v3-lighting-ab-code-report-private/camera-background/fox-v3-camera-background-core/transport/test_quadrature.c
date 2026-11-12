#include "bounce.h"
#include <assert.h>
#include <math.h>
#include <stdio.h>
#include <string.h>
static const double pi=3.14159265358979323846;
static void ray(unsigned m,unsigned i,double d[3]){unsigned ring=i/(4*m),az=i%(4*m);double r=sqrt((ring+.5)/m),ph=2*pi*(az+.5*(ring%2))/(4*m);/* For +Z least-axis basis: u=-Y,v=+X. */d[0]=r*sin(ph);d[1]=-r*cos(ph);d[2]=sqrt(1-r*r);}
static vis_budget budget(void){vis_budget b={{20000000,800000000,300000000},{0,0,0}};return b;}
static bounce_triangle attr(void){bounce_triangle a={0};a.double_sided=1;for(int v=0;v<3;v++){a.v[v].front[2]=32767;a.v[v].back[2]=-32767;a.v[v].a565=a.v[v].b565=0xffff;}return a;}
static vis_scene *plane(double extent,vis_generation g){double p[]={-extent,-extent,1,extent,-extent,1,extent,extent,1,-extent,extent,1};uint32_t idx[]={0,1,2,0,2,3};vis_scene *s=NULL;vis_limits l={2048,4095,524288};assert(vis_scene_build(&s,p,4,idx,2,g,l)==VIS_OK);return s;}
int main(void){bounce_generation g={{1,1,1},1};FoxDiskLightInput li[3]={0};for(int i=0;i<3;i++){li[i].shape=FOX_DISK_SHAPE_DISK;li[i].center[0]=i*.3;li[i].center[2]=-2;li[i].rotation_xyz[0]=pi;li[i].power=10;li[i].diameter=.5;li[i].color[0]=li[i].color[1]=li[i].color[2]=1;}
 double w[3]={0,0,0};FoxDiskScene l;assert(fox_disk_scene_init(&l,li,w,1)==FOX_DISK_OK);vis_scene *v=plane(100,g.visibility);bounce_triangle a[2]={attr(),attr()};bounce_scene *s=NULL;assert(bounce_scene_build(&s,v,a,2,&l,1,g,262144)==BOUNCE_OK);bounce_binding b={0};assert(bounce_binding_set(&b,s,g)==BOUNCE_OK);double p[3]={0,0,0},n[3]={0,0,1},rho[3]={.25,.5,.75},ry[3]={1,1,1};
 for(unsigned outer=16;outer<=64;outer*=4){vis_budget db=budget(),tb=budget();bounce_result out;assert(bounce_eval(&b,g,p,n,rho,BOUNCE_ONE,outer,16,&db,&tb,&out)==BOUNCE_OK);double expected[3]={0,0,0};unsigned m=outer==16?2:4;for(unsigned j=0;j<outer;j++){double d[3],hit[3],normal[3]={0,0,-1},rgb[3];ray(m,j,d);for(int k=0;k<3;k++)hit[k]=d[k]/d[2];assert(fox_disk_eval16(&l,hit,normal,ry,rgb)==FOX_DISK_OK);for(int k=0;k<3;k++)expected[k]+=rho[k]*rgb[k]/outer;}for(int k=0;k<3;k++)assert(fabs(expected[k]-out.combined[k])<1e-12);assert(out.counters.secondary_direct_queries==outer*48);assert(out.counters.primary_direct_queries==0);assert(tb.used.rays==outer+outer*48+outer*16);printf("area secondary outer%u value %.12g, exact visibility-free reference matched\n",outer,out.combined[0]);}
 /* Dense analytic-plane area reference, still no image data. */
 for(unsigned m=16;m<=64;m*=2){double sum=0;unsigned count=4*m*m;for(unsigned j=0;j<count;j++){double d[3],hit[3],normal[3]={0,0,-1},rgb[3];ray(m,j,d);for(int k=0;k<3;k++)hit[k]=d[k]/d[2];assert(fox_disk_eval16(&l,hit,normal,ry,rgb)==FOX_DISK_OK);sum+=rho[0]*rgb[0]/count;}printf("dense plane area %u samples value %.12g\n",count,sum);}
 bounce_binding_clear(&b);bounce_scene_release(s);vis_scene_release(v);
 /* Partial square blocker: convergent uniform-world reference via public nearest,
  * independently evaluated dense cosine grids. Values reported, never fitted. */
 v=plane(.8,g.visibility);vis_binding vb={0};assert(vis_binding_set(&vb,v,g.visibility)==VIS_OK);double fraction[5];unsigned bands[5]={2,4,16,32,64};for(int test=0;test<5;test++){unsigned m=bands[test],count=4*m*m,misses=0;vis_budget bu=budget();for(unsigned i=0;i<count;i++){double d[3];ray(m,i,d);vis_hit h;assert(vis_ray_nearest(&vb,g.visibility,p,d,&bu,&h)==VIS_OK);if(!h.found)misses++;}fraction[test]=(double)misses/count;printf("partial square world: %u samples visible fraction %.12g\n",count,fraction[test]);}printf("errors against16384: 16 %.12g,64 %.12g,1024 %.12g,4096 %.12g\n",fabs(fraction[0]-fraction[4]),fabs(fraction[1]-fraction[4]),fabs(fraction[2]-fraction[4]),fabs(fraction[3]-fraction[4]));assert(fabs(fraction[3]-fraction[4])<.01);
 vis_binding_clear(&vb);vis_scene_release(v);puts("quadrature tests passed");return 0;}
