"""Reversible chair-only rectangles. Preserve aperture/dash mesh + all other geometry."""
from pathlib import Path
import bpy,sys,os
P=Path(__file__).resolve().parent
stage=os.getenv('SHAPE','mixed')
s=bpy.context.scene
o=next(o for o in s.objects if o.name.startswith('Engine chair • shell'))
m=o.data
changed=[(72,87),(96,111)]
if stage in ('mixed','rect'):changed.append((56,71))
if stage=='caps':changed=[]
skip=set(z for l,h in changed for z in range(l,h+1))
ret=list(v.index for v in m.vertices if v.index not in skip);lookup={z:k for k,z in enumerate(ret)}
vs=[m.vertices[z].co[:] for z in ret];faces=[];ids=[];smooth=[]
for f in m.polygons:
 src=tuple(f.vertices)
 if set(src)&skip:
  assert set(src)<=skip;continue
 if stage=='caps' and len(src)==8 and (set(src)<=set(range(56,72)) or set(src)<=set(range(72,88)) or set(src)<=set(range(96,112))):
  z=max(m.vertices[i].co.z for i in src)
  if any(abs(z-h)<1e-4 for h in (1.15,1.887)):continue
 faces.append(tuple(lookup[v] for v in src));ids.append(f.material_index);smooth.append(f.use_smooth)
def extrusion(group,z0,z1,caps,sides):
 p=len(vs);n=len(group);vs.extend([(x,y,z) for z in (z0,z1) for (x,y) in group])
 faces.extend([tuple(reversed(range(p,p+n))),tuple(range(p+n,p+2*n))]);ids.extend(caps);smooth.extend([False,False])
 for j in range(n):
  k=(j+1)%n;faces.append((p+j,p+k,p+n+k,p+n+j));ids.append(sides);smooth.append(False)
if stage!='caps':
 for x0,x1 in ((-.93,-.75),(.75,.93)):
  extrusion([(x0,-.64),(x1,-.64),(x1,-.17),(x0,-.17)],1.887,1.951,(3,3),3)
if stage in ('mixed','rect'):
 if stage=='mixed':pts=[(-.57,-.92),(.57,-.92),(.72,-.77),(.72,.48),(-.72,.48),(-.72,-.77)]
 else:pts=[(-.72,-.92),(.72,-.92),(.72,.48),(-.72,.48)]
 extrusion(pts,1.15,1.373,(0,1),0)
n=bpy.data.meshes.new(m.name+' v66-'+stage);n.from_pydata(vs,[],faces);n.update()
for q in m.materials:n.materials.append(q)
for f,i,a in zip(n.polygons,ids,smooth):f.material_index=i;f.use_smooth=a
o.data=n
tris=sum(len(f.vertices)-2 for k in bpy.data.collections['Gaming Chair Prop'].all_objects if k.type=='MESH' for f in k.data.polygons)
s['v66_opt']='Chair-only '+stage+' native silhouette validation; rear aperture, bracket gauge and license untouched.'
print('EXPECTED_TRIANGLES',tris,stage)
bpy.context.preferences.filepaths.save_version=0;bpy.ops.wm.save_as_mainfile(filepath=str(P/f'chair-rect-v66-{stage}.blend'),compress=True)
