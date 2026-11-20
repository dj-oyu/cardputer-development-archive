"""v15: one hair pigment, short-range geometry-driven contact AO."""
import bpy,sys,hashlib
from pathlib import Path
src,dst=map(lambda x:Path(x).resolve(),sys.argv[-2:])
assert hashlib.sha256(src.read_bytes()).hexdigest()=='f57d7a60d035f49a17565d0fe5b59f3a1614c6b2b98b5e0333962ae7f9407c67'
bpy.ops.wm.open_mainfile(filepath=str(src),use_scripts=False)
hair=list(bpy.data.collections['Hair – sculpted locks'].objects)
oldm={m for o in hair for m in o.data.materials}; oldimg={n.image for m in oldm for n in m.node_tree.nodes if n.type=='TEX_IMAGE' and n.image}
# Display RGB single pigment; no painted dark/light areas or texture.
def srgb(q):
 q/=255
 return q/12.92 if q<.04045 else ((q+.055)/1.055)**2.4
pigment=(*[srgb(q) for q in (91,53,37)],1)
m=bpy.data.materials.new('Hair · chestnut and real contact only');m.diffuse_color=pigment;m.use_nodes=True
n=m.node_tree.nodes;p=n.get('Principled BSDF')
p.inputs['Roughness'].default_value=.66;p.inputs['Specular IOR Level'].default_value=.27
p.inputs['Base Color'].default_value=pigment
ao=n.new('ShaderNodeAmbientOcclusion');ao.name='Contact geometry';ao.label='Short-range AO: overlapping geometry / concave boundaries'
ao.inputs['Distance'].default_value=.095;ao.samples=32
# Not "Only Local": the front fringe, temple curls and cap are distinct meshes.
ao.only_local=False
# Convex smooth regions: AO near 1, same as the unmodulated pigment. Expose a
# single mix strength for A/B and for renderer fallback; keep a nonblack floor.
r=n.new('ShaderNodeMapRange');r.name='Contact contrast';r.label='Contact falloff, no tint change'
r.inputs['From Min'].default_value=.20;r.inputs['From Max'].default_value=.96
r.inputs['To Min'].default_value=.32;r.inputs['To Max'].default_value=1;r.clamp=True
u=n.new('ShaderNodeMixRGB');u.name='Chestnut contact mix';u.label='AO amount (zero for matched control)'
u.blend_type='MULTIPLY';u.inputs[0].default_value=.78;u.inputs[1].default_value=pigment
ln=m.node_tree.links;ln.new(ao.outputs['AO'],r.inputs['Value']);ln.new(r.outputs['Result'],u.inputs[2]);ln.new(u.outputs['Color'],p.inputs['Base Color'])
for node,pos in ((ao,(-610,80)),(r,(-400,80)),(u,(-190,80)),(p,(20,80)),(n.get('Material Output'),(330,80))):node.location=pos
for o in hair: o.data.materials[0]=m
for retired in oldm:
 assert not any(retired in list(o.data.materials) for o in bpy.context.scene.objects if o.type=='MESH')
 bpy.data.materials.remove(retired,do_unlink=True)
for retired in oldimg:
 assert not retired.users,retired.name
 bpy.data.images.remove(retired)
bpy.ops.wm.save_as_mainfile(filepath=str(dst),compress=True)
