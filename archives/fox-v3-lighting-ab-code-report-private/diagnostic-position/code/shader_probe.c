#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <math.h>
#include "fox_disk_lighting.h"
#include "ayatsuri/ayatsuri_shade.h"
static int load_disk(const char *path,FoxDiskScene *out){
 FILE *f=fopen(path,"r");if(!f)return 0;char magic[10]={0};FoxDiskLightInput lights[3];memset(lights,0,sizeof lights);double world[3],strength;int ok=fscanf(f,"%9s",magic)==1&&!strcmp(magic,"FOXDISK1");
 for(unsigned j=0;ok&&j<3;j++){lights[j].shape=FOX_DISK_SHAPE_DISK;for(unsigned k=0;ok&&k<3;k++)ok=fscanf(f,"%lf",&lights[j].center[k])==1;for(unsigned k=0;ok&&k<3;k++)ok=fscanf(f,"%lf",&lights[j].rotation_xyz[k])==1;for(unsigned k=0;ok&&k<3;k++)ok=fscanf(f,"%lf",&lights[j].color[k])==1;if(ok)ok=fscanf(f,"%lf %lf",&lights[j].power,&lights[j].diameter)==2;}
 for(unsigned k=0;ok&&k<3;k++)ok=fscanf(f,"%lf",world+k)==1;if(ok)ok=fscanf(f,"%lf",&strength)==1;char extra;if(ok&&fscanf(f," %c",&extra)!=EOF)ok=0;fclose(f);return ok&&fox_disk_scene_init(out,lights,world,strength)==FOX_DISK_OK;
}

static FoxDiskScene scene;
int init(const char *path){return load_disk(path,&scene);}
int shade(const double *p,const double *n,unsigned albedo,unsigned short *out,double *raw){
 double rho[3]={((albedo>>11)&31)/31.0,((albedo>>5)&63)/63.0,(albedo&31)/31.0};
 for(unsigned k=0;k<3;k++)rho[k]=ayatsuri_srgb_decode((float)rho[k]);
 if(fox_disk_eval16(&scene,p,n,rho,raw)!=FOX_DISK_OK)return 0;
 unsigned q[3];for(unsigned k=0;k<3;k++){float value=(float)fmin(1.0,raw[k]);value=ayatsuri_srgb_encode(value);q[k]=(unsigned)lroundf(value*(k==1?63:31));}
 *out=(q[0]<<11)|(q[1]<<5)|q[2];return 1;
}
