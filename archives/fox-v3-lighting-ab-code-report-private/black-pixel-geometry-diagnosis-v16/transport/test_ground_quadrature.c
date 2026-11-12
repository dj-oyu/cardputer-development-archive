#define main existing_ground_test_main
#include "test_ground.c"
#undef main
int main(void){
 const double pi=acos(-1.0),a=1,h=1;double t=a/sqrt(a*a+h*h),analytic=4/pi*t*atan(t),area=0;
 for(unsigned y=0;y<512;y++)for(unsigned x=0;x<512;x++){double u=-a+(x+.5)*2*a/512,w=-a+(y+.5)*2*a/512,d=u*u+w*w+h*h;area+=h*h/(pi*d*d)*(2*a/512)*(2*a/512);}
 assert(fabs(area-analytic)<2e-6);
 bounce_generation g={.visibility={1,1,1},.material=1,.emission=1};double xyz[]={-1,-1,1,1,-1,1,1,1,1,-1,1,1};uint32_t ix[]={0,1,2,0,2,3};vis_scene *v=NULL;assert(vis_scene_build(&v,xyz,4,ix,2,g.visibility,(vis_limits){2048,4095,524288})==VIS_OK);bounce_triangle attrs[2]={attribute(),attribute()};FoxDiskScene l=lights(0);for(int k=0;k<3;k++)l.world_radiance[k]=0;
 bounce_ground ground={.mode=BOUNCE_GROUND_PRIMARY_LE,.object_id=1,.first_triangle=0,.triangle_count=2,.le={1,1,1}};bounce_scene *s=NULL;assert(bounce_scene_build_ground(&s,v,attrs,2,&l,1,g,262144,&ground)==BOUNCE_OK);double p[3]={0},n[3]={0,0,1},rho[3]={1,1,1};
 printf("finite square a=h=1 analytic cosine fraction %.15g, Cartesian512x512 %.15g\n",analytic,area);
 for(unsigned count=16;count<=64;count*=4){bounce_result r=eval(s,g,p,n,rho,count);assert(r.world[0]==0&&r.bounce[0]==0&&r.direct[0]==0);assert(r.ground[0]==(double)r.counters.primary_ground_hits/count);printf("actual outer%u Le fraction %.15g relative_error %.15g\n",count,r.ground[0],(r.ground[0]-analytic)/analytic);}
 unsigned hit=0;for(unsigned ir=0;ir<64;ir++)for(unsigned ip=0;ip<256;ip++){double r=sqrt((ir+.5)/64),phi=2*pi*(ip+.5*(ir%2))/256,z=sqrt(1-r*r);double x=r*cos(phi)/z,y=r*sin(phi)/z;hit+=fabs(x)<=1&&fabs(y)<=1;}
 printf("independent cosine16384 %.15g relative_error %.15g\n",hit/16384.0,(hit/16384.0-analytic)/analytic);bounce_scene_release(s);vis_scene_release(v);return 0;
}
