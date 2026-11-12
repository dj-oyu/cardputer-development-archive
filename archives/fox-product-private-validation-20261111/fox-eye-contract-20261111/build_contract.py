import json,pathlib
R=pathlib.Path(__file__).resolve().parent;x=json.loads((R/'evaluated-contract.json').read_text());out=[]
for m in x['materials']:
 ns={n['name']:n for n in m['nodes']};ls={(l[2],l[3]):(l[0],l[1])for l in m['links']};seen=set()
 def walk(n,s):
  seen.add(n)
  for i in ns[n]['inputs']:
   if (n,i['id'])in ls:walk(*ls[n,i['id']])
 fac=ls['Mix Shader','Fac'];walk(*fac)
 assert all(n in seen for n in ['Head-local eye coordinates','Blink driver'])
 assert not any(n.startswith('Value')for n in seen)
 assert ls['Mix Shader','Shader']==('Transparent BSDF','BSDF')
 assert ls['Mix Shader','Shader_001']==('Principled BSDF','BSDF')
 def c(n,i):return ns[n]['inputs'][i]['value']
 out.append({'name':m['name'],'side':-1 if m['name'].endswith('-1')else 1,'center_x':c('Math',1),'radius_x':c('Math.001',1),'slope':c('Math.006',1),'center_z':c('Math.007',0),'radius_z':c('Math.009',0),'neutral_fade_gain':c('Math.016',1),'alpha_dependencies':sorted(seen),'alpha_links':[l for l in m['links']if l[2]in seen or l[2]=='Mix Shader'],'alpha_nodes':[n for n in m['nodes']if n['name']in seen]})
(R/'alpha-ir.json').write_text(json.dumps(out,ensure_ascii=False,indent=2))
head='''#ifndef FOX_EYE_ALPHA_H
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
'''
for m in out:
 vals=','.join(format(m[k],'.17g')+'f' if '.' in format(m[k],'.17g') or 'e' in format(m[k],'.17g') else format(m[k],'.17g')+'.0f' for k in ['center_x','radius_x','slope','center_z','radius_z','neutral_fade_gain'])
 head+='  {'+json.dumps(m['name'])+','+str(m['side'])+','+vals+'},\n'
head+='''};
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
'''
(R/'eye_alpha.h').write_text(head)
print([(m['name'],m['side'])for m in out])
