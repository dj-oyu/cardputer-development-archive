import bpy,json,sys,pathlib,hashlib
src,out=sys.argv[sys.argv.index('--')+1:];bpy.ops.wm.open_mainfile(filepath=src)
r={'sourceSHA256':hashlib.sha256(pathlib.Path(src).read_bytes()).hexdigest(),'materials':{}}
for m in bpy.data.materials:
 p=m.node_tree.nodes.get('Principled BSDF') if m.node_tree else None
 if p:r['materials'][m.name]={'doubleSided':not m.use_backface_culling,'baseColor':list(p.inputs['Base Color'].default_value)}
pathlib.Path(out).write_text(json.dumps(r,indent=2))
