import bpy,json,pathlib,hashlib
R=pathlib.Path('/workspace/scratch/6d8dcdbcdc54');O=R/'fox-eye-contract-20261111';S=R/'fixed-recovery/extracted/fox-cardputer-latest-private/fox-cardputer-2k-v2.blend'
bpy.ops.wm.open_mainfile(filepath=str(S));bpy.context.scene.frame_set(1);bpy.context.view_layer.update()
side=json.loads((R/'fixed-recovery/extracted/fox-cardputer-latest-private/2k-v2-neutral-sidecar.json').read_text());eye={m['name'] for m in json.loads((O/'evaluated-contract.json').read_text())['materials']};rows=[]
for source in side['material_source_graphs']:
 name=source['name']
 if name in eye:continue
 m=bpy.data.materials[name];row={'name':name,'supported':False}
 if not m.use_nodes:row['reason']='No active node tree'
 else:
  outputs=[n for n in m.node_tree.nodes if n.type=='OUTPUT_MATERIAL' and n.is_active_output];row['nodes']=[{'name':n.name,'type':n.bl_idname}for n in m.node_tree.nodes]
  if len(outputs)!=1 or len(outputs[0].inputs['Surface'].links)!=1:row['reason']='Ambiguous Surface output'
  else:
   n=outputs[0].inputs['Surface'].links[0].from_node
   if n.type!='BSDF_PRINCIPLED':row['reason']='Surface is not direct Principled BSDF'
   elif n.inputs['Base Color'].is_linked:row['reason']='Procedural Base Color; not approximated'
   elif m.node_tree.animation_data:row['reason']='Animated node tree requires additional evaluation'
   else:
    row.update(supported=True,linear_rgba=list(n.inputs['Base Color'].default_value),principled_alpha=n.inputs['Alpha'].default_value,principled_node=n.name,roughness=n.inputs['Roughness'].default_value,metallic=n.inputs['Metallic'].default_value)
    old=next(n for n in source['node_tree']['nodes']if n['type']=='ShaderNodeBsdfPrincipled');oldval=next(i['default']for i in old['inputs']if i['identifier']=='Base Color');row['sidecar_constant_exact_match']=row['linear_rgba']==oldval
 rows.append(row)
out={'source_sha256':hashlib.sha256(S.read_bytes()).hexdigest(),'scope':'Exact constant scene-linear Principled Base Color. Unlit diagnostic, not BSDF/light transport.','materials':rows,'unsupported':[r['name']for r in rows if not r['supported']]}
(O/'non_eye_base_colors.json').write_text(json.dumps(out,ensure_ascii=False,indent=2))
def fl(v):
 s=format(v,'.17g');return s+'f'if '.'in s or 'e'in s else s+'.0f'
header='#ifndef FOX_NON_EYE_BASE_COLORS_H\n#define FOX_NON_EYE_BASE_COLORS_H\n#include <string.h>\n/* Exact source scene-linear RGBA constants. Unlit diagnostic, no BSDF. */\ntypedef struct {const char *name;float rgba[4];} FoxNonEyeBaseColor;\nstatic const FoxNonEyeBaseColor fox_non_eye_base_colors[]={\n'
for r in rows:
 if r['supported']:header+=' {'+json.dumps(r['name'],ensure_ascii=False)+',{'+','.join(fl(v)for v in r['linear_rgba'])+'}},\n'
header+='};\nstatic inline const float *fox_non_eye_base_color(const char *name){\n unsigned i;for(i=0;i<sizeof(fox_non_eye_base_colors)/sizeof(fox_non_eye_base_colors[0]);i++)if(strcmp(name,fox_non_eye_base_colors[i].name)==0)return fox_non_eye_base_colors[i].rgba;\n return 0;\n}\n#endif\n'
(O/'non_eye_base_colors.h').write_text(header);print(json.dumps(out,ensure_ascii=False),flush=True)
