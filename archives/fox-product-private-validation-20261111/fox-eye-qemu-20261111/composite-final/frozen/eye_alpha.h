#ifndef FOX_EYE_ALPHA_H
#define FOX_EYE_ALPHA_H
#include <math.h>
/* Generated from immutable 2k-v2 Blender graphs. IDs below are local to this
 * header, not global renderer material IDs. Map by full source material name.
 * Coordinates: evaluated shaded object's local metres; NEVER world/rest local.
 * Input blink domain [0,1]. Nonfinite coordinates => alpha 0; nonfinite control
 * => default 0. Clamping is defensive runtime policy, not extra source nodes.
 */
typedef struct { const char *name; int side; float cx,rx,slope,cz,rz,gain; } FoxEyeMask;
static const FoxEyeMask fox_eye_masks[6] = {
  {"Blink mask Expressive eye contour -1",-1,-0.28499999642372131f,0.25499999523162842f,-0.039999999105930328f,2.5499999523162842f,0.31000000238418579f,50.0f},
  {"Blink mask Expressive eye contour 1",1,0.28499999642372131f,0.25499999523162842f,0.039999999105930328f,2.5499999523162842f,0.31000000238418579f,50.0f},
  {"Blink mask Expressive eye white -1",-1,-0.28499999642372131f,0.25499999523162842f,-0.039999999105930328f,2.5499999523162842f,0.31000000238418579f,50.0f},
  {"Blink mask Expressive eye white 1",1,0.28499999642372131f,0.25499999523162842f,0.039999999105930328f,2.5499999523162842f,0.31000000238418579f,50.0f},
  {"Blink mask Outer eye corner -1",-1,-0.28499999642372131f,0.25499999523162842f,-0.039999999105930328f,2.5499999523162842f,0.31000000238418579f,50.0f},
  {"Blink mask Outer eye corner 1",1,0.28499999642372131f,0.25499999523162842f,0.039999999105930328f,2.5499999523162842f,0.31000000238418579f,50.0f},
};
static inline float fox_eye_clamp_control(float b) {
 return isfinite(b) ? fminf(1.0f,fmaxf(0.0f,b)) : 0.0f;
}
static inline float fox_eye_alpha(int material_index, float x, float z,
                                  float blink_both, float blink_side) {
 if (material_index<0 || material_index>=6 || !isfinite(x) || !isfinite(z)) return 0.0f;
 const FoxEyeMask *m=&fox_eye_masks[material_index];
 float b=fmaxf(fox_eye_clamp_control(blink_both),fox_eye_clamp_control(blink_side));
 float u=(x-m->cx)/m->rx;
 float root=sqrtf(fmaxf(1.0f-u*u,0.0f));
 float center=m->cz+u*m->slope;
 float half=(m->rz*(1.0f-b))*root;
 float inside=(z<center+half && z>center-half)?1.0f:0.0f;
 float neutral=1.0f-fminf(1.0f,b*m->gain);
 return fminf(1.0f,fmaxf(0.0f,fmaxf(inside,neutral)));
}
/* hide_render driver applies independently of shader alpha. */
static inline int fox_eye_outer_corner_visible(float both,float side) {
 return fmaxf(fox_eye_clamp_control(both),fox_eye_clamp_control(side))<0.98f;
}
#endif
