import bpy,json,pathlib,hashlib,random
R=pathlib.Path('/workspace/scratch/6d8dcdbcdc54');O=R/'fox-eye-runtime-20261111';S=R/'fixed-recovery/extracted/fox-cardputer-latest-private/fox-cardputer-2k-v2.blend'
h=hashlib.sha256(S.read_bytes()).hexdigest();bpy.ops.wm.open_mainfile(filepath=str(S),use_scripts=False)
j=json.load(open(R/'fox-eye-contract-20261111/evaluated-contract.json'));mapping=json.load(open(R/'fox-eye-fixtures-20261111/mapping.json'))['object_mapping'];ctrl=bpy.data.objects['Expression Controls'];sc=bpy.context.scene
keys=['Blink Both','Blink -X','Blink +X','Gaze X','Gaze Up','Eye Style','Show Highlights','Environment Reflection','Bubble Pressure']
rng=random.Random(187);samples=[[v,0,0,0,0,0,1,.5,0] for v in [0,.001,.019,.021,.123,.499,.731,.979,.98,.981,1]]+[[rng.random(),rng.random(),rng.random(),rng.uniform(-1,1),rng.uniform(-1,1),rng.randrange(3),rng.randrange(2),rng.random(),rng.uniform(-1,1)] for _ in range(35)]
# Force single-side and reversal/pause sequences.
samples += [[0,a,b,0,0,0,1,.5,0] for a,b in [(0,.37),(.82,0),(.6,.1),(.6,.1),(.2,.9),(0,0)]]
out=[]
for cs in samples:
 for k,v in j['controls'].items():ctrl[k]=v
 for k,v in zip(keys,cs):ctrl[k]=v
 ctrl.update_tag();sc.frame_set(1);bpy.context.view_layer.update();dg=bpy.context.evaluated_depsgraph_get();objects=[]
 for m in mapping:
  e=bpy.data.objects[m['name']].evaluated_get(dg);me=e.to_mesh();me.calc_loop_triangles();objects.append({'local':[list(v.co) for v in me.vertices],'hidden':int(e.hide_render),'matrix':[list(r) for r in e.matrix_world],'triangles':[list(t.vertices) for t in me.loop_triangles],'material_slots':[t.material_index for t in me.loop_triangles]});e.to_mesh_clear()
 out.append({'controls':cs,'objects':objects})
shapes={}
for m in mapping:
 o=bpy.data.objects[m['name']]
 if m['id'] in (43,44):shapes[str(m['id'])]={k.name:[list(v.co) for v in k.data] for k in o.data.shape_keys.key_blocks}
assert hashlib.sha256(S.read_bytes()).hexdigest()==h
(O/'oracle.json').write_text(json.dumps({'source_sha256':h,'blender_version':bpy.app.version_string,'samples':out,'shapes':shapes},separators=(',',':')))
print('RUNTIME_ORACLE_OK',len(out),h)
