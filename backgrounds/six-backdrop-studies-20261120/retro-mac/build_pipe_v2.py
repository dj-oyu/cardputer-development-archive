import bpy, math, sys, random, hashlib, json
from mathutils import Vector
from pathlib import Path
a=sys.argv[sys.argv.index('--')+1:] if '--' in sys.argv else []
root=Path(__file__).resolve().parent
variant=a[0] if a else 'all'
def scene(path):
    bpy.ops.wm.read_factory_settings(use_empty=True)
    s=bpy.context.scene
    s.render.engine='CYCLES'
    s.cycles.samples=72 if variant!='mac' else 12
    s.cycles.use_adaptive_sampling=True
    s.cycles.use_denoising=False
    s.cycles.adaptive_threshold=.025
    s.render.resolution_x=240;s.render.resolution_y=135;s.render.resolution_percentage=100
    s.render.film_transparent=False;s.render.image_settings.color_mode='RGB'
    s.render.image_settings.file_format='PNG'
    s.render.filepath=str(root/(path+'.png'))
    s.view_settings.view_transform='Standard'
    s.world=bpy.data.worlds.new('Stage ambient');s.world.use_nodes=True
    return s
def mat(n,c,rough=.4,met=0,glow=False):
    m=bpy.data.materials.new(n);m.diffuse_color=(*c,1);m.use_nodes=True
    nt=m.node_tree
    if glow:
        p=nt.nodes.new('ShaderNodeEmission');p.inputs[0].default_value=(*c,1);nt.links.new(p.outputs[0],nt.nodes['Material Output'].inputs['Surface'])
    else:
        p=nt.nodes.get('Principled BSDF');p.inputs['Base Color'].default_value=(*c,1);p.inputs['Roughness'].default_value=rough;p.inputs['Metallic'].default_value=met
    return m
def box(n,loc,size,m,b=.0):
    bpy.ops.mesh.primitive_cube_add(size=1,location=loc);o=bpy.context.object;o.name=n;o.dimensions=size
    bpy.ops.object.transform_apply(location=False,rotation=False,scale=True)
    o.data.materials.append(m)
    if b:
        v=o.modifiers.new('Soft edges','BEVEL');v.width=b;v.segments=3
        w=o.modifiers.new('Corner normals','WEIGHTED_NORMAL')
    return o
def lines(n,pts,r,m):
    cu=bpy.data.curves.new(n,'CURVE');cu.dimensions='3D';cu.bevel_depth=r;cu.bevel_resolution=5;cu.resolution_u=14
    s=cu.splines.new('BEZIER');s.bezier_points.add(len(pts)-1)
    for p,v in zip(s.bezier_points,pts):p.co=v;p.handle_left_type='AUTO';p.handle_right_type='AUTO'
    o=bpy.data.objects.new(n,cu);bpy.context.scene.collection.objects.link(o);cu.materials.append(m);return o
def cyl(n,x,y,z,r,d,m):
    bpy.ops.mesh.primitive_cylinder_add(vertices=40,radius=r,depth=d,location=(x,y,z));o=bpy.context.object;o.name=n;o.data.materials.append(m)
    for p in o.data.polygons:p.use_smooth=(len(p.vertices)==4)
    return o
def turn(o,p):o.rotation_euler=(Vector(p)-o.location).to_track_quat('-Z','Y').to_euler()
def spot(n,p,dst,power,color,size=3):
    d=bpy.data.lights.new(n,'AREA');d.energy=power;d.color=color;d.shape='DISK';d.size=size;o=bpy.data.objects.new(n,d);bpy.context.collection.objects.link(o);o.location=p;turn(o,dst)
def save(name):
    s=bpy.context.scene
    bpy.context.preferences.filepaths.save_version=0
    out=root/(name+'.blend')
    bpy.ops.wm.save_as_mainfile(filepath=str(out),compress=True)
    bpy.ops.wm.open_mainfile(filepath=str(out))
    bpy.context.scene.render.filepath=str(root/(name+'.png'))
    bpy.ops.render.render(write_still=True)
    sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
    (root/(name+'-validation.json')).write_text(json.dumps({'blend_sha256':sha(out),'png_sha256':sha(root/(name+'.png')),'resolution':[240,135],'format':'RGB8 opaque','engine':bpy.context.scene.render.engine,'no_actor_assets':True},indent=2)+'\n')
def pipe():
    s=scene('pipe-dream-room-v2');s.view_settings.view_transform='AgX';s.view_settings.look='AgX - Medium High Contrast';s.cycles.samples=144
    s.world.node_tree.nodes['Background'].inputs[0].default_value=(.08,.11,.16,1)
    s.world.node_tree.nodes['Background'].inputs[1].default_value=.26
    navy=mat('Deep Prussian stage paint',(.095,.14,.20),.45)
    teal=mat('Desaturated blue enamel',(.021,.22,.37),.25,.38)
    iron=mat('Blued steel',(.06,.13,.21),.28,.58)
    brass=mat('Burnished brass',(.76,.43,.135),.20,.73)
    copper=mat('Varnished copper',(.61,.225,.085),.27,.65)
    cream=mat('Ivory hammer heads',(.77,.59,.34),.33)
    dark=mat('Bakelite / acoustic felt',(.02,.037,.05),.56)
    red=mat('Vermilion drum shells',(.74,.033,.016),.25,.32)
    white=mat('Vintage drum skins',(.61,.52,.37),.48)
    silver=mat('Chromed steel balls',(.77,.84,.90),.12,.94)
    maple=[mat('Amber plank %d'%i,(.15+i*.018,.076+i*.011,.039+i*.005),.36) for i in range(5)]
    rng=random.Random(330)
    box('Backdrop wall',(0,4.2,3.5),(17,.25,7.0),navy)
    for i in range(18):
        box('Maple stage plank',((i-8.5)*.87,-.3,-.052),(.862,8,.10),rng.choice(maple))
    for i in range(0,13):
        x=-7.6+i*1.25
        box('Inset slat',(x,4.0,3.1),(.035,.10,6.1),iron)
    box('Blue back-stage skirting',(0,3.95,.45),(16,.31,.45),teal,.08)
    # Framing ribs give a recognisable bank of pneumatic instruments.
    for side in [-1,1]:
        for i in range(4):
            x=side*(4.0+i*.54);h=3.5+i*.56; y=1.2+i*.10
            col=brass if side>0 and i%2==0 else copper if i%2==0 else teal
            lines('Pneumatic intake',[(x+side*.38,y,.52),(x,y,.93),(x,y,h-.38),(x-side*.26,y,h),(x-side*.70,y,h)],.105,col)
            cyl('Speaker cup',x-side*.70,y,h,.16,.12,col).rotation_euler[0]=math.pi/2
            for z in [1.12,h-.62]:
                cyl('Machined coupling',x,y,z,.145,.14,iron)
            a=cyl('Pipe pedestal',x+side*.35,y,.18,.26,.30,dark)
        box('Independent instrument cabinet',(side*5.25,1.28,.39),(2.5,1.1,.77),iron,.10)
    for j in range(11):
        x=-6.25+j*.26
        wood=box('Mallet bar',(x,.66,.98+(j%2)*.04),(.213,.77+j*.018,.14),brass if j%2 else copper,.036)
        wood.rotation_euler[0]=-.12
        cyl('Resonator',x,.72,.58,.091,.63-(j*.015),teal)
    for x,y,z,r in [(4.15,.62,.68,.66),(5.42,.96,.78,.56),(6.56,1.16,.67,.45)]:
        cyl('Tuned drum body',x,y,z,r,.76,red)
        cyl('Brass drum hoop',x,y,z+.38,r+.035,.095,brass)
        cyl('Skin',x,y,z+.427,r-.07,.02,white)
        cyl('Drum foot',x,y,.148,.21,.33,iron)
    for i,(x,y,z) in enumerate([(-4.4,.2,2.7),(-3.72,.1,2.29),(-3.18,.12,1.72),(3.88,.30,3.2),(4.35,.40,2.88),(4.56,.27,2.29),(4.88,.13,1.68)]):
        bpy.ops.mesh.primitive_uv_sphere_add(segments=24,ring_count=12,radius=.115 if i%2 else .14,location=(x,y,z))
        o=bpy.context.object;o.name='Suspended chrome ball';o.data.materials.append(silver)
        for p in o.data.polygons:p.use_smooth=True
    vermilion=mat('Painted red header pipe',(.8,.035,.020),.22,.22)
    gold=mat('Polished yellow brass',(.87,.55,.135),.18,.59)
    litgold=mat('Gold signal trace',(.60,.28,.042),glow=True)
    frost=mat('Pinball hot highlight',(.69,.92,1),glow=True)
    for side in (-1,1):
        loc=side*5.55
        lines('Large painted cistern main',[(loc+.65*side,-.18,.14),(loc+.45*side,-.18,1.42),(loc+.15*side,-.18,2.25),(loc+.00*side,-.17,4.21),(loc-.55*side,-.06,5.05),(loc-1.64*side,.08,5.13)],.235,vermilion)
        lines('Parallel copper feed',[(loc-1.40*side,.22,.16),(loc-1.09*side,.3,1.4),(loc-.96*side,.3,3.15),(loc-1.20*side,.21,4.20),(loc-1.89*side,.06,4.42)],.145,copper)
        for z in (1.3,3.0,3.75):
            cyl('Wide machined red collar',loc+.08*side,-.18,z,.275,.15,gold)
        # Bell nozzles open toward camera plus inward travel of chrome pinballs.
        for x,y,z,r in [(loc-1.64*side,.08,5.13,.36),(loc-1.89*side,.06,4.42,.25)]:
            ob=cyl('Flared ejector collar',x,y-.06,z,r,.26,gold);ob.rotation_euler[0]=math.pi/2
            ob=cyl('Dark ejector bore',x,y-.212,z,r*.74,.035,dark);ob.rotation_euler[0]=math.pi/2
        # Rings and bundles under each playable instrument.
        for j in range(3):
            p=loc-(.60+j*.52)*side
            lines('Linked water manifold',[(p,-.9,.22),(p,-.36,.36+j*.12),(p+.5*side,.2,.49),(p+.32*side,1.5,.62)],.085,teal if j%2 else gold)
    # Track positions tell the eye which tubes shoot toward which instruments.
    rail_left=[(-3.90,-.18,5.08),(-3.60,-.48,4.68),(-3.52,-.54,4.14),(-3.74,-.56,3.57),(-4.10,-.58,2.87),(-4.68,-.55,1.50)]
    rail_right=[(3.71,-.12,4.43),(3.61,-.64,4.00),(3.82,-.84,3.52),(4.12,-.96,2.89),(4.55,-1.02,2.16),(5.03,-.97,1.45)]
    for j,rail in enumerate((rail_left,rail_right)):
        for i,(x,y,z) in enumerate(rail):
            bpy.ops.mesh.primitive_uv_sphere_add(segments=24,ring_count=12,radius=.17+(i%3)*.018,location=(x,y,z))
            o=bpy.context.object;o.name='Chrome ball at frozen flight phase';o.data.materials.append(silver)
            for f in o.data.polygons:f.use_smooth=True
            bpy.ops.mesh.primitive_uv_sphere_add(segments=14,ring_count=8,radius=.041,location=(x-.08,y-.135,z+.07))
            bpy.context.object.name='Crisp glint on ball';bpy.context.object.data.materials.append(frost)
        for a0,b0 in zip(rail,rail[1:]):
            p=Vector(a0).lerp(Vector(b0),.31);q=Vector(a0).lerp(Vector(b0),.56)
            lines('Thin light echo on flight path',[p,q],.016,litgold)
    for j in range(13):
        x=-6.35+j*.23
        b=box('Wide foreground xylophone bar',(x,-.62,.74),(.18,.94+j*.030,.19),gold if j%2 else copper,.042)
        b.rotation_euler[0]=-.14
    for x,y,z,rr in [(4.69,-.75,.58,.78),(6.06,-.51,.53,.63)]:
        cyl('Closer floor tom',x,y,z,rr,.8,red)
        cyl('Reflecting skin rim',x,y,z+.42,rr+.04,.076,gold)
        cyl('Luminous ivory head',x,y,z+.47,rr-.05,.023,white)
    spot('Left hot gold glow',(-6.8,-4.7,6.6),(-5,.5,1.4),1400,(1,.72,.41),2.4)
    spot('Crisp mint edge',(6.0,-1.7,5),(4.6,1.2,2.1),1700,(.25,.87,1),2.3)
    spot('Left 90s warm key',(-6,-4,7),(-4,1,2),1700,(1,.67,.34),4.1)
    spot('Blue rim',(7,1,7),(4,1,2),2200,(.29,.63,1),3.2)
    spot('Amber low fill',(4,-5,4),(3,2,2),520,(1,.49,.30),4)
    spot('Soft central spill',(0,-2,7),(0,3,2),190,(.43,.63,1),5)
    d=bpy.data.cameras.new('Locked 16:9 camera');o=bpy.data.objects.new('Locked 16:9 camera',d);s.collection.objects.link(o)
    o.location=(0,-16.4,6.1);turn(o,(0,1.35,2.44));d.type='PERSP';d.lens=44;s.camera=o
    save('pipe-dream-room-v2')
pipe()
