/* Independent differential stress test for exact per-normal term reuse.
 * Only synthetic numeric inputs; no assets, renderer, device, or timing test.
 * COUNT_MATH=0 checks unmodified optimized arithmetic. COUNT_MATH=1 replaces
 * three libm spellings with transparent counters to prove source-call sharing.
 */
#include <fenv.h>
#include <float.h>
#include <inttypes.h>
#include <math.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifndef COUNT_MATH
#define COUNT_MATH 0
#endif
#ifndef BASELINE_SHADE_HEADER
#define BASELINE_SHADE_HEADER "../baseline/main/ayatsuri/ayatsuri_shade.h"
#endif
#ifndef CANDIDATE_SHADE_HEADER
#define CANDIDATE_SHADE_HEADER "../candidate/main/ayatsuri/ayatsuri_shade.h"
#endif

struct math_counts {uint64_t sqrt_calls,pow_calls,round_calls;};
static struct math_counts *active_counts;
#if COUNT_MATH
static float counted_sqrtf(float x){if(active_counts)++active_counts->sqrt_calls;return sqrtf(x);}
static float counted_powf(float x,float y){if(active_counts)++active_counts->pow_calls;return powf(x,y);}
static long counted_lroundf(float x){if(active_counts)++active_counts->round_calls;return lroundf(x);}
#define sqrtf counted_sqrtf
#define powf counted_powf
#define lroundf counted_lroundf
#endif
#define ayatsuri_shade_unit baseline_unit
#define ayatsuri_shade_channel baseline_channel
#define ayatsuri_shade_basis baseline_basis
#define ayatsuri_shade_prepare baseline_prepare
#define ayatsuri_shade_sample baseline_sample
#include BASELINE_SHADE_HEADER
#undef ayatsuri_shade_unit
#undef ayatsuri_shade_channel
#undef ayatsuri_shade_basis
#undef ayatsuri_shade_prepare
#undef ayatsuri_shade_sample
#undef AYATSURI_SHADE_H
#include CANDIDATE_SHADE_HEADER
#if COUNT_MATH
#undef sqrtf
#undef powf
#undef lroundf
#endif

_Static_assert(sizeof(float)==4&&FLT_RADIX==2&&FLT_MANT_DIG==24,"Requires binary32 float");
_Static_assert(sizeof(uint16_t)==2,"Requires 16-bit uint16_t");
static uint64_t cases,basis_checks,term_checks,color_checks,wrapper_checks;
static uint64_t no_half,front_zero,back_zero,spec_zero,nonzero_spec;
static uint64_t failures,checksum=UINT64_C(14695981039346656037);
static uint64_t quantized_tie_pairs,nonnegated_back_pairs,invalid_rejected;
static struct math_counts baseline_counts,candidate_counts;
static uint32_t rng=UINT32_C(0x9e3779b9);
static uint32_t random_u32(void){uint32_t x=rng;x^=x<<13;x^=x>>17;x^=x<<5;return rng=x;}
static float random_unit(void){return (random_u32()>>8)*(1.0f/16777215.0f);}
static uint32_t float_bits(float x){uint32_t v;memcpy(&v,&x,sizeof v);return v;}
static void mix32(uint32_t v){for(unsigned i=0;i<4;i++){checksum^=(v>>(8*i))&255;checksum*=UINT64_C(1099511628211);}}
static void fail(const char *group,const char *what,uint64_t index,uint32_t a,uint32_t b){
    if(failures<12)fprintf(stderr,"%s case=%" PRIu64 " %s baseline=0x%08" PRIx32 " candidate=0x%08" PRIx32 "\n",group,index,what,a,b);
    failures++;
}

/* Original baseline expression order, independent of the candidate term API.
 * The complete unchanged baseline_sample remains the primary color oracle. */
static ayatsuri_shade_terms original_terms(const int16_t n[3],uint8_t thickness,const float m[8],const baseline_basis *b){
    float x=n[0]*(1.0f/32767),y=n[1]*(1.0f/32767),z=n[2]*(1.0f/32767);
    (void)baseline_unit(&x,&y,&z);
    const float dot=x*b->lx+y*b->ly+z*b->lz;
    const float front=fmaxf(0,dot),back=fmaxf(0,-dot);
    const float nh=b->half?fmaxf(0,x*b->hx+y*b->hy+z*b->hz):0;
    const float spec=front>0&&nh>0?powf(nh,m[3]):0;
    const float thin=1-thickness*(1.0f/255);
    return (ayatsuri_shade_terms){front,back,spec,thin};
}

static void check_case(const char *group,const int16_t n[3],uint16_t a,uint16_t b,uint8_t thickness,const float light[9],const float m[8]){
    const uint64_t index=cases++;
    baseline_basis bb;
    ayatsuri_shade_basis cb;
    const bool bp=baseline_prepare(light,&bb),cp=ayatsuri_shade_prepare(light,&cb);
    if(!bp||!cp){fail(group,"valid-direction prepare",index,bp,cp);return;}
    const float ba[6]={bb.lx,bb.ly,bb.lz,bb.hx,bb.hy,bb.hz};
    const float ca[6]={cb.lx,cb.ly,cb.lz,cb.hx,cb.hy,cb.hz};
    for(unsigned k=0;k<6;k++){basis_checks++;if(float_bits(ba[k])!=float_bits(ca[k]))fail(group,"basis bits",index,float_bits(ba[k]),float_bits(ca[k]));}
    basis_checks++;
    if(bb.half!=cb.half)fail(group,"half flag",index,bb.half,cb.half);
    if(!bb.half)no_half++;
    const ayatsuri_shade_terms oracle=original_terms(n,thickness,m,&bb);
    const struct math_counts before_b=baseline_counts,before_c=candidate_counts;
    active_counts=&baseline_counts;
    const uint16_t expected_a=baseline_sample(n,a,thickness,light,m,&bb);
    const uint16_t expected_b=baseline_sample(n,b,thickness,light,m,&bb);
    active_counts=&candidate_counts;
    const ayatsuri_shade_terms terms=ayatsuri_shade_terms_prepare(n,thickness,m,&cb);
    const uint16_t actual_a=ayatsuri_shade_from_terms(a,light,m,&terms);
    const uint16_t actual_b=ayatsuri_shade_from_terms(b,light,m,&terms);
    active_counts=NULL;
#if COUNT_MATH
    if(baseline_counts.sqrt_calls-before_b.sqrt_calls!=2||candidate_counts.sqrt_calls-before_c.sqrt_calls!=1)
        fail(group,"normal sqrt call count",index,(uint32_t)(baseline_counts.sqrt_calls-before_b.sqrt_calls),(uint32_t)(candidate_counts.sqrt_calls-before_c.sqrt_calls));
    if(baseline_counts.pow_calls-before_b.pow_calls!=2*(candidate_counts.pow_calls-before_c.pow_calls))
        fail(group,"specular pow call count",index,(uint32_t)(baseline_counts.pow_calls-before_b.pow_calls),(uint32_t)(candidate_counts.pow_calls-before_c.pow_calls));
    if(baseline_counts.round_calls-before_b.round_calls!=6||candidate_counts.round_calls-before_c.round_calls!=6)
        fail(group,"channel round call count",index,(uint32_t)(baseline_counts.round_calls-before_b.round_calls),(uint32_t)(candidate_counts.round_calls-before_c.round_calls));
#else
    (void)before_b;(void)before_c;
#endif
    const float ot[4]={oracle.front,oracle.back,oracle.spec,oracle.thin};
    const float ct[4]={terms.front,terms.back,terms.spec,terms.thin};
    for(unsigned k=0;k<4;k++){term_checks++;if(float_bits(ot[k])!=float_bits(ct[k]))fail(group,"term bits",index,float_bits(ot[k]),float_bits(ct[k]));mix32(float_bits(ct[k]));}
    front_zero+=terms.front==0;back_zero+=terms.back==0;spec_zero+=terms.spec==0;nonzero_spec+=terms.spec>0;
    color_checks+=2;
    if(expected_a!=actual_a)fail(group,"color A",index,expected_a,actual_a);
    if(expected_b!=actual_b)fail(group,"color B",index,expected_b,actual_b);
    const uint16_t wrapped_a=ayatsuri_shade_sample(n,a,thickness,light,m,&cb);
    const uint16_t wrapped_b=ayatsuri_shade_sample(n,b,thickness,light,m,&cb);
    wrapper_checks+=2;
    if(expected_a!=wrapped_a)fail(group,"wrapper A",index,expected_a,wrapped_a);
    if(expected_b!=wrapped_b)fail(group,"wrapper B",index,expected_b,wrapped_b);
    mix32(actual_a);mix32(actual_b);
}

static const int16_t normals[][3]={
    {32767,0,0},{-32767,0,0},{0,32767,0},{0,-32767,0},{0,0,32767},{0,0,-32767},
    {1,0,0},{-1,0,0},{0,1,0},{0,0,-1},{1,1,1},{-1,-1,-1},
    {1,32767,0},{-1,32767,0},{32767,1,0},{32767,-1,0},{0,1,32767},{0,-1,32767},
    {32767,32767,32767},{-32767,-32767,-32767},{23170,23170,0},{-23170,23170,0},
    {16384,28377,1},{-16383,-28377,-1},{32766,1,-1},{1,-1,32766},
};
static const float directions[][6]={
    {1,0,0,1,0,0},{-1,0,0,1,0,0},{0,1,0,0,1,0},{0,0,1,0,0,1},{0,0,-1,0,0,1},
    {1,-0.0f,0,-1,0,-0.0f},{0,-0.0f,1,-0.0f,0,-1},
    {1,1,0,-1,-1,0},{1,1,1,-1,-1,-1},
    {FLT_MAX,FLT_MAX,FLT_MAX,FLT_MAX,-FLT_MAX,FLT_MAX},
    {FLT_MAX,FLT_MIN,FLT_TRUE_MIN,FLT_TRUE_MIN,FLT_MAX,FLT_MIN},
    {FLT_TRUE_MIN,0,0,FLT_TRUE_MIN,0,0},
    {FLT_TRUE_MIN,2*FLT_TRUE_MIN,3*FLT_TRUE_MIN,-FLT_TRUE_MIN,-2*FLT_TRUE_MIN,-3*FLT_TRUE_MIN},
    {FLT_MIN,FLT_TRUE_MIN,-FLT_MIN,FLT_MIN,-FLT_MIN,FLT_TRUE_MIN},
    {0x1p-140f,-0x1p-139f,0x1p-138f,0x1p-138f,0x1p-140f,-0x1p-139f},
    {1,0x1p-23f,0,-1,0x1p-23f,0},
    {1,0x1p-24f,0,-1,-0x1p-25f,0},
    {1,0x1p-126f,0,-1,0x1p-126f,0},
    {1,FLT_TRUE_MIN,0,1,-FLT_TRUE_MIN,0},
    {0x1p+100f,0x1p-100f,-0x1p+80f,0x1p-100f,-0x1p+100f,0x1p+80f},
    {0,1,-0.0f,1,0,0},{0,0,1,1,0,0},
    {0x1.fffffep-1f,1,0,-1,0x1.fffffep-1f,0},
};
static const float materials[][8]={
    {0,0,0,1,0,0,0,0},{1,1,1,128,1,1,1,1},
    {0.1f,0.7f,0.2f,1,0.3f,1,0.5f,0},
    {0.1f,0.7f,0.2f,128,0.3f,1,0.5f,0},
    {0.1f,0.7f,0.2f,1.5f,0.3f,1,0.5f,0},
    {0,0,1,2.5f,0,0,0,0},{0,1,0,3.25f,0,0,0,0},
    {0,0,0,63.5f,1,1,1,1},{0.5f,0.5f,0.5f,127.5f,0.5f,0.5f,0.5f,0.5f},
    {FLT_TRUE_MIN,FLT_MIN,0x1p-23f,1,FLT_TRUE_MIN,FLT_MIN,0,1},
    {-0.0f,-0.0f,-0.0f,128,-0.0f,-0.0f,-0.0f,-0.0f},
    {0,0,1,0x1.000002p+0f,0,0,0,0},
};
static const uint16_t colors[]={0,1,30,31,32,63,0x07df,0x07e0,0x07ff,0x0800,0x7bef,0x8000,0xf7ff,0xf800,0xffdf,0xffe0,0xfffe,0xffff};
static const uint8_t thicknesses[]={0,1,127,128,254,255};
#define LENGTH(a) (sizeof(a)/sizeof((a)[0]))

static uint64_t directed(void){
    const uint64_t start=cases;
    for(size_t n=0;n<LENGTH(normals);n++)for(size_t d=0;d<LENGTH(directions);d++)for(size_t m=0;m<LENGTH(materials);m++)for(size_t t=0;t<LENGTH(thicknesses);t++){
        float light[9];memcpy(light,directions[d],6*sizeof(float));
        const size_t pick=(n+d+m+t)%7;
        light[6]=pick==0?0:pick==1?FLT_TRUE_MIN:pick==2?FLT_MIN:pick==3?-0.0f:1;
        light[7]=pick==4?0.5f:1;light[8]=pick==5?0x1.fffffep-1f:pick==6?0:1;
        check_case("directed",normals[n],colors[(n+3*d+m)%LENGTH(colors)],colors[(n+d+5*m+t)%LENGTH(colors)],thicknesses[t],light,materials[m]);
    }
    return cases-start;
}

static uint64_t all_rgb565(void){
    const uint64_t start=cases;
    /* 8 scenarios enumerate every 16-bit color in A and every complement in B. */
    for(unsigned scenario=0;scenario<8;scenario++){
        float light[9];memcpy(light,directions[scenario*3],6*sizeof(float));
        light[6]=scenario==3?0.5f:1;light[7]=scenario==5?0.25f:1;light[8]=scenario==7?0:1;
        for(uint32_t color=0;color<65536;color++)check_case("all_rgb565",normals[(scenario*3)%LENGTH(normals)],(uint16_t)color,(uint16_t)(65535-color),scenario&1?255:0,light,materials[scenario+2]);
    }
    return cases-start;
}

static uint64_t rounding_boundaries(void){
    const uint64_t start=cases;
    const float light[9]={0,0,1,0,0,1,1,1,1};
    for(unsigned max=31;max<=63;max+=32)for(unsigned code=0;code<max;code++){
        const float midpoint=((float)code+0.5f)/(float)max;
        const float ambient[3]={nextafterf(midpoint,0),midpoint,nextafterf(midpoint,1)};
        for(unsigned i=0;i<3;i++){
            const float m[8]={ambient[i],0,0,1,0,0,0,0};
            check_case("rgb565_rounding",normals[4],UINT16_MAX,(uint16_t)((code<<11)|(code<<5)|code),i?255:0,light,m);
        }
    }
    return cases-start;
}

static int16_t quantize(double value){return (int16_t)fmax(-32767,fmin(32767,floor(value*32767+0.5)));}
static uint64_t quantized_ties(void){
    const uint64_t start=cases;
    const int k_values[]={0,1,2,31,255,8191,16383,23169,32765};
    for(size_t k=0;k<LENGTH(k_values);k++)for(unsigned axis=0;axis<3;axis++){
        double v[3]={0,0,0};v[axis]=(k_values[k]+0.5)/32767.0;v[(axis+1)%3]=sqrt(1-v[axis]*v[axis]);
        int16_t front[3],back[3];bool unequal=false;
        for(unsigned j=0;j<3;j++){front[j]=quantize(v[j]);back[j]=quantize(-v[j]);unequal|=back[j]!=-front[j];}
        quantized_tie_pairs++;nonnegated_back_pairs+=unequal;
        for(size_t d=0;d<LENGTH(directions);d++)for(size_t t=0;t<LENGTH(thicknesses);t++){
            float light[9];memcpy(light,directions[d],6*sizeof(float));light[6]=1;light[7]=0.5f;light[8]=0.25f;
            check_case("quantized_front_tie",front,0x7bef,0xf81f,thicknesses[t],light,materials[(k+d+t)%LENGTH(materials)]);
            check_case("quantized_back_tie",back,0x7bef,0xf81f,thicknesses[t],light,materials[(k+d+t)%LENGTH(materials)]);
        }
    }
    return cases-start;
}

static void random_direction(float v[3],unsigned style){
    do {
        for(unsigned j=0;j<3;j++){
            const float sign=random_u32()&1?1:-1;
            if(style==0)v[j]=sign*random_unit();
            else if(style==1)v[j]=sign*(float)(1+(random_u32()%64))*FLT_TRUE_MIN;
            else if(style==2)v[j]=sign*scalbnf(0.5f+0.5f*random_unit(),100+(int)(random_u32()%28));
            else if(style==3)v[j]=sign*scalbnf(0.5f+0.5f*random_unit(),-149+(int)(random_u32()%277));
            else v[j]=sign*0.0f;
        }
        if(style==4)v[random_u32()%3]=random_u32()&1?1:-1;
    }while(v[0]==0&&v[1]==0&&v[2]==0);
}
static uint64_t randomized(void){
    const uint64_t start=cases;
    for(unsigned i=0;i<200000;i++){
        int16_t n[3];do{for(unsigned j=0;j<3;j++)n[j]=(int16_t)((int)(random_u32()%65535)-32767);}while(!n[0]&&!n[1]&&!n[2]);
        float light[9],m[8];random_direction(light,i%5);random_direction(light+3,(i/5)%5);
        if(i%17==0)for(unsigned j=0;j<3;j++)light[3+j]=-light[j];
        for(unsigned j=6;j<9;j++)light[j]=random_unit();
        for(unsigned j=0;j<8;j++)m[j]=random_unit();
        m[3]=i%7==0?1:i%7==1?128:1+127*random_unit();
        const uint16_t a=(uint16_t)random_u32(),b=(uint16_t)random_u32();
        check_case("randomized",n,a,b,(uint8_t)random_u32(),light,m);
    }
    return cases-start;
}
static void rejected_directions(void){
    const float bad[][3]={{0,0,0},{-0.0f,0,-0.0f},{INFINITY,1,0},{-INFINITY,0,1},{NAN,0,0},{0,NAN,0},{0,0,NAN}};
    for(size_t i=0;i<LENGTH(bad);i++)for(unsigned side=0;side<2;side++){
        float light[9]={1,0,0,1,0,0,1,1,1};memcpy(light+3*side,bad[i],3*sizeof(float));
        baseline_basis b;ayatsuri_shade_basis c;const bool bp=baseline_prepare(light,&b),cp=ayatsuri_shade_prepare(light,&c);
        if(bp||cp)fail("invalid_direction","expected rejection",i,bp,cp);else invalid_rejected++;
    }
}
int main(void){
    if(fegetround()!=FE_TONEAREST){fprintf(stderr,"FE_TONEAREST required\n");return 2;}
    const uint64_t d=directed(),rgb=all_rgb565(),r=rounding_boundaries(),q=quantized_ties(),random=randomized();
    rejected_directions();
    if(!cases||!nonzero_spec||!no_half||!nonnegated_back_pairs)fail("coverage","missing required case",cases,0,1);
    printf("{\"passed\":%s,\"instrumented\":%s,\"seed\":\"0x9e3779b9\",\"cases\":%" PRIu64 ",\"basis_checks\":%" PRIu64 ",\"term_bit_checks\":%" PRIu64 ",\"paired_color_checks\":%" PRIu64 ",\"wrapper_color_checks\":%" PRIu64 ",\"failures\":%" PRIu64 ",\"digest\":\"%016" PRIx64 "\",",failures?"false":"true",COUNT_MATH?"true":"false",cases,basis_checks,term_checks,color_checks,wrapper_checks,failures,checksum);
    printf("\"groups\":{\"directed\":%" PRIu64 ",\"all_rgb565\":%" PRIu64 ",\"rgb565_rounding\":%" PRIu64 ",\"quantized_ties\":%" PRIu64 ",\"randomized\":%" PRIu64 "},",d,rgb,r,q,random);
    printf("\"coverage\":{\"no_half_vector\":%" PRIu64 ",\"front_zero\":%" PRIu64 ",\"back_zero\":%" PRIu64 ",\"spec_zero\":%" PRIu64 ",\"nonzero_spec\":%" PRIu64 ",\"quantized_tie_pairs\":%" PRIu64 ",\"back_not_negated_front_pairs\":%" PRIu64 ",\"invalid_directions_rejected\":%" PRIu64 "},",no_half,front_zero,back_zero,spec_zero,nonzero_spec,quantized_tie_pairs,nonnegated_back_pairs,invalid_rejected);
    printf("\"baseline_math_calls\":{\"sqrtf\":%" PRIu64 ",\"powf\":%" PRIu64 ",\"lroundf\":%" PRIu64 "},\"candidate_math_calls\":{\"sqrtf\":%" PRIu64 ",\"powf\":%" PRIu64 ",\"lroundf\":%" PRIu64 "}}\n",baseline_counts.sqrt_calls,baseline_counts.pow_calls,baseline_counts.round_calls,candidate_counts.sqrt_calls,candidate_counts.pow_calls,candidate_counts.round_calls);
    return failures?1:0;
}
