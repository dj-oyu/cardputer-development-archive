import bpy, math, sys, random, hashlib, json
from mathutils import Vector
from pathlib import Path
a=sys.argv[sys.argv.index('--')+1:] if '--' in sys.argv else []
root=Path(__file__).resolve().parent
variant=a[0] if a else 'all'
def scene(path):
    bpy.ops.wm.read_factory_settings(use_empty=True)
    s=bpy.context.scene
    s.render.engine='CYCLES'
    s.cycles.samples=72 if variant!='mac' else 12
    s.cycles.use_adaptive_sampling=True
    s.cycles.use_denoising=False
    s.cycles.adaptive_threshold=.014
    s.render.resolution_x=240;s.render.resolution_y=135;s.render.resolution_percentage=100
    s.render.film_transparent=False;s.render.image_settings.color_mode='RGB'
    s.render.image_settings.file_format='PNG'
    s.render.filepath=str(root/(path+'.png'))
    s.view_settings.view_transform='Standard'
    s.world=bpy.data.worlds.new('Stage ambient');s.world.use_nodes=True
    return s
def mat(n,c,rough=.4,met=0,glow=False):
    m=bpy.data.materials.new(n);m.diffuse_color=(*c,1);m.use_nodes=True
    nt=m.node_tree
    if glow:
        p=nt.nodes.new('ShaderNodeEmission');p.inputs[0].default_value=(*c,1);nt.links.new(p.outputs[0],nt.nodes['Material Output'].inputs['Surface'])
    else:
        p=nt.nodes.get('Principled BSDF');p.inputs['Base Color'].default_value=(*c,1);p.inputs['Roughness'].default_value=rough;p.inputs['Metallic'].default_value=met
    return m
def box(n,loc,size,m,b=.0):
    bpy.ops.mesh.primitive_cube_add(size=1,location=loc);o=bpy.context.object;o.name=n;o.dimensions=size
    bpy.ops.object.transform_apply(location=False,rotation=False,scale=True)
    o.data.materials.append(m)
    if b:
        v=o.modifiers.new('Soft edges','BEVEL');v.width=b;v.segments=3
        w=o.modifiers.new('Corner normals','WEIGHTED_NORMAL')
    return o
def lines(n,pts,r,m):
    cu=bpy.data.curves.new(n,'CURVE');cu.dimensions='3D';cu.bevel_depth=r;cu.bevel_resolution=5;cu.resolution_u=14
    s=cu.splines.new('BEZIER');s.bezier_points.add(len(pts)-1)
    for p,v in zip(s.bezier_points,pts):p.co=v;p.handle_left_type='AUTO';p.handle_right_type='AUTO'
    o=bpy.data.objects.new(n,cu);bpy.context.scene.collection.objects.link(o);cu.materials.append(m);return o
def cyl(n,x,y,z,r,d,m):
    bpy.ops.mesh.primitive_cylinder_add(vertices=40,radius=r,depth=d,location=(x,y,z));o=bpy.context.object;o.name=n;o.data.materials.append(m)
    for p in o.data.polygons:p.use_smooth=(len(p.vertices)==4)
    return o
def turn(o,p):o.rotation_euler=(Vector(p)-o.location).to_track_quat('-Z','Y').to_euler()
def spot(n,p,dst,power,color,size=3):
    d=bpy.data.lights.new(n,'AREA');d.energy=power;d.color=color;d.shape='DISK';d.size=size;o=bpy.data.objects.new(n,d);bpy.context.collection.objects.link(o);o.location=p;turn(o,dst)
def save(name):
    s=bpy.context.scene
    bpy.context.preferences.filepaths.save_version=0
    out=root/(name+'.blend')
    bpy.ops.wm.save_as_mainfile(filepath=str(out),compress=True)
    bpy.ops.wm.open_mainfile(filepath=str(out))
    bpy.context.scene.render.filepath=str(root/(name+'.png'))
    bpy.ops.render.render(write_still=True)
    sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
    (root/(name+'-validation.json')).write_text(json.dumps({'blend_sha256':sha(out),'png_sha256':sha(root/(name+'.png')),'resolution':[240,135],'format':'RGB8 opaque','engine':bpy.context.scene.render.engine,'no_actor_assets':True},indent=2)+'\n')
source=Path(sys.argv[sys.argv.index('--')+1]) if '--' in sys.argv and len(sys.argv)>sys.argv.index('--')+1 and '--draft' not in sys.argv[sys.argv.index('--')+1:sys.argv.index('--')+2] else next(p for p in (root.parent/'three-depth-look-revisions-20261120/pipe-hall/pipe-dream-open-hall.blend',root.parent/'pipe-hall/pipe-dream-open-hall.blend') if p.is_file())
bpy.ops.wm.open_mainfile(filepath=str(source));s=bpy.context.scene
# Local mesh construction avoids repeated evaluation of the inherited scene.
def direct(n,loc,verts,faces,m):
 d=bpy.data.meshes.new(n);d.from_pydata(verts,[],faces);d.update()
 o=bpy.data.objects.new(n,d);s.collection.objects.link(o);o.location=loc;d.materials.append(m)
 return o
def box(n,loc,size,m,b=0):
 x,y,z=(q/2 for q in size)
 return direct(n,loc,[(-x,-y,-z),(x,-y,-z),(x,y,-z),(-x,y,-z),(-x,-y,z),(x,-y,z),(x,y,z),(-x,y,z)],[(3,2,1,0),(4,5,6,7),(0,1,5,4),(1,2,6,5),(2,3,7,6),(3,0,4,7)],m)
def cyl(n,x,y,z,r,d,m):
 k=40
 verts=[(r*math.cos(2*math.pi*j/k),r*math.sin(2*math.pi*j/k),sgn*d/2) for sgn in (-1,1) for j in range(k)]
 f=[tuple(reversed(range(k))),tuple(range(k,2*k))]+[(j,(j+1)%k,(j+1)%k+k,j+k) for j in range(k)]
 o=direct(n,(x,y,z),verts,f,m)
 for p in o.data.polygons:p.use_smooth=len(p.vertices)==4
 return o
roof=mat('Cool corrugated warehouse deck',(.051,.077,.107),.58,.48)
girder=mat('Blue-gray galvanized industrial truss',(.19,.27,.33),.42,.57)
silver=mat('Silver zinc ventilation',(.31,.38,.43),.27,.73)
ring=mat('Dark duct couplings',(.094,.13,.17),.35,.63)
red=mat('Safety red sprinkler main',(.48,.038,.026),.32,.44)
glow=mat('Warehouse practical diffuser',(.38,.48,.49),glow=True)
def beam(n,a,b,w,h,m):
 a,b=Vector(a),Vector(b);o=box(n,(a+b)/2,(w,h,(b-a).length),m)
 o.rotation_euler=(b-a).to_track_quat('Z','Y').to_euler();return o
def tubing(n,a,b,r,m):
 a,b=Vector(a),Vector(b);v=b-a;o=cyl(n,*(tuple((a+b)/2)),r,v.length,m)
 o.rotation_euler=v.to_track_quat('Z','Y').to_euler();return o
# Tall, sparse ribwork; the vertical free space above the instruments remains open.
box('Warehouse upper deck', (0,56,9.3),(27,112,.22),roof)
for x in (-11,-8,-5,-2,2,5,8,11):beam('Longitudinal steel roof purlin',(x,4,8.94),(x,105,8.94),.145,.17,girder)
for y in (10,19,28,37,46,55,64,73,82,91,100):
 for z in (8.1,8.83):beam('Open lattice lateral truss chord',(-13,y,z),(13,y,z),.12,.12,girder)
 for j in range(13):
  x=-13+j*2
  up=j%2==0
  beam('Galvanized web diagonal',(x,y,8.1 if up else 8.83),(x+2,y,8.83 if up else 8.1),.092,.092,girder)
 for x in (-10.8,10.8):
  beam('Sparse distant perimeter post',(x,y,.1),(x,y,8.75),.16,.21,girder)
 if y>=19:
  for x in (-4.5,4.5):
   beam('Warehouse hanging drop',(x,y,8.81),(x,y,7.76),.028,.028,ring)
   cyl('Industrial pendant shade',x,y,7.75,.31,.16,girder)
   cyl('Pendant lit circular lens',x,y,7.66,.23,.032,glow)
for x,z,r in ((-4.0,7.65,.57),(4.30,7.89,.51)):
 tubing('Silver spiral high-volume HVAC main',(x,6,z),(x,104,z),r,silver)
 for y in range(13,105,5):
  tubing('Circumferential galvanized duct seam',(x,y,z),(x,y+.12,z),r+.035,ring)
 for y in range(16,102,14):
  tubing('Exposed short branch from HVAC',(x,y,z),(x+math.copysign(2.8,x),y,z),r*.44,silver)
  beam('Duct suspension strap',(x,y,z),(x,y,8.9),.036,.046,girder)
for x,z in ((-2.28,8.54),(7.48,8.42),(-7.9,8.47)):
 tubing('Exposed red sprinkler / narrow supply line',(x,5,z),(x,104,z),.069,red)
 for y in range(13,100,9):
  tubing('Red conduit tee',(x,y,z),(x+.67,y,z),.062,red)
# Light from practical uplights, not a bright roof in the halo lane.
for y in (19,32,49,65,83):
 spot('Cool ceiling bounce',(-4.8,y,5.4),(-3.5,y+3,8.9),490*(1 if y<36 else .76),(.52,.71,1),4.8)
 spot('Muted warm metal bounce',(5.4,y+3,5.7),(3.6,y,8.9),330,(1,.70,.48),4.2)
s['scope']='Open-ended instrument aisle beneath high warehouse roof; fixed eye-level camera unchanged. No rear wall.'
s.render.filepath='//pipe-dream-warehouse.png'
if '--draft' in sys.argv:
 s.cycles.samples=48;s.render.filepath=str(root/'draft.png');bpy.ops.render.render(write_still=True)
else:save('pipe-dream-warehouse')
