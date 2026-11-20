"""Editable composite character; target design study not rigged or adopted."""
import bpy, math, sys, json
from pathlib import Path
from mathutils import Vector
from math import pi, sin, cos, sqrt
root=Path(__file__).resolve().parent
bpy.ops.wm.read_factory_settings(use_empty=True);s=bpy.context.scene
def mat(n,h,rough=.72):
 rgb=[int(h[i:i+2],16)/255 for i in (0,2,4)]
 rgb=tuple(v/12.92 if v<.04045 else ((v+.055)/1.055)**2.4 for v in rgb)
 m=bpy.data.materials.new(n);m.use_nodes=True;m.diffuse_color=(*rgb,1);p=m.node_tree.nodes.get('Principled BSDF');p.inputs['Base Color'].default_value=(*rgb,1);p.inputs['Roughness'].default_value=rough;return m
skin=mat('Warm peach skin','E69C71');earm=mat('Ear warmth','CA7457');nose=mat('Warm nose','DEA07B')
hair=mat('Chestnut base','342018',.60);lit=mat('Chestnut lit locks','52291B',.60);mid=mat('Chestnut warm locks','48251A',.59)
ink=mat('Espresso feature lines','2C1A15');white=mat('Warm eye whites','FFF1D9');iris=mat('Amber eyes','B86F24');pupil=mat('Deep umber pupils','2C1B14');spark=mat('Bright catchlight','FFFADE')
teal=mat('Teal cropped jacket','267F88');teald=mat('Teal collar and cuffs','22616F');teall=mat('Teal seam highlights','43959B')
shirt=mat('Ivory jersey','F1DBC0');ivory=mat('Ivory neck binding','FCEDD5');rust=mat('Terracotta high-rise shorts','B94F37');rustl=mat('Rust pocket edging','D46E4B');rustd=mat('Copper garment shadow','854032')
gold=mat('Ochre boot suede','C28A36');soles=mat('Tan rubber toe and sole','EDCAA1');darkgold=mat('Boot elastic gussets','734F34')
ground=mat('Neutral slate backdrop','546674')
co={}
for name in ('Face and features','Hair – sculpted locks','Jacket and T-shirt','Shorts','Arms and legs','Boots','Preview only'):
 c=bpy.data.collections.new(name);s.collection.children.link(c);co[name]=c
def mesh(n,p,f,m,g,sm=True):
 me=bpy.data.meshes.new(n);me.from_pydata(p,[],f);me.update()
 o=bpy.data.objects.new(n,me);co[g].objects.link(o);me.materials.append(m)
 if sm:
  for t in me.polygons:t.use_smooth=len(t.vertices)==4
 return o
def rings(n,rr,m,g,k=12,fy=1):
 p=[]
 for x,y,z,rx,ry in rr:
  p += [(x+rx*cos(i*2*pi/k),y+ry*sin(i*2*pi/k)*(1 if sin(i*2*pi/k)>=0 else fy),z) for i in range(k)]
 l=len(rr)
 f=[tuple(range(k-1,-1,-1)),tuple((l-1)*k+i for i in range(k))]
 f += [(j*k+i,j*k+(i+1)%k,(j+1)*k+(i+1)%k,(j+1)*k+i) for j in range(l-1) for i in range(k)]
 return mesh(n,p,f,m,g)
def ell(n,c,r,m,g,k=10,h=5):
 x,y,z=c;rx,ry,rz=r;rr=[(x,y,z+rz*cos(t*pi/h),max(.003,rx*sin(t*pi/h)),max(.003,ry*sin(t*pi/h))) for t in range(h,-1,-1)]
 return rings(n,rr,m,g,k)
def strand(n,pts,m,g,k=7,axis=(0,-1,0)):
 # Cross-section normal plane; describes taper and gives sculpted separate surface.
 p=[]; pts=[(Vector(t[:3]),t[3],t[4]) for t in pts]
 for i,(c,rx,ry) in enumerate(pts):
  tan=(pts[min(i+1,len(pts)-1)][0]-pts[max(0,i-1)][0]).normalized()
  d=Vector(axis);u=tan.cross(d).normalized();v=u.cross(tan).normalized()
  p.extend(tuple(c+u*(rx*cos(j*2*pi/k))+v*(ry*sin(j*2*pi/k))) for j in range(k))
 l=len(pts);f=[tuple(range(k-1,-1,-1)),tuple((l-1)*k+i for i in range(k))]
 f.extend((j*k+i,j*k+(i+1)%k,(j+1)*k+(i+1)%k,(j+1)*k+i) for j in range(l-1) for i in range(k))
 return mesh(n,p,f,m,g)
face='Face and features';hr='Hair – sculpted locks';cl='Jacket and T-shirt';sh='Shorts';limb='Arms and legs';boot='Boots';stage='Preview only'
# 5.55 unit total standing height. Hair-to-chin is about one fourth.
rings('Sculpted cheeks, jaw and cranium',[(.020,-.058,4.32,.145,.155),(.008,-.058,4.37,.25,.216),(0,-.058,4.48,.385,.293),(0,-.031,4.67,.47,.372),(0,-.016,4.90,.486,.383),(0,.000,5.10,.435,.345),(0,.027,5.27,.326,.283),(0,.030,5.37,.135,.16)],skin,face,20,1.09)
rings('Neck',[(0,.016,3.956,.170,.145),(0,.006,4.08,.141,.134),(0,.015,4.26,.127,.130),(0,.033,4.46,.139,.133)],skin,face)
for sg in (-1,1):
 ell('Ear shell',(sg*.467,-.075,4.607),(.122,.090,.126),skin,face)
 ell('Ear bowl',(sg*.511,-.144,4.620),(.040,.018,.066),earm,face,7,4)
# Slight convex face conformance, no fully separate eyeballs.
def facial_depth(x,z):
 row=[(4.32,.020,-.058,.145,.155),(4.37,.008,-.058,.25,.216),(4.48,0,-.058,.385,.293),(4.67,0,-.031,.47,.372),(4.90,0,-.016,.486,.383),(5.10,0,0,.435,.345),(5.27,0,.027,.326,.283)]
 for (za,xa,ya,ra,da),(zb,xb,yb,rb,db) in zip(row,row[1:]):
  if za<=z<=zb:
   t=(z-za)/(zb-za)
   x0=xa*(1-t)+xb*t;y0=ya*(1-t)+yb*t;r=ra*(1-t)+rb*t;depth=da*(1-t)+db*t
   # Project to the actual 20-segment cheek cross-section, not a detached flat image.
   q=max(-1.,min(1.,(x-x0)/r))
   for j in range(10):
    lo=cos((j+1)*pi/10);hi=cos(j*pi/10)
    if lo-1e-7<=q<=hi+1e-7:
     w=(q-lo)/(hi-lo)
     return y0-1.09*depth*(sin((j+1)*pi/10)*(1-w)+sin(j*pi/10)*w)-.005
 return -.24
def patch(n,c,rx,rz,depth,m,shape=0):
 x,z=c
 p=[(x,facial_depth(x,z)-depth-.002,z)]
 for i in range(20):
  a=i*2*pi/20;xx=x+rx*cos(a);zz=z+rz*sin(a)*(1 if sin(a)>0 else .77)+shape*cos(a)
  p.append((xx,facial_depth(xx,zz)-depth,zz))
 f=[(0,i+1,(i+1)%20+1) for i in range(20)]
 return mesh(n,p,f,m,face)
for side in (-1,1):
 x=.214*side;z=4.754
 patch('Upper charcoal eye shape',(x,z+.039),.151,.097,.007,ink,.027*side)
 patch('Ivory sclera',(x,z),.126,.089,.012,white,.019*side)
 patch('Amber iris',(x+.018,z+.002),.071,.081,.020,iris)
 patch('Dark oval pupil',(x+.021,z+.013),.048,.066,.027,pupil)
 patch('Large eye glint',(x-.006,z+.053),.012,.014,.034,spark)
 pts=[(x-.130*side,4.952,.005),(x-.083*side,4.981,.023),(x+.008*side,4.981,.030),(x+.093*side,4.951,.023),(x+.123*side,4.930,.003)]
 strand('Arched expressive eyebrow',[(xx,facial_depth(xx,zz)-.029,zz,rr,.018*max(.35,rr/.03)) for xx,zz,rr in pts],mid,face,6)
rings('Low nose bridge and tapered tip',[(0,-.391,4.563,.035,.026),(.010,-.424,4.586,.059,.062),(.009,-.434,4.613,.055,.073),(0,-.421,4.636,.038,.055),(0,-.417,4.680,.021,.029),(0,-.407,4.713,.012,.015)],nose,face,12)
strand('Small asymmetric warm smile',[(x,facial_depth(x,z)-.010,z,r,.007) for x,z,r in [(-.108,4.501,.002),(-.058,4.481,.010),(.019,4.480,.012),(.077,4.492,.009),(.109,4.516,.003)]],earm,face,7)
# Base hugs back of cranium; cheeks remain open and separate curled locks carry silhouette.
rings('Bob back mass',[(0,.164,4.22,.27,.190),(0,.161,4.32,.48,.250),(0,.139,4.48,.60,.307),(0,.137,4.71,.565,.335),(0,.114,4.96,.508,.359),(0,.080,5.17,.441,.358),(.031,.064,5.37,.335,.299),(.035,.065,5.46,.185,.164)],hair,hr,16)
# Asymmetrical sweeping fringe, broad visible ribbons with fine edge separation.
for n,p,m in [
 ('Large right side-sweep',[(.012,-.020,5.45,.045,.060),(.153,-.273,5.394,.144,.114),(.299,-.365,5.259,.175,.118),(.414,-.331,5.069,.171,.102),(.535,-.237,4.924,.126,.093),(.631,-.117,4.845,.077,.061),(.643,-.033,4.784,.003,.009)],lit),
 ('Right split long sweep',[(.082,-.088,5.42,.032,.035),(.262,-.297,5.33,.086,.081),(.391,-.346,5.16,.100,.067),(.443,-.346,4.995,.069,.051),(.485,-.275,4.819,.048,.046),(.552,-.208,4.677,.003,.006)],mid),
 ('Left wide brushed fringe',[(.020,-.050,5.43,.025,.051),(-.172,-.275,5.353,.109,.095),(-.314,-.367,5.228,.120,.087),(-.424,-.387,5.069,.103,.075),(-.502,-.323,4.902,.099,.066),(-.558,-.215,4.78,.055,.055),(-.565,-.116,4.669,.005,.006)],mid),
 ('Left swept temple curl',[(-.414,-.130,5.138,.073,.085),(-.479,-.282,4.931,.092,.097),(-.501,-.259,4.733,.086,.068),(-.485,-.245,4.553,.073,.074),(-.401,-.236,4.439,.051,.038),(-.334,-.220,4.423,.006,.005)],lit),
 ('Right framing curl',[(.429,-.095,5.10,.085,.077),(.519,-.205,4.904,.121,.087),(.550,-.218,4.693,.106,.105),(.537,-.225,4.479,.084,.063),(.484,-.232,4.389,.009,.006)],mid),
 ('Little lifted crown tuft',[(-.102,.01,5.393,.033,.057),(-.21,.020,5.53,.069,.059),(-.35,.06,5.553,.047,.048),(-.469,.066,5.487,.020,.031),(-.482,.10,5.405,.004,.005)],mid),
 ('Outer light airy tuft',[(.106,.10,5.40,.033,.057),(.305,.09,5.42,.073,.079),(.481,.08,5.34,.059,.065),(.607,.09,5.24,.029,.054),(.624,.11,5.108,.004,.003)],lit),
 ]: strand(n,p,m,hr,10)
for side in (-1,1):
 for i in range(4):
  x=(.26+.10*i)*side;y=.058+.073*i
  strand('Scalloped separate bob tip',[(x*.74,y,5.13,.091,.099),(x*.91,y+.016,4.87,.138,.135),(x*1.10,y+.028,4.61,.146,.104),(x*1.13,y+.019,4.42,.112,.089),(x*1.02,y-.01,4.26,.065,.055),(x*.83,y-.031,4.235,.005,.008)],mid if i%2 else hair,hr,8)
rings('Soft ivory tee base',[(0,0,3.17,.285,.166),(0,-.005,3.30,.335,.205),(0,-.015,3.53,.369,.226),(0,-.007,3.72,.394,.210),(0,.008,3.91,.338,.175),(0,.009,4.013,.179,.124)],shirt,cl,16,1.16)
strand('Ivory scoop binding',[(-.20,-.162,3.998,.012,.016),(-.142,-.228,3.931,.017,.013),(0,-.264,3.898,.018,.012),(.138,-.226,3.94,.017,.013),(.20,-.163,3.998,.012,.014)],ivory,cl)
# Open jacket cut, rolled sleeves, and upturned collar split by the tee.
for side in(-1,1):
 def a(x):return side*x
 # Loop from chest opening across side to closed back; pattern remains editable.
 p=[]
 for z,xx,yy,ang0,ang1 in [(3.19,.402,.261,-52,87),(3.33,.420,.276,-56,90),(3.55,.438,.279,-58,90),(3.77,.468,.268,-63,90),(3.923,.437,.235,-64,90),(4.01,.272,.165,-53,89)]:
  for j in range(11):
   an=(ang0+(ang1-ang0)*j/10)*pi/180
   p.append((a(xx*cos(an)),yy*sin(an)-.020,z))
 f=[(j*11+i,j*11+i+1,(j+1)*11+i+1,(j+1)*11+i) for i in range(10) for j in range(5)]
 o=mesh('Jacket cut front and back',p,f,teal,cl)
 sl=o.modifiers.new('Garment thickness','SOLIDIFY');sl.thickness=.019
 strand('Cropped jacket hem',[(a(.244),-.236,3.20,.022,.020),(a(.393),-.134,3.19,.026,.024),(a(.433),.006,3.19,.030,.020),(a(.335),.170,3.204,.026,.024),(a(.033),.243,3.198,.024,.010)],teald,cl)
 strand('Open jacket front binding',[(a(.237),-.248,3.20,.022,.022),(a(.225),-.263,3.43,.020,.023),(a(.208),-.264,3.70,.019,.024),(a(.209),-.237,3.91,.021,.022)],teall,cl)
 p=[(a(x),y,z) for x,y,z in[(.18,-.226,3.89),(.216,-.214,4.058),(.264,-.108,4.225),(.405,.062,4.197),(.315,.165,4.10),(.269,.188,3.98),(.321,.002,3.908),(.192,-.16,3.875)]]
 o=mesh('Upturned jacket lapel',p,[(0,1,2,7),(2,3,6,7),(3,4,5,6),(0,7,6,5)],teald,cl)
 sl=o.modifiers.new('Collar thickness','SOLIDIFY');sl.thickness=.025
 k=[(a(.465),.005,3.844,.188,.228),(a(.568),.01,3.697,.207,.228),(a(.656),.003,3.515,.207,.203),(a(.768),-.008,3.319,.189,.166),(a(.791),-.010,3.228,.140,.143)]
 strand('Shaped rolled jacket sleeve',k,teal,cl,11)
 strand('Rolled fabric sleeve cuff',[(a(.741),-.007,3.43,.152,.166),(a(.791),-.009,3.358,.208,.172),(a(.809),-.019,3.252,.177,.142),(a(.819),-.022,3.211,.139,.126)],teald,cl,11)
 strand('Elbow and narrowing forearm',[(a(.802),-.018,3.245,.113,.112),(a(.846),-.049,3.105,.117,.111),(a(.926),-.080,2.901,.112,.107),(a(.987),-.094,2.689,.080,.088),(a(1.040),-.115,2.600,.066,.076)],skin,limb,11)
 ell('Relaxed blockout fist',(a(1.055),-.121,2.487),(.113,.105,.147),skin,limb)
 ell('Separate resting thumb',(a(.981),-.202,2.532),(.054,.067,.101),skin,limb,8,4)
# Shorts are separate fitted waistband and tailored legs.
rings('Waist and seat',[(0,.027,2.612,.424,.250),(0,.020,2.760,.455,.268),(0,.007,2.969,.406,.225),(0,.004,3.194,.324,.194)],rust,sh,18,1.07)
rings('Topstitched waistband',[(0,.006,3.081,.333,.198),(0,.007,3.183,.337,.200),(0,.008,3.217,.325,.197)],rustd,sh,16,1.11)
ell('Brass waist button',(0,-.222,3.13),(.041,.022,.040),gold,sh,8,4)
for side in(-1,1):
 def a(x):return side*x
 dy=.052 if side<0 else -.023
 rings('Tailored high-rise shorts leg',[(a(.290),.015+dy,2.374,.276,.231),(a(.261),.006,2.492,.275,.235),(a(.226),.025,2.642,.237,.254),(a(.213),.029,2.782,.205,.251),(a(.177),.029,2.858,.182,.222)],rust,sh,14,1.03)
 rings('Double-rolled short hem',[(a(.294),.013+dy,2.360,.282,.234),(a(.287),.016+dy,2.399,.283,.241),(a(.271),.015+dy,2.468,.277,.240)],rustl,sh,13,1.03)
 strand('Diagonal pocket opening',[(a(.182),-.218,3.087,.013,.012),(a(.253),-.227,3.025,.015,.012),(a(.310),-.225,2.969,.016,.011),(a(.383),-.197,2.941,.010,.010)],rustl,sh,6)
 rings('Thigh to shin continuous leg',[(a(.391),.066+dy,.566,.101,.123),(a(.407),.053+dy,.724,.105,.121),(a(.404),.040+dy,.998,.153,.164),(a(.380),.015+dy,1.211,.186,.190),(a(.353),-.037+dy,1.403,.144,.163),(a(.329),-.043+dy,1.637,.164,.178),(a(.307),-.011+dy,1.896,.191,.210),(a(.299),.014+dy,2.164,.221,.225),(a(.291),.014+dy,2.409,.222,.217)],skin,limb,14,1.02)
 bx=a(.397)
 rings('Ochre ankle boot and rounded vamp',[(bx,-.149+dy,.122,.257,.441),(bx,-.148+dy,.202,.245,.405),(bx,-.091+dy,.286,.209,.350),(bx,.003+dy,.409,.174,.265),(bx,.070+dy,.541,.154,.168),(bx,.070+dy,.696,.147,.156),(bx,.072+dy,.759,.159,.173)],gold,boot,15)
 rings('Cream lug outsole',[(bx,-.145+dy,.038,.251,.427),(bx,-.144+dy,.063,.270,.443),(bx,-.149+dy,.142,.274,.449),(bx,-.151+dy,.177,.244,.419)],soles,boot,16)
 # Blank square gusset surfaces join boot sides with no floating detail.
 for d in(-1,1):
  x=bx+d*.142
  mesh('Dark elastic boot inset',[(x,-.047+dy,.728),(x,.130+dy,.738),(x+d*.018,.151+dy,.530),(x+d*.016,.018+dy,.498)],[(0,1,2,3)],darkgold,boot)
for x,w in [(-.24,.113),(-.08,.119),(.095,.120),(.257,.108)]:
 strand("Swept layered back nape lock",[(x*.66,.231,5.34,.050,.064),(x*.88,.348,5.15,w,.084),(x*1.08,.463,4.91,w,.080),(x*1.14,.548,4.68,w*.86,.071),(x*1.08,.563,4.47,w*.60,.044),(x*.96,.490,4.31,.010,.010)],mid if x<0 else hair,hr,8,(1,0,0))
# Design iteration: the reference is wide and jaw-framing, not a round narrow helmet.
# Keep camera scale fixed; taper lateral enlargement toward the crown preserving the sweep.
for o in co[hr].objects:
 for v in o.data.vertices:
  x,y,z=v.co
  shell=1.08+.20*min(1,max(0,(5.37-z)/.90))
  v.co.x=x*shell
  # Keep curls by the cheek, lower hair expands predominantly sideways/back.
  zweight=max(0,min(1,(5.46-z)/.74))
  if y>.017:
   v.co.y+=zweight*(.055+min(y,.35)*.54)
  if o.name.startswith(('Left wide brushed','Large right side-sweep')):
   # Place seam near upper forehead before broadening sides. Tiny z changes lift brows from shade.
   v.co.z+=.027*max(0.,1-abs(x-.07)*2.8)
  v.co.z-=.07
for o in co[face].objects:
 for v in o.data.vertices:
  if o.name=='Neck':v.co.z-=max(0.,min(1.,(v.co.z-4.)/.46))*.07
  else:v.co.z-=.07
# Fore/aft asymmetry seen in three-quarter. Leave hip and seams connected.
for o in [o for group in (cl,limb,boot,sh) for o in co[group].objects]:
 for v in o.data.vertices:
  x,y,z=v.co
  if (o.name.startswith('Thigh') or o in co[boot].objects[:]) and z<2.42:
   side=-1 if x<0 else 1
   w=max(0,min(1,(2.42-z)/1.86))
   v.co.x+=side*.111*w
   v.co.y+=(.110 if side<0 else -.09)*w
   calf=max(0,1-abs(z-1.05)/.44)
   if o.name.startswith('Thigh'):v.co.x+= (x-side*.395)*.17*calf
  if o.name.startswith(('Ochre ankle','Cream lug')):
   toe=max(0,min(1,(-y+.055)*2))
   side=-1 if x<0 else 1
   v.co.x+=side*.055*toe
   v.co.y-=.07*toe
# Object normals need to be consistently outward on the visible sculpted parts.
import bmesh
for obj in [o for c in co.values() if c.name!=stage for o in c.objects]:
 bm=bmesh.new();bm.from_mesh(obj.data)
 bmesh.ops.recalc_face_normals(bm,faces=list(bm.faces));bm.to_mesh(obj.data);bm.free()
# Studio cameras use one ortho scale; front and profile may differ in silhouette.
camd=bpy.data.cameras.new('Turnaround 240×135');cam=bpy.data.objects.new('Turnaround 240×135',camd);co[stage].objects.link(cam);s.camera=cam
camd.type='ORTHO';camd.ortho_scale=10.6
def aim(o,p):o.rotation_euler=(Vector(p)-o.location).to_track_quat('-Z','Y').to_euler()
def camera(yaw):
 c=yaw*pi/180;cam.location=(sin(c)*13,-cos(c)*13,3.45);aim(cam,(0,0,2.79))
def light(n,loc,p,size,col):
 d=bpy.data.lights.new(n,'AREA');d.energy=p;d.shape='DISK';d.size=size;d.color=col
 o=bpy.data.objects.new(n,d);co[stage].objects.link(o);o.location=loc;aim(o,(0,0,3.0))
light('Warm softbox',(-4,-5,8),830,5,(1,.87,.75));light('Cool bounce',(4,-3,5),290,5,(.66,.84,1));light('Upper contour rim',(1,3.5,7),710,4,(1,.81,.62))
s.world=bpy.data.worlds.new('Soft neutral slate');s.world.use_nodes=True
b=s.world.node_tree.nodes.get('Background');b.inputs[0].default_value=(.074,.096,.117,1);b.inputs[1].default_value=.58
mesh('Preview floor only',[(-200,-200,0),(200,-200,0),(200,200,0),(-200,200,0)],[(0,1,2,3)],ground,stage)
s.render.engine='CYCLES';s.cycles.use_denoising=False;s.cycles.samples=168;s.render.threads_mode='FIXED';s.render.threads=6
s.render.resolution_x=240;s.render.resolution_y=135;s.render.resolution_percentage=100
s.render.film_transparent=False;s.render.image_settings.file_format='PNG';s.render.image_settings.color_mode='RGB'
s.view_settings.view_transform='AgX';s.view_settings.exposure=.20
s['scope']='Overlay 02 editable second-pass blockout, not production retopology, rig or hardware asset. Existing concept proposal used visually but not embedded.'
camera(-32)
bpy.context.preferences.filepaths.save_version=0
for sc in bpy.data.screens:
 for a in sc.areas:
  if a.type=='VIEW_3D':a.spaces.active.region_3d.view_perspective='CAMERA'
blend=root/'human-overlay-02.blend'
bpy.ops.wm.save_as_mainfile(filepath=str(blend),compress=True)
dg=bpy.context.evaluated_depsgraph_get()
pieces={}
for name,c in co.items():
 if name==stage:continue
 pieces[name]=0
 for o in c.objects:
  eo=o.evaluated_get(dg);m=eo.to_mesh();m.calc_loop_triangles()
  pieces[name]+=len(m.loop_triangles);eo.to_mesh_clear()
(root/'metrics.json').write_text(json.dumps({'character_triangles':sum(pieces.values()),'triangles_by_layer':pieces,'included_stage':False,'runtime_model':False,'rigged':False},indent=2)+'\n')
for yaw,name in [(0,'front'),(-32,'three-quarter'),(-90,'profile')]:
 camera(yaw);s.render.filepath=str(root/(name+'-240x135.png'));bpy.ops.render.render(write_still=True)
camd.ortho_scale=3.13
for yaw,name in [(0,'face-front'),(-32,'face-three-quarter'),(-90,'face-profile')]:
 a=yaw*pi/180;cam.location=(sin(a)*13,-cos(a)*13,5.17);aim(cam,(0,0,4.70));s.render.filepath=str(root/(name+'-240x135.png'));bpy.ops.render.render(write_still=True)
