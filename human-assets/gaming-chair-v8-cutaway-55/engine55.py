"""90-degree V8 cutaway; coherent slider-crank with original authored geometry, not ignition."""
import bpy, math, os, json
from pathlib import Path
from mathutils import Vector
P=Path(__file__).resolve().parent
bpy.ops.wm.read_factory_settings(use_empty=True)
s=bpy.context.scene;s.name='Virtual bay • 90-degree V8 cutaway (offline)'
def material(n,c,m=0,r=.4):
 a=bpy.data.materials.new(n);a.use_nodes=True
 b=a.node_tree.nodes['Principled BSDF'];b.inputs['Base Color'].default_value=(*c,1);b.inputs['Metallic'].default_value=m;b.inputs['Roughness'].default_value=r
 return a
case=material('Dark cast block',(.046,.065,.078),.48)
chrome=material('Piston crown • nickel',(.66,.72,.77),.68,.27)
mid=material('Cut edge • steel',(.24,.30,.33),.66,.34)
rodmat=material('Forged connecting rods',(.51,.28,.13),.72,.32)
groove=material('Piston ring • dark steel',(.043,.057,.072),.68,.42)
axle=material('Polished crank cheek',(.35,.45,.50),.62,.30)
def cyl(n,loc,r,d,axis,mat,N=20):
 bpy.ops.mesh.primitive_cylinder_add(vertices=N,radius=r,depth=d,location=loc)
 o=bpy.context.object;o.name=n;o.data.materials.append(mat);o.rotation_euler=Vector(axis).to_track_quat('Z','Y').to_euler()
 for f in o.data.polygons:f.use_smooth=(len(f.vertices)==4)
 return o
def oriented(o,a,b):
 a,b=Vector(a),Vector(b);o.location=(a+b)/2
 o.rotation_euler=(b-a).to_track_quat('Z','Y').to_euler()
def beam(n,loc,scale,ma):
 bpy.ops.mesh.primitive_cube_add(size=1,location=loc)
 o=bpy.context.object;o.name=n;o.scale=scale;o.data.materials.append(ma)
 return o
def sleeve(n,center,direction,r,d,ma):
 A=Vector(direction);B=Vector((0,1,0));C=A.cross(B)
 # Remove the broad camera-facing (+Y) strip; retain machined cut edges.
 arc=[math.radians(a) for a in range(63,298,18)]
 v=[center+A*h+(B*math.cos(a)+C*math.sin(a))*rr for rr,h in ((r,-d*.5),(r,d*.5),(r-.013,-d*.5),(r-.013,d*.5)) for a in arc]
 l=len(arc);f=[];mi=[]
 for j in range(l-1):
    for a,b in [(0,1),(2,3),(0,2),(1,3)]:f.append((a*l+j,a*l+j+1,b*l+j+1,b*l+j));mi.append(a+b>=2 and (a,b)!=(2,3))
 for j in (0,l-1):f.append((j,l+j,3*l+j,2*l+j));mi.append(True)
 m=bpy.data.meshes.new(n);m.from_pydata(v,[],f);m.update();m.materials.append(ma);m.materials.append(mid)
 for p,i in zip(m.polygons,mi):p.material_index=int(i)
 o=bpy.data.objects.new(n,m);s.collection.objects.link(o);return o
Z=2.514;X=-.015;ys=[.392,.216,.040,-.136]
r=.098;L=.291
D=[Vector((-2**-.5,0,2**-.5)),Vector((2**-.5,0,2**-.5))]
throws=(0,90,270,180)
cyl('Shared longitudinal main shaft',(X,.13,Z),.038,.72,(0,1,0),axle)
for b in (-1,1):
 beam('Cast support rail',(X+b*.239,.126,2.585),(.057,.73,.055),case)
functions=[]
for j,y in enumerate(ys):
 main=Vector((X,y,Z))
 crank=cyl(f'Throw {j+1} · common floating crankpin',main,.029,.104,(0,1,0),axle)
 cheeks=[]
 for k in (-1,1):
    cheek=beam(f'Throw {j+1} counterweight',main,(.105,.022,.055),axle)
    cheeks.append((k,cheek))
 stations=[]
 for b,axis in enumerate(D):
    cy=y+(.021 if b else -.021);zero=Vector((X,cy,Z))
    sleeve(f'Bank {b+1} / cylinder {j+1} • sectioned liner',zero+axis*.315,axis,.100,.280,case)
    piston=cyl(f'Bank {b+1} / crown {j+1}',zero,.068,.064,axis,chrome)
    band=cyl(f'Bank {b+1} / ring {j+1}',zero,.069,.014,axis,groove)
    pin=cyl(f'Bank {b+1} / wrist pin {j+1}',zero,.020,.036,(0,1,0),mid)
    rod=cyl(f'Bank {b+1} / rod {j+1}',zero,.020,L,(0,0,1),rodmat)
    stations.append((zero,axis,piston,band,pin,rod))
    add=None
 functions.append((main,crank,cheeks,stations))
def pose(t,key=False,fr=1):
 metrics=[]
 for j,(main,crank,cheeks,stations) in enumerate(functions):
    angle=t+math.radians(throws[j])
    delta=Vector((r*math.sin(angle),0,r*math.cos(angle)))
    crank.location=main+delta
    for k,c in cheeks:
       c.location=main+delta*.42+Vector((0,k*.060,0));c.rotation_euler.y=angle
    for zero,A,pist,band,pin,rod in stations:
       along=delta.dot(A); off=delta-along*A
       arm=along+math.sqrt(L*L-off.length_squared)
       foot=zero+delta;head=zero+arm*A
       pin.location=head;pist.location=head+A*.045;band.location=head+A*.027;oriented(rod,foot,head)
       metrics.append({'crown':pist.name,'axis':list(A),'pos':list(pist.location),'rod_length':(head-foot).length})
    if key:
       for o in [crank,*[o for _,o in cheeks],*[x for station in stations for x in station[2:]]]:
         o.keyframe_insert('location',frame=fr);o.keyframe_insert('rotation_euler',frame=fr)
 return metrics
for fr in range(1,122):pose((fr-1)*math.tau/120,key=True,fr=fr)
s.frame_start=1;s.frame_end=120
for mat in bpy.data.materials:pass
# Pointed light keeps gold rods and bright crowns readable at view size.
def area(name,loc,power,col,size):
 d=bpy.data.lights.new(name,'AREA');d.energy=power;d.size=size;d.color=col
 o=bpy.data.objects.new(name,d);s.collection.objects.link(o);o.location=loc
 o.rotation_euler=(Vector((X,.15,2.65))-o.location).to_track_quat('-Z','Y').to_euler()
area('Broad edge / nickel',(1.0,1.90,3.18),147,(.88,.93,1),1.35)
area('Warm base left',(-.66,1.08,2.67),52,(1,.80,.57),.55)
area('Low balance',(.1,.59,1.96),20,(.77,.85,1),.5)
s.world=bpy.data.worlds.new('Dim bay');s.world.use_nodes=True;s.world.node_tree.nodes['Background'].inputs[1].default_value=.14
bpy.ops.object.camera_add();c=s.camera=bpy.context.object;c.data.lens=50
s.render.engine='CYCLES';s.cycles.use_denoising=False;s.cycles.samples=int(os.getenv('SAMPLES','32'));s.cycles.seed=177
s.render.film_transparent=True;s.render.image_settings.color_mode='RGBA'
w=int(os.getenv('WIDTH','240'));s.render.resolution_x=w;s.render.resolution_y=w*9//16;s.render.resolution_percentage=100
s['geometry']='Two banks of 4, axes ±45°, four throws on one longitudinal shaft, coherent slider crank. Stylized cutaway only.'
pose_metrics={}
for yaw in map(int,os.getenv('YAW','-35,0,35').split(',')):
 a=math.radians(180+yaw);c.location=(12*math.sin(a),-12*math.cos(a),3.70);c.rotation_euler=(Vector((0,0,2.16))-c.location).to_track_quat('-Z','Y').to_euler()
 f=P/('engine-native' if w==240 else 'engine-detail')/f'rear_{yaw:+03}';f.mkdir(parents=True,exist_ok=True)
 for ph in map(int,os.getenv('PHASE','0,1,2,3,4,5').split(',')):
    s.frame_set(1+20*ph);pose_metrics[str(ph)]=pose(ph*math.tau/6)
    s.render.filepath=str(f/f'{ph}.png');bpy.ops.render.render(write_still=True)
if w==240:
 s.frame_set(1);c.location=(0,12,3.70);c.rotation_euler=(Vector((0,0,2.16))-c.location).to_track_quat('-Z','Y').to_euler()
 bpy.context.preferences.filepaths.save_version=0;bpy.ops.wm.save_as_mainfile(filepath=str(P/'virtual-cutaway-v8-55.blend'),compress=True)
 (P/'kinematics.json').write_text(json.dumps(pose_metrics,indent=2)+'\n')
