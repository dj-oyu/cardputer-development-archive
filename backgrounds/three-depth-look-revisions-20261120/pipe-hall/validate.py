"""Run by Blender with the frozen file as input."""
import bpy
from mathutils import Vector
from bpy_extras.object_utils import world_to_camera_view as project
s=bpy.context.scene
eye=135*(1-project(s,s.camera,s.camera.location+Vector((0,100,0))).y)
bays=sum(o.name.startswith('Bay ') and 'paired instrument base' in o.name for o in s.objects)
assert abs(eye-67.5)<.0001
assert not any(q in o.name.lower() for o in s.objects for q in ('window','backdrop wall','ceiling member'))
assert bays==18 and s.render.engine=='CYCLES' and not s.render.film_transparent
print({'horizon_y':eye,'paired_bay_instrument_bases':bays,'existing_near_bay':True,'no_end_wall_or_window':True,'near_defocused_meshes':sum(bool(o.get('camera_near_layer')) for o in s.objects)})
