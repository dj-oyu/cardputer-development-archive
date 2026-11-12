import bpy,json,hashlib,math
from pathlib import Path
from mathutils import Vector
from mathutils.bvhtree import BVHTree
R=Path(__file__).resolve().parent.parent;D=Path(__file__).resolve().parent;cfg=json.loads((R/'fox-reference-uncertainty-v3/input/config.json').read_text());src=Path(cfg['source']);sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();before=sha(src);assert before==cfg['sourceSHA256'];bpy.ops.wm.open_mainfile(filepath=str(src));dep=bpy.context.evaluated_depsgraph_get()
verts=[];tris=[];data=[]
for ob in bpy.context.scene.objects:
 if ob.hide_render or ob.type not in ['MESH','CURVE']:continue
 ev=ob.evaluated_get(dep);me=ev.to_mesh();me.calc_loop_triangles();M=ev.matrix_world;N=M.to_3x3().inverted().transposed();offset=len(verts);verts.extend([M@v.co for v in me.vertices]);cn=me.corner_normals
 for tr in me.loop_triangles:
  ids=[offset+i for i in tr.vertices];tris.append(ids);data.append((ob.name,[N@cn[i].vector for i in tr.loops],tr.polygon_index))
 ev.to_mesh_clear()
tree=BVHTree.FromPolygons(verts,tris,all_triangles=True);rows=[];maxerr=0
for c in cfg['cameras']:
 V=(Vector(c['blenderLocation'])-Vector(c['blenderTarget'])).normalized();rot=(-V).to_track_quat('-Z','Y').to_matrix();right=rot@Vector((1,0,0));up=rot@Vector((0,1,0));center=Vector(c['blenderTarget']);scale=135/c['verticalOrtho'];w=json.loads((R/'fox-v3-lid-transport-point-audit/verified-winners-v2'/f"{c['name']}-baseline.json").read_text())
 for q in w['points']:
  p=Vector(q['P']);uv=[119.5+(p-center).dot(right)*scale,67-(p-center).dot(up)*scale];err=max(abs(uv[0]-q['x']),abs(uv[1]-q['y']));maxerr=max(maxerr,err);assert err<.001,(q['x'],q['y'],uv)
  loc,ng,fi,dist=tree.ray_cast(p+20*V,-V,40);row={'view':c['name'],'x':q['x'],'y':q['y'],'nativeObject':q['sourceObjectName'],'nativePhysicalSide':q['physicalSide'],'nativeDistance':20.,'sourceHit':fi is not None}
  if fi is not None:
   name,ns,poly=data[fi];a,b,cc=[verts[i] for i in tris[fi]];v0=b-a;v1=cc-a;v2=loc-a;d00=v0.dot(v0);d01=v0.dot(v1);d11=v1.dot(v1);d20=v2.dot(v0);d21=v2.dot(v1);den=d00*d11-d01*d01;assert den!=0;bb=(d11*d20-d01*d21)/den;bc=(d00*d21-d01*d20)/den;ba=1-bb-bc;sn=(ns[0]*ba+ns[1]*bb+ns[2]*bc).normalized();nn=Vector(q['Ns']).normalized();row.update(sourceObject=name,sameObject=name==q['sourceObjectName'],distance=dist,sourceAheadOfNative=20-dist,point=list(loc),Ng=list(ng),Ns=list(sn),sourceNgDotView=ng.dot(V),sourceNsDotView=sn.dot(V),nativeNsDotView=nn.dot(V),sourceNsDotNativeNs=sn.dot(nn),sourceNgDotNativeNs=ng.dot(nn),triangle=fi,polygon=poly,barycentric=[ba,bb,bc])
  rows.append(row)
assert sha(src)==before
(D/'source-rays-private.json').write_text(json.dumps({'sourceSHA256':before,'maxProjectionErrorPixels':maxerr,'rayOrigin':'nativeSourceWorldP+20*V','nativeDistance':20,'normalConvention':'Unflipped evaluated source triangle Ng and barycentric corner Ns; not Cycles safe shading normals','rows':rows},indent=2));print('DONE',len(rows),maxerr,flush=True)
