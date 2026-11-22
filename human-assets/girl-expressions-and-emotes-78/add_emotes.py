"""Add the archive's shared manga shapes without changing the figure mesh or actions."""
import argparse, hashlib, sys
from pathlib import Path
import bpy
from mathutils import Matrix, Vector

p = argparse.ArgumentParser()
p.add_argument("--fox", type=Path, required=True)
p.add_argument("--out", type=Path, required=True)
a = p.parse_args(sys.argv[sys.argv.index("--")+1:])
assert hashlib.sha256(a.fox.read_bytes()).hexdigest() == "d3edde66f2c538388f544989fe16bc60c2d391fc519000bfa1ed9e49c6295d22"
assert not a.out.exists() and a.out.resolve() != Path(bpy.data.filepath).resolve()
s=bpy.context.scene
rig=next(o for o in s.objects if o.type == 'ARMATURE')
cam=s.camera
assert cam.data.type == 'PERSP' and abs(cam.data.shift_x)+abs(cam.data.shift_y)<1e-6
coll=bpy.data.collections.new("Shared comic symbols • Girl")
s.collection.children.link(coll)
names=("sweat","confusion","anger")
rig["Comic Emote"]=0
rig.id_properties_ui("Comic Emote").update(min=0,max=3,description="0: off • 1: sweat • 2: confusion • 3: anger")
# Use identical material IDs and silhouettes, except removal of four redundant
# samples per strip in the confusion mark to keep the character + active mark under 2k.
def thin_spiral(data):
    assert len(data.vertices)==100 and len(data.polygons)==48
    coords=[v.co.copy() for v in data.vertices]
    for j in range(48):
        k=2*j if j<24 else 50+2*(j-24)
        assert tuple(data.polygons[j].vertices)==(k,k+1,k+3,k+2)
    ids=list(range(25))
    def error(l,m,r):
        e=0
        for strip in (0,50):
            for edge in (0,1):
                A,B=coords[strip+2*l+edge],coords[strip+2*r+edge]
                D=B-A
                for j in range(l+1,r):
                    V=coords[strip+2*j+edge]-A
                    t=max(0.0,min(1.0,V.dot(D)/D.length_squared))
                    e=max(e,(V-t*D).length)
        return e
    for _ in range(4):
        _, j=min((error(ids[i-1],ids[i],ids[i+1]),i) for i in range(1,len(ids)-1))
        ids.pop(j)
    maxdev=max(error(x,0,y) for x,y in zip(ids,ids[1:]))
    vs=[coords[strip+2*j+edge] for strip in (0,50) for j in ids for edge in (0,1)]
    faces=[(k,k+1,k+3,k+2) for strip in (0,42) for j in range(20) for k in (strip+2*j,)]
    m=bpy.data.meshes.new("Shared confusion • tapered spiral")
    m.from_pydata(vs,[],faces)
    for mat in data.materials: m.materials.append(mat)
    for i,poly in enumerate(m.polygons): poly.material_index=i//20
    m.update()
    return m,maxdev
def var(d, target, prop, name):
    x=d.variables.new();x.name=name;x.type='SINGLE_PROP';x.targets[0].id=target;x.targets[0].data_path=prop
with bpy.data.libraries.load(str(a.fox.resolve())) as (_, out):
    out.objects=["Manga "+n for n in names]
for no,(name,src) in enumerate(zip(names,out.objects),1):
    mesh,dev=thin_spiral(src.data) if name=="confusion" else (src.data.copy(),0)
    x=[v.co.x for v in mesh.vertices]; z=[v.co.z for v in mesh.vertices]
    w=max(max(x)-min(x),max(z)-min(z))
    center=Vector(((max(x)+min(x))/2,0,(max(z)+min(z))/2))
    for v in mesh.vertices: v.co-=center
    mesh.calc_loop_triangles()
    count=len(mesh.loop_triangles)
    assert count==[20,80,64][no-1] and 1913+count <=2000
    o=bpy.data.objects.new("Comic emote • "+name,mesh);coll.objects.link(o)
    o["triangles"]=count
    o.parent=cam
    o.rotation_euler=Matrix(((1,0,0),(0,0,1),(0,-1,0))).to_euler()
    # The mesh's own front is -Y; rotate it toward the camera's local +Z.
    depth=3.0
    fov=cam.data.sensor_width*depth
    # Pixel anchors in a 240x135 frame, measured from lower left.
    px,py,extent=152.,105.,17.
    o.location=(0,0,-depth)
    for axis,v in enumerate((px-120,py-67.5)):
        d=o.driver_add('location',axis).driver;d.type='SCRIPTED';var(d,cam,'data.lens','lens')
        d.expression=f'{fov*v/240:.10g}/lens'
    for axis in range(3):
        d=o.driver_add('scale',axis).driver;d.type='SCRIPTED'
        var(d,rig,'["Comic Emote"]','sel');var(d,cam,'data.lens','lens')
        d.expression=f'{fov*extent/240/w:.10g} / lens if sel == {no} else 0'
    d=o.driver_add('hide_render').driver;d.type='SCRIPTED';var(d,rig,'["Comic Emote"]','sel')
    d.expression=f'sel != {no}'
    # Do not change render when the sticker is added (flat ink should not cast studio shadows).
    if hasattr(o,'visible_shadow'): o.visible_shadow=False
    if hasattr(o,'visible_diffuse'): o.visible_diffuse=False
    if hasattr(o,'visible_glossy'): o.visible_glossy=False
    bpy.data.objects.remove(src)
    print(name,count,"spiral edge subsampling maxpx",dev/w*extent)
s["Comic emotes"]="Choose Comic Emote on the character armature. One shared camera-facing symbol at a time, off by default."
rig.update_tag(); s.frame_set(s.frame_current); bpy.context.view_layer.update()
bpy.context.preferences.filepaths.save_version=0
bpy.ops.wm.save_as_mainfile(filepath=str(a.out.resolve()),compress=True)
