"""Run in Blender: blender -b -t 2 --python build_chair.py"""
import bpy
from math import pi, sin, cos
from pathlib import Path
from mathutils import Vector
path=Path(__file__).resolve().parent
bpy.ops.wm.read_factory_settings(use_empty=True)
verts=[]; faces=[]; idx=[]
palette=[("Chair • graphite shell",(.052,.060,.083)),("Chair • storm teal upholstery",(.090,.205,.234)),("Chair • dark hardware",(.084,.089,.113)),("Chair • golden welt",(.95,.37,.035)),("Chair • steel",(.20,.224,.262))]
def loft(a,b,mat,front_mat=None):
    k=len(verts); n=len(a); verts.extend(a+b)
    faces.extend([tuple(range(k+n-1,k-1,-1)),tuple(range(k+n,k+2*n))])
    idx.extend([mat,mat if front_mat is None else front_mat])
    for i in range(n):
        j=(i+1)%n
        faces.append((k+i,k+j,k+n+j,k+n+i));idx.append(mat)
def octagon(xlo,xhi,ylo,yhi,c):
    return [(xlo+c,ylo),(xhi-c,ylo),(xhi,ylo+c),(xhi,yhi-c),(xhi-c,yhi),(xlo+c,yhi),(xlo,yhi-c),(xlo,ylo+c)]
def pad(xlo,xhi,ylo,yhi,zlo,zhi,c,mat,top=None):
    outline=octagon(xlo,xhi,ylo,yhi,c)
    loft([(x,y,zlo) for x,y in outline],[(x,y,zhi) for x,y in outline],mat,top)
def panel(outline,front,back,mat,lining=None):
    # XZ perimeter, front and rear Y offset assumed positive to rear.
    loft([(x,back(x,z),z) for x,z in outline],[(x,front(x,z),z) for x,z in outline],mat,lining)
def pole(zlo,zhi,r0,r1,n,mat):
    a=[(r0*cos(i*2*pi/n),-.10+r0*sin(i*2*pi/n),zlo) for i in range(n)]
    b=[(r1*cos(i*2*pi/n),-.10+r1*sin(i*2*pi/n),zhi) for i in range(n)]
    loft(a,b,mat)
# Seat shell and top upholstered surface (z=1.373)
pad(-.72,.72,-.92,.48,1.15,1.373,.15,0,1)
# Tall bucket silhouette with integrated taper into headrest. Contact surface
# pitches rearward as height increases.
def front(x,z): return .39+.285*(z-1.6)
outline=[(-.57,1.30),(.57,1.30),(.73,2.17),(.79,2.88),(.61,3.26),(.42,3.32),(.36,3.64),(-.36,3.64),(-.42,3.32),(-.61,3.26),(-.79,2.88),(-.73,2.17)]
panel(outline,front,lambda x,z: front(x,z)+.18,0,1)
for s in [-1,1]:
    def side(v):
        a=[(x*s,z) for x,z in v]
        return a if s==1 else a[::-1]
    panel(side([(.49,1.38),(.68,1.38),(.72,2.18),(.77,2.90),(.59,3.22),(.54,2.88)]),
          lambda x,z:front(x,z)-.14, lambda x,z:front(x,z)+.045,0)
    strip=side([(.67,2.48),(.70,2.51),(.74,2.90),(.64,3.10),(.61,3.06),(.70,2.90)])
    k=len(verts)
    verts.extend([(x,front(x,z)-.144,z) for x,z in strip])
    faces.append(tuple(range(k,k+len(strip))));idx.append(3)
    # Small armrests; edge bevels omitted to reserve triangles.
    xlo,xhi=sorted([s*.75,s*.93]); y0,y1=-.64,-.17
    for a,b,c,d,e,f,m in [(xlo,xhi,y0,y1,1.88,1.951,2),(s*.83-.065,s*.83+.065,-.22,-.02,1.34,1.89,2)]:
        outline=[(a,c),(b,c),(b,d),(a,d)]
        loft([(x,y,e) for x,y in outline],[(x,y,f) for x,y in outline],m)
pole(.40,1.21,.09,.13,6,4)
# Five caster arms, each a single tapered prism; fitted low to make
# the seat visibly read as a swivel chair rather than a stool.
for i in range(5):
    theta=-pi/2+2*pi*i/5
    ux,uy=cos(theta),sin(theta); vx,vy=-uy,ux
    def p(r,w,z):return (r*ux+w*vx,-.10+r*uy+w*vy,z)
    loft([p(.04,-.10,.31),p(.04,.10,.31),p(.86,.075,.05),p(.86,-.075,.05)],
         [p(.04,-.10,.51),p(.04,.10,.51),p(.86,.10,.26),p(.86,-.10,.26)],2)
    # Re-use the existing outward face for the caster's darker tone.
    idx[-2]=0
mesh=bpy.data.meshes.new("Compact gaming chair geometry")
mesh.from_pydata(verts,[],faces);mesh.update()
for name,rgb in palette:
    m=bpy.data.materials.new(name);m.diffuse_color=(*rgb,1)
    mesh.materials.append(m)
for face,i in zip(mesh.polygons,idx):face.material_index=i
# Consistent outward normals for separately closed components in one object.
import bmesh
bm=bmesh.new();bm.from_mesh(mesh);bmesh.ops.recalc_face_normals(bm,faces=list(bm.faces));bm.to_mesh(mesh);bm.free()
mesh.calc_loop_triangles()
obj=bpy.data.objects.new("Gaming Chair • low-poly",mesh)
collection=bpy.data.collections.new("Gaming Chair Prop")
bpy.context.scene.collection.children.link(collection);collection.objects.link(obj)
obj["source"]="build_chair.py"
obj["forward_axis"]="-Y"
obj["seat_surface_z"]=1.373
obj["seat_back_contact_y_at_z1_6"]= .39
obj["triangles"]=len(mesh.loop_triangles)
bpy.context.scene.unit_settings.system='NONE'
bpy.ops.wm.save_as_mainfile(filepath=str(path/"gaming-chair-45.blend"))
print("chair triangles",len(mesh.loop_triangles),"verts",len(mesh.vertices))
