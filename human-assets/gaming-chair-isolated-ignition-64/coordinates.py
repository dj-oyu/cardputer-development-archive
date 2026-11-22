import bpy,math
from mathutils import Vector
from bpy_extras.object_utils import world_to_camera_view
s=bpy.context.scene;c=s.camera
for yaw in (-35,0,35):
 a=math.radians(180+yaw);c.location=(12*math.sin(a),-12*math.cos(a),3.70)
 c.rotation_euler=(Vector((0,0,2.16))-c.location).to_track_quat('-Z','Y').to_euler();bpy.context.view_layer.update()
 print('POS',yaw,*[(round(q.x*240,3),round((1-q.y)*135,3)) for q in [world_to_camera_view(s,c,o.location) for o in sorted(s.objects,key=lambda o:o.name) if o.name.startswith('Hidden area pulse')]])
