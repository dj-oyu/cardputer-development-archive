'''Controlled runtime LOD from the editable v44 seated reference.'''
import bpy,sys,os,math,json
from pathlib import Path
s=bpy.context.scene;r=next(o for o in s.objects if o.type=='ARMATURE')
level=os.getenv('LOD','runtime'); hero=level=='hero'; lite=level=='lite'
r.animation_data.action, act=(None,r.animation_data.action)
for p in r.pose.bones:p.matrix_basis.identity()
bpy.context.view_layer.update()
def reweave_sleeve(o,segs,rings):
 m=o.data; lut=[round(j*24/segs)%24 for j in range(segs)]
 ids=[i*24+j for i in rings for j in lut]
 xyz=[m.vertices[k].co.copy() for k in ids]
 groups=[g.name for g in o.vertex_groups]
 weights=[[(v.group,v.weight) for v in m.vertices[k].groups] for k in ids]
 polys=[];mat=[]
 for i,ri in enumerate(rings[:-1]):
  assert len(set(x.material_index for x in list(m.polygons)[ri*24:rings[i+1]*24]))==1
  for j in range(segs):
   k=(j+1)%segs
   # source camera shell winding
   p=m.polygons[ri*24+lut[j]]
   q=(i*segs+j,(i+1)*segs+j,(i+1)*segs+k,i*segs+k)
   if p.vertices[1]==ri*24+(lut[j]+1)%24:q=q[::-1]
   polys.append(q);mat.append(p.material_index)
 mm=bpy.data.meshes.new(m.name+' runtime rings');mm.from_pydata(xyz,[],polys);mm.update()
 for ma in m.materials:mm.materials.append(ma)
 for p,ma in zip(mm.polygons,mat):p.material_index=ma;p.use_smooth=True
 o.data=mm
 for gn in groups:o.vertex_groups.new(name=gn)
 for ind,ww in enumerate(weights):
  for g,v in ww:o.vertex_groups[g].add([ind],v,'REPLACE')
def reweave_leg(o,segs=8):
 m=o.data; sr=14
 rings=list(range(9));pick=[round(j*sr/segs)%sr for j in range(segs)]
 ids=[i*sr+j for i in rings for j in pick]
 xyz=[m.vertices[k].co.copy() for k in ids]
 groups=[g.name for g in o.vertex_groups]
 ww=[[(g.group,g.weight) for g in m.vertices[k].groups] for k in ids]
 polys=[tuple(reversed(range(segs))),tuple((len(rings)-1)*segs+j for j in range(segs))]
 for i in range(len(rings)-1):
  for j in range(segs):
   k=(j+1)%segs;polys.append((i*segs+j,i*segs+k,(i+1)*segs+k,(i+1)*segs+j))
 mm=bpy.data.meshes.new(m.name+' runtime rings');mm.from_pydata(xyz,[],polys);mm.update()
 for ma in m.materials:mm.materials.append(ma)
 for p in mm.polygons:p.use_smooth=len(p.vertices)==4
 o.data=mm
 for gn in groups:o.vertex_groups.new(name=gn)
 for ind,weights in enumerate(ww):
  for g,v in weights:o.vertex_groups[g].add([ind],v,'REPLACE')
def budget(n):
 if n=='Preview floor only':return None
 m={'Bob back mass':(.39,.27),'Brass waist button':(.28,.20),'Cream lug outsole':(.5,.28),'Cropped jacket hem':(.62,.35),'Ear bowl':(.38,.20),'Ear shell':(.50,.29),'Elbow and narrowing forearm':(.55,.34),'Ivory scoop binding':(.61,.30),'Jacket cut front and back':(.76,.67),'Large right side-sweep':(.63,.52),'Left wide brushed fringe':(.63,.52),'Left swept temple curl':(.37,.24),'Right framing curl':(.37,.24),'Little lifted crown tuft':(.59,.45),'Neck':(.50,.35),'Ochre ankle boot and rounded vamp':(.5,.34),'Open jacket front binding':(.67,.37),'Relaxed blockout fist':(.53,.33),'Separate resting thumb':(.45,.28),'Sculpted cheeks, jaw and cranium':(.86,.64),'Soft ivory tee base':(.57,.39),'Thigh to shin continuous leg':(.60,.35),'Topstitched waistband':(.72,.45),'Waist and seat':(.70,.47)}
 n=n.removesuffix('.001');k=m.get(n)
 if lite:
  alt={'Waist and seat':.41,'Bob back mass':.24,'Cream lug outsole':.19,'Ear shell':.21,'Elbow and narrowing forearm':.28,'Ochre ankle boot and rounded vamp':.27,'Soft ivory tee base':.26,'Relaxed blockout fist':.25,'Separate resting thumb':.2,'Neck':.25,'Topstitched waistband':.35,'Sculpted cheeks, jaw and cranium':.56,'Cropped jacket hem':.28}
  if n in alt:return alt[n]
 return k[0 if hero else 1] if k else 1.
hide=set()
if not hero:
 hide={'Ear bowl','Ear bowl.001','Ivory scoop binding'}
for o in list(s.objects):
 if o.type!='MESH' or o.name=='Preview floor only':continue
 if o.name in hide:
  bpy.data.objects.remove(o,do_unlink=True);continue
 if o.name.startswith('Long ivory varsity sleeve'):
  reweave_sleeve(o,12 if hero else 8,[0,2,4,5,7,8,10,12,13,14,15,17] if hero else [0,3,5,7,8,12,14,15,17]);continue
 if not hero and o.name.startswith('Thigh to shin continuous leg'):
  reweave_leg(o);continue
 if not hero:
  for mo in list(o.modifiers):
   if mo.type=='SOLIDIFY':o.modifiers.remove(mo)
 rat=budget(o.name)
 if rat<1:
  bpy.context.view_layer.objects.active=o
  mo=o.modifiers.new('Rhythm-preserving silhouette LOD','DECIMATE');mo.ratio=rat
  bpy.ops.object.modifier_move_to_index(modifier=mo.name,index=0);bpy.ops.object.modifier_apply(modifier=mo.name)
r.animation_data.action=act
s.frame_set(1);bpy.context.view_layer.update()
p=Path(sys.argv[-1]).resolve();bpy.context.preferences.filepaths.save_version=0;bpy.ops.wm.save_as_mainfile(filepath=str(p))
