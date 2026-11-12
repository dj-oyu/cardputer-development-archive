#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "fox_disk_lighting.h"
static int load_disk(const char *path,FoxDiskScene *out){
 FILE *f=fopen(path,"r");if(!f)return 0;char magic[10]={0};FoxDiskLightInput lights[3];memset(lights,0,sizeof lights);double world[3],strength;int ok=fscanf(f,"%9s",magic)==1&&!strcmp(magic,"FOXDISK1");
 for(unsigned j=0;ok&&j<3;j++){lights[j].shape=FOX_DISK_SHAPE_DISK;for(unsigned k=0;ok&&k<3;k++)ok=fscanf(f,"%lf",&lights[j].center[k])==1;for(unsigned k=0;ok&&k<3;k++)ok=fscanf(f,"%lf",&lights[j].rotation_xyz[k])==1;for(unsigned k=0;ok&&k<3;k++)ok=fscanf(f,"%lf",&lights[j].color[k])==1;if(ok)ok=fscanf(f,"%lf %lf",&lights[j].power,&lights[j].diameter)==2;}
 for(unsigned k=0;ok&&k<3;k++)ok=fscanf(f,"%lf",world+k)==1;if(ok)ok=fscanf(f,"%lf",&strength)==1;char extra;if(ok&&fscanf(f," %c",&extra)!=EOF)ok=0;fclose(f);return ok&&fox_disk_scene_init(out,lights,world,strength)==FOX_DISK_OK;
}
int main(int argc,char **argv){if(argc!=3)return 2;FoxDiskScene s;if(!load_disk(argv[1],&s))return 3;FILE*f=fopen(argv[2],"r");if(!f)return 4;double p[3],n[3],rho[3]={1,1,1},rgb[3];while(fscanf(f,"%lf %lf %lf %lf %lf %lf",p,p+1,p+2,n,n+1,n+2)==6){unsigned bands[4]={2,4,16,32};for(unsigned j=0;j<4;j++){FoxDiskStatus q=j==0?fox_disk_eval16(&s,p,n,rho,rgb):fox_disk_eval_diagnostic(&s,p,n,rho,bands[j],rgb);if(q)return 5;printf("%.17g %.17g %.17g%s",rgb[0],rgb[1],rgb[2],j==3?"\n":" ");}}fclose(f);return 0;}
