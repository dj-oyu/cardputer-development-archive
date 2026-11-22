import bpy, math, hashlib, json
from pathlib import Path
from mathutils import Vector, Matrix
from mathutils.bvhtree import BVHTree
D=Path(__file__).resolve().parent
s=bpy.context.scene
sha=hashlib.sha256(Path(bpy.data.filepath).read_bytes()).hexdigest()
assert sha=='4816760351f82f9d8eaca76924022a4a225f1253e282183ba28bf4cea3ae96ed'
r=next(o for o in s.objects if o.type=='ARMATURE')
wa=s.objects['Waist and seat'];ch=next(o for o in s.objects if o.name.startswith('Engine chair'))
bpy.context.scene.render.fps=120;s.render.fps_base=1.
def up(f):
 s.frame_set(int(f),subframe=f-int(f));bpy.context.view_layer.update()
def geom(o):
 e=o.evaluated_get(bpy.context.evaluated_depsgraph_get());m=e.to_mesh();m.calc_loop_triangles()
 pts=[e.matrix_world@v.co for v in m.vertices]
 tri=[(tuple(t.vertices),m.polygons[t.polygon_index].material_index) for t in m.loop_triangles]
 e.to_mesh_clear();return pts,tri
avatar=[o for o in s.objects if o.type=='MESH' and (o.parent==r or any(m.type=='ARMATURE' and m.object==r for m in o.modifiers)) and not o.name.startswith('Comic emote')]
up(1);v=[q for o in avatar for q in geom(o)[0]];h=max(x.z for x in v)-min(x.z for x in v)
m_BU=1.60/h
g=9.80665; gu=g/m_BU
up(31.50)
cp,ct=geom(ch);wp,wt=geom(wa)
st=[p for p,m in ct if m==1 and min(cp[i].z for i in p)>1.10 and max(cp[i].z for i in p)<1.85]
tree=BVHTree.FromPolygons(cp,st,all_triangles=True); waist=BVHTree.FromPolygons(wp,[t for t,_ in wt],all_triangles=True)
hit=waist.overlap(tree)
assert len(hit)==2 and all({69,74}<=set(wt[i][0]) for i,j in hit)
seatz=cp[st[hit[0][1]][0]].z
t=(wp[74].z-seatz)/(wp[74].z-wp[69].z)
ref=wp[74].lerp(wp[69],t)
up(31.0)
p0=geom(wa)[0];wa0=p0[74].lerp(p0[69],t)
land_at=tree.ray_cast(Vector((wa0.x,wa0.y,wa0.z+1)),Vector((0,0,-1)),3)[0]
assert land_at and abs(land_at.z-seatz)<1e-5
radius=.125
lane=-1.37
zA=wa0.z+radius;zB=seatz+radius
rise=zA-zB;rt=math.sqrt(2*rise/gu)
release=37 # preceding 300 ms visual hold
arrival=release+rt*120
orig={b.name:b.matrix_basis.copy() for b in r.pose.bones}
poses={b.name:b.matrix.copy() for b in r.pose.bones}
a=r.animation_data.action;a.use_fake_user=True;r.animation_data.action=None
for n,x in orig.items():r.pose.bones[n].matrix_basis=x
bpy.context.view_layer.update()
def mat(n,color,em=.0):
 a=bpy.data.materials.new(n);a.diffuse_color=(*color,1);a.use_nodes=True
 q=a.node_tree.nodes.get('Principled BSDF')
 q.inputs['Base Color'].default_value=(*color,1)
 q.inputs['Metallic'].default_value=.15;q.inputs['Roughness'].default_value=.28
 q.inputs['Emission Color'].default_value=(*color,1);q.inputs['Emission Strength'].default_value=em
 return a
new=bpy.data.collections.new('Gravity study • lateral lane, same release height');s.collection.children.link(new)
def move(o):
 for c in list(o.users_collection):c.objects.unlink(o)
 new.objects.link(o);return o
bpy.ops.mesh.primitive_uv_sphere_add(segments=32,ring_count=16,radius=radius,location=(lane,wa0.y,zA))
ball=move(bpy.context.object);ball.name='Ball | analytical vertical free fall'
ball.data.materials.append(mat('Free-fall ball • warm yellow',(.91,.30,.015),.19))
for p in ball.data.polygons:p.use_smooth=True
ball['release height BU']=zA
ball['contact height BU']=zB
ball['standard g m/s²']=g
ball['meters per Blender unit']=m_BU
ball['release frame at 120fps']=release
ball['exact contact frame']=arrival
fc=ball.driver_add('location',2);dr=fc.driver;dr.type='SCRIPTED';dr.expression=f'max({zB:.12g},{zA:.12g} - {gu/2:.12g} * (max(0,frame-{release})/120.0)**2)'
def block(n,loc,sz,color):
 bpy.ops.mesh.primitive_cube_add(size=1,location=loc)
 o=move(bpy.context.object);o.name=n;o.dimensions=sz;o.data.materials.append(mat(n,color))
 return o
block('Catch pad • top at actual cushion height',(lane,wa0.y,seatz-.019),(.48,.46,.038),(.04,.33,.35))
# Non-physical stand only used to make the lateral catch position readable in the example.
block('Catch pad stand (illustration)',(lane,wa0.y,(seatz-.038+.2)/2),(.060,.060,seatz-.038-.2),(.14,.20,.22))
block('Catch pad base',(lane,wa0.y,.065),(.32,.31,.050),(.12,.16,.18))
ctrl=next(o for o in s.objects if o.name.startswith('CAM CONTROLS'))
aim=next(o for o in s.objects if o.name.startswith('CAM TARGET'))
s.camera.data.type='ORTHO';s.camera.data.ortho_scale=6.20
ctrl['yaw_deg']=133.;ctrl['pitch_deg']=8.;ctrl['distance']=12.5
aim.location.x=-.35;aim.location.y=-.59;aim.location.z=2.36
ctrl.update_tag()
s.frame_start=1;s.frame_end=115
for f,n in [(release,'Physical release t = 0'),(round(arrival),'Impact (exact subframe in ball properties)')]:
 s.timeline_markers.new(n,frame=f)
def err(m,n):return max(abs(a-b) for x,y in zip(m,n) for a,b in zip(x,y))
proof=[]
for f in [1,release,release+rt*120*.25,release+rt*120*.5,release+rt*120*.75,arrival,58,115]:
 up(f)
 z=max(zB,zA-gu/2*max(0,(f-release)/120)**2)
 got=ball.evaluated_get(bpy.context.evaluated_depsgraph_get()).location.z
 e=max(err(a,r.pose.bones[n].matrix) for n,a in poses.items())
 assert abs(got-z)<1e-5,(f,got,z)
 assert e<1e-5,(f,e)
 proof.append([f,z,got,e])
print('gravity proof',proof,flush=True)
s['Gravity study']='Independent ball-only problem. Avatar is frozen in exact v92 f31. The ball is offset in X only; same buttock-derived Y,Z. No character dynamics.'
s['Calibration']='Source displays metric at 1 m/BU but its adult is over 5 nominal metres tall. For physical example explicitly normalize exact standing geometry to a stylized 1.60 m height.'
s['Ball contact']='Constant g=9.80665 m/s² from rest, vertical only. Radius is included in contact and held afterward; no air drag, bounce or person motion.'
info={'source_sha256':sha,'source_freeze_frame':31,'source_waist_contact_frame':31.5,'source_contact_waist_vertex_edge':[74,69],'source_edge_parameter':t,'original_contact_vector':list(ref),'release_surface_vector':list(wa0),'ball_lane_x':lane,'ball_y':wa0.y,'ball_radius_BU':radius,'radius_m':radius*m_BU,'ball_center_start_z_BU':zA,'ball_center_contact_z_BU':zB,'cushion_z_BU':seatz,'fall_height_BU':rise,'fall_height_m':rise*m_BU,'model_height_BU':h,'assumed_standing_height_m':1.60,'metres_per_BU':m_BU,'g_m_per_s2':g,'g_BU_per_s2':gu,'time_s':rt,'release_frame':release,'contact_frame':arrival,'physical_blender_fps':120,'sampling_proof':[{'frame':f,'analytic_z':z,'Blender_z':e,'avatar_matrix_max_delta':u} for f,z,e,u in proof]}
(D/'ball-gravity-proof.json').write_text(json.dumps(info,indent=2))
up(release)
bpy.context.preferences.filepaths.save_version=0
bpy.ops.wm.save_as_mainfile(filepath=str(D/'butt-height-gravity-ball.blend'),compress=True)
