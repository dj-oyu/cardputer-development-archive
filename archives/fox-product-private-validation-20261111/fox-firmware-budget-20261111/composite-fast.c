extern unsigned long budget_fragments,budget_passes;
#include "composite.h"
#include <math.h>
#include <limits.h>
#include <string.h>
/* Validate spans before any dereference or workspace initialization. Avoid
   pointer-end addition, including wraparound at UINTPTR_MAX. */
typedef struct {uintptr_t start;size_t bytes;} memory_span;
static bool disjoint_spans(const memory_span *spans,unsigned count){
 for(unsigned i=0;i<count;i++){
  const memory_span a=spans[i];
  if(!a.start||!a.bytes||a.bytes-1>UINTPTR_MAX-a.start)return false;
  for(unsigned j=0;j<i;j++){
   const memory_span b=spans[j];
   if(a.start<=b.start?b.start-a.start<a.bytes:a.start-b.start<b.bytes)return false;
  }
 }
 return true;
}
typedef struct {fox_composite_workspace*w;fox_surface_fn surface;void*user;unsigned y,n;} peel_context;
static bool behind(float depth,unsigned id,float prev,unsigned prev_id){return depth<prev||(depth==prev&&id>prev_id);}
static bool nearer(float depth,unsigned id,float other,unsigned other_id){return depth>other||(depth==other&&id<other_id);}
static double collect(void*opaque,const fox_fragment*f){
 budget_fragments++;peel_context*c=opaque;fox_composite_workspace*w=c->w;
 unsigned at=((unsigned)f->y-c->y)*240+(unsigned)f->x;
 if(at>=c->n)return NAN;
 if(w->transmittance[at]==0||!behind(f->depth,f->triangle,w->previous_depth[at],w->previous_id[at])||!nearer(f->depth,f->triangle,w->next_depth[at],w->next_id[at]))return 0;
 float rgb[3],alpha;if(!c->surface(c->user,f,rgb,&alpha)||!isfinite(alpha)||alpha<0||alpha>1)return NAN;
 for(unsigned k=0;k<3;k++)if(!isfinite(rgb[k])||rgb[k]<0)return NAN;
 if(alpha==0)return 0;
 w->next_depth[at]=f->depth;w->next_id[at]=f->triangle;
 memcpy(w->next_rgb[at],rgb,sizeof rgb);w->next_alpha[at]=alpha;
 return 0; /* collect never writes raster depth/color */
}
/* Pure immutable callbacks only: a fractional candidate may cause replay in the
 * unchanged general compositor. Output remains untouched until either path wins. */
typedef struct { peel_context peel; bool fractional; } cutout_context;
static double collect_cutout(void *opaque,const fox_fragment *f){
 cutout_context *c=opaque;
 double result=collect(&c->peel,f);
 if(!isfinite(result))return result;
 unsigned at=((unsigned)f->y-c->peel.y)*240+(unsigned)f->x;
 if(c->peel.w->next_id[at]==f->triangle && c->peel.w->next_alpha[at]>0 && c->peel.w->next_alpha[at]<1){c->fractional=true;return NAN;}
 return result;
}
static float linear(float v){return v<=.04045f?v/12.92f:powf((v+.055f)/1.055f,2.4f);}
static float srgb(float v){v=fmaxf(0,fminf(1,v));return v<=.0031308f?12.92f*v:1.055f*powf(v,1.f/2.4f)-.055f;}
bool fox_scene_composite(const scene_frame*f,uint16_t*out,unsigned y,unsigned rows,unsigned limit,scene_workspace*scene,const float(*local)[3],fox_surface_fn surface,void*user,unsigned max_layers,fox_composite_workspace*w){
 if(!f||!out||!scene||!surface||!w||!rows||rows>4||y%4||y>=135||rows>135-y||!max_layers||max_layers>64)return false;
 unsigned n=rows*240;
 const memory_span spans[]={{(uintptr_t)f,sizeof *f},{(uintptr_t)scene,sizeof *scene},
  {(uintptr_t)out,n*sizeof *out},{(uintptr_t)w,sizeof *w},
  {(uintptr_t)local,SCENE_VERTICES*sizeof *local}};
 if(!disjoint_spans(spans,local?5:4))return false;
 peel_context ctx={w,surface,user,y,n};w->passes=0;w->max_observed_layers=0;
 for(unsigned i=0;i<n;i++){w->previous_depth[i]=INFINITY;w->previous_id[i]=0;w->transmittance[i]=1;memset(w->accumulated[i],0,sizeof w->accumulated[i]);w->scratch[i]=0;}

 /* Optional generic binary-alpha fast path. Same source-order/tie selection as
  * peel pass zero; zero-alpha never claims depth. No coverage is approximated. */
 for(unsigned i=0;i<n;i++){w->next_depth[i]=-INFINITY;w->next_id[i]=UINT_MAX;}
 cutout_context cut={ctx,false};
 bool fast_ok=fox_scene_band_local(f,w->scratch,y,rows,limit,scene,-1,collect_cutout,&cut,local);
 budget_passes++;
 if(fast_ok){
  w->passes=1;
  for(unsigned i=0;i<n;i++)if(w->next_id[i]!=UINT_MAX){
   memcpy(w->accumulated[i],w->next_rgb[i],sizeof w->accumulated[i]);
   w->transmittance[i]=0;w->max_observed_layers=1;
  }
  goto convert;
 }
 if(!cut.fractional)return false;
 /* Fractional opacity is not a failure and must not become a threshold. */
 for(unsigned i=0;i<n;i++){w->previous_depth[i]=INFINITY;w->previous_id[i]=0;w->transmittance[i]=1;memset(w->accumulated[i],0,sizeof w->accumulated[i]);w->scratch[i]=0;}
 for(unsigned pass=0;pass<=max_layers;pass++){
  for(unsigned i=0;i<n;i++){w->next_depth[i]=-INFINITY;w->next_id[i]=UINT_MAX;}
  if(!fox_scene_band_local(f,w->scratch,y,rows,limit,scene,-1,collect,&ctx,local))return false;
  budget_passes++;w->passes++;bool found=false;
  for(unsigned i=0;i<n;i++)if(w->next_id[i]!=UINT_MAX){found=true;if(pass==max_layers)return false;
   float a=w->next_alpha[i],weight=w->transmittance[i]*a;
   for(unsigned k=0;k<3;k++){w->accumulated[i][k]+=weight*w->next_rgb[i][k];if(!isfinite(w->accumulated[i][k]))return false;}
   w->transmittance[i]*=1-a;w->previous_depth[i]=w->next_depth[i];w->previous_id[i]=w->next_id[i];
  }
  if(!found)break;
  w->max_observed_layers=pass+1;
 }
convert:
 /* All possible failures have occurred before publication. */
 for(unsigned i=0;i<n;i++){
  uint16_t bg=out[i];float b[3]={linear((bg>>11)/31.f),linear(((bg>>5)&63)/63.f),linear((bg&31)/31.f)};
  unsigned c[3];for(unsigned k=0;k<3;k++)c[k]=(unsigned)lroundf(srgb(w->accumulated[i][k]+w->transmittance[i]*b[k])*(k==1?63:31));
  w->scratch[i]=(uint16_t)((c[0]<<11)|(c[1]<<5)|c[2]);
 }
 memcpy(out,w->scratch,n*sizeof *out);return true;
}
bool fox_scene_composite_preflight(const scene_frame*f,scene_workspace*s,const float(*local)[3],fox_surface_fn cb,void*u,unsigned layers,fox_composite_workspace*w){
 uint16_t output[FOX_STRIP_PIXELS];
 for(unsigned y=0;y<135;y+=4){unsigned rows=135-y<4?135-y:4;memset(output,0,sizeof output);if(!fox_scene_composite(f,output,y,rows,30,s,local,cb,u,layers,w))return false;}
 return true;
}
