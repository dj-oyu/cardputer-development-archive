#include "bridge.h"
#include "composite.h"
#include <string.h>
static scene_frame frame;
static scene_workspace workspace;
static fox_composite_workspace composite;
static uint16_t rows[960];
static bool surface(void*user,const fox_fragment*f,float rgb[3],float *alpha){
 const fox_eye_snapshot*s=user;
 if(s->hidden[f->object]){*alpha=0;rgb[0]=rgb[1]=rgb[2]=0;return true;}
 return fox_eye_snapshot_surface(s,f->material,f->local[0],f->local[1],f->local[2],rgb,alpha);
}
bool fox_bridge_render(const fox_eye_snapshot*s,uint32_t*out){
 scene_times t;
 if(!fox_scene_prepare_local(NULL,&frame,&workspace,-1,3,-1,&t,s->local)||
    !fox_scene_composite_preflight(&frame,&workspace,s->local,surface,(void*)s,16,&composite))return false;
 uint32_t hash=2166136261u;
 for(unsigned y=0;y<135;y+=4){unsigned h=135-y<4?135-y:4;memset(rows,0,sizeof rows);
  if(!fox_scene_composite(&frame,rows,y,h,30,&workspace,s->local,surface,(void*)s,16,&composite))return false;
  for(unsigned i=0;i<h*240;i++)hash=(hash^rows[i])*16777619u;
 }
 *out=hash;return true;
}
