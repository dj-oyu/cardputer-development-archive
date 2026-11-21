"""Ease the sharp front crotch-plane transition; preserve the projected frontal outline."""
import bpy,sys,hashlib
from pathlib import Path
a,b=map(Path,sys.argv[-3:-1]);k=float(sys.argv[-1])
assert hashlib.sha256(a.read_bytes()).hexdigest()=='10c954f9a9e9c034684cd6a18e053e4060858e964e357f02e1445f2569f3a258'
bpy.ops.wm.open_mainfile(filepath=str(a.resolve()),use_scripts=False)
m=bpy.data.objects['Waist and seat'].data
for vi,delta in {39:-.017,47:-.017,40:.009,48:.008,89:.006,159:.006,90:-.007,160:-.007}.items():
 m.vertices[vi].co.y+=delta*k
m.update()
# Broad tone only; keep source artwork byte-identical (no drawn edge or shadow line).
import numpy as np
W,H=256,128
Y,X=np.mgrid[0:H,0:W].astype('float32')
U=(X+.5)/W;V=(Y+.5)/H
x=(U-.25)*1.2/.42
z=(V-.03)*.92/.94+2.32
tone=1-.037*np.exp(-((z-2.63)/.068)**2-((np.abs(x)-.102)/.102)**2)
tex=bpy.data.images.new('Tobacco twill | soft fabric tone v39',width=W,height=H,alpha=False);tex.colorspace_settings.name='Non-Color'
rgba=np.ones((H,W,4),dtype='float32');rgba[:,:,:3]=tone[:,:,None]
tex.pixels.foreach_set(rgba.ravel());tex.update();tex.pack()
mat=m.materials[0].copy();mat.name='Tailored tobacco twill | soft fabric tone';m.materials[0]=mat
nodes=mat.node_tree.nodes;links=mat.node_tree.links
bs=next(n for n in nodes if n.type=='BSDF_PRINCIPLED');base=bs.inputs['Base Color'];prev=base.links[0].from_socket
mapnode=nodes.new('ShaderNodeTexImage');mapnode.image=tex;mapnode.extension='EXTEND'
uv=nodes.new('ShaderNodeUVMap');uv.uv_map='Tailored seams | front and back'
mix=nodes.new('ShaderNodeMixRGB');mix.blend_type='MULTIPLY';mix.inputs[0].default_value=1
links.new(prev,mix.inputs[1]);links.new(uv.outputs['UV'],mapnode.inputs['Vector'])
links.new(mapnode.outputs['Color'],mix.inputs[2]);links.new(mix.outputs[0],base)
bpy.ops.wm.save_as_mainfile(filepath=str(b.resolve()),compress=True)
