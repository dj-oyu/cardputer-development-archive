"""Camera-visible material-ID matte of existing animated character in the full depth scene."""
import bpy,json
from pathlib import Path
P=Path(__file__).resolve().parent;s=bpy.context.scene
m=json.loads((P/'rear-eligibility.json').read_text());A=P/'actor-matte';A.mkdir(exist_ok=True)
actor=next(o for o in s.objects if o.type=='ARMATURE')
def mtl(name,node):
 m=bpy.data.materials.new(name);m.use_nodes=True;t=m.node_tree;t.nodes.clear()
 n=t.nodes.new(node);t.links.new(n.outputs[0],t.nodes.new('ShaderNodeOutputMaterial').inputs[0]);return m
white=mtl('Visible character silhouette','ShaderNodeEmission');hold=mtl('Occluding scene holdout','ShaderNodeHoldout')
for o in s.objects:
 if o.type!='MESH':continue
 yes=any(x.type=='ARMATURE' and x.object==actor for x in o.modifiers)
 if len(o.data.materials):
  for i in range(len(o.data.materials)):o.data.materials[i]=white if yes else hold
 else:o.data.materials.append(white if yes else hold)
s.render.film_transparent=True;s.render.image_settings.color_mode='RGBA'
# Identical samples/seed to the final beauty pass preserves subpixel alignment.
for rec in m:
 if not m[rec]['overlay']:continue
 i=int(rec);s.frame_set(i);bpy.context.view_layer.update()
 s.render.filepath=str(A/f'visible-{i:04d}.png');bpy.ops.render.render(write_still=True)
