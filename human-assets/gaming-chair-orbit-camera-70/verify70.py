"""Reopen saved v70, test stored seat playback and independent camera inputs."""
import bpy, math, json, os
from pathlib import Path
from mathutils import Vector
P=Path(__file__).resolve().parent
s=bpy.context.scene;cam=s.camera
c=next(o for o in s.objects if o.name.startswith('CAM CONTROLS'))
t=next(o for o in s.objects if o.name.startswith('CAM TARGET'))
up=next(o for o in s.objects if o.name.startswith('Engine chair'))
stand=next(o for o in s.objects if 'stationary 26' in o.name)
arm=next(o for o in s.objects if o.type=='ARMATURE')
assert cam.parent.parent.parent==t and stand.animation_data is None
def current(obj):return obj.evaluated_get(bpy.context.evaluated_depsgraph_get())
def base(obj):
 e=current(obj);return [e.matrix_world@v.co for v in e.data.vertices]
def angle(obj):
 w=current(obj).matrix_world;return math.degrees(math.atan2(w[1][0],w[0][0]))
bpy.context.view_layer.update();stand_ref=base(stand)
ref_feet={x:current(arm).pose.bones[f'foot.{x}'].head.copy() for x in ('L','R')}
def check(f,yaw,pitch):
 c['yaw_deg']=float(yaw);c['pitch_deg']=float(pitch);c.update_tag()
 s.frame_set(f);bpy.context.view_layer.update()
 C=current(cam);T=current(t);dr=(T.matrix_world.translation-C.matrix_world.translation).normalized()
 forward=C.matrix_world.to_3x3()@Vector((0,0,-1))
 yr=math.degrees(math.atan2(-(C.matrix_world.translation-T.matrix_world.translation).x,(C.matrix_world.translation-T.matrix_world.translation).y))
 p=(C.matrix_world.translation-T.matrix_world.translation)
 pr=math.degrees(math.atan2(p.z,math.hypot(p.x,p.y)))
 xa=35*math.cos(math.tau*(f-1)/48);ya=angle(up)
 stand_error=max((a-b).length for a,b in zip(stand_ref,base(stand)))
 foot={x:(current(arm).pose.bones[f'foot.{x}'].head-ref_feet[x]).length for x in ref_feet}
 score=dr.dot(forward)
 data={'frame':f,'requested_camera_yaw_deg':yaw,'camera_yaw_deg':yr,'requested_pitch_deg':pitch,'camera_pitch_deg':pr,'stored_seat_yaw_deg':ya,'stationary_base_max_vertices_drift':stand_error,'look_at_alignment':score,'feet_drift_blender_units':foot}
 assert abs(yr-yaw)<.02 and abs(pr-pitch)<.02 and abs(xa-ya)<.02 and stand_error<1e-8 and score>.99999,data
 assert max(foot.values())<.0015,data
 return data
s.render.engine='CYCLES';s.cycles.samples=32;s.cycles.seed=177;s.cycles.use_denoising=False
s.render.resolution_x=240;s.render.resolution_y=135;s.render.resolution_percentage=100;s.render.film_transparent=False
for o in s.objects:
 if o.type=='LIGHT' or 'floor' in o.name.lower():o.hide_render=True
def light(loc, power, size):
 d=bpy.data.lights.new('Studio fill','AREA');d.energy=power;d.shape='DISK';d.size=size
 ob=bpy.data.objects.new('Studio fill',d);s.collection.objects.link(ob);ob.location=loc
 ob.rotation_euler=(Vector((0,0,2))-ob.location).to_track_quat('-Z','Y').to_euler()
light((3,5,6),730,5);light((-4,4,5),410,4);light((0,-5,6),590,5)
s.world=bpy.data.worlds.new('Neutral Studio');s.world.use_nodes=True
s.world.node_tree.nodes['Background'].inputs[0].default_value=(.18,.18,.18,1)
s.world.node_tree.nodes['Background'].inputs[1].default_value=.70
tests=[('neutral',13,0,7.31),('upper_oblique',13,35,22),('low_front',13,145,-4),('swivel_a',1,-25,12),('swivel_b',25,-25,12),('same_seat_other_cam',25,35,-3),('cycle_end',49,0,7.31)]
stats={}
for name,f,y,p in tests:
 stats[name]=check(f,y,p)
 if name!='cycle_end':
  s.render.filepath=str(P/f'{name}.png');bpy.ops.render.render(write_still=True)
rec={'tests':stats,'near_clip':cam.data.clip_start,'display_actors_actions':[a.name for a in bpy.data.actions if 'seated' in a.name.lower() or '椅子' in a.name]}
(P/'camera-proof.json').write_text(json.dumps(rec,indent=2)+'\n')
print('RECORD',json.dumps(rec))
