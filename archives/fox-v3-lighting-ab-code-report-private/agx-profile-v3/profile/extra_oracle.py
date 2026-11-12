import bpy,numpy as np,pathlib,json
P=pathlib.Path(__file__).resolve().parent
f=json.loads((P/'frozen.json').read_text());HI=f['hi']
sc=bpy.context.scene;sc.display_settings.display_device='sRGB';sc.view_settings.view_transform='AgX';sc.view_settings.look='AgX - Medium High Contrast';sc.view_settings.exposure=0;sc.view_settings.gamma=1;sc.render.dither_intensity=0;sc.render.image_settings.file_format='PNG';sc.render.image_settings.color_depth='16';sc.render.image_settings.color_mode='RGB'
rng=np.random.default_rng(901734)
extra=np.exp(rng.uniform(np.log(1e-10),np.log(HI*1024),(20000,3))).astype(np.float32)
extra=np.concatenate([extra[np.any(extra>HI,axis=1)],np.array([[np.finfo(np.float32).max,0,0],[0,np.finfo(np.float32).max,0],[0,0,np.finfo(np.float32).max]],np.float32)])
old=np.load(P/'samples.npy');samples=np.concatenate([old,extra]);np.save(P/'samples.npy',samples)
groups=json.loads((P/'groups.json').read_text());groups['out_of_domain_mixed']=len(extra);(P/'groups.json').write_text(json.dumps(groups,indent=2))
w=1024;h=(len(samples)+w-1)//w;rgba=np.ones((w*h,4),np.float32);rgba[:len(samples),:3]=samples
im=bpy.data.images.new('extra',w,h,float_buffer=True);im.colorspace_settings.name='Linear Rec.709';im.pixels.foreach_set(rgba.ravel());im.save_render(str(P/'oracle.png'),scene=sc)
