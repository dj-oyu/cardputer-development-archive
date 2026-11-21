"""Rotate the existing two welt openings without modifying construction or profile."""
import bpy,sys,hashlib,math,numpy as np
from pathlib import Path
a,b=map(Path,sys.argv[-3:-1]); angle=float(sys.argv[-1])
assert hashlib.sha256(a.read_bytes()).hexdigest()=='28f5a304fbf4d7dafab8188bb5b7f8e229dab7e76ddb2a0a755a991de8f82baa'
bpy.ops.wm.open_mainfile(filepath=str(a.resolve()),use_scripts=False)
o=bpy.data.objects
W,H=512,512
Y,X=np.mgrid[0:H,0:W].astype('float32')
X=(X+.5)/W*.60;Z=3.20+(Y+.5)/H*.6
# Pocket opening: subtle fabric lip on each bank, with a dark interior
# and rounded taper at the ends. Everything follows sewn face topology.
cx,cz=.309,3.428
h=math.hypot(.076,.226)/2; xr=h*math.cos(math.radians(angle));zr=h*math.sin(math.radians(angle))
x0,z0=cx+xr,cz-zr;x1,z1=cx-xr,cz+zr
dx=x1-x0;dz=z1-z0;nn=(dx*dx+dz*dz)**.5
t=((X-x0)*dx+(Z-z0)*dz)/(nn*nn)
p=((X-x0)*dz-(Z-z0)*dx)/nn
end=np.minimum(np.clip(t/.10,0,1),np.clip((1-t)/.10,0,1))
A=np.zeros((H,W,4),dtype='float32')
def band(center,sigma,weight,col):
 global A
 g=(weight*end*np.exp(-.5*((p-center)/sigma)**2)).astype('float32')
 oa=A[:,:,3].copy();ra=g+oa*(1-g)
 A[:,:,:3]=(np.array(col)[None,None,:]*g[:,:,None]+A[:,:,:3]*(oa*(1-g))[:,:,None])/np.maximum(1e-8,ra[:,:,None])
 A[:,:,3]=ra
band(.001,.030,.58,(.019,.024,.014))
band(-.013,.014,.93,(.47,.365,.215))
band(.013,.007,.49,(.175,.143,.085))
band(.008,.006,.88,(.006,.010,.006))
im=bpy.data.images.new('Forest jacket | inset pocket welts v42',width=W,height=H,alpha=True)
im.colorspace_settings.name='Linear Rec.709';im.pixels.foreach_set(A.ravel());im.update();im.pack()
for name in ('Jacket cut front and back','Jacket cut front and back.001'):
 nodes=o[name].data.materials[0].node_tree.nodes
 tx=next(n for n in nodes if n.type=='TEX_IMAGE')
 tx.image=im
bpy.ops.wm.save_as_mainfile(filepath=str(b.resolve()),compress=True)
