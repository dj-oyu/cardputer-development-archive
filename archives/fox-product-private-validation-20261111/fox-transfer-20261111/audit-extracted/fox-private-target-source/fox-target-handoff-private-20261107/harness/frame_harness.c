#include "frame_harness.h"
#include <string.h>
static bool port_valid(const fh_port*p){return p&&p->now_us&&p->submit&&p->drain;}
static bool drain(fh_owner*o,const fh_port*p,fh_times*t){uint64_t n=p->now_us(p->ctx);bool ok=p->drain(p->ctx);t->drain_us+=p->now_us(p->ctx)-n;if(ok)o->pending=0;else o->quarantine=true;return ok;}
fh_result fh_frame(fh_owner*o,const fh_port*p,int pose,unsigned camera,int fail,fh_times*t){
 if(!o||!t||!port_valid(p)||pose<0||pose>7||camera>2)return FH_INVALID;
 if(o->quarantine||o->pinned||o->pending)return FH_BUSY;
 memset(t,0,sizeof *t);uint64_t start=p->now_us(p->ctx),n=start;unsigned candidate=o->has_ready?o->ready^1u:0u;scene_times unused;
 bool prepared=scene_prepare(o->has_ready?&o->frames[o->ready]:NULL,&o->frames[candidate],&o->workspace,pose,camera,fail,&unused);t->prepare_us=p->now_us(p->ctx)-n;
 if(!prepared){t->total_us=p->now_us(p->ctx)-start;return FH_PREPARE;}
 o->pinned=true;fh_result result=FH_OK;
 for(unsigned y=0,piece=0;y<135;y+=4,piece++){
  if(o->pending==2&&!drain(o,p,t)){result=FH_QUARANTINE;break;}
  unsigned rows=135-y<4?135-y:4;uint16_t*half=o->halves[piece&1u];memset(half,0,rows*480);n=p->now_us(p->ctx);
  bool rastered=scene_band(&o->frames[candidate],half,y,rows,30,&o->workspace,-1);t->raster_us+=p->now_us(p->ctx)-n;
  if(!rastered){result=FH_RASTER;break;}
  n=p->now_us(p->ctx);/* Conservatively count a borrow even on submit failure. */
  o->pending++;o->display_known=false;bool sent=p->submit(p->ctx,y,rows,half);t->submit_us+=p->now_us(p->ctx)-n;
  if(!sent){result=FH_SEND;break;}
 }
 /* Do not retry an uncertain drain implicitly. Preserve all pins. */
 if(!o->quarantine&&!drain(o,p,t))result=FH_QUARANTINE;
 if(!o->quarantine){o->pinned=false;if(result==FH_OK){o->ready=candidate;o->has_ready=true;o->display_known=true;}}
 t->total_us=p->now_us(p->ctx)-start;return result;
}
bool fh_recover(fh_owner*o,const fh_port*p){if(!o||!port_valid(p)||!o->quarantine)return false;if(!p->drain(p->ctx))return false;o->pending=0;o->pinned=false;o->quarantine=false;/* No display rollback or ACK implied. */return true;}
