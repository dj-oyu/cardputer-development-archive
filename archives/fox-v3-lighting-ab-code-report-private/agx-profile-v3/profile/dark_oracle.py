import bpy,numpy as np,pathlib,json
P=pathlib.Path(__file__).resolve().parent;f=json.loads((P/'frozen.json').read_text());first=f['lo']*np.expm1(np.log1p(f['hi']/f['lo'])/64)
rng=np.random.default_rng(47501);v=np.r_[0,np.nextafter(np.float32(first),np.float32(0)),first,np.nextafter(np.float32(first),np.float32(np.inf))]
a=rng.uniform(0,first*1.01,(4096,3));b=np.array([[x,y,z] for x in v for y in v for z in v]);c=np.concatenate([np.geomspace(1e-12,first*1.01,512)[:,None]*np.eye(3)[k] for k in range(3)])
extra=np.concatenate([a,b,c]).astype(np.float32);samples=np.concatenate([np.load(P/'samples.npy'),extra]);np.save(P/'samples.npy',samples)
g=json.loads((P/'groups.json').read_text());g['dark_first_cell_saturation']=len(extra);(P/'groups.json').write_text(json.dumps(g,indent=2))
sc=bpy.context.scene;sc.display_settings.display_device='sRGB';sc.view_settings.view_transform='AgX';sc.view_settings.look='AgX - Medium High Contrast';sc.view_settings.exposure=0;sc.view_settings.gamma=1;sc.render.dither_intensity=0;sc.render.image_settings.file_format='PNG';sc.render.image_settings.color_depth='16';sc.render.image_settings.color_mode='RGB'
w=1024;h=(len(samples)+w-1)//w;rgba=np.ones((w*h,4),np.float32);rgba[:len(samples),:3]=samples
im=bpy.data.images.new('dark',w,h,float_buffer=True);im.colorspace_settings.name='Linear Rec.709';im.pixels.foreach_set(rgba.ravel());im.save_render(str(P/'oracle.png'),scene=sc)
print('first_cell_upper',first,'count',len(extra))
