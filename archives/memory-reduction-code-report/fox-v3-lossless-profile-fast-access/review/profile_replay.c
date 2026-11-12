#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <assert.h>
int old_eval(const float*,float*);
int new_eval(const float*,float*);
static uint16_t packed(float *v){return (uint16_t)(((unsigned)floor((double)(v[0]*31)+0.5)<<11)|((unsigned)floor((double)(v[1]*63)+0.5)<<5)|(unsigned)floor((double)(v[2]*31)+0.5));}
int main(int argc,char **argv){assert(argc==3||argc==4);int doubles=strcmp(argv[1],"f64")==0;FILE *f=fopen(argv[2],"rb"),*q=argc==4?fopen(argv[3],"rb"):NULL;assert(f&&(!doubles||q));size_t n=0,invalid=0,clamp=0;for(;;){float in[3];double d[3];size_t got=fread(doubles?(void*)d:(void*)in,1,doubles?sizeof d:sizeof in,f);if(!got)break;assert(got==(doubles?sizeof d:sizeof in));if(doubles)for(unsigned k=0;k<3;k++)in[k]=(float)d[k];float a[3]={.123f,.456f,.789f},b[3]={.123f,.456f,.789f};int x=old_eval(in,a),y=new_eval(in,b);assert(x==y&&!memcmp(a,b,sizeof a));invalid+=x==2;clamp+=x==1;if(x<2){assert(packed(a)==packed(b));if(q){unsigned char v[2];assert(fread(v,1,2,q)==2);assert(packed(a)==(uint16_t)(v[0]+256u*v[1]));}}else assert(!q);n++;}assert(!ferror(f));fclose(f);if(q){assert(fgetc(q)==EOF&&!ferror(q));fclose(q);}printf("%s PASS samples=%zu invalid=%zu clamped=%zu\n",argv[2],n,invalid,clamp);return 0;}
