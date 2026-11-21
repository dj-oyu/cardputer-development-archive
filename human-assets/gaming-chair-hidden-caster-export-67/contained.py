from collections import defaultdict
import bpy,sys,json
from mathutils import Vector
from pathlib import Path
P=Path(__file__).resolve().parent
o=next(o for o in bpy.context.scene.objects if o.name.startswith('Engine chair • shell'));m=o.data
conn=defaultdict(list)
for e in m.edges:
 a,b=e.vertices;conn[a].append(b);conn[b].append(a)
result=[]
se=set()
for k in range(len(m.vertices)):
 if k in se:continue
 C=set();Q=[k]
 while Q:
  j=Q.pop()
  if j in C:continue
  C.add(j);Q+=list(set(conn[j])-C)
 se|=C
 faces=[f for f in m.polygons if f.vertices[0] in C];cent=sum((m.vertices[x].co for x in C),Vector())/len(C)
 edged=defaultdict(int);planes=[]
 for f in faces:
  vx=tuple(f.vertices)
  for z,w in zip(vx,vx[1:]+vx[:1]):edged[tuple(sorted((z,w)))]+=1
  p=m.vertices[vx[0]].co.copy();n=f.normal.copy()
  if (cent-p).dot(n)>0:n=-n
  if max(abs((m.vertices[i].co-p).dot(n)) for i in vx)>1e-5:n=None
  if n is not None:planes.append((p,n))
 convex=len(planes)==len(faces) and all(e==2 for e in edged.values()) and all(max((m.vertices[i].co-p).dot(n) for p,n in planes)<1e-5 for i in C)
 result.append((k,faces,planes,convex))
hidden={13,52,61,65,82,88,96,102,110,116,124,130,133,139}
for tag,fs,ps,cv in result:
 for f in fs:
  if f.index not in hidden:continue
  candidates=[]
  for k2,_,p2,cv2 in result:
   if k2==tag or not cv2:continue
   worst=max((m.vertices[i].co-p).dot(n) for i in f.vertices for p,n in p2)
   candidates.append((worst,k2))
  a,b=min(candidates)
  print('Contained-by-one-convex-solid',f.index,round(a,6),b,'strictly_inside',a<-.0001)
