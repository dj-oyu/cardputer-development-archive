"""blender -b expression.blend -t 2 --python add_fox_emotes.py -- --fox-source fox.blend --output merged.blend [--review-dir directory]"""
import argparse, hashlib, json, sys
from pathlib import Path
import bpy
from mathutils import Vector, Matrix
SRC_SHA='d3edde66f2c538388f544989fe16bc60c2d391fc519000bfa1ed9e49c6295d22'
SRC_COMMIT='ba71ff28339200212297bef5fb4e98b385c2c5e2'
NAMES=['Manga sweat','Manga confusion','Manga anger']
GROUP='Cloud • fox-derived manga overlays'
p=argparse.ArgumentParser()
p.add_argument('--fox-source',required=True,type=Path);p.add_argument('--output',required=True,type=Path)
p.add_argument('--review-dir',type=Path); a=p.parse_args(sys.argv[sys.argv.index('--')+1:])
a.output=a.output.resolve(); input_path=Path(bpy.data.filepath).resolve()
if a.output.exists() or not bpy.data.filepath or GROUP in bpy.data.collections or a.output.suffix!='.blend':
    raise ValueError('Open a clean base and choose a fresh .blend output')
if hashlib.sha256(a.fox_source.read_bytes()).hexdigest()!=SRC_SHA: raise ValueError('Fox source checksum mismatch')
s=bpy.context.scene; cam=s.camera
if not cam or cam.data.type!='ORTHO': raise ValueError('Requires active orthographic camera')
s.frame_set(s.frame_start); frame0=s.frame_current
def camera_rect():
    field=cam.data.view_frame(scene=s)
    return min(v.x for v in field), max(v.x for v in field), min(v.y for v in field), max(v.y for v in field)
cr=camera_rect(); cw=cam.matrix_world.copy()
def box(vs):
    pts=list(vs)
    return (min(v[0] for v in pts),max(v[0] for v in pts),min(v[1] for v in pts),max(v[1] for v in pts))
def px(v):
    return ((v.x-cr[0])*240/(cr[1]-cr[0]),(v.y-cr[2])*135/(cr[3]-cr[2]))
def sep(a,b):
    return max(b[0]-a[1], a[0]-b[1], b[2]-a[3], a[2]-b[3])
objs=[o for o in s.objects if o.type in {'MESH','CURVE','SURFACE','FONT'} and not o.hide_render and o.name.lower()!='stage']
if not any(o.name=='Cloud body' for o in objs): raise ValueError('Cloud body not found')
obstacles={}
for f in range(s.frame_start,s.frame_end+1):
    s.frame_set(f); dg=bpy.context.evaluated_depsgraph_get()
    if camera_rect()!=cr or cw!=cam.matrix_world: raise ValueError('Requires stationary review camera')
    for o in objs:
        e=o.evaluated_get(dg); m=e.to_mesh()
        if m:
            xform=cw.inverted()@e.matrix_world
            if len(m.vertices): obstacles.setdefault(o.name,[]).append(box(px(xform@v.co) for v in m.vertices))
            e.to_mesh_clear()
s.frame_set(frame0)
candidates=[(x,y) for x in (184,188,192,196,200,204,180,208) for y in (97,101,93,105,89,109,113)]
def margins(x,y):
    marker=(x-12,x+12,y-12,y+12)
    return {key:min(sep(marker,b) for b in boxes) for key,boxes in obstacles.items()}
anchor=next(((x,y) for x,y in candidates if min(margins(x,y).values())>=6),None)
if anchor is None: raise ValueError('No safe upper-right position; widen camera or lower overlay size')
cat=bpy.data.collections.new(GROUP);s.collection.children.link(cat)
ctl=bpy.data.objects.new('Cloud emote controls',None);cat.objects.link(ctl)
for key in ('sweat','confusion','anger'):
    ctl[key]=0.0;ctl.id_properties_ui(key).update(min=0.0,max=1.0,description='Active at 0.5; one at a time (anger > confusion > sweat)')
with bpy.data.libraries.load(str(a.fox_source.resolve())) as (fr,to):
    if not set(NAMES).issubset(fr.objects): raise ValueError('Missing frozen fox overlays')
    to.objects=list(NAMES)
counts={}; scales={}
for index,src in enumerate(to.objects,1):
    mesh=src.data.copy()
    name=NAMES[index-1].replace('Manga ','Cloud emote • ')
    mesh.name=name
    # Copy unchanged geometry/topology apart from centering; no fox animation or transforms imported.
    bounds=box((v.co.x,v.co.z) for v in mesh.vertices)
    cx=(bounds[0]+bounds[1])*0.5; cy=(bounds[2]+bounds[3])*0.5
    for v in mesh.vertices: v.co-=Vector((cx,0,cy))
    mesh.calc_loop_triangles();counts[name]=len(mesh.loop_triangles)
    o=bpy.data.objects.new(name,mesh);cat.objects.link(o);o.parent=cam
    o.location=(cr[0]+anchor[0]*(cr[1]-cr[0])/240,cr[2]+anchor[1]*(cr[3]-cr[2])/135,-max(cam.data.clip_start+.1,3))
    o.rotation_euler=Matrix(((1,0,0),(0,0,1),(0,-1,0))).to_euler()
    scale=23*(cr[1]-cr[0])/240/max(bounds[1]-bounds[0],bounds[3]-bounds[2]);scales[name]=scale
    for axis in (0,1,2,None):
        driver=(o.driver_add('scale',axis) if axis is not None else o.driver_add('hide_render')).driver
        for k in ('sweat','confusion','anger'):
            v=driver.variables.new();v.name=k;v.type='SINGLE_PROP'
            v.targets[0].id=ctl;v.targets[0].data_path=f'["{k}"]'
        test=('sweat >= .5 and confusion < .5 and anger < .5',
              'confusion >= .5 and anger < .5', 'anger >= .5')[index-1]
        driver.expression=f'{scale:.10g} if {test} else 0' if axis is not None else f'not ({test})'
    bpy.data.objects.remove(src)
a.output.parent.mkdir(parents=True,exist_ok=True)
bpy.ops.wm.save_as_mainfile(filepath=str(a.output))
if a.review_dir:
    a.review_dir.mkdir(parents=True,exist_ok=True)
    r=s.render; r.resolution_x=240;r.resolution_y=135;r.resolution_percentage=100
    if s.render.engine=='CYCLES': s.cycles.samples=10
    r.image_settings.file_format='PNG'
    for index,name in enumerate(['off','sweat','confusion','anger']):
        for k in ('sweat','confusion','anger'): ctl[k]=float(k==name)
        ctl.update_tag(); s.frame_set(frame0);bpy.context.view_layer.update()
        dg=bpy.context.evaluated_depsgraph_get()
        actual=[o.name for o in cat.objects if o.type=='MESH' and not o.evaluated_get(dg).hide_render and o.evaluated_get(dg).scale.x>0]
        if actual!=([f'Cloud emote • {name}'] if index else []): raise RuntimeError(f'Unexpected selector state {index}: {actual}')
        r.filepath=str(a.review_dir.resolve()/f'{name}.png');bpy.ops.render.render(write_still=True)
report={'frozen_fox_commit':SRC_COMMIT,'frozen_fox_sha256':SRC_SHA,'input_sha256':hashlib.sha256(input_path.read_bytes()).hexdigest(),'output_sha256':hashlib.sha256(a.output.read_bytes()).hexdigest(),'verified_frame_range':[s.frame_start,s.frame_end], 'resolution':[240,135], 'center_px_lower_left':anchor, 'maximum_dimensions_px':23,'min_screen_clearance_px':{k:round(v,3) for k,v in margins(*anchor).items()},'per_symbol_triangles':counts,'inactive_visible_triangles':0,'stored_triangles':sum(counts.values()),'budget_note':'Additive camera-facing overlay. One active symbol, no firmware or real performance test.'}
a.output.with_suffix('.json').write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps(report,indent=2))
