import bpy,numpy as np,json,pathlib
R=pathlib.Path('/workspace/scratch/6d8dcdbcdc54');bpy.ops.wm.open_mainfile(filepath=str(R/'fox-reference-sculpt-private/fox-reference-standing-editable.blend'));dep=bpy.context.evaluated_depsgraph_get();out=[]
for side in [-1,1]:
 o=bpy.data.objects[f'Upper eyelid {side}'];ev=o.evaluated_get(dep);m=ev.to_mesh();m.calc_loop_triangles();v=np.array([ev.matrix_world@x.co for x in m.vertices]);t=np.array([list(x.vertices) for x in m.loop_triangles]);np.savez(R/f'fox-v3-lid-design/source-lid-{side}-readonly.npz',v=v,t=t);out.append({'side':side,'v':len(v),'t':len(t),'first12mean':v[:12].mean(0).tolist(),'first12radii':np.linalg.norm(v[:12]-v[:12].mean(0),axis=1).tolist(),'last12mean':v[-12:].mean(0).tolist(),'firstTriangles':t[:8].tolist()});ev.to_mesh_clear()
print(json.dumps(out,indent=2));(R/'fox-v3-lid-design/source-evaluated-rings.json').write_text(json.dumps(out,indent=2))
