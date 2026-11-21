"""True swept virtual-bay tube, baked from matching cameras. No geometry in the physical chair."""
import math,bpy,os
from pathlib import Path
from mathutils import Vector
P=Path(__file__).resolve().parent
bpy.ops.wm.read_factory_settings(use_empty=True)
s=bpy.context.scene
def mat(n,c,m=0):
 a=bpy.data.materials.new(n);a.use_nodes=True
 b=a.node_tree.nodes.get('Principled BSDF');b.inputs['Base Color'].default_value=(*c,1);b.inputs['Metallic'].default_value=m;b.inputs['Roughness'].default_value=.39 if m else .48
 return a
rubber=mat('Graphite rubber',(0.036,.039,.043))
band=mat('Raised rubber ribs',(.050,.055,.062))
alloy=mat('Mount collar brushed metal',(.24,.20,.155),.70)
dark=mat('Deep mount sockets',(.043,.038,.031),.34)
seam=mat('Light retaining band',(.42,.34,.23),.76)
def pos(x,d,z): return Vector((x,.39+.285*(z-1.6)+.115-d,z))
knots=[pos(.535,.78,2.425),pos(.494,.55,2.428),pos(.451,.34,2.45),pos(.37,.20,2.49),pos(.19,.145,2.515),pos(.025,.146,2.51),pos(-.105,.165,2.464),pos(-.191,.215,2.374),pos(-.233,.36,2.311),pos(-.262,.56,2.294),pos(-.27,.75,2.30)]
def cat(a,b,c,d,t):
 return .5*((2*b)+(-a+c)*t+(2*a-5*b+4*c-d)*t*t+(-a+3*b-3*c+d)*t*t*t)
def pts():
 p=[knots[0]]+knots+[knots[-1]]
 return [cat(*p[i:i+4],j/14) for i in range(len(p)-3) for j in range(14)] + [knots[-1]]
verts=[];faces=[];mids=[]
def tube(name,pp,radii,skin,accent,N=20):
 verts=[];faces=[];ids=[]
 for i,(u,r) in enumerate(zip(pp,radii)):
    t=(pp[min(len(pp)-1,i+1)]-pp[max(0,i-1)]).normalized()
    n=Vector((0,0,1)).cross(t).normalized();b=t.cross(n)
    for k in range(N):
        a=k*math.tau/N;verts.append(u+r*(math.cos(a)*n+math.sin(a)*b))
 for i in range(len(pp)-1):
    for k in range(N):
       l=(k+1)%N;faces.append((i*N+l,i*N+k,(i+1)*N+k,(i+1)*N+l))
       ids.append(accent(i))
 faces.extend([tuple(range(N)),tuple(range((len(pp)-1)*N,len(pp)*N))[::-1]])
 ids.extend([0,0])
 me=bpy.data.meshes.new(name);me.from_pydata(verts,[],faces);me.update()
 for a in skin:me.materials.append(a)
 for p,i in zip(me.polygons,ids):p.material_index=i;p.use_smooth=(len(p.vertices)==4)
 o=bpy.data.objects.new(name,me);s.collection.objects.link(o);return o
p=pts()
dist=[0]
for a,b in zip(p,p[1:]):dist.append(dist[-1]+(a-b).length)
radius=[.075+.009*math.cos(k*.056)+.007*(.5+.5*math.cos(k*math.tau/.054))**5 for k in dist]
tube('Intake • one round continuous path through real depth',p,radius,[rubber,band],lambda i:int(math.cos(dist[i]*math.tau/.054)>.67))
for j,(idx,inn) in enumerate([(0,12),(-1,-13)]):
 origin=p[idx];t=(p[inn]-origin).normalized()
 # The end finishes behind the visible ring, in the solid body of a socket.
 rings=[-.17,-.068,-.065,-.023,-.020,.030,.033,.054]
 r=[.127,.127,.148,.148,.116,.116,.097,.095]
 tube(('Bay wall' if j==0 else 'Engine block')+' • anchored socket',
      [origin+t*d for d in rings],r,[dark,alloy,seam],lambda i:[0,0,1,1,0,2,2][i])
 # Bolt head hidden just behind dark mount; an asymmetric local anchor.
 bpy.ops.mesh.primitive_cube_add(size=1,location=origin-t*.11)
 o=bpy.context.object;o.name='Opaque mounting block supporting intake end';o.scale=(.22,.19,.24);o.data.materials.append(dark)
d=bpy.data.cameras.new('Match v50');cam=bpy.data.objects.new('Match v50',d);s.collection.objects.link(cam);s.camera=cam;d.lens=50
def light(loc,power,size):
 d=bpy.data.lights.new('Area','AREA');d.energy=power;d.size=size
 o=bpy.data.objects.new('Area',d);s.collection.objects.link(o);o.location=loc
 o.rotation_euler=(Vector((0,.0,2.43))-o.location).to_track_quat('-Z','Y').to_euler()
light((1.20,2.20,4.2),160,1.9);light((-1.07,.80,2.7),55,1.03)
s.world=bpy.data.worlds.new('Virtual soft cavity');s.world.use_nodes=True
s.world.node_tree.nodes['Background'].inputs[0].default_value=(.15,.17,.16,1);s.world.node_tree.nodes['Background'].inputs[1].default_value=.30
s.render.engine='CYCLES';s.cycles.samples=24;s.cycles.use_denoising=False;s.cycles.seed=177
s.render.film_transparent=True;s.render.image_settings.color_mode='RGBA'
size=int(os.getenv('WIDTH','240'));s.render.resolution_x=size;s.render.resolution_y=size*9//16;s.render.resolution_percentage=100
for yaw in map(int,os.getenv('YAW','-35,0,35').split(',')):
 a=math.radians(180+yaw);cam.location=(12*math.sin(a),-12*math.cos(a),3.70)
 cam.rotation_euler=(Vector((0,0,2.16))-cam.location).to_track_quat('-Z','Y').to_euler()
 dest=P/'assets'/f'rear_{yaw:+03d}';dest.mkdir(parents=True,exist_ok=True)
 s.render.filepath=str(dest/('tube.png' if size==240 else f'tube-{size}.png'))
 bpy.ops.render.render(write_still=True)
if size==240:
 s['purpose']='This separately editable scene is virtual volume only; use physical aperture mask from chair. Do not append into exterior.'
 s['tube_mount_length_BU']=(max(v.y for v in knots)-min(v.y for v in knots))
 bpy.context.preferences.filepaths.save_version=0
 bpy.ops.wm.save_as_mainfile(filepath=str(P/'virtual-tube-51.blend'),compress=True)
