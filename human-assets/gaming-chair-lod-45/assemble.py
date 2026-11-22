"""Append the independent chair to a seated character, keeping its materials and objects editable."""
import bpy,sys,re,hashlib,json
from pathlib import Path
human,chair,out = map(Path,sys.argv[-3:])
bpy.ops.wm.open_mainfile(filepath=str(human.resolve()), use_scripts=False)
s=bpy.context.scene
with bpy.data.libraries.load(str(chair.resolve()),link=False) as (src,dst):
    names=[n for n in src.collections if n.lower().replace('_',' ').replace('-',' ').startswith('gaming chair')]
    assert len(names)==1,(names,src.collections)
    dst.collections=names
c=dst.collections[0]
assert c and c.all_objects and all(o.type in ('MESH','EMPTY') for o in c.all_objects)
s.collection.children.link(c)
s.frame_set(1); bpy.context.view_layer.update()
dg=bpy.context.evaluated_depsgraph_get()
def count(oo):
    result={}
    for o in oo:
        if o.type!='MESH' or o.hide_render or o.name.startswith('Preview floor'):continue
        e=o.evaluated_get(dg);m=e.to_mesh();m.calc_loop_triangles()
        result[o.name]=len(m.loop_triangles)
        e.to_mesh_clear()
    return result
ch=count(c.all_objects);hu={k:v for k,v in count(s.objects).items() if k not in ch}
assert ch and hu and max(ch.values())>0
p=out.with_suffix('.json')
p.write_text(json.dumps({'human_sha256':hashlib.sha256(human.read_bytes()).hexdigest(),'chair_sha256':hashlib.sha256(chair.read_bytes()).hexdigest(),'human_triangles':sum(hu.values()),'chair_triangles':sum(ch.values()),'combined_triangles':sum(hu.values())+sum(ch.values()),'by_human_object':hu,'by_chair_object':ch,'pose_frame':s.frame_current,'counts':'Evaluated active meshes; excludes preview floor and render-hidden objects; Blender source only'},indent=2)+'\n')
bpy.context.preferences.filepaths.save_version=0
bpy.ops.wm.save_as_mainfile(filepath=str(out.resolve()),compress=True)
