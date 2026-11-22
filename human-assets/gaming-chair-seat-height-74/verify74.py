import bpy,math,json
from mathutils import Vector
from mathutils.bvhtree import BVHTree
from pathlib import Path
P=Path(__file__).resolve().parent
def capture(collisions):
 s=bpy.context.scene
 sh=next(o for o in s.objects if o.name.startswith('Engine chair'))
 c=bpy.data.collections['Gaming Chair Prop'];upper=[o for o in c.objects if 'stationary 26' not in o.name]
 stand=next(o for o in c.objects if 'stationary 26' in o.name);rig=next(o for o in s.objects if o.type=='ARMATURE')
 ol=[o for o in s.objects if o.type=='MESH' and o.name.startswith(('Cream lug','Thigh to shin','Ochre ankle boot','Waist and seat'))]
 target=next(o for o in s.objects if o.name.startswith('CAM TARGET'));ctrl=next(o for o in s.objects if o.name.startswith('CAM CONTROLS'))
 portal=next(o for o in s.objects if o.name.startswith('Rear aperture'));n=portal.active_material.node_tree.nodes
 vals={a.label:a.outputs[0] for a in n if a.label.startswith('Live v71 /')}
 assert len(vals)==3
 def data(o):
  d=bpy.context.evaluated_depsgraph_get()
  e=o.evaluated_get(d);m=e.to_mesh()
  vs=[e.matrix_world@x.co for x in m.vertices];faces=[tuple(f.vertices) for f in m.polygons];e.to_mesh_clear();return vs,faces
 def bone(n):
  e=rig.evaluated_get(bpy.context.evaluated_depsgraph_get())
  return e.matrix_world@e.pose.bones[n].matrix
 def collection_state():
  return {o.name:o.matrix_world.copy() for o in upper}
 s.frame_set(13);bpy.context.view_layer.update()
 fixed=data(stand)[0];foot={o.name:data(o)[0] for o in ol if o.name.startswith('Cream lug')}
 rel={n:sh.matrix_world.inverted()@bone(n) for n in ('root','pelvis','spine','head')}
 neutral={n:bone(n) for n in ('root','pelvis',*[f'{n}.{side}' for n in ('thigh','shin','foot') for side in ('L','R')])}
 diff=lambda A,B:max(abs(A[k][l]-B[k][l]) for k in range(4) for l in range(4))
 rows={}
 for f in range(1,50):
  s.frame_set(f);bpy.context.view_layer.update()
  dev=max(diff(sh.matrix_world.inverted()@bone(n),M) for n,M in rel.items())
  sol=max((a-b).length for o in ol if o.name in foot for a,b in zip(foot[o.name],data(o)[0]))
  sta=max((a-b).length for a,b in zip(data(stand)[0],fixed))
  touch={}
  if collisions:
   tree=BVHTree.FromPolygons(*data(sh));bs=BVHTree.FromPolygons(*data(stand))
   for o in ol:
    a=BVHTree.FromPolygons(*data(o))
    overlap=len(tree.overlap(a));floor=len(bs.overlap(a))
    if overlap or floor:touch[o.name]=[overlap,floor]
  rows[f]={'seat_local_actor_error':dev,'sole_vertex_drift':sol,'stand_vertex_drift':sta,'contacts':touch,
           'optical_phases':{k:v.default_value for k,v in vals.items()},'upper':collection_state(),
           'camera':s.camera.matrix_world.copy()}
 return rows,fixed,neutral
src=P.parent/'chair-camera-bay-71'/'chair-camera-bay-v71.blend'
bpy.ops.wm.open_mainfile(filepath=str(src))
before,stand0,old=capture(True)
bpy.ops.wm.open_mainfile(filepath=str(P/'chair-seated-v74.blend'))
now,stand1,cur=capture(True)
p=.12;dx=[list(b-a) for a,b in zip(stand0,stand1)]
assert sum(abs(d[2])>.001 for d in dx)==2 and all(abs(d[0])+abs(d[1])<1e-9 and min(abs(d[2]),abs(d[2]-p))<1e-6 for d in dx)
T=__import__('mathutils').Matrix.Translation((0,0,p))
for f in now:
 a,b=before[f],now[f]
 assert a['optical_phases']==b['optical_phases'] and a['camera']==b['camera']
 for n,m in a['upper'].items():
  mm=b['upper'][n]
  assert max(abs((T@m)[i][j]-mm[i][j]) for i in range(4) for j in range(4))<1e-6,(f,n)
 assert b['seat_local_actor_error']<1e-5 and b['sole_vertex_drift']<8e-6 and b['stand_vertex_drift']==0,(f,b['seat_local_actor_error'],b['sole_vertex_drift'],b['stand_vertex_drift'])
for q in [before,now]:
 for a in q.values():
  a.pop('upper');a.pop('camera')
report={'frames':49,'new_post_top_only':2,'base_xy_unchanged':True,
 'new_actor_seat_frame_error':max(x['seat_local_actor_error'] for x in now.values()),
 'new_outsoles_world_error_max':max(x['sole_vertex_drift'] for x in now.values()),'camera_and_optical_sockets_identical':True,'frames_v71':before,'frames_v74':now}
(P/'pose-audit74.json').write_text(json.dumps(report,indent=2)+'\n')
print('verified all 49 frames', {k:v for k,v in report.items() if not k.startswith('frames_v')})
# The neutral position of the individual bones must match the user's earlier selected static proof.
bpy.ops.wm.open_mainfile(filepath=str(P.parent/'chair-seat-height-study'/'chair-seat-height-012-adjusted.blend'))
_,_,test=capture(False)
match={k:max(abs(test[k][i][j]-cur[k][i][j]) for i in range(4) for j in range(4)) for k in test}
assert max(match.values())<1e-5,match
print('neutral selected static fit matches',match)
