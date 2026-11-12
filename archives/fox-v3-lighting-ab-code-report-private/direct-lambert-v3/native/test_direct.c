#include "shader.c"
#include <assert.h>
int main(int argc,char**argv){assert(argc==2&&init(argv[1]));unsigned short bits[3]={65535,65535,65535};FoxDiskScene saved=scene;for(unsigned k=0;k<3;k++)scene.world_radiance[k]=0;unsigned count=0;
 for(int x=-4;x<=4;x++)for(int y=-4;y<=4;y++)for(int z=1;z<=6;z++){
  double p[3]={x*.1,y*.1,z*.4},n[3]={.2+x*.1,.7+y*.1,.6},rho[3]={.57,.092,.008},unit[3],full[3];assert(direct_unit(p,n,bits,unit));assert(fox_disk_eval16(&scene,p,n,rho,full)==FOX_DISK_OK);for(unsigned k=0;k<3;k++)assert(full[k]==unit[k]*rho[k]);count++;
 }
 scene=saved;double p[3]={0,0,1},n[3]={0,0,1},raw[3];unsigned short zero[3]={0,0,0};assert(direct_unit(p,n,zero,raw));assert(raw[0]==0&&raw[1]==0&&raw[2]==0);printf("DIRECT_UNIT_PASS %u full16 worldzero exact; no world term when all direct masked\n",count);return 0;
}
