"""Reopen a saved Blend, verify toggles across animation, and render native LCD tests."""
import argparse, json, sys
from pathlib import Path
import bpy
from mathutils import Vector
from bpy_extras.object_utils import world_to_camera_view
p=argparse.ArgumentParser()
p.add_argument('--out',type=Path,required=True)
p.add_argument('--full',action='store_true')
a=p.parse_args(sys.argv[sys.argv.index('--')+1:])
a.out.mkdir(parents=True,exist_ok=True)
s=bpy.context.scene
rig=next(o for o in s.objects if o.type=='ARMATURE')
ctrl=next(o for o in s.objects if o.name.startswith('CAM CONTROLS'))
cam=s.camera
s.render.resolution_x=240;s.render.resolution_y=135;s.render.resolution_percentage=100
s.render.film_transparent=False
s.render.image_settings.file_format='PNG'
s.render.image_settings.color_mode='RGB'
s.render.engine='CYCLES';s.cycles.samples=14;s.cycles.seed=178;s.cycles.use_denoising=False
s.cycles.use_adaptive_sampling=False
for o in s.objects:
    if o.type=='LIGHT' or 'floor' in o.name.lower():o.hide_render=True
for x,power,radius in [((3,5,6),730,5),((-4,4,5),410,4),((0,-5,6),590,5)]:
    d=bpy.data.lights.new('review area','AREA');d.energy=power;d.shape='DISK';d.size=radius
    o=bpy.data.objects.new('review area',d);s.collection.objects.link(o);o.location=x
    o.rotation_euler=(Vector((0,0,2))-o.location).to_track_quat('-Z','Y').to_euler()
s.world=bpy.data.worlds.new('Review studio');s.world.use_nodes=True
s.world.node_tree.nodes['Background'].inputs[0].default_value=(.18,.18,.18,1)
s.world.node_tree.nodes['Background'].inputs[1].default_value=.70
levels=['off','sweat','confusion','anger']; measures=[]
syms=[o for o in s.objects if o.name.startswith('Comic emote • ')]
assert len(syms)==3
assert rig['Comic Emote']==0
for view,yaw,pitch in [('front',180,9),('quarter',145,10),('side',90,7.31),('back',0,7.31)]:
    ctrl['yaw_deg']=float(yaw);ctrl['pitch_deg']=float(pitch);ctrl.update_tag()
    for frame in [1,12,25,49]:
        for i,name in enumerate(levels):
            rig['Comic Emote']=i
            if 'Face Expression' in rig: rig['Face Expression']=0
            rig.update_tag();s.frame_set(frame);bpy.context.view_layer.update()
            dg=bpy.context.evaluated_depsgraph_get()
            active=[o.evaluated_get(dg) for o in syms if not o.evaluated_get(dg).hide_render and o.evaluated_get(dg).scale.x>0]
            assert [o.name for o in active] == (['Comic emote • '+name] if i else []), (frame, i, [o.name for o in active])
            if active:
                o=active[0]
                pts=[world_to_camera_view(s,cam,o.matrix_world@v.co) for v in o.data.vertices]
                x=[uv.x*240 for uv in pts];y=[uv.y*135 for uv in pts]
                assert 5<min(x)<max(x)<235 and 5<min(y)<max(y)<130
                measures.append([view,frame,name,*map(lambda q: round(q,3),(min(x),min(y),max(x),max(y)))])
            if frame!=25 or view not in ('front','quarter'): continue
            if a.full and 'Face Expression' in rig: rig['Face Expression']={0:0,1:1,2:2,3:4}[i]
            rig.update_tag();s.frame_set(frame);bpy.context.view_layer.update()
            s.render.filepath=str(a.out/f'{view}-{name}.png')
            bpy.ops.render.render(write_still=True)
(a.out/'emote-bounds.json').write_text(json.dumps(measures,indent=2)+'\n')
