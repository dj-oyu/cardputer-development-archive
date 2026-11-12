import bpy,pathlib,sys,numpy as np,ctypes,ast,json,subprocess
D=pathlib.Path(sys.argv[sys.argv.index('--')+1]).resolve();sc=bpy.context.scene;sc.render.image_settings.file_format='PNG';sc.render.image_settings.color_mode='RGBA';sc.render.image_settings.color_depth='8';sc.render.dither_intensity=1;sc.view_settings.exposure=0;sc.view_settings.gamma=1
ns={'bpy':bpy,'np':np};mod=ast.parse((D/'run.py').read_text());exec(compile(ast.Module(body=[n for n in mod.body if isinstance(n,ast.FunctionDef) and n.name=='display'],type_ignores=[]),'display-test','exec'),ns)
a=np.zeros((135,240,3),np.float32);a[:,:,0]=np.linspace(0,1,240)[None,:];a[:,:,1]=.25;a[:,:,2]=.75;ns['display'](sc,a,D/'synthetic-raw-view.png',True)
np.save(D/'synthetic-display-input.npy',a)
subprocess.run(['python3','-c',"from PIL import Image;import numpy as np,json,sys,pathlib;d=pathlib.Path(sys.argv[1]);a=np.load(d/'synthetic-display-input.npy');b=np.array(Image.open(d/'synthetic-raw-view.png'))[...,:3]/255;e=abs(a-b);assert e.max()<=1/255; (d/'profile-synthetic.json').write_text(json.dumps({'rawPassThroughMaxError':float(e.max()),'sameDither':1,'noSecondSrgb':True},indent=2))",str(D)],check=True);print('PROFILE_PASS')
