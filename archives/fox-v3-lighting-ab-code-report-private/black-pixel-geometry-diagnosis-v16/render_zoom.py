import bpy,pathlib,json,hashlib,ast,numpy as np,time
from mathutils import Vector
P=pathlib.Path('/workspace/scratch/6d8dcdbcdc54');R=P/'fox-v3-position-diagnostic';D=R/'rich-oracle';OUT=P/'fox-v16-black-pixel-diagnostic/zoom';OUT.mkdir(exist_ok=False);REF=P/'fox-reference-uncertainty-v3'
sha=lambda p:hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest()
cfg=json.loads((REF/'input/config.json').read_text());comp=json.loads((P/'fox-v3-lighting-ab/four-both-002/model-baseline/compile.json').read_text());cur=json.loads((P/'fox-v3-ground-transport/le-001/model-baseline/compile.json').read_text());assert comp==cur
manifest=json.loads((REF/'render-manifest.json').read_text());lookup={(r['seed'],r['view'],r['case']):r for r in manifest['images']};v=np.fromfile(R/'observer/native-front-baseline.vertices.f64',np.float64).reshape(3,256,32,3);materials={m['id']:m for m in comp['materialTrace']};tree=ast.parse((D/'render_oracle.py').read_text());exec(compile(ast.Module(body=[n for n in tree.body if isinstance(n,ast.FunctionDef)],type_ignores=[]),'oracle_functions','exec'),globals())
view=next(x for x in cfg['cameras'] if x['name']=='oblique');rows=[]
for name,coarse,box in [('original-rich-bh',False,False),('coarse-rich-bh',True,False),('coarse-rich-box',True,True)]:
 sc=setup(11,'baseline',view)
 if coarse:replace_character(sc)
 cam=sc.camera;rot=cam.matrix_world.to_3x3();cam.location += rot@Vector((18*4.8/135,22.75*4.8/135,0));cam.data.ortho_scale/=2;bpy.context.view_layer.update()
 if box:sc.cycles.pixel_filter_type='BOX';sc.cycles.filter_width=.01
 sc.render.filepath=str(OUT/(name+'.png'));t=time.monotonic();bpy.ops.render.render(write_still=True);rows.append({'name':name,'seconds':time.monotonic()-t,'cameraMatrix':[list(x) for x in cam.matrix_world],'orthoScale':cam.data.ortho_scale,'settings':capture_settings(sc),'pngSHA':sha(sc.render.filepath)});(OUT/'manifest.json').write_text(json.dumps(rows,indent=2))
assert sha(cfg['source'])==cfg['sourceSHA256']
