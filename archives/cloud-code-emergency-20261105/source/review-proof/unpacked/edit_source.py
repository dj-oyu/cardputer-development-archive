import bpy,bmesh,pathlib,sys,json
args=sys.argv[sys.argv.index('--')+1:]; src,out=map(pathlib.Path,args)
bpy.ops.wm.open_mainfile(filepath=str(src.resolve()))
head=bpy.data.objects['head']; mesh=head.data
before=len(mesh.vertices)
bm=bmesh.new();bm.from_mesh(mesh)
# A local cheek edit with a topology change, selected by spatial region.
# No exported vertex number, triangle order or converter code is edited.
region=[v for v in bm.verts if v.co.x<-.35 and -.65<v.co.z<.05 and v.co.y<.10]
for v in region: v.co.x-=.14; v.co.y-=.06
edges=[e for e in bm.edges if all(v in region for v in e.verts)]
bmesh.ops.subdivide_edges(bm,edges=edges,cuts=1,use_grid_fill=True)
bm.normal_update();bm.to_mesh(mesh);bm.free();mesh.update()
bpy.data.objects['upper_muzzle'].scale.x=1.12
bpy.ops.wm.save_as_mainfile(filepath=str(out.resolve()))
out.with_suffix('.edit.json').write_text(json.dumps({'operation':'cheek spatial selection, translate, subdivide; muzzle object scale X 1.12','headVerticesBefore':before,'headVerticesAfter':len(mesh.vertices),'selectedCheekVertices':len(region),'manualVertexIds':False,'compilerChanges':False},indent=2))
