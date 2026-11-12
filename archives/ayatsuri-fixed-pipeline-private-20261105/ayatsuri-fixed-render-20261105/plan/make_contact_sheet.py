"""Private scientific visualization of actually rendered raw outputs, no image generation."""
from pathlib import Path
import json,hashlib,numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
D=Path(__file__).resolve().parent;O=D/'canary-output';kinds=['baseline','q16','q20'];colors=[];hdr=[]
for k in kinds:
 p=O/(k+'-front');manifest=json.loads(Path(str(p)+'.PASS.json').read_text());assert manifest['status']=='PASS'
 for ext in ['.u16le','.hdr.f64le']:assert hashlib.sha256(Path(str(p)+ext).read_bytes()).hexdigest()==manifest['files'][ext]
 z=np.fromfile(str(p)+'.u16le',dtype='<u2').reshape(135,240);colors.append(np.stack([((z>>11)&31)/31,((z>>5)&63)/63,(z&31)/31],axis=-1));hdr.append(np.fromfile(str(p)+'.hdr.f64le',dtype='<f8').reshape(135,240,3))
out=O/'actual-image-contact-sheet.png';assert not out.exists();fig,axs=plt.subplots(3,3,figsize=(16,10));
for i,k in enumerate(kinds):axs[0,i].imshow(colors[i],interpolation='nearest');axs[0,i].set_title(k+' actual RGB565 output')
axs[1,0].text(.04,.5,'RGB difference: abs(candidate − baseline) × 16\nDisplay-channel normalized values; clipped to [0,1].\nBlack = identical display value.\n\nHDR maps: max absolute linear-RGB channel error.\nShared linear scale across both candidates.\nNo shadow equivalence claim.',va='center',fontsize=11);axs[2,0].axis('off')
errors=[np.max(np.abs(hdr[i]-hdr[0]),axis=2) for i in [1,2]];maximum=max(float(e.max()) for e in errors)
for i in [1,2]:
 axs[1,i].imshow(np.clip(np.abs(colors[i]-colors[0])*16,0,1),interpolation='nearest');axs[1,i].set_title(kinds[i]+' RGB difference ×16')
 im=axs[2,i].imshow(errors[i-1],vmin=0,vmax=maximum or 1,cmap='magma',interpolation='nearest');axs[2,i].set_title(kinds[i]+' HDR max-channel absolute error');fig.colorbar(im,ax=axs[2,i],fraction=.035,pad=.025)
for a in axs.flat:a.set_xticks([]);a.set_yticks([])
fig.suptitle('Private geometry-only canary: unchanged shading, front view, floor-world ON',fontsize=16);fig.tight_layout();fig.savefig(out,dpi=160);plt.close(fig)
print(out)
