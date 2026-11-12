import bpy,numpy as np, pathlib,json,hashlib
P=pathlib.Path(__file__).resolve().parent
N=65; LO=2**-12.47393; HI=2**12.5260688117
(P/'frozen.json').write_text(json.dumps(dict(size=N,lo=LO,hi=HI,shaper='log1p(x/lo)/log1p(hi/lo)',gates=dict(rmse=.5,p99=1,max=2),quantum=[31,63,31],seed=731994,display='sRGB',view='AgX',look='AgX - Medium High Contrast',exposure=0,gamma=1,dither=0),indent=2))
v=LO*np.expm1(np.linspace(0,np.log1p(HI/LO),N)); lattice=np.stack(np.meshgrid(v,v,v,indexing='ij'),-1).reshape(-1,3).astype(np.float32)
rng=np.random.default_rng(731994)
groups={}
groups['random_log_hdr']=np.exp(rng.uniform(np.log(1e-8),np.log(HI),(50000,3)))
groups['linear_hdr']=rng.uniform(0,HI,(5000,3))
groups['black_dark_gray']=np.repeat(np.r_[0,np.geomspace(1e-10,1,2048)][:,None],3,axis=1)
a=np.geomspace(1e-10,HI,4096); groups['saturated_axes']=np.concatenate([a[:,None]*np.eye(3)[i] for i in range(3)])
groups['domain_edges']=np.array([[x,y,z] for x in [0,LO,HI,np.nextafter(np.float32(HI),np.float32(0))] for y in [0,LO,HI] for z in [0,LO,HI]])
groups['out_of_domain']=np.exp(rng.uniform(np.log(HI),np.log(HI*1024),(1000,3)))
samples=np.concatenate(list(groups.values())).astype(np.float32); np.save(P/'samples.npy',samples)
(P/'groups.json').write_text(json.dumps({k:len(v) for k,v in groups.items()},indent=2))
sc=bpy.context.scene; sc.display_settings.display_device='sRGB'; sc.view_settings.view_transform='AgX';sc.view_settings.look='AgX - Medium High Contrast';sc.view_settings.exposure=0;sc.view_settings.gamma=1;sc.view_settings.view_settings if False else None
sc.render.dither_intensity=0;sc.render.image_settings.file_format='PNG';sc.render.image_settings.color_depth='16';sc.render.image_settings.color_mode='RGB'
for name,arr in [('lut',lattice),('oracle',samples)]:
 w=1024;h=(len(arr)+w-1)//w;rgba=np.ones((w*h,4),np.float32);rgba[:len(arr),:3]=arr
 im=bpy.data.images.new(name,w,h,float_buffer=True);im.colorspace_settings.name='Linear Rec.709';im.pixels.foreach_set(rgba.ravel());im.save_render(str(P/(name+'.png')),scene=sc);bpy.data.images.remove(im)
np.save(P/'lattice.npy',lattice)
print('SYNTHETIC GENERATION COMPLETE')
