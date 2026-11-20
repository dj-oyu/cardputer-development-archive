"""Fit the selected varsity outfit to the saved authoring rig."""
import bpy,sys,math,hashlib,json
from mathutils import Vector
from mathutils.bvhtree import BVHTree
from mathutils.geometry import tessellate_polygon
from pathlib import Path
src,dst=map(Path,sys.argv[-2:])
assert hashlib.sha256(src.read_bytes()).hexdigest()=='50065bcac43753ba878d13dac6d959f734d984a399094833141f018ec142519e'
bpy.ops.wm.open_mainfile(filepath=str(src.resolve()))
scene=bpy.context.scene;scene.frame_set(1)
rig=next(o for o in scene.objects if o.type=='ARMATURE')
jacket=bpy.data.collections['Jacket and T-shirt'];shorts=bpy.data.collections['Shorts']
def mat(name, rgb, rough=.65):
 m=bpy.data.materials.new(name);m.use_nodes=True
 lin=lambda v:v/12.92 if v<.04045 else ((v+.055)/1.055)**2.4
 col=tuple(lin(c/255) for c in rgb)+(1.,)
 m.diffuse_color=col
 node=m.node_tree.nodes.get('Principled BSDF');node.inputs['Base Color'].default_value=col;node.inputs['Roughness'].default_value=rough
 return m
pine=mat('Varsity forest green wool',(30,55,42));rib=mat('Varsity dark forest rib knit',(22,47,35));ivory=mat('Varsity warm ivory sleeves',(224,211,185))
welts=mat('Warm ivory welt and stripe',(234,219,183));snap=mat('Warm pewter varsity snap',(181,163,137),.30)
tobacco=mat('Tobacco twill',(113,73,49));fold=mat('Tobacco pleat and rolled hem',(140,91,56))
oxblood=mat('Oxblood boot leather',(87,41,37),.41);sole=mat('Roasted umber outsole',(55,41,32))
gold=mat('Golden amber embroidered badge',(239,160,42));border=mat('Golden edge embroidery',(194,111,17));ink=mat('Dark charcoal lightning embroidery',(19,18,14))
def setmat(o,m):o.data.materials.clear();o.data.materials.append(m)
def tstep(a,b,x):
 t=max(0,min(1,(x-a)/(b-a)));return t*t*(3-2*t)
def new(name,vs,fs,materials,mats,groups,collection=jacket,smooth=True):
 me=bpy.data.meshes.new(name);me.from_pydata(vs,[],fs);me.update()
 o=bpy.data.objects.new(name,me);collection.objects.link(o)
 for m in materials: me.materials.append(m)
 for p,i in zip(me.polygons,mats): p.material_index=i;p.use_smooth=smooth
 # Normals must be outward even for independently mirrored sleeve frames.
 import bmesh
 bm=bmesh.new();bm.from_mesh(me);bmesh.ops.recalc_face_normals(bm,faces=list(bm.faces));bm.to_mesh(me);bm.free()
 for i,gs in enumerate(groups):
  for n,w in gs:
   if w<1e-6:continue
   g=o.vertex_groups.get(n) or o.vertex_groups.new(name=n)
   g.add([i],w,'REPLACE')
 mod=o.modifiers.new('Provisional joint continuity','ARMATURE');mod.object=rig;mod.use_deform_preserve_volume=True
 return o
def bvh(o):
 return BVHTree.FromPolygons([o.matrix_world@v.co for v in o.data.vertices],[tuple(p.vertices) for p in o.data.polygons])
def fixed(name,n):return [[(name,1.)] for _ in range(n)]
def attached_depth(tree,x,z,clearance):
 p,*_=tree.ray_cast(Vector((x,-2,z)),Vector((0,1,0)))
 return None if p is None else Vector((x,p.y-clearance,z))
def plate(name,tree,outline,material,bone='spine',offset=.021,collection=jacket):
 points=[attached_depth(tree,x,z,offset) for x,z in outline]
 if any(p is None or p.y>-.10 for p in points):return None
 return new(name,points,[list(range(len(points)))],[material],[0],fixed(bone,len(points)),collection=collection,smooth=False)
vests={};pant=[]
tee=bvh(bpy.data.objects['Soft ivory tee base'])
for o in list(scene.objects):
 n=o.name;kind=o.users_collection[0].name
 if n.startswith(('Shaped rolled jacket sleeve','Rolled fabric sleeve cuff')):
  bpy.data.objects.remove(o,do_unlink=True);continue
 if kind=='Jacket and T-shirt':
  if n.startswith('Jacket cut front and back'):setmat(o,pine);vests['L' if n.endswith('.001') else 'R']=o
  elif n.startswith(('Cropped jacket hem','Upturned jacket lapel','Open jacket front binding')):setmat(o,rib)
 if kind=='Shorts' and not n.startswith('Brass waist button'):
  setmat(o,fold if n.startswith(('Double-rolled','Topstitched','Diagonal pocket')) else tobacco)
  if n.startswith(('Tailored high-rise shorts leg','Waist and seat')):pant.append(o)
 if n.startswith(('Jacket cut front and back','Cropped jacket hem','Open jacket front binding')):
  world=o.matrix_world; inv=world.inverted()
  for v in o.data.vertices:
   x,y,z=world@v.co
   forward=1-tstep(-.24,-.09,y)
   inner=1-tstep(.25,.45,abs(x))
   if forward*inner>.03:
    x-=math.copysign(.078*forward*inner,x)
    surface=attached_depth(tee,x,z,.040 if n.startswith('Open jacket') else .026)
    if surface and y>surface.y:y=y+(surface.y-y)*forward*inner
    v.co=inv@Vector((x,y,z))
 if n.startswith('Ochre ankle boot'):setmat(o,oxblood)
 if n.startswith('Cream lug outsole'):setmat(o,sole)
# Long blouson sleeves from shoulder to wrist, with elbow loops and knitted
# cuff built into the mesh. Separate named sleeve material per fabric piece.
sleeves={}
rings=[(-.08,.116,.140),(-.02,.167,.184),(.09,.212,.222),(.23,.207,.223),(.38,.219,.221),(.51,.227,.22),(.61,.229,.222),(.69,.218,.211),(.78,.214,.213),(.91,.211,.214),(1.06,.213,.213),(1.18,.205,.196),(1.25,.168,.168),(1.29,.131,.124),(1.31,.133,.128),(1.338,.133,.128),(1.374,.132,.127),(1.400,.128,.122)]
sleeve_n=24
for side,sign in [('R',-1.),('L',1.)]:
 arm=rig.data.bones['upper-arm.'+side]; fore=rig.data.bones['forearm.'+side]
 A,E,W=arm.head_local,arm.tail_local,fore.tail_local
 u=(E-A).normalized();v=(W-E).normalized();le=(E-A).length;lf=(W-E).length
 def axis(s):
  ctr=A+s*u if s<=le else E+(s-le)*v
  ax=u.lerp(v,tstep(le-.14,le+.14,s)).normalized()
  outward=Vector((sign,0,0));outward=(outward-outward.dot(ax)*ax).normalized()
  forward=Vector((0,-1,0));forward=(forward-forward.dot(ax)*ax-forward.dot(outward)*outward).normalized()
  return ctr,outward,forward
 vs=[];fs=[];mi=[];wg=[]
 for j,(s,rx,ry) in enumerate(rings):
  c,a,b=axis(s)
  for i in range(sleeve_n):
   f=math.tau*i/sleeve_n
   # very broad volume folds around the forearm, narrowing at the wrist knit.
   ripple=(1.+.046*math.cos(3*f+1.3*s)*math.sin(math.pi*tstep(.76,1.28,s)))
   vs.append(c+ripple*(rx*math.cos(f)*a+ry*math.sin(f)*b))
   w=tstep(le-.23,le+.25,s)
   wg.append([('upper-arm.'+side,1-w),('forearm.'+side,w)])
  if j:
   for i in range(sleeve_n):
    fs.append(((j-1)*sleeve_n+i,(j-1)*sleeve_n+(i+1)%sleeve_n,j*sleeve_n+(i+1)%sleeve_n,j*sleeve_n+i))
    mi.append(2 if j==15 else (1 if j>=13 else 0))
 o=new('Long ivory varsity sleeve and forest cuff.'+side,vs,fs,[ivory,rib,welts],mi,wg)
 sleeves[side]=o
 if side!='R':continue
 # Rounded embroidered shield and lightning on the anatomical right upper arm only.
 # Project to the actual sleeve, and share rigid upper-arm deformation in this region.
 surface=bvh(o)
 def badge(uv, offset):
  x,z=uv;ss=.245-z;ang=.36+x/.225
  c,a,b=axis(ss);d=math.cos(ang)*a+math.sin(ang)*b
  hit,*_=surface.ray_cast(c+d,-d)
  assert hit is not None,uv
  return hit+d*offset
 def rr(w,h,r):
  return [(sx*(w/2-r)+r*math.cos(math.radians(a)),sy*(h/2-r)+r*math.sin(math.radians(a))) for sx,sy,start in [(1,1,0),(-1,1,90),(-1,-1,180),(1,-1,270)] for a in (start,start+30,start+60,start+90)]
 for label,coords,m,lift in [('Gold badge edge',rr(.310,.333,.049),border,.014),('Golden amber badge',rr(.285,.307,.043),gold,.021)]:
  verts=[badge(x,lift) for x in [(0,0)]+coords]
  faces=[(0,i+1,((i+1)%len(coords))+1) for i in range(len(coords))]
  new('Right sleeve '+label,verts,faces,[m],[0]*len(faces),fixed('upper-arm.R',len(verts)),smooth=False)
 # Seven-corner bolt, wide enough for ~2–3 LCD pixels, no mirroring or other sleeve artwork.
 bolt=[(.011,.113),(.082,.113),(.020,.019),(.068,.019),(-.065,-.113),(-.024,-.015),(-.074,-.015)]
 poly=[Vector((x,z,0)) for x,z in bolt];lookup={tuple(v):i for i,v in enumerate(poly)}
 faces=[[int(v) if isinstance(v,int) else lookup[tuple(v)] for v in f] for f in tessellate_polygon([poly])]
 verts=[badge(q,.035) for q in bolt]
 new('Right sleeve lightning glyph only',verts,faces,[ink],[0]*len(faces),fixed('upper-arm.R',len(verts)),smooth=False)
# Readable design accents on the existing jacket; no red trim.
for side,o in vests.items():
 sign=-1 if side=='R' else 1; tree=bvh(o)
 def zx(rows):return [(sign*x,z) for x,z in rows]
 plate('Ivory diagonal varsity pocket welt.'+side,tree,zx([(.234,3.350),(.281,3.337),(.361,3.570),(.315,3.583)]),welts)
 for z in [3.218,3.258]:
  plate('Ivory waist rib stripe.'+side,tree,zx([(.188,z),(.344,z),(.344,z+.022),(.188,z+.022)]),welts)
 for z in [3.30,3.49,3.68,3.86]:
  outline=zx([(.194+.025*math.cos(i*math.tau/10),z+.025*math.sin(i*math.tau/10)) for i in range(10)])
  plate('Matte metal snap.'+side,tree,outline,snap,bone='spine' if z<3.55 else 'chest',offset=.043)
# Visible pleats; sparse shaped strips follow the existing combined overshort surface.
for idx,sign in enumerate((-1,1)):
 tris=[]
 for o in pant:
  v=[o.matrix_world@p.co for p in o.data.vertices];tris.append((v,[tuple(q.vertices) for q in o.data.polygons]))
 verts=[]; faces=[]
 for vs,fs in tris:
  offset=len(verts);verts+=vs;faces += [tuple(offset+i for i in f) for f in fs]
 tree=BVHTree.FromPolygons(verts,faces)
 side='R' if sign<0 else 'L'
 for shift in (0.,.095):
  outlines=[(sign*(x+shift),z) for x,z in [(.17,3.065),(.204,3.048),(.207,2.83),(.254,2.54),(.233,2.54),(.182,2.83)]]
  plate('Tobacco shorts pressed pleat.'+side,tree,outlines,fold,bone='pelvis',offset=.016,collection=shorts)
scene['varsity_outfit_notes']='Deep forest and ivory varsity outfit. One amber lightning badge on anatomical right upper sleeve. Editable color and geometry, no design images linked.'
dst=dst.resolve();dst.parent.mkdir(exist_ok=True,parents=True)
bpy.ops.wm.save_as_mainfile(filepath=str(dst),compress=True)
