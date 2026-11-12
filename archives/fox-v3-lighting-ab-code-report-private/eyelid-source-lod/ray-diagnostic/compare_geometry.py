import bpy,json,struct,pathlib,hashlib,sys,math,numpy as np
from mathutils import Vector
from mathutils.bvhtree import BVHTree
R=pathlib.Path('/workspace/scratch/6d8dcdbcdc54');D=R/'fox-v3-eye-diagnostic/lid-ab';plan=json.loads((D/'PLAN.json').read_text());arm=sys.argv[sys.argv.index('--')+1];cfg=json.loads((R/'fox-reference-uncertainty-v3/input/config.json').read_text());src=pathlib.Path(cfg['source']);sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();before=sha(src)
bpy.ops.wm.open_mainfile(filepath=str(src));dep=bpy.context.evaluated_depsgraph_get();source={}
for o in bpy.context.scene.objects:
 if o.hide_render or o.type not in ['MESH','CURVE'] or o.name=='Studio ground':continue
 ev=o.evaluated_get(dep);m=ev.to_mesh();m.calc_loop_triangles();v=np.array([list(ev.matrix_world@x.co) for x in m.vertices]);t=np.array([list(x.vertices) for x in m.loop_triangles]);source[o.name]=(v,t);ev.to_mesh_clear()
p=R/plan['arms'][arm];assert sha(p)==plan['inputHashes'][plan['arms'][arm]];b=p.read_bytes();l=struct.unpack_from('<I',b,12)[0];g=json.loads(b[20:20+l]);buf=b[28+l:]
def acc(i):
 a=g['accessors'][i];v=g['bufferViews'][a['bufferView']];dt={5126:'<f4',5123:'<u2',5125:'<u4'}[a['componentType']];n={'VEC3':3,'SCALAR':1}[a['type']];assert not v.get('byteStride');return np.frombuffer(buf,dtype=dt,count=a['count']*n,offset=v.get('byteOffset',0)+a.get('byteOffset',0)).reshape(-1,n).copy()
coarse={}
for o in g['nodes']:
 if 'mesh' not in o:continue
 assert not any(k in o for k in ['matrix','rotation','translation','scale'])
 pr=g['meshes'][o['mesh']]['primitives'][0];v=acc(pr['attributes']['POSITION']).astype(float)[:,[0,2,1]];v[:,1]*=-1;t=acc(pr['indices']).reshape(-1,3);coarse[o['name'].removeprefix('EXPORT ')]=(v,t)
def tree(shapes):
 vv=[];tt=[];names=[]
 for name,(v,t) in shapes.items():
  tt.extend((t+len(vv)).tolist());vv.extend(v.tolist());names.extend([name]*len(t))
 return BVHTree.FromPolygons(vv,tt,all_triangles=True),names
st,sn=tree(source);ct,cn=tree(coarse)
object_trees={name:BVHTree.FromPolygons(v.tolist(),t.tolist(),all_triangles=True) for name,(v,t) in coarse.items()}
roles=['Eye socket','Eye white','Amber iris','Pupil','Eye glint','Eye glint small','Upper eyelid']
counts={name:{'sourceVertices':len(source[name][0]),'sourceTriangles':len(source[name][1]),'coarseVertices':len(coarse[name][0]),'coarseTriangles':len(coarse[name][1])} for side in [-1,1] for role in roles for name in [f'{role} {side}']};rows=[]
cameras=list(cfg['cameras'])
for hold in plan['holdout']:
 az=math.radians(hold['azimuthDegrees']);el=math.radians(hold['elevationDegrees']);direction=np.array([math.cos(el)*math.cos(az),math.cos(el)*math.sin(az),math.sin(el)]);target=np.array(cfg['cameras'][0]['blenderTarget']);cameras.append({'name':hold['name'],'blenderTarget':target.tolist(),'blenderLocation':(target+direction*10).tolist()})
for camera in cameras:
 V=(Vector(camera['blenderLocation'])-Vector(camera['blenderTarget'])).normalized();rot=(-V).to_track_quat('-Z','Y').to_matrix();right=rot@Vector((1,0,0));up=rot@Vector((0,1,0));center=Vector(camera['blenderTarget']);A=np.array([right,up,V]);
 for side in [-1,1]:
  verts=np.concatenate([source[f'{role} {side}'][0] for role in roles]);pr=(verts-np.array(center))@A.T;lo=pr[:,:2].min(0);hi=pr[:,:2].max(0);margin=(hi-lo)*.02;lo-=margin;hi+=margin;samples=[];hist={}
  for yy in range(32):
   for xx in range(32):
    uv=lo+(hi-lo)*[(xx+.5)/32,(yy+.5)/32];origin=center+right*float(uv[0])+up*float(uv[1])+V*20;hits=[]
    for tr,ns in [(st,sn),(ct,cn)]:
     loc,n,f,dist=tr.ray_cast(origin,-V,40);hits.append({'object':ns[f] if f is not None else None,'distance':dist,'point':list(loc) if loc is not None else None})
    target=hits[0]['object'];targetHit=None
    if target in object_trees:
     loc,n,f,dist=object_trees[target].ray_cast(origin,-V,40)
     targetHit={'distance':dist,'point':list(loc) if loc is not None else None}
    hits[0]['sameObjectCoarseIntersection']=targetHit
    key=str(hits[0]['object'])+' -> '+str(hits[1]['object']);hist[key]=hist.get(key,0)+1;samples.append({'grid':[xx,yy],'source':hits[0],'coarse':hits[1]})
  rows.append({'view':camera['name'],'side':side,'grid':32,'bboxLo':lo.tolist(),'bboxHi':hi.tolist(),'transitionCounts':hist,'samples':samples})
assert sha(src)==before
assert sha(p)==plan['inputHashes'][plan['arms'][arm]]
assert not (D/(arm+'-geometry.json')).exists()
(D/(arm+'-geometry.json')).write_text(json.dumps({'sourceSHA256':before,'coarseSHA256':sha(p),'contract':'32x32 fixed grid on original eye-component projected bbox +2percent each side; full character nearest hit; no illumination or image input; no formal score','counts':counts,'views':rows},indent=2));print('DONE',flush=True)
