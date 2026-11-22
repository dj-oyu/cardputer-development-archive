"""Derive a low-resolution-readable detail pass without source art or topology changes."""
import bpy,hashlib,sys,math,json
from pathlib import Path
from mathutils import Vector
from mathutils.bvhtree import BVHTree
src,dst=map(Path,sys.argv[-2:])
source_sha='387b9143495323fc5a5b4ce62eebe8702a45f6a54a30afba5e6df6773a837b6f'
assert hashlib.sha256(src.read_bytes()).hexdigest()==source_sha
bpy.ops.wm.open_mainfile(filepath=str(src.resolve()))
s=bpy.context.scene;s.frame_set(1)
face=bpy.data.objects['Sculpted cheeks, jaw and cranium']
bvh=BVHTree.FromPolygons([face.matrix_world@v.co for v in face.data.vertices],[tuple(p.vertices) for p in face.data.polygons])
def ease(a,b,x):
 t=min(1,max(0,(x-a)/(b-a)));return t*t*(3-2*t)
# Keep the existing separate facial detail layers. Re-seat those that had become
# buried when the cheek/nose surface was made deeper. Outer lid has ~1 pixel at target size.
levels = [
 ('Upper charcoal eye shape',.024), ('Ivory sclera',.030), ('Amber iris',.037),
 ('Dark oval pupil',.043), ('Large eye glint',.049), ('Small asymmetric warm smile',.031),
 ('Arched expressive eyebrow',.017)]
changed={}
for ob in s.objects:
 if ob.type!='MESH' or not ob.modifiers.get('Provisional joint continuity'):continue
 matrix=ob.matrix_world.copy(); inverse=matrix.inverted()
 sign=1 if len(ob.data.vertices) and sum((matrix@v.co).x for v in ob.data.vertices)>=0 else -1
 count=0
 for v in ob.data.vertices:
  x,y,z=matrix@v.co
  pos=Vector((x,y,z))
  for name,depth in levels:
   if not ob.name.startswith(name):continue
   if name=='Upper charcoal eye shape':
    # Small near-outer wedge, not separate eyelashes which alias badly at LCD scale.
    tail=ease(.27,.36,abs(x))*ease(4.68,4.78,z)
    x+=sign*.018*tail; z+=.030*tail+.014
   if name=='Amber iris':
    cx=-.196 if sign<0 else .232
    x=cx+1.13*(x-cx); z=4.70+1.04*(z-4.70)
   if name=='Dark oval pupil':
    cx=-.193 if sign<0 else .235
    x=cx+1.08*(x-cx)
   if name=='Small asymmetric warm smile':
    # Preserve a shallow curve, let its outer corners read rather than enlarging the mouth.
    z+=.012*ease(.04,.11,abs(x))
   hit,*_=bvh.ray_cast(Vector((x,-2,z)),Vector((0,1,0)))
   if hit is not None:y=min(y,hit.y-depth)
   break
  if ob.name.startswith(('Left swept temple curl','Right framing curl')):
   # Just clear the outside eye line in three-quarter view; lower frame remains near cheek.
   y+=.053*math.exp(-((z-4.73)/.17)**2)*(1-ease(-.24,.03,y))
   # Sweep upper lock over the ear, leaving the lower tapered cheek lock visible
   # in front of it. Carve its depth rather than growing the skin shell.
   ear=math.exp(-((z-4.56)/.181)**2)*math.exp(-((y+.096)/.166)**2)
   x-=sign*.302*ear
   y-=.058*ear*(1-ease(4.48,4.62,z))
  if ob.name.startswith(('Ear shell','Ear bowl')):
   x+=sign*.039*ease(.40,.53,abs(x))
   y=-.074+1.13*(y+.074)
  if ob.name.startswith('Bob back mass'):
   # A gentle recess in the outer cap, specific to the place the ear stays visible.
   ear=math.exp(-((z-4.55)/.21)**2)*math.exp(-((y+.059)/.195)**2)
   x-=sign*.156*ear*ease(.25,.57,abs(x))
  if ob.name.startswith('Swept layered back nape lock'):
   # Spread the middle of a few layered locks in depth, tips maintain the 04 bob silhouette.
   y+=.036*math.exp(-((z-4.79)/.26)**2)*ease(.38,.62,y)
  if ob.name.startswith('Upturned jacket lapel'):
   # Turn the collar lip outward enough to read as a separate folded plane.
   t=ease(3.94,4.22,z)
   y-=.036*t
   x+=sign*.039*t
  if (Vector((x,y,z))-pos).length>1e-6:
   v.co=inverse@Vector((x,y,z));count+=1
 if count:changed[ob.name]=count
def color(name,srgb):
 m=bpy.data.materials[name]
 lin=lambda a:a/12.92 if a<.04045 else ((a+.055)/1.055)**2.4
 rgb=tuple(lin(c/255) for c in srgb)+(1.,)
 m.diffuse_color=rgb
 for node in m.node_tree.nodes:
  if node.type=='BSDF_PRINCIPLED':node.inputs['Base Color'].default_value=rgb
color('Espresso feature lines',(35,22,19))
color('Amber eyes',(202,119,34))
color('Ear warmth',(187,107,84))
color('Teal collar and cuffs',(38,83,98))
color('Teal seam highlights',(67,136,147))
color('Chestnut lit locks',(99,52,33))
# Keep the iris outer ring as an editable rigged layer rather than a texture
# silhouette. Clone its existing modifier and copied head weights by Blender data copy.
rim_mat=bpy.data.materials['Espresso feature lines'].copy()
rim_mat.name='Warm dark amber iris rim'
color(rim_mat.name,(78,41,20))
for name in ('Amber iris','Amber iris.001'):
 iris=bpy.data.objects[name]
 rim=iris.copy(); rim.data=iris.data.copy()
 rim.name='Dark amber iris rim'+('.001' if name.endswith('.001') else '')
 iris.users_collection[0].objects.link(rim)
 rim.data.materials.clear();rim.data.materials.append(rim_mat)
 matrix=iris.matrix_world
 inverse=matrix.inverted()
 centroid=sum((matrix@v.co for v in iris.data.vertices),Vector())/len(iris.data.vertices)
 for v in rim.data.vertices:
  x,y,z=matrix@v.co
  x=centroid.x+1.13*(x-centroid.x)
  z=centroid.z+1.11*(z-centroid.z)
  hit,*_=bvh.ray_cast(Vector((x,-2,z)),Vector((0,1,0)))
  if hit is not None:y=hit.y-.034
  v.co=inverse@Vector((x,y,z))
 assert rim.modifiers.get('Provisional joint continuity') and rim.vertex_groups.get('head')
s['detail_overlay_pass']='Original posed project art matched by private transparent views; targeted LCD-scale color/shape differences. Source artwork not included.'
dst=dst.resolve();dst.parent.mkdir(parents=True,exist_ok=True)
bpy.ops.wm.save_as_mainfile(filepath=str(dst),compress=True)
(dst.parent/'detail-edit.json').write_text(json.dumps({'source_sha256':source_sha,'sha256':hashlib.sha256(dst.read_bytes()).hexdigest(),'changed_vertices':changed,'reference_images_embedded':0},indent=2)+'\n')
