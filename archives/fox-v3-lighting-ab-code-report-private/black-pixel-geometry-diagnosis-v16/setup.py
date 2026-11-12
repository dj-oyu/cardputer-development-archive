from pathlib import Path
import shutil,json
W=Path('/workspace/scratch/6d8dcdbcdc54');S=W/'fox-v16-subpixel-preview';D=W/'fox-v16-black-pixel-diagnostic'
for n in ['product','physical','visibility','transport','code']:shutil.copytree(S/n,D/n)
p=D/'product/main/ui/kasane/ksn_mesh_depth.c';s=p.read_text();s='#include <stdio.h>\nint blackdiag_x,blackdiag_y;\n'+s
s=s.replace('if(shader){if(!shader(', 'blackdiag_x=x;blackdiag_y=yy;\n                    if(shader){if(!shader(')
s=s.replace('unsigned q[3];for(unsigned k=0;k<3;k++)', '''if((x>=112&&x<=120&&yy>=60&&yy<=64)||(x>=116&&x<=120&&yy>=97&&yy<=101)||(x>=145&&x<=149&&yy>=96&&yy<=100)||(x>=100&&x<=104&&yy>=72&&yy<=76))fprintf(stderr,"WIN %d %d %u %u %d %.17g %.17g %.17g %.17g %.17g %.17g %.17g %.17g %.17g %.17g\\n",x,yy,view.node,face,back,(double)depth,position[0],position[1],position[2],nn[0],nn[1],nn[2],rho[0],rho[1],rho[2]);
                    unsigned q[3];for(unsigned k=0;k<3;k++)''')
p.write_text(s)
p=D/'transport/pixel_transport.c';s=p.read_text();s='#include <stdio.h>\nextern int blackdiag_x,blackdiag_y;\n'+s
s=s.replace('bounce_counters sum=c->counters;', '''int x=blackdiag_x,y=blackdiag_y;if((x>=112&&x<=120&&y>=60&&y<=64)||(x>=116&&x<=120&&y>=97&&y<=101)||(x>=145&&x<=149&&y>=96&&y<=100)||(x>=100&&x<=104&&y>=72&&y<=76)){fprintf(stderr,"LIGHT %d %d",x,y);for(int k=0;k<3;k++)fprintf(stderr," %.17g %.17g %.17g %.17g",r.direct[k],r.world[k],r.bounce[k],r.ground[k]);fprintf(stderr,"\\n");}
 bounce_counters sum=c->counters;''');p.write_text(s)
b=json.loads((S/'run-001/build.json').read_text())['command'];b=[v.replace(str(S),str(D)) for v in b];b[-1]=str(D/'native-render');(D/'build.json').write_text(json.dumps(b));
import subprocess
subprocess.run(b,check=True)
r=json.loads((W/'fox-v16-density-preview/run-001/result.json').read_text());a=r['command'];a[0]=str(D/'native-render');a[2]=str(D/'control');import os
e=dict(os.environ,HONE_LINEAR_LIGHT='1',HONE_PIXEL_LIGHT='1',HONE_PIXEL_VISIBILITY='1',HONE_TRANSPORT_MODE='2',HONE_OUTER_SAMPLES='16',HONE_GROUND_MODE='2',HONE_GROUND_FILE=str(W/'fox-v3-ground-transport/le-001/inputs/ground-baseline.txt'),HONE_DISK_FILE=str(W/'fox-v3-ground-transport/le-001/physical-baseline.txt'))
# take exact ground path from prior density script candidate config
cfg=json.loads((W/'fox-v3-ground-transport/le-001/inputs/candidate-config.json').read_text());e['HONE_GROUND_FILE']=str(W/'fox-v3-ground-transport/le-001'/next(x for x in cfg['scenarios'] if x['name']=='baseline')['ground']['inputFile'])
with (D/'control.stdout').open('w') as o,(D/'control.stderr').open('w') as er: p=subprocess.run(a,env=e,stdout=o,stderr=er)
print('return',p.returncode)
