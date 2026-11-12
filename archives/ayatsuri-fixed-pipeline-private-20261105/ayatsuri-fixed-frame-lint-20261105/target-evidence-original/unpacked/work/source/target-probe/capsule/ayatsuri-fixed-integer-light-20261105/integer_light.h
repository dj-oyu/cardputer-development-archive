#ifndef INTEGER_LIGHT_H
#define INTEGER_LIGHT_H
#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>
enum { IL_LIGHTS=3, IL_SAMPLES=16, IL_POSITION_MAX=524288 };
typedef struct {int32_t center[3],sample[16][3];int16_t normal[3];uint32_t power[3];} il_light;
typedef struct {il_light light[3];uint32_t world[3];} il_scene;
typedef struct {int32_t p[3];int16_t normal[3];uint16_t rho[3],visible[3];} il_pixel;
typedef enum {IL_OK,IL_INVALID,IL_FALLBACK_PLANE,IL_FALLBACK_SAMPLE,IL_RANGE} il_status;
/* Portable restoring sqrt: floor(sqrt(x)), bounded 32 iterations, no floats. */
static uint64_t il_sqrt(uint64_t x){uint64_t r=0,b=UINT64_C(1)<<62;while(b>x)b>>=2;while(b){if(x>=r+b){x-=r+b;r=(r>>1)+b;}else r>>=1;b>>=2;}return r;}
static uint64_t il_round(uint64_t n,uint64_t d){uint64_t q=n/d,r=n%d;return q+(r>d-r||(r==d-r&&(q&1)));}
static int64_t il_signed_round(int64_t n,uint64_t d){return n<0?-(int64_t)il_round((uint64_t)(-n),d):(int64_t)il_round((uint64_t)n,d);}
static bool il_position(const int32_t p[3]){for(unsigned k=0;k<3;k++)if(p[k]<-IL_POSITION_MAX||p[k]>IL_POSITION_MAX)return false;return true;}
static uint64_t il_normal_length(const int16_t n[3]){uint64_t s=0;for(unsigned k=0;k<3;k++){if(n[k]==INT16_MIN)return 0;s+=(int64_t)n[k]*n[k];}if(s<UINT64_C(32762)*32762||s>UINT64_C(32772)*32772)return 0;return il_sqrt(s<<16);}
static bool il_scene_valid(const il_scene *s){if(!s)return false;for(unsigned k=0;k<3;k++)if(s->world[k]>(16u<<24))return false;for(unsigned l=0;l<3;l++){const il_light *a=&s->light[l];if(!il_position(a->center)||!il_normal_length(a->normal))return false;for(unsigned k=0;k<3;k++)if(a->power[k]>(256u<<16))return false;for(unsigned j=0;j<16;j++)if(!il_position(a->sample[j]))return false;}return true;}
/* Validated scene is immutable during calls. No floating arithmetic in this API.
 * Caller prepares exact disk16 samples offline and supplies explicit visibility masks.
 * Output unchanged on rejection. Positions Q16 metres; normal /32767;
 * rho /32767; power Q16; world/result Q24 radiance. */
static il_status il_eval(const il_scene *s,const il_pixel *p,uint64_t out[3]){
 if(!s||!p||!out||!il_position(p->p))return IL_INVALID;
 uint64_t nr=il_normal_length(p->normal);if(!nr)return IL_INVALID;
 for(unsigned k=0;k<3;k++)if(p->rho[k]>32767)return IL_INVALID;
 uint64_t rgb[3]={s->world[0],s->world[1],s->world[2]};
 for(unsigned l=0;l<3;l++){
  const il_light *a=&s->light[l];uint64_t nl=il_normal_length(a->normal);if(!nl)return IL_INVALID;
  int64_t plane=0;for(unsigned k=0;k<3;k++)plane+=((int64_t)a->center[k]-p->p[k])*a->normal[k];
  uint64_t ap=plane<0?(uint64_t)-plane:(uint64_t)plane;
  /* 0.127 metres, rounded upward in Q16 * SNORM scale. */
  if(ap<UINT64_C(272722101))return IL_FALLBACK_PLANE;
  uint64_t sum=0;
  for(unsigned j=0;j<16;j++){
   int64_t d[3];uint64_t rr=0;for(unsigned k=0;k<3;k++){d[k]=(int64_t)a->sample[j][k]-p->p[k];if(d[k]<-1048576||d[k]>1048576)return IL_RANGE;rr+=(uint64_t)(d[k]*d[k]);}
   if(rr<(UINT64_C(1)<<26))return IL_FALLBACK_SAMPLE;
   uint64_t length=il_sqrt(rr<<16);int16_t wi[3];for(unsigned k=0;k<3;k++)wi[k]=(int16_t)il_signed_round(d[k]*INT64_C(4194304),length);
   int64_t dr=0,ds=0;for(unsigned k=0;k<3;k++){dr+=(int64_t)p->normal[k]*wi[k];ds-=(int64_t)a->normal[k]*wi[k];}
   if(dr<=0||ds<=0||!(p->visible[l]&(1u<<j)))continue;
   uint64_t cr=il_round((uint64_t)dr*256,nr),cs=il_round((uint64_t)ds*256,nl);
   if(cr>16387||cs>16387)return IL_RANGE;
   uint64_t inverse=il_round(UINT64_C(1)<<56,rr);
   uint64_t kernel=il_round(cr*cs*inverse,UINT64_C(1)<<28);sum+=kernel;
  }
  uint64_t mean=il_round(sum,16);
  for(unsigned k=0;k<3;k++)rgb[k]+=il_round((uint64_t)a->power[k]*mean,UINT64_C(1)<<16);
 }
 for(unsigned k=0;k<3;k++)out[k]=il_round(rgb[k]*p->rho[k],32767);
 return IL_OK;
}
static bool il_hdr19(const uint64_t in[3],uint32_t out[3]){uint64_t q[3];for(unsigned k=0;k<3;k++){q[k]=il_round(in[k],32);if(q[k]>UINT32_MAX)return false;}for(unsigned k=0;k<3;k++)out[k]=(uint32_t)q[k];return true;}
static bool il_block(const il_scene *s,const il_pixel *p,unsigned count,uint64_t out[8][3],il_status status[8]){if(count!=1&&count!=2&&count!=4&&count!=8)return false;for(unsigned i=0;i<count;i++)status[i]=il_eval(s,p+i,out[i]);return true;}
#endif
