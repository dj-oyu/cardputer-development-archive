import bpy,math,os,json,random,time,sys
from mathutils import Vector,Matrix
from mathutils.bvhtree import BVHTree
from pathlib import Path
P=Path(__file__).resolve().parent
s=bpy.context.scene; s.frame_set(13);bpy.context.view_layer.update()
R=next(o for o in s.objects if o.type=='ARMATURE');bs=R.pose.bones
chair=next(o for o in s.objects if o.name.startswith('Engine chair'))
stand=next(o for o in s.objects if o.name.startswith('Chair • stationary'))
waist=s.objects['Waist and seat']
anchor=s.camera.matrix_world.copy()
bas_m={b.name:b.matrix.copy() for b in bs}; defaults={b.name:b.matrix_basis.copy() for b in bs}
source_action=R.animation_data.action
R.animation_data.action=None; source_action.use_fake_user=True
saved={}
for o in bpy.data.collections['Gaming Chair Prop'].all_objects:
 if o.animation_data and o.animation_data.action:
  m=o.matrix_world.copy();a=o.animation_data.action;a.use_fake_user=True;saved[o.name]=a.name;o.animation_data.action=None;o.matrix_world=m
def up():bpy.context.view_layer.update()
up()
def ev(o):
  e=o.evaluated_get(bpy.context.evaluated_depsgraph_get());m=e.to_mesh();m.calc_loop_triangles()
  pts=[e.matrix_world@v.co for v in m.vertices];ind=[tuple(t.vertices) for t in m.loop_triangles];e.to_mesh_clear()
  return pts,ind
def bvh(g):return BVHTree.FromPolygons(*g,all_triangles=True)
def tree(o):return bvh(ev(o))
def join(os):
 p=[];f=[]
 for o in os:
  a,b=ev(o);f.extend(tuple(i+len(p) for i in q) for q in b);p.extend(a)
 return p,f
parts={}
for k in 'LR':
 parts[k]={}
 parts[k]['pants']=[o for o in s.objects if o.name.startswith('Thigh to shin') and o.vertex_groups.get('thigh.'+k)]
 parts[k]['boot']=[o for o in s.objects if o.name.startswith(('Ochre ankle boot','Cream lug outsole','Dark elastic boot inset')) and o.vertex_groups.get('foot.'+k)]
 parts[k]['sole']=next(o for o in parts[k]['boot'] if o.name.startswith('Cream lug'))
 assert len(parts[k]['pants'])==1
env={'shell':tree(chair),'stand':tree(stand)}
baseline_waist=len(tree(waist).overlap(env['shell']))
side=os.getenv('SIDE','L');other='R' if side=='L' else 'L';sgn=1 if side=='L' else -1
ends=[f'{n}.{side}' for n in ('thigh','shin','foot')];support=[f'{n}.{other}' for n in ('thigh','shin','foot')]
hip,knee,ankle=[bas_m[n].translation.copy() for n in ends]
p_hip,p_knee,p_ankle=[bas_m[n].translation.copy() for n in support]
l1,l2=(hip-knee).length,(knee-ankle).length
other_pts={k:join(parts[other][k]) for k in ('pants','boot')}
other_t={k:bvh(v) for k,v in other_pts.items()}
floorz=min(v.z for v in ev(parts[other]['sole'])[0])
arm_t=bvh(join([o for o in s.objects if o.type=='MESH' and o.name.startswith(('Elbow and narrowing','Relaxed blockout','Separate resting','Long ivory varsity sleeve'))]))
def orient(n,vec,roll=0):
 old=bas_m[n];b=bs[n]
 goal=vec.normalized()
 oldaxis=old.to_3x3()@Vector((0,1,0))
 rot=oldaxis.rotation_difference(goal).to_matrix()@old.to_3x3()
 if roll:rot=Matrix.Rotation(math.radians(roll),3,goal)@rot
 mat=rot.to_4x4();mat.translation=b.head; b.matrix=mat;up()
def pose(c):
 x,z,a,b,tr,sr,yr,pr=c
 k=Vector((sgn*x,hip.y-math.sqrt(max(0,l1*l1-(sgn*x-hip.x)**2-(z-hip.z)**2)),z))
 dd=Vector((sgn*a,b,-math.sqrt(max(0,l2*l2-a*a-b*b))))
 orient(ends[0],k-hip,tr)
 orient(ends[1],dd,sr)
 foot=bs[ends[2]];M=(Matrix.Rotation(math.radians(yr*sgn),3,'Z')@Matrix.Rotation(math.radians(pr),3,'X')@bas_m[ends[2]].to_3x3()).to_4x4()
 M.translation=foot.head;foot.matrix=M;up()
 return k,foot.head.copy()

def qa(c,diagnostic=False):
 q,a=pose(c)
 gv={k:join(parts[side][k]) for k in ('pants','boot')}
 tt={k:bvh(v) for k,v in gv.items()}
 clash={f'{k}:{l}':len(v.overlap(t)) for k,v in tt.items() for l,t in (*other_t.items(),*env.items(),('hands',arm_t))}
 wa=tree(waist)
 if not os.getenv('FAST'):
  clash['waist:shell']=max(0,len(wa.overlap(env['shell']))-baseline_waist)
  clash['waist:stand']=len(wa.overlap(env['stand']))
 gs=[p for p in gv['pants'][0] if (p-q).length<.40 and p.z>p_knee.z+.1]
 nearest=[(other_t['pants'].find_nearest(v)[3],v) for v in gs]
 distance,contact=min(nearest,key=lambda x:x[0]) if nearest else (999,q)
 s_gap=min(x.z for x in ev(parts[side]['sole'])[0])-floorz
 q2=other_t['pants'].find_nearest(contact)[0]
 # Contact should be around both distal thighs, not knee hovering far in front, nor between ankles.
 ax=(q-p_hip).dot((p_knee-p_hip).normalized())
 fp=(q-p_knee).length
 counts=sum(clash.values())
 score=counts*500+abs(distance-.019)*360
 score+=min(100,abs((p_knee.x-q.x))*26+abs(q.y-p_knee.y)*4)
 score+=10*abs(q.z-p_knee.z-.44)+10*abs(s_gap-.42)+abs(tr(c))*0 if False else 0
 score+=8*abs(q.z-p_knee.z-.44)+10*abs(s_gap-.42)+abs(c[4])*.03+abs(c[5])*.035
 if s_gap<.15:score+=300*(.15-s_gap)
 if a.z>min(q.z-.65,p_knee.z-.25):score+=250
 if ax<.70:score+=12
 return {'c':c,'score':score,'counts':counts,'clash':clash,'knee':list(q),'support_knee':list(p_knee),'ankle':list(a),
  'near_distance':distance,'near_upper_vertex':list(contact),'near_lower_vertex':list(q2),'top_outsole_lift':s_gap,'near_distal_thigh_projection':ax}
MODE=os.getenv('MODE','scan')
if MODE=='scan':
 n=int(os.getenv('N','2500')); rr=random.Random(277+(side=='R'))
 rules=[(-.41,-.21),(1.98,2.28),(-.73,-.18),(-.44,.21),(-48,48),(-55,55),(-34,34),(-15,30)]
 def draw(rule):return [rr.uniform(x,y) for x,y in rule]
 res=[]
 for idx in range(n):
  if idx==0:c=[-.31,2.13,-.45,-.22,0,0,-13,9]
  elif idx<n//3 or not res:c=draw(rules)
  else:
   res.sort(key=lambda x:x['score']); q=rr.choice(res[:min(24,len(res))])['c']
   amp=max(.035,.25*(1-idx/n));c=[max(lo,min(hi,val+rr.gauss(0,(hi-lo)*amp))) for val,(lo,hi) in zip(q,rules)]
  res.append(qa(c))
  if idx%250==249:
   res.sort(key=lambda x:x['score']);(P/f'scan-{side}.json').write_text(json.dumps(res[:100],indent=2))
   print('progress',side,idx+1,res[0],flush=True)
 res.sort(key=lambda x:x['score']);(P/f'scan-{side}.json').write_text(json.dumps(res[:100],indent=2))
 sys.exit()
if MODE=='build':
 a=json.loads((P/f'scan-{side}.json').read_text())
 ch=int(os.getenv('CH','0')); cfg=a[ch]['c']; out=qa(cfg)
 print(out,flush=True); assert out['counts']==0
 assert all((bs[n].matrix.translation-m.translation).length<1e-6 for n,m in bas_m.items() if n not in ends)
 assert (bs[ends[0]].head-hip).length<1e-6
 assert abs((bs[ends[0]].head-bs[ends[1]].head).length-l1)<1e-6
 assert abs((bs[ends[1]].head-bs[ends[2]].head).length-l2)<1e-6
 assert s.camera.matrix_world==anchor
 new=bpy.data.actions.new('v77 • isolated knee-over-knee endpoint')
 new.use_fake_user=True;R.animation_data.action=new
 for n in ends:bs[n].keyframe_insert('rotation_euler',frame=13,group=n)
 s['v77_cross_endpoint']='Reference Fig 1J standard leg cross, isolated static endpoint from v74 f13 at unchanged +0.12 BU seat. v74 swivel action preserved but inactive. Not a motion proof.'
 s['v77_original_chair_actions']=json.dumps(saved)
 bpy.context.preferences.filepaths.save_version=0
 bpy.ops.wm.save_as_mainfile(filepath=str(P/f'chair-knee-over-knee-v77-{side}.blend'),compress=True)
 (P/f'endpoint-{side}.json').write_text(json.dumps(out,indent=2))
if MODE in ('path','motion','route'):
 from itertools import pairwise
 out_hold=json.loads((P/'endpoint-L.json').read_text()); end=out_hold['c']
 ntrl=[knee.x,knee.z,(ankle-knee).x,(ankle-knee).y,0,0,0,0]
 def gap(c, full=False):
  data=qa(c)
  penalty=sum(data['clash'].values())
  l=max(0.,-data['top_outsole_lift']-.008)
  if l>0:penalty+=l*200
  a=data['ankle']
  if c[0]>.02 and a[0]<-.025:penalty+=15
  # Ignore baseline hip/cushion attachment, already waived with exact per-component baseline.
  return penalty,data
 def lerp(a,b,p):return [u+(v-u)*p for u,v in zip(a,b)]
 def segment(a,b,steps):
  return [gap(lerp(a,b,k/steps)) for k in range(steps+1)]
 if MODE=='path':
  seeds=[ntrl,[.34,1.81,.13,-.60,0,4,-4,8],
      [.21,2.03,.15,-.66,8,12,-6,12],
      [.045,2.23,.03,-.70,10,15,-7,25],
      [-.08,2.39,-.28,-.74,18,28,-7,25],
      [-.24,2.40,-.55,-.62,22,43,-8,30],end]
  arr=[]
  for i,(starter,ending) in enumerate(pairwise(seeds)):
   xx=segment(starter,ending,20)
   arr.append({'stage':i,'samples':[d for score,d in xx],'costs':[p for p,d in xx],'maximum':max(p for p,d in xx)})
   print(i,'max',arr[-1]['maximum'],'breakdown',[(k,p,[a for a,q in d['clash'].items() if q]) for k,(p,d) in enumerate(xx) if p>1e-4],flush=True)
  (P/'motion-path-initial.json').write_text(json.dumps({'seeds':seeds,'segments':arr},indent=2))
  sys.exit()

 if MODE=='route':
  seeds=json.loads((P/'motion-path-initial.json').read_text())['seeds']
  A=seeds[3]; G=end
  rng=random.Random(1333)
  from math import sqrt
  def norm(c):
   return [c[0]*1.7,c[1]*2.2,c[2],c[3],c[4]/105,c[5]/115,c[6]/130,c[7]/125]
  def d(a,b):
   return sqrt(sum((u-v)**2 for u,v in zip(norm(a),norm(b))))
  def valid(c):
   if abs(c[0]-hip.x)**2+abs(c[1]-hip.z)**2>l1*l1-.025:return False
   if c[2]*c[2]+c[3]*c[3]>l2*l2-.032:return False
   if c[0]>.02 and c[0]+c[2]<-.025:return False
   return gap(c)[0]<.00001
  def edge(a,b,eps=.05):
   if d(a,b)<1e-7:return True
   k=max(2,int(math.ceil(d(a,b)/eps)))
   return all(valid(lerp(a,b,i/k)) for i in range(1,k))
  trees=[[(A,-1)],[(G,-1)]]
  def add(tree,goal):
   i=min(range(len(tree)),key=lambda j:d(tree[j][0],goal))
   dst=d(tree[i][0],goal)
   if dst<1e-7:return i,True
   c=lerp(tree[i][0],goal,min(1,.16/dst))
   ok=valid(c) and edge(tree[i][0],c)
   if ok:tree.append((c,i));return len(tree)-1,dst<.160001
   return None,False
  def backtrack(tree,i):
   p=[]
   while i>=0: x,i=tree[i];p.append(x)
   return p
  assert valid(A) and valid(G)
  route=None
  group=[
    [-.09,2.42,-.28,-.95,16,26,-8,26],
    [-.24,2.43,-.67,-.72,24,48,-8,31],
    [-.36,2.39,-.70,-.47,23,53,-7,30],
    [-.13,2.34,-.24,-.99,12,25,-8,27],
    [-.16,2.45,-.29,-.97,23,36,0,26],
    [-.24,2.48,-.72,-.68,22,50,-8,32],
  ]
  for it in range(3100):
   ix=it%2; t=trees[ix]; u=trees[1-ix]
   if it<16:goal=group[it%len(group)]
   elif it%7==0:goal=rng.choice(group)
   elif it%6==0:goal=rng.choice(u)[0]
   else:
    mm=rng.choice(group+[G,A]); rr=(.16,.12,.28,.16,20,23,9,8)
    goal=[x+rng.gauss(0,a) for x,a in zip(mm,rr)]
    lim=[(-.54,.14),(2.12,2.58),(-.86,.22),(-1.055,-.19),(-32,74),(-15,84),(-30,40),(-8,48)]
    goal=[min(hi,max(lo,v)) for v,(lo,hi) in zip(goal,lim)]
   j,touch=add(t,goal)
   if j is not None:
    while True:
     k,exact=add(u,t[j][0])
     if k is None:break
     if exact:
      p=backtrack(t,j);q=backtrack(u,k)
      route=list(reversed(p))+q[1:]
      if ix:route=route[::-1]
      break
   if route is not None:break
   if it%100==99:print('ROUTE',it,[len(a) for a in trees],flush=True)
  if route is None:
   print('NO ROUTE',[len(a) for a in trees]);sys.exit(2)
  i=0
  while i<len(route)-2:
   q=max(j for j in range(i+1,len(route)) if edge(route[i],route[j],.026))
   if q>i+1:route=route[:i+1]+route[q:]
   i+=1
  seq=seeds[:3]+route
  for i,(a,b) in enumerate(pairwise(seq)):
   assert edge(a,b,.015),(i,a,b)
  (P/'motion-route.json').write_text(json.dumps({'trials':it+1,'trees':[len(a) for a in trees],'route':seq},indent=2))
  print('ROUTE FOUND',it+1,seq,flush=True)
  sys.exit()
 if MODE=='motion':
  rec=json.loads((P/'motion-route.json').read_text())
  seq=rec['route']; knots=[1,5.2,8.2,11.5,15.2,17.1,20.2,23.0]
  assert len(seq)==len(knots)
  import bisect
  def motion(fr,soft):
   f=min(fr,50-fr,23)
   if f<=1:return seq[0]
   if f>=23:return seq[-1]
   i=bisect.bisect_right(knots,f)-1
   h=knots[i+1]-knots[i];u=(f-knots[i])/h
   H=(1+2*u)*(1-u)**2;I=u*(1-u)**2;J=u*u*(3-2*u);K=u*u*(u-1)
   A,B=seq[i:i+2]
   blend=[]
   for k,(a,b) in enumerate(zip(A,B)):
    left=0 if i==0 else (b-seq[i-1][k])/(knots[i+1]-knots[i-1])
    right=0 if i+2==len(seq) else (seq[i+2][k]-a)/(knots[i+2]-knots[i])
    x=H*a+I*h*left*soft+J*b+K*h*right*soft
    blend.append(x)
   blend[2]+=.105*math.exp(-((f-12.42)/.72)**2)
   return blend
  candidates=[]
  for soft in (1,.85,.70,.50,.30,0):
   # Search the nicest continuous route first; go to conservative points if the tangents intrude.
   result=[]
   for i in range(193):
    f=1+i*.25;c=motion(f,soft)
    p,m=gap(c);result.append((f,p,m))
   bad=[(f,p,m['clash']) for f,p,m in result if p>.0001]
   print('SMOOTH',soft,len(bad),bad[:6],flush=True)
   if not bad:break
  assert not bad
  new=bpy.data.actions.new('v77 • seated knee over knee, planted support shoe')
  new.use_fake_user=True;R.animation_data.action=new
  # Bake only the raised leg. Fine pose samples protect the known collision envelope.
  er={}
  for a in range(97):
   f=1+a*.5;pose(motion(f,soft))
   for n in ends:
    pig=bs[n];q=pig.rotation_euler.copy()
    if n in er:q.make_compatible(er[n])
    pig.rotation_euler=q;er[n]=q.copy()
    pig.keyframe_insert('rotation_euler',frame=f,group=n)
  for c in new.fcurves:
   for k in c.keyframe_points:k.interpolation='LINEAR'
  s['v77_cross_motion']='The standard knee-over-knee motion from the archived v74 +.12 BU neutral. Lift and extend first, then cross knee before hanging shoe, and hold. Original swivel and chair actions preserved inactive. Only left femur/shin/foot animated.'
  s['v77_original_chair_actions']=json.dumps(saved)
  s.frame_start=1;s.frame_end=49;s.frame_set(25);up()
  bpy.context.preferences.filepaths.save_version=0
  bpy.ops.wm.save_as_mainfile(filepath=str(P/'chair-knee-over-knee-v77-motion.blend'),compress=True)
  (P/'motion-raw-qa.json').write_text(json.dumps({'trimmed_route':seq,'tangent_tune':soft,'sample_frequency_frames':.25,'results':result},indent=2))
