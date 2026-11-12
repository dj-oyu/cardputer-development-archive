import bpy, math, pathlib, sys
from mathutils import Vector
OUT = pathlib.Path(sys.argv[sys.argv.index('--')+1]).resolve()
OUT.mkdir(parents=True, exist_ok=False)
bpy.ops.wm.read_factory_settings(use_empty=True)
def material(name, color):
    m=bpy.data.materials.new(name); m.diffuse_color=(*color,1); m.use_nodes=True
    p=m.node_tree.nodes.get('Principled BSDF'); p.inputs['Base Color'].default_value=(*color,1)
    p.inputs['Metallic'].default_value=0; p.inputs['Roughness'].default_value=1
    m.use_backface_culling=True
    return m
skin=material('skin',(0.46,0.22,0.08)); white=material('muzzle',(0.8,0.7,0.48))
eye=material('eye',(0.035,0.11,0.16)); dark=material('mouth',(0.012,0.006,0.004))
def sphere(name, location, scale, mat, segments=8, rings=4):
    bpy.ops.mesh.primitive_uv_sphere_add(segments=segments, ring_count=rings, location=location)
    o=bpy.context.object; o.name=name; o.scale=scale
    bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)
    if mat: o.data.materials.append(mat)
    for p in o.data.polygons: p.use_smooth=True
    o['part_id']=name
    return o
def box(name, location, scale, mat):
    bpy.ops.mesh.primitive_cube_add(size=2, location=location)
    o=bpy.context.object; o.name=name; o.scale=scale
    bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)
    o.data.materials.append(mat)
    for p in o.data.polygons: p.use_smooth=True
    o['part_id']=name
    return o
head=sphere('head',(0,0,0),(1,.61,1.05),skin,12,6)
for x in [-.43,.43]:
    cutter=sphere('socket_cutter',(x,-.60,.25),(.33,.30,.29),None)
    bpy.context.view_layer.objects.active=head
    mod=head.modifiers.new('recessed_eye_socket','BOOLEAN');mod.operation='DIFFERENCE';mod.object=cutter;mod.solver='EXACT'
    bpy.ops.object.modifier_apply(modifier=mod.name)
    bpy.data.objects.remove(cutter,do_unlink=True)
for side,x in [('L',-.43),('R',.43)]:
    sphere('eye_'+side,(x,-.49,.25),(.235,.21,.225),eye)
    lid=box('lid_'+side,(x,-.705,.46),(.245,.025,.035),skin)
    lid.shape_key_add(name='Basis'); key=lid.shape_key_add(name='blink')
    # An authored eyelid target: lower edge travels down over the eye.
    for v in key.data:
        if v.co.z<0: v.co.z-=.41
    key.slider_min=0;key.slider_max=1
sphere('upper_muzzle',(0,-.62,-.27),(.52,.37,.25),white)
box('mouth_cavity',(0,-.57,-.48),(.32,.11,.18),dark)
jaw=box('lower_jaw',(0,-.67,-.51),(.36,.18,.075),white)
jaw.shape_key_add(name='Basis'); key=jaw.shape_key_add(name='jawOpen')
for v in key.data: v.co.z-=.24; v.co.y+=.02
key.slider_min=0;key.slider_max=1
bpy.context.scene['purpose']='minimal authoring workflow probe; not fox artwork or product asset'
bpy.context.scene['front']='Blender -Y; +Z up'
bpy.ops.wm.save_as_mainfile(filepath=str(OUT/'before.blend'))
