import bpy,pathlib,sys,json,hashlib
from mathutils import Vector
args=sys.argv[sys.argv.index('--')+1:]; src,out=map(pathlib.Path,args)
out.mkdir(parents=True,exist_ok=False)
bpy.ops.wm.open_mainfile(filepath=str(src.resolve()))
scene=bpy.context.scene
objects=sorted([o for o in scene.objects if o.type=='MESH'],key=lambda o:o.name)
def export(path,morph,selected=False):
    bpy.ops.export_scene.gltf(filepath=str(path),export_format='GLB',use_selection=selected,
      export_texcoords=False,export_normals=True,export_tangents=False,export_materials='EXPORT',
      export_cameras=False,export_lights=False,export_animations=False,
      export_morph=morph,export_morph_normal=morph,export_extras=True)
export(out/'with-morph.glb',True)
poses=[('neutral',0,0),('blink-half',.5,0),('blink',1,0),('jaw-half',0,.5),('jaw',0,1),('combined',1,1)]
summary=[]
for name,blink,jaw in poses:
    for o in objects:
        if o.data.shape_keys:
            for k in o.data.shape_keys.key_blocks:
                if k.name!='Basis': k.value=blink if k.name=='blink' else jaw
    bpy.context.view_layer.update(); deps=bpy.context.evaluated_depsgraph_get()
    clones=[]; surfaces=[]
    for o in objects:
        evaluated=o.evaluated_get(deps)
        mesh=bpy.data.meshes.new_from_object(evaluated,preserve_all_data_layers=True,depsgraph=deps)
        clone=bpy.data.objects.new('sample_'+o.name,mesh);scene.collection.objects.link(clone)
        clone.matrix_world=o.matrix_world.copy();clones.append(clone)
        mesh.calc_loop_triangles()
        positions=[]
        for v in mesh.vertices:
            p=o.matrix_world@v.co; positions.append([p.x,-p.z,-p.y])
        triangles=[];colors=[]
        for t in mesh.loop_triangles:
            a,b,c=t.vertices;triangles.append([a,c,b])
            colors.append(list(mesh.materials[t.material_index].node_tree.nodes['Principled BSDF'].inputs['Base Color'].default_value[:3]))
        surfaces.append({'id':o.name,'positions':positions,'triangles':triangles,'linearColors':colors})
    bpy.ops.object.select_all(action='DESELECT')
    for o in clones:o.select_set(True)
    bpy.context.view_layer.objects.active=clones[0]
    export(out/(name+'.glb'),False,True)
    (out/(name+'.source.json')).write_text(json.dumps({'scope':'direct evaluated Blender geometry; explicit static pose sample, not runtime morph','blink':blink,'jawOpen':jaw,'surfaces':surfaces}))
    summary.append({'name':name,'blink':blink,'jawOpen':jaw,'vertices':sum(len(s['positions']) for s in surfaces),'triangles':sum(len(s['triangles']) for s in surfaces)})
    for clone in clones:
        mesh=clone.data;bpy.data.objects.remove(clone,do_unlink=True);bpy.data.meshes.remove(mesh)
(out/'export.json').write_text(json.dumps({'blender':bpy.app.version_string,'source':str(src.resolve()),'sourceSha256':hashlib.sha256(src.read_bytes()).hexdigest(),'export':'Blender bundled glTF exporter, GLB, normals, opaque material colors, no UV/animation','poseSamplesAreStaticDiagnosticOnly':True,'poses':summary},indent=2))
