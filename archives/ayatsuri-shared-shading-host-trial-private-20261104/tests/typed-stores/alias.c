/* Synthetic, type-correct overlap test. Actual pair implementations link as separate TUs. */
#include "ayatsuri/ayatsuri_shade.h"
#include <fenv.h>
#include <float.h>
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
_Static_assert(sizeof(uint16_t)==2,"16-bit colors required");
_Static_assert(FLT_RADIX==2 && FLT_MANT_DIG==24,"binary32 required");
typedef void (*pair_fn)(const int16_t[3],const uint16_t[2],uint8_t,const float[9],const float[8],const ayatsuri_shade_basis*,uint16_t[2]);
void control_pair(const int16_t[3],const uint16_t[2],uint8_t,const float[9],const float[8],const ayatsuri_shade_basis*,uint16_t[2]);
void candidate_pair(const int16_t[3],const uint16_t[2],uint8_t,const float[9],const float[8],const ayatsuri_shade_basis*,uint16_t[2]);
static uint64_t cases,calls,checks,canary_checks,unaligned4,ties,failures,digest=UINT64_C(14695981039346656037);
static uint32_t rng=0x9e3779b9;
static uint32_t next(void){uint32_t x=rng;x^=x<<13;x^=x>>17;x^=x<<5;return rng=x;}
static float unit(void){return (next()>>8)*(1.0f/16777215.0f);}
static void mix(uint16_t x){digest^=x&255;digest*=UINT64_C(1099511628211);digest^=x>>8;digest*=UINT64_C(1099511628211);}
static void check(const int16_t n[3],uint16_t a,uint16_t b,uint8_t thickness,const float light[9],const float m[8]){
    ayatsuri_shade_basis basis;
    if(!ayatsuri_shade_prepare(light,&basis)){fprintf(stderr,"unexpected invalid direction\n");exit(2);}
    /* Oracle reads both original albedos before any output mutation. */
    const uint16_t want[2]={ayatsuri_shade_sample(n,a,thickness,light,m,&basis),ayatsuri_shade_sample(n,b,thickness,light,m,&basis)};
    const pair_fn fns[2]={control_pair,candidate_pair};
    const int shifts[5]={-1,0,1,-3,3};
    ++cases;
    for(unsigned parity=0;parity<2;parity++)for(unsigned layout=0;layout<5;layout++)for(unsigned fn=0;fn<2;fn++){
        _Alignas(4) uint16_t buf[16],expected[16];
        const unsigned ai=6+parity,oi=(unsigned)((int)ai+shifts[layout]);
        for(unsigned j=0;j<16;j++)buf[j]=(uint16_t)(0xa5c3u^(j*0x1537u));
        buf[ai]=a;buf[ai+1]=b;
        memcpy(expected,buf,sizeof buf);expected[oi]=want[0];expected[oi+1]=want[1];
        if((uintptr_t)(buf+oi)%2){fprintf(stderr,"invalid uint16 alignment\n");exit(2);}
        if((uintptr_t)(buf+oi)%4==2)++unaligned4;
        fns[fn](n,buf+ai,thickness,light,m,&basis,buf+oi);++calls;
        for(unsigned j=0;j<16;j++){
            if(j==oi||j==oi+1)++checks;else ++canary_checks;
            if(buf[j]!=expected[j]){if(failures<10)fprintf(stderr,"case=%"PRIu64" fn=%u shift=%d parity=%u index=%u got=%04x expected=%04x\n",cases,fn,shifts[layout],parity,j,buf[j],expected[j]);++failures;}
            mix(buf[j]);
        }
    }
}
static int16_t quantize(double v){return (int16_t)fmax(-32767,fmin(32767,floor(v*32767+0.5)));}
int main(void){
    if(fegetround()!=FE_TONEAREST)return 2;
    const float dirs[][6]={{1,0,0,1,0,0},{1,0,0,-1,0,0},{-0.0f,1,0,0,0,1},{FLT_TRUE_MIN,FLT_TRUE_MIN,0,0,FLT_TRUE_MIN,FLT_TRUE_MIN},{FLT_MAX,-FLT_MAX,1,FLT_MAX,0,-FLT_MAX}};
    const int16_t ns[][3]={{32767,0,0},{-32767,0,0},{1,32767,-1},{-1,-32767,1},{1,0,0},{32767,32767,32767}};
    const uint8_t ts[]={0,1,127,128,254,255};
    float light[9]={1,0,0,1,0,0,1,0.5f,0.25f},m[8]={0.2f,0.4f,0.1f,1.5f,0.3f,0.2f,0.5f,1};
    for(unsigned i=0;i<65536;i++)check(ns[i%6],(uint16_t)i,(uint16_t)(65535-i),ts[i%6],light,m);
    for(unsigned d=0;d<5;d++)for(unsigned n=0;n<6;n++)for(unsigned t=0;t<6;t++){
        memcpy(light,dirs[d],6*sizeof(float));m[3]=t%2?128:1;
        check(ns[n],0xf81f,0x07e0,ts[t],light,m);
    }
    const int ks[]={0,1,2,31,255,8191,16383,23169,32765};
    for(unsigned k=0;k<9;k++)for(unsigned ax=0;ax<3;ax++){
        double v[3]={0,0,0};v[ax]=(ks[k]+0.5)/32767.0;v[(ax+1)%3]=sqrt(1-v[ax]*v[ax]);
        int16_t front[3],back[3];bool different=false;
        for(unsigned j=0;j<3;j++){front[j]=quantize(v[j]);back[j]=quantize(-v[j]);different|=back[j]!=-front[j];}
        ties+=different;
        for(unsigned d=0;d<5;d++)for(unsigned t=0;t<6;t++){
            memcpy(light,dirs[d],6*sizeof(float));m[3]=t%2?1.5f:128;
            check(front,0x7bef,0xf81f,ts[t],light,m);check(back,0x7bef,0xf81f,ts[t],light,m);
        }
    }
    for(unsigned i=0;i<20000;i++){
        int16_t n[3];do{for(unsigned j=0;j<3;j++)n[j]=(int16_t)((int)(next()%65535)-32767);}while(!n[0]&&!n[1]&&!n[2]);
        for(unsigned j=0;j<6;j++)light[j]=2*unit()-1;
        if(!(light[0]||light[1]||light[2]))light[0]=1;
        if(!(light[3]||light[4]||light[5]))light[3]=1;
        for(unsigned j=6;j<9;j++)light[j]=unit();
        for(unsigned j=0;j<8;j++)m[j]=unit();
        m[3]=1+127*unit();
        const uint16_t a=(uint16_t)next(),b=(uint16_t)next();const uint8_t t=(uint8_t)next();
        check(n,a,b,t,light,m);
    }
    if(ties!=27||unaligned4!=calls/2)++failures;
    printf("{\"passed\":%s,\"cases\":%"PRIu64",\"pair_calls\":%"PRIu64",\"exact_color_checks\":%"PRIu64",\"canary_checks\":%"PRIu64",\"output_2_not_4_aligned_calls\":%"PRIu64",\"asymmetric_snorm_ties\":%"PRIu64",\"failures\":%"PRIu64",\"digest\":\"%016"PRIx64"\"}\n",failures?"false":"true",cases,calls,checks,canary_checks,unaligned4,ties,failures,digest);
    return failures?1:0;
}
