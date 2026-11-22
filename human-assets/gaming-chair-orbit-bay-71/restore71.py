"""Restore live aperture-subtree texture sheets without changing geometry or camera/chair actions."""
import bpy,sys,math,json
from pathlib import Path
P=Path(__file__).resolve().parent;sys.path.append(str(P))
from timeline import state,N
s=bpy.context.scene;o=next(x for x in s.objects if x.name.startswith('Rear aperture'))
nt=o.active_material.node_tree;n=nt.nodes
l={int(x.label[:2]):x for x in n if x.type=='MIX_RGB' and x.label[:2].isdigit()}
tex={int(i):next(a for a in n if a.type=='TEX_IMAGE' and a.label.startswith(z)) for i,z in [(4,'0.60'),(5,'0.44'),(6,'0.31'),(8,'0.13')]}
def bind(source,to):
 for e in list(to.links):nt.links.remove(e)
 if hasattr(source,'node'):nt.links.new(source,to)
 else:to.default_value=source
def M(op,x,y,label=''):
 a=n.new('ShaderNodeMath');a.operation=op;a.label=label;bind(x,a.inputs[0]);bind(y,a.inputs[1]);return a.outputs[0]
def value(name,pick):
 a=n.new('ShaderNodeValue');a.label=name
 for i in range(N+1):
  a.outputs[0].default_value=pick(state(i%N))
  a.outputs[0].keyframe_insert('default_value',frame=i+1)
 return a.outputs[0]
phase={
 4:value('Live v71 / independent tank slosh',lambda x:{'settled':0,'left':1,'right':2}[x[2]]),
 5:value('Live v71 / independent bottle bubbles',lambda x:x[1]),
 6:value('Live v71 / engine and local ignition phase',lambda x:x[3]),
}
def img(p):
 q=bpy.data.images.load(str(P/'optics'/p),check_existing=False);q.pack();return q
def softsheet(uv,ind,tiles):
 sep=n.new('ShaderNodeSeparateXYZ');bind(uv,sep.inputs[0])
 u,v=sep.outputs[:2]
 restrict=M('MULTIPLY',M('MULTIPLY',M('GREATER_THAN',u,0),M('LESS_THAN',u,1)),
                      M('MULTIPLY',M('GREATER_THAN',v,0),M('LESS_THAN',v,1)),'Clip to each cell, not adjacent frames')
 cb=n.new('ShaderNodeCombineXYZ')
 bind(M('DIVIDE',M('ADD',u,ind),tiles,'Pack U to active phase cell'),cb.inputs[0]);bind(v,cb.inputs[1])
 return cb.outputs[0],restrict
engine_lookup=None
lp=n.new('ShaderNodeLightPath');lp.label='All new optics are camera ray only; no outer illumination'
camera_ray=lp.outputs['Is Camera Ray']
for i,(name,tiles,desc) in {4:('neutral-tank-3.png',3,'04 / rotating tank: fixed V8 pocket optics'),
 5:('blue-bottle-6.png',6,'05 / animated blue bottle'),
 6:('engine-phases-12.png',12,'06 / axial V8, live piston and pin light'),
 8:('tube-static.png',1,'08 / folded intake tube (source bake)')}.items():
 t=tex[i]
 assert len(t.outputs['Alpha'].links)==1
 factor=t.outputs['Alpha'].links[0].to_node.outputs[0]
 t.image=img(name);t.interpolation='Linear';t.extension='CLIP';l[i].label=desc
 if tiles>1:
  orig=t.inputs[0].links[0].from_socket
  coords,gate=softsheet(orig,phase[i],tiles);bind(coords,t.inputs[0])
  factor=M('MULTIPLY',factor,gate,'Keep current depth branch inside its sheet cell')
  if i==6:engine_lookup=(coords,gate)
 bind(M('MULTIPLY',factor,camera_ray,'No indirect illumination from substituted optical plates'),l[i].inputs[0])
# Restore secondary reflection on saved inner radiator only. It gets occluded
# by overlying engine, pipe, coolant, and cables, and doesn't light physical shell.
t=n.new('ShaderNodeTexImage');t.label='Local pin response on authentic inner metal only'
t.image=img('near-local-falloff-12.png');t.extension='CLIP';bind(engine_lookup[0],t.inputs[0])
strong=M('MULTIPLY',M('MULTIPLY',t.outputs['Alpha'],engine_lookup[1]),camera_ray)
orig=l[2].inputs[2].links[0].from_socket
r=n.new('ShaderNodeMixRGB');r.blend_type='ADD';r.label='Only inside radiator plate: caged nearby reflection'
bind(strong,r.inputs[0]);bind(orig,r.inputs[1]);bind((.11,.046,.008,1),r.inputs[2]);bind(r.outputs[0],l[2].inputs[2])
for f in nt.animation_data.action.fcurves:
 for k in f.keyframe_points:k.interpolation='CONSTANT'
s['v71_preview']='Active optical aperture restores live plane-atlas V8/ignition/tank/bottle motion and relit intake bake; independent source camera and seat animations unchanged; not the same per-view full 3D virtual rendering as old offline review, not hardware.'
s.frame_set(13)
# Open in the rear camera with material preview. Use F12 for the native proof.
for screen in bpy.data.screens:
 for area in screen.areas:
  if area.type=='VIEW_3D':
   sp=area.spaces.active
   sp.shading.type='MATERIAL'
   if sp.region_3d:sp.region_3d.view_perspective='CAMERA'

bpy.context.preferences.filepaths.save_version=0
bpy.ops.wm.save_as_mainfile(filepath=str(P/'chair-camera-bay-v71.blend'),compress=True)
