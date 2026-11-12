import bpy,json
from mathutils import Vector
from mathutils.bvhtree import BVHTree
from pathlib import Path
R=Path('/workspace/scratch/6d8dcdbcdc54');cfg=json.loads((R/'fox-reference-uncertainty-v3/input/config.json').read_text());v=next(x for x in cfg['cameras'] if x['name']=='oblique');V=(Vector(v['blenderLocation'])-Vector(v['blenderTarget'])).normalized();find=json.loads((R/'fox-v16-black-pixel-diagnostic/findings.json').read_text());pts=[p for p in find['points'] if p['q'] in [[118,99],[147,98]]]
bpy.ops.wm.open_mainfile(filepath=cfg['source']);dep=bpy.context.evaluated_depsgraph_get();trees=[]
for o in bpy.context.scene.objects:
 if o.hide_render or o.type not in ['MESH','CURVE']:continue
 ev=o.evaluated_get(dep);m=ev.to_mesh();verts=[ev.matrix_world@x.co for x in m.vertices];polys=[list(p.vertices) for p in m.polygons];tree=BVHTree.FromPolygons(verts,polys,all_triangles=False);trees.append((o.name,tree));ev.to_mesh_clear()
out=[]
for p in pts:
 point=Vector(p['lastWinner'][4:7]);origin=point+V*20;hits=[]
 for name,t in trees:
  loc,n,face,d=t.ray_cast(origin,-V,40)
  if loc is not None:hits.append({'name':name,'distance':d,'position':list(loc),'normal':list(n),'face':face,'signedAheadOfNative':20-d})
 hits.sort(key=lambda h:h['distance']);out.append({'q':p['q'],'nativePoint':list(point),'V':list(V),'hits':hits})
Path('/tmp/black-source-rays.json').write_text(json.dumps(out,indent=2));print(json.dumps(out,indent=2))
