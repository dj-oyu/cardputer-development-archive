"""Blender 4.3+ headless: export pose samples as opaque-normal+base-color GLB.
Keep original editable transforms, materials, rig and shapes in the .blend."""
import bpy, os, sys, math, bmesh, json
from pathlib import Path
import hashlib
argv=sys.argv[sys.argv.index('--')+1:]
if len(argv) != 3 or argv[2] not in ('balanced','halo-safe'):
 raise SystemExit('usage: blender -b --python-exit-code 1 --python export_trim.py -- SOURCE.blend NEW_OUTPUT_DIR balanced|halo-safe')
src=Path(argv[0]).resolve(); d=Path(argv[1]).resolve(); profile=argv[2]
source_sha=hashlib.sha256(src.read_bytes()).hexdigest()
assert source_sha=='148426cb676261c32dfe6bac01d8cb38e71b2ec66c478c0852cb3243c16c4d5c', 'unexpected source revision'
d.mkdir()
bpy.ops.wm.open_mainfile(filepath=str(src))
scene=bpy.context.scene
pal={}
def ms(name,c):
 if name not in pal:
  m=bpy.data.materials.new(name);m.use_nodes=True;m.diffuse_color=(*c,1)
  m.use_backface_culling=True # every proxy surface is closed
  bs=m.node_tree.nodes.get('Principled BSDF')
  bs.inputs['Base Color'].default_value=(*c,1);bs.inputs['Roughness'].default_value=.68
  pal[name]=m
 return pal[name]
lo=(.52,.71,1.0);hi=(.99,.983,1.0)
body_m=[ms('Cloud pale band %d'%i,tuple((1-i/6)*u+(i/6)*v for u,v in zip(hi,lo))) for i in range(7)]
rainbow=[(.85,.71,.98),(.72,.85,.99),(.70,.92,.96),(.98,.81,.88),(.99,.89,.79)]
hal_m=[ms('Pastel vapor ribbon %d'%i,c) for i,c in enumerate(rainbow)]
rig=bpy.data.objects['Cloud_Rig']
objs=[o for o in scene.objects if o.parent==rig and o.type in ('MESH','CURVE')]
def cap(n):
 if n=='Cloud body':return 640 if profile=='balanced' else 560
 if n.startswith('Floating hand'):return 72
 if n.startswith('Halo vapor'):return 88 if profile=='balanced' else 104
 if n.startswith('Eye rim'):return 36
 if n.startswith('Eye white'):return 40
 if n.startswith('Pupil'):return 44
 if n.startswith('Catchlight small'):return 12
 if n.startswith('Catchlight'):return 24
 if n.startswith('Cheek'):return 32
 if n.startswith('Brow'):return 50
 if n.startswith('Open smile'):return 77
 return 20
records={}
for frame in (1,84,166,241):
 scene.frame_set(frame); dg=bpy.context.evaluated_depsgraph_get()
 B=[]; counts={}; closed={}
 for o in objs:
  e=o.evaluated_get(dg);me=bpy.data.meshes.new_from_object(e,depsgraph=dg,preserve_all_data_layers=True);me.calc_loop_triangles()
  m0=me.materials[0];col=tuple(m0.diffuse_color)[:3];me.materials.clear()
  # Bake transforms, not lights, into per-pose files. Material bands are local
  # albedo approximation; actual lighting is supplied by consumer.
  if o.name=='Cloud body' or o.name.startswith('Floating hand'):
   for m in body_m:me.materials.append(m)
   zlo=min(v.co.z for v in me.vertices);zhi=max(v.co.z for v in me.vertices)
   for f in me.polygons:
    t=(f.center.z-zlo)/(zhi-zlo)
    f.material_index=max(0,min(6,round((1-t)*5.45)));f.use_smooth=True
  else:
   me.materials.append(hal_m[int(o.name.split()[-1])] if o.name.startswith('Halo vapor') else ms(m0.name+' opaque',col))
   for f in me.polygons:f.use_smooth=True
  for a in list(me.color_attributes):me.color_attributes.remove(a)
  x=bpy.data.objects.new(o.name+' proxy',me);scene.collection.objects.link(x);x.matrix_world=e.matrix_world.copy()
  lim=cap(o.name)
  if len(me.loop_triangles)>lim:
   mod=x.modifiers.new('Triangle budget','DECIMATE');mod.ratio=lim/len(me.loop_triangles);mod.use_collapse_triangulate=True
   bpy.context.view_layer.objects.active=x;bpy.ops.object.modifier_apply(modifier=mod.name)
  x.data.calc_loop_triangles();counts[o.name]=len(x.data.loop_triangles)
  if o.name=='Cloud body' or o.name.startswith(('Floating hand','Halo vapor')):
   bm=bmesh.new()
   try:
    bm.from_mesh(x.data)
    assert bm.faces and all(ed.is_manifold for ed in bm.edges) and all(f.calc_area()>1e-10 for f in bm.faces), (o.name,frame,'non-manifold or collapsed face')
    assert bm.calc_volume(signed=True)>0., (o.name,frame,'nonpositive volume')
    stack=[next(iter(bm.verts))]; seen=set(stack)
    while stack:
     for ed in stack.pop().link_edges:
      for v in ed.verts:
       if v not in seen: seen.add(v); stack.append(v)
    assert len(seen)==len(bm.verts),(o.name,frame,'non-connected mesh')
    closed[o.name]='one connected closed manifold with positive volume'
   finally: bm.free()
  B.append(x)
 bpy.ops.object.select_all(action='DESELECT')
 for o in B:o.select_set(True)
 end=os.path.join(d,f'cloud-opaque-{frame:03d}.glb')
 bpy.ops.export_scene.gltf(filepath=end,export_format='GLB',use_selection=True,export_animations=False,export_skins=False,export_morph=False,export_texcoords=False,export_normals=True,export_materials='EXPORT',export_yup=True,export_image_format='NONE')
 records[str(frame)]={'triangles':sum(counts.values()),'per_mesh':counts,'selected_mesh_manifold':closed,'bytes':os.path.getsize(end)}
 for o in B:
  me=o.data;bpy.data.objects.remove(o,do_unlink=True)
  if not me.users:bpy.data.meshes.remove(me)
assert hashlib.sha256(src.read_bytes()).hexdigest()==source_sha
with open(os.path.join(d,'opaque-stats.json'),'w') as f:json.dump({'source_sha256':source_sha,'profile':profile,'poses':records},f,indent=2)
