#include "eye_runtime.h"
#include "eye_geometry.inc"
#include "../fox-eye-contract-20261111/non_eye_base_colors.h"
#include <string.h>
static bool range(float x,float lo,float hi){return isfinite(x)&&x>=lo&&x<=hi;}
bool fox_eye_controls_valid(const FoxEyeControls *c){
 return c && range(c->blink_both,0,1)&&range(c->blink_neg,0,1)&&range(c->blink_pos,0,1)
 &&range(c->gaze_x,-1,1)&&range(c->gaze_up,-1,1)
 &&range(c->eye_style,0,2)&&c->eye_style==floorf(c->eye_style)
 &&range(c->show_highlights,0,1)&&c->show_highlights==floorf(c->show_highlights)
 &&range(c->environment_reflection,0,1)&&range(c->bubble_pressure,-1,1);
}
bool fox_eye_snapshot_build(fox_eye_snapshot *dst,const FoxEyeControls *controls){
 if(!dst||!fox_eye_controls_valid(controls))return false;
 const FoxEyeControls c=*controls;
 memset(dst,0,sizeof(*dst));dst->controls=c;
 memcpy(dst->local,fox_eye_basis,sizeof(dst->local));
 float b[2]={fmaxf(c.blink_both,c.blink_neg),fmaxf(c.blink_both,c.blink_pos)};
 for(unsigned i=0;i<32;i++)for(unsigned k=0;k<3;k++){
  unsigned v=fox_eye_delta_index[i];dst->local[v][k]=fox_eye_basis[v][k]+b[i/16]*fox_eye_delta[i][k];
 }
 for(unsigned side=0;side<2;side++)for(unsigned i=0;i<3;i++)
  dst->hidden[fox_eye_hidden_index[side][i]]=b[side]>=0.98f;
 return true;
}
bool fox_eye_snapshot_surface(const fox_eye_snapshot *s,unsigned m,float x,float y,float z,float rgb[3],float *alpha){
 if(!s||!rgb||!alpha||m>=12||!isfinite(x)||!isfinite(y)||!isfinite(z))return false;
 int mask=fox_runtime_material_mask[m];
 if(mask<0){for(unsigned k=0;k<3;k++)rgb[k]=fox_runtime_non_eye_rgb[m][k];*alpha=1;}
 else{fox_eye_base_color(mask,x,y,z,&s->controls,rgb);const FoxEyeControls *c=&s->controls;
 *alpha=fox_eye_alpha(mask,x,z,c->blink_both,fox_eye_masks[mask].side<0?c->blink_neg:c->blink_pos);}
 return true;
}
