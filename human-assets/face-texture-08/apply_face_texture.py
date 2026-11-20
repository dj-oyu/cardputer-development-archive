"""Mix square, aligned transparent facial art into the Skin albedo, not as a lit overlay plane."""
import bpy,hashlib,sys,json,math
from pathlib import Path
src,texture,out=map(Path,sys.argv[-3:])
src,texture,out=(p.resolve() for p in (src,texture,out))
bpy.ops.wm.open_mainfile(filepath=str(src));s=bpy.context.scene;s.frame_set(1)
head=bpy.data.objects['Sculpted cheeks, jaw and cranium']
assert len(head.data.materials)==1
m0=head.data.materials[0]
m=m0.copy();m.name='Skin albedo + packed front-projected facial art';head.data.materials[0]=m
uvs=head.data.uv_layers.new(name='FaceGraphic_Ortho_512')
for lp in head.data.loops:
  p=head.matrix_world@head.data.vertices[lp.vertex_index].co
  uvs.data[lp.index].uv=(.5+p.x/2.24,.5+(p.z-4.78)/2.24)
a=head.data.attributes.new('FaceGraphic_front_weight','FLOAT','POINT')
# Fade only toward the side of the head; no elements in the starting graphic beyond here.
# Store weights on the rest mesh, so skinning never recalculates or slides the decal.
def smooth(x):
 t=max(0.,min(1.,x));return t*t*(3-2*t)
for v in head.data.vertices:
 y=(head.matrix_world@v.co).y
 a.data[v.index].value=1-smooth((y+.25)/.14)
img=bpy.data.images.load(str(texture),check_existing=False)
assert img.size[0]==img.size[1] and img.size[0]>=256 and img.channels==4,(tuple(img.size),img.channels)
img.alpha_mode='STRAIGHT';img.name='Packed face graphic / transparent sRGB'
img.pack();img.filepath='//face-art.png'
nodes=m.node_tree.nodes;links=m.node_tree.links
uv=nodes.new('ShaderNodeUVMap');uv.uv_map=uvs.name;uv.location=(-690,160)
tex=nodes.new('ShaderNodeTexImage');tex.image=img;tex.extension='CLIP';tex.interpolation='Linear';tex.location=(-500,160)
mask=nodes.new('ShaderNodeAttribute');mask.attribute_name=a.name;mask.location=(-500,-170)
mul=nodes.new('ShaderNodeMath');mul.operation='MULTIPLY';mul.location=(-230,-70)
mix=nodes.new('ShaderNodeMixRGB');mix.blend_type='MIX';mix.label='Transparent makeup into original base color';mix.location=(-40,180)
pbr=next(n for n in nodes if n.type=='BSDF_PRINCIPLED');pbr.location=(210,110)
if pbr.inputs['Base Color'].is_linked:
 link=pbr.inputs['Base Color'].links[0];links.new(link.from_socket,mix.inputs[1]);links.remove(link)
else:mix.inputs[1].default_value=pbr.inputs['Base Color'].default_value
links.new(uv.outputs['UV'],tex.inputs['Vector']);links.new(tex.outputs['Alpha'],mul.inputs[0]);links.new(mask.outputs['Fac'],mul.inputs[1]);links.new(mul.outputs[0],mix.inputs[0]);links.new(tex.outputs['Color'],mix.inputs[2]);links.new(mix.outputs[0],pbr.inputs['Base Color'])
s['face_texture_08']='Square 2.24 orthographic facial art in rest UV. No feature mesh, no albedo art on ears/rear/hair, head-rig tracking.'
out.parent.mkdir(exist_ok=True,parents=True)
bpy.ops.wm.save_as_mainfile(filepath=str(out),compress=True)
(out.parent/'projection-evidence.json').write_text(json.dumps({'source_sha256':hashlib.sha256(src.read_bytes()).hexdigest(),'texture_sha256':hashlib.sha256(texture.read_bytes()).hexdigest(),'model_sha256':hashlib.sha256(out.read_bytes()).hexdigest(),'image_size':list(img.size),'projection':'front -Y, up +Z; width 2.24, target z 4.78; packed PNG','affected_object':head.name},indent=2)+'\n')
