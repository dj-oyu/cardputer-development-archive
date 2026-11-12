#include "../code/chain.h"
#define main unused_synthetic_main
#include "../../ayatsuri-fixed-integer-light-20261105/test_integer_light.c"
#undef main
#include "../../fox-v3-indexed-bvh-bounds/cache/candidate_profile.c"
#ifdef RAW_NORMAL
#define RUN_CHAIN chain_block_raw_normals
#else
#define RUN_CHAIN chain_block
#endif
static agx_block_cache oracle;
static uint16_t pack(const double rgb[3]){float f[3],v[3];unsigned q[3];for(unsigned k=0;k<3;k++)f[k]=(float)rgb[k];int s=agx_cache_profile_eval(&oracle,f,v);assert(s<=1);for(unsigned k=0;k<3;k++)q[k]=(unsigned)lroundf(v[k]*(k==1?63:31));return (q[0]<<11)|(q[1]<<5)|q[2];}
/* Diagnostic double arithmetic on QUANTIZED scene/pixel inputs. Not runtime. */
static void quantized_oracle(const il_scene*s,const il_pixel*p,double out[3],double*grazing){
 double nr=0;for(unsigned k=0;k<3;k++)nr+=(double)p->normal[k]*p->normal[k];nr=sqrt(nr);*grazing=1;
 for(unsigned k=0;k<3;k++)out[k]=s->world[k]/16777216.0;
 for(unsigned l=0;l<3;l++){const il_light*a=&s->light[l];double nl=0,sum=0;for(unsigned k=0;k<3;k++)nl+=(double)a->normal[k]*a->normal[k];nl=sqrt(nl);
 for(unsigned j=0;j<16;j++){double d[3],rr=0,dr=0,ds=0;for(unsigned k=0;k<3;k++){d[k]=(a->sample[j][k]-p->p[k])/65536.0;rr+=d[k]*d[k];}for(unsigned k=0;k<3;k++){dr+=p->normal[k]/nr*d[k]/sqrt(rr);ds-=a->normal[k]/nl*d[k]/sqrt(rr);}if(dr>0&&dr<*grazing)*grazing=dr;if(dr>0&&ds>0&&(p->visible[l]&(1u<<j)))sum+=dr*ds/rr;}
 for(unsigned k=0;k<3;k++)out[k]+=a->power[k]/65536.0*sum/16;}
 for(unsigned k=0;k<3;k++)out[k]*=p->rho[k]/32767.0;
}
int main(int argc,char**argv){assert(argc==4&&sizeof(FoxDiskScene)==408);assert(fegetround()==FE_TONEAREST);FILE*f=fopen(argv[1],"rb");assert(f);unsigned char magic[8];FoxDiskScene scene;assert(fread(magic,1,8,f)==8&&fread(&scene,1,408,f)==408);fclose(f);assert(fox_disk_scene_validate(&scene)==FOX_DISK_OK);il_scene fixed;prepare(&scene,&fixed);agx_block_cache cache;assert(private_integer_profile_bind(&cache));agx_cache_init(&oracle);assert(agx_cache_bind_profile(&oracle));
 f=fopen(argv[2],"rb");assert(f);double raw[8000][9];il_pixel px[8000];unsigned count=0;uint16_t masks[3]={65535,65535,65535};while(fread(raw[count],8,9,f)==9){
#ifdef RAW_NORMAL
 for(unsigned k=0;k<3;k++){px[count].p[k]=pos(raw[count][k]);assert(fabs(raw[count][3+k])<=1);px[count].normal[k]=(int16_t)nearbyint(raw[count][3+k]*32767);px[count].rho[k]=(uint16_t)nearbyint(raw[count][6+k]*32767);px[count].visible[k]=masks[k];}
#else
 pixel(raw[count],raw[count]+3,raw[count]+6,masks,&px[count]);
#endif
assert(++count<8000);}assert(feof(f));fclose(f);
 FILE*csv=fopen(argv[3],"w");assert(csv);fprintf(csv,"index,status,old565,prepared565,integer_light565,integer_hdr19_float565,new565,grazing,min_rho,max_rho,ref_r,ref_g,ref_b,prepared_r,prepared_g,prepared_b,int_r,int_g,int_b,h19_r,h19_g,h19_b\n");chain_result scalar[8000];unsigned statuses[50]={0};
 for(unsigned i=0;i<count;i++){assert(RUN_CHAIN(&fixed,px+i,1,&cache,scalar+i));chain_result*r=scalar+i;assert(r->status>=0&&r->status<50);statuses[r->status]++;if(r->status>1)continue;double ref[3],prepared[3],got[3],h19[3],grazing;assert(fox_disk_eval16(&scene,raw[i],raw[i]+3,raw[i]+6,ref)==FOX_DISK_OK);quantized_oracle(&fixed,px+i,prepared,&grazing);for(unsigned k=0;k<3;k++){got[k]=r->hdr24[k]/16777216.0;h19[k]=r->hdr19[k]/524288.0;}
 fprintf(csv,"%u,%d,%u,%u,%u,%u,%u,%.17g,%.17g,%.17g",i,r->status,pack(ref),pack(prepared),pack(got),pack(h19),r->pixel,grazing,fmin(raw[i][6],fmin(raw[i][7],raw[i][8])),fmax(raw[i][6],fmax(raw[i][7],raw[i][8])));for(unsigned k=0;k<3;k++)fprintf(csv,",%.17g",ref[k]);for(unsigned k=0;k<3;k++)fprintf(csv,",%.17g",prepared[k]);for(unsigned k=0;k<3;k++)fprintf(csv,",%.17g",got[k]);for(unsigned k=0;k<3;k++)fprintf(csv,",%.17g",h19[k]);fputc('\n',csv);
 }fclose(csv);
 for(unsigned width=1;width<=8;width*=2){unsigned compared=0;for(unsigned i=0;i<count;){unsigned n=count-i>=width?width:1;chain_result b[8];assert(RUN_CHAIN(&fixed,px+i,n,&cache,b));for(unsigned lane=0;lane<n;lane++){assert(b[lane].status==scalar[i+lane].status&&b[lane].pixel==scalar[i+lane].pixel&&!memcmp(b[lane].hdr24,scalar[i+lane].hdr24,24)&&!memcmp(b[lane].hdr19,scalar[i+lane].hdr19,12));compared++;}i+=n;}printf("width=%u compared=%u mismatch=0\n",width,compared);}
 printf("total=%u",count);for(unsigned i=0;i<50;i++)if(statuses[i])printf(" status%u=%u",i,statuses[i]);puts("");return 0;}
