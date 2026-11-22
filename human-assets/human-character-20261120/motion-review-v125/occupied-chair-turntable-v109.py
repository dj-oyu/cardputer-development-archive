"""Original v109 occupied chair; raised fixed camera, stationary base, optical loops."""
import bpy, json, math, os, hashlib
from pathlib import Path
from mathutils import Vector, Matrix
from bpy_extras.object_utils import world_to_camera_view
D=Path(__file__).resolve().parent
s=bpy.context.scene
src=Path(bpy.data.filepath); source_hash=hashlib.sha256(src.read_bytes()).hexdigest()
assert source_hash==os.environ['EXPECTED_BLEND_SHA256'],(src,source_hash)
s.frame_set(84)
bpy.context.view_layer.update()
upper=[next(x for x in s.objects if x.name.startswith(p)) for p in ('Engine chair','Rear aperture','Dash • boost','Dash • rear')]
base=next(x for x in s.objects if x.name.startswith('Chair • stationary'))
floor=s.objects.get('Preview floor only')
# f84 is frozen source seated endpoint; f13 is still standing. Bake the evaluated skin,
# then rotate the copies and original upper chair together, leaving the rig/feet controls
# and stationary chair base untouched. Material slots and UVs inherit the exact pose.
from mathutils.bvhtree import BVHTree
dg=bpy.context.evaluated_depsgraph_get()
visible_actor=[obj for obj in list(s.objects) if obj.type=='MESH' and obj not in (base,floor,*upper) and not obj.hide_render and not obj.name.startswith('Comic emote')]
assert len(visible_actor)==51,len(visible_actor)
actor=[]; bake_error=0.
for obj in visible_actor:
    ev=obj.evaluated_get(dg); m=ev.matrix_world.copy()
    mesh=bpy.data.meshes.new_from_object(ev,preserve_all_data_layers=True,depsgraph=dg)
    copy=bpy.data.objects.new('Frozen v100 seat pose / '+obj.name,mesh)
    s.collection.objects.link(copy);copy.matrix_world=m
    reference=ev.to_mesh()
    assert len(reference.vertices)==len(mesh.vertices),(obj.name,len(reference.vertices),len(mesh.vertices))
    if mesh.vertices:
        bake_error=max(bake_error,max(((m@a.co)-(copy.matrix_world@b.co)).length for a,b in zip(reference.vertices,mesh.vertices)))
    ev.to_mesh_clear()
    actor.append(copy)
assert bake_error<=2e-7,bake_error
allowed=(base,floor,*upper,*actor)
for obj in s.objects:
    if obj.type in {'MESH','CURVE','SURFACE','META','FONT','VOLUME','POINTCLOUD','GREASEPENCIL'}:
        obj.hide_render=obj not in allowed
    if obj.type=='LIGHT':obj.hide_render=True
def boxes(obj):return BVHTree.FromPolygons([obj.matrix_world@v.co for v in obj.data.vertices],[tuple(p.vertices) for p in obj.data.polygons],all_triangles=False)
bpy.context.view_layer.update()
chair_checks={o.name:{a.name:len(boxes(o).overlap(boxes(a))) for a in actor} for o in upper[:2]}
floor.hide_render=False
floor.location.z=.025
s.world=bpy.data.worlds.new('Chair turntable / neutral slate')
s.world.use_nodes=True
s.world.node_tree.nodes['Background'].inputs[0].default_value=(.18,.18,.18,1)
s.world.node_tree.nodes['Background'].inputs[1].default_value=.65
def studio_light(name,pos,power,size,color,focus=(0,0,1.65)):
    l=bpy.data.lights.new(name,type='AREA');l.energy=power;l.shape='DISK';l.size=size;l.color=color
    o=bpy.data.objects.new(name,l);s.collection.objects.link(o);o.location=pos
    o.rotation_euler=(Vector(focus)-o.location).to_track_quat('-Z','Y').to_euler()
studio_light('Broad warm key',(-3.8,4.5,6.5),890,4.5,(1,.91,.79))
studio_light('Cool rear fill',(4,4.0,4.0),480,4.5,(.72,.85,1))
studio_light('Front surface contour',(0,-4.5,6.0),900,4,(.87,.91,1))
s.render.engine='CYCLES';s.cycles.samples=int(os.environ.get('SAMPLES','12'));s.cycles.seed=55
s.cycles.use_adaptive_sampling=False;s.cycles.use_denoising=False
s.cycles.max_bounces=4;s.cycles.diffuse_bounces=2;s.cycles.glossy_bounces=2;s.cycles.transmission_bounces=2
s.render.use_persistent_data=True
s.render.fps=24;s.render.fps_base=1.0
s.render.resolution_x=240;s.render.resolution_y=135;s.render.resolution_percentage=100
s.render.film_transparent=False;s.render.image_settings.file_format='PNG';s.render.image_settings.color_mode='RGB'
s.view_settings.view_transform='AgX'
lens=bpy.data.cameras.new('Fixed rear demo / pitch 26°')
camera=bpy.data.objects.new('Fixed rear demo / pitch 26°',lens);s.collection.objects.link(camera)
s.camera=camera;lens.type='ORTHO';lens.ortho_scale=float(os.getenv('SCALE','9.70'))
target=Vector((0,0,float(os.getenv('AIM','1.855'))))
pitch=math.radians(26);rear_yaw=math.radians(-4)
camera.location=target+Vector((math.sin(rear_yaw)*math.cos(pitch),math.cos(rear_yaw)*math.cos(pitch),math.sin(pitch)))*12
camera.rotation_euler=(target-camera.location).to_track_quat('-Z','Y').to_euler()
pivot=Vector((0,0,.12));initial={obj:obj.matrix_world.copy() for obj in (*upper,*actor)}
static_base=base.matrix_world.copy()
node_tree=upper[1].data.materials[0].node_tree
act=node_tree.animation_data.action
tracks=[]
for name,num,period in [('Value',3,16),('Value.001',6,7),('Value.002',12,15)]:
    socket=node_tree.nodes[name].outputs[0]
    curve=act.fcurves.find(socket.path_from_id('default_value'))
    assert curve is not None and len(curve.modifiers)==1 and curve.modifiers[0].type=='CYCLES'
    values=[int(round(curve.evaluate(f))) for f in range(1,period+1)]
    assert set(values)==set(range(num)) and all(int(round(curve.evaluate(f+period)))==values[f-1] for f in range(1,period+1))
    tracks.append((socket,values))
node_tree.animation_data.action=None
N=276
S=54
E=246
part=int(os.environ.get('PART','0'))
count=int(os.environ.get('PARTS','1'))
only={int(i) for i in os.environ.get('ONLY','').split(',') if i}
out=D/os.environ.get('OUT','frames')
out.mkdir(exist_ok=True,parents=True)
rows=[]
def bounds(obj):
    projected=[world_to_camera_view(s,camera,obj.matrix_world@v.co) for v in obj.data.vertices]
    return [min(x.x for x in projected),max(x.x for x in projected),min(x.y for x in projected),max(x.y for x in projected)]
bounds_iter=[*upper,base,*actor]
for i in range(part,N,count):
    if only and i+1 not in only:continue
    q=min(1,max(0,(i-S)/(E-S)))
    # Brief ease into/out of the turn; the middle is nearly uniform angular speed.
    u=.80*q+.20*(q*q*(3-2*q))
    yaw=math.tau*u
    orient=Matrix.Translation(pivot)@Matrix.Rotation(yaw,4,'Z')@Matrix.Translation(-pivot)
    for obj,m in initial.items():obj.matrix_world=orient@m
    optical_tick=i*10//24
    phases=[]
    for node,vals in tracks:
        node.default_value=vals[optical_tick%len(vals)]
        phases.append(vals[optical_tick%len(vals)])
    bpy.context.view_layer.update()
    assert base.matrix_world==static_base
    b=[bounds(obj) for obj in bounds_iter]
    rect=[min(x[0] for x in b),max(x[1] for x in b),min(x[2] for x in b),max(x[3] for x in b)]
    if not os.environ.get('ALLOW_CROP'):assert rect[0]>.02 and rect[1]<.98 and rect[2]>.02 and rect[3]<.98,(i,rect)
    path=out/f'{i+1:04}.png'
    if not os.getenv('BOUNDS_ONLY') and (not os.getenv('RESUME') or not path.is_file()):
        s.render.filepath=str(path);bpy.ops.render.render(write_still=True)
    rows.append(dict(frame=i+1,yaw_deg=round(math.degrees(yaw),10),optical_tick=optical_tick,phases=phases,bounds=rect,base_fixed=True))
(out/f'proof-{part}.json').write_text(json.dumps(dict(sha=source_hash,pitch=26,fps=24,size=[240,135],seat_frame=84,bake_max_error=bake_error,checks=chair_checks,frames=rows),indent=2))
