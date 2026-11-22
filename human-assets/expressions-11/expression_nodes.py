"""Install independent, optional slot replacement textures on the exact face-08 UVs."""
from pathlib import Path
import bpy, sys, hashlib, json
base,eye_neutral,eyes,mouth,out=map(Path,sys.argv[-5:])
base,eye_neutral,eyes,mouth,out=(x.resolve() for x in (base,eye_neutral,eyes,mouth,out))
assert hashlib.sha256(base.read_bytes()).hexdigest()=='b85782ddda968c5e8b6c43bc60079a206900b67117b9e513c22afed76e64d5e4'
bpy.ops.wm.open_mainfile(filepath=str(base));s=bpy.context.scene
s.frame_set(1)
r=next(o for o in s.objects if o.type=='ARMATURE')
head=bpy.data.objects['Sculpted cheeks, jaw and cranium']
m=head.data.materials[0]
nodes=m.node_tree.nodes; links=m.node_tree.links
uv=next(n for n in nodes if n.type=='UVMAP')
neutral=next(n for n in nodes if n.type=='TEX_IMAGE')
neutral.image.use_fake_user=True  # untouched 08 source stays packed and recoverable.
enhanced=bpy.data.images.load(str(eye_neutral))
enhanced.alpha_mode='STRAIGHT';enhanced.name='Packed face neutral larger eyes';enhanced.pack();enhanced.filepath='//expression-neutral.png'
neutral.image=enhanced
orig_mix=next(n for n in nodes if n.type=='MIX_RGB')
orig_alpha=next(n for n in nodes if n.type=='MATH' and n.operation=='MULTIPLY')
rgb=neutral.outputs['Color']; alpha=neutral.outputs['Alpha']
assert orig_mix.inputs[2].is_linked and orig_alpha.inputs[0].is_linked
prev=(rgb,alpha)
controls={'Blink': (eyes,[(337,482,482,629),(543,482,692,629)]),
          'Smile': (mouth,[(438,630,595,686)])}
split=nodes.new('ShaderNodeSeparateXYZ');split.label='Calibrated facial UV, no remap'
links.new(uv.outputs['UV'],split.inputs[0])
def calc(op,a,b):
 n=nodes.new('ShaderNodeMath');n.operation=op
 for j,v in enumerate([a,b]):
  if isinstance(v,(int,float)): n.inputs[j].default_value=v
  else:links.new(v,n.inputs[j])
 return n.outputs[0]
def area(rect):
 l,t,u,b=rect;N=1024
 x,y=split.outputs[0],split.outputs[1]
 return calc('MULTIPLY',calc('MULTIPLY',calc('GREATER_THAN',x,l/N),calc('LESS_THAN',x,u/N)),
              calc('MULTIPLY',calc('GREATER_THAN',y,1-b/N),calc('LESS_THAN',y,1-t/N)))
def step(name,texture,rectangles):
 global prev
 key='Face '+name
 frame=nodes.new('NodeFrame');frame.label=f'{name}: independent replacement only inside reserved UV area';frame.name='Face Slot - '+name
 r[key]=0.0;r.id_properties_ui(key).update(min=0.,max=1.,soft_min=0.,soft_max=1.,description=f'0 neutral, 1 {name.lower()}; can be keyed independently.')
 control=nodes.new('ShaderNodeValue');control.label=key;control.parent=frame
 drv=control.outputs[0].driver_add('default_value').driver;drv.type='AVERAGE'
 var=drv.variables.new();var.name='switch';var.type='SINGLE_PROP';var.targets[0].id=r;var.targets[0].data_path=f'["{key}"]'
 tex=nodes.new('ShaderNodeTexImage');tex.label=name+' override';tex.parent=frame
 img=bpy.data.images.load(str(texture));img.alpha_mode='STRAIGHT';img.name='Packed face '+name.lower()
 assert tuple(img.size)==(1024,1024) and img.channels==4
 img.pack();img.filepath='//expression-'+name.lower()+'.png'
 tex.image=img;tex.extension='CLIP';tex.interpolation='Linear'
 links.new(uv.outputs['UV'],tex.inputs['Vector'])
 bounds=area(rectangles[0])
 for rect in rectangles[1:]:bounds=calc('MAXIMUM',bounds,area(rect))
 fac=calc('MULTIPLY',bounds,calc('GREATER_THAN',control.outputs[0],.5))
 col=nodes.new('ShaderNodeMixRGB');col.label=f'Apply {name.lower()} RGB';col.parent=frame
 links.new(fac,col.inputs[0]);links.new(prev[0],col.inputs[1]);links.new(tex.outputs['Color'],col.inputs[2])
 a=nodes.new('ShaderNodeMix');a.data_type='FLOAT';a.label=f'Apply {name.lower()} alpha';a.parent=frame
 links.new(fac,a.inputs[0]);links.new(prev[1],a.inputs[2]);links.new(tex.outputs['Alpha'],a.inputs[3])
 # Give the graph coherent browsing order.
 xpos=330 if name=='Blink' else 900
 frame.location=(xpos,-350)
 control.location=(0,0);tex.location=(0,-130);col.location=(230,0);a.location=(230,-130)
 prev=(col.outputs[0],a.outputs[0])
for name,(tex,rects) in controls.items():step(name,tex,rects)
links.new(prev[0],orig_mix.inputs[2]);links.new(prev[1],orig_alpha.inputs[0])
orig_mix.location=(1500,200);orig_alpha.location=(1300,-40)
next(n for n in nodes if n.type=='BSDF_PRINCIPLED').location=(1710,220)
next(n for n in nodes if n.type=='OUTPUT_MATERIAL').location=(1960,220)
s['face_expression_slots']='Blink and Smile are independent 0/1 rig properties. Eyebrow area reserved and neutral; existing UV and rig motion unchanged.'
out.parent.mkdir(parents=True,exist_ok=True)
bpy.ops.wm.save_as_mainfile(filepath=str(out),compress=True)
