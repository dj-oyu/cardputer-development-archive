import bpy,numpy as np,json,pathlib,sys,hashlib
R=pathlib.Path(sys.argv[sys.argv.index('--')+1]).resolve();D=R/'rich-oracle';P=R.parent;cfg=json.loads((P/'fox-reference-uncertainty-v3/input/config.json').read_text());comp=json.loads((P/'fox-v3-lighting-ab/four-both-002/model-baseline/compile.json').read_text());bpy.ops.wm.open_mainfile(filepath=cfg['source']);v=np.fromfile(R/'observer/native-front-baseline.vertices.f64',np.float64).reshape(3,256,32,3);report={'materials':{},'normalStorage':[]}
for mat in comp['materialTrace']:
 m=bpy.data.materials.get(mat['name']);assert m and m.use_nodes
 report['materials'][mat['name']]={'nodes':[(n.name,n.bl_idname) for n in m.node_tree.nodes],'links':[(l.from_node.name,l.from_socket.name,l.to_node.name,l.to_socket.name) for l in m.node_tree.links]}
for node,part in enumerate(comp['parts'],1):
 ids=np.array(part['triangles'])[:,[0,2,1]];p=v[0,node,:len(part['positions'])][:,[0,2,1]]*[1,-1,-1]/38;n=v[1,node,:len(part['positions'])][:,[0,2,1]]*[1,-1,-1];n=n/np.linalg.norm(n,axis=1)[:,None]
 mesh=bpy.data.meshes.new('audit');mesh.from_pydata(p.tolist(),[],ids.tolist());mesh.update()
 for f in mesh.polygons:f.use_smooth=True
 mesh.normals_split_custom_set_from_vertices(n.tolist());stored=np.array([c.vector[:] for c in mesh.corner_normals]);expected=np.array([n[l.vertex_index] for l in mesh.loops]);err=np.linalg.norm(stored-expected,axis=1)
 report['normalStorage'].append({'node':node,'maxVectorError':float(err.max()),'cornersOver1eMinus3':int((err>1e-3).sum()),'positionMaxError':float(abs(np.array([x.co[:] for x in mesh.vertices])-p).max())})
 bpy.data.meshes.remove(mesh)
report['characterObjects']=[o.name for o in bpy.context.scene.objects if o.type in ('MESH','CURVE') and not o.hide_render and o.name!='Studio ground']
(D/'source-audit.json').write_text(json.dumps(report,indent=2));print('AUDIT_DONE',max(x['maxVectorError'] for x in report['normalStorage']))
