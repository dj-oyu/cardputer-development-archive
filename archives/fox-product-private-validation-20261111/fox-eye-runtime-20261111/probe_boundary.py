import bpy,json,pathlib,hashlib,struct,math
R=pathlib.Path('/workspace/scratch/6d8dcdbcdc54');O=R/'fox-eye-runtime-20261111';S=R/'fixed-recovery/extracted/fox-cardputer-latest-private/fox-cardputer-2k-v2.blend'
h=hashlib.sha256(S.read_bytes()).hexdigest();bpy.ops.wm.open_mainfile(filepath=str(S),use_scripts=False);sc=bpy.context.scene;c=bpy.data.objects['Expression Controls'];base={k:c[k] for k in c.keys() if k!='_RNA_UI'}
def f32(x):return struct.unpack('f',struct.pack('f',x))[0]
def near(x,d):return struct.unpack('f',struct.pack('I',struct.unpack('I',struct.pack('f',x))[0]+d))[0]
values=[.9799999,.97999999,.979999999,.98,.980000001,near(.98,-1),f32(.98),near(.98,1),.019999999,.02,.020000001,near(.02,-1),f32(.02),near(.02,1)]
rows=[]
for key in ['Blink Both','Blink -X','Blink +X']:
 for v in values:
  for k,x in base.items():c[k]=x
  c[key]=v;c.update_tag();sc.frame_set(1);bpy.context.view_layer.update();dg=bpy.context.evaluated_depsgraph_get()
  obs=[]
  for side in [-1,1]:
   e=bpy.data.objects['Expressive eye contour '+str(side)].evaluated_get(dg)
   m=bpy.data.materials['Blink mask Expressive eye contour '+str(side)]
   obs.append({'side':side,'hidden':e.hide_render,'shader_blink':m.node_tree.nodes['Blink driver'].outputs[0].default_value})
  rows.append({'key':key,'input_double':v,'stored_control':c[key],'f32':f32(v),'runtime_hidden':f32(v)>=f32(.98),'observed':obs})
assert hashlib.sha256(S.read_bytes()).hexdigest()==h
(O/'boundary-oracle.json').write_text(json.dumps({'source_sha256':h,'blender_version':bpy.app.version_string,'rows':rows},indent=2));print('BOUNDARY_OK',len(rows))
