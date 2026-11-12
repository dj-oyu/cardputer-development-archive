#include "../../fox-v3-indexed-bvh-bounds/private-build/background/background.c"
/* Pure geometry-only classification for supplied actual composition slots.
 * config: camera9, sourceOrigin3, sourceView3, clip2, floor12.
 * slots: x,y,sample (0..3 or UINT32_MAX), character-hit; depth separate F32.
 * result: one action 0 keep/1 floor/2 world, and one floor depth per slot. */
int background_metadata(const double cfg[29],const uint32_t ix[6],const uint32_t*slots,const float*depth,size_t count,uint8_t*actions,float*floor_depth){
 if(!cfg||!ix||!slots||!depth||!actions||!floor_depth||!count||count>39573)return -1;
 fox_bg_scene s={0};for(int k=0;k<9;k++)s.in.camera[k]=(float)cfg[k];memcpy(s.in.source_origin,cfg+9,24);memcpy(s.in.source_view,cfg+12,24);memcpy(s.in.clip,cfg+15,16);memcpy(s.in.floor,cfg+17,96);memcpy(s.in.indices,ix,24);
 fox_bg_status st=camera_prepare(&s);if(st)return 10+st;
 const double dx[4]={-.25,.25,-.25,.25},dy[4]={-.25,-.25,.25,.25};
 for(size_t i=0;i<count;i++){
  const uint32_t*q=slots+4*i;if(q[0]>=240||q[1]>=135||(q[2]>3&&q[2]!=UINT32_MAX)||q[3]>1||(q[3]&&!isfinite(depth[i])))return -2;
  double x=q[0],y=q[1];if(q[2]!=UINT32_MAX){x+=dx[q[2]];y+=dy[q[2]];}fox_bg_result r={0};st=floor_intersection(&s,x,y,&r);if(st)return 20+st;
  int hit=r.miss_reason==FOX_BG_FLOOR_HIT;int keep=q[3]&&(!hit||r.floor_depth<=depth[i]);actions[i]=keep?0:hit?1:2;floor_depth[i]=r.floor_depth;
 }
 return 0;
}
