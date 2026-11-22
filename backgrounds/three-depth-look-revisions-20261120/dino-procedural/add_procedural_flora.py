"""Add editable native Geometry Nodes plant scatter and readable near fern fronds."""
import argparse, bpy, math, random, sys
from pathlib import Path
from mathutils import Vector
from random import Random
p=argparse.ArgumentParser();p.add_argument('source');p.add_argument('--draft',action='store_true')
a=p.parse_args(sys.argv[sys.argv.index('--')+1:])
root=Path(__file__).resolve().parent
bpy.ops.wm.open_mainfile(filepath=str(Path(a.source).resolve()))
s=bpy.context.scene;cam=s.camera
def mat(n,rgb,highlight=0.0):
    o=bpy.data.materials.new(n);o.diffuse_color=(*rgb,1);o.use_nodes=True
    bs=o.node_tree.nodes.get('Principled BSDF')
    bs.inputs['Base Color'].default_value=(*rgb,1);bs.inputs['Roughness'].default_value=.5
    bs.inputs['Subsurface Weight'].default_value=.08
    bs.inputs['Emission Color'].default_value=(*rgb,1);bs.inputs['Emission Strength'].default_value=highlight
    return o
green=[mat('Fern shadow jade',(.061,.22,.043),.25),mat('Fern lit edge',(.185,.445,.054),.32),mat('Fern vein',(.37,.61,.16),.27)]
new=bpy.data.collections.new('Procedural forest planted pockets');s.collection.children.link(new)
near=bpy.data.collections.new('Readable camera-near fern fronds');s.collection.children.link(near)
assets=bpy.data.collections.new('Geometry Nodes editable prototype plants');s.collection.children.link(assets)
def mesh(n,verts,faces,mats,c,ids=None):
    me=bpy.data.meshes.new(n);me.from_pydata(verts,[],faces);me.update()
    o=bpy.data.objects.new(n,me);c.objects.link(o)
    for k in mats:me.materials.append(k)
    if ids is not None:
        for poly,i in zip(me.polygons,ids):poly.material_index=i
    return o
def frond(verts,faces,ids,base,tip,axis,spread,count,depth,gold=0):
    a,b,side=Vector(base),Vector(tip),Vector(axis)
    def stem(t):return a.lerp(b,t)+Vector(depth)*math.sin(math.pi*t)
    def blade(x,y,w,h,col):
        ix=len(verts); vv=(x+y)/2+Vector(h)
        v=Vector(w)
        verts.extend([x,x.lerp(y,.47)+v,y,x.lerp(y,.47)-v,vv])
        faces.extend([(ix,ix+1,ix+4),(ix+1,ix+2,ix+4),(ix+2,ix+3,ix+4),(ix+3,ix,ix+4)])
        ids.extend([col,1-col,1-col,col])
    # Tapering rachis gives the fern a shape even at 240 px.
    for j in range(count):
        t=(j+.55)/(count+.7);u=stem(t)
        v=stem(min(.995,t+.14))
        w=spread*(math.sin(math.pi*t)**.74)*(1-.40*t)
        taper=spread*.012+spread*.025*(1-t)
        i=len(verts)
        verts.extend([stem(j/count)-side*taper,stem(j/count)+side*taper,stem((j+1)/count)+side*taper,stem((j+1)/count)-side*taper])
        faces.append((i,i+1,i+2,i+3));ids.append(2)
        for sign in (-1,1):
            end=v+side*(sign*w)
            blade(u,end,(b-a).normalized()*w*.23,Vector(depth)*.055,(j+sign+gold)%2)
def prototype(seed,name,fronds,extent,width):
    rng=Random(seed);v=[];f=[];m=[]
    for k in range(fronds):
        q=k*math.tau/fronds+rng.uniform(-.22,.22)
        ell=extent*rng.uniform(.67,1.18)*(0.75 if k%4==0 else 1)
        vec=Vector((math.cos(q),math.sin(q),0))
        tip=vec*ell+Vector((0,0,rng.uniform(.47,.98)*ell))
        front=Vector((-vec.y,vec.x,0))
        frond(v,f,m,(0,0,.026),tip,front,width*rng.uniform(.76,1.22),8,(0,0,ell*.30),k)
    o=mesh(name,v,f,green,assets,m)
    o.location=(0,250,-160)
    return o
proto_fern=prototype(121,'Prototype: paired fern leaflets',9,1.47,.55)
proto_cycad=prototype(844,'Prototype: wide cycad fronds',7,1.27,.61)
def plant_patch(o_name,rects,proto,density,seed,sz_min,sz_max):
    v=[];f=[]
    for x0,x1,y0,y1,z in rects:
        j=len(v);v.extend([(x0,y0,z),(x1,y0,z),(x1,y1,z),(x0,y1,z)]);f.append((j,j+1,j+2,j+3))
    o=mesh(o_name,v,f,[],new)
    nt=bpy.data.node_groups.new(o_name+' | native scattering','GeometryNodeTree')
    nt.interface.new_socket(name='Geometry',in_out='INPUT',socket_type='NodeSocketGeometry')
    nt.interface.new_socket(name='Geometry',in_out='OUTPUT',socket_type='NodeSocketGeometry')
    for nm,kind,default in [('Density','NodeSocketFloat',density),('Seed','NodeSocketInt',seed),('Scale min','NodeSocketFloat',sz_min),('Scale max','NodeSocketFloat',sz_max)]:
        z=nt.interface.new_socket(name=nm,in_out='INPUT',socket_type=kind);z.default_value=default
    ns=nt.nodes;ln=nt.links
    i=ns.new('NodeGroupInput');i.location=(-690,140)
    out=ns.new('NodeGroupOutput');out.location=(310,140)
    d=ns.new('GeometryNodeDistributePointsOnFaces'); d.distribute_method='RANDOM';d.location=(-455,220)
    d.label='Scatter only inside the hand-placed ground patches'
    obj=ns.new('GeometryNodeObjectInfo');obj.transform_space='ORIGINAL';obj.inputs['Object'].default_value=proto;obj.location=(-460,-20)
    v=ns.new('FunctionNodeRandomValue');v.data_type='FLOAT';v.location=(-450,-255)
    rot=ns.new('FunctionNodeRandomValue');rot.data_type='FLOAT_VECTOR';rot.location=(-448,-490)
    rot.inputs['Min'].default_value=(0,0,0);rot.inputs['Max'].default_value=(0,0,math.tau)
    inst=ns.new('GeometryNodeInstanceOnPoints');inst.location=(20,155)
    def link(a,an,b,bn):ln.new(a.outputs[an],b.inputs[bn])
    link(i,'Geometry',d,'Mesh');link(i,'Density',d,'Density');link(i,'Seed',d,'Seed')
    link(i,'Scale min',v,'Min');link(i,'Scale max',v,'Max')
    link(d,'Points',inst,'Points');link(obj,'Geometry',inst,'Instance')
    link(v,'Value',inst,'Scale');link(rot,'Value',inst,'Rotation');link(inst,'Instances',out,'Geometry')
    mod=o.modifiers.new('Editable fern distribution','NODES');mod.node_group=nt
    return o
# Replace only the generic round understory, keep distant canopy, dinos and layout.
for x in s.objects:
    if x.name.startswith(('Jungle understory','Lens-close')):
        x.hide_render=True;x.hide_set(True)
plant_patch('Mossy foreground islands', [(-14.8,-4.3,-8.0,-1.8,.013),(3.1,13.0,-7.0,-.8,.011)],proto_fern,.38,63,.68,1.16)
plant_patch('Midground cycad banks',[(-15.3,-7.1,1,9,.021),(-6.0,2.6,6,12,.017),(8.55,16.7,4.5,11,.015)],proto_cycad,.25,28,.67,1.48)
plant_patch('Far forest ground layer',[(-23.0,23.0,11.6,25.5,.02)],proto_fern,.084,403,.70,1.64)
# These near-camera meshes are intentionally larger and only softly defocused.
bpy.context.view_layer.update()
def ccam(x,y,dist):
    k=dist*cam.data.sensor_width/cam.data.lens/240.0
    return cam.matrix_world @ Vector(((x-120)*k,(67.5-y)*k,-dist))
def fern_screen(n,base,tip,width,seed):
    v=[];f=[];m=[]
    b=Vector(base);t=Vector(tip);q=t-b
    for j in range(10):
        u=j/10.0;w=(j+1)/10.0
        f.append(tuple(range(len(v),len(v)+4)));m.append(2)
        vv=b.lerp(t,u);ww=b.lerp(t,w)
        for px,py in [(vv.x-1.0,vv.y),(vv.x+1.0,vv.y),(ww.x+.76,ww.y),(ww.x-.76,ww.y)]:
            v.append(ccam(px,py,2.84))
        for sign in (-1,1):
            u=(j+.45)/10;mid=b.lerp(t,u)+Vector((-1.6,0))
            if j==0:continue
            sw=width*math.sin(math.pi*u)**.69*(1-.29*u)
            ort=Vector((q.y,-q.x)).normalized()
            endpoint=mid+q.normalized()*(6.0+(1-u)*9.0)+ort*(sign*sw)
            cv=endpoint-mid;h=Vector((cv.y,-cv.x)).normalized()*(3.1*(1-.54*u))
            i=len(v);v.extend(ccam(x.x,x.y,2.84+(0.085 if ii==4 else 0)) for ii,x in enumerate([mid,mid+cv*.51+h,endpoint,mid+cv*.5-h,mid+cv*.61]))
            f.extend([(i,i+1,i+4),(i+1,i+2,i+4),(i+2,i+3,i+4),(i+3,i,i+4)]);m.extend([(j+sign+seed)%2,1,0,1])
    o=mesh(n,v,f,green,near,m);o['camera_near_layer']=True
fern_screen('Near left fern | readable leaflets',(-13,139),(36,39),18,3)
fern_screen('Near left smaller fern',(-9,137),(26,77),12,5)
fern_screen('Near right hanging fern',(261,-4),(191,43),14,11)
s['flora_notes']='Native Geometry Nodes scatter, fern and cycad prototypes, three editable placement patches, optical close-camera foliage; no external add-on.'
s.cycles.use_denoising=False;s.cycles.samples=40 if a.draft else 320
s.render.image_settings.color_mode='RGB'; s.render.image_settings.file_format='PNG';s.render.film_transparent=False
s.render.filepath='//dino-procedural-240x135.png'
if a.draft:s.render.filepath=str(root/'draft.png')
else:
    bpy.context.preferences.filepaths.save_version=0
    dest=root/'dino-procedural.blend';bpy.ops.wm.save_as_mainfile(filepath=str(dest),compress=True)
    bpy.ops.wm.open_mainfile(filepath=str(dest))
    s=bpy.context.scene
    assert len([o for o in s.objects if any(m.type=='NODES' for m in o.modifiers)])==3
bpy.ops.render.render(write_still=True)
