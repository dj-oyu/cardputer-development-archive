import bpy,json,pathlib,struct,numpy as np,hashlib
from mathutils import Vector
from mathutils.bvhtree import BVHTree
R=pathlib.Path('/workspace/scratch/6d8dcdbcdc54');D=R/'fox-v3-eye-diagnostic/lid-residual';cfg=json.loads((R/'fox-reference-uncertainty-v3/input/config.json').read_text());src=pathlib.Path(cfg['source']);sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();before=sha(src);bpy.ops.wm.open_mainfile(filepath=str(src));dep=bpy.context.evaluated_depsgraph_get()
p=R/'fox-v3-eye-local-lod/eye-B.glb';b=p.read_bytes();l=struct.unpack_from('<I',b,12)[0];g=json.loads(b[20:20+l]);buf=b[28+l:]
def acc(i):
 a=g['accessors'][i];v=g['bufferViews'][a['bufferView']];dt={5126:'<f4',5123:'<u2',5125:'<u4'}[a['componentType']];n={'VEC3':3,'SCALAR':1}[a['type']];return np.frombuffer(buf,dtype=dt,count=a['count']*n,offset=v.get('byteOffset',0)+a.get('byteOffset',0)).reshape(-1,n).copy()
rows=[]
for side in [-1,1]:
 name=f'Upper eyelid {side}';o=bpy.data.objects[name];assert o.type=='CURVE' and len(o.data.splines)==1;s=o.data.splines[0];assert s.type=='BEZIER' and not s.use_cyclic_u;bp=s.bezier_points;nodes=[x for x in g['nodes'] if x.get('name')=='EXPORT '+name];assert len(nodes)==1;pr=g['meshes'][nodes[0]['mesh']]['primitives'][0];v=acc(pr['attributes']['POSITION']).astype(float)[:,[0,2,1]];v[:,1]*=-1;t=acc(pr['indices']).reshape(-1,3);tree=BVHTree.FromPolygons(v.tolist(),t.tolist(),all_triangles=True)
 ev=o.evaluated_get(dep);me=ev.to_mesh();st=BVHTree.FromPolygons([ev.matrix_world@x.co for x in me.vertices],[list(x.vertices) for x in me.polygons]);samples=[]
 for k in range(len(bp)-1):
  a,b,c,d=bp[k].co,bp[k].handle_right,bp[k+1].handle_left,bp[k+1].co
  for j in range(64+(k==len(bp)-2)):
   u=j/64;q=o.matrix_world@((1-u)**3*a+3*(1-u)**2*u*b+3*(1-u)*u*u*c+u**3*d);loc,n,f,dist=tree.find_nearest(q);sl,sn,sf,sd=st.find_nearest(q);samples.append({'segment':k,'t':u,'coarseSurfaceDistance':dist,'sourceSurfaceDistance':sd})
 ev.to_mesh_clear();radius=o.data.bevel_depth;dist=np.array([x['coarseSurfaceDistance'] for x in samples]);rows.append({'name':name,'sourceType':'BEZIER','controlCount':len(bp),'bevelDepth':radius,'bevelResolution':o.data.bevel_resolution,'useFillCaps':o.data.use_fill_caps,'coarseVertices':len(v),'coarseTriangles':len(t),'sampleCount':len(samples),'coarseCenterlineToSurfaceMax':float(dist.max()),'coarseCenterlineToSurfaceMedian':float(np.median(dist)),'countFartherThanOriginalRadius':int(sum(dist>radius)),'samples':samples})
assert sha(src)==before;(D/'curve-read.json').write_text(json.dumps({'sourceSHA':before,'coarseSHA':sha(p),'contract':'257source-Bezier centreline samples per side,64per segment; descriptive nearest-distance, no fitting or acceptance','rows':rows},indent=2))
