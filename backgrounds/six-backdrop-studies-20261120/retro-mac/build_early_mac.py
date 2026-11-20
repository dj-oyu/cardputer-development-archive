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
def mac():
    s=scene('early-mac-desktop');s.cycles.samples=12
    colors={k:mat(k,(v,v,v),glow=True) for k,v in [('lcd off black',.009),('desktop checker light',.155),('desktop checker dark',.116),('window white',.71),('title gray',.45),('inactive window',.26),('toolbar grey',.49),('hover shade',.32)]}
    black=colors['lcd off black'];white=colors['window white'];gray=colors['title gray'];desk=colors['desktop checker dark'];grid=colors['desktop checker light']
    def rect(n,x,y,w,h,z,m):
        me=bpy.data.meshes.new(n)
        me.from_pydata([(x,135-y-h,z),(x+w,135-y-h,z),(x+w,135-y,z),(x,135-y,z)],[],[(0,1,2,3)])
        ob=bpy.data.objects.new(n,me);s.collection.objects.link(ob);me.materials.append(m);return ob
    def text(n,x,y,msg,size,z=2,m=black):
        cv=bpy.data.curves.new(n,'FONT');cv.body=msg;cv.size=size;cv.align_x='LEFT';cv.align_y='TOP_BASELINE'
        ob=bpy.data.objects.new(n,cv);s.collection.objects.link(ob);ob.location=(x,135-y,z);cv.materials.append(m);return ob
    rect('Desktop base',0,0,240,135,0,desk)
    vs=[];fs=[]
    for y in range(13,135,2):
        for x in range(y%4//2,240,2):
            i=len(vs);vs.extend([(x,134-y,.03),(x+1,134-y,.03),(x+1,135-y,.03),(x,135-y,.03)]);fs.append((i,i+1,i+2,i+3))
    me=bpy.data.meshes.new('Stipple');me.from_pydata(vs,[],fs);me.materials.append(grid);o=bpy.data.objects.new('Editable monochrome stipple',me);s.collection.objects.link(o)
    rect('Menu bar black outline',0,0,240,13,4,black);rect('Menu bar off white',1,1,238,10,4.1,white)
    for x,label in [(15,'File'),(35,'Edit'),(56,'View'),(82,'Special')]:
        text('Menu '+label,x,8.5,label,7,4.4)
    # Draw an original tiny fruit emblem and 1-bit-inspired UI, no image textures.
    for r,line in enumerate(['....*..','...*...','.**.**.','******.','*****..','******.','.**.**.','..*.*..']):
        for c,k in enumerate(line):
            if k=='*':rect('Menu emblem pixel',4+c,2+r,1,1,4.5,black)
    def panel(n,x,y,w,h,z,active=True):
        rect(n+' shadow',x+2,y+2,w,h,z,black);rect(n+' boundary',x,y,w,h,z+.02,black)
        rect(n+' content',x+1,y+1,w-2,h-2,z+.03,white if active else colors['inactive window'])
        rect(n+' separator',x+1,y+13,w-2,1,z+.05,black)
        for u in [2,4,6,8,10,12]:
            rect(n+' title stripe',x+2,y+u,w-4,1,z+.06,gray if active else desk)
        rect(n+' title backing',x+12,y+2,w-24,10,z+.08,white if active else gray)
        rect(n+' close box',x+4,y+4,6,6,z+.1,black);rect(n+' close inset',x+5,y+5,4,4,z+.11,white)
        text(n+' title',x+15,y+10,n,8,z+.115)
        if active:
            rect(n+' scrollbar border',x+w-9,y+14,1,h-15,z+.07,black)
            rect(n+' scrollbar track',x+w-8,y+15,6,h-17,z+.08,gray)
            rect(n+' scrollbar thumb',x+w-7,y+20,4,11,z+.09,white)
    panel('Desktop',37,36,108,67,.25,False)
    panel('System Folder',7,20,100,78,.58,True)
    def icon(n,x,y,pixels,z):
        for r,line in enumerate(pixels):
            for c,k in enumerate(line):
                if k!='.':rect(n,x+c,y+r,1,1,z,black if k=='#' else white)
    folder=['.####.......','##  ########','##         #','#          #','#          #','#          #','############']
    floppy=['..########..','.##  #### #.','##   ####  #','#          #','#          #','# ######## #','# #    ### #','# ######## #','############']
    trash=['..######..','##########','.## ## ##.','.## ## ##.','.## ## ##.','.## ## ##.','.########.']
    for x,y,label,p in [(17,46,'Finder',folder),(47,46,'Scrapbook',folder),(76,71,'Notes',folder),(208,21,'Disk',floppy),(210,110,'Trash',trash)]:
        if x>180:rect(label+' label back',x-3,y+12,23,9,2,white)
        icon(label,x,y,p,2.1);text(label+' caption',x-2,y+18,label,6,2.2)
    text('Window information line',14,43,'3 items',6,1.0)
    icon('Arrow pointer',183,97,['#.......','##......','# #.....','#  #....','#   #...','#    #..','#  ####.','# #.....','## #....','#..#....'],2.7)
    d=bpy.data.cameras.new('Mac desktop fixed pixel field');o=bpy.data.objects.new('Mac desktop fixed pixel field',d);s.collection.objects.link(o)
    o.location=(120,67.5,24);d.type='ORTHO';d.ortho_scale=240;s.camera=o
    save('early-mac-desktop')
mac()
