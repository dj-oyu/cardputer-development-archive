import bpy,math,random
from mathutils import Vector
from pathlib import Path
D=Path(__file__).resolve().parent;random.seed(73)
bpy.ops.object.select_all(action='SELECT');bpy.ops.object.delete(use_global=False)
def mat(name,color,rough=.85):
 m=bpy.data.materials.new(name);m.diffuse_color=(*color,1);m.use_nodes=True;p=m.node_tree.nodes.get('Principled BSDF');p.inputs['Base Color'].default_value=(*color,1);p.inputs['Roughness'].default_value=rough;return m
forest=[mat('Deep jade',(0.018,.12,.068)),mat('Emerald foliage',(.035,.29,.10)),mat('Sunlit lime',(.26,.52,.09)),mat('Turquoise distant jungle',(.045,.24,.22)),mat('Leaf gold',(.43,.58,.12))];bark=mat('Warm jungle bark',(.12,.12,.045));ground=mat('Moss carpet',(.055,.17,.035));dino=mat('Dinosaur golden chartreuse',(.43,.59,.13),.65);belly=mat('Warm dinosaur belly',(.66,.68,.27));eye=mat('Obsidian eye',(.012,.018,.009),.22);white=mat('Eye glint',(.95,.98,.7));rock=mat('Mossy rocks',(.065,.14,.09));water=mat('Distant jade pool',(.03,.26,.20),.16)
def uv(name,loc,scale,ma,seg=20):
 bpy.ops.mesh.primitive_uv_sphere_add(segments=seg,ring_count=12,location=loc);o=bpy.context.object;o.name=name;o.scale=scale;o.data.materials.append(ma);[setattr(p,'use_smooth',True)for p in o.data.polygons];return o
def tube(name,pts,rads,ma,sides=12):
 vs=[];fs=[]
 for i,p in enumerate(pts):
  t=Vector(pts[min(i+1,len(pts)-1)])-Vector(pts[max(0,i-1)]);t.normalize();a=t.cross(Vector((0,1,0)));a.normalize();b=t.cross(a)
  for j in range(sides):vs.append(Vector(p)+rads[i]*(a*math.cos(2*math.pi*j/sides)+b*math.sin(2*math.pi*j/sides)))
 for i in range(len(pts)-1):
  for j in range(sides):fs.append((i*sides+j,i*sides+(j+1)%sides,(i+1)*sides+(j+1)%sides,(i+1)*sides+j))
 fs+=[tuple(reversed(range(sides))),tuple((len(pts)-1)*sides+j for j in range(sides))];m=bpy.data.meshes.new(name);m.from_pydata(vs,[],fs);m.update();o=bpy.data.objects.new(name,m);bpy.context.collection.objects.link(o);m.materials.append(ma);[setattr(p,'use_smooth',True)for p in m.polygons];return o
def leaf(name,base,tip,width,ma):
 a=Vector(base);b=Vector(tip);d=b-a;cross=Vector((-d.y,d.x,0));cross.normalize();verts=[a,a+d*.35+cross*width,a+d*.68+cross*width*.7,b,a+d*.68-cross*width*.7,a+d*.35-cross*width,a+d*.48+Vector((0,0,.22))];faces=[(0,1,6),(1,2,6),(2,3,6),(3,4,6),(4,5,6),(5,0,6)];mesh=bpy.data.meshes.new(name);mesh.from_pydata(verts,[],faces);o=bpy.data.objects.new(name,mesh);bpy.context.collection.objects.link(o);mesh.materials.append(ma)
def palm(x,y,h):
 tube('Palm trunk',[(x,y,0),(x+.2,y,h*.45),(x-.25,y,h)], [.28,.20,.13],bark,9)
 for j in range(9):
  a=j*math.tau/9+random.random()*.2;length=random.uniform(2.4,4.0);base=(x-.25,y,h);tip=(x+math.cos(a)*length,y+math.sin(a)*length,h+random.uniform(-1.6,.3));leaf('Broad palm frond',base,tip,.65,random.choice(forest[1:]))
# Ground and layered foliage, open sightline at right dinosaur.
bpy.ops.mesh.primitive_plane_add(size=200);bpy.context.object.name='Forest floor';bpy.context.object.data.materials.append(ground)
uv('Jade pool',(-2,3,.015),(5,3,.045),water)
for x in [-16,-12,-8,-4,0,4,8,12,16]:
 y=random.uniform(10,14);h=random.uniform(11,16);palm(x,y,h)
 for j in range(4):uv('Distant layered canopy',(x+random.uniform(-2,2),y,h-2+random.uniform(-1,1)),(3,2,2),forest[3])
for x,y,h in [(-12,-1,14),(-9,4,12),(-5,7,14),(1,9,13),(12,7,14),(15,1,16)]:palm(x,y,h)
for i in range(42):
 x=random.uniform(-16,16);y=random.uniform(4,10);z=random.uniform(.4,1.4);uv('Jungle understory',(x,y,z),(random.uniform(1,2.5),1.3,z),random.choice(forest[:3]),12)
# Long-neck dinosaur clear right-side silhouette, contrasting pale green.
uv('Dinosaur body',(7.4,0,3.2),(2.35,.85,1.30),dino)
uv('Dinosaur breast',(8.7,-.02,3.45),(1,.78,1.15),dino)
for x,y in [(6.2,.55),(8.6,.55),(6.45,-.55),(8.7,-.55)]:
 tube('Dinosaur sturdy leg',[(x,y,3.1),(x+.12,y,1.6),(x-.1,y,.38)],[.43,.32,.33],dino);uv('Dinosaur rounded foot',(x-.22,y-.12,.30),(.5,.40,.32),dino)
tube('Dinosaur sweeping tail',[(5.7,0,3.3),(4.6,.1,3.15),(3.1,.35,3.0),(1.7,.6,3.4),(.7,.7,3.8)],[.70,.50,.28,.12,.025],dino)
tube('Dinosaur long curved neck',[(8.9,0,3.8),(9.5,0,4.9),(9.8,0,6.3),(9.65,0,7.8),(9.2,0,9.0),(8.55,0,9.55)],[.78,.64,.50,.42,.36,.33],dino)
uv('Dinosaur small head',(8.0,-.05,9.55),(.82,.43,.40),dino);uv('Dinosaur snout',(7.43,-.1,9.43),(.50,.40,.26),belly)
uv('Dinosaur near eye',(8.0,-.443,9.68),(.105,.045,.105),eye);uv('Dinosaur eye shine',(7.98,-.482,9.72),(.029,.015,.029),white)
uv('Dinosaur nostril',(7.25,-.40,9.49),(.055,.025,.04),eye)
for i in range(11):uv('Dinosaur subtle flank speckle',(5.9+i*.23,-.813,3.55+math.sin(i)*.12),(.10,.018,.16),forest[2],10)
# Fern silhouettes foreground, frame bottom not obscure dinosaur head.
for x,y in [(-12,-6),(-9,-5),(-5,-5),(0,-5),(5,-5),(12,-5),(15,-4)]:
 for j in range(7):
  a=j*math.tau/7;tip=(x+math.cos(a)*random.uniform(1.3,2.5),y+math.sin(a)*1.7,random.uniform(.8,2));leaf('Foreground tropical leaf',(x,y,.1),tip,.45,random.choice(forest[:3]))
for x,y,z in [(-7,-2,.7),(10,2,.5),(12,-2,.7),(-13,1,1)]:uv('Moss boulder',(x,y,z),(1.4,1,z),rock,12)
# Atmosphere with real light shafts.
vol=bpy.data.materials.new('Thin humid atmosphere');vol.use_nodes=True;nt=vol.node_tree;nt.nodes.clear();out=nt.nodes.new('ShaderNodeOutputMaterial');v=nt.nodes.new('ShaderNodeVolumePrincipled');v.inputs['Density'].default_value=.008;v.inputs['Color'].default_value=(.55,.73,.42,1);v.inputs['Anisotropy'].default_value=.25;nt.links.new(v.outputs['Volume'],out.inputs['Volume']);bpy.ops.mesh.primitive_cube_add(size=2,location=(0,4,8));o=bpy.context.object;o.name='Humid forest atmosphere';o.scale=(24,18,12);o.data.materials.append(vol);o.display_type='WIRE'
def light(name,typ,loc,power,color,target,size=6):
 d=bpy.data.lights.new(name,typ);d.energy=power;d.color=color
 if typ=='AREA':d.shape='DISK';d.size=size
 if typ=='SPOT':d.spot_size=.32;d.spot_blend=.35;d.shadow_soft_size=.25
 o=bpy.data.objects.new(name,d);bpy.context.collection.objects.link(o);o.location=loc;o.rotation_euler=(Vector(target)-o.location).to_track_quat('-Z','Y').to_euler()
light('Warm canopy opening','AREA',(-3,-5,15),2300,(1,.87,.57),(5,0,3),8)
light('Dinosaur rim skylight','AREA',(11,5,13),1700,(.75,1,.55),(8,0,6),5)
for x in [-7,-3,1]:light('Sun shaft','SPOT',(x,3,16),4500,(1,.88,.57),(x+5,-1,0))
scene=bpy.context.scene;scene.world.color=(.13,.22,.20);scene.render.engine='CYCLES';scene.cycles.samples=256;scene.cycles.use_denoising=False;scene.cycles.max_bounces=6
bpy.ops.object.camera_add(location=(0,-26,11));cam=bpy.context.object;cam.name='Cardputer background camera';cam.rotation_euler=(Vector((0,1,5.2))-cam.location).to_track_quat('-Z','Y').to_euler();cam.data.type='ORTHO';cam.data.ortho_scale=28;scene.camera=cam
scene.render.resolution_x=240;scene.render.resolution_y=135;scene.render.resolution_percentage=100;scene.render.image_settings.file_format='PNG';scene.render.image_settings.color_mode='RGB';scene.render.film_transparent=False;scene.view_settings.view_transform='AgX';scene.view_settings.look='AgX - Medium High Contrast';scene.render.filepath=str(D/'dinosaur-forest-240.png');bpy.context.preferences.filepaths.save_version=0;bpy.ops.wm.save_as_mainfile(filepath=str(D/'dinosaur-forest.blend'),compress=True);bpy.ops.wm.open_mainfile(filepath=str(D/'dinosaur-forest.blend'));bpy.ops.render.render(write_still=True)
